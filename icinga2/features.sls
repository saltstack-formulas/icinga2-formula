{% from "icinga2/map.jinja" import icinga2 with context %}
{% from "icinga2/map.jinja" import feature with context %}

{%- if icinga2.features != None %}
{%- for name, enable in icinga2.features.items() %}
{{ feature(name, enable) }}
{%  endfor %}
{%- endif %}
