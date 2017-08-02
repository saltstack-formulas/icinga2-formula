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
    - name: /etc/icingaweb2
    - source: salt://icinga2/files/etc/
    - makedirs: True
    - user: www-data
    - group: icingaweb2
    - dir_mode: 750
    - file_mode: 644

icinga2web-autoconfigure-finalize:
  file.symlink:
    - name: /etc/icingaweb2/enabledModules/monitoring
    - target: /usr/share/icingaweb2/modules/monitoring
    - makedirs: True
    - user: www-data
    - group:  icingaweb2
