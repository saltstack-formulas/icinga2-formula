{% for activate in ['enable', 'disable']%}

/usr/local/bin/icinga2-{{ activate }}-feature:
  file.managed:
    - mode: 755
    - content: |
        #!/bin/bash
        icinga2 feature {{ activate }} $@

{% endfor %}
