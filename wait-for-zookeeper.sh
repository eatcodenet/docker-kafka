#!/bin/sh
base_dir="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
timeout=5
config_file=$KAFKA_HOME/config/server.properties
connect_string=$(grep 'zookeeper.connect=' ${config_file})
hosts=$(cut -d'=' -f2 <<< ${connect_string} | tr ',' ' ')

for host in ${hosts}; do
  ${base_dir}/wait-for-it.sh ${host} -t ${timeout}
done
