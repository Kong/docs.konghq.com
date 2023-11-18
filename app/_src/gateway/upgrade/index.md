---
title: Upgrading Kong Gateway
---

This guide aims to assist you determining appropriate upgrade paths for {{site.base_gateway}} and offers useful advice along the way. 

This guide presents four available upgrade strategies, nominating the best applicable strategy for each deployment mode Kong Gateway supports. Additionally, we list some fundamental factors that play important roles in the upgrade process, and also instruct how to back up and recover data.

{:.note}
> **Note**: If you are interested in upgrading between the {{site.ee_product_name}} 2.8.x and 3.4.x long-term 
support (LTS) versions, see the [LTS upgrade guide](/gateway/{{page.kong_version}}/upgrade/lts-upgrade/).

## Upgrade journey overview

### Preparation phase

1. Work through any listed prerequisites.
1. Back up your database or your declarative configuration files.
1. Determine your upgrade path based on the release you're starting from and the release you're upgrading to.
1. Choose the right strategy for upgrading based on your deployment topology.
1. Review the breaking changes for the version you're upgrading to.
1. Test migration in a pre-production environment.

### Performing the upgrade 

The actual execution of the migration is dependent on the type of deployment you have with Kong. 
In this guide, we offer recommendations for the type of strategy to use for each supported deployment type. 
See the [Upgrade Strategies and Deployment Modes](#preparation-upgrade-strategies-and-deployment-modes) 
section of this document to choose the right strategy for you.

1. Execute your chosen upgrade strategy on dev.
2. Move from dev to prod.
3. Smoke test.
4. Wrap up the upgrade or roll back and try again.

Now, let's move on to preparation, starting determining your upgrade path.

## Preparation: Upgrade paths

Kong adheres to [semantic versioning](https://semver.org/), which makes a
distinction between major, minor, and patch versions.

The upgrade to 3.0.x is a **major** upgrade.
The lowest version that Kong 3.0.x supports migrating from is 2.1.x.

{{site.base_gateway}} does not support directly upgrading from 1.x to 3.0.x.
If you are running 1.x, upgrade to 2.1.0 first at minimum, then upgrade to 3.0.x from there.

While you can upgrade directly to the latest version, be aware of any
breaking changes between the 2.x and 3.x series noted in this document
(both this version and prior versions) and in the
[open-source (OSS)](https://github.com/Kong/kong/blob/release/3.0.x/CHANGELOG.md#300) and
[Enterprise](/gateway/changelog/#3000) Gateway changelogs. Since {{site.base_gateway}}
is built on an open-source foundation, any breaking changes in OSS affect all {{site.base_gateway}} packages.

An upgrade path is subject to a wide spectrum of conditions, and there is not a one-size-fits-all way applicable to all customers, depending on the deployment modes, custom plugins, customers’ technical capabilities, hardware capacities, SLA, etc. Our engineers should discuss thoroughly and carefully with customers before taking any action.

We encourage you to stay updated with Kong Gateway releases, as that helps maintain a smooth upgrade path. 
The smaller the version gap is, the less complex the upgrade process becomes.

### Guaranteed upgrade paths

By default, Kong Gateway has migration tests between adjacent versions and hence the following upgrade paths are guaranteed officially:

1. Between patch releases of the same major and minor version.
2. Between adjacent minor releases of the same major version.
3. Between LTS versions.

    Kong Gateway plans to maintain LTS versions and guarantee upgrades between adjacent LTS versions. The current LTS in 2.x series is 2.8, and that in 3.x is 3.4. We may even maintain multiple LTS versions in the same major series.

### Upgrade path exceptions

#### Cassandra support

Kong has completely removed Cassandra support with 3.4.0.0, so affected customers can only upgrade to 3.3.x if Cassandra is the only choice. Please refer to the section Upgrade Considerations for migration from Cassandra to Postgres.

#### Upgrades from 3.1.0.0 or 3.1.1.1

There is a special case where you deploy Kong Gateway in hybrid mode and the version in use is 3.1.0.0 and 3.1.1.1. Kong Gateway removed the legacy WebSocket protocol, added a new WebSocket protocol between CP and DP in 3.1.0.0, and added back the legacy one in 3.1.1.2. So, please upgrade to 3.1.1.2 first before moving forward to higher versions. Additionally, the new WebSocket Protocol has been completely removed since 3.2.0.0 as shown in table 1. Please also read Memo: wRPC Deprecation and Upgrade Impacts.

Kong Gateway Version | Legacy WebSocket (JSON) | New WebSocket (RPC)
---------------------|-------------------------|--------------------
3.0.0.0 | Y | Y
3.1.0.0 and 3.1.1.1 | N | Y
3.1.1.2 | Y | Y
3.2.0.0 | Y | N

## Prepation: Choosing a backup strategy

The following instructions lay out how to back up your configuration for each supported deployment type. This is an important step prior to migrating. Each supported deployment mode has different instructions for backup.

The `kong migrations` commands in this guide are not reversible. We recommend backing up data before any migration. 

* **Database backup** (_Traditional mode and control planes in hybrid mode_): PostgreSQL has native exporting and importing tools that are reliable and performant, and that ensure consistency when backing up or restoring data.
* **Declarative backup** (_DB-less mode and data planes in hybrid mode_): In DB-less mode, configuration is managed declaratively using a tool called decK. decK allows you to import and export configuration using YAML or JSON files. 

Review the [Backup and Restore](/gateway/{{page.kong_version}}/upgrade/backup-and-restore/) guide to prepare backups of your configuration.

## Preparation: Upgrade strategies and deployment modes

Upgrade strategies introduced in this section are generic and may or may not fit in with your deployment environment. We will nominate the best applicable strategies for each deployment mode in the section Choose Strategies, with detailed instructions.

Kong Gateway deployment with a database, including control planes:
* Dual-cluster Upgrade
* In-place Upgrade
* Blue-green Upgrade (derived from an in-place upgrade)

DB-less mode and data planes in a hybrid mode environment:
* Rolling Upgrade

Here's a flow chart the breaks down how the decision process works:

![Choosing a strategy based on the deployment mode](/assets/images/products/gateway/upgrade/choose-your-deployment.png)
> _Figure 1: Choosing an upgrade strategy based on deployment type_

See the following sections for breakdowns and links to each upgrade strategy guide.

### Traditional mode

A traditional mode deployment is when all Kong Gateway components are running in one environment, and there is no control plane/data plane separation.

You have two options when upgrading Kong Gateway in traditional mode:
* [Dual-cluster upgrade](/gateway/{{page.kong_version}}/upgrade/dual-cluster-upgrade): A new Kong cluster of version Y is deployed alongside the current version X, so that two clusters serve requests concurrently during the upgrade process.
* [In-place upgrade](/gateway/{{page.kong_version}}/upgrade/in-place-upgrade): Similar to, but unlike the dual-cluster upgrade strategy, an in-place upgrade reuses the existing database and has to shut down the cluster X first, then configure the new cluster Y to point to the database.

We recommend using a dual cluster upgrade if the resources are available.

### DB-less mode

DB-less mode is special in that each independent Kong node loads a copy of declarative Kong configuration data into memory, without persistent database storage, so failure of some nodes will not spread to other nodes.

Deployments in this mode are recommended to adopt the [Rolling Upgrade](/gateway/{{page.kong_version}}/upgrade/rolling-upgrade/) strategy. As proposed, you could parse the validity of the declarative YAML contents with version Y, using the `deck validate` command.

Backup of the declarative YAML file to a safe storage is still a recommended upgrade step.

### Hybrid mode

Hybrid mode comprises one or more control plane (CP) nodes, and one or more data plane (DP) nodes. Therefore, the recommended upgrade process is a combination of different upgrade strategies for each type of node, CP or DP.

The major challenge with a hybrid mode upgrade is the communication between CP and DP. As hybrid mode requires the minor version of CP to be no less than that of DP, you must upgrade CP nodes before DP nodes. Therefore, the upgrade will be carried out in two phases, as follows.

* Upgrade CP first according to the recommendations in the section [Traditional Mode](#traditional-mode), while DP nodes are still serving API requests.
* Upgrade DP next with exactly the same recommendations in the section [DB-less Mode](#db-less-mode). Please set new DP nodes pointing to the new CP to avoid version conflicts.

With this method, there is no business downtime.

The role decoupling feature between CP and DP enables DP nodes to serve API requests while upgrading CP. Consequently, upgrade of hybrid mode deployments bring no downtime to business.

We will present the two phases in detail in the following two subsections.

#### Control planes

As described in the previous section, we must upgrade the CP nodes before the DP nodes. CP nodes serve an Admin-only role and demand database support (e.g. PostgreSQL). So, we are free to select the same upgrade strategies nominated for the Traditional Mode, namely Dual-Cluster Strategy or In-place Strategy as described in figure 2 and figure 3 respectively.

Figure 2, by Dual-Cluster Strategy, has a new CP Y deployed alongside with current CP X, while current DP nodes X are still serving API requests.

![Dual-cluster hybrid upgrade workflow](/assets/images/products/gateway/upgrade/dual-cluster-hybrid-upgrade.png)
> _Figure 2: Upgrade CP by Dual-Cluster Strategy_

In figure 3, current CP X is replaced with a new CP Y. The upgrade is more or less the same as that in figure 2, but the database is reused by the new CP Y, and current CP X is shut down.

![In-place hybrid upgrade workflow](/assets/images/products/gateway/upgrade/in-place-hybrid-upgrade.png)
> _Figure 3: Upgrade CP by In-place Strategy_

From the two figures, you can find DP nodes X remain connection to current CP node X, or alternatively switch to the new CP node Y. Kong Gateway guarantees that new minor versions of CP are compatible with old minor versions of DP, so that you can temporarily set DP nodes X pointing to the new CP node Y. This allows the upgrade process to be conducted over a longer period of time or to be paused. We do not recommend the combination between new version of CP nodes and old version of DP nodes as a long-term production deployment.

After the CP upgrade, current X can be decommissioned, although you can delay it to the very end of DP upgrade.

#### Data planes

Once the CP nodes are upgraded, let’s move on to upgrade the DP nodes. The only strategy for DP upgrades is the Rolling Upgrade.

Figure 4 and 5 below are the counterparts of figure 2 and 3 respectively. The background colour of current CP X and/or current DB is white, signalling that the CP part has already been upgraded and might have been decommissioned.

![Dual-cluster and rolling upgrade workflow](/assets/images/products/gateway/upgrade/dual-cluster-rolling-hybrid-upgrade.png)
> _Figure 4: Upgrade by Dual-Cluster Strategy and Rolling Strategy_

The Rolling Upgrade Strategy applied to the DP side is self-explanatory, and rollback is quite fast.

![In-place and rolling upgrade workflow](/assets/images/products/gateway/upgrade/in-place-rolling-hybrid-upgrade.png)
> _Figure 5: Upgrade by In-place Strategy and Rolling Strategy_

## Next steps

Once you have reviewed everything and chosen a strategy, proceed to upgrade using your chosen strategy:

* [Dual-cluster upgrade](/gateway/{{page.kong_version}}/upgrade/dual-cluster/)
* [In-place upgrade](/gateway/{{page.kong_version}}/upgrade/in-place/)
* [Blue-green upgrade](/gateway/{{page.kong_version}}/upgrade/blue-green/)
* [Rolling upgrade](/gateway/{{page.kong_version}}/upgrade/rolling-upgrade/)
