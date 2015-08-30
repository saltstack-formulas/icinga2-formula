include:
  - .pgsql-ido
  - .legacy-feature-activation

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
            - libapache2-mod-php5

icinga-web:
  pkg.installed:
    - require:
{% if grains['os'] == 'Ubuntu' %}
      - pkgrepo: formorer_icinga_web
{% endif %}
      - pkg: icinga2-web-required-packages
      - pkg: icinga2-ido-pgsql
      - file: /etc/dbconfig-common/icinga-idoutils.conf

icinga-web-config-icinga2-ido-pgsql:
  pkg.installed:
    - require:
      - pkg: icinga-web
      - file: /usr/local/bin/icinga2-disable-feature
      - file: /usr/local/bin/icinga2-enable-feature
