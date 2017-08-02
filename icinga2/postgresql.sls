postgresql_packages_for_icinga_ido:
  pkg.installed:
    - pkgs:
      - postgresql
      - postgresql-client
    - require_in:
      - pkg: icinga2-ido-pgsql
