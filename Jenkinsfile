pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "suryakpmax/my-java-app:${BUILD_NUMBER}"
        AWS_REGION   = "ap-south-1"
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Use GitHub credentials added in Jenkins
                git branch: 'main', 
                    url: 'https://github.com/SuryaKPog/my-java-app.git', 
                    credentialsId: 'github-creds'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Make sure Docker daemon is accessible by Jenkins user
                sh "docker build -t $DOCKER_IMAGE ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub-creds', url: 'https://index.docker.io/v1/']) {
                    sh "docker push $DOCKER_IMAGE"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                // Using AWS credentials added in Jenkins
                withAWS(credentials: 'aws-creds', region: "$AWS_REGION") {
                    sh "kubectl set image deployment/sample-app-deployment sample-container=$DOCKER_IMAGE"
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully. Docker Image: $DOCKER_IMAGE"
        }
        failure {
            echo "Pipeline failed. Check logs for details."
        }
    }
}
