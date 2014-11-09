
pnp4nagios_packages:
  pkg.installed:
    - pkgs:
      - pnp4nagios
      - pnp4nagios-web
    - install_recommends: False