pipeline {
    agent any

    environment {
        IMAGE_NAME = 'biparasite/nginx_static'  // Укажите здесь!
        TAG = "${env.GIT_COMMIT[0..7]}"
    }

    stages {
        stage('Checkout') {
            steps {
                git(
                    url: 'https://github.com/biparasite/netology-diplom-nginx-docker.git',
                    branch: 'main'
                )
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://hub.docker.com/') {
                        def app = docker.build("${DOCKER_IMAGE}:${TAG}")
                        app.push()
                        // Дополнительно: тег latest
                        app.push('latest')
                    }
                }
            }
        }
    }
    post {
        success {
            echo 'Пайплайн успешно завершён!'
        }
        failure {
            echo 'Ошибка в пайплайне!'
        }
    }
}


pipeline {
    agent any
    environment {
        IMAGE_NAME = 'your-username/your-repo'  // Укажите здесь!
        TAG = "${env.GIT_COMMIT[0..7]}"
    }
    stages {
        stage('Build') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials-id') {
                        def app = docker.build("${IMAGE_NAME}:${TAG}")
                        app.push()
                    }
                }
            }
        }
    }
}
