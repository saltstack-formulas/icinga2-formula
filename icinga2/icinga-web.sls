include:
  - .pgsql-ido

{% if grains['os'] == 'Ubuntu' %}

formorer_icinga_web:
  pkgrepo.managed:
    - ppa: formorer/icinga-web
    - require_in:
      - pkg: icinga2

{% endif %}

icinga2-web-required-packages:
  pkg.installed:
    - pkgs:
      - php5-fpm
      - php5-pgsql

icinga-web:
  pkg.installed:
    - require:
      - pkgrepo: formorer_icinga_web
      - pkg: icinga2-web-required-packages
      - pkg: icinga2-ido-pgsql
      - file: /etc/dbconfig-common/icinga-idoutils.conf

icinga-web-config-icinga2-ido-pgsql:
  pkg.installed:
    - require:
      - pkg: icinga-web