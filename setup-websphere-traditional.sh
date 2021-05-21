#!/bin/bash

# prereq : oc login is required to execuete this shell
#          mvn, ant program and shell PATH environment variable to execute it.
#          kubeadmin

binDir=`dirname ${0}`
${binDir}/help-kubeadmin.sh

$HOME/kubeadmin

oc registry login
docker login `oc registry info`

# pull openliberty docker repository
WAS_VERSION=9.0.5.7
docker pull ibmcom/websphere-traditional:${WAS_VERSION}

docker tag websphere-traditional:${WAS_VERSION} $(oc registry info)/$(oc project -q)/websphere-traditional:${WAS_VERSION}

docker push $(oc registry info)/$(oc project -q)/websphere-traditional:${WAS_VERSION}

sed -i s/image-registry.openshift-image-registry.svc:5000/default-route-openshift-image-registry.apps-crc.testing/g twas-kubernetes.yaml
sed -i s/"\[project-name\]"/$(oc project -q)/g twas-kubernetes.yaml
sed -i s/"\[was-version\]"/${WAS_VERSION}/g twas-kubernetes.yaml

oc create secret generic docker-user-secret --from-file=.dockerconfigjson=$HOME/.docker/config.json --type=kubernetes.io/dockerconfigjson
oc apply -f kubernetes.yaml

