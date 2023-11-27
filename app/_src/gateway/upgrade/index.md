---
title: Upgrading Kong Gateway
content_type: reference
purpose: This guide walks you through upgrade paths for {{site.base_gateway}} and helps you prepare for an upgrade.
---

Using this guide, prepare for a {{site.base_gateway}} upgrade and determine which {{site.base_gateway}} upgrade paths to use.

This guide walks you through four available upgrade strategies and recommends the best strategy for each {{site.base_gateway}} deployment mode. 
Additionally, we list some fundamental factors that play important roles in the upgrade process, and instruct how to back up and recover data.

This guide uses the following terms in the context of {{site.base_gateway}}:
* **Upgrade**: The overall process of switching from an older to a newer version of {{site.base_gateway}}. 
* **Migration**: The migration of your data store data into a new environment. 
For example, the process of moving 2.8.x data from an old PostgreSQL instance to a new one for 3.4.x is referred to as database migration.

{:.note}
> **Note**: If you are interested in upgrading between the {{site.ee_product_name}} 2.8.x and 3.4.x long-term 
support (LTS) versions, see the [LTS upgrade guide](/gateway/{{page.kong_version}}/upgrade/lts-upgrade/).

## Upgrade overview

A {{site.base_gateway}} upgrade requires two phases of work: preparing for the upgrade and applying the upgrade.

**Preparation phase**

