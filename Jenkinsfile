pipeline {
  agent any
  options {
    timestamps()
    ansiColor('xterm')
  }
  environment {
    DOCKERHUB_USER = 'laly9999'
    IMAGE_NAME     = 'hello-ci'
    IMAGE_TAG      = "${BUILD_NUMBER}"
    IMAGE          = "${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
    // Jenkins runs directly on WSL Ubuntu:
    KUBECONFIG     = '/var/lib/jenkins/.kube/config'
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/lily4499/day7-mini-pipeline.git'
      }
    }

    stage('Build') {
      steps {
        sh 'set -e; docker build -t "$IMAGE" .'
      }
    }

    stage('Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          sh '''
            set -e
            echo "$PASS" | docker login -u "$USER" --password-stdin
            docker push "$IMAGE"
            docker logout || true
          '''
        }
      }
    }

    stage('Deploy') {
      steps {
        sh '''
          #set -euo pipefail

          # Ensure we’re talking to the right cluster
          kubectl config current-context
          kubectl get nodes

          # Create/Update k8s objects (idempotent)
          kubectl apply -f service.yaml
          kubectl apply -f deployment.yaml

          # Update deployment to this build’s image
          kubectl set image deployment/hello-k8s \
            hello-k8s="$IMAGE"

          # Wait for rollout to finish
          kubectl rollout status deployment/hello-k8s --timeout=180s

          # Quick verify
          kubectl get deploy,rs,pods -l app=hello-k8s -o wide
          kubectl get svc hello-k8s-service -o wide
        '''
      }
    }
  }

  post {
    success {
      echo "✅ Deployed image: ${IMAGE}"
    }
    failure {
      echo "❌ Deploy failed. Showing recent pod events/logs (best effort)…"
      sh '''
        kubectl describe deploy/hello-k8s || true
        POD=$(kubectl get pods -l app=hello-k8s -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)
        [ -n "$POD" ] && kubectl logs --tail=200 "$POD" || true
      '''
    }
    always {
      echo "Pipeline complete."
    }
  }
}

