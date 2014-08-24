# Test icinga2 standalone
FROM      martinhoefling/salt-minion:debian
MAINTAINER Martin Hoefling <martin.hoefling@gmx.de>

# push formula
ADD icinga2 /srv/salt/icinga2
ADD pillar.example /srv/pillar/example.sls
RUN echo "file_client: local" > /etc/salt/minion.d/local.conf
RUN echo "base:" > /srv/pillar/top.sls
RUN echo "  '*':" >> /srv/pillar/top.sls
RUN echo "    - example" >> /srv/pillar/top.sls
# starting the icinga2 server fails in docker
RUN salt-call --local state.sls icinga2 | tee log.txt && grep "Failed:     0" log.txt

# Test nrpe server installation
FROM      martinhoefling/salt-minion:debian
MAINTAINER Martin Hoefling <martin.hoefling@gmx.de>

# push formula
ADD icinga2 /srv/salt/icinga2
ADD pillar.example /srv/pillar/example.sls
RUN echo "file_client: local" > /etc/salt/minion.d/local.conf
RUN echo "base:" > /srv/pillar/top.sls
RUN echo "  '*':" >> /srv/pillar/top.sls
RUN echo "    - example" >> /srv/pillar/top.sls
# starting the nrpe server fails in docker
RUN salt-call --local state.sls icinga2.nrpe-server | tee log.txt && grep "Failed:    0" log.txt
