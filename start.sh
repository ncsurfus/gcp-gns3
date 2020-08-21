#!/bin/bash
set -e

# Terraform handles infrastructure
./terraform.sh init
./terraform.sh apply --auto-approve -var="instance_state=RUNNING"

# Sync packages
./sync.sh
