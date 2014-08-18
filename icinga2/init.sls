{% from "icinga2/map.jinja" import icinga2 with context %}

{%- macro printconfig(object, name, config)%}
        object {{ object}} "{{ name }}" {
{%- for key, value in config.iteritems()%}
{%- if key == "import" %}
          {{key}} "{{ value }}"

{%- elif key == "vars"  %}
{%- for key, value in config.vars.iteritems() %}
          vars.{{key}} = "{{ value }}"
{%- endfor %}
{%- elif key == "services"  %}
{%- else %}
          {{ key }} = "{{ value }}"
{%- endif %}
{%- endfor %}
        }
{%-endmacro%}

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

### Begin hosts configuration
{% if icinga2.conf.hosts is defined %}
{% for host, hostconf in icinga2.conf.hosts.iteritems() %}

/etc/icinga2/conf.d/hosts/{{ host }}.conf:
  file.managed:
    - watch_in:
      - service: icinga2
    - contents: |
{{ printconfig("Host", host, hostconf) }}

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
{{ printconfig("Service", service, serviceconf) }}

{% endfor%}
{% endif %}

{% endfor %}
{% endif %}

### End hosts configuration

### Begin template configuration



{% endif %}