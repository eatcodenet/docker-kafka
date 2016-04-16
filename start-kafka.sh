#!/bin/bash

# Optional ENV variables:
# * ADVERTISED_HOST: the external ip for the container, e.g. `docker-machine ip \`docker-machine active\``
# * ADVERTISED_PORT: the external port for Kafka, e.g. 9092

# Set the external host and port
if [ ! -z "$ADVERTISED_HOST" ]; then
    echo "advertised host: $ADVERTISED_HOST"
    sed -r -i "s/#(advertised.host.name)=(.*)/\1=$ADVERTISED_HOST/g" $KAFKA_HOME/config/server.properties
fi

if [ ! -z "$ADVERTISED_PORT" ]; then
    echo "advertised port: $ADVERTISED_PORT"
    sed -r -i "s/#(advertised.port)=(.*)/\1=$ADVERTISED_PORT/g" $KAFKA_HOME/config/server.properties
fi

if [ ! -z "$ZOOKEEPER_CONNECT" ]; then
    zk_port=$(cut -d':' -f2 <<< $ZOOKEEPER_CONNECT)
    # no port. add default port
    if [ "$zk_port" == "$ZOOKEEPER_CONNECT" ]; then
      ZOOKEEPER_CONNECT="$ZOOKEEPER_CONNECT:2181"
    fi
    echo "zookeeper connect: $ZOOKEEPER_CONNECT"
    sed -r -i "s/(zookeeper\.connect)=(.*)/\1=$ZOOKEEPER_CONNECT/g" $KAFKA_HOME/config/server.properties
fi

# Wait for zookeeper
/usr/bin/wait-for-zookeeper.sh 5

# Capture ctrlc
trap "$KAFKA_HOME/bin/kafka-server-stop.sh; echo 'Kafka stopped.'; exit" SIGHUP SIGINT SIGTERM

# Run Kafka
$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
