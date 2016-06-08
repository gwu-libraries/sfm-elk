# sfm-elk
A proof-of-concept analytics dashboard for social media content harvested by [Social Feed Manager](https://gwu-libraries.github.io/sfm-ui) using the ELK
([Elasticsearch](https://www.elastic.co/products/elasticsearch), [Logstash](https://www.elastic.co/products/logstash), 
[Kibana](https://www.elastic.co/products/kibana)) stack.

sfm-elk works by listening for warc_created messages produced by harvesters.  Upon receiving a message it:
1. Iterates over social media API calls records recorded in the WARC using a platform-specific WARC iterator 
(e.g., [twitter_rest_warc_iter](https://github.com/gwu-libraries/sfm-twitter-harvester/blob/master/twitter_rest_warc_iter.py)), 
outputting line-oriented json records to STDOUT.
2. Pipes the json records to [jq](https://stedolan.github.io/jq/) to filter out unnecessary metadata.
3. Pipes the filtered json records to Logstash.
4. Logstash loads the json records to Elasticsearch, which makes them available from Kibana.

sfm-elk currently supports loading WARCs from the Twitter REST API, Twitter Stream API, and Weibo API. A Twitter dashboard
and Weibo dashboard are provided.

## Installing
    git clone https://github.com/gwu-libraries/sfm-elk.git
    cd sfm-elk
    pip install -r requirements/requirements.txt

## Requirements
[Docker Engine](https://www.docker.com/docker-engine) and [Docker Compose](https://www.docker.com/docker-compose)

## Running with development configuration
In the development configuration, the code is linked in from the local file system. sfm-elk must be installed.

    cd docker
    docker-compose -f dev.docker-compose.yml up -d
    
## Running with master configuration
In the master configuration, the latest version of code committed to the master branch is used. sfm-elk does not need
to be installed.

    curl -L https://github.com/gwu-libraries/sfm-elk/raw/master/docker/master.docker-compose.yml > docker-compose.yml
    docker-compose up -d
    
Or if sfm-elk is installed:

    cd docker
    docker-compose -f master.docker-compose.yml up -d

## Using
Once a configuration is running, use sfm-ui (http://<host>:8080/) to schedule a harvest.  Harvested content will be 
automatically loaded into sfm-elk.

Dashboards are available at http://<host>:5601/app/kibana#/dashboard. Click the folder icon and choose a dashboard.
The Twitter dashboard is available at http://<host>:5601/app/kibana#/dashboard/Twitter.

To see results, you may need to wait and/or adjust the timeframe (by clicking the clock icon in the upper right corner.)
