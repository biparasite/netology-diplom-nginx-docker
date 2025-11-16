pipeline {
    agent any
    triggers {
        // Указывает Jenkins ожидать уведомления от репозитория
        // Это более общий и предпочтительный способ для всех Git-серверов
        pollSCM('* * * * *') // Обязательно укажите 'pollSCM' 
    }
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
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-creds') {
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