1. Determine your [upgrade path](#preparation-review-upgrade-paths) based on the release you're starting from and the release you're upgrading to.
1. [Back up](#preparation-choose-a-backup-strategy) your database or your declarative configuration files.
1. Choose the right [strategy for upgrading](#preparation-choose-an-upgrade-strategy-based-on-deployment-mode) based on your deployment topology.
1. Review the [breaking changes](#prepation-review-breaking-changes) for the version you're upgrading to.
1. Review any remaining [upgrade considerations](#preparation-upgrade-considerations).
1. Test migration in a pre-production environment.

**Performing the upgrade**

The actual execution of the upgrade is dependent on the type of deployment you have with {{site.base_gateway}}. 
In this part of the upgrade journey, you will use the strategy you determined during the preparation phase.

1. Execute your chosen upgrade strategy on dev.
2. Move from dev to prod.
3. Smoke test.
4. Wrap up the upgrade or roll back and try again.

Now, let's move on to preparation, starting with determining your upgrade path.

## Preparation: Review upgrade paths

{{site.base_gateway}} adheres to [semantic versioning](https://semver.org/), which makes a
distinction between major, minor, and patch versions.

The upgrade to 3.0.x is a **major** upgrade.
The lowest version that {{site.base_gateway}} 3.0.x supports migrating from is 2.1.x.

{{site.base_gateway}} does not support directly upgrading from 1.x to 3.0.x.
If you are running 1.x, upgrade to 2.1.0 first at a minimum, then upgrade to 3.0.x from there.

While you can upgrade directly to the latest version, be aware of any
[breaking changes](/gateway/{{page.kong_version}}/breaking-changes/)
between the 2.x and 3.x series (both this version and prior versions) and in the
open-source (OSS) and Enterprise Gateway changelogs. Since {{site.base_gateway}}
is built on an open-source foundation, any breaking changes in OSS affect all {{site.base_gateway}} packages.

An upgrade path is subject to a wide spectrum of conditions, and there is not a one-size-fits-all way applicable to all customers, depending on the deployment modes, custom plugins, customers’ technical capabilities, hardware capacities, SLA, etc. Our engineers should discuss thoroughly and carefully with customers before taking any action.

We encourage you to stay updated with {{site.base_gateway}} releases, as that helps maintain a smooth upgrade path. 
The smaller the version gap is, the less complex the upgrade process becomes.

### Guaranteed upgrade paths

By default, {{site.base_gateway}} has migration tests between adjacent versions and hence the following upgrade paths are guaranteed officially:

1. Between patch releases of the same major and minor version.
2. Between adjacent minor releases of the same major version.
3. Between LTS versions.

    {{site.base_gateway}} plans to maintain LTS versions and guarantee upgrades between adjacent LTS versions. 
    The current LTS in the 2.x series is 2.8, and the current LTS in the 3.x series is 3.4.

    If you want to upgrade between the 2.8 and 3.4 LTS versions, 
    see the [LTS Upgrade guide](/gateway/{{page.kong_version}}/upgrade/lts-upgrade/).

The following table outlines various upgrade path scenarios to {{page.kong_version}} depending on the {{site.base_gateway}} version you are currently using:

{% if_version lte: 3.1.x %}

| **Current version** | **Topology** | **Direct upgrade possible?** | **Upgrade path** |
| ------------------- | ------------ | ---------------------------- | ---------------- |
| 2.x–2.7.x | Traditional | No | [Upgrade to 2.8.2.x](/gateway/2.8.x/install-and-run/upgrade-enterprise/) (required for blue/green deployments only), then [upgrade to 3.0.x](/gateway/3.0.x/upgrade/), and then [upgrade to 3.1.x](#migrate-db). |
| 2.x–2.7.x | Hybrid | No | [Upgrade to 2.8.2.x](/gateway/2.8.x/install-and-run/upgrade-enterprise/), then [upgrade to 3.0.x](/gateway/3.0.x/upgrade/), and then [upgrade to 3.1.x](#migrate-db). |
| 2.x–2.7.x | DB less | No | [Upgrade to 3.0.x](/gateway/3.0.x/upgrade/), and then [upgrade to 3.1.x](#migrate-db). |
| 2.8.x | Traditional | No | [Upgrade to 3.0.x](/gateway/3.0.x/upgrade/), and then [upgrade to 3.1.x](#migrate-db). |
| 2.8.x | Hybrid | No | [Upgrade to 3.0.x](/gateway/3.0.x/upgrade/), and then [upgrade to 3.1.1.3](#migrate-db). |
| 2.8.x | DB less | No | [Upgrade to 3.0.x](/gateway/3.0.x/upgrade/), and then [upgrade to 3.1.x](#migrate-db). |
| 3.0.x | Traditional | Yes | [Upgrade to 3.1.x](#migrate-db). |
| 3.0.x | Hybrid | Yes | [Upgrade to 3.1.x](#migrate-db). |
| 3.0.x | DB less | Yes | [Upgrade to 3.1.x](#migrate-db). |

{% endif_version %}

{% if_version eq: 3.2.x %}

| **Current version** | **Topology** | **Direct upgrade possible?** | **Upgrade path** |
| ------------------- | ------------ | ---------------------------- | ---------------- |
| 2.x–2.7.x | Traditional | No | [Upgrade to 2.8.2.x](/gateway/2.8.x/install-and-run/upgrade-enterprise/) (required for blue/green deployments only), [upgrade to 3.0.x](/gateway/3.0.x/upgrade/), [upgrade to 3.1.x](/gateway/3.1.x/upgrade/#migrate-db), and then [upgrade to 3.2.x](#migrate-db). |
| 2.x–2.7.x | Hybrid | No | [Upgrade to 2.8.2.x](/gateway/2.8.x/install-and-run/upgrade-enterprise/), [upgrade to 3.0.x](/gateway/3.0.x/upgrade/), [upgrade to 3.1.x](/gateway/3.1.x/upgrade/#migrate-db), and then [upgrade to 3.2.x](#migrate-db). |
| 2.x–2.7.x | DB less | No | [Upgrade to 3.0.x](/gateway/3.0.x/upgrade/), [upgrade to 3.1.x](/gateway/3.1.x/upgrade/#migrate-db), and then [upgrade to 3.2.x](#migrate-db). |
| 2.8.x | Traditional | No | [Upgrade to 3.1.1.3](/gateway/3.1.x/upgrade/#migrate-db), and then [upgrade to 3.2.x](#migrate-db). |
| 2.8.x | Hybrid | No | [Upgrade to 3.1.1.3](/gateway/3.1.x/upgrade/#migrate-db), and then [upgrade to 3.2.x](#migrate-db). |
| 2.8.x | DB less | No | [Upgrade to 3.1.1.3](/gateway/3.1.x/upgrade/#migrate-db), and then [upgrade to 3.2.x](#migrate-db). |
| 3.0.x | Traditional | No | [Upgrade to 3.1.x](/gateway/3.1.x/upgrade/#migrate-db), and then [upgrade to 3.2.x](#migrate-db). |
| 3.0.x | Hybrid | No | [Upgrade to 3.1.x](/gateway/3.1.x/upgrade/#migrate-db), and then [upgrade to 3.2.x](#migrate-db). |
| 3.0.x | DB less | No | [Upgrade to 3.1.x](/gateway/3.1.x/upgrade/#migrate-db), and then [upgrade to 3.2.x](#migrate-db). |
| 3.1.x | Traditional | Yes | [Upgrade to 3.2.x](#migrate-db). |
| 3.1.0.x-3.1.1.2 | Hybrid | No | [Upgrade to 3.1.1.3](/gateway/3.1.x/upgrade/#migrate-db), and then [upgrade to 3.2.x](#migrate-db). |
| 3.1.1.3 | Hybrid | Yes | [Upgrade to 3.2.x](#migrate-db). |
| 3.1.x | DB less | Yes | [Upgrade to 3.2.x](#migrate-db). |

{% endif_version %}

{% if_version eq: 3.3.x %}

| **Current version** | **Topology** | **Direct upgrade possible?** | **Upgrade path** |
| ------------------- | ------------ | ---------------------------- | ---------------- |
| 2.x–2.7.x | Traditional | No | [Upgrade to 2.8.2.x](/gateway/2.8.x/install-and-run/upgrade-enterprise/) (required for blue/green deployments only), [upgrade to 3.0.x](/gateway/3.0.x/upgrade/), [upgrade to 3.1.x](/gateway/3.1.x/upgrade/#migrate-db), [upgrade to 3.2.x](#migrate-db), and then [upgrade to 3.3.x](#migrate-db). |
| 2.x–2.7.x | Hybrid | No | [Upgrade to 2.8.2.x](/gateway/2.8.x/install-and-run/upgrade-enterprise/), [upgrade to 3.0.x](/gateway/3.0.x/upgrade/), [upgrade to 3.1.x](/gateway/3.1.x/upgrade/#migrate-db), [upgrade to 3.2.x](#migrate-db), and then [upgrade to 3.3.x](#migrate-db). |
| 2.x–2.7.x | DB less | No | [Upgrade to 3.0.x](/gateway/3.0.x/upgrade/), [upgrade to 3.1.x](/gateway/3.1.x/upgrade/#migrate-db), [upgrade to 3.2.x](#migrate-db), and then [upgrade to 3.3.x](#migrate-db). |
| 2.8.x | Traditional | No | [Upgrade to 3.1.1.3](/gateway/3.1.x/upgrade/#migrate-db), [upgrade to 3.2.x](#migrate-db), and then [upgrade to 3.3.x](#migrate-db). |
| 2.8.x | Hybrid | No | [Upgrade to 3.1.1.3](/gateway/3.1.x/upgrade/#migrate-db), [upgrade to 3.2.x](#migrate-db), and then [upgrade to 3.3.x](#migrate-db). |
| 2.8.x | DB less | No | [Upgrade to 3.1.1.3](/gateway/3.1.x/upgrade/#migrate-db), [upgrade to 3.2.x](#migrate-db), and then [upgrade to 3.3.x](#migrate-db). |
| 3.0.x | Traditional | No | [Upgrade to 3.1.x](/gateway/3.1.x/upgrade/#migrate-db), [upgrade to 3.2.x](#migrate-db), and then [upgrade to 3.3.x](#migrate-db). |
| 3.0.x | Hybrid | No | [Upgrade to 3.1.x](/gateway/3.1.x/upgrade/#migrate-db), [upgrade to 3.2.x](#migrate-db), and then [upgrade to 3.3.x](#migrate-db). |
| 3.0.x | DB less | No | [Upgrade to 3.1.x](/gateway/3.1.x/upgrade/#migrate-db), [upgrade to 3.2.x](#migrate-db), and then [upgrade to 3.3.x](#migrate-db). |
| 3.1.x | Traditional | No | [Upgrade to 3.2.x](#migrate-db), and then [upgrade to 3.3.x](#migrate-db). |
| 3.1.0.x-3.1.1.2 | Hybrid | No | [Upgrade to 3.1.1.3](/gateway/3.1.x/upgrade/#migrate-db), [upgrade to 3.2.x](#migrate-db), and then [upgrade to 3.3.x](#migrate-db). |
| 3.1.1.3 | Hybrid | No | [Upgrade to 3.2.x](#migrate-db), and then [upgrade to 3.3.x](#migrate-db). |
| 3.1.x | DB less | No | [Upgrade to 3.2.x](#migrate-db), and then [upgrade to 3.3.x](#migrate-db). |
| 3.2.x | Traditional | Yes | [Upgrade to 3.3.x](#migrate-db). |
| 3.2.x | Hybrid | Yes | [Upgrade to 3.3.x](#migrate-db). |
| 3.2.x | DB less | Yes | [Upgrade to 3.3.x](#migrate-db). |

{% endif_version %}

{% if_version eq: 3.4.x %}

| **Current version** | **Topology** | **Direct upgrade possible?** | **Upgrade path** |
| ------------------- | ------------ | ---------------------------- | ---------------- |
| 2.x–2.7.x | Traditional | No | [Upgrade to 2.8.2.x](/gateway/2.8.x/install-and-run/upgrade-enterprise/) (required for blue/green deployments only), [upgrade to 3.0.x](/gateway/3.0.x/upgrade/), [upgrade to 3.1.x](/gateway/3.1.x/upgrade/#migrate-db), [upgrade to 3.2.x](#migrate-db), [upgrade to 3.3.x](#migrate-db), and then [upgrade to 3.4.x](#migrate-db). |
| 2.x–2.7.x | Hybrid | No | [Upgrade to 2.8.2.x](/gateway/2.8.x/install-and-run/upgrade-enterprise/), [upgrade to 3.0.x](/gateway/3.0.x/upgrade/), [upgrade to 3.1.x](/gateway/3.1.x/upgrade/#migrate-db), [upgrade to 3.2.x](#migrate-db), [upgrade to 3.3.x](#migrate-db), and then [upgrade to 3.4.x](#migrate-db). |
| 2.x–2.7.x | DB less | No | [Upgrade to 3.0.x](/gateway/3.0.x/upgrade/), [upgrade to 3.1.x](/gateway/3.1.x/upgrade/#migrate-db), [upgrade to 3.2.x](#migrate-db), [upgrade to 3.3.x](#migrate-db), and then [upgrade to 3.4.x](#migrate-db). |
| 2.8.x | Traditional | No | [Upgrade to 3.1.1.3](/gateway/3.1.x/upgrade/#migrate-db), [upgrade to 3.2.x](#migrate-db), [upgrade to 3.3.x](#migrate-db), and then [upgrade to 3.4.x](#migrate-db). |
| 2.8.x | Hybrid | No | [Upgrade to 3.1.1.3](/gateway/3.1.x/upgrade/#migrate-db), [upgrade to 3.2.x](#migrate-db), [upgrade to 3.3.x](#migrate-db), and then [upgrade to 3.4.x](#migrate-db). |
| 2.8.x | DB less | No | [Upgrade to 3.1.1.3](/gateway/3.1.x/upgrade/#migrate-db), [upgrade to 3.2.x](#migrate-db), [upgrade to 3.3.x](#migrate-db), and then [upgrade to 3.4.x](#migrate-db). |
| 3.0.x | Traditional | No | [Upgrade to 3.1.x](/gateway/3.1.x/upgrade/#migrate-db), [upgrade to 3.2.x](#migrate-db), [upgrade to 3.3.x](#migrate-db), and then [upgrade to 3.4.x](#migrate-db). |
| 3.0.x | Hybrid | No | [Upgrade to 3.1.x](/gateway/3.1.x/upgrade/#migrate-db), [upgrade to 3.2.x](#migrate-db), [upgrade to 3.3.x](#migrate-db), and then [upgrade to 3.4.x](#migrate-db). |
| 3.0.x | DB less | No | [Upgrade to 3.1.x](/gateway/3.1.x/upgrade/#migrate-db), [upgrade to 3.2.x](#migrate-db), [upgrade to 3.3.x](#migrate-db), and then [upgrade to 3.4.x](#migrate-db). |
| 3.1.x | Traditional | No | [Upgrade to 3.2.x](#migrate-db), [upgrade to 3.3.x](#migrate-db), and then [upgrade to 3.4.x](#migrate-db). |
| 3.1.0.x-3.1.1.2 | Hybrid | No | [Upgrade to 3.1.1.3](/gateway/3.1.x/upgrade/#migrate-db), [upgrade to 3.2.x](#migrate-db), [upgrade to 3.3.x](#migrate-db), and then [upgrade to 3.4.x](#migrate-db). |
| 3.1.1.3 | Hybrid | No | [Upgrade to 3.2.x](#migrate-db), [upgrade to 3.3.x](#migrate-db), and then [upgrade to 3.4.x](#migrate-db). |
| 3.1.x | DB less | No | [Upgrade to 3.2.x](#migrate-db), [upgrade to 3.3.x](#migrate-db), and then [upgrade to 3.4.x](#migrate-db). |
| 3.2.x | Traditional | No | [Upgrade to 3.3.x](#migrate-db), and then [upgrade to 3.4.x](#migrate-db). |
| 3.2.x | Hybrid | No | [Upgrade to 3.3.x](#migrate-db), and then [upgrade to 3.4.x](#migrate-db). |
| 3.2.x | DB less | No | [Upgrade to 3.3.x](#migrate-db), and then [upgrade to 3.4.x](#migrate-db). |
| 3.3.x | Traditional | Yes | [Upgrade to 3.4.x](#migrate-db). |
| 3.3.x | Hybrid | Yes | [Upgrade to 3.4.x](#migrate-db). |
| 3.3.x | DB less | Yes | [Upgrade to 3.4.x](#migrate-db). |

{% endif_version %}

{% if_version eq: 3.5.x %}

| **Current version** | **Topology** | **Direct upgrade possible?** | **Upgrade path** |
| ------------------- | ------------ | ---------------------------- | ---------------- |
| 2.x–2.7.x | Traditional | No | [Upgrade to 2.8.2.x](/gateway/2.8.x/install-and-run/upgrade-enterprise/) (required for blue/green deployments only), upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 2.x–2.7.x | Hybrid | No | [Upgrade to 2.8.2.x](/gateway/2.8.x/install-and-run/upgrade-enterprise/), upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 2.x–2.7.x | DB less | No | [Upgrade to 3.0.x](/gateway/3.0.x/upgrade/), [upgrade to 3.1.x](/gateway/3.1.x/upgrade/#migrate-db), upgrade to 3.2.x, upgrade to 3.3.x upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 2.8.x | Hybrid | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 2.8.x | DB less | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.0.x | Traditional | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.0.x | Hybrid | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.0.x | DB less | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.1.x | Traditional | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.1.0.x-3.1.1.2 | Hybrid | No | [Upgrade to 3.1.1.3](/gateway/3.1.x/upgrade/#migrate-db), upgrade to 3.2.x, upgrade to 3.3.x, upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.1.1.3 | Hybrid | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.1.x | DB less | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.2.x | Traditional | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.2.x | Hybrid | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.2.x | DB less | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.3.x | Traditional | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.3.x | Hybrid | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.3.x | DB less | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.4.x | Traditional | Yes | Upgrade to 3.5.x. |
| 3.4.x | Hybrid | Yes | Upgrade to 3.5.x. |
| 3.4.x | DB less | Yes | Upgrade to 3.5.x. |

{% endif_version %}

### Upgrades from 3.1.0.0 or 3.1.1.1

There is a special case if you deployed {{site.base_gateway}} in hybrid mode and the version you are using is 3.1.0.0 or 3.1.1.1.
Kong removed the legacy WebSocket protocol, added a new WebSocket protocol between CP and DP in 3.1.0.0, 
and added back the legacy one in 3.1.1.2. 
So, upgrade to 3.1.1.2 first before moving forward to later versions. 

Additionally, the new WebSocket protocol has been completely removed since 3.2.0.0.
See the following table for the version breakdown:

{{site.base_gateway}} Version | Legacy WebSocket (JSON) | New WebSocket (RPC)
---------------------|-------------------------|--------------------
3.0.0.0 | Y | Y
3.1.0.0 and 3.1.1.1 | N | Y
3.1.1.2 | Y | Y
3.2.0.0 | Y | N

## Preparation: Choose a backup strategy

The following instructions lay out how to back up your configuration for each supported deployment type. 
This is an important step prior to migrating. 
Each supported deployment mode has different instructions for backup.

The `kong migrations` commands in this guide are not reversible. We recommend backing up data before any migration. 

* **Database backup** (_Traditional mode and control planes in hybrid mode_): 
PostgreSQL has native exporting and importing tools that are reliable and performant, and that ensure 
consistency when backing up or restoring data.
* **Declarative backup** (_DB-less mode and data planes in hybrid mode_): In DB-less mode, configuration 
is managed declaratively using a tool called decK. decK allows you to import and export configuration 
using YAML or JSON files. 

Review the [Backup and Restore](/gateway/{{page.kong_version}}/upgrade/backup-and-restore/) guide to 
prepare backups of your configuration.

## Preparation: Choose an upgrade strategy based on deployment mode

Though you could define your own upgrade procedures, we recommend using one of the nominated strategies in this section. 
Any custom upgrade requirements may require a well-tailored upgrade strategy. 
For example, if you only want a small group of customer objects to be directed to the new cluster Y, use the 
Canary plugin and a load balancer that supports traffic interception.

Whichever upgrade strategy you choose, you should account for management downtime for {{site.base_gateway}}, as 
Admin API operations and database updates are not allowed during the upgrade process.

Based on your deployment type, we recommend one of the following upgrade strategies.
Carefully read the descriptions for each option to choose the upgrade strategy that works best for your situation.

* Traditional or hybrid mode control planes:
    * Dual-cluster upgrade
    * In-place upgrade
    * Blue-green upgrade (derived from an in-place upgrade)

* DB-less mode or hybrid mode data planes:
    * Rolling upgrade

Here's a flow chart the breaks down how the decision process works:

![Choosing a strategy based on the deployment mode](/assets/images/products/gateway/upgrade/choose-your-deployment.png)
> _Figure 1: Choosing an upgrade strategy based on deployment type_

See the following sections for breakdowns and links to each upgrade strategy guide.

### Traditional mode

A traditional mode deployment is when all {{site.base_gateway}} components are running in one environment, 
and there is no control plane/data plane separation.

You have two options when upgrading {{site.base_gateway}} in traditional mode:
* [Dual-cluster upgrade](/gateway/{{page.kong_version}}/upgrade/dual-cluster-upgrade): 
A new {{site.base_gateway}} cluster of version Y is deployed alongside the current version X, so that two 
clusters serve requests concurrently during the upgrade process.
* [In-place upgrade](/gateway/{{page.kong_version}}/upgrade/in-place-upgrade): An in-place upgrade reuses 
the existing database and has to shut down cluster X first, then configure the new cluster Y to point 
to the database.

We recommend using a dual-cluster upgrade if you have the resources to run another cluster concurrently.
Use the in-place method only if resources are limited, as it will cause business downtime.

### DB-less mode

In DB-less mode, each independent {{site.base_gateway}} node loads a copy of declarative {{site.base_gateway}} 
configuration data into memory without persistent database storage, so failure of some nodes doesn't spread to other nodes.

Deployments in this mode should use the [Rolling Upgrade](/gateway/{{page.kong_version}}/upgrade/rolling-upgrade/) strategy. 
You could parse the validity of the declarative YAML contents with version Y, using the `deck validate` command.

### Hybrid mode

Hybrid mode comprises of one or more control plane (CP) nodes, and one or more data plane (DP) nodes. 
CP nodes use a database to store Kong configuration data, whereas DP nodes don't, since they get all of the needed information from the CP.
The recommended upgrade process is a combination of different upgrade strategies for each type of node, CP or DP.

The major challenge with a hybrid mode upgrade is the communication between the CP and DP. 
As hybrid mode requires the minor version of the CP to be no less than that of the DP, you must upgrade CP nodes before DP nodes. 
The upgrade must be carried out in two phases:

1. First, upgrade the CP according to the recommendations in the section [Traditional Mode](#traditional-mode), 
while DP nodes are still serving API requests.
2. Next, upgrade DP nodes using the recommendations from the section [DB-less Mode](#db-less-mode). 
Point the new DP nodes to the new CP to avoid version conflicts.

The role decoupling feature between CP and DP enables DP nodes to serve API requests while upgrading CP. 
With this method, there is no business downtime.

Custom plugins (either your own plugins or third-party plugins that are not shipped with {{site.base_gateway}})
need to be installed on both the control plane and the data planes in hybrid mode. 
Install the plugins on the control plane first, and then the data planes.

See the following sections for a breakdown of the options for hybrid mode deployments.

#### Control planes

CP nodes must be upgraded before DP nodes. CP nodes serve an admin-only role and require database support. 
So, you can select from the same upgrade strategies nominated for traditional mode (dual-cluster or in-place), 
as described in figure 2 and figure 3 respectively.

Using the dual-cluster strategy to upgrade a CP:
![Dual-cluster hybrid upgrade workflow](/assets/images/products/gateway/upgrade/dual-cluster-hybrid-upgrade.png)
> _Figure 2: Upgrading the CP using the dual-cluster strategy. The diagram shows the new CP Y, deployed alongside the current CP X, while current DP nodes X are still serving API requests._

Using an in-place strategy to upgrade a CP:
![In-place hybrid upgrade workflow](/assets/images/products/gateway/upgrade/in-place-hybrid-upgrade.png)
> _Figure 3: Upgrading the CP using the in-place strategy. The diagram shows how the current CP X is replaced with a new CP Y. The upgrade is mostly the same as that in figure 2, but the database is reused by the new CP Y, and current CP X is shut down._

From the two figures, you can see that DP nodes X remain connected to the current CP node X, or alternatively switch to the new CP node Y. 

{{site.base_gateway}} guarantees that new minor versions of CPs are compatible with old minor versions of the DP, 
so you can temporarily point DP nodes X to the new CP node Y.
This lets you pause the upgrade process if needed, or conduct it over a longer period of time. 

After the CP upgrade, cluster X can be decommissioned. You can delay this task to the very end of the DP upgrade.

{:.important}
> We do not recommend running a combination of new versions of CP nodes and old versions of DP nodes in a long-term production deployment. 
This setup is meant to be temporary, to be used only during the upgrade process.

#### Data planes

Once the CP nodes are upgraded, you can move on to upgrade the DP nodes. 
The only supported upgrade strategy for DP upgrades is the rolling upgrade.

The following diagrams, figure 4 and 5, are the counterparts of figure 2 and 3 respectively. 

Using the dual-cluster strategy with a rolling upgrade workflow:
![Dual-cluster and rolling upgrade workflow](/assets/images/products/gateway/upgrade/dual-cluster-rolling-hybrid-upgrade.png)
> _Figure 4: Upgrading using the dual-cluster and rolling strategies. The diagram shows the new CP Y, deployed alongside with current CP X, while current DP nodes X are still serving API requests._
_In the image, the background color of the current CP X or current DB is white instead of blue, signaling that the CP part was already upgraded and might have been decommissioned._

Using the in-place cluster strategy with a rolling upgrade workflow:
![In-place and rolling upgrade workflow](/assets/images/products/gateway/upgrade/in-place-rolling-hybrid-upgrade.png)
> _Figure 5: Upgrade by in-place strategy and rolling strategy_

## Prepation: Review breaking changes

Review the [breaking changes](/gateway/{{page.kong_version}}/breaking-changes/) for the release or releases that you are upgrading to. Make any preparations or adjustments as directed in the breaking changes.

## Preparation: Upgrade considerations

There are some universal factors that may also influence the upgrade, regardless of your deployment mode.

Selecting a strategy for the target deployment mode doesn't guarantee that you can start the upgrade immediately.
You must also account for the following factors:

* During the upgrade process, no changes can be made to the configuration database. 
Until the upgrade is completed:
  * Don't write to the database via the Admin API.
  * Don't operate on the database directly.
  * Don't update configuration through Kong Manager, decK, or the `kong config` CLI.
* Review the compatibility between the new version Y and your existing platform. 
Factors may include, but are not limited to:
  * [OS version](/gateway/{{page.kong_version}}/support/#supported-versions)
  * [Database version](/gateway/{{page.kong_version}}/support/third-party/)
  * [Kubernetes version and Helm prerequisites](/kubernetes-ingress-controller/latest/support-policy/)
  * [Dependency versions](/gateway/{{page.kong_version}}/support/third-party/)
  * [Hardware resources](/gateway/{{page.kong_version}}/production/sizing-guidelines/)
* Carefully review all [changelogs](/gateway/changelog/) starting from your current version X,
 all the way up to the target version Y. 
  * Look for any potential conflicts, especially for schema changes and functionality removal.
  * When configuring the new cluster, update `kong.conf` directly or via environment variables based on the changelog.

    Breaking changes in `kong.conf` in a minor version upgrade are infrequent, but do happen.

    For example, the parameter `pg_ssl_version` defaults to `tlsv1` in 2.8.2.4, but in 3.2.2.1, `tlsv1` is not a valid argument anymore.
    If you were depending on this setting, you would have to adjust your environment to fit one of the new options.

* If you have custom plugins, review the code against changelog and test the custom plugin using the new version Y.
* If you have modified any Nginx templates like `nginx-kong.conf` and `nginx-kong-stream.conf`, also make those changes to the templates for the new version Y. 
Refer to [Nginx Directives](/gateway/{{page.kong_version}}/reference/nginx-directives/) for a detailed customization guide.
* If you're using {{site.ee_product_name}}, make sure to [apply the enterprise license] to the new Gateway cluster.
* Always remember take a backup.
{% if_version %}
* Cassandra DB support has been removed from {{site.base_gateway}} with 3.4.0.0.
Migrate to PostgreSQL according to the [Cassandra to PostgreSQL Migration Guidelines](/gateway/{{page.kong_version}}/migrate-cassandra-to-postgres/).
{% endif_version %}

## Perform the upgrade

Once you have reviewed everything and chosen a strategy, proceed to upgrade {{site.base_gateway}} 
using your chosen strategy:

* [Dual-cluster upgrade](/gateway/{{page.kong_version}}/upgrade/dual-cluster/)
* [In-place upgrade](/gateway/{{page.kong_version}}/upgrade/in-place/)
* [Blue-green upgrade](/gateway/{{page.kong_version}}/upgrade/blue-green/)
* [Rolling upgrade](/gateway/{{page.kong_version}}/upgrade/rolling-upgrade/)
