variable "gcloud_project" {
    description = "The gcloud project name."
}

variable "gcloud_region" {
    description = "The gcloud region."
}

variable "gcloud_disk_selfLink" {
    description = "The persistent data storage's self link"
}

variable "ssh_username" {
    description = "The username to use for SSH access."
}

variable "ssh_private_key" {
    description = "The SSH key used to connect to the vm, add files, and execute scripts."
    default = "~/.ssh/id_rsa"
}

variable "ssh_public_key" {
    description = "The SSH key used to connect to the vm, add files, and execute scripts."
    default = "~/.ssh/id_rsa.pub"
}

variable "full_access" {
    description = "An IP address that will be allowed full access."
}

variable "instance_state" {
    description = "The expected status of the instance."
}