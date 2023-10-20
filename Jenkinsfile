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
        sh 'sh "dotnet restore ${workspace}**/*.sln"'
        sh 'sh "msbuild.exe ${workspace}**/*.sln /nologo /nr:false /p:platform=\\"x64\\" /p:configuration=\\"release\\" /t:clean"'
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