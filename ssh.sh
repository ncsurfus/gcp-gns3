#!/bin/bash
set -e

INSTANCE_IP=$(./terraform.sh output instance_ip)
ssh -oStrictHostKeyChecking=no "$INSTANCE_IP" $*
