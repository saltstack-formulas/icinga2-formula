#Configures the timezone for the 
phpini-conf:
  cmd.run:
    - name: "sudo sed -i.bak \"s/;date.timezone\\\ .*/date.timezone\ =\ \\\"Europe\\/Vienna\\\"/\" /etc/php5/apache2/php.ini"
    - user: vagrant
    - output_loglevel: DEBUG
    - require_in:
      - pkg: icinga2-web2
  service.running:
    - name: apache2
    - restart: True
    - enable: True
    - watch:
      - pkg: icinga2-web2-required-packages
#      - file: /etc/php5/apache2/php.ini

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
    - require:
      - postgres_database: icinga2web-db-setup
