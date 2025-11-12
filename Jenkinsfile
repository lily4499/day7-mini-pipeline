pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'docker build -t laly9999/demo-node:ci .'
      }
    }
    stage('Test (simple)') {
      steps {
        sh '''
          set -e
          # clean any old container name
          docker rm -f ci-demo >/dev/null 2>&1 || true

          # 1) run in background so Jenkins doesn't hang
          docker run -d --rm --name ci-demo laly9999/demo-node:ci node app.js

          # 2) give it a moment to start
          sleep 3

          # 3) check recent logs for the startup line
          docker logs --tail 20 ci-demo | tee /dev/stderr | grep -i "listening" >/dev/null

          # 4) stop it (pipeline continues)
          docker stop ci-demo >/dev/null
        '''
      }
    }
  }
  post {
    always {
      echo 'Pipeline finished'
    }
  }
}

