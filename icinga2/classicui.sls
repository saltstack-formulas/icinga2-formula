{% from "icinga2/map.jinja" import icinga2 with context %}

{% if grains['os_family'] in ['Debian']  %}

include:
  - icinga2
  - .repositories

icinga2-classicui:
  pkg.installed:
    - require:
      - sls: icinga2
      - pkgrepo: icinga_repo

/etc/icinga2/classicui/htpasswd.users:
  file.managed:
    - user: root
    - group: www-data
    - mode: 0640
    - require:
      - pkg: icinga2-classicui
    - contents: |
{%- for user, password_hash in icinga2.classicui.users.iteritems() %}
        {{ user }}:{{ password_hash }}
{%- endfor %}

/etc/icinga2/classicui/cgi.cfg:
  file.managed:
    - source: salt://icinga2/files/classicui.cgi.cfg.tpl
    - template: jinja

{% endif %}