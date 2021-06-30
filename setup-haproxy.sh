#!/bin/bash
# Reference : https://access.redhat.com/documentation/en-us/red_hat_codeready_containers/1.23/html/getting_started_guide/networking_gsg#setting-up-remote-server_gsg


#ToDo
# prereq environment : sudo, haproxy
#                      shell environment variables are required to execute crc and oc.
flag=`rpm -qa | grep haproxy | wc -l`
if [ $flag -lt 1 ]; then 
     echo ""
     echo "Please install haproxy with command yum -y install haproxy policycoreutils-python-utils jq"
     echo ""
     exit 1
fi

flag=`rpm -qa | grep policycoreutils-python | wc -l`
if [ $flag -lt 1 ]; then
     echo ""
     echo "Please install python-utils with command yum -y install haproxy policycoreutils-python jq"
     echo ""
     exit 1
fi

# Configure firewall
sudo systemctl start firewalld
sudo firewall-cmd --add-port=80/tcp --permanent
sudo firewall-cmd --add-port=6443/tcp --permanent
sudo firewall-cmd --add-port=443/tcp --permanent
sudo systemctl restart firewalld

sudo semanage port -a -t http_port_t -p tcp 6443

# Copy setting to host
cd host-haproxy
sed -i s/"\[crc-ip\]"/$(crc ip)/g haproxy.cfg

sudo mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bak
sudo cp haproxy.cfg /etc/haproxy/

# Enable and start nginx 
sudo systemctl enable haproxy
sudo systemctl restart haproxy
