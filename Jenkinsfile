pipeline {
    agent any
    triggers {
        // Указывает Jenkins ожидать уведомления от репозитория
        // Это более общий и предпочтительный способ для всех Git-серверов
        pollSCM('* * * * *') // Обязательно укажите 'pollSCM' 
    }
    environment {
        IMAGE_USER = 'biparasite/'
        IMAGE_NAME = 'nginx_static'  
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
                        def app = docker.build("${IMAGE_USER}${IMAGE_NAME}:${TAG}")
                        app.push()
                    }
                }
            }
        }
        stage('Update GitOps Config') {
            steps {
                script {
                    // --- КОНФИГУРАЦИЯ ---
                    def CONFIG_REPO_URL = 'https://github.com/biparasite/netology-diplom-k8s-config.git' // Укажите URL вашего Config Repo
                    def GIT_CREDENTIALS_ID = 'github-push-creds' // ID учетных данных для пуша
                    def YAML_PATH = 'nginx/values.yaml' // Путь к вашему K8s манифесту в Config Repo
                    def NEW_IMAGE = "${env.TAG}"
                    def PROJECT_PATH = "${WORKSPACE}"

                    // 1. Клонирование репозитория конфигурации с использованием учетных данных для пуша
                    withCredentials([usernamePassword(credentialsId: GIT_CREDENTIALS_ID, usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                        sh 'rm -rf netology-diplom-k8s-config'
                        sh "git clone ${CONFIG_REPO_URL}"
                        
                        dir('netology-diplom-k8s-config') {
                            // Настройка Git для выполнения коммита
                            sh "git config user.email 'jenkins@ci.local'"
                            sh "git config user.name 'Jenkins GitOps Updater'"
                            sh "git checkout main" // или любая ветка, за которой следит Argo CD
                            
                            // 2. ОБНОВЛЕНИЕ YAML
                            sh "sed -i 's/${env.IMAGE_NAME}:.*/${env.IMAGE_NAME}:${NEW_IMAGE}/g' ${PROJECT_PATH}/${YAML_PATH }"                          
                            // 3. КОММИТ И PUSH
                            sh 'git add .'
                            sh "git commit -m 'GitOps: Auto-deploy ${NEW_IMAGE} triggered by Jenkins CI'"
                            
                            // Push с использованием учетных данных
                            sh "git push https://${GIT_USER}:${GIT_PASS}@github.com/biparasite/netology-diplom-k8s-config.git HEAD:main"
                        }
                    }
                    echo "✅ GitOps Config обновлен до образа: ${NEW_IMAGE}"
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
