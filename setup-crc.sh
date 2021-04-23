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
if [ ! -e $HOME/pull-secret.txt ]; then 
     echo ""
     echo "Please get image pull secret of OpenShift and copy it as $HOME/pull-secret.txt"
     echo ""
     exit 1
fi
cat $HOME/pull-secret.txt
echo "Copy pull secret above"

crc start

echo ""
echo "Add oc login command as kubeadmin user to $HOME/kubeadmin shell script"
echo "Command example is 'oc login -u kubeadmin -p XXXXXXXXX https://api.crc.testing:6443'" 
echo ""

if [ ! -e $HOME/kubeadmin ]; then
    echo "#!/bin/bash" > $HOME/kubeadmin
    chmod 755 $HOME/kubeadmin
fi
