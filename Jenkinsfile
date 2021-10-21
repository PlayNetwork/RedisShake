pipeline {
    agent {
        label 'golang'
    }
    parameters {
        booleanParam(name: "TEST_BOOLEAN", defaultValue: true, description: "Sample boolean parameter")
        string(name: "TEST_STRING", defaultValue: "ssbostan", trim: true, description: "Sample string parameter")
        text(name: "TEST_TEXT", defaultValue: "Jenkins Pipeline Tutorial", description: "Sample multi-line text parameter")
        password(name: "TEST_PASSWORD", defaultValue: "SECRET", description: "Sample password parameter")
        choice(name: "TEST_CHOICE", choices: ["production", "staging", "development"], description: "Sample multi-choice parameter")
    }

    stages {
		stage('build-par'){
			parallel{
		        stage('build-stage') {
		            environment {
						jpass = credentials('jenkins_registry_credentials')
		                env = 'staging'
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
		        stage('build-dev') {
		            environment {
						jpass = credentials('jenkins_registry_credentials')
		                env = 'dev'
		                source_cluster_ip = '10.100.100.100'
		                source_cluster_type = 'master'
		                source_cluster_port = '7000'
		                destination_cluster_ip = '22.222.222.222'
		                destination_cluster_type = 'slave'
		                destination_cluster_port = '9000'
		            }
		            steps {
		                sh 'make build'
		            }
		        }
		        stage('build-prod') {
		            environment {
						jpass = credentials('jenkins_registry_credentials')
						env = 'prod'
		                source_cluster_ip = '10.100.100.100'
		                source_cluster_type = 'master'
		                source_cluster_port = '7000'
		                destination_cluster_ip = '33.333.333.333'
		                destination_cluster_type = 'slave'
		                destination_cluster_port = '9000'
		            }
		            steps {
		                sh 'make build'
		            }
		        }
			}
		}

        stage('deploy') {
           environment {
				jpass = credentials('jenkins_registry_credentials')
				env = 'dev'
           }
            steps {
				sh 'pwd'
				sh 'ls -la'
				sh 'make deploy'
                sh 'echo deploy binary to target ec2 instance'
            }
        }
    }
}
