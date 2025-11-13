pipeline {
  agent any
  environment {
    DOCKERHUB_USER = 'laly9999'
    IMAGE_NAME = 'hello-ci'
    KUBE_CONFIG = '/var/jenkins_home/.kube/config'
  }
  stages {
    stage('Build') {
      steps {
        sh 'docker build -t $DOCKERHUB_USER/$IMAGE_NAME:$BUILD_NUMBER .'
      }
    }
    stage('Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          sh 'echo $PASS | docker login -u $USER --password-stdin'
          sh 'docker push $DOCKERHUB_USER/$IMAGE_NAME:$BUILD_NUMBER'
        }
      }
    }
    stage('Deploy') {
      steps {
        sh '''
          sed -i "s#laly9999/hello-ci:.*#laly9999/hello-ci:${BUILD_NUMBER}#g" deployment.yaml
          kubectl apply -f deployment.yaml --kubeconfig=$KUBE_CONFIG
          kubectl rollout status deployment/hello-k8s
        '''
      }
    }
  }
}

