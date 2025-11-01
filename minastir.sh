# dns forwarder

apt update
apt install bind9 -y

nano /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";
    dnssec-validation auto;
    forwarders {
        192.168.122.1;        
    };
    allow-query { any; };
    auth-nxdomain no;
    listen-on-v6 { any; };
};

ln -s /etc/init.d/named /etc/init.d/bind9
service bind9 restart