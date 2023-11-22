---
title: Kong Enterprise LTS 2.8 to 3.4 upgrade guide
badge: enterprise
---

Kong supports direct upgrades between long-term support (LTS) versions of {{site.ee_product_name}}.

This guide walks you through upgrading from {{site.ee_product_name}} 2.8.x.x LTS to {{site.ee_product_name}} 3.4.x.x LTS. It presents three available upgrade strategies, nominating the best applicable strategy for each deployment mode {{site.base_gateway}} supports. Additionally, we list some fundamental factors that play important roles in the upgrade process, and also instruct how to back up and recover data.

This guide uses the following terms in the context of Kong:
* **Upgrade**: The overall process of switching from an older to a newer version of Kong. 
* **Migration**: The migration of your data store data into a new environment. 
For example, the process of moving 2.8.x data from an old PostgreSQL instance to a new one for 3.4.x is referred to as database migration.

To make sure your upgrade is successful, carefully review all the steps in this guide. It’s very important to understand all the preparation steps and choose the recommended upgrade path based on your deployment type.

{:.important}
> **Caution**: The migration pattern described in this document can only happen between two LTS versions, {{site.ee_product_name}} 2.8 LTS and {{site.ee_product_name}} 3.4 LTS. If you apply this document to other release intervals, database modifications may be run in the wrong sequence and leave the database schema in a broken state. To migrate between other versions, see the [general upgrade guide](/gateway/{{page.kong_version}}/upgrade/) for your target version.

## Prerequisites

* Starting from 3.4, Cassandra is not supported. 
If you are using Cassandra as your data store, migrate off of Cassandra first and upgrade second.
* [Review KIC upgrade compatibility](/kubernetes-ingress-controller/latest/guides/upgrade-kong-3x/)
* decK upgrade compatibility? <!-- where is this? -->

Read this document thoroughly to successfully complete the upgrade process, as it includes all the necessary operational knowledge for the upgrade.

## Upgrade journey overview

**Preparation phase**

There are a number of steps you must complete before upgrading to Kong 3.4.x.x LTS:

1. Work through any listed prerequistes.
1. Back up your database (if applicable), or your declarative configuration files.
1. Choose the right strategy for upgrading based on your deployment topology.
1. Review the gateway changes from 2.8 to 3.4 for any breaking changes that affect your deployments.
1. Conduct a thorough examination of the modifications made to the `kong.conf` file between the LTS releases.
1. Using your chosen strategy, test migration in a pre-production environment.

**Performing the upgrade**

The actual execution of the migration is dependent on the type of deployment you have with Kong. 
In this part of the upgrade journey, you will use the strategy you determined during the preparation phase.

1. Execute your chosen upgrade strategy on dev.
2. Move from dev to prod.
3. Smoke test.
4. Wrap up the upgrade or roll back and try again.

Now, let's move on to preparation, starting with your backup options.

## Prepation: Choosing a backup strategy

The following instructions lay out how to back up your configuration for each supported deployment type. This is an important step prior to upgrading. Each supported deployment mode has different instructions for backup.

The `kong migrations` commands in this guide are not reversible. We recommend backing up data before any migration. 

* **Database backup** (_Traditional mode and control planes in hybrid mode_): PostgreSQL has native exporting and importing tools that are reliable and performant, and that ensure consistency when backing up or restoring data.
* **Declarative backup** (_DB-less mode and data planes in hybrid mode_): In DB-less mode, configuration is managed declaratively using a tool called decK. decK allows you to import and export configuration using YAML or JSON files. 

Review the [Backup and Restore](/gateway/{{page.kong_version}}/upgrade/backup-and-restore/) guide to prepare backups of your configuration. If you run into any issues and need to roll back, you can also reference that guide to restore your old data store.

## Preparation: Choosing an upgrade strategy

Upgrade strategies introduced in this section are generic and may or may not fit in with your deployment environment. 

