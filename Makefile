all: 
	./build.sh

.PHONY: test run

build:
ifeq ($(env),prod)
	# we call build.sh to create our golang binary
	@./build.sh

	# Here we pull env variables and pass them to our docker build from the pipeline
	docker login -u jenkins -p ${jpass_PSW} docker-apps-prod-local.artifactory.tsp.cld.touchtunes.com

	docker build . \
	--no-cache \
	--build-arg source_cluster_ip=${source_cluster_ip} \
	--build-arg source_cluster_type=${source_cluster_type} \
	--build-arg source_cluster_port=${source_cluster_port} \
	--build-arg destination_cluster_ip=${destination_cluster_ip} \
	--build-arg destination_cluster_type=${destination_cluster_type} \
	--build-arg destination_cluster_port=${destination_cluster_port} \
	-t red

	docker tag red docker-apps-prod-local.artifactory.tsp.cld.touchtunes.com/docker-apps-prod-local/redis-shake
	docker push docker-apps-prod-local.artifactory.tsp.cld.touchtunes.com/docker-apps-prod-local/redis-shake
else
	@./build.sh
	docker login -u jenkins -p ${jpass_PSW} docker-apps-${env}.artifactory.tsp.cld.touchtunes.com

	docker build . \
	--no-cache \
	--build-arg source_cluster_ip=${source_cluster_ip} \
	--build-arg source_cluster_type=${source_cluster_type} \
	--build-arg source_cluster_port=${source_cluster_port} \
	--build-arg destination_cluster_ip=${destination_cluster_ip} \
	--build-arg destination_cluster_type=${destination_cluster_type} \
	--build-arg destination_cluster_port=${destination_cluster_port} \
	-t red 

	docker tag red docker-apps-${env}-local.artifactory.tsp.cld.touchtunes.com/redis-shake-${env}
	docker push docker-apps-${env}-local.artifactory.tsp.cld.touchtunes.com/redis-shake-${env}
endif

# figure out how template body works in jenkins
# figure  out how to use "file" for jenkins
deploy:
ifeq ($(env),prod)
	aws --profile=${env} \
	cloudformation create-stack \
	--stack-name redis-shake \
	--parameters \
		ParameterKey=JenkinsPassword,ParameterValue=${jpass_PSW} \
		ParameterKey=JenkinsUser,ParameterValue=jenkins \
	--template-body file:///Users/vpotra/work/git/RedisShake/cf.json
else
	aws --profile=${env} \
	cloudformation create-stack \
	--stack-name redis-shake-${env} \
	--parameters \
		ParameterKey=JenkinsPassword,ParameterValue=${jpass_PSW} \
		ParameterKey=JenkinsUser,ParameterValue=jenkins \
	--template-body file:///tmp/workspace/build-redisshake/cf.json
endif

# only for dev or stage
# you must export your env
deploy_from_local:
	aws --profile=${env} \
	cloudformation create-stack \
	--stack-name redis-shake-${env} \
	--parameters \
		ParameterKey=JenkinsPassword,ParameterValue=${jpass_PSW} \
		ParameterKey=JenkinsUser,ParameterValue=jenkins \
		ParameterKey=Env,ParameterValue=${env} \
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
