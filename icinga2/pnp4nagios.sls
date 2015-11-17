{% from "icinga2/map.jinja" import icinga2 with context %}

pnp4nagios_packages:
  pkg.installed:
    - pkgs:
      - pnp4nagios
      - pnp4nagios-web
    - install_recommends: False

enable_perfdata:
  cmd.run:
    - name: icinga2 feature enable perfdata
    - watch_in:
      - service: icinga2

/etc/default/npcd:
  file.append:
    - text: RUN="yes"

/etc/pnp4nagios/npcd.cfg:
  file.replace:
    - pattern: ^perfdata_spool_dir.*
    - repl: perfdata_spool_dir = /var/spool/icinga2/perfdata

npcd:
  service.running:
    - watch:
      - file: /etc/default/npcd
      - file: /etc/pnp4nagios/npcd.cfg

/etc/pnp4nagios/apache.conf:
  file.managed:
    - source: salt://icinga2/files/pnp4nagios.apache2.conf

/etc/pnp4nagios/htpasswd.users:
  file.managed:
    - user: root
    - group: www-data
    - mode: 0640
    - require:
      - pkg: pnp4nagios_packages
    - contents: |
{%- for user, password_hash in icinga2.pnp4nagios.users.items() %}
        {{ user }}:{{ password_hash }}
{%- endfor %}
