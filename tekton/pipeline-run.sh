#!/bin/bash


PROJECT=tekton-test
APP=basket
PROFILE=dev

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
    -w name=shared-workspace,volumeClaimTemplateFile=pipelines/${APP}-pipeline-pvc.yaml \
    -w name=maven-settings,config=custom-maven-settings \
    -p APP_NAME=${APP} \
    -p GIT_REPO=https://github.com/justindav1s/microservices-on-openshift.git \
    -p GIT_BRANCH=master \
    -p APP_PROFILE=${PROFILE} \
    -p CONTEXT_DIR=src/${APP} \
    -p IMAGE_REPO=${QUAYIO_HOST}/${QUAYIO_USER} \
    --use-param-defaults \
    --showlog
