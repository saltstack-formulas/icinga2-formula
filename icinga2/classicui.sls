{% from "icinga2/map.jinja" import icinga2 with context %}

{% if grains['os_family'] in ['Debian']  %}

include:
  - icinga2

icinga2-classicui:
  pkg.installed:
    - require:
      - sls: icinga2

/etc/icinga2/classicui/htpasswd.users:
  file.managed:
    - require:
      - pkg: icinga2-classicui
    - contents: |
{%- for user, password_hash in icinga2.classicui.users.iteritems() %}
        {{ user }}:{{ password_hash }}
{%- endfor %}

{% endif %}