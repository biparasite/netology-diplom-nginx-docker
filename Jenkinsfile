pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'registry.example.com/your-group/your-repo'
        TAG = "${env.GIT_COMMIT[0..7]}"  // Короткие 8 символов SHA
        KUBE_CONFIG = '/path/to/your/kubeconfig'  // Путь к kubeconfig на сервере Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                git(
                    url: 'https://your-repo.git',
                    branch: 'main'
                )
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.example.com', 'docker-hub-credentials-id') {
                        def app = docker.build("${DOCKER_IMAGE}:${TAG}")
                        app.push()
                        // Дополнительно: тег latest
                        app.push('latest')
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Подставляем тег образа в deployment.yaml
                    sh """
                    sed -i 's|registry.example.com/your-group/your-repo:latest|${DOCKER_IMAGE}:${TAG}|g' k8s/deployment.yaml
                    """
                    // Применяем манифесты
                    sh "kubectl --kubeconfig ${KUBE_CONFIG} apply -f k8s/deployment.yaml"
                    sh "kubectl --kubeconfig ${KUBE_CONFIG} apply -f k8s/service.yaml"
                    // Ждём готовности подов
                    sh "kubectl --kubeconfig ${KUBE_CONFIG} rollout status deployment/jenkins-app"
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
