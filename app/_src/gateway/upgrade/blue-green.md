---
title: Blue-green upgrade
content_type: how-to
purpose: Learn how to perform a blue-green upgrade for Kong Gateway
---

The blue-green upgrade strategy is a {{site.base_gateway}} upgrade option used primarily for traditional mode deployments 
and for control planes in hybrid mode. 

Blue-green upgrades are derived from the in-place upgrade strategy. 
This upgrade strategy benefits from the fact that `kong migrations up` leaves the database in a state 
where it can serve requests by either current cluster X or the new cluster Y. 
The compatibility of the database with cluster X is only lost when `kong migrations finish` is executed.

This is a more advanced strategy than the dual-cluster upgrade in that there is no need to deploy a new database. 
It still supports gradually diverting traffic from the current cluster X to the new cluster Y, shown in the following diagram. 
Furthermore, runtime metrics (for example, Rate Limiting Advanced plugin counters) are sent to the same database. 
Metrics are continuously collected from both clusters during the upgrade process.

![Blue-green upgrade workflow](/assets/images/products/gateway/upgrade/blue-green-upgrade.png)

> _Figure 1: Blue-green upgrade workflow_

Compared to dual-cluster and in-place upgrades, blue-green upgrades consume less resources since there is no extra database required, 
and still allow for no business downtime.

Support from Kong for upgrades using this strategy is limited.
Though blue-green upgrades are supported, it is nearly impossible to fully cover all migration tests, because we have to cover all 
'combinations, given the number of {{site.base_gateway}} versions, upgrade strategies, and deployment modes. 

{:.important}
> **Important**: In traditional mode, blue-green migration support is available starting in 2.8.2.x.
If you have a {{site.base_gateway}} 2.8.x version earlier than 2.8.2.x, upgrade to at least 2.8.2.0 before starting any upgrades to the 3.x series.

## Prerequisites

* Review the [general upgrade guide](/gateway/{{page.kong_version}}/upgrade/) to prepare for the upgrade and review your options.
* You have a traditional deployment or you need to upgrade the control planes (CPs) in a hybrid mode deployment.
* You have {{site.base_gateway}} 2.8.2.x or later.
* You can't perform [dual-cluster upgrades](/gateway/{{page.kong_version}}/upgrade/dual-cluster/) due to resource limitations.

## Upgrade using the blue-green method

This guide refers to the old (current) version as cluster X and the new version as cluster Y.

In the following procedure, `kong migrations finish` is only executed at the end of the upgrade, 
after you have verified that the new cluster Y is operating as expected.

{:.note}
> The following steps are intended as a guideline.
The exact execution of these steps will vary depending on your environment. 

1. Stop any {{site.base_gateway}} configuration updates (e.g. Admin API calls). 
This is critical to guarantee data consistency between cluster X and cluster Y.

2. Back up data from the current cluster Y by following the 
[Backup guide](/gateway/{{page.kong_version}}/upgrade/backup-and-restore/).

3. Evaluate factors that may impact the upgrade, as described in [Upgrade Considerations].
You may have to consider customization of both `kong.conf` and {{site.base_gateway}} configuration data.

4. Evaluate any [breaking changes](/gateway/{{page.kong_version}}/breaking-changes/) that may 
have happened between releases.

5. Deploy a new {{site.base_gateway}} cluster of version Y:

    1. Install a new {{site.base_gateway}} cluster running version Y as instructed in the 
    [{{site.base_gateway}} Installation Options](/gateway/{{page.kong_version}}/install/) and 
    point it at the existing database for cluster X.
    
    2. Migrate the database to the new version by running `kong migrations up`. 
    
        {{site.base_gateway}} will print a warning log entry that pending migrations exist. 
        This is expected.

    3. Start the new cluster Y.

    4. Perform staging tests against version Y to make sure it works for all use cases. 
    
        For example, does the Key Authentication plugin authenticate requests properly?
        
        If the outcome is not as expected, look over the 
        [upgrade considerations](/gateway/{{page.kong_version}}/upgrade/upgrade-considerations/) and the 
        [breaking changes](/gateway/{{page.kong_version}}/breaking-changes/)
        again to see if you missed anything.

6. Divert traffic from old cluster X to new cluster Y.
    
    This is usually done gradually and incrementally, depending on the risk profile of the deployment. 
    Any load balancers that support traffic splitting will work here, such as DNS, Nginx, Kubernetes rollout mechanisms, and so on.

7. Actively monitor all proxy metrics.

8. If any issues arise, roll back by setting all traffic to cluster X, investigate the issues, 
and repeat the steps above.

9. Finalize the database migrations with `kong migrations finish`.

10. When there are no more issues, decommission the old cluster X to complete the upgrade.

Write updates to {{site.base_gateway}} can now be performed, though we suggest you keep monitoring metrics for a while.

{:.note}
> **Note**: This upgrade strategy is not the same thing as the [Blue-green (Canary) Deployment](/gateway/{{page.kong_version}}/production/canary/). 
That process targets your upstream services upgrade and is not related to {{site.base_gateway}} upgrades.