pipeline {
    agent {
        docker {
            image 'ruby:2.5.1'
        }
    }
    environment {
        HEROKU_API_KEY = credentials('HEROKU_API_KEY')
    }
    stages {
        stage('Test') {
            steps {
                sh './scripts/cibuild.sh'
            }
        }
        stage('Stage') {
            when {
                changeRequest target: 'master'
            }
            steps {
                sh './scripts/heroku_release.sh sign-junkie-qa ${HEROKU_API_KEY}'
            }
        }
        stage('Deploy') {
            when {
                branch 'master'
            }
            steps {
                sh './scripts/heroku_release.sh sign-junkie-pd ${HEROKU_API_KEY}'
            }
        }
    }
    post {
        cleanup {
            cleanWs()
        }
    }
}
