---
title: Cassandra to PostgreSQL Migration Guidelines 
---

This guide walks you through migrating {{site.base_gateway}} from a Cassandra DB-backed 
[traditional](/gateway/{{page.release}}/production/deployment-topologies/traditional/) deployment to a PostgreSQL-backed
[hybrid](/gateway/{{page.release}}/production/deployment-topologies/hybrid-mode/) deployment.

This guide uses a blue-green migration approach. In this approach, DNS switching helps cut traffic over from a Blue environment to a Green environment. This provides the ability to roll back faster if an issue is detected. 

We recommend using [decK](/deck/), Kong's declarative configuration management tool.

Migration steps:

1. Build a target {{site.base_gateway}} hybrid environment with PostgreSQL. This acts as your blank canvas.
1. Use decK to export (`dump`) configuration from the old traditional Cassandra-backed deployment. 
1. Use decK to import (`sync`) the configuration to the new hybrid PostgreSQL-backed deployment.
1. Create basic auth credentials and local RBAC users using either the Admin Api or Kong Manager.
1. When the {{site.base_gateway}} configuration has been migrated over to the green environment, slowly redirect traffic via canary into the green environment. This lowers the risk of the release with a fast rollback mechanism in place.


## Considerations

While the document provides high level guidelines, actual migration steps may differ based on the following factors:
* Complexity of the Kong deployment environment
* Kong plugins
* Custom plugins
* External touch points to the Gateway (for example, OIDC with external IdPs)
* Number of configuration entities, for example services and routes
* If running an older version of {{site.base_gateway}}, we recommend doing a {{site.base_gateway}} version upgrade before the database migration. This reduces the moving parts in the upgrade procedure.
* If you're using Cassandra, you likely have a traditional deployment. We recommend taking this opportunity to review the [deployment topology options](/gateway/{{page.release}}/production/deployment-topologies/) for {{site.base_gateway}} and converting to a hybrid mode deployment, if possible.

The following diagram shows the architecture of a hybrid mode deployment, which means there is a split between the {{site.base_gateway}} control and data planes. You can follow the same database migration approach for {{site.base_gateway}} instances deployed in traditional mode.

![migration image](/assets/images/products/gateway/migration.png)


## Prerequisites
* The {{site.base_gateway}} blue environment (using Cassandra) and green environment (using PostgreSQL) are running the same Gateway version.
* In the following examples, blue is deployed in traditional mode and green is deployed in hybrid mode. If you prefer to migrate to a traditional deployment, you can still follow the steps, but you don't need to worry about performing separate control plane and data plane tasks.


## Migration approach
The following steps should be tested in a non-production environment. Any gaps in the target state should be identified and remediated before running it in production.

| Step | Name               | Description                                                                                           | 
|------|--------------------|-------------------------------------------------------------------------------------------------------|
| 1    | Platform build     | Build the green environment with {{site.base_gateway}} using the same version as the blue environment |
| 2    | Database setup     | Build a new Postgres DB and connect it to the green environment                                     |
| 3    | Regression testing | Deploy your setup into the new system and regression test it. Clean up the deployment when testing is completed . |


## Preparation



| Step | Name                          | Description                                                                                                 |
|------|-------------------------------|-------------------------------------------------------------------------------------------------------------|
| 1    | Change embargo                | Place a change embargo on the old environment preventing new deployments or configuration changes             |
| 2    | Blue environment backup       | Make a backup of the blue environment's Cassandra database and place it into redundant storage              |
| 3    | Observability setup           | Create dashboards to track the health of the new environment                                           |
| 4    | Go/No Go checkpoint           | Go/No Go decision point for the migration execution                                                         |



## Execution

The goal of this phase is to reproduce the {{site.base_gateway}} configuration in the blue environment and perform regression and smoke testing ahead of live traffic cut-over. 


| Step | Name                  | Description                                                                                                           |
|------|-----------------------|-----------------------------------------------------------------------------------------------------------------------|
| 1    | Configuration dump    | - Execute the `deck dump` command against the blue environment for each workspace to build a YAML representation of the Kong estate<br>- Execute `deck dump --rbac-resources-only` against the blue environment for each workspace to build a YAML representation of any RBAC resources created<br>- If using the Kong Dev Portal, run the `portal fetch` command via the Portal CLI to build a representation of the Dev Portal assets for a workspace |
| 2    | Configuration sync    | - Change decK to work with the green environment, and execute `deck sync` to push the configuration to the green environment<br>- Change the Portal CLI to work against the green environment, and execute `portal deploy` to push the Dev Portal configuration against the new environment |
| 3    | Regression testing    | Execute regression tests against the green environment backed by PostgreSQL                                             |
| 4    | Go/No Go checkpoint   | If all tests pass, proceed with traffic cut over                                                                         |


## Traffic cut over

The purpose of this phase is to migrate traffic in a controlled manner, with a rapid fallback mechanism if a problem is detected. You can increase or decrease the wait times before increasing the canary split depending on the risk tolerance.


| Step | Name                                                  | Description|
|------|-------------------------|---------------------------------------|-----------|
| 1    | Canary 1% of traffic to the new green environment      | Canary 1% of traffic to the new environment and monitor the traffic health. |
| 2    | Canary 5% of traffic to the new green environment      | Increase traffic split to 5% and monitor. |
| 3    | Canary 10% of traffic to the new green environment     | Increase traffic split to 10% and monitor. |
| 4    | Canary 50% of traffic to the new green environment     | Increase traffic split to 50% and monitor.|
| 5    | Switch 100% of traffic to the new green environment    | Perform a full DNS switch over to point to the new green environment.|
| 6    | Take down old platform | After 24 hours when confidence is high, take down the old platform. |




## Next steps

* If using the Basic Authentication plugin, the passwords are hashed and encrypted in the database. A decK dump doesn't export these credentials, so it is impossible to get the passwords out of the database in the cleartext. You must migrate these credentials using the Admin Api or Kong Manager.

* Admin users on the {{site.base_gateway}} control plane are not propagated using decK. Migrate them using the Kong Admin API.




After migration, basic authentication credentials can be managed by decK. See the following topics to learn how to manage secrets with deck:

* [Gateway secret management GCP](/gateway/{{page.release}}/kong-enterprise/secrets-management/backends/gcp-sm/)
* [Secrets management with decK](/deck/latest/guides/vaults/#configure-a-secret-vault)
