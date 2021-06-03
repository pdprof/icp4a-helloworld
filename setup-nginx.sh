#!/bin/bash


#ToDo
# prereq environment : sudo, nginx 
#                      shell environment variables are required to execute crc and oc.
flag=`rpm -qa | grep nginx | wc -l`

if [ $flag -lt 1 ]; then 
     echo ""
     echo "Please install nginx with command yum -y install nginx"
     echo ""
     exit 1
fi

# Copy reverse proxy setting to host
cd host-nginx
sed -i s/"\[crc-ip\]"/$(crc ip)/g server.conf
sed -i s/"\[crc-ip\]"/$(crc ip)/g ssl.conf

echo "================"
echo ""
echo "Input password for ssl key"
echo ""
echo "================"
openssl req -x509 -newkey rsa:4096 -keyout ssl-pass.key -out ssl.crt -days 3650 -subj '/CN=*.apps-crc.testing'
echo "================"
echo ""
echo "Input password for ssl key, again to remove password from ssl key"
echo ""
echo "================"
openssl rsa -in ssl-pass.key -out ssl.key

sudo cp server.conf ssl.conf ssl.key ssl.crt /etc/nginx/conf.d/

# Enable and start nginx 
sudo systemctl enable nginx
sudo systemctl restart nginx
