{% from "icinga2/map.jinja" import icinga2 with context %}

icinga2_service_restart:
  service.running:
    - name: {{ icinga2.service }}
    - enable: True

icinga2_service_reload:
  service.running:
    - name: {{ icinga2.service }}
    - enable: True
    - reload: True
