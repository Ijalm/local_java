pipeline {
    agent any

    environment {
        IMAGE_NAME = "shopping-cart-app"
        CONTAINER_NAME = "shopping-cart-container"
        PORT = "8080"
    }

    stages {

        stage('Checkout Code') {
            steps {
                //git 'https://github.com/Ijalm/local_java.git'
		git branch: 'main', url: 'https://github.com/Ijalm/local_java.git'
            }
        }

        stage('Check Environment') {
            steps {
                sh '''
                    java -version
                    mvn -version
                    docker -v
                '''
            }
        }

        stage('Build Maven Project') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $IMAGE_NAME ."
            }
        }

        stage('Stop Old Container') {
            steps {
                sh '''
                    docker stop $CONTAINER_NAME || true
                    docker rm $CONTAINER_NAME || true
                '''
            }
        }

        stage('Run Container') {
            steps {
                sh """
                    docker run -d \
                    --name $CONTAINER_NAME \
                    -p $PORT:8080 \
                    $IMAGE_NAME
                """
            }
        }
    }

    post {
        success {
            echo "Build & Deployment Successful 🚀"
        }

        failure {
            echo "Pipeline Failed ❌ Check logs"
        }
    }
}
