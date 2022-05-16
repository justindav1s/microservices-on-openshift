#!/bin/bash

rm -rf user-truststore.jks

oc get secret my-cluster-cluster-ca-cert -n kafka-cluster -o jsonpath='{.data.ca\.crt}' | base64 --decode > ca.crt

# oc get secret kafka-user -n kafka-cluster -o jsonpath='{.data.user\.p12}' | base64 --decode > user.p12
oc get secret kafka-user -n kafka-cluster -o jsonpath='{.data.user\.password}' | base64 --decode > user.password
export PASSWORD=`cat user.password`
keytool -import -trustcacerts -file ca.crt -keystore user-truststore.jks -storepass $PASSWORD -noprompt
# keytool -importkeystore -srckeystore user.p12 -srcstoretype pkcs12 -destkeystore user-keystore.jks -deststoretype jks

rm -rf user.password ca.crt