#!/bin/bash
cd ~/conf/

# Install docker
dpkg -s docker.io > /dev/null
if [ $? -gt 0 ]; then
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends docker.io
  sudo usermod -aG docker $USER
fi

# Format drive
# https://devopscube.com/mount-extra-disks-on-google-cloud/
DRIVE="/dev/sdb"
lsblk -f "$DRIVE" | grep ext4 > /dev/null
if [ $? -gt 0 ]; then
  sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard "$DRIVE"
  sudo cp /etc/fstab /etc/fstab.backup
  UUID=$(sudo blkid -s UUID -o value $DRIVE)
  echo "UUID=$UUID /mnt/disks/data ext4 discard,defaults,nofail 0 2" | sudo tee -a /etc/fstab
fi

# Mount filesystem
df "$DRIVE" | grep /mnt/disks/data > /dev/null
if [ $? -gt 0 ]; then 
  sudo mkdir -p /mnt/disks/data
  sudo mount -a
fi

# Start container
sudo ~/conf/docker-compose up -d
