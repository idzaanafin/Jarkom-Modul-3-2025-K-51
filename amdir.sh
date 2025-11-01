# NO 4
apt update
apt install bind9 -y

nano /etc/bind/named.conf.local
# zone "k51.com" {
#     type slave;
#     masters { 10.89.3.2; };
#     file "/etc/bind/k51.com";
# };

nano /etc/bind/named.conf.local
# zone "3.89.10.in-addr.arpa" {
# 	type slave;
#   masters { 10.89.3.2; };
# 	file "/etc/bind/3.89.10.in-addr.arpa";
# };


ln -s /etc/init.d/named /etc/init.d/bind9
service bind9 restart