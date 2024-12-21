pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                // Get some code from a GitHub repository
                git branch: 'CI-CD', url: 'https://github.com/iam-parag/springboot-app.git'

                // Build docker image 
                sh " docker build -t hello-world-springboot ."

            }

        }
    }
}
