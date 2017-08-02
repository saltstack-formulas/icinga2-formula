===============
icinga2-formula
===============

A salt formula that installs and configures icinga2, currently on Debian and Ubuntu only, but other
installation source can be easily added. Configuration via pillar currently for hosts and
services only.

.. note::

Suggestions, pull-requests, bug reports and comments are welcome.


Available states
================

.. contents::
    :local:


``icinga2``
-----------

Installs and configures the icinga2 package.
Includes ``icinga.repositories``.


``icinga2.classicui``
---------------------

Includes ``icinga2`` and configures the classicui.


``icinga2.icinga-web``
----------------------

Installs the (old) Icinga Web UI.

Includes:

- ``icinga2.pgsql-ido``
- ``icinga2.postgresql``
- ``icinga2.legacy-feature-activation``


``icinga2.icinga-web2``
-----------------------

Includes:

- ``icinga2.icinga-web2-core``
- ``icinga2.icinga-web2-database``
- ``icinga2.pgsql-ido``
- ``icinga2.postgresql``
- ``icinga2.legacy-feature-activation``
- ``icinga2.vagrant``
- ``icinga2.iptables``


``icinga2.nrpe-server``
-----------------------

Installs and configures the nrpe-server to perform checks on non-local hosts.


``icinga2.pnp4nagios``
----------------------

Installs and configures PNP4Nagios.


``icinga2.vagrant``
-------------------

Installs and configures Apache2 and populates the DB in the presence of a vagrant user.


States which are independent (reusable) building blocks
=======================================================


``icinga2.icinga-web2-database``
-----------------------

Creates the DB user and the DB itself.
(Makes only sense if the DB shall run on the same host as Icinga2)


``icinga2.icinga-web2-core``
-----------------------

Installs the (new) Icinga Web UI.


``icinga2.iptables``
----------------------

Accepts connections on port 80/tcp.


``icinga2.pgsql-ido``
---------------------

Installs and configures ``icinga2-ido-pgsql``.
You may want to add ``icinga2.postgresql``


``icinga2.postgresql``
----------------------

Installs PostgreSQL server and client.


``icinga2.repositories``
------------------------

Adds the Debian / Ubuntu repository to get Icinga2 packages from if (and only if)
the machine happens to run one of the mentioned operating systems.
