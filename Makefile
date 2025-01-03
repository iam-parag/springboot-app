run:
	mvn spring-boot:run

build:
	mvn clean package

test:
	mvn test

clean:
	mvn clean

docker-build:
	docker build -t phonebook-app:v1 .

docker-run:
	docker run -p 8280:8280 -e DB_HOST=127.0.0.1 -e DB_PORT=3306 -e DB_NAME=phonebook -e DB_USERNAME=phonebook -e DB_PASSWORD=phonebook phonebook-app:v1
