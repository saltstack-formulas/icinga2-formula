{%- from "icinga2/map.jinja" import icinga2 with context %}

include:
  - icinga2.directories

icinga2_check_command_openvpn_source:
  git.latest:
    - name: https://github.com/liquidat/nagios-icinga-openvpn
    - target: {{ icinga2.scripts_dir }}/check_command/openvpn
    - branch: {{ icinga2.check_command.openvpn.branch }}
    - rev: {{ icinga2.check_command.openvpn.revision }}
    - force_checkout: True
    - force_fetch: True
    - force_reset: True
    - require:
      - sls: icinga2.directories

icinga2_check_command_openvpn_check_command_conf:
  file.managed:
    - name: {{ icinga2.check_command_dir }}/openvpn.conf
    - source: salt://icinga2/files/check_command/openvpn.conf.jinja
    - template: jinja
    - context:
        source_dir: {{ icinga2.scripts_dir }}/check_command/openvpn
    - require:
      - sls: icinga2.directories
    - watch_in:
      - service: icinga2_service_reload
