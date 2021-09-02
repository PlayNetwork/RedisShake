FROM busybox

COPY ./bin/redis-shake.linux /usr/local/app/redis-shake
COPY ./conf/redis-shake.conf /usr/local/app/redis-shake.conf

# Default type is sync unless we override it.
# this is the parameter that is desired to continously stream from cluster a to cluster b
ENV TYPE sync
ARG source_cluster_ip
ARG source_cluster_type
ARG source_cluster_port
ARG destination_cluster_ip
ARG destination_cluster_type
ARG destination_cluster_port

ENV source_cluster_ip=${source_cluster_ip}
ENV source_cluster_type=${source_cluster_type}
ENV source_cluster_port=${source_cluster_port}
ENV destination_cluster_ip=${destination_cluster_ip}
ENV destination_cluster_type=${destination_cluster_type}
ENV destination_cluster_port=${destination_cluster_port}
# We here give the type of node that we are targeting aka "slave" since we want to read from the source replicas from the cluster not the masters

# example of final "source.address" parameter passed to redis-shake.conf slave@10.133.31.143:7000
RUN echo $source_cluster_ip &&\
	echo $source_cluster_type

RUN env

# example of final "destination.address" parameter passed to redis-shake.conf slave@10.133.31.143:7000

CMD /usr/local/app/redis-shake -type=${TYPE} -conf=/usr/local/app/redis-shake.conf
