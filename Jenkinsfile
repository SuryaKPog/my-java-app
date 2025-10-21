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

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $DOCKER_IMAGE ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub-creds', url: 'https://index.docker.io/v1/']) {
                    sh "docker push $DOCKER_IMAGE"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh "kubectl apply -f deployment.yaml"
                sh "kubectl apply -f service.yaml"
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully. Image: $DOCKER_IMAGE"
        }
        failure {
            echo "Pipeline failed. Check logs for details."
        }
    }
}
