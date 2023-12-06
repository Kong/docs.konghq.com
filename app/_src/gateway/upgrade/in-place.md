---
title: In-place upgrade
content_type: how-to
purpose: Learn how to perform an in-place upgrade for Kong Gateway
---

The in-place upgrade strategy is a {{site.base_gateway}} upgrade option used primarily for traditional mode deployments and for control planes in hybrid mode. An in-place upgrade reuses the existing database.

In comparison to dual-cluster upgrades, the in-place upgrade uses less resources, but causes business downtime.

For this upgrade method, you have to shut down cluster X, then configure the new cluster Y to point to the database.

{% mermaid %}
flowchart TD
    DB[(Database)]
    CPX(Current {{site.base_gateway}} X \n #40;inactive#41;)
    Admin(No Admin API \n write operations)
    CPY(New {{site.base_gateway}} Y)
    API(API requests)

    CPX -.X.-> DB
    API --> CPY
    CPY --kong migrations up \n kong migrations finish--> DB
    Admin -.X.- CPX & CPY

    style API stroke:none
    style CPX stroke-dasharray:3
    style Admin fill:none,stroke:none,color:#d44324
    linkStyle 0,3,4 stroke:#d44324,color:#d44324
{% endmermaid %}

> _Figure 1: The diagram shows an in-place upgrade workflow, where the current CP X is directly replaced by a new CP Y. DP nodes are gradually diverted to the new CP Y. The database is reused by the new CP Y, and the current CP X is shut down once all nodes are migrated. No Admin API write operations can be performed during the upgrade._

There is business downtime as cluster X is stopped during the upgrade process. You must carefully review the upgrade considerations in advance. The prescribed steps below are recommended for you.

{:.important}
> **Important**: We do not recommend using this strategy unless {{site.base_gateway}} is deployed under 
an extreme resource-constrained environment, or unless you are not able to obtain new resources in a 
timely manner for a dual-cluster upgrade. 
However, this strategy does not prevent you from deploying the new cluster Y on a different machine.

## Prerequisites

* Review the [general upgrade guide](/gateway/{{page.kong_version}}/upgrade/) to prepare for the upgrade and review your options.
* You have a traditional deployment or you need to upgrade the control planes (CPs) in a hybrid mode deployment.
* You can't perform [dual-cluster upgrades](/gateway/{{page.kong_version}}/upgrade/dual-cluster/) due to resource limitations.

## Upgrade using the in-place method

This guide refers to the old version as cluster X and the new version as cluster Y.

{:.note}
> The following steps are intended as a guideline.
The exact execution of these steps will vary depending on your environment. 

1. Stop any {{site.base_gateway}} configuration updates (e.g. Admin API calls). 
This is critical to guarantee data consistency between cluster X and cluster Y.

2. Back up data from the current cluster Y by following the 
[Backup guide](/gateway/{{page.kong_version}}/upgrade/backup-and-restore/).

3. Evaluate factors that may impact the upgrade, as described in [Upgrade considerations](/gateway/{{page.kong_version}}/upgrade/#preparation-upgrade-considerations/).
You may have to consider customization of both `kong.conf` and {{site.base_gateway}} configuration data.

4. Evaluate any [breaking changes](/gateway/{{page.kong_version}}/breaking-changes/) that may 
have happened between releases.

5. Stop the {{site.base_gateway}} nodes of the old cluster X but keep the database running.

6. Install a new cluster running version Y as instructed in the 
    [{{site.base_gateway}} Installation Options](/gateway/{{page.kong_version}}/install/) and 
    point it at the existing database for cluster X.

7. Migrate the database to the new version by running `kong migrations up`. 

8. When complete, run `kong migrations finish`.

9. Start the new cluster Y.

10. Actively monitor all proxy metrics.

11. If you run into any issues, roll back the upgrade. 
Prioritize the database-level restoration method over the application-level method.

12. When there are no more issues, decommission the old cluster X to complete the upgrade. 

Write updates to {{site.base_gateway}} can now be performed, though we suggest you keep monitoring metrics for a while.


