{% from "icinga2/map.jinja" import icinga2 with context %}

{% if grains['os_family'] in ['Debian']  %}

debmon_repo_required_packages:
  pkg.installed:
    - name: python-apt

debmon_repo:
  pkgrepo.managed:
    - humanname: debmon
    - name: deb http://debmon.org/debmon debmon-wheezy main
    - file: /etc/apt/sources.list.d/debmon.list
    - key_url: http://debmon.org/debmon/repo.key
    - require:
      - pkg: debmon_repo_required_packages

icinga2:
  pkg:
    - installed
  service:
    - running

{% endif %}