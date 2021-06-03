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
sed -i s/"\[crc-ip\]"/$(crc ip)/g host-nginx/server.conf
sudo cp host-nginx/server.conf /etc/nginx/conf.d/

# Enable and start nginx 
sudo systemctl enable nginx
sudo systemctl start nginx
