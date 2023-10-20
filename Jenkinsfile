pipeline {
  agent any
  stages {
    stage('Check-out') {
      steps {
        git(url: 'https://github.com/npetmark/TestWebApp.git', branch: 'main')
      }
    }

    stage('Build') {
      steps {
        echo 'Build'
      }
    }

    stage('Test') {
      steps {
        echo 'Test'
      }
    }

    stage('Deploy') {
      steps {
        echo 'Test'
      }
    }

  }
}