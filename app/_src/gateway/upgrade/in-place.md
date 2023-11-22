---
title: In-place upgrade
content_type: how-to
purpose: Learn how to perform an in-place upgrade for Kong Gateway
---

The in-place upgrade strategy is a {{site.base_gateway}} upgrade option used primarily for traditional mode deployments and for control planes in hybrid mode. In comparison to dual-cluster upgrades, the in-place upgrade uses less resources, but causes business downtime.

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

This guide refers to the old version as cluster X and the new version as cluster Y.

1. Stop any {{site.base_gateway}} configuration updates (e.g. Admin API calls). 
This is critical to guarantee data consistency between cluster X and cluster Y.

2. Back up data from the current cluster Y by following the 
[Backup guide](/gateway/{{page.kong_version}}/upgrade/backup-and-restore/).

3. Evaluate factors that may impact the upgrade, as described in [Upgrade Considerations].
You may have to consider customization of both `kong.conf` and Kong configuration data.

4. Evaluate any [breaking changes](/gateway/{{page.kong_version}}/breaking-changes/) that may 
have happened between releases.

5. Stop the {{site.base_gateway}} nodes of the old cluster X but keep the database running.

6. Install a new cluster running version Y as instructed in the 
    [{{site.base_gateway Installation Options](/gateway/{{page.kong_version}}/install/) and 
    point it at the existing database for cluster X.

7. Migrate the database to the new version by running `kong migrations up`. 

8. When complete, run `kong migrations finish`.

9. Start the new cluster Y.

10. Actively monitor all proxy metrics.

11. If you run into any issues, roll back the upgrade. 
Prioritize the database-level restoration method over the application-level method.

12. When there are no more issues, decommission the old cluster X to complete the upgrade. 

Write updates to Kong can now be performed, though we suggest you keep monitoring metrics for a while.


