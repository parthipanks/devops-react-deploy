pipeline {
    agent any

    environment {
        DOCKERHUB_CREDS = credentials('dockerhub-creds')
        DOCKER_USER     = 'parthipanks'
        DEV_REPO        = "${DOCKER_USER}/dev"
        PROD_REPO       = "${DOCKER_USER}/prod"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    // Jenkins multibranch will set BRANCH_NAME (dev or master)
                    def branch = env.BRANCH_NAME ?: 'dev'
                    def imageTag = "${branch}-${env.BUILD_NUMBER}"

                    if (branch == 'master') {
                        REPO = PROD_REPO
                    } else {
                        REPO = DEV_REPO
                    }

                    IMAGE_FULL = "${REPO}:${imageTag}"
                    IMAGE_LATEST = "${REPO}:latest"

                    sh """
                      echo "Building image: ${IMAGE_FULL}"
                      docker build -t ${IMAGE_FULL} .
                      docker tag ${IMAGE_FULL} ${IMAGE_LATEST}
                    """
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh """
                      echo "${DOCKERHUB_CREDS_PSW}" | docker login -u "${DOCKERHUB_CREDS_USR}" --password-stdin
                      docker push ${IMAGE_FULL}
                      docker push ${IMAGE_LATEST}
                    """
                }
            }
        }

        stage('Deploy to Server (only master)') {
            when {
                branch 'master'
            }
            steps {
                script {
                    // Stop old container and run new one from prod repo
                    sh """
                      echo "${DOCKERHUB_CREDS_PSW}" | docker login -u "${DOCKERHUB_CREDS_USR}" --password-stdin
                      docker pull ${IMAGE_LATEST} || true

                      docker stop devops-react || true
                      docker rm devops-react || true

                      docker run -d --name devops-react -p 80:80 ${IMAGE_LATEST}
                    """
                }
            }
        }
    }
}
