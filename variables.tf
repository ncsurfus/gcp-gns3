variable "gcloud_credential_file" {
    description = "The gcloud credential json file."
}

variable "gcloud_state_bucket" {
    description = "The gcloud bucket to store the state in."
}

variable "gcloud_state_prefix" {
    description = "The prefix for the state file name."
}

variable "gcloud_project" {
    description = "The gcloud project name."
}

variable "gcloud_region" {
    description = "The gcloud region."
}

variable "gcloud_disk_selfLink" {
    description = "The persistent data storage's self link"
}

variable "duckdns_token" {
    description = "The duckdns.org API token."
}

variable "duckdns_domain" {
    description = "The duckdns.org domain to update."
}

variable "ssh_username" {
    description = "The username to use for SSH access."
}

variable "ssh_private_key" {
    description = "The SSH key used to connect to the vm, add files, and execute scripts."
}

variable "ssh_public_key" {
    description = "The SSH key used to connect to the vm, add files, and execute scripts."
}

variable "vpn_psk" {
    description = "The VPN pre-shared key."
}

variable "vpn_username" {
    description = "The VPN username."
}

variable "vpn_password" {
    description = "The VPN password."
}