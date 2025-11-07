# praktikum-komdat-jarkom-k51

| Nama   | NRP |
|--------|------|
| Ahmad Idza Anafin   | 5027241017   |
| Erlangga Valdhio Putra Sulistio   | 5027241030   |

# MODUL 3

## TOPOLOGI JARINGAN

<img width="1177" height="698" alt="image" src="https://github.com/user-attachments/assets/dcafed3a-a015-49bc-b78d-95f57b8d1b09" />


## KONFIGURASI JARINGAN

pada nomer 1 kita diminta untuk membuat topologi dan mengkonfigurasinya, pertama kita bikin topologinya.

<img width="1150" height="671" alt="image" src="https://github.com/user-attachments/assets/3d9d2d3f-d37a-427a-b338-908fb820dca6" />

Setelah kita bikin topologinya, kita konfigurasi setiap nodes yang ada pada jaringan kita

Konfirgurasi Durin
```
auto eth0
iface eth0 inet dhcp
    # 1. Mengaktifkan IP Forwarding
    post-up echo 1 > /proc/sys/net/ipv4/ip_forward
    # 2. Mengaktifkan NAT/Masquerade
    post-up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

auto eth1
iface eth1 inet static
    address 10.89.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 10.89.2.1
    netmask 255.255.255.0

auto eth3
iface eth3 inet static
    address 10.89.3.1
    netmask 255.255.255.0

auto eth4
iface eth4 inet static
    address 10.89.4.1
    netmask 255.255.255.0

auto eth5
iface eth5 inet static
    address 10.89.5.1
    netmask 255.255.255.0
```

Konfigurasi nodes lain
```
auto eth0
iface eth0 inet static
    address (sesuaikan dengan masing-masing nodes)
    netmask 255.255.255.0
    gateway (sesuaikan dengan masing-masing nodes)
 up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

Setelah kita konfigurasi kita coba test apakah jalan dengan cara `ping google.com` pada salah satu nodes

<img width="639" height="250" alt="image" src="https://github.com/user-attachments/assets/f0549cb3-6966-4526-b37b-558cdb84ba04" />

Dan yap! nomer 1 sudah selesai


## KONFIGURASI DHCP
pada no 2 diminta untuk melakukan konfigurasi DHCP agar client dynamic mendapatkan IP Address secara otomatis dari DHCP Server. Karena beberapa klient berada di jaringan yang berbeda, maka diperlukan DHCP Relay agar client dapat terhubung ke DHCP Server.

### KONFIGURASI DHCP SERVER (aldarion)
```
# dhcp server
# no 2 dan 3 dan 6
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
    max-lease-time 3600;
}

subnet 10.89.2.0 netmask 255.255.255.0 {
    range 10.89.2.35 10.89.2.67;
    range 10.89.2.96 10.89.2.121;
    option routers 10.89.2.1;
    option broadcast-address 10.89.2.255;
    # option domain-name "k51.com";
    option domain-name-servers 10.89.5.2;
    default-lease-time 1800;
    max-lease-time 3600;
}

subnet 10.89.3.0 netmask 255.255.255.0 {
    option routers 10.89.3.1;
    option broadcast-address 10.89.3.255;
    # option domain-name "k51.com";
    option domain-name-servers 10.89.5.2;
    default-lease-time 600;
    max-lease-time 3600;
}
# fixed address untuk subnet 10.89.3.0/24
host khamul {
    hardware ethernet 02:42:eb:43:f3:00;
    fixed-address 10.89.3.95;
}

service isc-dhcp-server restart
```


### KONFIGURASI DHCP RELAY (durin)
```
apt update
apt install isc-dhcp-relay -y

nano /etc/default/isc-dhcp-relay
SERVERS="10.89.4.2"
INTERFACES="eth1 eth2 eth3 eth4"
OPTIONS=""

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

