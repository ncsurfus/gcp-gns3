provider "google" {
  project = var.gcloud_project
  region  = var.gcloud_region
}

data "google_compute_image" "ubuntu_1804_image" {
  family  = "ubuntu-minimal-1804-lts"
  project = "ubuntu-os-cloud"
}

resource "google_compute_disk" "ubuntu_1804_virt_disk" {
  name  = "ubuntu-1804-virt-disk"
  type  = "pd-standard"
  image = data.google_compute_image.ubuntu_1804_image.self_link
  size  = "10"
}

resource "google_compute_disk" "gns3_storage" {
  name            = "gns3-storage"
  type            = "pd-standard"
  size            = 30
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_compute_image" "ubuntu_1804_virt_image" {
  name        = "ubuntu-1804-virt-image"
  source_disk = google_compute_disk.ubuntu_1804_virt_disk.self_link

  licenses = [
    "https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx"
  ]

  lifecycle {
    ignore_changes = [licenses]
  }
}

resource "google_compute_instance" "gns3_compute" {
  name                      = "gns3-compute"
  machine_type              = "n1-standard-2"
  min_cpu_platform          = "Intel Skylake"
  allow_stopping_for_update = true
  desired_status            = var.instance_state

  boot_disk {
    initialize_params {
      image = google_compute_image.ubuntu_1804_virt_image.self_link
      type  = "pd-standard"
      size  = "10"
    }
  }

  attached_disk {
    source = google_compute_disk.gns3_storage.self_link
  }

  scheduling {
    preemptible       = false
    automatic_restart = false
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
}

output "instance_ip" {
  value = google_compute_instance.gns3_compute.network_interface.0.access_config.0.nat_ip
}

resource "google_compute_firewall" "local" {
  name    = "local"
  network = "default"

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  source_ranges = [var.full_access]
}
