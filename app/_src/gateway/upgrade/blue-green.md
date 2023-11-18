---
title: Blue-green upgrade
---

Derived from the In-place Upgrade strategy, blue-green upgrade benefits from the fact that “kong migrations up” leaves the database in a state where it can serve requests by either current cluster X or the new cluster Y.  Only when “kong migrations finish” is executed, the compatibility of the database with cluster X lost.

This is a more advanced strategy than the Dual-cluster Upgrade in that there is no need to deploy a new database. It still supports gradually diverting traffic from the current cluster X to the new cluster Y, shown in figure 3. Furthermore, runtime metrics (e.g. Vitals or RLA plugin counters) are sent to the same database. Thus, metrics are continuously collected from both clusters during the upgrade process.

![Blue-green upgrade workflow](/assets/images/products/gateway/upgrade/blue-green-upgrade.png)

> _Figure 1: Blue-green upgrade workflow_

Compared to Dual-cluster Upgrade and In-place Upgrade, blue-green upgrade consumes less resources (e.g. no extra database required), but still supports “no business downtime” upgrade. Though blue-green upgrade is a supported feature, it is nearly impossible to fully cover all migrations tests, because we have to cover all combinations, given the number of Kong Gateway versions, upgrade strategies and deployment modes.

Considering the limited number of migration tests, please only use this strategy to upgrade between patch releases if customers do not have enough hardware resources but still want to keep “no business downtime” upgrade.  Also, a test run in a staging environment should be done.

{:.important}
> **Important**: Blue-green migration in traditional mode for versions below 2.8.2 to 3.0.x is not supported.
The 2.8.2.x release includes blue-green migration support. If you want
to perform migrations for traditional mode with no downtime, please upgrade to at least 2.8.2.0, [then migrate to 3.0.x](#migrate-db).

## Prerequisites

* You have reviewed the general upgrade guide.
* You have chosen this upgrade option because you have a traditional deployment, or you need to upgrade the control planes (CPs)
in a hybrid mode deployment.
* You are running {{site.base_gateway}} 2.8.2.x or above.
* You ruled out [Dual-cluster upgrades](/gateway/{{page.kong_version}}/upgrade/dual-cluster/) due to hardware or similar limitations.

## Upgrade steps

Note that `kong migrations finish` in the following procedure is only executed at the end of the upgrade procedure, when it has been verified that the new cluster Y is operating as expected.

1. Stop any Kong configuration updates (e.g. Admin API calls), which is critical to guarantee the data consistency between cluster X and cluster Y.
2. Back up data of current version X as instructed in section [Backup and Restore].
    1. Back up the existing database if Kong Gateway is deployed in Traditional or Hybrid mode.
    2. Dump the declarative Kong configuration data using deck dump.
    3. Back up keyring materials if the Keyring and Data Encryption feature is enabled.
    4. Any other applicable static data (e.g. `kong.conf`).
3. Evaluate factors that may impact the upgrade, as described in Upgrade Considerations. You may have to consider customization of both `kong.conf` and Kong configuration data.
4. Deploy a new Kong cluster of version Y.
    1. Install a new Kong cluster of version Y as instructed at Kong Gateway Installation Options and configure it pointing to the existing database.
    2. Migrate database, with “kong migrations up”, without running “kong migrations finish”. Kong would add a warning log entry that pending migrations exist. 
    3. Start cluster Y.
    4. Perform appropriate staging tests against version Y to make sure it works for all use cases. For instance, does the plugin key-auth-enc authenticate requests properly? If the outcome is not as expected, please validate step 3.
5. Divert traffic from cluster X to Y. This is usually done gradually and incrementally, depending on the risk profile of the deployment.  Any load balancers that support traffic splitting suffice, like DNS, Nginx, Kubernetes rollout mechanisms, etc.
6. Actively monitor all proxy metrics.
7. If any issues are found, rollback by setting all traffic to cluster X, investigate issues and repeat steps above.
8. Finalize the database migrations, with “kong migrations finish”.
9. Decommission cluster X to complete the upgrade. Write updates to Kong can now be performed, though we suggest you keep monitoring metrics for a while.

Please do not mix this upgrade strategy with the Blue-green (Canary) Deployment that is targeting your upstream services upgrade and has nothing to do with the topic in this document.