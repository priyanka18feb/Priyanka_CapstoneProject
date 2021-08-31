#FROM openjdk:8
FROM maven
MAINTAINER "priyanka18feb@gmail.com"

## Install maven
#RUN apt-get update
#RUN apt-get install -y maven

WORKDIR /code

# Prepare by downloading dependencies
ADD pom.xml /code/pom.xml
#RUN ["mvn", "dependency:resolve"]
# RUN ["mvn", "verify"]

# Adding source, compile and package into a fat jar
ADD src /code/src
RUN ["mvn", "package", "-DskipTests"]

EXPOSE 8085

ENTRYPOINT ["java", "-jar", "target\UserFront.jar"]