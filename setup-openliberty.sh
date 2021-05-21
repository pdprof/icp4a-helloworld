#!/bin/bash

# prereq : oc login is required to execuete this shell
#          mvn, ant program and shell PATH environment variable to execute it.
#          kubeadmin

binDir=`dirname ${0}`
${binDir}/help-kubeadmin.sh

$HOME/kubeadmin

oc registry login
docker login `oc registry info`

# change directory to root directry to clone git
cd ..
git clone https://github.com/openliberty/guide-cloud-openshift.git
cd guide-cloud-openshift/start

# setup mvn and ant 
#

/opt/mvn/bin/mvn package

# pull openliberty docker repository
docker pull openliberty/open-liberty:kernel-java8-openj9-ubi

docker build -t system:1.0-SNAPSHOT system/.
docker build -t inventory:1.0-SNAPSHOT inventory/.

docker tag system:1.0-SNAPSHOT $(oc registry info)/$(oc project -q)/system:1.0-SNAPSHOT
docker tag inventory:1.0-SNAPSHOT $(oc registry info)/$(oc project -q)/inventory:1.0-SNAPSHOT

docker push $(oc registry info)/$(oc project -q)/system:1.0-SNAPSHOT
docker push $(oc registry info)/$(oc project -q)/inventory:1.0-SNAPSHOT

sed -i s/image-registry.openshift-image-registry.svc:5000/default-route-openshift-image-registry.apps-crc.testing/g kubernetes.yaml
sed -i s/"\[project-name\]"/$(oc project -q)/g kubernetes.yaml
sed -i s/"- containerPort: 9080"/"- containerPort: 9080\n      imagePullSecrets:\n      - name: docker-user-secret"/g kubernetes.yaml

oc create secret generic docker-user-secret --from-file=.dockerconfigjson=$HOME/.docker/config.json --type=kubernetes.io/dockerconfigjson
oc apply -f kubernetes.yaml

