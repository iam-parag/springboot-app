ARCH := $(shell dpkg --print-architecture)
VERSION_CODENAME := $(shell . /etc/os-release && echo ""$$VERSION_CODENAME"")


.PHONY: all install-java install-maven install-docker check-prerequisites clean run build test docker-app-build docker-db-run docker-app-run db-migration

# Run all installation steps
all: install-java install-maven install-docker check-prerequisites

# Install Java (OpenJDK 11)
install-java:
	@echo "Installing Java (OpenJDK 11)..."
	@sudo apt-get update
	@sudo apt-get install -y openjdk-11-jdk
	@java -version
	@echo "Java installation completed!"

# Install Maven
install-maven:
	@echo "Installing Maven $(MAVEN_VERSION)..."
	@sudo apt-get update
	@sudo apt-get install -y wget
	@wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz
	@sudo tar -xvzf apache-maven-3.9.9-bin.tar.gz -C /opt
	@sudo rm -rf /usr/bin/mvn
	@sudo ln -s /opt/apache-maven-3.9.9/bin/mvn /usr/bin/mvn
	@mvn -version
	@sudo rm -rf apache-maven-3.9.9-bin.*
	@echo "Maven installation completed!"

# Install Docker (optional for containerization)
install-docker:
	@echo "Installing Docker..."
	@sudo apt-get update
	@sudo apt-get install ca-certificates curl
	@sudo install -m 0755 -d /etc/apt/keyrings
	@sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	@sudo chmod a+r /etc/apt/keyrings/docker.asc
	@echo "deb [arch=$(ARCH) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(VERSION_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	@sudo apt-get update
	@sudo apt-get install -y -f  containerd.io docker-ce docker-ce-cli  docker-buildx-plugin docker-compose-plugin
	@docker --version
	@echo "Docker installation completed!"

# Check all prerequisites
check-prerequisites:
	@echo "Checking prerequisites..."
	@if ! command -v java >/dev/null 2>&1; then echo "Error: Java is not installed." && exit 1; fi
	@if ! command -v mvn >/dev/null 2>&1; then echo "Error: Maven is not installed." && exit 1; fi
	@if ! command -v docker >/dev/null 2>&1; then echo "Warning: Docker is not installed." && exit 0; fi
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
	@docker ps -q -f name=mysql-container || docker start mysql-container
	@docker exec -i mysql-container mysql -u phonebook -pphonebook phonebook < sql_backup.sql
docker-compose-start:
	@docker-compose up

docker-app-start: docker-db-run db-migration docker-compose-start

# Clean temporary files
clean-temp:
	@echo "Cleaning up temporary files..."
	@rm -f apache-maven-$(MAVEN_VERSION)-bin.tar.gz
	@echo "Cleanup completed!"
