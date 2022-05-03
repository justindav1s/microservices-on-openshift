#!/bin/bash


PROJECT=tekton-test


echo Deleting $PROJECT
oc delete project $PROJECT
echo Creating $PROJECT
oc new-project $PROJECT 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
oc new-project $PROJECT 2> /dev/null
done

# oc apply -f git-clone-build.yaml
oc apply -f bash.yaml
oc apply -f git-clone.yaml
oc apply -f git-clone-build.yaml

tkn pipeline start git-clone \
    -w name=shared-workspace,volumeClaimTemplateFile=pvc.yaml \
    -p deployment-name=test \
    -p git-url=https://github.com/justindav1s/microservices-on-openshift.git \
    -p git-revision=master \
    -p command='ls -ltr' \
    --use-param-defaults \
    --showlog 


tkn pipeline start git-clone-build \
    -w name=shared-workspace,volumeClaimTemplateFile=pvc.yaml \
    -p deployment-name=pipeline-test \
    -p git-url=https://github.com/justindav1s/microservices-on-openshift.git \
    -p APP_PROFILE='' \
    -p CONTEXT_DIR='src/inventory' \
    -p command='ls -ltr' \
    --use-param-defaults \
    --showlog
