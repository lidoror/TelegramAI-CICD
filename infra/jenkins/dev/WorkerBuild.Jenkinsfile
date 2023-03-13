pipeline {
    agent {
        docker {
            image '700935310038.dkr.ecr.us-west-2.amazonaws.com/lidoror-jenkinsagent-k0s:1'
            args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    options {
        timestamps()
        timeout(time: 30, unit: 'MINUTES')
    }

    environment {
        IMAGE_NAME = 'lidoror-worker-k0s'
        IMAGE_TAG = "${GIT_COMMIT}"
        REPO_URL = '700935310038.dkr.ecr.us-west-2.amazonaws.com'
    }

    stages {
        stage('ECR Login') {
            steps {
                sh 'aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 700935310038.dkr.ecr.us-west-2.amazonaws.com'
            }
        }
        stage('Image Build') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} -f worker/Dockerfile ."
            }
        }

        stage('Image Push') {
            steps {
                sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${REPO_URL}/${IMAGE_NAME}:${IMAGE_TAG}"
                sh "docker push ${REPO_URL}/${IMAGE_NAME}:${IMAGE_TAG}"
            }
            post {
                    always {
                        sh 'docker image prune -a --filter "until=64h" --force'
                    }
                }
        }

        stage('Trigger Deploy') {
            steps {
                build job: 'workerDeploy', wait: false, parameters: [
                    string(name: 'WORKER_IMAGE_NAME', value: "${REPO_URL}/${IMAGE_NAME}:${IMAGE_TAG}"),
                ]
            }
        }
    }
}