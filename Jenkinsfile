pipeline {
    agent {
        label 'golang'
    }
    stages {
        stage('local') {
            environment {
                source_cluster_ip = '10.100.100.100'
                source_cluster_type = 'master'
                source_cluster_port = '7000'
                destination_cluster_ip = '11.111.111.111'
                destination_cluster_type = 'slave'
                destination_cluster_port = '9000'
            }
            steps {
                sh 'make build'
            }
        }
        stage('deploy') {
            steps {
                sh 'echo deploy binary to target ec2 instance'
            }
        }
    }
}
