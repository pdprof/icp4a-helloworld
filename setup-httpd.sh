#!/bin/bash


#ToDo
# prereq environment : sudo, httpd, mod_ssl
#                      shell environment variables are required to execute crc and oc.
flag=`rpm -qa | grep httpd | wc -l`
if [ $flag -lt 1 ]; then 
     echo ""
     echo "Please install httpd with command yum -y install httpd"
     echo ""
     exit 1
fi

flag=`rpm -qa | grep mod_ssl | wc -l`
if [ $flag -lt 1 ]; then
     echo ""
     echo "Please install mod_ssl with command yum -y install mod_ssl"
     echo ""
     exit 1
fi



# Copy reverse proxy setting to host
cd host-httpd
sed -i s/"\[crc-ip\]"/$(crc ip)/g proxy.conf
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

sudo cp proxy.conf ssl.conf ssl.key ssl.crt /etc/httpd/conf.d/

# Enable and start nginx 
sudo systemctl enable httpd
sudo systemctl restart httpd
