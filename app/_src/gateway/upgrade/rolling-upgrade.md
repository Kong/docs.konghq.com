---
title: Rolling upgrade
content_type: how-to
purpose: Learn how to perform a rolling upgrade for Kong Gateway
---

The rolling upgrade strategy is a {{site.base_gateway}} upgrade option specifically designed 
for DB-less mode, data planes running in hybrid mode, and {{site.konnect_short_name}}.
This strategy is meant for nodes that don't use a database and are independent of each other.

The rolling upgrade is a process of continuously adding new nodes of version Y, while shutting 
down nodes of version X.

![Rolling upgrade workflow](/assets/images/products/gateway/upgrade/rolling-upgrade.png)

> _Figure 1: Rolling upgrade workflow_

## Prerequisites

* Review the [general upgrade guide](/gateway/{{page.kong_version}}/upgrade/) to prepare for the upgrade and review your options.
* You have a DB-less deployment or you need to upgrade the data planes (CPs) in a hybrid mode deployment.

## Upgrade using the rolling method

This guide refers to the old version as cluster X and the new version as cluster Y.

{:.note}
> The following steps are intended as a guideline.
The exact execution of these steps will vary depending on your environment. 

1. Stop any {{site.base_gateway}} configuration updates (for example, Admin API calls). 
This is critical to guarantee data consistency between cluster X and cluster Y.

2. Back up data from the current cluster Y by following the 
[declarative configuration backup instructions](/gateway/{{page.kong_version}}/upgrade/backup-and-restore/#declarative-config-backup).

3. Evaluate factors that may impact the upgrade, as described in [Upgrade considerations](/gateway/{{page.kong_version}}/upgrade/#preparation-upgrade-considerations/).
You may have to consider customization of both `kong.conf` and {{site.base_gateway}} configuration data.

4. Evaluate any [breaking changes](/gateway/{{page.kong_version}}/breaking-changes/) that may 
have happened between releases.

5.  Deploy a new {{site.base_gateway}} cluster of version Y:
    
    1. Install a new cluster running version Y as instructed in the 
    [{{site.base_gateway}} Installation Options](/gateway/{{page.kong_version}}/install/) and 
    point it at the existing database for cluster X.
    
    2. Perform staging tests against version Y to make sure it works for all use cases. 
    
    For example, does the Key Authentication plugin authenticate requests properly?

    If it is a data plane node, ensure the communication with the control node succeeds.

    If the outcome is not as expected, look over the 
    [upgrade considerations](/gateway/{{page.kong_version}}/upgrade/#preparation-upgrade-considerations/) and the 
    [breaking changes](/gateway/{{page.kong_version}}/breaking-changes/)
    again to see if you missed anything.

    3. Continuously install and launch more Y nodes.

6. Divert traffic from old cluster X to new cluster Y.
    
    This is usually done gradually and incrementally, depending on the risk profile of the deployment. 
    Any load balancers that support traffic splitting will work here, such as DNS, Nginx, Kubernetes rollout mechanisms, and so on.

7. If any issues arise, roll back by setting all traffic to cluster X, investigate the issues, 
and repeat the steps above.

8. When there are no more issues, decommission the old cluster X to complete the upgrade. 

Write updates to {{site.base_gateway}} can now be performed, though we suggest you keep monitoring metrics for a while.