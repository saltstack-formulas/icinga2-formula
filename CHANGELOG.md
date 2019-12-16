# Changelog

# [0.9.0](https://github.com/saltstack-formulas/icinga2-formula/compare/v0.8.0...v0.9.0) (2019-12-16)


### Features

* **icinga_web2:** run postgres service after installing package ([9e8485e](https://github.com/saltstack-formulas/icinga2-formula/commit/9e8485ed3dc8359e9ebc9fc80559880dc19b2ecf))

# [0.8.0](https://github.com/saltstack-formulas/icinga2-formula/compare/v0.7.1...v0.8.0) (2019-12-11)


### Bug Fixes

* **pgsql-ido.sls:** ensure state `debconf.set` is available ([310b2f5](https://github.com/saltstack-formulas/icinga2-formula/commit/310b2f50131a7e60e110d20af4bc487daeb8a6f1))
* **postgresql-server.sls:** fix missing import ([dece815](https://github.com/saltstack-formulas/icinga2-formula/commit/dece8157b447c8fe2f5abbab0d14bc01af016228))
* **repo:** prepare basic structure for all available platforms ([33f7694](https://github.com/saltstack-formulas/icinga2-formula/commit/33f7694c0dc270a9020a0ffe8b5e43e38682137a))
* **salt-lint:** fix all errors (or add to ignores) ([cae6252](https://github.com/saltstack-formulas/icinga2-formula/commit/cae62526e6c920056171ded3e6a3c2dfd127999d))
* **yamllint:** fix all errors (or add to ignores) ([860f72b](https://github.com/saltstack-formulas/icinga2-formula/commit/860f72bd89df9f01d7bb75f4370a2b89f68c545e))


### Documentation

* **readme:** modify according to standard structure ([fb0aca8](https://github.com/saltstack-formulas/icinga2-formula/commit/fb0aca8105cf95f7b4b098851d2fa56d67575d8c))
* **readme:** move to `docs/` directory ([70105f0](https://github.com/saltstack-formulas/icinga2-formula/commit/70105f0b116120f7d54b52b98f954c703700cda0))


### Features

* **repositories.sls:** add inline `stretch-backports` repo ([5353313](https://github.com/saltstack-formulas/icinga2-formula/commit/5353313e0e9afd16801e97906e7320ab3356fdb4))
* **semantic-release:** implement for this formula ([d632339](https://github.com/saltstack-formulas/icinga2-formula/commit/d63233988227752cfce108bee635e0dc5a131189))


### Tests

* **inspec:** add tests for package, config & service ([da16c4e](https://github.com/saltstack-formulas/icinga2-formula/commit/da16c4e54c3ced76615e79584e3b7c102900ce39))
* **pillar:** add for `default` suite based on `pillar.example` ([a1ee8a1](https://github.com/saltstack-formulas/icinga2-formula/commit/a1ee8a187ec1b74cac416a10a7274ca59f9c4ff6))
