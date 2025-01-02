# hello-world-springboot
Hello World with Spring Boot JDK 11,
# Set Environment variables for database
>      export DB_HOST=your-db-host
>      export DB_PORT=3306
>      export DB_NAME=phonebook
>      export DB_USERNAME=your-username
>      export DB_PASSWORD=your-password
# Manual application start on local
  >     mvn install
  >     java -jar target/phonebook-0.0.1-SNAPSHOT.jar

# Run using Docker Container
  Build docker image
  >     docker buildx build -t phonebook-app:v1 .
Run docker image
  >     docker run -p 8280:8280 -e DB_HOST=Host_IP -e DB_PORT=Port -e DB_NAME=Database_Name -e DB_USERNAME=Username -e DB_PASSWORD=password phonebook-app:v1

