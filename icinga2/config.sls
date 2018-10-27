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

{%-   elif value is string %}
          {{ key }} = "{{ value }}"

{%-   elif value is iterable %}
          {{ key }} = [ "{{ value|join('", "') }}" ]

{%-   else %}
          {{ key }} = "{{ value }}"
{%-   endif %}
{%- endfor %}
        }
{%-endmacro%}

{%- if grains['os_family'] in ['Debian']  %}

### Begin hosts configuration
{%-   if conf.hosts is defined %}

{{ icinga2.config_dir }}/conf.d/hosts/:
  file.directory

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
      - file: {{ icinga2.config_dir }}/conf.d/hosts/
    - watch_in:
      - service: icinga2_service_reload
    - contents: |
{{ printconfig("object", "Host", host, hostconf) }}

{%-         if hostconf.services is defined %}
{{ path}}:
  file.directory

{%-           for service, serviceconf in hostconf.services.items() %}

{{ path }}/{{ service }}.conf:
  file.managed:
    - require:
      - file: {{ icinga2.config_dir }}/conf.d/hosts/{{ host }}
    - watch_in:
      - service: icinga2_service_reload
    - contents: |
{{ printconfig("object", "Service", service, serviceconf) }}

{%-           endfor %}
{%-         endif %}
{%-       endif %}
{%-     endfor %}
{%-   endif %}
### End hosts configuration

### Begin hostgroups configuration

{%-   if conf.hostgroups is defined %}
{{ icinga2.config_dir }}/conf.d/hostsgroups.conf:
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
{{ icinga2.config_dir }}/conf.d/templates:
  file.directory:
    - require:
      - pkg: icinga2_pkgs

{%-     for template, templateinfo in conf.templates.items() %}
{{ icinga2.config_dir }}/conf.d/templates/{{ template }}.conf:
  file.managed:
    - require:
      - file: {{ icinga2.config_dir }}/conf.d/templates
    - watch_in:
      - service: icinga2_service_reload
    - contents: |
{{ printconfig("template", templateinfo["type"], template, templateinfo["conf"]) }}

{%-     endfor%}
{%-   endif %}
### End template configuration

### Begin user configuration
{%-   if conf.users is defined %}
{{ icinga2.config_dir }}/conf.d/users:
  file.directory:
    - require:
      - pkg: icinga2_pkgs

{%-     for user, userinfo in conf.users.items() %}
{{ icinga2.config_dir }}/conf.d/users/{{ user }}.conf:
  file.managed:
    - require:
      - file: {{ icinga2.config_dir }}/conf.d/users
    - watch_in:
      - service: icinga2_service_reload
    - contents: |
{{ printconfig("object", "User", user, userinfo) }}

{%-     endfor%}
{%-   endif %}
### End user configuration

### Begin apply configuration
{% set applies = { "downtimes": "ScheduledDowntime", "services": "Service", "notifications": "Notification"} %}
{%-   for type, objecttype in applies.items() %}

{%-     if type in conf %}
{{ icinga2.config_dir }}/conf.d/{{ type }}:
  file.directory:
    - require:
      - pkg: icinga2_pkgs

{%-       for apply, applyinfo in conf[type].items() %}
{% set applyto = applyinfo["apply_to"]|default('') %}
{{ icinga2.config_dir }}/conf.d/{{ type }}/{{ apply }}.conf:
  file.managed:
    - require:
      - file: {{ icinga2.config_dir }}/conf.d/{{ type }}
    - watch_in:
      - service: icinga2_service_reload
    - contents: |
{{ printconfig("apply", applyinfo.get("type", objecttype), apply, applyinfo.get("conf", {}), applyto) }}

{%-       endfor%}
{%-     endif %}

{%-   endfor%}
### End apply configuration

{% endif %}

