pipeline {
    agent {
        label 'golang'
    }
    parameters {
        choice(name: "ENVIRONMENT", choices: ["stage", "dev","prod"], description: "Choose which env we deploy too")
        string(name: "source_cluster_ip", defaultValue: "10.0.0.1", trim: true, description: "The redis cluster source ip or the dns ")
        string(name: "source_cluster_port", defaultValue: "9999", trim: true, description: "The port redis listens on")
        string(name: "source_cluster_type", defaultValue: "cluster", trim: true, description: "The redis source type, such as individual or cluster, this should generally always be cluster")


        string(name: "destination_cluster_ip", defaultValue: "10.0.0.1", trim: true, description: "The redis cluster destination ip or the dns ")
        string(name: "destination_cluster_port", defaultValue: "9999", trim: true, description: "The port redis listens on")
        string(name: "destination_cluster_type", defaultValue: "cluster", trim: true, description: "The redis destination type, such as individual or cluster, this should generally always be cluster")
    }

    stages {
		stage('build-par'){
			parallel{
		        stage('build-stage') {
		            environment {
						jpass = credentials('jenkins_registry_credentials')
		                env = 'staging'
		            }
		            steps {
		                sh 'make build'
		            }
		        }
		        stage('build-dev') {
		            environment {
						jpass = credentials('jenkins_registry_credentials')
		                env = 'dev'
		            }
		            steps {
		                sh 'make build'
		            }
		        }
		        stage('build-prod') {
		            environment {
						jpass = credentials('jenkins_registry_credentials')
						env = 'prod'
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
				source_ip = "$params.source_cluster_ip"
				source_type = "$params.source_cluster_type"
				source_port = "$params.source_cluster_port"
				destination_ip = "$params.destination_cluster_ip"
				destination_type = "$params.destination_cluster_type"
				destination_port = "$params.destination_cluster_port"
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
