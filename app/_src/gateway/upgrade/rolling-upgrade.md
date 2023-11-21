---
title: Rolling upgrade
content_type: how-to
purpose: Learn how to perform a rolling upgrade for Kong Gateway
---

The rolling upgrade strategy is a {{site.base_gateway}} upgrade option, specifically designed 
for DB-less mode and for data planes running in hybrid mode. This strategy is meant for nodes that don't use a database, and that are independent of each other.

This guide refers to the old version as cluster X and the new version as cluster Y.

The rolling upgrade is a process of continuously adding new nodes of version Y, while shutting 
down nodes of version X.

![Rolling upgrade workflow](/assets/images/products/gateway/upgrade/rolling-upgrade.png)

> _Figure 1: Rolling upgrade workflow_

## Prerequisites

* You have reviewed the [general upgrade guide](/gateway/{{page.kong_version}}/upgrade/).
* You have chosen this upgrade option because you have a DB-less deployment, or you need to 
upgrade the data planes (DPs) in a hybrid mode deployment. 

## Upgrade steps

The following procedure echoes the illustration in figure 4 for DB-less mode as an example.

1. Stop any Kong configuration updates, which is critical to guarantee the data consistency between X and Y.
2. Back up data of current version X as instructed in section Backup and Restore.
    1. Save the declarative configuration “kong.yml” to a safe place.
    2. Any other applicable static data (e.g. `kong.conf`).
3. Evaluate factors that may impact the upgrade, as described in Upgrade Considerations. You may have to consider customization of both `kong.conf` and Kong configuration data.
4. Install a new node of version Y.
    1. Perform appropriate staging tests to make sure it works for all use cases. For instance, does the plugin key-auth-enc authenticate requests properly? Please at least run “deck validate” to validate the compatibility of Kong configuration data. If the outcome is not as expected, please repeat step 3.
    2. If it is a DP node, ensure the communication with the CP node succeeds.
5. Continuously install and launch more Y nodes.
6. Divert traffic from X to Y. This is usually done gradually and incrementally, depending on the risk profile of the deployment.  Any load balancers that support traffic splitting suffice, like DNS, Nginx, Kubernetes rollout mechanisms, etc.
7. If any issues are found, rollback by setting all traffic to X nodes, investigate issues and repeat steps above
8. Decommission X nodes to complete the upgrade. Write updates to Kong can now be performed, though we suggest you keep monitoring metrics for a while.

This method is quite robust and straightforward, please do not hesitate to use it for DB-less mode, DP side of Hybrid mode or Konnect.
