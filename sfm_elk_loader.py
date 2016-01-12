from sfmutils.consumer import BaseConsumer, MqConfig, EXCHANGE
from subprocess import check_output, CalledProcessError
import logging
import argparse

log = logging.getLogger(__name__)


class ElkLoader(BaseConsumer):
    def on_message(self):
        # Message should be WARC created
        warc_filepath = self.message["warc"]["path"]
        log.info("Loading %s", warc_filepath)
        cmd = "twitter_rest_warc_iter.py {} | jq -c '{{ id: .id, user_id: .user.id_str, screen_name: .user.screen_name, created_at: .created_at, text: .text, user_mentions: [.entities.user_mentions[]?.screen_name], hashtags: [.entities.hashtags[]?.text], urls: [.entities.urls[]?.expanded_url]}}' | /opt/logstash/bin/logstash -f stdin.conf".format(
            warc_filepath)
        try:
            check_output(cmd, shell=True)
            log.debug("Loading %s completed.", warc_filepath)
        except CalledProcessError, e:
            log.error("%s returned %s: %s", cmd, e.returncode, e.output)

if __name__ == "__main__":
        # Logging
        logging.basicConfig(format='%(asctime)s: %(name)s --> %(message)s', level=logging.DEBUG)

        # Arguments
        parser = argparse.ArgumentParser()
        parser.add_argument("host")
        parser.add_argument("username")
        parser.add_argument("password")
        parser.add_argument("--debug", type=lambda v: v.lower() in ("yes", "true", "t", "1"), nargs="?", default="False", const="True")

        args = parser.parse_args()

        # Logging
        logging.basicConfig(format='%(asctime)s: %(name)s --> %(message)s',
                            level=logging.DEBUG if args.debug else logging.INFO)
        loader = ElkLoader(mq_config=MqConfig(args.host, args.username, args.password, EXCHANGE,
                                               {"elk_loader": ["warc_created"]}))
        loader.run()
