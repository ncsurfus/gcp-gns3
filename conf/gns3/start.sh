#!/bin/sh
/linux_amd64_goioulic | sed -n '2,3p' > /data/.iourc
dockerd --storage-driver=vfs &
exec gns3server -A --config /config.ini