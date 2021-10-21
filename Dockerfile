FROM ubuntu

COPY ./bin/redis-shake.linux /usr/local/app/redis-shake
COPY ./conf/redis-shake.conf /usr/local/app/redis-shake.conf

# We pass the Args from --build-arg to ENV, so we can re-use these params throught the file
ARG source_cluster_ip
ARG source_cluster_type
ARG source_cluster_port
ARG destination_cluster_ip
ARG destination_cluster_type
ARG destination_cluster_port

ENV TYPE sync
ENV source_cluster_ip=${source_cluster_ip}
ENV source_cluster_type=${source_cluster_type}
ENV source_cluster_port=${source_cluster_port}
ENV destination_cluster_ip=${destination_cluster_ip}
ENV destination_cluster_type=${destination_cluster_type}
ENV destination_cluster_port=${destination_cluster_port}


# with the runtime command and the cmd sed, we can either build this container with env statically or dynamically at runtime
RUN apt-get update && \
apt-get -y install wondershaper

CMD sed -i "s/parallel = 32/parallel = 16/g" /usr/local/app/redis-shake.conf && \
sed -i "s/source\.type = standalone/source\.type = cluster/g" /usr/local/app/redis-shake.conf && \
sed -i "s/source\.address = 127.0.0.1:20441/source\.address = ${source_cluster_type}@${source_cluster_ip}:${source_cluster_port}/g" /usr/local/app/redis-shake.conf && \
sed -i "s/target\.type = standalone/target\.type = cluster/g" /usr/local/app/redis-shake.conf && \
sed -i "s/target\.address = 127.0.0.1:6379/target\.address = ${destination_cluster_type}@${destination_cluster_ip}:${source_cluster_port}/g" /usr/local/app/redis-shake.conf &&\
wondershaper eth0 52428800 52428800 && /usr/local/app/redis-shake -type=${TYPE} -conf=/usr/local/app/redis-shake.conf
