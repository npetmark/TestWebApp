pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'dotnet restore'
        sh 'dotnet build'
        echo 'Stage completed'
      }
    }

    stage('Test') {
      steps {
        sh 'dotnet test'
      }
    }

    stage('Deploy') {
      steps {
        echo 'Stage completed'
      }
    }

  }
}