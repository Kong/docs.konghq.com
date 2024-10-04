---
title: In-place upgrade
content_type: how-to
purpose: Learn how to perform an in-place upgrade for Kong Gateway
---

The in-place upgrade strategy is a {{site.base_gateway}} upgrade option used primarily for traditional mode deployments and for control planes in hybrid mode. 
An in-place upgrade reuses the existing database.

In comparison to dual-cluster upgrades, the in-place upgrade uses less resources, but causes business downtime.

This guide refers to the old version as cluster X and the new version as cluster Y.
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

> _Figure 1: The diagram shows an in-place upgrade workflow, where the current cluster X is directly replaced by a new cluster Y._
_The database is reused by the new cluster Y, and the current cluster X is shut down once all nodes are migrated. No Admin API write operations can be performed during the upgrade._

There is business downtime as cluster X is stopped during the upgrade process. 
You must carefully review the [upgrade considerations](/gateway/{{page.release}}/upgrade/#preparation-upgrade-considerations) in advance.

{:.important}
> **Important**: We do not recommend using this strategy unless {{site.base_gateway}} is deployed under 
an extremely resource-constrained environment, or unless you are not able to obtain new resources in a 
timely manner for a dual-cluster upgrade.
> <br><br>
> The current cluster X can be substituted in place with the new cluster Y.
However, this strategy does not prevent you from deploying the new cluster Y on a different machine.

## Prerequisites

* Review the [general upgrade guide](/gateway/{{page.release}}/upgrade/) to prepare for the upgrade and review your options.
* You have a traditional deployment or you need to upgrade the control planes (CPs) in a hybrid mode deployment.
* You can't perform [dual-cluster upgrades](/gateway/{{page.release}}/upgrade/dual-cluster/) due to resource limitations.

## Upgrade using the in-place method

{:.note}
> The following steps are intended as a guideline.
The exact execution of these steps will vary depending on your environment. 

1. Stop any {{site.base_gateway}} configuration updates (e.g. Admin API calls). 
This is critical to guarantee data consistency between cluster X and cluster Y.

2. Back up data from the current cluster X by following the 
[Backup guide](/gateway/{{page.release}}/upgrade/backup-and-restore/).

3. Evaluate factors that may impact the upgrade, as described in [Upgrade considerations](/gateway/{{page.release}}/upgrade/#preparation-upgrade-considerations/).
You may have to consider customization of both `kong.conf` and {{site.base_gateway}} configuration data.

4. Evaluate any changes that have happened between releases:
    * [Breaking changes](/gateway/{{page.release}}/breaking-changes/)
    * [Full changelog](/gateway/changelog/)

5. Stop the {{site.base_gateway}} nodes of the old cluster X but keep the database running. 
This will create a period of downtime until the upgrade completes.

6. Install a new cluster running version Y as instructed in the 
    [{{site.base_gateway}} Installation Options](/gateway/{{page.release}}/install/) and 
    point it at the existing database for cluster X.
    
    Provision the new cluster Y with the same-sized resource capacity as that of 
    the current cluster X.

7. Migrate the database to the new version by running `kong migrations up`. 

8. When complete, run `kong migrations finish`.

9. Start the new cluster Y.

10. Actively monitor all proxy metrics.

11. If you run into any issues, [roll back the upgrade](/gateway/{{page.release}}/upgrade/backup-and-restore/#restore-gateway-entities). 
Prioritize the database-level restoration method over the application-level method.

12. When there are no more issues, decommission the old cluster X to complete the upgrade. 

Write updates to {{site.base_gateway}} can now be performed, though we suggest you keep monitoring metrics for a while.


