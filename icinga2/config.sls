{% from "icinga2/map.jinja" import icinga2 with context %}
{% set conf = salt['pillar.get']('icinga2:conf', {}) %}

{%- macro printconfig(type, object, name, config, applyto="") %}
        {{ type }} {{ object }} "{{ name }}" {% if applyto !="" %}to {% endif %}{{ applyto }}{% if applyto !="" %} {% endif %}{
{%- for key, value in config.items()%}
{%-   if key == "import" %}
          {{key}} "{{ value }}"
{%-   endif %}
{%- endfor %}

{%- for key, value in config.items()%}
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

{%-   elif value is number %}
          {{ key }} = {{ value }}

{%-   else %}
          {{ key }} = "{{ value }}"
{%-   endif %}
{%- endfor %}
        }
{%-endmacro%}

{%- if grains['os_family'] in ['Debian']  %}

### Begin hosts configuration
{%-   if conf.hosts is defined %}

/etc/conf.d/hosts/:
  file.directory

{%-     for host, hostconf in conf.hosts.items() %}

/etc/conf.d/hosts/{{ host }}.conf:
  file.managed:
    - require:
      - file: /etc/conf.d/hosts/
    - watch_in:
      - service: icinga2
    - contents: |
{{ printconfig("object", "Host", host, hostconf) }}

{%-       if hostconf.services is defined %}
/etc/conf.d/hosts/{{ host }}:
  file.directory

{%-         for service, serviceconf in hostconf.services.items() %}

/etc/conf.d/hosts/{{ host }}/{{ service }}.conf:
  file.managed:
    - require:
      - file: /etc/conf.d/hosts/{{ host }}
    - watch_in:
      - service: icinga2
    - contents: |
{{ printconfig("object", "Service", service, serviceconf) }}

{%-         endfor %}
{%-       endif %}
{%-     endfor %}
{%-   endif %}
### End hosts configuration

### Begin hostgroups configuration

{%-   if conf.hostgroups is defined %}
/etc/conf.d/hostsgroups.conf:
  file.managed:
    - watch_in:
      - service: icinga2
    - contents: |
{%-     for hostgroup, hostgroupconf in conf.hostgroups.items() %}
{{ printconfig("object", "HostGroup", hostgroup, hostgroupconf) }}

{%-     endfor %}
{%-   endif %}
### End hostgroups configuration

### Begin template configuration
{%-   if conf.templates is defined %}
/etc/conf.d/templates:
  file.directory:
    - require:
      - pkg: icinga2

{%-     for template, templateinfo in conf.templates.items() %}
/etc/conf.d/templates/{{ template }}.conf:
  file.managed:
    - require:
      - file: /etc/conf.d/templates
    - watch_in:
      - service: icinga2
    - contents: |
{{ printconfig("template", templateinfo["type"], template, templateinfo["conf"]) }}

{%-     endfor%}
{%-   endif %}
### End template configuration

### Begin apply configuration
{% set applies = { "downtimes": "ScheduledDowntime", "services": "Service", "notifications": "Notification"} %}
{%-   for type, objecttype in applies.items() %}

{%-     if conf[type] is defined %}
/etc/conf.d/{{ type }}:
  file.directory:
    - require:
      - pkg: icinga2

{%-       for apply, applyinfo in conf[type].items() %}
{% set applyto = applyinfo["apply_to"]|default('') %}
/etc/conf.d/{{ type }}/{{ apply }}.conf:
  file.managed:
    - require:
      - file: /etc/conf.d/{{ type }}
    - watch_in:
      - service: icinga2
    - contents: |
{{ printconfig("apply", applyinfo["type"], apply, applyinfo["conf"], applyto) }}

{%-       endfor%}
{%-     endif %}

{%-   endfor%}
### End apply configuration

{% endif %}

