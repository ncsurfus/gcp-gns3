FROM hwdsl2/ipsec-vpn-server

## Create a GNS3 IP Address in the same subnet as the VPN users
## This means the VPN client doesn't need any additional routes.
RUN sed -i '/^# Create IPTables rules/a iptables -t nat -A PREROUTING -d 192.168.42.3 -j DNAT \
    --to-destination 172.28.1.1' /opt/src/run.sh