---
title: Kong Enterprise LTS 2.8 to 3.4 upgrade guide
badge: enterprise
---

{{site.base_gateway}} supports direct upgrades between long-term support (LTS) versions of {{site.ee_product_name}}.

This guide walks you through upgrading from {{site.ee_product_name}} 2.8 LTS to {{site.ee_product_name}} 3.4 LTS, 
specifically covering 2.8.0.0-2.8.4.1 up to 3.4.0.0.
Carefully review each entry and make changes to your configuration accordingly.

There are three upgrade strategies available for the LTS to LTS upgrade. 
This guide nominates the best applicable strategy for each deployment mode that {{site.base_gateway}} supports. 
Additionally, it lists some fundamental factors that play important roles in the upgrade process, and explains how to back up and recover data.

This guide uses the following terms in the context of {{site.base_gateway}}:
* **Upgrade**: The overall process of switching from an older to a newer version of {{site.base_gateway}}. 
* **Migration**: The migration of your data store data into a new environment. 
For example, the process of moving 2.8 data from an old PostgreSQL instance to a new one for 3.4 is referred to as database migration.

To make sure your upgrade is successful, carefully review all the steps in this guide. It’s very important to understand all the preparation steps and choose the recommended upgrade path based on your deployment type.

{:.important}
> **Caution**: The migration pattern described in this document can only happen between two LTS versions, {{site.ee_product_name}} 2.8 LTS and {{site.ee_product_name}} 3.4 LTS. If you apply this document to other release intervals, database modifications may be run in the wrong sequence and leave the database schema in a broken state. To migrate between other versions, see the [general upgrade guide](/gateway/{{page.release}}/upgrade/).

## Prerequisites

