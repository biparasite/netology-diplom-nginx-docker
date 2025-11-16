pipeline {
    agent any

    environment {
        IMAGE_NAME = 'biparasite/nginx_static'  // Укажите здесь!
        TAG = "${env.GIT_COMMIT[0..7]}"
    }
    agent {
        docker {
            image 'docker:24-git'  // Образ с Docker CLI
            args '-v /var/run/docker.sock:/var/run/docker.sock'  // Монтируем сокет
        }
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
                    docker.withRegistry('https://registry.hub.docker.com') {
                        def app = docker.build("${IMAGE_NAME}:${TAG}")
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
