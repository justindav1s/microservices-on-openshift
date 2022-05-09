#!/bin/bash


oc project 3scale


oc delete DeveloperAccount jdcorp-dev-acc-1
oc delete DeveloperUser justin
oc delete secret justin-creds-secret

oc create secret generic justin-creds-secret --from-literal=password=password
oc apply -f user.yaml
oc apply -f account.yaml
