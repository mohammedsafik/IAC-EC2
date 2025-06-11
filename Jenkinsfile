pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        EC2_USER = 'ec2-user'
        PEM_FILE = 'my-key.pem'
    }

    stages {
        stage('Terraform Init & Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Fetch EC2 IP') {
            steps {
                script {
                    def ec2Ip = sh(script: "cd terraform && terraform output -raw instance_ip", returnStdout: true).trim()
                    env.EC2_IP = ec2Ip
                    echo "Provisioned EC2 Public IP: http://${env.EC2_IP}:80"
                }
            }
        }

        stage('Copy Setup Script & Run') {
            steps {
                sh '''
                    chmod 400 ${PEM_FILE}
                    scp -o StrictHostKeyChecking=no -i ${PEM_FILE} scripts/setup-docker.sh ${EC2_USER}@${EC2_IP}:/home/ec2-user/
                    ssh -o StrictHostKeyChecking=no -i ${PEM_FILE} ${EC2_USER}@${EC2_IP} 'bash setup-docker.sh'
                '''
            }
        }

        stage('Success Output') {
            steps {
                echo "✅ NGINX is deployed at: http://${env.EC2_IP}:80"
            }
        }
    }
}
