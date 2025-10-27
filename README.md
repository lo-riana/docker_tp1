### **TP 1**

1. It's better to run the container with a flag instead of putting variable in the Dockerfile because values in the Dockerfile stay inside the image, while -e keeps them private and easier to change.
2. We need a volume because it stores the database files on the host machine, so the data stays even if the container is removed.
3. 
commands :
docker build -t lorianaa/tpfirstapp .  
docker network create app-network 
docker run -d --name tpfirstdb --network app-network -v "C:\Users\loria\Documents\I2-efrei\Docker\tp_1\data:/var/lib/postgresql/data" -e POSTGRES_DB=db -e POSTGRES_USER=usr -e POSTGRES_PASSWORD=pwd lorianaa/tpfirstapp

docker run -d --name adminer --network app-network -p 8081:8080 adminer

Dockerfile :
FROM postgres:17.2-alpine
COPY initdb/*.sql /docker-entrypoint-initdb.d/

4. We need a multistage build to keep the final Docker image smaller, faster, and cleaner. It lets us build the project with all the heavy tools (JDK, Maven) in the first stage, and then run only the compiled app in a lightweight image (JRE) in the second stage.
Dockerfile :
FROM eclipse-temurin:21-jdk-alpine AS myapp-build  # use JDK to build the project
ENV MYAPP_HOME=/opt/myapp
WORKDIR $MYAPP_HOME

RUN apk add --no-cache maven  # install Maven 

COPY pom.xml .                # copy Maven configuration file
COPY src ./src                # copy source code
RUN mvn package -DskipTests   # build the Spring Boot jar without running tests

FROM eclipse-temurin:21-jre-alpine 
ENV MYAPP_HOME=/opt/myapp
WORKDIR $MYAPP_HOME


COPY --from=myapp-build $MYAPP_HOME/target/*.jar # copy the jar file built in the first stage $MYAPP_HOME/myapp.jar

ENTRYPOINT ["java", "-jar", "myapp.jar"] # run the Spring Boot application

5. We need a reverse proxy because it receives client requests and forwards them to the backend server. It helps hide the backend’s address, manage traffic, and handle things like security or HTTPS. It also makes the application easier to access through a single public entry point.

6. Docker Compose is important because it makes it easy to manage multiple containers as one application. It automates the startup, networking, and dependencies between services (like backend, database, and http server).

7. 
docker compose up -d --build → rebuild and start services
docker compose ps → list running services
docker compose restart [service] → restart a service
docker compose down → stop and remove containers, networks
docker compose down -v →  remove volumes (reset database)

8.
database → runs PostgreSQL, loads environment variables from .env
backend → builds the Spring Boot API, connects to the database service
httpd → builds the Apache server, exposes port 8084, and acts as a reverse proxy for the backend
networks → defines a private internal network so services can communicate
volumes → keeps PostgreSQL data even if containers are rebuilt

9.
docker login
docker tag lorianaa/simpleapi:latest lorianaa/simpleapi:1.0.0
docker push lorianaa/simpleapi:1.0.0

docker tag lorianaa/http-server:latest lorianaa/http-server:1.0.0
docker push lorianaa/http-server:1.0.0

10. We publish images to an online repository (like Docker Hub) so they can be shared, reused, and deployed easily on any machine.


### **TP 2** 

1. TestContainers is a Java library that provides instances of Docker containers for testing purposes. 

2. We need secured variables to protect sensitive informations like passwords, API tokens, and other  from being exposed in our source code. 

3. The `needs: test-backend` creates a dependency between jobs, ensuring that the `build-and-push-docker-image` job only runs if the `test-backend` job completes successfully. This prevents building and publishing potentially broken or faulty Docker images. Without this dependency, images would be built and pushed even if tests fail, which could deploy defective code to production environments.

4. We push Docker images to Docker Hub to store versioned artifacts that can be easily shared with team members, used in automated deployment pipelines, and ensure consistent environments.
