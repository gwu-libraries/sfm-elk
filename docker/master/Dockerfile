FROM sebp/elk
MAINTAINER Justin Littman <justinlittman@gwu.edu>

RUN apt-get update && apt-get install -y \
    python-dev \
    libffi-dev \
    libssl-dev \
    python-pip \
    git \
    wget \
    zip
#Need newer version of jq
WORKDIR /usr/bin
RUN wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && mv jq-linux64 jq && chmod +x jq
#Upgrade pip
RUN pip install --upgrade pip
RUN wget --no-check-certificate https://github.com/gwu-libraries/sfm-elk/archive/master.zip
RUN unzip master.zip
RUN mv sfm-twitter-harvester-master /opt/sfm-elk
WORKDIR /opt/sfm-elk
RUN pip install -r requirements/master.txt
RUN pip install appdeps
ADD start.sh /usr/local/bin/sfm_elk_start.sh
RUN chmod +x /usr/local/bin/sfm_elk_start.sh
ENTRYPOINT ["/usr/local/bin/sfm_elk_start.sh"]