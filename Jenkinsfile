pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'https://hub.docker.com/biparasite/'
        TAG = "${env.GIT_COMMIT[0..7]}"  // Короткие 8 символов SHA
        KUBE_CONFIG = '/path/to/your/kubeconfig'  // Путь к kubeconfig на сервере Jenkins
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


    post {
        success {
            echo 'Пайплайн успешно завершён!'
        }
        failure {
            echo 'Ошибка в пайплайне!'
        }
    }
}
