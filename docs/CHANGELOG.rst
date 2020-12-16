
Changelog
=========

`0.10.0 <https://github.com/saltstack-formulas/icinga2-formula/compare/v0.9.0...v0.10.0>`_ (2020-12-16)
-----------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **pillar.example:** fix ``yamllint`` violation [skip ci] (\ `c011aa6 <https://github.com/saltstack-formulas/icinga2-formula/commit/c011aa62935f58349c11941f867b3b2bac6ba139>`_\ )

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **gemfile:** restrict ``train`` gem version until upstream fix [skip ci] (\ `602d65f <https://github.com/saltstack-formulas/icinga2-formula/commit/602d65fff0cc4d762d8c2b8cd7e9759e6e6d1a4c>`_\ )
* **gemfile.lock:** add to repo with updated ``Gemfile`` [skip ci] (\ `0749adc <https://github.com/saltstack-formulas/icinga2-formula/commit/0749adc99315ec174def2d3f5c15b3b4b6ba0945>`_\ )
* **gitlab-ci:** use GitLab CI as Travis CI replacement (\ `753e00b <https://github.com/saltstack-formulas/icinga2-formula/commit/753e00b927ded5b2f15ed72c614d8f564b0fb22a>`_\ )
* **kitchen:** avoid using bootstrap for ``master`` instances [skip ci] (\ `bcba572 <https://github.com/saltstack-formulas/icinga2-formula/commit/bcba57237b8ed86176faac65ad9e567e6f829a17>`_\ )
* **kitchen:** use ``saltimages`` Docker Hub where available [skip ci] (\ `694a428 <https://github.com/saltstack-formulas/icinga2-formula/commit/694a428569c33337d34982df8aea020f1efa5216>`_\ )
* **kitchen+travis:** remove ``master-py2-arch-base-latest`` [skip ci] (\ `623baad <https://github.com/saltstack-formulas/icinga2-formula/commit/623baade4b3ba5835167f40968ecef56e0fc9b6f>`_\ )
* **pre-commit:** add to formula [skip ci] (\ `a4fb4f4 <https://github.com/saltstack-formulas/icinga2-formula/commit/a4fb4f4a5136340ddf5ac295e08b1731e4dacca3>`_\ )
* **pre-commit:** enable/disable ``rstcheck`` as relevant [skip ci] (\ `e405733 <https://github.com/saltstack-formulas/icinga2-formula/commit/e4057336d83eb187a8c6ff52ccbd59856aac9553>`_\ )
* **pre-commit:** finalise ``rstcheck`` configuration [skip ci] (\ `ab3c855 <https://github.com/saltstack-formulas/icinga2-formula/commit/ab3c85541dd7d7f12c55d21aae32a5e53a7b4614>`_\ )
* **travis:** add notifications => zulip [skip ci] (\ `b65f633 <https://github.com/saltstack-formulas/icinga2-formula/commit/b65f6337bc28116ec1a78dd3ee501d60b5fbba63>`_\ )
* **travis:** use ``major.minor`` for ``semantic-release`` version [skip ci] (\ `a37f569 <https://github.com/saltstack-formulas/icinga2-formula/commit/a37f5694b890d6643715bf3e3705e0e22355fef0>`_\ )
* **workflows/commitlint:** add to repo [skip ci] (\ `c14014b <https://github.com/saltstack-formulas/icinga2-formula/commit/c14014b575f43de7c5ef2ba2defc40a461f93470>`_\ )

Documentation
^^^^^^^^^^^^^


* **readme:** fix ``rstcheck`` violation [skip ci] (\ `ec5d9ff <https://github.com/saltstack-formulas/icinga2-formula/commit/ec5d9ffedb813260bfef69ba9c687986e83eb865>`_\ ), closes `/travis-ci.org/github/myii/icinga2-formula/builds/731606737#L259 <https://github.com//travis-ci.org/github/myii/icinga2-formula/builds/731606737/issues/L259>`_

Features
^^^^^^^^


* **config:** allow removal of services (\ `6c1d059 <https://github.com/saltstack-formulas/icinga2-formula/commit/6c1d059be50ee598395057e9c7dd619ec5fe23a1>`_\ )

`0.9.0 <https://github.com/saltstack-formulas/icinga2-formula/compare/v0.8.0...v0.9.0>`_ (2019-12-16)
---------------------------------------------------------------------------------------------------------

Features
^^^^^^^^


* **icinga_web2:** run postgres service after installing package (\ `9e8485e <https://github.com/saltstack-formulas/icinga2-formula/commit/9e8485ed3dc8359e9ebc9fc80559880dc19b2ecf>`_\ )

`0.8.0 <https://github.com/saltstack-formulas/icinga2-formula/compare/v0.7.1...v0.8.0>`_ (2019-12-11)
---------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **pgsql-ido.sls:** ensure state ``debconf.set`` is available (\ `310b2f5 <https://github.com/saltstack-formulas/icinga2-formula/commit/310b2f50131a7e60e110d20af4bc487daeb8a6f1>`_\ )
* **postgresql-server.sls:** fix missing import (\ `dece815 <https://github.com/saltstack-formulas/icinga2-formula/commit/dece8157b447c8fe2f5abbab0d14bc01af016228>`_\ )
* **repo:** prepare basic structure for all available platforms (\ `33f7694 <https://github.com/saltstack-formulas/icinga2-formula/commit/33f7694c0dc270a9020a0ffe8b5e43e38682137a>`_\ )
* **salt-lint:** fix all errors (or add to ignores) (\ `cae6252 <https://github.com/saltstack-formulas/icinga2-formula/commit/cae62526e6c920056171ded3e6a3c2dfd127999d>`_\ )
* **yamllint:** fix all errors (or add to ignores) (\ `860f72b <https://github.com/saltstack-formulas/icinga2-formula/commit/860f72bd89df9f01d7bb75f4370a2b89f68c545e>`_\ )

Documentation
^^^^^^^^^^^^^


* **readme:** modify according to standard structure (\ `fb0aca8 <https://github.com/saltstack-formulas/icinga2-formula/commit/fb0aca8105cf95f7b4b098851d2fa56d67575d8c>`_\ )
* **readme:** move to ``docs/`` directory (\ `70105f0 <https://github.com/saltstack-formulas/icinga2-formula/commit/70105f0b116120f7d54b52b98f954c703700cda0>`_\ )

Features
^^^^^^^^


* **repositories.sls:** add inline ``stretch-backports`` repo (\ `5353313 <https://github.com/saltstack-formulas/icinga2-formula/commit/5353313e0e9afd16801e97906e7320ab3356fdb4>`_\ )
* **semantic-release:** implement for this formula (\ `d632339 <https://github.com/saltstack-formulas/icinga2-formula/commit/d63233988227752cfce108bee635e0dc5a131189>`_\ )

Tests
^^^^^


* **inspec:** add tests for package, config & service (\ `da16c4e <https://github.com/saltstack-formulas/icinga2-formula/commit/da16c4e54c3ced76615e79584e3b7c102900ce39>`_\ )
* **pillar:** add for ``default`` suite based on ``pillar.example`` (\ `a1ee8a1 <https://github.com/saltstack-formulas/icinga2-formula/commit/a1ee8a187ec1b74cac416a10a7274ca59f9c4ff6>`_\ )
