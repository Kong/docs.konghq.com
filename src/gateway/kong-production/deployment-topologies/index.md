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

{{ site.konnect_short_name }} is the fastest way to get started when using {{site.base_gateway}}. It allows you to deploy your own data planes (DP) to handle customer traffic without needing to deploy your own control plane (CP) or database.

{{ site.konnect_short_name }} is a hybrid mode deployment, where Kong host the control plane for you. This means that you get all of the benefits of a hybrid mode deployment without needing to run multiple nodes yourself.

Configuration changes can be made using the {{ site.konnect_short_name }} UI and configuration wizards, or applied in an automated way using [decK](/deck/).

As with hybrid mode, your data planes will continue to process traffic even if the control plane is offline. In addition, you no longer need to worry about securing the control plane because {{site.base_gateway}} does it for you.

Finally, {{ site.konnect_short_name }} supports runtime groups, which allows you to segment your configuration in any way that you need. It could be by business unit, or environment. Achieving this using hybrid mode requires you to deploy one control plane per segment, while {{ site.konnect_short_name }} allows you to manage multiple configuration sets through the same UI and API.

[Get started](https://cloud.konghq.com/register) with {{ site.konnect_short_name }} for free today.

## Hybrid mode

Starting with {{site.base_gateway}} 2.1, {{site.base_gateway}} can be deployed in
[hybrid mode](/gateway/{{page.kong_version}}/kong-production/deployment-topologies/hybrid-mode/), which separates the control plane from the data plane.

In this mode, {{site.base_gateway}} nodes in a cluster are split into two roles: control plane
(CP), where configuration is managed and the Admin API is served from, and data
plane (DP), which serves traffic for the proxy. Many DP nodes are connected to a single CP node. Instead of accessing the database contents directly like in the
traditional deployment method, the DP nodes maintain connection with CP nodes,
and receive the latest configuration in real-time.

Hybrid mode deployments have the following benefits:

* Users can deploy groups of data planes in different data centers, geographies, or zones without needing a local clustered database for each DP group.
* The availability of the database does not affect the availability of the data planes. If a control plane is offline, data planes will run using their last known configuration.
* Drastically reduces the amount of traffic to and from the database, since only CP nodes need a direct connection to the database.
* If one of the DP nodes is compromised, an attacker won’t be able to affect other nodes in the {{site.base_gateway}} cluster.

## Traditional (database) mode

In [traditional mode](/gateway/{{page.kong_version}}/kong-production/deployment-topologies/traditional/), {{site.base_gateway}} requires a database to store configured entities such as routes, services, and plugins. {{site.base_gateway}} supports both PostgreSQL 10+ and Cassandra 3.11.x as its data store.

Running {{ site.base_gateway }} in traditional mode is the simplest way to get started with Kong, and it is the only deployment topology that supports plugins that require a database, like rate-limiting with the cluster strategy, or OAuth2. However, there are some downsides too.

When running in traditional mode, every {{ site.base_gateway }} node runs as both a Control Plane (CP) and Data Plane (DP). This means that if **any** of your nodes are compromised, the entire running gateway configuration is compromised. In contrast, hybrid mode (shown below) has distinct CP and DP nodes reducing the attack surface.

In addition, if you're running Kong Enterprise with Kong Manager, request throughput may be reduced on nodes running Kong Manager due to expensive calculations being run to render analytics data and graphs.

You can use the [Admin API](/gateway/{{page.kong_version}}/admin-api/) or declarative configuration files [(decK)](/deck/{{page.kong_version}}/) to configure the {{site.base_gateway}} in traditional mode.

## DB-less and declarative mode

Starting with {{site.base_gateway}} 1.1, you can enable [DB-less mode](/gateway/{{page.kong_version}}/kong-production/deployment-topologies/db-less-and-declarative-config/) to reduce complexity of and create more flexible deployment patterns. In this mode, configured entities such as routes, services and plugins are stored in-memory on the node.

When running in DB-less mode, configuration is provided to {{ site.base_gateway }} using a second file. This file contains your configuration in YAML or JSON format using Kong's declarative configuration syntax.

DB-less mode is also used by the Kong Ingress Controller, where the Kubernetes API server uses Kong's `/config` endpoint to update the running configuration in memory any time a change is made.

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

* The [Admin API](/gateway/{{page.kong_version}}/admin-api/) is read only.
* Any plugin that stores information in the database, like rate limiting (cluster mode), do not fully function.