#!/bin/bash

#A script to prepare icinga2web database and to finalize the configuration;
#A pre-requisite is the icinga2 core;

sudo -u postgres psql -d icinga2web -f /tmp/icingaschema/changetemplateencoding.sql
sudo -u postgres psql -d icinga2web -f /tmp/icingaschema/pgsql.schema.sql
sudo -u postgres psql -d icinga2web -f /tmp/icingaschema/postgresql.sql
sudo -u postgres psql -d icinga2web -f /tmp/icingaschema/prepare_db.sql
sudo sed -i.bak "s/---xxx---\.*/`sudo grep dbc_dbpass /etc/dbconfig-common/icinga-idoutils.conf |grep -v \"#\"|cut -d \"=\" -f2| cut -d \"'\" -f2`/" /etc/icingaweb2/resources.ini
sleep 3
/tmp/icingaschema/psql_chown.sh icinga2web icinga2web 2>&1
