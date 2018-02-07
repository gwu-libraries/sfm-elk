# USING VERSION 5.3.3
FROM docker.elastic.co/elasticsearch/elasticsearch:5.3.3

MAINTAINER Victor Tan <ychtan@email.gwu.edu>

USER root
# grab su-exec for easy step-down from root
RUN apk add --no-cache 'su-exec>=0.2' bash
RUN chown root:elasticsearch /sbin/su-exec
RUN chmod +s /sbin/su-exec

RUN apk add --update \
    bash \
    git \
    libffi-dev \
    openssl-dev \
    openssh \
    python-dev \
    py-pip \
    build-base \
  && rm -rf /var/cache/apk/*

RUN pip install --upgrade --quiet \
    requests \
    pip==9.0.1 \
    appdeps

# set environment
ENV SFM_REQS release
ENV DEBUG false

# add start bash for elasticsearch
ADD docker/elasticsearch/start.sh /usr/local/bin/sfm_elastic_start.sh
RUN chmod +x /usr/local/bin/sfm_elastic_start.sh

# custom elasticsearch config
COPY docker/elasticsearch/elasticsearch.yml config/
RUN chown elasticsearch:elasticsearch config/elasticsearch.yml

# custom elasticsearch logging
# see https://www.elastic.co/guide/en/elasticsearch/reference/current/settings.html
COPY docker/elasticsearch/log4j2.properties config/
RUN chown elasticsearch:elasticsearch config/log4j2.properties

USER elasticsearch
ENTRYPOINT ["/usr/local/bin/sfm_elastic_start.sh"]


