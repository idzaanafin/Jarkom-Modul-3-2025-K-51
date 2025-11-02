# no 8
# database server
apt update
apt install mariadb-server -y
service mariadb start
nano /etc/mysql/my.cnf
# [mysqld]
# skip-networking=0
# skip-bind-address

service mariadb restart