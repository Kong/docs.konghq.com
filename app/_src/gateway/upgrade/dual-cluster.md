---
title: Dual-cluster upgrade
content_type: how-to
purpose: Learn how to perform a dual-cluster upgrade for Kong Gateway
---

The dual-cluster upgrade strategy is a {{site.base_gateway}} upgrade option used primarily for traditional 
mode deployments and for control planes in hybrid mode. 

With a dual-cluster upgrade, you deploy a new cluster of version Y alongside the current version X, 
so that two clusters serve requests concurrently during the upgrade process. 
As you add nodes, you will gradually adjust the traffic ratio between the two clusters to 
switch traffic over from the old cluster to the new one.

![Dual-cluster upgrade workflow](/assets/images/products/gateway/upgrade/dual-cluster-upgrade.png)
> _Figure 1: Dual-cluster upgrade workflow_

This method has limitations on automatically generated runtime metrics that rely on the database. 
For example, if the Rate-Limiting-Advanced (RLA) plugin is configured to store request counters in 
the database, the counters between database X and database Y are not synchronized. 
The impact scope depends on the `window_size` parameter of the plugin. 
{% if_version eq:3.4.x %}
Similarly, the same limitation applies to Vitals if you have a large amount of buffered metrics in 
PostgreSQL.
{% endif_version %}
{% if_version lte:3.3.x %}
Similarly, the same limitation applies to Vitals if you have a large amount of buffered metrics in 
PostgreSQL or Cassandra.
{% endif_version %}

## Prerequisites

* Review the [general upgrade guide](/gateway/{{page.kong_version}}/upgrade/) to prepare for the upgrade and review your options.
* You have a traditional deployment or you need to upgrade the control planes (CPs) in a hybrid mode deployment.
* You have enough resources to temporarily run an additional {{site.base_gateway}} cluster alongside your existing cluster.

## Upgrade using the dual-cluster method

This guide refers to the old version as cluster X and the new version as cluster Y.

{:.note}
> The following steps are intended as a guideline.
The exact execution of these steps will vary depending on your environment. 

1. Stop any {{site.base_gateway}} configuration updates (e.g. Admin API calls). 
This is critical to guarantee data consistency between cluster X and cluster Y.

    To keep data consistency between the two clusters, you must not execute any write operations through Admin API, Kong Manager, or direct database updates. 
    This upgrade strategy is the safest of all available strategies and ensures that there is no planned business downtime during the upgrade process.

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

    2. Install a new database of the same version.

    3. [Restore the backup data](/gateway/{{page.kong_version}}/upgrade/backup-and-restore/#restore)
    to the new database.

    4. Configure the new cluster Y to point to the new database.

    5. Start cluster Y.

    6. Perform staging tests against version Y to make sure it works for all use cases. 
    
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

9. When there are no more issues, decommission the old cluster X to complete the upgrade. 

Write updates to {{site.base_gateway}} can now be performed, though we suggest you keep monitoring metrics for a while.