sysctl -p
service isc-dhcp-relay restart
```


### PENGUJIAN
<img width="894" height="234" alt="image" src="https://github.com/user-attachments/assets/3aee97ed-5f9a-4c0b-b578-bdd735978e9f" />

<img width="907" height="226" alt="image" src="https://github.com/user-attachments/assets/ea47a475-b397-4982-a8a4-ddb0f827197a" />

<img width="919" height="227" alt="image" src="https://github.com/user-attachments/assets/a56e645c-d947-4e84-9952-461297454328" />


## KONFIGURASI DNS 

### KONFIGURASI DNS FORWARDER (minastir)
```
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
```

<img width="498" height="75" alt="image" src="https://github.com/user-attachments/assets/520658af-1a56-4d4f-a073-eb9af516c29e" />

<img width="734" height="112" alt="image" src="https://github.com/user-attachments/assets/cff2db3a-df23-4083-b8a6-5ae94eb95e0b" />

<img width="541" height="94" alt="image" src="https://github.com/user-attachments/assets/7e46f0db-a5b3-4908-b2bb-92cf4221ce0c" />

<img width="1053" height="471" alt="image" src="https://github.com/user-attachments/assets/9db52242-8dd1-45f8-b215-c95c3a997ce7" />


### KONFIGURASI DNS SERVER (erendis)
```
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
www       IN      CNAME   palantir.k51.com.
elros.k51.com.     IN      TXT     "Cincin Sauron"
pharazon.k51.com.  IN      TXT     "Aliansi Terakhir"

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
# 2       IN      PTR     erendis.k51.com.
# 3       IN      PTR     amdir.k51.com.
```

### KONFIGURASI DNS SLAVE (amdir)
```
apt update
apt install bind9 -y

nano /etc/bind/named.conf.local
# zone "k51.com" {
#     type slave;
#     masters { 10.89.3.2; };
#     file "/etc/bind/k51.com";
# };

#no 5
nano /etc/bind/named.conf.local
# zone "3.89.10.in-addr.arpa" {
# 	type slave;
#   masters { 10.89.3.2; };
# 	file "/etc/bind/3.89.10.in-addr.arpa";
# };


ln -s /etc/init.d/named /etc/init.d/bind9
service bind9 restart
```

### PENGUJIAN
<img width="898" height="631" alt="image" src="https://github.com/user-attachments/assets/e877cb4b-17a0-45eb-87fb-86ffd84111f7" />

<img width="956" height="582" alt="image" src="https://github.com/user-attachments/assets/2497b1cc-e259-4242-add4-76c40a224e3f" />

<img width="933" height="617" alt="image" src="https://github.com/user-attachments/assets/dd31a16d-9034-44e7-848e-6d315f4e783e" />

<img width="916" height="516" alt="image" src="https://github.com/user-attachments/assets/51003aae-3e5a-47ec-bf31-36ab1d517159" />



## KONFIGURASI WORKER

### KONFIGURASI WORKER 1 (elendir)
```
# no 7
# install php8.4 laravel nginx composer

apt update
apt install -y lsb-release apt-transport-https ca-certificates wget
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
apt update
apt install php8.4-mbstring php8.4-xml php8.4-cli php8.4-common php8.4-intl php8.4-opcache php8.4-readline php8.4-mysql php8.4-fpm php8.4-curl unzip wget -y
apt install nginx -y
wget https://getcomposer.org/download/2.0.13/composer.phar
chmod +x composer.phar
mv composer.phar /usr/bin/composer

apt install git -y
cd /var/www/
git clone https://github.com/elshiraphine/laravel-simple-rest-api.git
cd laravel-simple-rest-api
composer install


# no 8
apt install mariadb-client -y
cp .env.example .env
# ganti db host
# user=worker
# password=123
# database=laravel
php artisan migrate:fresh
php artisan db:seed --class=AiringsTableSeeder
php artisan key:generate

# nginx config
nano /etc/nginx/sites-available/k51.com
# server {

#     listen 8001;

#     root /var/www/laravel-simple-rest-api/public;

#     index index.php index.html index.htm;
#     server_name _;

#     location / {
#             try_files $uri $uri/ /index.php?$query_string;
#     }

#     # pass PHP scripts to FastCGI server
#     location ~ \.php$ {
#     include snippets/fastcgi-php.conf;
#     fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
#     }

# location ~ /\.ht {
#             deny all;
#     }

#     error_log /var/log/nginx/k51.com_error.log;
#     access_log /var/log/nginx/k51.com_access.log;
# }

# block ip request
nano /etc/nginx/sites-enabled/default
server {
    listen 8001 default_server;
    listen [::]:8001 default_server;

    server_name _;

    return 444;
}

ln -s /etc/nginx/sites-available/k51.com /etc/nginx/sites-enabled/
chown -R www-data:www-data /var/www/laravel-simple-rest-api/storage
service php8.4-fpm start
service nginx restart
```

### KONFIGURASI WORKER 2 (isildur)
```
# no 7
# install php8.4 laravel nginx composer

