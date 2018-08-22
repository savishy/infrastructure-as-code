# JDK application 
FROM openjdk:8u131-jdk-alpine

# Labels allow for metadata and visibility
LABEL com.poc.maintainer="Vish"
LABEL com.poc.description="Petclinic Application JAR"

VOLUME /app

# Application and configuration
ADD https://github.com/savishy/spring-petclinic/releases/download/v1.5.1/spring-petclinic-1.5.1.jar /app/petclinic.jar
ADD application.properties /app/application.properties
ENV JAVA_OPTS=""

ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -jar /app/petclinic.jar $SPRING_OPTS" ]
