<<<<<<< HEAD
# Build the application
FROM maven:3.9.5-eclipse-temurin-8 AS build

WORKDIR /app

COPY pom.xml ./
COPY src ./src

RUN mvn clean package -DskipTests

# Set the working directory in the container
FROM eclipse-temurin:8-jre

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8087

ENTRYPOINT ["java", "-jar", "app.jar"]
=======
# use the image for spring boot application build process
FROM maven:3.6.3-openjdk-11-slim as build

# set the working directory
WORKDIR /app

# copy pom.xml and all files
COPY pom.xml .
COPY . .

# Run the build command to build app
RUN mvn clean install

# stage 2 smaller iimage for previous stage
FROM openjdk:11-jre-slim

WORKDIR /app

COPY --from=build /app/target/phonebook-0.0.1-SNAPSHOT.jar .

EXPOSE 8280

CMD ["java","-jar","/app/phonebook-0.0.1-SNAPSHOT.jar"]
>>>>>>> 7e0f468 (Update Code)
