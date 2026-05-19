pipeline {
    agent any

    tools {
        maven 'Maven'
        jdk 'JDK8'
    }

    environment {
        IMAGE_NAME = "shopping-cart-app"
        NEXUS_URL = "YOUR_NEXUS_IP:8082"
        NEXUS_REPO = "docker-hosted"
        IMAGE_TAG = "latest"

        FULL_IMAGE_NAME = "${NEXUS_URL}/${NEXUS_REPO}/${IMAGE_NAME}:${IMAGE_TAG}"
    }

    stages {

        stage('Clone Repository') {
            steps {
                git 'https://github.com/shashirajraja/shopping-cart.git'
            }
        }

        stage('Build Maven Project') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Tag Docker Image') {
            steps {
                sh 'docker tag $IMAGE_NAME $FULL_IMAGE_NAME'
            }
        }

        stage('Login to Nexus Docker Registry') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'nexus-credentials',
                    usernameVariable: 'NEXUS_USER',
                    passwordVariable: 'NEXUS_PASS'
                )]) {

                    sh '''
                    echo $NEXUS_PASS | docker login $NEXUS_URL \
                    -u $NEXUS_USER \
                    --password-stdin
                    '''
                }
            }
        }

        stage('Push Image to Nexus') {
            steps {
                sh 'docker push $FULL_IMAGE_NAME'
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                docker stop shopping-cart-container || true
                docker rm shopping-cart-container || true

                docker run -d \
                --name shopping-cart-container \
                -p 8080:8080 \
                $FULL_IMAGE_NAME
                '''
            }
        }
    }

    post {

        success {
            echo 'Application built and deployed successfully!'
        }

        failure {
            echo 'Pipeline failed!'
        }
    }
}
