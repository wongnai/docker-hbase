FROM openjdk:8-jdk-buster

ARG HBASE_VERSION=2.3.3

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install wget unzip \
    && apt-get -y autoremove \
    && apt-get -y clean

RUN cd /tmp \
    && wget https://archive.apache.org/dist/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz \
    && mkdir -p /opt/hbase \
    && tar --strip 1 -xzvf hbase-${HBASE_VERSION}-bin.tar.gz -C /opt/hbase \
    && groupadd hadoop \
	&& useradd -m -d /opt/hbase -g hadoop hbase \
	&& chown -R hbase:hadoop /opt/hbase \
    && rm -f /tmp/hbase-${HBASE_VERSION}-bin.tar.gz

USER hbase

VOLUME ["/opt/hbase/conf", "/opt/hbase/logs", "/opt/hbase/data"]

COPY hbase/ /opt/hbase/

CMD [ "/opt/hbase/bin/start.sh" ]
