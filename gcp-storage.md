# Steps to initialize GCP Storage
See https://devopscube.com/mount-extra-disks-on-google-cloud/
- sudo lsblk
- sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb
- sudo mkdir -p /data
- sudo mount -o discard,defaults /dev/sdb /data
- sudo cp /etc/fstab /etc/fstab.backup
- echo UUID=`sudo blkid -s UUID -o value /dev/sdb` /data ext4 discard,defaults,nofail  2 | sudo tee -a /etc/fstab