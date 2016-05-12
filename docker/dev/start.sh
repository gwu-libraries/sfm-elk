#!/bin/bash

pip install -r /opt/sfm-elk/requirements/dev.txt --upgrade

/usr/local/bin/start.sh &

appdeps.py --port-wait mq:5672 --port-wait localhost:9200 --port-wait localhost:5601

python elk_config_loader.py

python sfm_elk_loader.py mq $MQ_ENV_RABBITMQ_DEFAULT_USER $MQ_ENV_RABBITMQ_DEFAULT_PASS --debug=$DEBUG $* &

wait