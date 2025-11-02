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
#     fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
#     }

# location ~ /\.ht {
#             deny all;
#     }

#     error_log /var/log/nginx/k51.com_error.log;
#     access_log /var/log/nginx/k51.com_access.log;
# }
ln -s /etc/nginx/sites-available/k51.com /etc/nginx/sites-enabled/
chown -R www-data:www-data /var/www/laravel-simple-rest-api/storage
service nginx restart



