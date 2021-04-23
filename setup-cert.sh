#!/bin/bash

#required text file
# kubeadmin : shell script to login openshift 

binDir=`dirname ${0}`
${binDir}/help-kubeadmin.sh

$HOME/kubeadmin

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
