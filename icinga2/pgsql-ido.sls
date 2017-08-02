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

enable_ido:
  cmd.run:
    - name: icinga2 feature enable ido-pgsql
    - unless: "icinga2 feature list | grep '^Enabled features: .*ido-pgsql'"
    - require:
      - pkg: icinga2-ido-pgsql
    - watch_in:
      - service: icinga2

/etc/dbconfig-common/icinga-idoutils.conf:
  file.symlink:
    - target: icinga2-ido-pgsql.conf
    - require:
      - pkg: icinga2-ido-pgsql
