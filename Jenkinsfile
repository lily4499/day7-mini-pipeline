pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        echo 'Building Docker image...'
        sh 'docker build -t laly9999/demo-node:ci .'
      }
    }
    stage('Test') {
      steps {
        echo 'Running container...'
        sh 'docker run --rm laly9999/demo-node:ci node app.js'
      }
    }
  }
  post {
    always {
      echo 'Pipeline finished'
    }
  }
}

