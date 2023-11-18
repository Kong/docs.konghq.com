---
title: Upgrade considerations
---

Having talked about capabilities and limitations of all upgrade strategies, and also the nominated strategy for each deployment mode, it is time we focus on some universal factors that may influence the upgrade.

When a strategy is selected for the target deployment mode, it does not guarantee it is feasible to do the upgrade immediately. On the contrary, when scheduling the upgrade procedures, you must account for the following factors.

* During the upgrade process, no changes must be made to the configuration database.  Thus, do not call Admin API writes, directly operate on the database or update the configuration through Kong Manager, deck or kong config CLI until the upgrade is finished.
* Review compatibility between new version Y and your existing platform, like OS version, database version, Kubernetes version, Helm prerequisites, hardware resources, etc.
* Carefully review all changelogs from current version X all the way up to the target version Y. If there are any conflicts, you must prepare for that, especially for schema changes and functionality removal. For example, if a deprecated schema is in use, please update `kong.conf` or Kong configuration data accordingly when configuring the new cluster.
* Update `kong.conf` directly or via environment variables based on the changelog. Although reusing `kong.conf` from version X is possible, that is not always true, like a parameter removal, argument change, etc. For example, parameter “pg_ssl_version” defaults to “tlsv1” in 2.8.2.4, but in 3.2.2.1, “tlsv1” is not a valid argument any more. Breaking changes in `kong.conf` in a minor version upgrade are infrequent, but do happen.
* If you have custom plugins, please review the code against changelogs as well as test the custom plugin using the new version Y.
* If you have modified any templates like nginx-kong.conf and nginx-kong-stream.conf, please carry the customization onto that of the new version Y as well. Refer to Kong Gateway Nginx Directives for detailed customization guide.
* Cassandra has been removed from Kong Gateway 3.4.0.0 onwards. Please migrate to PostgreSQL according to Cassandra to PostgreSQL Migration Guidelines.
* Do not forget to apply Kong Licence to the new Gateway cluster.
* Last but not the least, please take a backup. Pay full attention to Keyring Materials Backup.


