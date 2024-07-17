---
title: Overview
content_type: explanation
---

{{site.base_gateway}} can be deployed in four different modes:

* {{site.konnect_short_name}} (hosted control plane)
* Hybrid
* Traditional (database)
* DB-less and declarative

Each mode has benefits and limitations, so it is important to consider them carefully when deciding which mode to use to install {{site.base_gateway}} in production. 

The following sections briefly describe each mode. 

## {{ site.konnect_short_name }}

{{ site.konnect_short_name }} is the fastest way to get started when using {{site.base_gateway}}. It allows you to deploy your own data plane nodes (DP) to handle customer traffic without needing to deploy your own control plane (CP) or database.

{{ site.konnect_short_name }} is a hybrid mode deployment, where Kong hosts the control plane for you. This means that you get all of the benefits of a hybrid mode deployment without needing to run multiple control plane nodes yourself.

{% include_cached /md/gateway/deployment-topologies.md topology='konnect' %}
<!-- vale on-->

> _Figure 1: In {{ site.konnect_short_name }}, Kong hosts your control planes and all of the related applications: Dev Portal, Gateway Manager, Analytics, {{site.service_catalog_name}}, and so on. You attach data planes to {{ site.konnect_short_name }} to process traffic, which get all of their configuration from the control planes._

Configuration changes can be made using the {{ site.konnect_short_name }} UI and configuration wizards, or applied in an automated way using [decK](/deck/latest/).

As with self-managed hybrid mode, your data plane nodes will continue to process traffic even if the control plane is offline. In addition, you no longer need to worry about securing the control plane because {{site.base_gateway}} does it for you.

Finally, {{ site.konnect_short_name }} supports cloud-managed control planes and control plane groups, which allows you to segment your configuration in any way that you need. It could be by business unit, or environment. Achieving this using hybrid mode requires you to deploy one control plane per segment, while {{ site.konnect_short_name }} allows you to manage multiple configuration sets through the same UI and API.

[Get started](https://cloud.konghq.com/register) with {{ site.konnect_short_name }} for free today.

## Hybrid mode

In hybrid mode, {{site.base_gateway}} nodes in a cluster are split into two roles: control plane
(CP), where configuration is managed and the Admin API is served from, and data
plane (DP), which serves traffic for the proxy. Many DP nodes are connected to a single CP node. Instead of accessing the database contents directly like in the
traditional deployment method, the DP nodes maintain connection with CP nodes,
and receive the latest configuration in real-time.

{% include_cached /md/gateway/deployment-topologies.md topology='hybrid' %}

> _Figure 2: In self-managed hybrid mode, the control plane and data planes are hosted on different nodes. The control plane connects to the database, and the data planes receive configuration from the control plane._

Hybrid mode deployments have the following benefits:

* Users can deploy groups of data planes in different data centers, geographies, or zones without needing a local clustered database for each DP group.
* The availability of the database does not affect the availability of the data planes. If a control plane is offline, data planes will run using their last known configuration.
* Drastically reduces the amount of traffic to and from the database, since only CP nodes need a direct connection to the database.
* If one of the DP nodes is compromised, an attacker won’t be able to affect other nodes in the {{site.base_gateway}} cluster.

## Traditional (database) mode

In [traditional mode](/gateway/{{page.release}}/production/deployment-topologies/traditional/), {{site.base_gateway}} requires a database to store configured entities such as routes, services, and plugins.
See [supported databases](/gateway/{{page.release}}/support/third-party/#data-stores).

{% include_cached /md/gateway/deployment-topologies.md topology='traditional' %}

> _Figure 3: In a traditional deployment, all {{site.base_gateway}} nodes connect to the database. Each node manages its own configuration._

Running {{ site.base_gateway }} in traditional mode is the simplest way to get started with Kong, and it is the only deployment topology that supports plugins that require a database, like rate-limiting with the cluster strategy, or OAuth2. However, there are some downsides too.

When running in traditional mode, every {{ site.base_gateway }} node runs as both a Control Plane (CP) and Data Plane (DP). This means that if **any** of your nodes are compromised, the entire running gateway configuration is compromised. In contrast, [hybrid mode](/gateway/{{page.release}}/production/deployment-topologies/hybrid-mode/) has distinct CP and DP nodes reducing the attack surface.

In addition, if you're running {{site.ee_product_name}} with Kong Manager, request throughput may be reduced on nodes running Kong Manager due to expensive calculations being run to render analytics data and graphs.

You can use the [Admin API](/gateway/{{page.release}}/admin-api/) or declarative configuration files [(decK)](/deck/latest/) to configure the {{site.base_gateway}} in traditional mode.

## DB-less and declarative mode

You can enable [DB-less mode](/gateway/{{page.release}}/production/deployment-topologies/db-less-and-declarative-config/) to reduce complexity of and create more flexible deployment patterns. In this mode, configured entities such as routes, services and plugins are stored in-memory on the node.

{% include_cached /md/gateway/deployment-topologies.md topology='dbless' %}

> _Figure 4: In DB-less mode, configuration is applied via YAML files. 
{{ site.base_gateway }} nodes aren't connected to a database, or to each other._

When running in DB-less mode, configuration is provided to {{ site.base_gateway }} using a second file. This file contains your configuration in YAML or JSON format using Kong's declarative configuration syntax.

DB-less mode is also used by the {{site.kic_product_name}}, where the Kubernetes API server uses Kong's `/config` endpoint to update the running configuration in memory any time a change is made.

The combination of DB-less mode and declarative configuration has a number
of benefits:

* Reduced number of dependencies: no need to manage a database installation
  if the entire setup for your use-case fits in memory.
* Your configuration is always in a known state. There is no intermediate 
  state between creating a service and a route using the Admin API.
* It is a good fit for automation in CI/CD scenarios. Configuration for
  entities can be kept in a single source of truth managed via a Git
  repository.

Here are a few limitations of this mode:

* The [Admin API](/gateway/{{page.release}}/admin-api/) is read only.
* Any plugin that stores information in the database, like rate limiting (cluster mode), do not fully function.
