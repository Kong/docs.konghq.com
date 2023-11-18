---
title: Kong Enterprise LTS 2.8 to 3.4 upgrade guide
badge: enterprise
---

Kong supports direct upgrades between long-term support (LTS) versions of {{site.ee_product_name}}.

This guide walks you through upgrading from {{site.ee_product_name}} 2.8.x.x LTS to {{site.ee_product_name}} 3.4.x.x LTS.

To make sure your migration is successful, carefully review all the steps in this guide. It’s very important to understand all the preparation steps and choose the recommended upgrade path based on your deployment type.

{:.important}
> **Caution**: The migration pattern described in this document can only happen between two LTS versions, {{site.ee_product_name}} 2.8 LTS and {{site.ee_product_name}} 3.4 LTS. If you apply this document to other release intervals, database modifications may be run in the wrong sequence and leave the database schema in a broken state. To migrate between other versions, see the [upgrade guide](/gateway/{{page.kong_version}}/upgrade/) for your target version.

## Prerequisites

* Starting from 3.4, Cassandra is not supported. 
If you are using Cassandra as your data store, migrate off of Cassandra first and upgrade second.
* [Review KIC upgrade compatibility](/kubernetes-ingress-controller/latest/guides/upgrade-kong-3x/)
* decK upgrade compatibility? <!-- where is this? -->

Please read this document thoroughly to successfully complete the upgrade process, which includes all the necessary operational knowledge for the upgrade.

## Upgrade journey overview

### Preparation phase

There are a number of steps you must complete before you upgrade to Kong 3.4.x.x LTS:
1. Work through any listed prerequistes.
1. Back up your database (if applicable), or your declarative configuration files.
1. Choose the right strategy for upgrading based on your deployment topology.
1. Review the gateway changes from 2.8 to 3.4 for any breaking changes that affect your deployments.
1. Conduct a thorough examination of the modifications made to the `kong.conf` file between the LTS releases.
1. Test migration in a pre-production environment.

