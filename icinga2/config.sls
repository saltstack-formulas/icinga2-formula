{% from "icinga2/map.jinja" import icinga2 with context %}
{% set conf = salt['pillar.get']('icinga2:conf', {}) %}

{%- macro printconfig(type, object, name, config, applyto="") %}
        {{ type }} {{ object }} "{{ name }}" {% if applyto !="" %}to {% endif %}{{ applyto }}{% if applyto !="" %} {% endif %}{
{%- for key, value in config.items() %}
{%-   if key == "import" %}
          {{ key }} "{{ value }}"
{%-   endif %}
{%- endfor %}

{%- for key, value in config.items() %}
{%-   if key == "import" %}
{%-   elif key == "vars"  %}
{%-     for varkey, varvalue in config.vars.items() %}
          vars.{{ varkey }} = "{{ varvalue }}"
{%-     endfor %}

{%-   elif key == "services"  %}

{%-   elif key == "ranges"  %}
          ranges = {
{%-     for rangekey, rangevalue in config.ranges.items() %}
            {{ rangekey }} = "{{ rangevalue }}"
{%-     endfor %}
          }

{%-   elif key in ["states", "types", "user_groups"] %}
          {{ key }} = [ {{ value|join(",") }} ]

{%-   elif key == "assign" or key == "ignore" %}
{%-     for item in value %}
          {{ key }} where {{ item }}
{%-     endfor %}

{%-   elif value is sameas True %}
          {{ key }} = true
{%-   elif value is sameas False %}
          {{ key }} = false

{%-   elif value is number %}
          {{ key }} = {{ value }}

{%-   elif value is string %}
          {{ key }} = "{{ value }}"

{%-   elif value is iterable %}
          {{ key }} = [ "{{ value|join('", "') }}" ]

{%-   else %}
          {{ key }} = "{{ value }}"
{%-   endif %}
{%- endfor %}
        }
{%- endmacro %}

include:
  - .directories

{%- if grains['os_family'] in ['Debian', 'FreeBSD']  %}

### Begin hosts configuration
{%-   if conf.hosts is defined %}

{{ icinga2.confd_dir }}/hosts/:
  file.directory

{%-     if grains['os_family'] in ['FreeBSD']  %}
{#-       Remove duplicate host entry of Icinga host #}
{{ icinga2.confd_dir }}/hosts.conf:
  file.managed:
    - contents: ''
    - watch_in:
      - service: icinga2_service_reload
{%-     endif %}

{%-     for host, hostconf in conf.hosts.items() %}

{%-       set path = "{}/conf.d/hosts/{}".format(icinga2.config_dir, host) %}
{%-       if not hostconf.get('address', False) %}
{%-         do hostconf.update({'address': host}) %}
{%-       endif %}
{%-       if not hostconf.get('import', False) %}
{%-         do hostconf.update({'import': 'generic-host'}) %}
{%-       endif %}

{%-       if hostconf['remove'] is sameas true %}
{{ path }}.conf:
  file.absent:
    - watch_in:
      - service: icinga2_service_reload
{{ path }}/:
  file.absent:
    - watch_in:
      - service: icinga2_service_reload
{%-       else %}
{{ path }}.conf:
  file.managed:
    - require:
      - file: {{ icinga2.confd_dir }}/hosts/
    - watch_in:
      - service: icinga2_service_reload
    - contents: |
{{ printconfig("object", "Host", host, hostconf) }}

{%-         if hostconf.services is defined %}
{{ path }}:
  file.directory

{%-           for service, serviceconf in hostconf.services.items() %}

{{ path }}/{{ service }}.conf:
{%-             if serviceconf['remove'] is sameas true %}
  file.absent:
{%-             else %}
  file.managed:
    - require:
      - file: {{ icinga2.confd_dir }}/hosts/{{ host }}
    - contents: |
{{ printconfig("object", "Service", service, serviceconf) }}
{%-             endif %}
    - watch_in:
      - service: icinga2_service_reload

{%-           endfor %}
{%-         endif %}
{%-       endif %}
{%-     endfor %}
{%-   endif %}
### End hosts configuration

### Begin hostgroups configuration

{%-   if conf.hostgroups is defined %}
{{ icinga2.confd_dir }}/hostsgroups.conf:
  file.managed:
    - watch_in:
      - service: icinga2_service_reload
    - contents: |
{%-     for hostgroup, hostgroupconf in conf.hostgroups.items() %}
{{ printconfig("object", "HostGroup", hostgroup, hostgroupconf) }}

{%-     endfor %}
{%-   endif %}
### End hostgroups configuration

### Begin template configuration
{%-   if conf.templates is defined %}
{{ icinga2.confd_dir }}/templates:
  file.directory:
    - require:
      - pkg: icinga2_pkgs

{%-     for template, templateinfo in conf.templates.items() %}
{{ icinga2.confd_dir }}/templates/{{ template }}.conf:
  file.managed:
    - require:
      - file: {{ icinga2.confd_dir }}/templates
    - watch_in:
      - service: icinga2_service_reload
    - contents: |
{{ printconfig("template", templateinfo["type"], template, templateinfo["conf"]) }}

{%-     endfor %}
{%-   endif %}
### End template configuration

### Begin user configuration
{%-   if conf.users is defined %}
{{ icinga2.confd_dir }}/users.conf:
  file.absent: []

{{ icinga2.confd_dir }}/users:
  file.directory:
    - require:
      - pkg: icinga2_pkgs

{%-     for user, userinfo in conf.users.items() %}
{{ icinga2.confd_dir }}/users/{{ user }}.conf:
  file.managed:
    - require:
      - file: {{ icinga2.confd_dir }}/users
    - watch_in:
      - service: icinga2_service_reload
    - contents: |
{{ printconfig("object", "User", user, userinfo) }}

{%-     endfor %}
{%-   endif %}
### End user configuration

### Begin user group configuration
{%-   if conf.user_groups is defined %}
{{ icinga2.confd_dir }}/user_groups:
  file.directory:
    - require:
      - pkg: icinga2_pkgs

{%-     for group, groupinfo in conf.user_groups.items() %}
{{ icinga2.confd_dir }}/user_groups/{{ group }}.conf:
  file.managed:
    - require:
      - file: {{ icinga2.confd_dir }}/user_groups
    - watch_in:
      - service: icinga2_service_reload
    - contents: |
{{ printconfig("object", "UserGroup", group, groupinfo) }}

{%-     endfor %}
{%-   endif %}
### End user group configuration

### Begin apply configuration
{% set applies = { "downtimes": "ScheduledDowntime", "services": "Service", "notifications": "Notification"} %}
{%-   for type, objecttype in applies.items() %}

{%-     if type in conf %}
{{ icinga2.confd_dir }}/{{ type }}:
  file.directory:
    - require:
      - pkg: icinga2_pkgs

{%-       for apply, applyinfo in conf[type].items() %}
{% set applyto = applyinfo["apply_to"]|default('') %}
{{ icinga2.confd_dir }}/{{ type }}/{{ apply }}.conf:
  file.managed:
    - require:
      - file: {{ icinga2.confd_dir }}/{{ type }}
    - watch_in:
      - service: icinga2_service_reload
    - contents: |
{{ printconfig("apply", applyinfo.get("type", objecttype), apply, applyinfo.get("conf", {}), applyto) }}

{%-       endfor %}
{%-     endif %}

{%-   endfor %}
### End apply configuration

{% endif %}

