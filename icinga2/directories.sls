{%- from "icinga2/map.jinja" import icinga2 with context %}

include:
  - .install

icinga2_confd_dir:
  file.directory:
    - name: {{ icinga2.confd_dir }}
    - require:
      - sls: icinga2.install

icinga2_check_command_dir:
  file.directory:
    - name: {{ icinga2.check_command_dir }}
    - require:
      - sls: icinga2.install

icinga2_config_scripts_dir:
  file.directory:
    - name: {{ icinga2.scripts_dir }}
    - require:
      - sls: icinga2.install
