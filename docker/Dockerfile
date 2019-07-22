# docker build -t david62243/elasticsearch:7.1node -f Dockerfile.1node .
FROM centos:7.5.1804

RUN groupadd -g 1000 elasticsearch && useradd elasticsearch -u 1000 -g 1000

RUN yum -y install epel-release && \
    yum -y install java-1.8.0-openjdk jq vim tmux && \
    echo "elasticsearch - nofile 65536" >> /etc/limits.conf && \
    echo "vm.max_map_count=262144" >> /etc/sysctl.conf


RUN rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
COPY files/elasticsearch.repo /etc/yum.repos.d/
RUN yum -y install elasticsearch

COPY files/3-node/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
COPY files/jvm.options /etc/elasticsearch/jvm.options

WORKDIR /usr/share/elasticsearch
RUN chown -R elasticsearch.elasticsearch /etc/elasticsearch

RUN mkdir /opt/elasticsearch && \
    chown -R elasticsearch.elasticsearch /opt/elasticsearch

USER elasticsearch

ENV PATH=$PATH:/usr/share/elasticsearch/bin

CMD ["elasticsearch"]

EXPOSE 9200 9300

