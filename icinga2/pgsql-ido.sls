{% from "icinga2/map.jinja" import feature with context %}

include:
  - icinga2

debconf_pgsql_ido:
  debconf.set:
    - name: icinga2-ido-pgsql
    - data:
        'icinga2-ido-pgsql/dbconfig-install': {'type': 'boolean', 'value': true}
        'icinga2-ido-pgsql/db/dbname': {'type': 'string', 'value': 'icinga'}
        'icinga2-ido-pgsql/enable': {'type': 'boolean', 'value': true}

icinga2-ido-pgsql:
  pkg.installed:
    - require:
      - debconf: debconf_pgsql_ido
      - pkg: icinga2_pkgs
    - watch_in:
      - service: icinga2

{{ feature('ido-pgsql', True) }}
    - require:
      - pkg: icinga2-ido-pgsql

/etc/dbconfig-common/icinga-idoutils.conf:
  file.symlink:
    - target: icinga2-ido-pgsql.conf
    - require:
      - pkg: icinga2-ido-pgsql
