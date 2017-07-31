{% from "icinga2/map.jinja" import icinga2 with context %}

icinga2_service:
  service.running:
    - name: {{ icinga2.service }}
    - enable: True
