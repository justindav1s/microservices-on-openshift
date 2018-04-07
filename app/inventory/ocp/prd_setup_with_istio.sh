#!/usr/bin/env bash

APP=inventory
S2I_IMAGE=redhat-openjdk18-openshift:1.2

. ../../env.sh

oc login https://${IP}:8443 -u $USER

oc project istio-system
oc adm policy add-scc-to-user privileged -z default -n ${PROD_PROJECT}

oc project ${PROD_PROJECT}

oc delete template inventory-istio-dev-dc -n ${PROD_PROJECT}
oc delete deploy -l app=${APP} -n ${PROD_PROJECT}
oc delete deploymentconfigs -l app=${APP} -n ${PROD_PROJECT}
oc delete po -l app=${APP} -n ${PROD_PROJECT}
oc delete builds -l app=${APP} -n ${PROD_PROJECT}
oc delete svc -l app=${APP} -n ${PROD_PROJECT}
oc delete bc -l app=${APP} -n ${PROD_PROJECT}
oc delete routes -l app=${APP} -n ${PROD_PROJECT}
oc delete ingress -l app=${APP} -n ${PROD_PROJECT}

oc label namespace ${PROD_PROJECT} istio-injection=enabled
oc adm policy add-scc-to-user privileged -z default -n ${PROD_PROJECT}

oc apply -f <(istioctl kube-inject --debug -f inventory-istio-prod.yaml)

