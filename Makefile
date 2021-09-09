all: 
	./build.sh

build:
	# we call build.sh to create our golang binary
	@./build.sh

	# Here we pull env variables and pass them to our docker build from the pipeline
	docker login docker-apps-dev.artifactory.tsp.cld.touchtunes.com

	docker build . \
	--no-cache \
	--build-arg source_cluster_ip=${source_cluster_ip} \
	--build-arg source_cluster_type=${source_cluster_type} \
	--build-arg source_cluster_port=${source_cluster_port} \
	--build-arg destination_cluster_ip=${destination_cluster_ip} \
	--build-arg destination_cluster_type=${destination_cluster_type} \
	--build-arg destination_cluster_port=${destination_cluster_port} \
	-t test

	docker tag test docker-apps-dev.artifactory.tsp.cld.touchtunes.com/docker-apps-test/test
	docker push docker-apps-dev.artifactory.tsp.cld.touchtunes.com/docker-apps-test/test

clean:
	rm -rf bin
	rm -rf *.pprof
	rm -rf *.output
	rm -rf logs
	rm -rf diagnostic/
	rm -rf *.pid
	
