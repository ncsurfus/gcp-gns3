#!/bin/bash
set -e

./terraform.sh apply --auto-approve -var='instance_state=TERMINATED'
