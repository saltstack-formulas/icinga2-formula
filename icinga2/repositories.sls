{% from "icinga2/map.jinja" import icinga2 with context %}

{% if grains.os == 'Debian' %}
icinga_repo_required_packages:
  pkg.installed:
    - name: python-apt
    - require_in:
      - pkgrepo: icinga_repo

# The old repo's name
debmon:
  pkgrepo.absent: []

# Icinga require packages from debian backports
{% if icinga2.enable_debian_backports %}
icinga_repo_debian_backports:
  pkgrepo.managed:
    - humanname: debian_backports
    - name: deb http://deb.debian.org/debian {{ grains['lsb_distrib_codename'] }}-backports main
    - file: /etc/apt/sources.list.d/backports.list
{% endif %}
{% endif %}

icinga_repo:
  pkgrepo.managed:
    - humanname: icinga_official
    - name: deb http://packages.icinga.org/{{ grains.os|lower }} icinga-{{ grains['lsb_distrib_codename'] }} main
    - file: /etc/apt/sources.list.d/icinga.list
    - key_url: http://packages.icinga.org/icinga.key
