{% from "icinga2/map.jinja" import icinga2 with context %}

{% if icinga2.configure_repositories %}
include:
  - .repositories
{% endif %}

icinga2_pkgs:
  pkg.installed:
    - pkgs: {{ icinga2.pkgs | json }}
{% if icinga2.configure_repositories %}
    - require:
      - pkgrepo: icinga_repo
{% endif %}