* Starting from 3.4, Cassandra is not supported. 
If you're using Cassandra as your data store, [migrate off of Cassandra](/gateway/{{page.release}}/migrate-cassandra-to-postgres/) first and upgrade second.
* Review version compatibility between your platform version and the version of {{site.kong_gateway}} that you are upgrading to:
    * [OS version](/gateway/{{page.release}}/support-policy/#supported-versions)
    * [Kubernetes version and Helm prerequisites](/kubernetes-ingress-controller/latest/support-policy/)
    {% if_version gte:3.2.x -%}
    * [Database version](/gateway/{{page.release}}/support/third-party/)
    * [Dependency versions](/gateway/{{page.release}}/support/third-party/)
    {% endif_version %}
* [Review KIC upgrade compatibility](/kubernetes-ingress-controller/latest/guides/upgrade-kong-3x/).
* If you're using decK, [upgrade it to the latest version](/deck/latest/installation/).

Read this document thoroughly to successfully complete the upgrade process, as it includes all the necessary operational knowledge for the upgrade.

## Upgrade journey overview

**Preparation phase**

There are a number of steps you must complete before upgrading to {{site.base_gateway}} 3.4 LTS:

1. Work through any listed prerequisites.
1. [Back up](#preparation-choose-a-backup-strategy) your database or your declarative configuration files.
1. Choose the right [strategy for upgrading](#preparation-choose-an-upgrade-strategy-based-on-deployment-mode) based on your deployment topology.
1. Review the [{{site.base_gateway}} changes from 2.8 to 3.4](#preparation-review-gateway-changes) for any breaking changes that affect your deployments.
1. Conduct a thorough examination of the [modifications made to the `kong.conf` file](#kongconf-changes) between the LTS releases.
1. Using your chosen strategy, test migration in a pre-production environment.

**Performing the upgrade**

The actual execution of the migration is dependent on the type of deployment you have with {{site.base_gateway}}. 
In this part of the upgrade journey, you will use the strategy you determined during the preparation phase.

1. Execute your chosen upgrade strategy on dev.
2. Move from dev to prod.
3. Smoke test.
4. Wrap up the upgrade or roll back and try again.

Now, let's move on to preparation, starting with your backup options.

## Preparation: Choose a backup strategy

{% include_cached /md/gateway/upgrade-backup.md release=page.release %}

## Preparation: Choose an upgrade strategy based on deployment mode

Upgrade strategies introduced in this section are generic and may or may not fit in with your deployment environment. 

Choose your deployment mode:
* [Traditional](#traditional-mode)
* [DB-less](#db-less-mode)
* [Hybrid](#hybrid-mode)

Here's a flowchart that breaks down how the decision process works:

{% include_cached md/gateway/upgrade-flow.md %}

See the following sections for breakdowns of each strategy.

### Traditional mode

{% include_cached /md/gateway/traditional-upgrade.md %}

#### Dual-cluster upgrade

Upgrading {{site.base_gateway}} from one LTS version to another LTS version with zero downtime can be achieved through a [dual-cluster upgrade strategy](/gateway/{{page.release}}/upgrade/dual-cluster/). 
This approach involves setting up a new cluster running the upgraded version of {{site.base_gateway}} alongside the existing cluster running the current version.

At a high level, the process typically involves the following steps:

1. **Provisioning a same-size deployment**: You need to ensure that the new cluster, which will run the upgraded version of {{site.base_gateway}}, has the same capacity and resources as the existing cluster. This ensures that both clusters can handle the same amount of traffic and workload.

2. **Setting up dual-cluster deployment**: Once the new cluster is provisioned, you can start deploying your APIs and configurations to both clusters simultaneously. The dual cluster deployment allows both the old and new clusters to coexist and process requests in parallel.

3. **Data synchronization**:  During the dual cluster deployment, data synchronization is crucial to ensure that both clusters have the same data. This can involve migrating data from the old cluster to the new one or setting up a shared data storage solution to keep both clusters in sync. Import the database from the old cluster to the new cluster by using a snapshot or `pg_restore`.

4. **Traffic rerouting**: As the new cluster is running alongside the old one, you can start gradually routing incoming traffic to the new cluster. This process can be done gradually or through a controlled switchover mechanism to minimize any impact on users. This can be achieved by any load balancer, like DNS, Nginx, F5, or even a {{site.base_gateway}} node with Canary plugin enabled.

5. **Testing and validation**: Before performing a complete switchover to the new cluster, it is essential to thoroughly test and validate the functionality of the upgraded version. This includes testing APIs, plugins, authentication mechanisms, and other functionalities to ensure they are working as expected.

6. **Complete switchover**: Once you are confident that the upgraded cluster is fully functional and stable, you can redirect all incoming traffic to the new cluster. This step completes the upgrade process and decommissions the old cluster.

By following this dual cluster deployment strategy, you can achieve a smooth and zero-downtime upgrade from one LTS version of {{site.base_gateway}} to another. This approach helps ensure high availability and uninterrupted service for your users throughout the upgrade process.

#### In-place upgrade

While an [in-place upgrade](/gateway/{{page.release}}/upgrade/in-place/) allows you to perform the upgrade on the same infrastructure, 
it does require some downtime during the actual upgrade process.
Plan a suitable maintenance or downtime window during which you can perform the upgrade.
During this period, the {{site.base_gateway}} will be temporarily unavailable.

For scenarios where zero downtime is critical, consider the [dual-cluster upgrade](#dual-cluster-upgrade) method, 
keeping in mind the additional resources and complexities.

### DB-less mode

{% include_cached /md/gateway/db-less-upgrade.md release=page.release %}

### Hybrid mode

{% include_cached /md/gateway/hybrid-upgrade.md release=page.release %}

## Preparation: Review gateway changes

The following tables categorize all relevant changelog entries from {{site.ee_product_name}} 2.8.0.0-2.8.4.1 up to 3.4.0.0.
Carefully review each entry and make changes to your configuration accordingly.

{% include_cached lts-changes.html %}

### kong.conf changes

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
* [Dual-cluster upgrade](/gateway/{{page.release}}/upgrade/dual-cluster/)
* [In-place upgrade](/gateway/{{page.release}}/upgrade/in-place/)

DB-less mode or data planes in hybrid mode:
* [Rolling upgrade](/gateway/{{page.release}}/upgrade/rolling-upgrade/)

## Troubleshooting

If you run into issues during the upgrade and need to roll back, [restore {{site.base_gateway}}](/gateway/{{page.release}}/upgrade/backup-and-restore/#restore-gateway-entities) based on the backup method.
