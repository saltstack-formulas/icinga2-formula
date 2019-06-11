{%- from "icinga2/map.jinja" import icinga2 with context %}
{%- set xmpp = salt['pillar.get']('icinga2:notification:xmpp', {}) %}

include:
  - icinga2.directories

icinga_notification_xmpp_pkg:
  pkg.installed:
    - name: {{ icinga2.notification.xmpp.pkg }}

{% set sender = "{}/xmpp-send.py".format(icinga2.scripts_dir) %}
icinga_notification_xmpp_sender:
  file.managed:
    - name: {{ sender }}
    - mode: 755
    - template: jinja
    - source: salt://icinga2/files/xmpp-send.py
    - context:
        python_executable: {{ icinga2.notification.xmpp.python_executable }}
        ca_file: {{ icinga2.notification.xmpp.ca_file }}
    - require:
      - pkg: icinga_notification_xmpp_pkg
      - sls: icinga2.directories

icinga_notification_xmpp_config:
  file.managed:
    - name: {{ icinga2.config_dir }}/conf.d/notification/xmpp.conf
    - makedirs: True
    - template: jinja
    - source: salt://icinga2/files/xmpp.conf.jinja
    - context:
        sender: {{ sender }}
        jid: {{ xmpp.get('jid') }}
        password: {{ xmpp.get('password') }}
    - require:
      - file: icinga_notification_xmpp_sender
    - watch_in:
      - service: icinga2_service_reload
