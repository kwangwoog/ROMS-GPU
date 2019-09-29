pipeline {
  agent {
    node {
      label 'docker'
    }

  }
  stages {
    stage('Build') {
      agent {
        node {
          label 'docker'
        }

      }
      steps {
        sh 'date && hostname'
      }
    }
  }
}