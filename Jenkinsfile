pipeline {

    agent any

    tools {
        jdk 'JDK25'
        maven 'Maven3'
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Fetching source code from GitHub...'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Building Java application using Maven...'
                bat 'mvn -B clean compile'
            }
        }

        stage('Test') {
            steps {
                echo 'Executing JUnit tests...'
                bat 'mvn -B test'
            }
        }

        stage('Package') {
            steps {
                echo 'Packaging application into JAR...'
                bat 'mvn -B package -DskipTests'

                archiveArtifacts(
                    artifacts: 'target/*.jar',
                    fingerprint: true
                )
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application...'

                bat '''
                powershell.exe -NoProfile -ExecutionPolicy Bypass -File deploy.ps1
                '''
            }
        }

        stage('Smoke Test') {
            steps {
                echo 'Verifying deployed application...'

                bat '''
                powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "
                    $response = $null

                    for ($i = 0; $i -lt 15; $i++) {
                        try {
                            $response = Invoke-RestMethod `
                                -Uri 'http://localhost:8080/health' `
                                -TimeoutSec 3

                            break
                        }
                        catch {
                            Start-Sleep -Seconds 2
                        }
                    }

                    if ($response.status -ne 'UP') {
                        throw 'Application health check failed!'
                    }

                    Write-Host 'Application is healthy!'
                    Write-Host $response
                "
                '''
            }
        }
    }

    post {
        success {
            echo 'BUILD AND DEPLOYMENT SUCCESSFUL!'
        }

        failure {
            echo 'BUILD OR DEPLOYMENT FAILED!'
        }

        always {
            junit(
                testResults: 'target/surefire-reports/*.xml',
                allowEmptyResults: true
            )
        }
    }
}