include:
  - icinga2.postgresql
  - icinga2

debconf_enable_pgsql_ido:
  cmd.run:
    - name: "echo debconf icinga2-ido-pgsql/dbconfig-install boolean true | sudo debconf-set-selections"

debconf_dbconfig_pgsql_ido:
  cmd.run:
    - name: "echo debconf icinga2-ido-pgsql/enable boolean true | sudo debconf-set-selections"

debconf_dbconfig_pgsql_dbname:
  cmd.run:
    - name: "echo debconf icinga2-ido-pgsql/db/dbname string icinga | sudo debconf-set-selections"


icinga2-ido-pgsql:
  pkg.installed:
    - require:
      - cmd: debconf_enable_pgsql_ido
      - cmd: debconf_dbconfig_pgsql_ido
      - cmd: debconf_dbconfig_pgsql_dbname
      - pkg: icinga2
      - pkg: postgresql_packages_for_icinga_ido
    - watch_in:
      - service: icinga2

enable_ido:
  cmd.run:
    - name: icinga2 feature enable ido-pgsql
    - require:
      - pkg: icinga2-ido-pgsql
    - watch_in:
      - service: icinga2

/etc/dbconfig-common/icinga-idoutils.conf:
  file.symlink:
    - target: icinga2-ido-pgsql.conf
    - require:
      - pkg: icinga2-ido-pgsql
