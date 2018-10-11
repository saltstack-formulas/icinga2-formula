{% from "icinga2/map.jinja" import feature with context %}
{% from "icinga2/map.jinja" import icinga2 with context %}

include:
  - icinga2

debconf_pgsql_ido:
  debconf.set:
    - name: icinga2-ido-pgsql
    - data:
        'icinga2-ido-pgsql/dbconfig-install': {'type': 'boolean', 'value': true}
        'icinga2-ido-pgsql/db/dbname': {'type': 'string', 'value': "{{ icinga2.ido.db.name }}"}
        'icinga2-ido-pgsql/db/dbuser': {'type': 'string', 'value': "{{ icinga2.ido.db.user }}"}
        'icinga2-ido-pgsql/db/dbpass': {'type': 'string', 'value': "{{ icinga2.ido.db.password }}"}
        'icinga2-ido-pgsql/db/dbport': {'type': 'string', 'value': "{{ icinga2.ido.db.port }}"}
        'icinga2-ido-pgsql/db/dbserver': {'type': 'string', 'value': "{{ icinga2.ido.db.host }}"}
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

is-icinga2ido-password-set:
  test.check_pillar:
    - present:
      - 'icinga2:lookup:ido:db:password'
    - string:
      - 'icinga2:lookup:ido:db:password'

icinga2ido-db-setup:
  postgres_user.present:
    - name: "{{ icinga2.ido.db.user }}"
    - password: "{{ icinga2.ido.db.password }}"
    - createdb: True
    - createroles: True
    - createuser: True
    - inherit: True
    - login: True
    # Necessary as of PostgreSQL 10
    - encrypted: True
    - require:
      - test: is-icinga2ido-password-set
      - pkg: icinga2-web2
  postgres_database.present:
    - name: "{{ icinga2.ido.db.name }}"
    - encoding: UTF8
    - template: template0
    - owner: "{{ icinga2.ido.db.user }}"
    - require:
      - test: is-icinga2ido-password-set
      - postgres_user: icinga2ido-db-setup
