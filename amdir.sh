# NO 4
apt update
apt install bind9 -y

nano /etc/bind/named.conf.local
# zone "k51.com" {
#     type slave;
#     masters { 10.89.3.2; };
#     file "/etc/bind/k51.com";
# };

ln -s /etc/init.d/named /etc/init.d/bind9
service bind9 restart