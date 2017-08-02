{# keep backwards compatibility #}
{% set nrpe = salt['pillar.get']('nrpe', salt['pillar.get']('icinga2:lookup::nrpe', {}))%}


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
{%- for key, value in nrpe.get('defaults', {}).items() %}
        {{ key }}={{ value }}
{%- endfor %}

/etc/nagios/nrpe_local.cfg:
  file.managed:
    - contents: |
{%- for key, value in nrpe.get('config', {}).items() if not value is mapping %}
        {{ key }}={{ value }}
{%- endfor %}
{%- for key, value in nrpe.get('config:commands', {}).items() %}
        command[{{ key }}] = {{ value }}
{%- endfor %}
