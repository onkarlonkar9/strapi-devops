pipeline {
    agent any

    environment {
        SONAR_HOME = tool "sonar"
    }

    stages {

        stage("Code Clone") {
            steps {
                git url: "https://github.com/onkarlonkar9/strapi-devops.git", branch: "main"
            }
        }
        
         stage("Sonar Quality Analysis") {
            steps {
                withSonarQubeEnv("sonar") {
                    sh """
                        $SONAR_HOME/bin/sonar-scanner \
                        -Dsonar.projectKey=strapi \
                        -Dsonar.projectName=strapi \
                        -Dsonar.sources=.
                    """
                }
            }
        }
         stage("OWASP Dependency Check") {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --format XML --out .', odcInstallation: 'OWASP'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

        stage("Sonar Quality Gate Scan") {
            steps {
                timeout(time: 2, unit: "MINUTES") {
                    waitForQualityGate abortPipeline: false
                }
            }
        }
        
        stage("Trivy Scan") {
            steps {
                sh '''
                    echo "Running Trivy File System Scan..."
                    trivy fs --exit-code 1 --severity HIGH,CRITICAL --format table -o trivy-fs-report.html .
                '''
            }
        }

        stage("Build Docker Image") {
            steps {
                sh "docker build -t strapi-prod ."
            }
        }

        stage("Test") {
            steps {
                echo "Running manual/automated tests"
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
                sh '''
                    echo "🚀 Deploying using Docker Compose..."
                    docker compose up -d
                '''
            }
        }
    }

    post {
        success {
            script {
                emailext(
                    from: "omkarlonkar46@gmail.com",
                    to: "onkarlonkar018@gmail.com",
                    subject: "✅ Build Success: Strapi CI/CD",
                    body: "The Strapi CI/CD pipeline completed successfully."
                )
            }
        }
        failure {
            script {
                emailext(
                    from: "omkarlonkar46@gmail.com",
                    to: "onkarlonkar018@gmail.com",
                    subject: "❌ Build Failed: Strapi CI/CD",
                    body: "The Strapi CI/CD build has failed. Check Jenkins logs for details."
                )
            }
        }
    }
}
