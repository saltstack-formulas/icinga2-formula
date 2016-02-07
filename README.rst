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

``icinga2.classicui``
---------------------

Installs and configures the icinga2 package and configures the classicui.

``icinga2.nrpe-server``
-----------------------

Installs and configures the nrpe-server to perform checks on non-local hosts.
