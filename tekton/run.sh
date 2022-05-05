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

oc create secret docker-registry quay-dockercfg \
  --docker-server=${QUAYIO_HOST} \
  --docker-username=${QUAYIO_USER} \
  --docker-password=${QUAYIO_PASSWORD} \
  --docker-email=${QUAYIO_EMAIL} \
  -n ${PROJECT}

oc secrets link pipeline quay-dockercfg -n ${PROJECT}
oc secrets link deployer quay-dockercfg --for=pull -n ${PROJECT}

oc create configmap custom-maven-settings --from-file=../src/settings.xml
oc apply -f run-script-task.yaml
oc apply -f oc-task.yaml
oc apply -f oc-deploy-template.yaml
oc apply -f build-test-deploy.yaml

tkn pipeline start build-test-deploy \
    -w name=shared-workspace,volumeClaimTemplateFile=pvc.yaml \
    -w name=maven-settings,config=custom-maven-settings \
    -p deployment-name=inventory-build-test-deploy \
    -p git-url=https://github.com/justindav1s/microservices-on-openshift.git \
    -p APP_PROFILE='' \
    -p CONTEXT_DIR='src/inventory' \
    --use-param-defaults \
    --showlog
