# no 4 
# dns master

apt update
apt install bind9 -y

nano /etc/bind/named.conf.local
zone "k51.com" {
    type master;
    notify yes;
    also-notify { 10.89.3.3; };
    allow-transfer { 10.89.3.3; };
    file "/etc/bind/k51.com";
};

nano /etc/bind/k51.com
# $TTL    604800          ; Waktu cache default (detik)
# @       IN      SOA     ns1.k51.com. root.k51.com. (
#                         2025100401 ; Serial (format YYYYMMDDXX)
#                         604800     ; Refresh (1 minggu)
#                         86400      ; Retry (1 hari)
#                         2419200    ; Expire (4 minggu)
#                         604800 )   ; Negative Cache TTL
# ;

# @         IN      NS      ns1.k51.com.
# @         IN      NS      ns2.k51.com.
# ns1       IN      A       10.89.3.2
# ns2       IN      A       10.89.3.3
# palantir  IN      A       10.89.4.3
# elros     IN      A       10.89.1.6
# pharazon  IN      A       10.89.2.6
# elendil   IN      A       10.89.1.2
# isildur   IN      A       10.89.1.3
# anarion   IN      A       10.89.1.4
# galadriel IN      A       10.89.2.4
# celeborn  IN      A       10.89.2.3
# oropher   IN      A       10.89.2.2

ln -s /etc/init.d/named /etc/init.d/bind9
service bind9 restart

# no 5
nano /etc/bind/k51.com
elros.k51.com.     IN      TXT     "Cincin Sauron"
pharazon.k51.com.  IN      TXT     "Aliansi Terakhir"
www       IN      CNAME   palantir.k51.com.

nano /etc/bind/named.conf.local
zone "3.89.10.in-addr.arpa" {
	type master;
    notify yes;
    also-notify { 10.89.3.3; };
    allow-transfer { 10.89.3.3; };
    file "/etc/bind/3.89.10.in-addr.arpa";
};

nano /etc/bind/3.89.10.in-addr.arpa
# $TTL    604800          ; Waktu cache default (detik)
# @       IN      SOA     k51.com. root.k51.com. (
#                         2025100401 ; Serial (format YYYYMMDDXX)
#                         604800     ; Refresh (1 minggu)
#                         86400      ; Retry (1 hari)
#                         2419200    ; Expire (4 minggu)
#                         604800 )   ; Negative Cache TTL
# ;

# 3.89.10.in-addr.arpa.       IN      NS      k51.com.
# 2       IN      PTR     ns1.k51.com.
# 3       IN      PTR     ns2.k51.com.
