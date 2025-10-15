pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "suryakpmax/my-java-app:${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/SuryaKPog/my-java-app.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $DOCKER_IMAGE ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub-creds']) {
                    sh "docker push $DOCKER_IMAGE"
                }
            }
        }
    }
}

