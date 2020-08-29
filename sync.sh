#!/bin/bash
set -e

# Get output ip for the instance
INSTANCE_IP=$(./terraform.sh output instance_ip)

# Upload
ssh -oStrictHostKeyChecking=no "$INSTANCE_IP" "rm -rf ~/conf/"
scp -oStrictHostKeyChecking=no -r ./conf/ "$INSTANCE_IP:~/conf/"

# Execute
ssh -oStrictHostKeyChecking=no "$INSTANCE_IP" "~/conf/deploy-conf.sh"

# Update DNS
source ./secrets-macos.sh
URL="https://www.duckdns.org/update?domains=$DUCK_DNS_DOMAIN&token=$DUCK_DNS_TOKEN"
ssh -oStrictHostKeyChecking=no "$INSTANCE_IP" "curl -s '$URL'"

# Set auto shutdown in case we forget to turn it off
ssh -oStrictHostKeyChecking=no "$INSTANCE_IP" "sudo shutdown -P +120"
