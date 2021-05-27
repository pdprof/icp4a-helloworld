#!/bin/bash

# prereq : oc login is required to execuete this shell
#          mvn, ant program and shell PATH environment variable to execute it.
#          kubeadmin

binDir=`dirname ${0}`
${binDir}/help-kubeadmin.sh

$HOME/kubeadmin

oc registry login
docker login `oc registry info`

# pull websphere-traditional docker repository
# https://github.com/WASdev/ci.docker.websphere-traditional
WAS_VERSION=9.0.5.7
docker pull ibmcom/websphere-traditional:${WAS_VERSION}

cd websphere-traditional

docker tag ibmcom/websphere-traditional:${WAS_VERSION} $(oc registry info)/$(oc project -q)/websphere-traditional:${WAS_VERSION}

docker push $(oc registry info)/$(oc project -q)/websphere-traditional:${WAS_VERSION}
sed -i s/"\[was-version\]"/${WAS_VERSION}/g Dockerfile

sed -i s/image-registry.openshift-image-registry.svc:5000/default-route-openshift-image-registry.apps-crc.testing/g kubernetes.yaml
sed -i s/"\[project-name\]"/$(oc project -q)/g kubernetes.yaml
sed -i s/"\[was-version\]"/${WAS_VERSION}/g kubernetes.yaml

oc create secret generic docker-user-secret --from-file=.dockerconfigjson=$HOME/.docker/config.json --type=kubernetes.io/dockerconfigjson
oc apply -f kubernetes.yaml

