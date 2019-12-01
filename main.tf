provider "google" {
  credentials = "${file(var.gcloud_credential_file)}"
  project     = "${var.gcloud_project}"
  region      = "${var.gcloud_region}"
  zone        = "us-central1-a"
}

data "google_compute_image" "ubuntu_1804_image" {
  family  = "ubuntu-minimal-1804-lts"
  project = "ubuntu-os-cloud"
}

resource "google_compute_disk" "ubuntu_1804_virt_disk" {
  name  = "ubuntu-1804-virt-disk"
  type  = "pd-standard"
  image = "${data.google_compute_image.ubuntu_1804_image.self_link}"
  size  = "10"
}

resource "google_compute_image" "ubuntu_1804_virt_image" {
  name        = "ubuntu-1804-virt-image"
  source_disk = "${google_compute_disk.ubuntu_1804_virt_disk.self_link}"

  licenses = [
    "https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx"
  ]

  lifecycle {
    ignore_changes = [
      "licenses"
    ]
  }
}

resource "google_compute_instance" "gns3_compute" {
  name             = "gns3-compute"
  machine_type     = "n1-standard-1"
  min_cpu_platform = "Intel Haswell"

  boot_disk {
    initialize_params {
      image = "${google_compute_image.ubuntu_1804_virt_image.self_link}"
      type  = "pd-standard"
      size  = "10"
    }
  }

  attached_disk {
    source = "${var.gcloud_disk_selfLink}"
  }

  metadata = {
    sshKeys = "${var.ssh_username}:${file(var.ssh_public_key)}"
  }

  network_interface {
    network = "default"
    access_config {
      // Leave empty, grants a ephemeral public ip
    }
  }

  connection {
    type        = "ssh"
    host        = "${self.network_interface.0.access_config.0.nat_ip}"
    user        = "${var.ssh_username}"
    private_key = "${file(var.ssh_private_key)}"
  }

  provisioner "file" {
    source      = "conf/"
    destination = "~/"
  }

  provisioner "remote-exec" {
    inline = [
      "curl 'https://www.duckdns.org/update?domains=${var.duckdns_domain}&token=${var.duckdns_token}'",
      "sleep 60",
      "sudo apt-get update",
      "sudo apt-get install -y --no-install-recommends docker.io",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo usermod -aG docker $USER",
      "echo 'VPN_PSK=${var.vpn_psk}' > .env",
      "echo 'VPN_USERNAME=${var.vpn_username}' >> .env",
      "echo 'VPN_PASSWORD=${var.vpn_password}' >> .env",
      "sudo mkdir -p /mnt/disks/data",
      "sudo mount -o discard,defaults /dev/sdb /mnt/disks/data",
      "sudo docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v \"$PWD:$PWD\" \\",
      "    -w=\"$PWD\" docker/compose:1.24.1 up -d"
    ]
  }

  provisioner "remote-exec" {
    when = "destroy"
    inline = [
      "sudo docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v \"$PWD:$PWD\" \\",
      "    -w=\"$PWD\" docker/compose:1.24.1 down"
    ]
  }
}

resource "google_compute_firewall" "ssh" {
  name    = "firewall-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "udp"
    ports    = ["500", "4500"]
  }

  source_ranges = ["0.0.0.0/0"]
}
