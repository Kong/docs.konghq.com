---
title: Migration guidelines: Cassandra to Postgres
---

The purpose of this document is to provide an approach aimed at migrating Cassandra db backed Kong deployment to Postgresql backed Kong deployment. This document will guide migration from traditional Kong deployment topology to hybrid.

A Blue/Green migration approach is proposed in this document. To achieve the easiest possible migration, declarative tools Kong [DecK](https://docs.konghq.com/deck/latest/) will be utilized. DNS switching will be used to cut traffic over from a Blue environment to a Green environment. This will provide the ability to rollback faster if an issue is detected. 

The steps to migrate, at a high level are: 

* New target Kong environment will be built as a blank canvas with Postgresql db with hybrid deployment. 
* Kong deck is used to take export (dump) from old traditional cassandra backed Kong deployment. 
* Kong deck is used to import (sync) to new hybrid postgresql backed Kong deployment.
* Basic auth credentials and local rbac users will need to be created separately either using admin api or manually(Kong Manager).
* When the Kong configuration has been migrated over to the green environment, traffic can be slowly canaried into the green environment to de-risk the release with a fast rollback mechanism in place.


### Considerations

While the document provides high level guidelines, actual migration steps may differ based on the following factors:
* complexity of the Kong deployment environment
* Kong plugins used
* Usage of custom plugins
* External touchpoints to the Gateway (e.g. OIDC)
* number of configuration entities - e.g. services and routes
* If running an older version of Kong it is recommended to do a Kong version upgrade before the database migration (To reduce the moving parts in the upgrade procedure)
* Using cassandra means may not be using the Kong Hybrid Mode deployment and might be deployed in the traditional mode, we recommend taking this opportunity to review the architecture to leverage the latest features of Kong Enterprise.

While the diagram shows the split between the Kong control and Data planes, the same approach can be followed for Kong instances deployed in Classic Mode.

![migration image](_assets/images/docs/gateway/migration.png)


### Assumptions
The Kong blue environment (Using Cassandra) and green environment (using Postgres) are running the same Kong Enterprise version
Blue is deployed in traditional mode and green environment is running with Kong deployed in a hybrid deployment mode.


## Migration Approach
The following steps should be tested in a non-production environment. Any gaps in the target state should be identified and remediated before running it in production.

| Step | Name               | Description                                                                                           | Completed |
|------|--------------------|-------------------------------------------------------------------------------------------------------|-----------|
| 1    | Platform build     | The Green environment is built with Kong Enterprise setup using the same version as the Blue environment |           |
| 2    | Database setup     | A new Postgres DB is built and connected to the green environment                                     |           |
| 3    | Regression Testing | A deployment is made into the new system and regression tested. The deployment is cleaned up when testing is completed |           |


## Preperation



| Step | Name                          | Description                                                                                                 | Completed |
|------|-------------------------------|-------------------------------------------------------------------------------------------------------------|-----------|
| 1    | Change embargo                | A change embargo is placed on the environment preventing new deployments or configuration changes             |           |
| 2    | Blue environment backup       | A backup is taken on the blue environment's Cassandra database and placed into redundant storage              |           |
| 3    | Observability setup           | Dashboards are created to track the health of the new environment                                           |           |
| 4    | Go/No go checkpoint           | Go/No go decision point for the migration execution                                                         |           |



## Execution

The goal of this phase is to reproduce the Kong configuration in the blue environment and perform regression/smoke testing ahead of live traffic cut-over. 


| Step | Name                  | Description                                                                                                           | Completed |
|------|-----------------------|-----------------------------------------------------------------------------------------------------------------------|-----------|
| 1    | Configuration dump    | - Execute the "deck dump" command against the blue environment, for each workspace to build a YAML representation of the Kong estate<br>- Execute "deck dump --rbac-resources-only" against the blue environment for each workspace to build a YAML representation of any RBAC resources created<br>- If using the Kong Developer Portal, run the "portal fetch" command to build a representation of the Dev Portal Assets for a workspace |           |
| 2    | Configuration sync    | - Change decK to work with the green environment, and execute "deck sync" to push the configuration to the green environment<br>- Change Portal CLI to work against the green environment, and execute "portal deploy" to push the Dev Portal configuration against the new environment |           |
| 3    | Regression Testing    | Execute regression tests against the green environment backed by PostGres                                               |           |
| 4    | Go/No go checkpoint   | If all tests pass proceed with traffic cutover                                                                         |           |


## Traffic cutover

The purpose of this phase is to migrate traffic in a controlled manner, with a rapid fall back mechanism if a problem is detected. The wait times before increasing the canary split can be increased/decreased depending on risk appetite.


| Step | Name                                                  | Description                                                                                                                     | Completed |
|------|-------------------------|---------------------------------------|-----------|
| 1    | Canary 1% of traffic to the new green environment      | Canary 1% of traffic to the new environment and monitor the traffic health.                                                     |           |
| 2    | Canary 5% of traffic to the new green environment      | Increase traffic split to 5% and monitor.                                                                                       |           |
| 3    | Canary 10% of traffic to the new green environment     | Increase traffic split to 10% and monitor.                                                                                      |           |
| 4    | Canary 50% of traffic to the new green environment     | Increase traffic split to 50% and monitor.                                                                                      |           |
| 5    | Switch 100% of traffic to the new green environment    | Perform a full DNS switch over to point to the new green environment.                                                           |           |
| 6    | Demise old platform                                    | After 24 hours when confidence is high, demise of the old platform.                                                              |           |




## Limitations


* If basic auth plugin is used, the passwords are hashed and encrypted in the database which a decK dump will not export and it is impossible to get the passwords out of the database in the cleartext. Migrating these credentials will have to be performed using admin api or Kong Manager.

* Admin users on the Kong management plane are not propagated using DecK, and will have to be done using the Kong Admin API




Going forward, the basic authentication credentials can be managed through the Kong deck. See below document to integrate with GCP secrets and secrets management with deck.

Gateway secret management GCP
https://docs.konghq.com/gateway/latest/kong-enterprise/secrets-management/backends/gcp-sm/#main
Secrets management with deck
https://docs.konghq.com/deck/latest/guides/vaults/#configure-a-secret-vault
