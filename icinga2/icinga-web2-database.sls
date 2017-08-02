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
    - encoding: UTF8
    - template: template0
    - owner: icinga2web
    - require:
      - postgres_user: icinga2web-db-setup
