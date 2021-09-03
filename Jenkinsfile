pipeline {
  agent {golang}
  stages {
    stage("local") {
      steps {
		sh 'make build'
      }
    }
    stage("deploy") {
      steps {
        sh 'echo deploy binary to target ec2 instance'
      }
    }
  }
}
