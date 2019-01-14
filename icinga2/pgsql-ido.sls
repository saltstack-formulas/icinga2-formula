{% from "icinga2/map.jinja" import feature with context %}
{% from "icinga2/map.jinja" import icinga2 with context %}

include:
  - icinga2

{% if grains['os_family'] == 'Debian' %}
debconf_pgsql_ido:
  debconf.set:
    - name: "{{ icinga2.ido.pkg }}"
    - data:
        '{{ icinga2.ido.pkg }}/dbconfig-install': {'type': 'boolean', 'value': true}
        '{{ icinga2.ido.pkg }}/db/dbname': {'type': 'string', 'value': "{{ icinga2.ido.db.name }}"}
        '{{ icinga2.ido.pkg }}/db/dbuser': {'type': 'string', 'value': "{{ icinga2.ido.db.user }}"}
        '{{ icinga2.ido.pkg }}/db/dbpass': {'type': 'string', 'value': "{{ icinga2.ido.db.password }}"}
        '{{ icinga2.ido.pkg }}/db/dbport': {'type': 'string', 'value': "{{ icinga2.ido.db.port }}"}
        '{{ icinga2.ido.pkg }}/db/dbserver': {'type': 'string', 'value': "{{ icinga2.ido.db.host }}"}
        '{{ icinga2.ido.pkg }}/enable': {'type': 'boolean', 'value': true}
    - require_in:
      - pkg: icinga2ido-pkg

/etc/dbconfig-common/icinga-idoutils.conf:
  file.symlink:
    - target: "{{ icinga2.ido.pkg }}.conf"
    - require:
      - pkg: icinga2ido-pkg
{% endif %}

{% if icinga2.ido.pkg %}
icinga2ido-pkg:
  pkg.installed:
    - name: "{{ icinga2.ido.pkg }}"
    - require:
      - pkg: icinga2_pkgs
    - watch_in:
      - service: icinga2_service_restart
{% endif %}

icinga2ido-config:
  file.managed:
    - name: "{{ icinga2.config_dir}}/features-available/ido-pgsql.conf"
    - template: jinja
    - source: salt://icinga2/files/ido-pgsql.conf.jinja
    - watch_in:
      - service: icinga2_service_restart

{{ feature('ido-pgsql', True) }}
    - require:
{% if icinga2.ido.pkg %}
      - pkg: icinga2ido-pkg
{% endif %}
      - file: icinga2ido-config

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
  cmd.run:
    - name: psql -U "{{ icinga2.ido.db.user }}" -d "{{ icinga2.ido.db.name }}" -h "{{ icinga2.ido.db.host }}" < "{{ icinga2.ido.schema_path }}"
    - env:
      - PGPASSWORD: "{{ icinga2.ido.db.password }}"
    - onchanges:
      - postgres_database: icinga2web-db-setup
    - require:
      - postgres_database: icinga2web-db-setup
      - postgres_user: icinga2web-db-setup
