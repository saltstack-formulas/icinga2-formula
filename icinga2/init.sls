include:
  - .repositories

{% from "icinga2/map.jinja" import icinga2 with context %}

{%- macro printconfig(type, object, name, config, applyto="")%}
        {{ type }} {{ object }} "{{ name }}" {% if applyto !="" %}to {% endif %}{{ applyto }}{% if applyto !="" %} {% endif %}{
{%- for key, value in config.iteritems()%}
{%- if key == "import" %}
          {{key}} "{{ value }}"
{%- endif %}
{%- endfor %}

{%- for key, value in config.iteritems()%}
{%- if key == "import" %}
{%- elif key == "vars"  %}
{%- for varkey, varvalue in config.vars.iteritems() %}
          vars.{{ varkey }} = "{{ varvalue }}"
{%- endfor %}

{%- elif key == "services"  %}

{%- elif key == "ranges"  %}
          ranges = {
{%- for rangekey, rangevalue in config.ranges.iteritems() %}
            {{ rangekey }} = "{{ rangevalue }}"
{%- endfor %}
          }

{%- elif key in ["states", "types", "user_groups"] %}
          {{ key }} = [ {{ value|join(",") }} ]

{%- elif key == "assign" or key == "ignore" %}
{%- for item in value %}
          {{ key }} where {{ item }}
{%- endfor %}

{%- elif value is number %}
          {{ key }} = {{ value }}

{%- else %}
          {{ key }} = "{{ value }}"
{%- endif %}
{%- endfor %}
        }
{%-endmacro%}

{% if grains['os_family'] in ['Debian']  %}

icinga2:
  pkg.installed:
    - require:
      - pkgrepo: icinga_repo
  service.running:
    - enable: True

{% for package in icinga2.pkgs %}
{{ package }}:
  pkg.installed:
    - require:
      - pkgrepo: icinga_repo
{% endfor %}

### Begin hosts configuration
{% if icinga2.conf.hosts is defined %}

/etc/icinga2/conf.d/hosts/:
  file.directory

{% for host, hostconf in icinga2.conf.hosts.iteritems() %}

/etc/icinga2/conf.d/hosts/{{ host }}.conf:
  file.managed:
    - require:
      - file: /etc/icinga2/conf.d/hosts/
    - watch_in:
      - service: icinga2
    - contents: |
{{ printconfig("object", "Host", host, hostconf) }}

{% if hostconf.services is defined %}
/etc/icinga2/conf.d/hosts/{{ host }}:
  file.directory

{% for service, serviceconf in hostconf.services.iteritems() %}

/etc/icinga2/conf.d/hosts/{{ host }}/{{ service }}.conf:
  file.managed:
    - require:
      - file: /etc/icinga2/conf.d/hosts/{{ host }}
    - watch_in:
      - service: icinga2
    - contents: |
{{ printconfig("object", "Service", service, serviceconf) }}

{% endfor%}
{% endif %}

{% endfor %}
{% endif %}

### End hosts configuration

### Begin hostgroups configuration

{% if icinga2.conf.hostgroups is defined %}
/etc/icinga2/conf.d/hostsgroups.conf:
  file.managed:
    - watch_in:
      - service: icinga2
    - contents: |
{% for hostgroup, hostgroupconf in icinga2.conf.hostgroups.iteritems() %}
{{ printconfig("object", "HostGroup", hostgroup, hostgroupconf) }}

{% endfor %}
{% endif %}
### End hostgroups configuration

### Begin template configuration
{% if icinga2.conf.templates is defined %}
/etc/icinga2/conf.d/templates:
  file.directory:
    - require:
      - pkg: icinga2

{% for template, templateinfo in icinga2.conf.templates.iteritems() %}
/etc/icinga2/conf.d/templates/{{ template }}.conf:
  file.managed:
    - require:
      - file: /etc/icinga2/conf.d/templates
    - watch_in:
      - service: icinga2
    - contents: |
{{ printconfig("template", templateinfo["type"], template, templateinfo["conf"]) }}

{% endfor%}
{% endif %}
### End template configuration

### Begin apply configuration
{% set applies = { "downtimes": "ScheduledDowntime", "services": "Service", "notifications": "Notification"} %}
{% for type, objecttype in applies.iteritems() %}

{% if icinga2.conf[type] is defined %}
/etc/icinga2/conf.d/{{ type }}:
  file.directory:
    - require:
      - pkg: icinga2

{% for apply, applyinfo in icinga2.conf[type].iteritems() %}
{% set applyto = applyinfo["apply_to"]|default('') %}
/etc/icinga2/conf.d/{{ type }}/{{ apply }}.conf:
  file.managed:
    - require:
      - file: /etc/icinga2/conf.d/{{ type }}
    - watch_in:
      - service: icinga2
    - contents: |
{{ printconfig("apply", applyinfo["type"], apply, applyinfo["conf"], applyto) }}

{% endfor%}
{% endif %}

{% endfor%}
### End apply configuration

{% endif %}
