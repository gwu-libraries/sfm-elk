FROM sebp/elk
MAINTAINER Justin Littman <justinlittman@gwu.edu>

ENV sfm_elk_version 1.0.0
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
RUN wget --no-check-certificate https://github.com/gwu-libraries/sfm-elk/archive/${sfm_elk_version}.zip
RUN unzip ${sfm_elk_version}.zip
RUN mv sfm-elk-${sfm_elk_version} /opt/sfm-elk
WORKDIR /opt/sfm-elk
RUN pip install -r requirements/requirements.txt
RUN pip install appdeps
ADD start.sh /usr/local/bin/sfm_elk_start.sh
RUN chmod +x /usr/local/bin/sfm_elk_start.sh
ENTRYPOINT ["/usr/local/bin/sfm_elk_start.sh"]