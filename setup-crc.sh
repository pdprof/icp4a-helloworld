#!/bin/bash

#required text file
# pull-secret.txt : secret to pull image from redhat

#create text file
# kubeadmin : shell script to login openshift 

#ToDo
# prereq environment : sudo, docker priviledges and dns networking 
#                      shell environment variables are required to execute crc and oc.

crc -f delete
crc setup
cat /home/test/pull-secret.txt
echo "\nCopy pull secret above"

crc start

echo "\nCopy kubeadmin password and developer password as kubeadmin"

cat /home/test/kubeadmin


openssl s_client -connect default-route-openshift-image-registry.apps-crc.testing:443 -showcerts < /dev/null | sed -n -e "/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/p" > ca.crt
sudo cp ca.crt /etc/pki/ca-trust/source/anchors/image-registry.crt
sudo update-ca-trust extract
sudo openssl verify /etc/pki/ca-trust/source/anchors/image-registry.crt
sudo systemctl restart docker

scp -i ~/.crc/machines/crc/id_rsa -o StrictHostKeyChecking=no ca.crt core@`crc ip`:ca.crt
ssh -i ~/.crc/machines/crc/id_rsa -o StrictHostKeyChecking=no core@`crc ip` sudo cp ca.crt /etc/pki/ca-trust/source/anchors/image-registry.crt
ssh -i ~/.crc/machines/crc/id_rsa -o StrictHostKeyChecking=no core@`crc ip` sudo update-ca-trust extract
ssh -i ~/.crc/machines/crc/id_rsa -o StrictHostKeyChecking=no core@`crc ip` sudo openssl verify /etc/pki/ca-trust/source/anchors/image-registry.crt
ssh -i ~/.crc/machines/crc/id_rsa -o StrictHostKeyChecking=no core@`crc ip` sudo systemctl restart crio
ssh -i ~/.crc/machines/crc/id_rsa -o StrictHostKeyChecking=no core@`crc ip` sudo systemctl restart kubelet
