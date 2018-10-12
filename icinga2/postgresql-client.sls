{% from "icinga2/map.jinja" import icinga2 with context %}

{% if salt['pillar.get']('icinga2:postgres:use_formula', False) %}
include:
  - postgres.client

extend:
  postgresql-client-libs:
    pkg:
    - require_in:
      - pkg: icinga2ido-pkg
{% else %}
postgresql_packages_for_icinga_ido:
  pkg.installed:
    - pkgs: {{ icinga2.postgresql_pkgs }}
    - require_in:
      - pkg: icinga2ido-pkg
{% endif %}
