pipeline {
    agent any

    stages {
        stage("Code Clone") {
            steps {
                git url: "https://github.com/onkarlonkar9/strapi-devops.git", branch: "main"
            }
        }

        stage("Build") {
            steps {
                sh "docker build -t strapi-prod ."
            }
        }

        stage("Test") {
            steps {
                echo "Developer will test the application"
            }
        }

        stage("Push to DockerHub") {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerHubCreds',
                    passwordVariable: 'PASS',
                    usernameVariable: 'USERNAME'
                )]) {
                    sh "docker login -u $USERNAME -p $PASS"
                    sh "docker tag strapi-prod $USERNAME/strapi-prod:latest"
                    sh "docker push $USERNAME/strapi-prod:latest"
                }
            }
        }

        stage("Deploy") {
            steps {
                sh "docker compose up -d"
            }
        }
    }

    post {
        success {
            script {
                emailext(
                    from: "omkarlonkar46@gmail.com",
                    to: "onkarlonkar018@gmail.com",
                    subject: "✅Build Success: Strapi CI/CD",
                    body: " The build and deployment for Strapi CI/CD completed successfully!"
                )
            }
        }

        failure {
            script {
                emailext(
                    from: "omkarlonkar46@gmail.com",
                    to: "onkarlonkar018@gmail.com",
                    subject: "❌Build Failed: Strapi CI/CD",
                    body: " The build for Strapi CI/CD has failed. Check Jenkins logs for details."
                )
            }
        }
    }
}
