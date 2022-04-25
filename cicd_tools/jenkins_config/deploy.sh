#!/bin/bash

PROJECT=cicd

oc project $PROJECT

oc create configmap jenkins-config --from-file=config.xml=config.xml -n $PROJECT