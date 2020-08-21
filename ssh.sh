#!/bin/bash
set -e

instance_ip=$(./terraform.sh output instance_ip)
ssh -oStrictHostKeyChecking=no $instance_ip
