import json
import requests

# For kibana's configuration: http://192.168.99.100:9200/.kibana/_search?pretty=1

with open("fields.json") as fields_file:
    fields = json.load(fields_file)

print "Loading logstash-* (index-pattern)"
resp = requests.post("http://localhost:9200/.kibana/index-pattern/logstash-*", data=json.dumps(fields))
resp.raise_for_status()

print "Loading config"
hits = 0
while hits != 1:
    resp = requests.get("http://localhost:9200/.kibana/_search?type=config")
    resp.raise_for_status()
    hits = resp.json()["hits"]["total"]
config = resp.json()["hits"]["hits"][0]["_source"]
config["defaultIndex"] = "logstash-*"
resp = requests.put("http://localhost:9200/.kibana/config/{}".format(resp.json()["hits"]["hits"][0]["_id"]), data=json.dumps(config))
resp.raise_for_status()

with open("export.json") as export_file:
    exports = json.load(export_file)

for export in exports:
    print "Loading {} ({})".format(export["_id"], export["_type"])
    resp = requests.post("http://localhost:9200/.kibana/{}/{}".format(export["_type"], export["_id"]), data=json.dumps(export["_source"]))
    resp.raise_for_status()