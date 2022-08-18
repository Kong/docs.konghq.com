---
title: Overview
content_type: explanation
---

{{site.base_gateway}} can be deployed in three different modes:

* Traditional (database)
* Hybrid
* DB-less and declarative

Each mode has benefits and limitations, so it is important to consider them carefully when deciding which mode to use to install {{site.base_gateway}} in production. 

The following sections briefly describe each mode. 

## Traditional (database) mode

In [traditional mode](/gateway/{{page.kong_version}}/kong-production/deployment-topologies/traditional/), {{site.base_gateway}} requires a database to store configured entities such as routes, services, and plugins. {{site.base_gateway}} supports both PostgreSQL 9.5+ and Cassandra 3.11.x as its datastore.

{:.warning}
> **Deprecation notice:** Cassandra as a backend database for {{site.base_gateway}} is deprecated. This means the feature will eventually be removed.
Our target for Cassandra removal is the {{site.base_gateway}} 4.0 release. Starting with the {{site.base_gateway}} 3.0 release, some new features might not be supported with Cassandra.

A benefit of this mode is that {{site.base_gateway}} stores the configuration in memory, which increases performance. This is because the database is typically only reached when the configuration is updated. 

You can use the [Admin API](/gateway/{{page.kong_version}}/admin-api/) or declarative configuration files [(decK)](/deck/{{page.kong_version}}/) to configure the {{site.base_gateway}} in this mode. 

## Hybrid mode

Starting with {{site.base_gateway}} 2.1, {{site.base_gateway}} can be deployed in
[hybrid mode](/gateway/{{page.kong_version}}/kong-production/deployment-topologies/hybrid-mode/), which separates the control plane from the data plane.

In this mode, {{site.base_gateway}} nodes in a cluster are split into two roles: control plane
(CP), where configuration is managed and the Admin API is served from, and data
plane (DP), which serves traffic for the proxy. Each DP node is connected to one of the CP nodes. Instead of accessing the database contents directly like in the
traditional deployment method, the DP nodes maintain connection with CP nodes,
and receive the latest configuration. 

Hybrid mode deployments have the following benefits:

* Users can deploy groups of data planes in different data centers, geographies, or zones without needing a local clustered database for each DP group.
* The availability of the database does not affect the availability of the data planes. 
* Drastically reduces the amount of traffic to and from the database, since only CP nodes need a direct connection to the database.
* If one of the DP nodes is compromised, an attacker won’t be able to affect other nodes in the {{site.base_gateway}} cluster.
* Admins only need to interact with the CP nodes to control and monitor the status of the entire {{site.base_gateway}} cluster.

## DB-less and declarative mode

Starting with {{site.base_gateway}} 1.1, you can enable [DB-less mode](/gateway/{{page.kong_version}}/kong-production/deployment-topologies/db-less-and-declarative-config/) to reduce complexity of and create more flexible deployment patterns. In this mode, the entire configuration is stored in-memory on the node.  

The combination of DB-less mode and declarative configuration has a number
of benefits:

* Reduced number of dependencies: no need to manage a database installation
  if the entire setup for your use-cases fits in memory
* It is a good fit for automation in CI/CD scenarios. Configuration for
  entities can be kept in a single source of truth managed via a Git
  repository
* It enables more deployment options for {{site.base_gateway}}

Here are a few limitations of this mode:

* The [Admin API](/gateway/{{page.kong_version}}/admin-api/) is read only.
* You must manage {{site.base_gateway}} using declarative configuration [(decK)](/deck/{{page.kong_version}}/).
* Some plugins, like rate limiting, do not fully function.