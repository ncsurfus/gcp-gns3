#!/bin/bash

# Load secrets
source ./secrets-macos.sh

# Set variables
export TF_VAR_full_access="$(curl -s ifconfig.me)/32"
export TF_VAR_ssh_username=$USER
export TF_VAR_gcloud_region="us-central1-a"
export TF_VAR_gcloud_disk_selfLink="https://www.googleapis.com/compute/v1/projects/\
$TF_VAR_gcloud_project/zones/$TF_VAR_gcloud_region/disks/gns3-data"

# Run terraform
cd infrastructure
terraform $*
