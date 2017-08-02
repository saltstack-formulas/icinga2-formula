{% from "icinga2/map.jinja" import icinga2 with context %}

include:
  - icinga2

icinga2-web2-required-packages:
  pkg.installed:
    - pkgs: {{ icinga2.icinga_web2.required_pkgs }}

icinga2-web2:
  pkg.installed:
    - pkgs: {{ icinga2.icinga_web2.pkgs }}

#Create an empty database which will be populated later
icinga2web-db-setup:
  postgres_user.present:
    - name: icinga2web
    - password: icinga2web
    - createdb: True
    - createroles: True
    - createuser: True
    - inherit: True
    - login: True
    - encrypted: False
    - require:
      - pkg: icinga2-web2
  postgres_database.present:
    - name: icinga2web
    - encoding: UTF-8
    - template: template0
    - owner: icinga2web
    - require:
      - postgres_user: icinga2web-db-setup

#Enable graphite module of icinga2web
icinga2web-enable-graphite:
  file.symlink:
    - target: /etc/icinga2/features-available/graphite.conf
    - name: /etc/icinga2/features-enabled/graphite.conf
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: icinga2

#Enable status data module of icinga2web
icinga2web-enable-statusdata:
  file.symlink:
    - target: /etc/icinga2/features-available/statusdata.conf
    - name: /etc/icinga2/features-enabled/statusdata.conf
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: icinga2

#Enable perfdata module of icinga2web
icinga2web-enable-perfdata:
  file.symlink:
    - target: /etc/icinga2/features-available/perfdata.conf
    - name: /etc/icinga2/features-enabled/perfdata.conf
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: icinga2

#Enable gelf module of icinga2web
icinga2web-enable-gelf:
  file.symlink:
    - target: /etc/icinga2/features-available/gelf.conf
    - name: /etc/icinga2/features-enabled/gelf.conf
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: icinga2

#Enable icingastatus module of icinga2web
icinga2web-enable-icingastatus:
  file.symlink:
    - target: /etc/icinga2/features-available/icingastatus.conf
    - name: /etc/icinga2/features-enabled/icingastatus.conf
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: icinga2

#Enable opentsdb module of icinga2web
icinga2web-enable-opentsdb:
  file.symlink:
    - target: /etc/icinga2/features-available/opentsdb.conf
    - name: /etc/icinga2/features-enabled/opentsdb.conf
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: icinga2

#Enable command module of icinga2web
icinga2web-enable-command:
  file.symlink:
    - target: /etc/icinga2/features-available/command.conf
    - name: /etc/icinga2/features-enabled/command.conf
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: icinga2

#Configure automatically Icinga web, avoiding the use of the php wizard
icinga2web-autoconfigure:
  file.recurse:
    - name: /etc/icingaweb2
    - source: salt://icinga2/files/etc/
    - makedirs: True
    - user: www-data
    - group: icingaweb2
    - dir_mode: 750
    - file_mode: 644

icinga2web-autoconfigure-finalize:
  file.symlink:
    - name: /etc/icingaweb2/enabledModules/monitoring
    - target: /usr/share/icingaweb2/modules/monitoring
    - makedirs: True
    - user: www-data
    - group:  icingaweb2
