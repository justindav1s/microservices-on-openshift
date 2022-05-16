# Camel based implementation of the _Product API_ API

## API Description ##
Product Information

### Building

    mvn clean package

### Running Locally

    mvn spring-boot:run

Getting the API docs:

    curl http://localhost:8080/openapi.json

## Running on OpenShift

    mvn fabric8:deploy

You can expose the service externally using the following command:

    oc expose svc product-api

And then you can access it's OpenAPI docs hosted by the service at:

    curl -s http://$(oc get route product-api --template={{.spec.host}})/openapi.json
