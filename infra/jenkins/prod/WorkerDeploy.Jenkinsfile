pipeline {
    agent {
        docker {
            // TODO build & push your Jenkins agent image, place the URL here
            image '700935310038.dkr.ecr.us-west-2.amazonaws.com/lidoror-jenkinsagent-k0s:1'
            args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    options {
        timestamps()
        timeout(time: 30, unit: 'MINUTES')
    }
    environment {
        APP_NAME = "worker"
        APP_ENV = "prod"
        K8S_DEPLOYMENT_FILE = "infra/k8s/worker_to_deploy.yaml"
        K8S_YAML_TO_EDIT = "infra/k8s/worker.yaml"
    }

        stages {

        stage('Deployment File Creation') {
            steps{
                sh 'pip3 install pyyaml'
                sh 'python3 scripts/k8s_deployment_yaml_customize.py'
            }
        }


        stage('Bot Deploy') {
            steps {
                withCredentials([
                    file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')
                ]) {
                    sh '''
                    # apply the configurations to k8s cluster
                    kubectl apply --kubeconfig ${KUBECONFIG} -f ${K8S_DEPLOYMENT_FILE} --namespace=prod
                    '''
                }
            }
        }
    }
}


