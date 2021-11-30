---
title: Classic Deployment
---
{{site.ee_product_name}} can be deployed in the following classic deployment modes:
* [**Embedded:**](#embedded) deployment with all services on one node.
* [**Distributed:**](#distributed) deployment with distributed services. Unlike 
in Hybrid mode, every node must connect to a database.


## Embedded

In this deployment mode, you install one instance of Kong, and all of its add-ons
reside on the same node. This option is normally used for testing and development.
<div class="alert alert-warning">
 
  <b>Warning:</b> The embedded mode is intended for evaluation and development
  environments and <b>should not</b> be used for a production environment.
</div>

![Classic embedded mode](/assets/images/docs/ee/deployment/deployment-classic-dev.png)

To learn more, see the [installation documentation](/enterprise/{{page.kong_version}}/deployment/installation/overview).

## Distributed

In a production environment, we recommend that you install multiple instances of
Kong on separate nodes. Each of these nodes must connect to the Kong database,
which can be Postgres or Cassandra.

![Classic distributed mode](/assets/images/docs/ee/deployment/deployment-classic-distributed.png)

To set up a distributed deployment, install the Control Plane Kong instance
following the [embedded installation instructions](/enterprise/{{page.kong_version}}/deployment/installation)
for your platform, then bring up subsequent instances for the Data Planes without
enabling any add-ons (e.g., Kong Manager, Developer Portal).

For further distributed setup help, contact [Kong Support](https://support.konghq.com/support/s/).
