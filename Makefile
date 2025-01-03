# Variables
JAVA_VERSION := openjdk-11-jdk
MAVEN_VERSION := 3.8.8
DOCKER_VERSION := 20.10.30

.PHONY: all install-java install-maven install-docker check-prerequisites clean run build test docker-app-build docker-db-run docker-app-run db-migration

# Run all installation steps
all: install-java install-maven install-docker check-prerequisites

# Install Java (OpenJDK 11)
install-java:
	@echo "Installing Java (OpenJDK 11)..."
	@sudo apt-get update
	@sudo apt-get install -y $(JAVA_VERSION)
	@java -version
	@echo "Java installation completed!"

# Install Maven
install-maven:
	@echo "Installing Maven $(MAVEN_VERSION)..."
	@sudo apt-get update
	@sudo apt-get install -y wget
	@wget https://downloads.apache.org/maven/maven-$(subst .,/, $(MAVEN_VERSION))/binaries/apache-maven-$(MAVEN_VERSION)-bin.tar.gz
	@sudo tar -xvzf apache-maven-$(MAVEN_VERSION)-bin.tar.gz -C /opt
	@sudo ln -s /opt/apache-maven-$(MAVEN_VERSION)/bin/mvn /usr/bin/mvn
	@mvn -version
	@echo "Maven installation completed!"

# Install Docker (optional for containerization)
install-docker:
	@echo "Installing Docker..."
	@sudo apt-get update
	@sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
	@curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	@sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(shell lsb_release -cs) stable"
	@sudo apt-get update
	@sudo apt-get install -y docker-ce docker-ce-cli containerd.io
	@docker --version
	@echo "Docker installation completed!"

# Check all prerequisites
check-prerequisites:
	@echo "Checking prerequisites..."
	@if ! [ -x "$(command -v java)" ]; then echo "Error: Java is not installed." && exit 1; fi
	@if ! [ -x "$(command -v mvn)" ]; then echo "Error: Maven is not installed." && exit 1; fi
	@if ! [ -x "$(command -v docker)" ]; then echo "Warning: Docker is not installed." && exit 0; fi
	@echo "All prerequisites are installed!"

# Maven tasks
run:
	@echo "Running Spring Boot application..."
	@mvn spring-boot:run

build:
	@echo "Building Spring Boot application..."
	@mvn clean package

test:
	@echo "Running tests..."
	@mvn test

clean:
	@echo "Cleaning project..."
	@mvn clean

# Docker tasks
docker-app-build:
	@echo "Building Docker image for the Spring Boot application..."
	@docker build -t phonebook-app:v1 .

docker-db-run:
	@echo "Running MySQL Docker container..."
	@docker run --name mysql-container -e MYSQL_ROOT_PASSWORD=rootpassword -e MYSQL_DATABASE=phonebook -e MYSQL_USER=phonebook -e MYSQL_PASSWORD=phonebook -p 3306:3306 -d mysql:latest

docker-app-run:
	@echo "Running Spring Boot application in Docker..."
	@docker run -p 8280:8280 -e DB_HOST=127.0.0.1 -e DB_PORT=3306 -e DB_NAME=phonebook -e DB_USERNAME=phonebook -e DB_PASSWORD=phonebook phonebook-app:v1

db-migration:
	@echo "Restoring database from backup..."
	@docker exec -i mysql-container mysql -u phonebook -pphonebook phonebook < sql_backup.sql

# Clean temporary files
clean-temp:
	@echo "Cleaning up temporary files..."
	@rm -f apache-maven-$(MAVEN_VERSION)-bin.tar.gz
	@echo "Cleanup completed!"
