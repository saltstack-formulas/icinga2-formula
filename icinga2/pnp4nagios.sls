
pnp4nagios_packages:
  pkg.installed:
    - pkgs:
      - pnp4nagios
      - pnp4nagios-web
    - install_recommends: False

enable_perfdata:
  cmd.run:
    - name: icinga2-enable-feature perfdata
    - watch_in:
      - service: icinga2

/etc/default/npcd:
  file.append:
    - text: RUN="yes"

npcd:
  service.running:
    - require:
      - file: /etc/default/npcd

/etc/pnp4nagios/apache.conf:
  file.managed:
    - source: salt://icinga2/files/apache.noauth.conf