All recommended actions for preparation can be found in the [Preparation](#preparation) sections of this document.

### Performing the upgrade 

The actual execution of the migration is dependent on the type of deployment you have with Kong. 
In this guide, we offer recommendations for the type of strategy to use for each supported deployment type. 
See the [Upgrade Strategies](#upgrade-strategies) section of this document to choose the right strategy for you.

1. Execute your chosen upgrade strategy on dev
2. Move from dev to prod
3. Smoke test
4. Wrap up the upgrade or roll back and try again

Now, let's move on to preparation, starting with your backup options.

## Prepation: Choosing a backup strategy

The following instructions lay out how to back up your configuration for each supported deployment type. This is an important step prior to migrating. Each supported deployment mode has different instructions for backup.

The `kong migrations` commands in this guide are not reversible. We recommend backing up data before any migration. 

* **Database backup** (_Traditional mode and control planes in hybrid mode_): PostgreSQL has native exporting and importing tools that are reliable and performant, and that ensure consistency when backing up or restoring data.
* **Declarative backup** (_DB-less mode and data planes in hybrid mode_): In DB-less mode, configuration is managed declaratively using a tool called decK. decK allows you to import and export configuration using YAML or JSON files. 

Review the [Backup and Restore](/gateway/{{page.kong_version}}/upgrade/backup-and-restore/) guide to prepare backups of your configuration.

## Preparation: Choosing an upgrade strategy

Choose your deployment mode:
* [Traditional](#traditional-mode)
* [Hybrid](#hybrid-mode)
* [DB-less](#db-less-mode)

![Choosing a strategy based on the deployment mode](/assets/images/products/gateway/upgrade/choose-your-deployment.png)
> _Figure 1: Choosing an upgrade strategy based on deployment type_

### Traditional mode

A traditional mode deployment is when all Kong Gateway components are running in one environment, and there is no control plane/data plane separation.

Kong is committed to support traditional mode deployments as it is used by a large percentage of our customer base. A stable upgrade procedure is critical for traditional mode customers. 

You have two options when upgrading Kong Gateway in traditional mode:
* [Dual-cluster upgrade](#dual-cluster-upgrade)
* [In-place upgrade](#in-place-upgrade)

We recommend using a dual cluster upgrade if the resources are available.

#### Dual-cluster upgrade

Upgrading a Kong API Gateway from one LTS version to another LTS version with zero downtime can be achieved through a dual-cluster deployment strategy. This approach involves setting up a new cluster running the upgraded version of Kong alongside the existing cluster running the current version.

At a high level, the process typically involves the following steps:

1. **Provisioning a same-size deployment**: You need to ensure that the new cluster, which will run the upgraded version of Kong, has the same capacity and resources as the existing cluster. This ensures that both clusters can handle the same amount of traffic and workload.

2. **Setting up dual-cluster deployment**: Once the new cluster is provisioned, you can start deploying your APIs and configurations to both clusters simultaneously. The dual cluster deployment allows both the old and new clusters to coexist and process requests in parallel.

3. **Data synchronization**:  During the dual cluster deployment, data synchronization is crucial to ensure that both clusters have the same data. This can involve migrating data from the old cluster to the new one or setting up a shared data storage solution to keep both clusters in sync. Import the database from the old cluster to the new cluster by using a snapshot or `pg_restore`.

4. **Traffic rerouting***: As the new cluster is running alongside the old one, you can start gradually routing incoming traffic to the new cluster. This process can be done gradually or through a controlled switchover mechanism to minimize any impact on users. This can be achieved by any load balancer, like DNS, Nginx, F5, or even a Kong node with Canary plugin enabled.

5. **Testing and validation**: Before performing a complete switchover to the new cluster, it is essential to thoroughly test and validate the functionality of the upgraded version. This includes testing APIs, plugins, authentication mechanisms, and other functionalities to ensure they are working as expected.

6. **Complete switchover**: Once you are confident that the upgraded cluster is fully functional and stable, you can redirect all incoming traffic to the new cluster. This step completes the upgrade process and decommissions the old cluster.

By following this dual cluster deployment strategy, you can achieve a smooth and zero-downtime upgrade from one LTS version of Kong to another. This approach helps ensure high availability and uninterrupted service for your users throughout the upgrade process.

#### In-place upgrade

Plan a suitable maintenance or downtime window during which you can perform the upgrade. During this period, the Kong Gateway will be temporarily unavailable.

While an in-place upgrade deployment allows you to perform the upgrade on the same infrastructure, it does require some downtime during the actual upgrade process. 

For scenarios where zero downtime is critical, you would need to consider the dual cluster deployment method mentioned earlier, but that would involve additional resources and complexities.

### DB-less mode

DB-less mode is special in that each independent Kong node loads a copy of Kong configuration data into memory, without persistent database storage, so failure of some nodes will not spread to others.

Customers in this mode are recommended to adopt the rolling upgrade strategy. This strategy relies on changes being made to the kong.yaml and then reloading the db-less instance of Kong.

It is highly recommended to take a backup of your current `kong.yaml` file before starting the upgrade as mentioned above.

### Hybrid mode

Hybrid mode comprises one or more control plane (CP) nodes, and one or more data plane (DP) nodes. Therefore, the recommended upgrade process is a combination of different upgrade strategies for each type of node, CP or DP.

The major challenge with a hybrid mode upgrade is the communication between CP and DP.

Hybrid mode requires that the CP cannot be running a version of Kong that is older than the DPs. For this reason, customers must upgrade their CPs first, and then the DPs

The workflow in figure as below, and we will not repeat the exact upgrade steps. With this approach there is no business downtime. This is the best strategy for customers upgrading in hybrid mode.

[image]

1. Upgrade CP first in accord with the recommendations in section Traditional Mode, while DP nodes are still serving requests.
2. Upgrade DP nodes with exactly the same recommendation in section DB-less Mode. Please be noted that new DP nodes should point to new CP.

With this method, there is no business downtime.

## Preparation: Review gateway changes

We have categorized all changelog notices relevant to this migration below. This encapsulates all changes from 2.8.x.x to 3.4.x.x Kong. They are bucketed into five categories.

{% include lts-changes.html %}

### kong.conf changes

**If we're going to list new params here, this table needs _way_ more work.**

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
 | `allow_debug_header = off` (new parameter)

## Perform upgrade

Now that you have chosen an upgrade strategy, reviewed all the relevant changes between the 2.8 and 3.4 LTS releases
you can move on to performing the upgrade with your chosen strategy:

Traditional mode or control planes in hybrid mode:
* [Dual-cluster upgrade]
* [In-place upgrade]

DB-less mode or data planes in hybrid mode:
* [Rolling upgrade]

## Troubleshooting

If you run into issues during the upgrade and need to roll back, select a restore method in accordance with the backup method picked.

1. Direct database operation: To restore data in this method is fast and robust. Here is a quick demonstration:

    ```sh
    pg_restore -U kong -d kong --clean kongdb_backup_20230816/
    ```

1. decK:

    ```sh
    deck ping
    deck validate --online -s /path/to/kong_backup.yaml
    deck sync -s /path/to/kong_backup.yaml
    ```

    Kong must be online before executing the deck commands.
