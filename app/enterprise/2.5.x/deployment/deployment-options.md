---
title: Deployment Options
---
{{site.ee_product_name}} can be deployed in the following main modes:
* [**Embedded:**](#embedded) classic deployment with all services on one node.
* [**Distributed:**](#distributed) classic deployment with distributed services.
* [**Hybrid:**](#hybrid-mode) Control Plane and Data Planes are separate.

## Classic deployment

### Embedded

In this deployment mode, you install one instance of Kong, and all of its add-ons
reside on the same node. This option is normally used for testing and development.
<div class="alert alert-warning">
 
  <b>Warning:</b> The embedded mode is intended for evaluation and development
  environments and <b>should not</b> be used for a production environment.
</div>

![Classic embedded mode](/assets/images/docs/ee/deployment/deployment-classic-dev.png)

To learn more, see the [installation documentation](/enterprise/{{page.kong_version}}/deployment/installation).

### Distributed

In a production environment, we recommend that you install multiple instances of
Kong on separate nodes. Each of these nodes must connect to the Kong database,
which can be Postgres or Cassandra.

![Classic distributed mode](/assets/images/docs/ee/deployment/deployment-classic-distributed.png)

To set up a distributed deployment, install the Control Plane Kong instance
following the [embedded installation instructions](/enterprise/{{page.kong_version}}/deployment/installation)
for your platform, then bring up subsequent instances for the Data Planes without
enabling any add-ons (e.g., Kong Manager, Developer Portal).

For further distributed setup help, contact Kong Support.

## Hybrid mode

In a Hybrid mode deployment, {{site.ee_product_name}} instances are divided into
two roles: Control Plane (CP) and Data Plane (DP). Only the Control Plane
requires a database, and it propagates Kong configuration to Data Plane nodes,
which use in-memory storage. The Data Plane nodes can be installed anywhere,
on-premise or in the cloud.

![Hybrid mode](/assets/images/docs/ee/deployment/deployment-hybrid.png)

To learn more, see the [Hybrid mode documentation](/enterprise/{{page.kong_version}}/deployment/hybrid-mode).
