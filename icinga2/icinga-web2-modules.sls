{% from "icinga2/map.jinja" import icinga2 with context %}
{% from "icinga2/map.jinja" import module with context %}

{% for name, data in icinga2.icinga_web2.modules.items() %}
{{ module( name,
           data.get("repo", icinga2.icinga_web2.module_repo + name + ".git"),
           data.version,
           data.get("path", icinga2.icinga_web2.module_dir + "/" + name),
           data.get("enable", true)
         ) }}
{% endfor %}
