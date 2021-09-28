#!/usr/bin/env bash


export IP=api.sno.openshiftlabs.net:6443
export USER=justin

export ORG=amazin
export DEV_PROJECT=${ORG}-dev
export PROD_PROJECT=${ORG}-prod
export CICD_PROJECT=cicd

export CURL="curl -k -v"
export JENKINS_USER=justin-admin-edit-view
export JENKINS_TOKEN=11f4274ec59be12eb227a08b08ee13d54b
export JENKINS=jenkins-cicd.apps.sno.openshiftlabs.net

export QUAYIO_REGISTRY=quay.io

export DOMAIN=$CICD_PROJECT
export DATABASE_USER="sonar"
export DATABASE_PASSWORD="sonar"
export DATABASE_URL="jdbc:postgresql://postgresql/sonar"

