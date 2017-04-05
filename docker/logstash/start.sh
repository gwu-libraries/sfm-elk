#!/bin/bash

# STEP-0 Initial install for sfm
gosu root /opt/sfm-setup/setup_reqs.sh

# STEP-1 Waiting for elasticsearch, mq kibana
echo "Waiting for elasticsearch, mq and kibana"
appdeps.py --port-wait mq:5672 --port-wait elasticsearch:9200 --port-wait kibana:5601 --wait-secs $WAIT_SECS
if [ "$?" = "1" ]; then
    echo "Problem with application dependencies."
    exit 1
fi

# STEP-2 Check whether elasticsearch status is not red, if it's red wait 30 seconds to try again
curl -s -XGET elasticsearch:9200/_cluster/health | grep "\"status\":\"red\"" 2>/dev/null 1>/dev/null
until [  $? -eq 1 ]; do
    echo "elasticsearch status is red, wait 30 seconds to try again."
    sleep 30
    curl -s -XGET elasticsearch:9200/_cluster/health | grep "\"status\":\"red\"" 2>/dev/null 1>/dev/null
done

# STEP-3 running the logstash
gosu logstash python sfm_elk_loader.py mq $RABBITMQ_USER $RABBITMQ_PASSWORD elk_loader_$HOSTNAME --debug=$DEBUG $* &

wait
