FROM sebp/elk
MAINTAINER Justin Littman <justinlittman@gwu.edu>

RUN apt-get update && apt-get install -y \
    python-dev \
    libffi-dev \
    libssl-dev \
    python-pip \
    git \
    wget
#Need newer version of jq
WORKDIR /usr/bin
RUN wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && mv jq-linux64 jq && chmod +x jq
#Upgrade pip
RUN pip install --upgrade pip
#This pre-fetches the most recent requirements.txt.
ADD https://raw.githubusercontent.com/gwu-libraries/sfm-elk/master/requirements/common.txt /tmp/
ADD https://raw.githubusercontent.com/gwu-libraries/sfm-elk/master/requirements/dev.txt /tmp/
RUN pip install -r /tmp/requirements.txt
RUN pip install appdeps
ADD start.sh /usr/local/bin/sfm_elk_start.sh
RUN chmod +x /usr/local/bin/sfm_elk_start.sh
WORKDIR /opt/sfm-elk
CMD /usr/local/bin/sfm_elk_start.sh