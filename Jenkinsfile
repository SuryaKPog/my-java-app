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
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/SuryaKPog/my-java-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $DOCKER_IMAGE ."
            }
        }

        stage('Login to Docker Hub & Push Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $DOCKER_IMAGE
                    '''
                }
            }
        }

        stage('Configure kubectl') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws']]) {
                    sh '''
                        aws eks --region $AWS_REGION update-kubeconfig --name $EKS_CLUSTER
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    kubectl create namespace dev --dry-run=client -o yaml | kubectl apply -f -
                    kubectl apply -f k8s/deployment.yaml -n dev
                    kubectl apply -f k8s/service.yaml -n dev
                '''
            }
        }
    }

    post {
        success {
            echo " Pipeline completed successfully. Image: $DOCKER_IMAGE"
        }
        failure {
            echo " Pipeline failed. Check logs for details."
        }
    }
}
