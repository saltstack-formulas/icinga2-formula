{% from "icinga2/map.jinja" import icinga2 with context %}

nagios-nrpe-server:
  pkg.installed

{% if icinga2.nrpe.config is defined %}
/etc/nagios/nrpe_local.cfg:
  file.managed:
    - contents: |
{%- for key, value in icinga2.nrpe.config.iteritems() if not value is mapping %}
        {{ key }} = {{ value }}
{%- endfor %}
{% if icinga2.nrpe.config.commands is defined %}
{%- for key, value in icinga2.nrpe.config.commands.iteritems() %}
        command[{{ key }}] = {{ value }}
{%- endfor %}
{% endif%}
{% endif%}