Choose your deployment mode:
* [Traditional](#traditional-mode)
* [Hybrid](#hybrid-mode)
* [DB-less](#db-less-mode)

Here's a flow chart the summarizes how the decision process works:

![Choosing a strategy based on the deployment mode](/assets/images/products/gateway/upgrade/choose-your-deployment.png)
> _Figure 1: Choosing an upgrade strategy based on deployment type_

See the following sections for breakdowns of each strategy.

### Traditional mode

A traditional mode deployment is when all {{site.base_gateway}} components are running in one environment, and there is no control plane/data plane separation.

You have two options when upgrading {{site.base_gateway}} in traditional mode:
* **Dual-cluster upgrade**: A new Kong cluster of version Y is deployed alongside the current version X, so that two clusters serve requests concurrently during the upgrade process.
* **In-place upgrade**: Similar to, but unlike the dual-cluster upgrade strategy, an in-place upgrade reuses the existing database and has to shut down the cluster X first, then configure the new cluster Y to point to the database.

We recommend using a dual cluster upgrade if the resources are available.

#### Dual-cluster upgrade

Upgrading a Kong API Gateway from one LTS version to another LTS version with zero downtime can be achieved through a dual-cluster deployment strategy. This approach involves setting up a new cluster running the upgraded version of Kong alongside the existing cluster running the current version.

At a high level, the process typically involves the following steps:

1. **Provisioning a same-size deployment**: You need to ensure that the new cluster, which will run the upgraded version of Kong, has the same capacity and resources as the existing cluster. This ensures that both clusters can handle the same amount of traffic and workload.

2. **Setting up dual-cluster deployment**: Once the new cluster is provisioned, you can start deploying your APIs and configurations to both clusters simultaneously. The dual cluster deployment allows both the old and new clusters to coexist and process requests in parallel.

3. **Data synchronization**:  During the dual cluster deployment, data synchronization is crucial to ensure that both clusters have the same data. This can involve migrating data from the old cluster to the new one or setting up a shared data storage solution to keep both clusters in sync. Import the database from the old cluster to the new cluster by using a snapshot or `pg_restore`.

4. **Traffic rerouting**: As the new cluster is running alongside the old one, you can start gradually routing incoming traffic to the new cluster. This process can be done gradually or through a controlled switchover mechanism to minimize any impact on users. This can be achieved by any load balancer, like DNS, Nginx, F5, or even a Kong node with Canary plugin enabled.

5. **Testing and validation**: Before performing a complete switchover to the new cluster, it is essential to thoroughly test and validate the functionality of the upgraded version. This includes testing APIs, plugins, authentication mechanisms, and other functionalities to ensure they are working as expected.

6. **Complete switchover**: Once you are confident that the upgraded cluster is fully functional and stable, you can redirect all incoming traffic to the new cluster. This step completes the upgrade process and decommissions the old cluster.

By following this dual cluster deployment strategy, you can achieve a smooth and zero-downtime upgrade from one LTS version of Kong to another. This approach helps ensure high availability and uninterrupted service for your users throughout the upgrade process.

#### In-place upgrade

Plan a suitable maintenance or downtime window during which you can perform the upgrade. During this period, the {{site.base_gateway}} will be temporarily unavailable.

While an in-place upgrade deployment allows you to perform the upgrade on the same infrastructure, it does require some downtime during the actual upgrade process. 

For scenarios where zero downtime is critical, you would need to consider the dual cluster deployment method mentioned earlier, but that would involve additional resources and complexities.

### DB-less mode

DB-less mode is special in that each independent Kong node loads a copy of Kong configuration data into memory, without persistent database storage, so failure of some nodes will not spread to others.

Customers in this mode are recommended to adopt the rolling upgrade strategy. This strategy relies on changes being made to the kong.yaml and then reloading the db-less instance of Kong.

It is highly recommended to take a backup of your current `kong.yaml` file before starting the upgrade as mentioned above.

### Hybrid mode

Hybrid mode comprises one or more control plane (CP) nodes, and one or more data plane (DP) nodes. 
CP nodes use a database to store Kong configuration data, whereas DP nodes do not, since they get all of the needed information from the CP.
Therefore, the recommended upgrade process is a combination of different upgrade strategies for each type of node, CP or DP.

The major challenge with a hybrid mode upgrade is the communication between CP and DP.

In hybrid mode, the CP can't be running a version of Kong that is older than the versions of the DPs. For 
this reason, you must upgrade your CPs first, and then the DPs. With this method, there is no business downtime.

See the upgrade workflow in the following diagram.

![Upgrading a hybrid mode deployment](/assets/images/products/gateway/upgrade/hybrid-mode-upgrade.png)
> _Figure 2: Upgrading a hybrid mode deployment using a dual-cluster or in-place strategy for control planes,_
_followed by a rolling upgrade strategy for data planes_.

1. First, upgrade the CP according to the recommendations in the section [Traditional Mode](#traditional-mode), while DP nodes are still serving API requests.
2. Next, upgrade DP nodes using the recommendations from the section [DB-less Mode](#db-less-mode). 
Point the new DP nodes to the new CP to avoid version conflicts.

## Preparation: Review gateway changes

We have categorized all changelog notices relevant to this migration below. This encapsulates all changes from 2.8.x.x to 3.4.x.x Kong. They are bucketed into five categories.

{% include_cached lts-changes.html %}

### kong.conf changes

<!-- **If we're going to list new params here, this table needs _way_ more work.** -->

2.8 | 3.4
----------------------|-----------------------
`data_plane_config_cache_mode` = unencrypted | Removed in 3.4
`data_plane_config_cache_path` | Removed in 3.4
`admin_api_uri` | Deprecated. Use `admin_gui_api_url` instead
`database` | Accepted values are `postgres` and `off`. All Cassandra options have been removed
`pg_keepalive_timeout = 60000` | Specify the maximal idle timeout (in ms) for the Postgres connections in the pool. If this value is set to 0 then the timeout interval is unlimited. If not specified this value will be the same as `lua_socket_keepalive_timeout`.
`worker_consistency = strict` | `worker_consistency = eventual`
`prometheus_plugin_*` | Disabled Prometheus plugin high-cardinality metrics.
`lua_ssl_trusted_certificate` <br> No default value | Default value: `lua_ssl_trusted_certificate = system`
`pg_ssl_version = tlsv1` | `pg_ssl_version = tlsv1_2 `
-- | `allow_debug_header = off` (new parameter)

## Perform upgrade

Now that you have chosen an upgrade strategy, reviewed all the relevant changes between the 2.8 and 3.4 LTS releases
you can move on to performing the upgrade with your chosen strategy:

Traditional mode or control planes in hybrid mode:
* [Dual-cluster upgrade](/gateway/{{page.kong_version}}/upgrade/dual-cluster/)
* [In-place upgrade](/gateway/{{page.kong_version}}/upgrade/in-place/)

DB-less mode or data planes in hybrid mode:
* [Rolling upgrade](/gateway/{{page.kong_version}}/upgrade/rolling-upgrade/)

## Troubleshooting

If you run into issues during the upgrade and need to roll back, select a restoration method based on the backup method.

{% navtabs %}
{% navtab Database %}
Using direct database operation (PostgreSQL):

```sh
pg_restore -U kong -d kong --clean kongdb_backup_20230816/
```

{% endnavtab %}
{% navtab Declarative configuration %}

Using decK, apply your backup configuration files.
{{site.base_gateway}} must be online before executing decK commands. 

Ping the Gateway to make sure the connection is working:
```sh
deck ping
```

Validate the configuration:
```sh
deck validate --online -s /path/to/kong_backup.yaml
```

If valid, sync the backup configuration to {{site.base_gateway}} restore the previous state:
```sh
deck sync -s /path/to/kong_backup.yaml
```
{% endnavtab %}
{% endnavtabs %}
    
