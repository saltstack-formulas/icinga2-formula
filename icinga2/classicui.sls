include:
  - icinga2

icinga2-classicui:
  pkg.installed:
    - require:
      - sls: icinga2