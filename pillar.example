icinga2:
  lookup:
    pkgs:
      - nagios-nrpe-plugin
    nrpe:
      config:
        server_port: 5666
        commands:
          check_users: /usr/lib/nagios/plugins/check_users -w 5 -c 10
      defaults:
        DAEMON_OPTS: "\"--no-ssl\""
    classicui:
      users:
        admin: $apr1$VxiIkiLL$44VZAqDUUsOoW4zns1USw0
        anotheradmin: $apr1$R9s6cQSW$C5KdQSdm5/1XACnRFMWNO/

    conf:
      templates:
        special-host:
          type: Host
          conf:
            vars:
              sla: "24x5"
        special-downtime:
          type: ScheduledDowntime
          conf:
            ranges:
              monday: "02:00-03:00"
        special-notification:
          type: Notification
          conf:
            types:
              - FlappingStart
              - FlappingEnd
      hosts:
        example.com:
          import: generic-host
          address: 1.2.3.4
          vars:
            sla: "24x7"
          services:
            http:
              import: generic-service
              host_name: example.com
              check_command: http
              vars:
                sla: "24x7"
            ssh:
              import: generic-service
              host_name: example.com
              check_command: ssh
              vars:
                sla: "24x7"
            ssh_alt:
              import: generic-service
              host_name: example.com
              check_command: ssh
              vars:
                ssh_port: 43
                sla: "24x7"

