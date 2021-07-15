{% from "icinga2/map.jinja" import icinga2 with context %}

{% if grains['os'] == 'Debian' %}
icinga_repo_required_packages:
  pkg.installed:
    - name: python3-apt
    - require_in:
      - pkgrepo: icinga_repo

# The old repo's name
debmon:
  pkgrepo.absent: []
{% endif %}

{#- Source: http://packages.icinga.com/ #}
{#- Preparing the basic structure here for all of the available platforms #}
{#- But only configuring for Debian for now #}
{%- set dist = '' %}
{%- set ocn = grains.get('oscodename', '') %}
{%- set omr = grains.get('osmajorrelease', '0')|string %}
{%- if grains.os_family == 'Debian' %}
{%-   set dist = 'icinga-{0} main'.format(ocn) %}
{#- elif grains.os_family == 'RedHat' #}
{#-   set dist = '7' if grains.os == 'Amazon' else omr #}
{#- elif grains.os_family == 'Suse' #}
{#-   set dist = grains.osrelease #}
{%- endif %}

{%- if icinga2.repo and dist %}
{%-   if grains.osfinger == 'Debian-9' %}
icinga_deps_repo_for_stretch:
  pkgrepo.managed:
    - humanname: Stretch Backports
    - name: deb http://http.debian.net/debian stretch-backports main
    - dist: stretch-backports
{%-   endif %}
icinga_repo:
  pkgrepo.managed:
    - humanname: icinga_official
    - name: deb http://packages.icinga.org/{{ icinga2.repo }} {{ dist }}
    - file: /etc/apt/sources.list.d/icinga.list
    - key_url: http://packages.icinga.org/icinga.key
{%- endif %}
