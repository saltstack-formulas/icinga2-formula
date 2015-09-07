include:
  - .pgsql-ido
  - .legacy-feature-activation

icinga2-web2-required-packages:
    pkg.installed:
        - pkgs:
            - php5-fpm
            - php5-pgsql
            - libapache2-mod-php5
            - php5-intl
            - php5-gd
            - php5-imagick

icinga2-web2:
    pkg.installed:
        - require:
            - pkg: icinga2-web2-required-packages
            - pkg: icinga2-ido-pgsql
            - cmd: phpini-conf
            - file: /etc/dbconfig-common/icinga-idoutils.conf
            - file: /usr/local/bin/icinga2-disable-feature
            - file: /usr/local/bin/icinga2-enable-feature
        - pkgs:
            - icingaweb2
            - icingaweb2-module-doc
            - icingaweb2-module-monitoring
            - icingaweb2-module-setup
    iptables.append:
        - table: filter
        - chain: INPUT
        - jump: ACCEPT
        - match: state
        - connstate: NEW
        - dport: 80
        - proto: tcp
        - sport: 1025:65535
        - save: True

#Configures the timezone for the 
phpini-conf:
    cmd.run:
        - name: "sudo sed -i.bak \"s/;date.timezone\\\ .*/date.timezone\ =\ \\\"Europe\\/Vienna\\\"/\" /etc/php5/apache2/php.ini"
        - user: vagrant
        - output_loglevel: DEBUG
    service.running:
        - name: apache2
        - restart: True
        - enable: True
        - watch:
            - pkg: icinga2-web2-required-packages
#            - file: /etc/php5/apache2/php.ini

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
            - pkg: icinga2-ido-pgsql
    postgres_database.present:
        - name: icinga2web
        - encoding: UTF-8
        - template: template0
        - owner: icinga2web

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

icinga2web-dbpopulate:
    file.recurse:
        - name: /tmp/icingaschema
        - source: salt://icinga2/files/pgsql
        - makedirs: True
        - dir_mode: 777
        - file_mode: 777
    cmd.script:
        - name: salt://icinga2/files/setup_icinga2web.sh
        - user: vagrant
        - output_loglevel: DEBUG

