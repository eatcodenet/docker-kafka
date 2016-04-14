FROM eatcode/openjdk8

MAINTAINER Ayub Malik <ayub.malik@gmail.com>

WORKDIR /opt

ENV KAFKA_VERSION 0.9.0.1

LABEL name="kafka" version="$KAFKA_VERSION"

RUN wget -q -O - http://mirrors.ukfast.co.uk/sites/ftp.apache.org/kafka/0.9.0.1/kafka_2.11-0.9.0.1.tgz | tar -xzf - -C /opt \
    && ln -s /opt/kafka_2.11-$KAFKA_VERSION /opt/kafka

ENV KAFKA_HOME /opt/kafka

LABEL name="buildNumber" value="102"

WORKDIR /opt/kafka

ADD server.properties config/server.properties

ADD start-kafka.sh /usr/bin/start-kafka.sh

ADD wait-for-it.sh /usr/bin/wait-for-it.sh

ADD wait-for-zookeeper.sh /usr/bin/wait-for-zookeeper.sh

EXPOSE 9092

CMD /usr/bin/start-kafka.sh
