# no 10
# reverse proxy load balancer 

apt update
apt install nginx -y
nano /etc/nginx/sites-available/reverse-proxy.conf
# upstream laravel {
#         server 10.0.2.2:8001;
#         server 10.0.2.3:8002;
#         server 10.0.2.4:8003;
# }

# server {
#         listen 80;
#         server_name k51.com;

#         location / {
#                 proxy_pass http://laravel;
#         }
# }

ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/
service nginx restart