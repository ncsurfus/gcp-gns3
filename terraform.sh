#!/bin/bash

# Load secrets
source ./secrets-macos.sh

# Set variables
export TF_VAR_full_access="$(curl -s ifconfig.me)/32"
export TF_VAR_ssh_username=$USER
export TF_VAR_gcloud_region="us-central1-a"

# Run terraform
cd infrastructure
terraform $*
