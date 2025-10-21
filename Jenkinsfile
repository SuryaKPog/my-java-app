pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "suryakpmax/my-java-app:${BUILD_NUMBER}"
        AWS_REGION   = "ap-south-1"
    }

    options {
        // Limit build logs and timeout
        timeout(time: 30, unit: 'MINUTES')
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', 
                    url: 'https://github.com/SuryaKPog/my-java-app.git', 
                    credentialsId: 'github-creds'
            }
        }

        stage('Build with Maven') {
            steps {
                // Limit Maven memory usage
                sh 'mvn clean package -T 1C -Dmaven.repo.local=/tmp/.m2/repo'
            }
        }

        stage('Build Docker Image') {
            steps {
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
                withAWS(credentials: 'aws-creds', region: "$AWS_REGION") {
                    // Use t3.micro nodes, safe for Free Tier
                    sh "kubectl set image deployment/sample-app-deployment sample-container=$DOCKER_IMAGE"
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully! Docker Image: $DOCKER_IMAGE"
        }
        failure {
            echo "Pipeline failed. Check logs for details."
        }
    }
}
