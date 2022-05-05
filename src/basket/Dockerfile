#FROM image-registry.openshift-image-registry.svc:5000/openshift/java:latest
FROM registry.access.redhat.com/ubi8/openjdk-8

LABEL maintainer=justinndavis@gmail.com

EXPOSE 8080

ENV TZ Europe/London
ENV SERVICE_ARTIFACT_ID=basket
ENV SERVICE_VERSION=0.0.1-SNAPSHOT
ENV SERVICE_JAR_FILE=$SERVICE_ARTIFACT_ID-$SERVICE_VERSION.jar

COPY target/$SERVICE_JAR_FILE .

ENV JAVA_OPTS="-Dspring.profiles.active=dev"

ENTRYPOINT [ "sh", "-c", "java -Djava.security.egd=file:/dev/./urandom $JAVA_OPTS -jar $SERVICE_JAR_FILE" ]