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