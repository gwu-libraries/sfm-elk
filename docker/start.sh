#!/bin/bash

/opt/sfm-setup/setup_reqs.sh

echo logging.quiet: true >> /opt/kibana/config/kibana.yml

mkdir -p /sfm-data/elk/$HOSTNAME/data
chown elasticsearch /sfm-data/elk/$HOSTNAME/data
echo path.data: /sfm-data/elk/$HOSTNAME/data >> /etc/elasticsearch/elasticsearch.yml

/usr/local/bin/start.sh &

echo "Waiting for elk"
appdeps.py --port-wait mq:5672 --port-wait localhost:9200 --port-wait localhost:5601 --wait-secs 60
if [ "$?" = "1" ]; then
    echo "Problem with application dependencies."
    exit 1
fi

python elk_config_loader.py

python sfm_elk_loader.py mq $RABBITMQ_USER $RABBITMQ_PASSWORD elk_loader_$HOSTNAME --debug=$DEBUG $* &

wait