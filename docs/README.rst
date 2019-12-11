.. _readme:

icinga2-formula
===============

|img_travis| |img_sr|

.. |img_travis| image:: https://travis-ci.com/saltstack-formulas/icinga2-formula.svg?branch=master
   :alt: Travis CI Build Status
   :scale: 100%
   :target: https://travis-ci.com/saltstack-formulas/icinga2-formula
.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release

A salt formula that installs and configures icinga2, currently on Debian and Ubuntu only, but other
installation source can be easily added. Configuration via pillar currently for hosts and
services only.

.. note::

Suggestions, pull-requests, bug reports and comments are welcome.

.. contents:: **Table of Contents**

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

If you need (non-default) configuration, please pay attention to the ``pillar.example`` file and/or `Special notes`_ section.

Contributing to this repo
-------------------------

**Commit message formatting is significant!!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

Special notes
-------------

None

Available states
----------------

.. contents::
   :local:

``icinga2``
^^^^^^^^^^^

Installs and configures the icinga2 package.
Includes ``icinga.repositories``.


``icinga2.icinga-web2``
^^^^^^^^^^^^^^^^^^^^^^^

Includes:

- ``icinga2.icinga-web2-core``
- ``icinga2.icinga-web2-database``
- ``icinga2.pgsql-ido``
- ``icinga2.postgresql-client``
- ``icinga2.postgresql-server``


``icinga2.nrpe-server`` (DEPRECATED)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Installs and configures the nrpe-server to perform checks on non-local hosts.


States which are independent (reusable) building blocks
-------------------------------------------------------

.. contents::
    :local:


``icinga2.icinga-web2-database``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Creates the DB user and the DB itself.
(Makes only sense if the DB shall run on the same host as Icinga2)


``icinga2.icinga-web2-core``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Installs the (new) Icinga Web UI.


``icinga2.pgsql-ido``
^^^^^^^^^^^^^^^^^^^^^

Installs and configures ``icinga2-ido-pgsql``.
You may want to add ``icinga2.postgresql-client``


``icinga2.postgresql-client``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Installs PostgreSQL client.


``icinga2.postgresql-server``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Installs PostgreSQL server.


``icinga2.repositories``
^^^^^^^^^^^^^^^^^^^^^^^^

Adds the Debian / Ubuntu repository to get Icinga2 packages from if (and only if)
the machine happens to run one of the mentioned operating systems.


``icinga2.check_command.openvpn``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Sets up CheckCommand ``openvpn`` using `<https://github.com/liquidat/nagios-icinga-openvpn>`.

``icinga2.notification.xmpp``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Sets up notification via XMPP using `slixmpp
<https://lab.louiz.org/poezio/slixmpp>`_.

Testing
-------

Linux testing is done with ``kitchen-salt``.

Requirements
^^^^^^^^^^^^

* Ruby
* Docker

.. code-block:: bash

   $ gem install bundler
   $ bundle install
   $ bin/kitchen test [platform]

Where ``[platform]`` is the platform name defined in ``kitchen.yml``,
e.g. ``debian-9-2019-2-py3``.

``bin/kitchen converge``
^^^^^^^^^^^^^^^^^^^^^^^^

Creates the docker instance and runs the ``template`` main state, ready for testing.

``bin/kitchen verify``
^^^^^^^^^^^^^^^^^^^^^^

Runs the ``inspec`` tests on the actual instance.

``bin/kitchen destroy``
^^^^^^^^^^^^^^^^^^^^^^^

Removes the docker instance.

``bin/kitchen test``
^^^^^^^^^^^^^^^^^^^^

Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^

Gives you SSH access to the instance for manual testing.
