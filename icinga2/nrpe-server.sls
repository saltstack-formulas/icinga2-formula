{% from "icinga2/map.jinja" import icinga2 with context %}

include:
  - .repositories

nrpe_nagios_plugins:
  pkg.installed:
    - name: nagios-plugins
    - require:
      - pkgrepo: icinga_repo

nagios-nrpe-server:
  pkg.installed:
    - require:
      - pkgrepo: icinga_repo
  service.running:
    - watch:
      - file: /etc/nagios/nrpe_local.cfg
      - file: /etc/default/nagios-nrpe-server

/etc/default/nagios-nrpe-server:
  file.managed:
    - contents: |
{%- for key, value in icinga2.nrpe.defaults.items() %}
        {{ key }}={{ value }}
{%- endfor %}

/etc/nagios/nrpe_local.cfg:
  file.managed:
    - contents: |
{%- for key, value in icinga2.nrpe.config.items() if not value is mapping %}
        {{ key }}={{ value }}
{%- endfor %}
{% if icinga2.nrpe.config.commands is defined %}
{%- for key, value in icinga2.nrpe.config.commands.items() %}
        command[{{ key }}] = {{ value }}
{%- endfor %}
{% endif %}
