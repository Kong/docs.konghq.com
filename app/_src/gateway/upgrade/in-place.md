---
title: In-place upgrade
content_type: how-to
purpose: Learn how to perform an in-place upgrade for Kong Gateway
---

The in-place upgrade strategy is a {{site.base_gateway}} upgrade option, used primarily for traditional mode deployments and for control planes in hybrid mode. In comparison to dual-cluster upgrades, the in-place upgrade uses less resources, but causes business downtime.

This guide refers to the old version as cluster X and the new version as cluster Y.

An in-place upgrade reuses the existing database.
For this upgrade method, you have to shut down cluster X, then configure the new cluster Y to point to the database.

![In-place upgrade workflow](/assets/images/products/gateway/upgrade/in-place-upgrade.png)

> _Figure 1: In-place upgrade workflow_

There is business downtime as cluster X is stopped during the upgrade process. You must carefully review the upgrade considerations in advance. The prescribed steps below are recommended for you.

{:.important}
> **Important**: We do not recommend using this strategy unless Kong Gateway is deployed under an extreme resource-constrained environment, or unless you are not able to obtain new resources in a timely manner for Dual-cluster Upgrade. However, this strategy does not prevent you from deploying the new cluster Y on a different machine.

## Prerequisites

* You have reviewed the [general upgrade guide](/gateway/{{page.kong_version}}/upgrade/).
* You have chosen this upgrade option because you have a traditional deployment, or you need to 
upgrade the control planes (CPs) in a hybrid mode deployment. 
* You ruled out [dual-cluster upgrades](/gateway/{{page.kong_version}}/upgrade/dual-cluster/) due to resource limitations.

## Upgrade steps

1. Stop any Kong configuration updates (e.g. Admin API calls), which is critical to guarantee the data consistency between cluster X and cluster Y.
2. Back up data of current version X as instructed in section Backup and Restore.
    1. Back up the existing database if Kong Gateway is deployed in Traditional or Hybrid mode.
    2. Dump the declarative Kong configuration data using deck dump.
    3. Back up keyring materials if the Keyring and Data Encryption feature is enabled.
    4. Any other applicable static data (e.g. `kong.conf`).
3. Evaluate factors that may impact the upgrade, as described in Upgrade Considerations. You may have to consider customization of both `kong.conf` and Kong configuration data.
4. Perform appropriate staging tests against version Y to make sure it works for all use cases, which can be done by running Kong Gateway in a docker container. For instance, does the plugin key-auth-enc authenticate requests properly? If the outcome is not as expected, please validate step 3.
5. Stop Kong nodes of cluster X but keep the database running.
6. Install a cluster of version Y and configure it pointing to the existing database. The installation method varies and depends on your preference. Please read instructions at Kong Gateway Installation Options. 
7. Migrate database, with `kong migrations <up|finish>`.
8. Start cluster Y.
8. Actively monitoring all proxy metrics.
9. Rollback if anything is wrong. To speed up, please prioritize the database-level method over the application-level method.
10. Decommission cluster X to complete the upgrade. Write updates to Kong can now be performed, though we suggest you keep monitoring metrics for a while.


