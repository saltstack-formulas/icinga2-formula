/* Creates a user called admin with password admin in the database. Also changes the owner of the database to icinga2web */

COPY icingaweb_user (name, active, password_hash, ctime, mtime) FROM stdin;
admin	1	\\x243124f4cc842ce019d0c52446316668396747385539446772612f3055744b57712f	2015-08-29 20:07:51	\N
\.

ALTER DATABASE icinga2web OWNER TO icinga2web
