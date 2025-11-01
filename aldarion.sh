# dhcp server

# no 2
apt update
apt install isc-dhcp-server -y

nano /etc/default/isc-dhcp-server
INTERFACESv4="eth0"

nano /etc/dhcp/dhcpd.conf
subnet 10.89.4.0 netmask 255.255.255.0 {
}

subnet 10.89.1.0 netmask 255.255.255.0 {
    range 10.89.1.6 10.89.1.34;
    range 10.89.1.68 10.89.1.94;
    option routers 10.89.1.1;
    option broadcast-address 10.89.1.255;
    # option domain-name "k51.com";
    option domain-name-servers 10.89.5.2;
    default-lease-time 600;
    max-lease-time 7200;
}

subnet 10.89.2.0 netmask 255.255.255.0 {
    range 10.89.2.35 10.89.2.67;
    range 10.89.2.96 10.89.2.121;
    option routers 10.89.2.1;
    option broadcast-address 10.89.2.255;
    # option domain-name "k51.com";
    option domain-name-servers 10.89.5.2;
    default-lease-time 600;
    max-lease-time 7200;
}

subnet 10.89.3.0 netmask 255.255.255.0 {
    option routers 10.89.3.1;
    option broadcast-address 10.89.3.255;
    # option domain-name "k51.com";
    option domain-name-servers 10.89.5.2;
    default-lease-time 600;
    max-lease-time 7200;
}
# fixed address untuk subnet 10.89.3.0/24
host khamul {
    hardware ethernet 02:42:eb:43:f3:00;
    fixed-address 10.89.3.95;
}

service isc-dhcp-server restart