pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "suryakpmax/my-java-app:${BUILD_NUMBER}"
        AWS_REGION   = "ap-south-1"
        EKS_CLUSTER  = "my-java-app-eks"
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
                withDockerRegistry([credentialsId: 'docker-hub-creds', url: 'https://index.docker.io/v1/']) {
                    sh "docker push $DOCKER_IMAGE"
                }
            }
        }

        stage('Configure kubectl') {
            steps {
                sh "aws eks --region $AWS_REGION update-kubeconfig --name $EKS_CLUSTER"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh "kubectl create namespace dev || true"
                sh "kubectl apply -f k8s/deployment.yaml -n dev"
                sh "kubectl apply -f k8s/service.yaml -n dev"
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
