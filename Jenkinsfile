pipeline {
    agent any
    environment {
        DOCKER_HUB_CREDENTIALS = 'c634720d-ccab-47f2-a073-7a67934670a5' // Replace with your credentials ID
        DOCKER_IMAGE = 'parag52/hello-world-springboot'
        IMAGE_TAG = 'latest'
    }
    
    stages {
        stage('Build') {
            steps {
                // Get some code from a GitHub repository
                git branch: 'CI-CD', url: 'https://github.com/iam-parag/springboot-app.git'

                // Build docker image 
                sh "docker build -t $DOCKER_IMAGE:$IMAGE_TAG ."

            }

        }
        stage('Login to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_HUB_CREDENTIALS, 
                                                     usernameVariable: 'DOCKER_USER', 
                                                     passwordVariable: 'DOCKER_PASS')]) {
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    }
                }
            }
        }
        stage('Push') {
            steps {

                // Push docker image to docker hub 
                sh " docker push $DOCKER_IMAGE:$IMAGE_TAG"

            }

        }
    }
    post {
        always {
            sh 'docker logout'
        }
    }
}
