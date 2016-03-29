FROM eatcode/openjdk8

MAINTAINER Ayub Malik <ayub.malik@gmail.com>

WORKDIR /opt

ENV KAFKA_VERSION 0.9.0.1

LABEL name="kafka" version="$KAFKA_VERSION"

RUN wget -q -O - http://mirror.ox.ac.uk/sites/rsync.apache.org/kafka/$KAFKA_VERSION/kafka_2.11-$KAFKA_VERSION.tgz | tar -xzf - -C /opt \
    && ln -s /opt/kafka_2.11-$KAFKA_VERSION /opt/kafka

ENV KAFKA_HOME /opt/kafka

LABEL name="buildNumber" value="100"

WORKDIR /opt/kafka

ADD server.properties config/server.properties

ADD start-kafka.sh /usr/bin/start-kafka.sh

EXPOSE 9092

ENTRYPOINT ["/usr/bin/start-kakfa.sh"]

