{% from "icinga2/map.jinja" import icinga2 with context %}
{% from "icinga2/map.jinja" import feature with context %}

include:
  - icinga2

icinga2-web2-required-packages:
  pkg.installed:
    - pkgs: {{ icinga2.icinga_web2.required_pkgs }}

icinga2-web2:
  pkg.installed:
    - pkgs: {{ icinga2.icinga_web2.pkgs }}

{%- for name, enable in icinga2.icinga_web2.features.items() %}
{{ feature(name, enable) }}
{%  endfor %}

#Configure automatically Icinga web, avoiding the use of the php wizard
icinga2web-autoconfigure:
  file.recurse:
    - name: "{{ icinga2.icinga_web2.config_dir }}"
    - source: salt://icinga2/files/etc/
    - template: jinja
    - makedirs: True
    - user: www-data
    - group: icingaweb2
    - dir_mode: 750
    - file_mode: 644

icinga2web-autoconfigure-finalize:
  file.symlink:
    - name: "{{ icinga2.icinga_web2.config_dir }}/enabledModules/monitoring"
    - target: "{{ icinga2.icinga_web2.modules_dir }}/monitoring"
    - makedirs: True
    - user: www-data
    - group:  icingaweb2
