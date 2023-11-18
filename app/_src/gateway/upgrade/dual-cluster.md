---
title: Dual-cluster upgrade
---

The dual-cluster strategy refers to the practice that a new Kong cluster of version Y is deployed alongside the current version X, so that two clusters serve requests concurrently during the upgrade process, as illustrated in figure 1.

![Dual-cluster upgrade workflow](/assets/images/products/gateway/upgrade/dual-cluster-upgrade.png)

> _Figure 1: Dual-cluster upgrade workflow_

## Prerequisites

* You have reviewed the general upgrade guide
* You have chosen this upgrade option because you have a traditional deployment, or you need to upgrade the control planes (CPs)
in a hybrid mode deployment

## Upgrade steps

Upgrade is achieved by gradually adjusting traffic ratio between the two clusters. The following are the steps required to perform an upgrade using this strategy.

1. Stop any Kong configuration updates (e.g. Admin API calls), which is critical to guarantee the data consistency between cluster X and cluster Y.

2. Back up the data of the current version X as instructed in section Backup and Restore.

    1. Back up the existing database if Kong Gateway is deployed in Traditional or Hybrid mode.
    2. Dump the declarative Kong configuration data using deck dump.
    3. Back up keyring materials if the Keyring and Data Encryption feature is enabled.
    4. Any other applicable static data (e.g. `kong.conf`).

3. Evaluate factors that may impact the upgrade, as described in [Upgrade Considerations]. You may have to consider customization of both `kong.conf` and Kong configuration data.

4. Deploy a new Kong cluster of version Y.
    1. Install a new Kong cluster of version Y as instructed at Kong Gateway Installation Options.
    2. Install a new database of the same version.
    3. Restore the backup data from step 2 above to the new database.
    4. Configure cluster Y to point to the new database.
    5. Start cluster Y.
    6. Perform appropriate staging tests against version Y to make sure it works for all use cases. For instance, does the plugin key-auth-enc authenticate requests properly? If the outcome is not as expected, please validate step 3.

5. Divert traffic from cluster X to Y. 

    This is usually done gradually and incrementally, depending on the risk profile of the deployment. Any load balancers that support traffic splitting will suffice, like DNS, Nginx, Kubernetes rollout mechanisms, etc.

6. Actively monitor all proxy metrics.

7. If any issues are found, rollback by setting all traffic to cluster X, investigate issues and repeat steps above.

8. When there are no more issues, decommission cluster X to complete the upgrade. Write updates to Kong can now be performed, though we suggest you keep monitoring metrics for a while.

To keep data consistency between the two clusters, you must not execute any write operations through Admin API, Kong Manager or direct database updates. This upgrade strategy is the safest of all available strategies and ensures that there is no planned business downtime during the upgrade process.

This method has limitations on automatically generated runtime metrics that rely on the database. For example, if the Rate-Limiting-Advanced (RLA) plugin is configured to store request counters in the database, the counters between database X and database Y are not synchronized. The impact scope depends on the “window_size” parameter of the plugin. Similarly, the same limitation applies to Vitals if you have a large amount of buffered metrics in Postgres or Cassandra.

The dual-cluster upgrade strategy was previously named the “DB-clone Upgrade Strategy” in previous versions.
