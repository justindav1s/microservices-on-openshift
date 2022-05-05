#!/bin/bash


PROJECT=tekton-test
APP=inventory
PROFILE=dev

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
oc apply -f tasks/run-script-task.yaml
oc apply -f tasks/oc-deploy-template.yaml
oc apply -f pipelines/maven-build-test-deploy.yaml

oc create configmap ${APP}-${PROFILE}-config \
    --from-file=../src/${APP}/src/main/resources/config.${PROFILE}.properties \
    -n ${PROJECT}

cat << EOF > pipelines/${APP}-pipeline-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ${APP}-pipeline-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi
EOF

tkn pipeline start maven-build-test-deploy \
    -w name=shared-workspace,volumeClaimTemplateFile=${APP}-pipeline-pvc.yaml \
    -w name=maven-settings,config=custom-maven-settings \
    -p APP_NAME=${APP} \
    -p GIT_REPO=https://github.com/justindav1s/microservices-on-openshift.git \
    -p GIT_BRANCH=master \
    -p APP_PROFILE=${PROFILE} \
    -p CONTEXT_DIR=src/${APP} \
    -p IMAGE_REPO=${QUAYIO_HOST}/${QUAYIO_USER} \
    --use-param-defaults \
    --showlog
