# konfigurasi dhcp-relay untuk router(durin)

#  no 2
apt update
apt install isc-dhcp-relay -y

nano /etc/default/isc-dhcp-relay
# SERVERS="10.89.4.2"
# INTERFACES="eth1 eth2 eth3 eth4"
# OPTIONS=""

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

sysctl -p
service isc-dhcp-relay restart


# no 3
# gatau ini pake iptables ga


