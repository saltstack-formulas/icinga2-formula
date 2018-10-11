{% if grains['os'] == 'Debian' %}
icinga_repo_required_packages:
  pkg.installed:
    - name: python-apt
    - require_in:
      - pkgrepo: icinga_repo

# The old repo's name
debmon:
  pkgrepo.absent: []
{% endif %}

icinga_repo:
  pkgrepo.managed:
    - humanname: icinga_official
    - name: deb http://packages.icinga.org/ubuntu icinga-{{ grains['lsb_distrib_codename'] }} main
    - file: /etc/apt/sources.list.d/icinga.list
    - key_url: http://packages.icinga.org/icinga.key
