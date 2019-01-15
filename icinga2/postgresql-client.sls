{% from "icinga2/map.jinja" import icinga2 with context %}

{% set dependent_pkg = "icinga2ido-pkg" if icinga2.ido.pkg else "icinga2_pkgs" %}

{#- In FreeBSD, icinga2 has a dependency on postgresqlXY-client #}
{%- if salt['grains.get']('os_family') != 'FreeBSD' %}
{%-   if salt['pillar.get']('icinga2:postgres:use_formula', False) %}
include:
  - postgres.client

extend:
  postgresql-client-libs:
    pkg:
    - require_in:
      - pkg: {{ dependent_pkg }}
{%-   else %}
postgresql_packages_for_icinga_ido:
  pkg.installed:
    - pkgs: {{ icinga2.postgresql_pkgs }}
    - require_in:
      - pkg: {{ dependent_pkg }}
{%-   endif %}
{%- endif %}
