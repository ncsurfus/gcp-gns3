#!/bin/bash
set -e

echo "Waiting for SSH..."
until ./ssh.sh "hostname"
do
  echo "Retrying..."
  sleep 1;
done

echo -e "\nSetting Auto-Shutdown..."
./ssh.sh "sudo shutdown -P +120"

echo -e "\nUploading Configuration..."
./ssh.sh "rm -rf ~/conf/"
INSTANCE_IP=$(./terraform.sh output instance_ip)
scp -oStrictHostKeyChecking=no -r ./conf/ "$INSTANCE_IP:~/conf/"

echo -e "\nExecuting Deploy..."
./ssh.sh "~/conf/deploy-conf.sh"

echo -e "\nUpdating DNS.."
source ./secrets-macos.sh
./ssh.sh "curl -s 'https://www.duckdns.org/update?domains=$DUCK_DNS_DOMAIN&token=$DUCK_DNS_TOKEN'"

echo -e "\n\nCompleted!"
