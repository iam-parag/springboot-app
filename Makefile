install-docker:
	@echo "Installing Docker..."
	@sudo apt-get update
	@sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
	@curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	@sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(shell lsb_release -cs) stable"
	@sudo apt-get update
	@sudo apt-get install -y docker-ce docker-ce-cli containerd.io
	@echo "Docker installed successfully!"


run:
	mvn spring-boot:run

build:
	mvn clean package

test:
	mvn test

clean:
	mvn clean

docker-app-build:
	docker build -t phonebook-app:v1 .

docker-db-run:
	docker run --name mysql-container -e MYSQL_ROOT_PASSWORD=rootpassword -e MYSQL_DATABASE=phonebook -e MYSQL_USER=phonebook -e MYSQL_PASSWORD=phonebook -p 3306:3306 -d mysql:latest

docker-app-run:
	docker run -p 8280:8280 -e DB_HOST=127.0.0.1 -e DB_PORT=3306 -e DB_NAME=phonebook -e DB_USERNAME=phonebook -e DB_PASSWORD=phonebook phonebook-app:v1

db-migration:
	docker exec -i mysql-container mysql -u phonebook -pphonebook phonebook < sql_backup.sql 
