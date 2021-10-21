all: 
	./build.sh

# We have to use an if else, since there is different naming for the root repositories. Aka docker-apps and docker-apps-<stage|dev>-
.PHONY: test run
build:
ifeq ($(env),prod)
	# we call build.sh to create our golang binary
	@./build.sh

	# Here we pull env variables and pass them to our docker build from the pipeline
	docker login -u jenkins -p ${jpass_PSW} docker-apps-prod-local.artifactory.tsp.cld.touchtunes.com

	docker build . \
	--no-cache \
	-t red

	docker tag red docker-apps-prod-local.artifactory.tsp.cld.touchtunes.com/docker-apps-prod-local/redis-shake
	docker push docker-apps-prod-local.artifactory.tsp.cld.touchtunes.com/docker-apps-prod-local/redis-shake
else
	@./build.sh
	docker login -u jenkins -p ${jpass_PSW} docker-apps-${env}.artifactory.tsp.cld.touchtunes.com

	docker build . \
	--no-cache \
	-t red 

	docker tag red docker-apps-${env}-local.artifactory.tsp.cld.touchtunes.com/redis-shake-${env}:${BUILD_NUMBER}
	docker tag red docker-apps-${env}-local.artifactory.tsp.cld.touchtunes.com/redis-shake-${env}:latest

	docker push docker-apps-${env}-local.artifactory.tsp.cld.touchtunes.com/redis-shake-${env}
endif

deploy:
ifeq ($(env),prod)
	aws --profile=${env} \
	cloudformation create-stack \
	--stack-name redis-shake \
	--parameters \
		ParameterKey=JenkinsPassword,ParameterValue=${jpass_PSW} \
		ParameterKey=JenkinsUser,ParameterValue=jenkins \
		ParameterKey=sourceIp,ParameterValue=${source_ip} \
		ParameterKey=sourcePort,ParameterValue=${source_port} \
		ParameterKey=sourceType,ParameterValue=${source_type} \
		ParameterKey=destinationIp,ParameterValue=${destination_ip} \
		ParameterKey=destinationPort,ParameterValue=${destination_port} \
		ParameterKey=destinationType,ParameterValue=${destination_type} \

	--template-body file:///Users/<filepath>/cf.json
else
	aws --profile=${env} \
	cloudformation create-stack \
	--stack-name redis-shake-${env} \
	--parameters \
		ParameterKey=JenkinsPassword,ParameterValue=${jpass_PSW} \
		ParameterKey=JenkinsUser,ParameterValue=jenkins \
		ParameterKey=sourceIp,ParameterValue=${source_ip} \
		ParameterKey=sourcePort,ParameterValue=${source_port} \
		ParameterKey=sourceType,ParameterValue=${source_type} \
		ParameterKey=destinationIp,ParameterValue=${destination_ip} \
		ParameterKey=destinationPort,ParameterValue=${destination_port} \
		ParameterKey=destinationType,ParameterValue=${destination_type} \
	--template-body file:///tmp/workspace/build-redisshake/cf.json
endif

# only for dev or stage
# you must use your local file path for the json
# you must export your env
deploy_from_local:
	aws --profile=${env} \
	cloudformation create-stack \
	--stack-name redis-shake-${env} \
	--parameters \
		ParameterKey=JenkinsPassword,ParameterValue=${jpass_PSW} \
		ParameterKey=JenkinsUser,ParameterValue=jenkins \
		ParameterKey=Env,ParameterValue=${env} \
# replace this line with the location of your cloud formation json
	--template-body file:///Users/vpotra/work/git/RedisShake/cf.json

# Write the command to the shell for testing
echo_command:
	@echo "docker run -it  \
	-e source_cluster_ip=test \
	-e source_cluster_type=test1 \
	-e source_cluster_port=test2 \
	-e destination_cluster_ip=test3 \
	-e destination_cluster_type=test4 \
	-e destination_cluster_port=test5 \
	test bash"
