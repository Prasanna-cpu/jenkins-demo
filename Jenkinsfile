
pipeline {

    agent any

    tools {
        jdk 'JDK25'
        maven 'Maven3'
    }

    stages {

        // 1. Checkout source code
        stage('Checkout') {
            steps {
                echo 'Fetching source code from GitHub...'
                checkout scm
            }
        }

        // 2. Compile Java application
        stage('Build') {
            steps {
                echo 'Building Java application using Maven...'
                bat 'mvn -B clean compile'
            }
        }

        // 3. Execute unit tests
        stage('Test') {
            steps {
                echo 'Executing JUnit tests...'
                bat 'mvn -B test'
            }
        }

        // 4. Package application into JAR
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

        // 5. Deploy application
        stage('Deploy') {
            steps {
                echo 'Deploying application...'

                bat '''
                powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "%WORKSPACE%\\deploy.ps1"
                '''
            }
        }

        // 6. Verify deployed application
        stage('Smoke Test') {
            steps {
                echo 'Verifying deployed application...'

                bat '''
                powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "%WORKSPACE%\\smoke-test.ps1"
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
