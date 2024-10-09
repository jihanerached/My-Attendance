pipeline {
    agent any

    environment {
        // Adjust path for Docker if needed
        PATH = "${env.PATH};C:\\Program Files\\Docker\\Docker\\resources\\bin"
    }

    tools {
        // Assuming PHP and Composer are installed on the agent
        nodejs 'NodeJS' // Install NodeJS and npm if needed
    }

    stages {
        stage('Checkout') {
            steps {
                // Clone the GitHub repository
                git branch: 'main', url: 'https://github.com/jihanerached/My-Attendance.git'
            }
        }
        stage('Migrate Database') {
            steps {
                sh 'php artisan migrate'
            }
        }


        stage('Install Dependencies') {
            steps {
                script {
                    // Install Composer dependencies
                    bat 'composer install'
                    // Install npm dependencies
                    bat 'npm install'
                    // Build Laravel assets
                    bat 'npm run build'
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Run Laravel unit tests (PHPUnit)
                    bat 'vendor\\bin\\phpunit'
                }

                post {
                    always {
                        // Archive the test results
                        junit '**/test-results/*.xml'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image for Laravel app
                    docker.build('my-attendance-app')
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Use Docker Compose to bring up the services (Laravel app, MySQL, etc.)
                    bat 'docker-compose up -d'
                }
            }
        }

        stage('Deploy') {
            steps {
                // Notify that the app is deployed and accessible
                echo 'Deployment completed. Your Laravel app is accessible at http://localhost:8000'
            }
        }
    }

    post {
        always {
            // Clean up workspace after the build
            cleanWs()
        }
        failure {
            echo 'Build or deployment failed.'
        }
        success {
            echo 'Build and deployment successful.'
        }
    }
}
