all: 
	./build.sh

.PHONY: test

build:
ifeq ($(env),prod)
	# we call build.sh to create our golang binary
	@./build.sh

	# Here we pull env variables and pass them to our docker build from the pipeline
	docker login -u jenkins -p ${jpass} docker-apps.artifactory.tsp.cld.touchtunes.com

	docker build . \
	--no-cache \
	--build-arg source_cluster_ip=${source_cluster_ip} \
	--build-arg source_cluster_type=${source_cluster_type} \
	--build-arg source_cluster_port=${source_cluster_port} \
	--build-arg destination_cluster_ip=${destination_cluster_ip} \
	--build-arg destination_cluster_type=${destination_cluster_type} \
	--build-arg destination_cluster_port=${destination_cluster_port} \
	-t red

	docker tag red docker-apps.artifactory.tsp.cld.touchtunes.com/docker-apps-prod-local/redis-shake
	docker push docker-apps.artifactory.tsp.cld.touchtunes.com/docker-apps-prod-local/redis-shake
else
	# we call build.sh to create our golang binary for env that is not prod
	@./build.sh

	# Here we pull env variables and pass them to our docker build from the pipeline
	docker login -u jenkins -p ${jpass} docker-apps-${env}.artifactory.tsp.cld.touchtunes.com

	docker build . \
	--no-cache \
	--build-arg source_cluster_ip=${source_cluster_ip} \
	--build-arg source_cluster_type=${source_cluster_type} \
	--build-arg source_cluster_port=${source_cluster_port} \
	--build-arg destination_cluster_ip=${destination_cluster_ip} \
	--build-arg destination_cluster_type=${destination_cluster_type} \
	--build-arg destination_cluster_port=${destination_cluster_port} \
	-t red 

	docker tag red docker-apps-${env}.artifactory.tsp.cld.touchtunes.com/redis-shake-${env}
	docker push docker-apps-${env}.artifactory.tsp.cld.touchtunes.com/redis-shake-${env}
endif

clean:
	rm -rf bin
	rm -rf *.pprof
	rm -rf *.output
	rm -rf logs
	rm -rf diagnostic/
	rm -rf *.pid
	
