FROM openjdk:11.0.2
WORKDIR /var/lib/jenkins/workspace/docker-k8s-project/
COPY target/spring*.jar /opt/app.jar
EXPOSE 8080
ENTRYPOINT exec java -jar /opt/app.jar

