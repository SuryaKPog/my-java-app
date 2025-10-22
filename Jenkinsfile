pipeline {
    agent any

    environment {
        DOCKER_IMAGE  = "suryakpmax/my-java-app:${BUILD_NUMBER}" // Docker Hub image with build number
        AWS_REGION    = "ap-south-1"
        EKS_CLUSTER   = "my-java-app-eks"
        K8S_NAMESPACE = "dev"
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

        stage('Configure kubectl & Deploy to EKS') {
            steps {
                sh '''
                    # Use instance profile to update kubeconfig
                    aws eks update-kubeconfig --name $EKS_CLUSTER --region $AWS_REGION

                    # Create namespace if it doesn't exist
                    kubectl create namespace $K8S_NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

                    # Replace image dynamically in deployment YAML and apply
                    sed "s|image: .*|image: $DOCKER_IMAGE|g" k8s/deployment.yaml | kubectl apply -n $K8S_NAMESPACE -f -

                    # Apply service
                    kubectl apply -f k8s/service.yaml -n $K8S_NAMESPACE

                    # Verify pods and services
                    kubectl get pods -n $K8S_NAMESPACE
                    kubectl get svc -n $K8S_NAMESPACE
                '''
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully. Deployed Image: $DOCKER_IMAGE"
        } 
        failure {
            echo "Pipeline failed. Check the logs above for errors."
        }
    }
}
