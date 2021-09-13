# Setup CRC and install openliberty docker image.

## Before begin.

### Add your user as a member of dockerroot and wheel group

command sample Example 
```
yum -y install docker
su - 
adduser test
usermod -a -G docker test
usermod -a -G dockerroot test
usermod -a -G wheel test 
```

To check the result

```
cat /etc/group
dockerroot:x:981:test
```


### Download CodeReady Container

1. Download CRC and setup PATH

```
curl -O https://mirror.openshift.com/pub/openshift-v4/clients/crc/latest/crc-linux-amd64.tar.xz 
xz -d crc-linux-amd64.tar.xz 
tar xvf crc-linux-amd64.tar
ln -fs ./crc-linux-1.20.0-amd64/crc /usr/local/bin/crc
```

2. Check your PATH
```
which crc
```

If you can not find crc with above command. Please check crc's PATH at step1 and permissions with following commands.
```
ls -al ./crc-linux*
ls -al /usr/local/bin
echo $PATH
```

### Get image pull secret of openshift

1. Access to following URL
image pull secret
https://developers.redhat.com/products/codeready-containers/overview
Click > Install OpenShift on your laptop

2. Copy pull secret

3. Paste it to file ~/pull-secret.txt 

## Setup CRC

### Start CRC and Deploy liberty

```
./setup-crc.sh
sudo ln -fs ~/.crc/bin/oc/oc /usr/local/bin/oc
vi $HOME/kubeadmin
./setup-cert.sh
./setup-openliberty.sh
```

In this step, you need to update kubeadmin shell script to login openshift.

setup-openlibery.sh is based on 
[Deploying microservices to OpenShift](https://openliberty.io/guides/cloud-openshift.html#pushing-the-images-to-openshifts-internal-registry)

You can access to liberty through following links.

[system](http://system-route-default.apps-crc.testing/system/properties/)

[inventory](http://inventory-route-default.apps-crc.testing/inventory/systems)


### Delploy websphere-traditional

You can issue ./setup-webphere-traditional.sh script instead of setup-openliberty.sh

```
./setup-websphere-traditional.sh
```

You can access to admin console through following links.

[console](http://twas-admin-route-default.apps-crc.testing/ibm/console)


## Setup client access (If it is needed)

### Start haproxy, httpd or nginx on HOST

- Option.1
Setup haproxy (tcp proxy)
```
./setup-haproxy.sh
```

- Option.2
Setup forward proxy and reverse proxy
```
./setup-httpd.sh
```

- Option.3
Use reverse proxy
```
./setup-nginx.sh
```

- Setup firewall

Please allow access to http and https.
```
firewall-cmd --permanent --zone=public --add-service=http 
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload
```

### Configure browser to use forward proxy 

If you change the proxy setting when you want to use CRC. That's the simple solution.


### Configure hosts file or DNS to use reverse proxy 

- hosts 

add required host name to /etc/hosts

Edit your /etc/hosts (file path and name depends on client OS)

Example.. If VM host ip is 192.168.10.25
```
192.168.10.25 system-route-default.apps-crc.testing
```
Please change IP address and hostname with your configuration.

- dnsmasq
Detail DNS setup is described at RedHat document.
https://access.redhat.com/documentation/en-us/red_hat_codeready_containers/1.23/html/getting_started_guide/networking_gsg#setting-up-remote-server_gsg