apt update
apt install -y lsb-release apt-transport-https ca-certificates wget
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
apt update
apt install php8.4-mbstring php8.4-xml php8.4-cli php8.4-common php8.4-intl php8.4-opcache php8.4-readline php8.4-mysql php8.4-fpm php8.4-curl unzip wget -y
apt install nginx -y
wget https://getcomposer.org/download/2.0.13/composer.phar
chmod +x composer.phar
mv composer.phar /usr/bin/composer

apt install git -y
cd /var/www/
git clone https://github.com/elshiraphine/laravel-simple-rest-api.git
cd laravel-simple-rest-api
composer install

# no 8
apt install mariadb-client -y
cp .env.example .env
# ganti db host
# nginx config
nano /etc/nginx/sites-available/k51.com
# server {

#     listen 8002;

#     root /var/www/laravel-simple-rest-api/public;

#     index index.php index.html index.htm;
#     server_name _;

#     location / {
#             try_files $uri $uri/ /index.php?$query_string;
#     }

#     # pass PHP scripts to FastCGI server
#     location ~ \.php$ {
#     include snippets/fastcgi-php.conf;
#     fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
#     }

# location ~ /\.ht {
#             deny all;
#     }

#     error_log /var/log/nginx/k51.com_error.log;
#     access_log /var/log/nginx/k51.com_access.log;
# }

# block ip request
nano /etc/nginx/sites-enabled/default
server {
    listen 8002 default_server;
    listen [::]:8002 default_server;

    server_name _;

    return 444;
}

ln -s /etc/nginx/sites-available/k51.com /etc/nginx/sites-enabled/
chown -R www-data:www-data /var/www/laravel-simple-rest-api/storage
service php8.4-fpm start
service nginx restart
```

### KONFIGURASI WORKER 3 (anarion)
```
# no 7
# install php8.4 laravel nginx composer

apt update
apt install -y lsb-release apt-transport-https ca-certificates wget
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
apt update
apt install php8.4-mbstring php8.4-xml php8.4-cli php8.4-common php8.4-intl php8.4-opcache php8.4-readline php8.4-mysql php8.4-fpm php8.4-curl unzip wget -y
apt install nginx -y
wget https://getcomposer.org/download/2.0.13/composer.phar
chmod +x composer.phar
mv composer.phar /usr/bin/composer

apt install git -y
cd /var/www/
git clone https://github.com/elshiraphine/laravel-simple-rest-api.git
cd laravel-simple-rest-api
composer install

# no 8
apt install mariadb-client -y
cp .env.example .env
# ganti db host
# nginx config
nano /etc/nginx/sites-available/k51.com
# server {

#     listen 8003;

#     root /var/www/laravel-simple-rest-api/public;

#     index index.php index.html index.htm;
#     server_name _;

#     location / {
#             try_files $uri $uri/ /index.php?$query_string;
#     }

#     # pass PHP scripts to FastCGI server
#     location ~ \.php$ {
#     include snippets/fastcgi-php.conf;
#     fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
#     }

# location ~ /\.ht {
#             deny all;
#     }

#     error_log /var/log/nginx/k51.com_error.log;
#     access_log /var/log/nginx/k51.com_access.log;
# }

# block ip request
nano /etc/nginx/sites-enabled/default
server {
    listen 8003 default_server;
    listen [::]:8003 default_server;

    server_name _;

    return 444;
}

s
ln -s /etc/nginx/sites-available/k51.com /etc/nginx/sites-enabled/
chown -R www-data:www-data /var/www/laravel-simple-rest-api/storage
service php8.4-fpm start
service nginx restart
```

### PENGUJIAN

<img width="1055" height="547" alt="image" src="https://github.com/user-attachments/assets/ea1dd5db-7f3a-48b9-8af3-fea718b3691a" />

<img width="1046" height="405" alt="image" src="https://github.com/user-attachments/assets/eb9758fe-df52-4bd9-bea1-87cb46beec4b" />


## KONFIGURASI DATABASE SERVER (palantir)
```
# no 8
# database server
apt update
apt install mariadb-server -y
service mariadb start
nano /etc/mysql/mariadb.conf.d/50-server.cnf
# [mysqld]
# skip-networking=0
# skip-bind-address
# bind-address=0.0.0.0

mysql
CREATE USER 'worker'@'10.89.1.%' IDENTIFIED BY '123';
GRANT ALL PRIVILEGES ON *.* TO 'worker'@'10.89.1.%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
# bikin database
CREATE DATABASE laravel;
EXIT;

service mariadb restart
```




