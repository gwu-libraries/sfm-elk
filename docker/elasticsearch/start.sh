#!/bin/bash

# create data directory
if [ ! -d "/sfm-data/elk/$HOSTNAME/data" ]; then
    # This will only run once.
    echo "Creating elasticsearch data directory"
    su-exec root mkdir -p /sfm-data/elk/$HOSTNAME/data
    su-exec root chown elasticsearch /sfm-data/elk/$HOSTNAME/data
fi

# create logs directory
if [ ! -d "/sfm-data/elk/$HOSTNAME/logs" ]; then
    # This will only run once.
    echo "Creating elasticsearch logs directory"
    su-exec root mkdir -p /sfm-data/elk/$HOSTNAME/logs
    su-exec root chown elasticsearch /sfm-data/elk/$HOSTNAME/logs
fi

# config the data path
if ! grep -Fqx "path.data: /sfm-data/elk/$HOSTNAME/data" /usr/share/elasticsearch/config/elasticsearch.yml; then
    echo "Adding path.data to elasticsearch.yml"
    su-exec root echo path.data: /sfm-data/elk/$HOSTNAME/data >> /usr/share/elasticsearch/config/elasticsearch.yml
fi

# config the logs path
if ! grep -Fqx "path.logs: /sfm-data/elk/$HOSTNAME/logs" /usr/share/elasticsearch/config/elasticsearch.yml; then
    echo "Adding path.logs to elasticsearch.yml"
    su-exec root echo path.logs: /sfm-data/elk/$HOSTNAME/logs >> /usr/share/elasticsearch/config/elasticsearch.yml
fi

# start the elasticsearch
su-exec elasticsearch /usr/share/elasticsearch/bin/es-docker &

echo "Waiting for elasticsearch and kibana"
appdeps.py --port-wait localhost:9200 --wait-secs $WAIT_SECS --file-wait /sfm-data/collection_set --file-wait /sfm-data/containers
if [ "$?" = "1" ]; then
    echo "Problem with application dependencies."
    exit 1
fi

wait