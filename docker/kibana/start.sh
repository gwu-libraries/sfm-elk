#!/bin/bash

# STEP-1 Waiting for elasticsearch
echo "Waiting for elasticsearch"
appdeps.py --port-wait elasticsearch:9200 --wait-secs $WAIT_SECS
if [ "$?" = "1" ]; then
    echo "Problem with elasticsearch start up."
    exit 1
fi

# STEP-2 Check whether elasticsearch status is not red, if it's red wait 30 seconds to try again
curl -s -XGET elasticsearch:9200/_cluster/health | grep "\"status\":\"red\"" 2>/dev/null 1>/dev/null
until [  $? -eq 1 ]; do
    echo "elasticsearch status is red, wait 30 seconds to try again."
    sleep 30
    curl -s -XGET elasticsearch:9200/_cluster/health | grep "\"status\":\"red\"" 2>/dev/null 1>/dev/null
done

# STEP-3 start up kibana
/usr/local/bin/kibana-docker &

# STEP-4 Check kibana start up
echo "Waiting for kibana"
appdeps.py --port-wait localhost:5601 --wait-secs $WAIT_SECS
if [ "$?" = "1" ]; then
    echo "Problem with kibana start up."
    exit 1
fi

# STEP-5 Initial elasticsearch setting
cd /opt/sfm-elk
python elk_config_loader.py
# for unknown reason, sometime, the first time initial seems not work well.
sleep 3
python elk_config_loader.py

# Go back to kibana home
cd /usr/share/kibana

wait