# Setup CRC and install openliberty docker image.

## Before begin.

### Add your user as a member of docker and wheel group

command sample Example 
```
su - 
adduser test
usermod -a -G docker test
usermod -a -G wheel test 
```

To check the result

```
cat /etc/group
docker:x:981:test
```


### Download CodeReady Container

1. Download CRC and setup PATH

```
curl -O https://mirror.openshift.com/pub/openshift-v4/clients/crc/latest/crc-linux-amd64.tar.xz 
xz -d crc-linux-amd64.tar.xz 
tar tvf crc-linux-amd64.tar
ln -fs ./crc-linux-1.20.0-amd64/crc /usr/local/bin/crc
ln -fs ~/.crc/bin/oc/oc /usr/local/bin/oc
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


### Start CRC and Deploy liberty

```
./setup-crc.sh
vi $HOME/kubeadmin
./setup-cert.sh
./setup-openliberty.sh
```

In this step, you need to update kubeadmin shell script to login openshift.

### Delploy websphere-traditional

You can issue ./setup-webphere-traditional.sh script instead of setup-openliberty.sh

```
./setup-websphere-traditional.sh
```
