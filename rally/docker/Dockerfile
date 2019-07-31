FROM ubuntu:18.04

# docker build -t satchpx/esrally:v0.1 .

RUN apt-get update && \
    apt-get -y install gcc python3-pip python3-dev git openjdk-8-jre tmux curl vim

ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64

RUN pip3 install esrally

RUN mkdir -p /root/.rally 

EXPOSE 8001/tcp

COPY rally.ini /root/.rally/rally.ini

WORKDIR /root
