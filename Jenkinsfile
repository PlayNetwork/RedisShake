pipeline {
    agent {
        label 'golang'
    }
    parameters {
        choice(name: "ENVIRONMENT", choices: ["production", "staging", "development"], description: "Choose which env we deploy too")
        string(name: "Source cluster ip", defaultValue: "10.0.0.1", trim: true, description: "The redis cluster source ip or the dns ")
        string(name: "Source cluster port", defaultValue: "9999", trim: true, description: "The port redis listens on")
        string(name: "Source cluster type", defaultValue: "cluster", trim: true, description: "The redis source type, such as individual or cluster, this should generally always be cluster")


        string(name: "Destination cluster ip", defaultValue: "10.0.0.1", trim: true, description: "The redis cluster destination ip or the dns ")
        string(name: "Destination cluster port", defaultValue: "9999", trim: true, description: "The port redis listens on")
        string(name: "Destination cluster type", defaultValue: "cluster", trim: true, description: "The redis destination type, such as individual or cluster, this should generally always be cluster")
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
