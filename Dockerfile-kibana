# USING VERSION 5.3.0
FROM docker.elastic.co/kibana/kibana:5.3.0

MAINTAINER Victor Tan <ychtan@email.gwu.edu>

USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    python-dev \
    libffi-dev \
    libssl-dev \
    python-pip \
    git \
    wget

# update the pip to 9.0.1
RUN pip install --upgrade pip==9.0.1
#Avoid the warning of https
RUN pip install --upgrade ndg-httpsclient
RUN pip install appdeps
RUN pip install requests

# add start bash for kibana
ADD docker/kibana/start.sh /usr/local/bin/sfm_kibana_start.sh
RUN chmod +x /usr/local/bin/sfm_kibana_start.sh

# custom kibana config
COPY docker/kibana/kibana.yml config/

ADD . /opt/sfm-elk/

USER kibana
ENTRYPOINT ["/usr/local/bin/sfm_kibana_start.sh"]