include:
  - .repositories

{% from "icinga2/map.jinja" import icinga2 with context %}

icinga2_pkgs:
  pkg.installed:
    - pkgs: {{ icinga2.pkgs }}
    - require:
      - pkgrepo: icinga_repo
