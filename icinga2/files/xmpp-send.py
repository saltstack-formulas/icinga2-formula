#!/usr/bin/env {{ python_executable }}

import logging
import os
import sys
from slixmpp import ClientXMPP

# https://lab.louiz.org/poezio/slixmpp/blob/master/README.rst
# https://sleekxmpp.readthedocs.io/en/latest/getting_started/sendlogout.html

class Client(ClientXMPP):

    def __init__(self, jid, password, recipient, message):
        super(Client, self).__init__(jid, password)

        {% if ca_file -%}
        self.ca_certs = "{{ ca_file }}"
        {%- endif %}

        self.recipient = recipient
        self.message = message

        self.add_event_handler('session_start', self.start)

    def start(self, event):
        self.send_presence()
        self.get_roster()
        self.send_message(
          mto=self.recipient,
          mbody=self.message
        )
        self.disconnect(wait=True)


def main():

    logging.basicConfig(
        level=logging.INFO,
        format='%(levelname)-8s %(message)s'
    )

    if len(sys.argv) < 3:
        print("Usage: {} RECIPIENT MESSAGE".format(sys.argv[0]))
        sys.exit(1)

    client = Client(
        os.environ["XMPP_JID"],
        os.environ["XMPP_PASSWORD"],
        sys.argv[1],
        sys.argv[2]
    )

    client.connect()
    client.process(forever=False)


if __name__ == "__main__":
    main()
