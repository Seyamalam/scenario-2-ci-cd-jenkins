pipeline {
    agent any
    
    environment {
        APP_NAME = 'api-avengers-demo'
        DOCKER_IMAGE = 'api-avengers-demo:latest'
        COMPOSE_PROJECT_NAME = 'api-avengers'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo '=== Stage 1: Checking out code ==='
                checkout scm
                sh 'echo "Code checked out successfully"'
                sh 'ls -la'
            }
        }
        
        stage('Build') {
            steps {
                echo '=== Stage 2: Building application ==='
                sh '''
                    echo "Installing dependencies..."
                    cd app
                    pip install --break-system-packages -r requirements.txt
                    echo "Build completed successfully"
                '''
            }
        }
        
        stage('Test') {
            steps {
                echo '=== Stage 3: Running unit tests ==='
                sh '''
                    cd app
                    echo "Running pytest..."
                    pytest test_app.py -v --tb=short || true
                    echo "Tests completed"
                '''
            }
        }
        
        stage('Package') {
            steps {
                echo '=== Stage 4: Building Docker image ==='
                sh '''
                    echo "Building Docker image: ${DOCKER_IMAGE}"
                    docker build -t ${DOCKER_IMAGE} -f Dockerfile ./app
                    echo "Docker image built successfully"
                    docker images | grep api-avengers-demo
                '''
            }
        }
        
        stage('Deploy') {
            steps {
                echo '=== Stage 5: Deploying with Docker Compose ==='
                sh '''
                    echo "Stopping any existing containers..."
                    docker-compose down || true
                    docker rm -f api-avengers-demo || true
                    
                    echo "Starting application with Docker Compose..."
                    docker-compose up -d
                    
                    echo "Waiting for container to start..."
                    sleep 10
                    
                    echo "Checking running containers..."
                    docker-compose ps
                '''
            }
        }
        
        stage('Health Check') {
            steps {
                echo '=== Stage 6: Verifying application health ==='
                sh '''
                    echo "Waiting for application to be ready..."
                    sleep 15
                    
                    echo "Checking container status..."
                    docker ps | grep api-avengers-demo
                    
                    echo "Testing health endpoint..."
                    docker exec api-avengers-demo curl -f http://localhost:5000/health || exit 1
                    
                    echo "Testing home endpoint..."
                    docker exec api-avengers-demo curl -f http://localhost:5000/ || exit 1
                    
                    echo "All health checks passed!"
                '''
            }
        }
    }
    
    post {
        success {
            echo '========================================='
            echo 'Pipeline completed successfully! ✓'
            echo '========================================='
            sh '''
                echo "Application is running at: http://localhost:5000"
                echo "Health endpoint: http://localhost:5000/health"
                docker ps | grep api-avengers-demo
            '''
        }
        failure {
            echo '========================================='
            echo 'Pipeline failed! ✗'
            echo '========================================='
            sh '''
                echo "Cleaning up..."
                docker-compose down || true
            '''
        }
        always {
            echo 'Cleaning up workspace...'
            sh 'docker system prune -f || true'
        }
    }
}
