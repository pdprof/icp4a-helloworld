#!/bin/bash

if [ ! $(grep oc $HOME/kubeadmin | wc -l) -eq 1 ]; then
     echo ""
     echo "Add oc login command as kubeadmin user to $HOME/kubeadmin shell script"
     echo "Command example is 'oc login -u kubeadmin -p XXXXXXXXX https://api.crc.testing:6443'" 
     echo ""
     exit 1
fi
