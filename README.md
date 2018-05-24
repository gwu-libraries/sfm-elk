# sfm-elk

__As of SFM 1.12, sfm-elk is deprecated.__

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

For more information on deploying and using SFM ELK, see the [Exploring Social Media Data with ELK](http://sfm.readthedocs.io/en/latest/exploring.html).
