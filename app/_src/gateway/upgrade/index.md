---
title: Upgrading Kong Gateway
content_type: reference
purpose: This guide walks you through upgrade paths for {{site.base_gateway}} and helps you prepare for an upgrade.
---

Using this guide, prepare for a {{site.base_gateway}} upgrade and determine which {{site.base_gateway}} upgrade paths to use.

This guide walks you through four available upgrade strategies and recommends the best strategy for each {{site.base_gateway}} deployment mode. 
Additionally, it lists some fundamental factors that play important roles in the upgrade process, and explains how to back up and recover data.

This guide uses the following terms in the context of {{site.base_gateway}}:
* **Upgrade**: The overall process of switching from an older to a newer version of {{site.base_gateway}}. 
* **Migration**: The migration of your data store data into a new environment. 
For example, the process of moving 2.8.x data from an old PostgreSQL instance to a new one for 3.4.x is referred to as database migration.

{:.note}
> **Note**: If you are interested in upgrading between the {{site.ee_product_name}} 2.8.x and 3.4.x long-term 
support (LTS) versions, see the [LTS upgrade guide](/gateway/{{page.release}}/upgrade/lts-upgrade/).

## Upgrade overview

A {{site.base_gateway}} upgrade requires two phases of work: preparing for the upgrade and applying the upgrade.

**Preparation phase**

1. Review version compatibility between your platform version and the version of {{site.kong_gateway}} that you are upgrading to:
    * [OS version](/gateway/{{page.release}}/support-policy/#supported-versions)
    * [Kubernetes version and Helm prerequisites](/kubernetes-ingress-controller/latest/support-policy/)
    {% if_version gte:3.2.x -%}
    * [Database version](/gateway/{{page.release}}/support/third-party/)
    * [Dependency versions](/gateway/{{page.release}}/support/third-party/)
    {% endif_version %}
1. Determine your [upgrade path](#preparation-review-upgrade-paths) based on the release you're starting from and the release you're upgrading to.
1. [Back up](#preparation-choose-a-backup-strategy) your database or your declarative configuration files.
1. Choose the right [strategy for upgrading](#preparation-choose-an-upgrade-strategy-based-on-deployment-mode) based on your deployment topology.
1. Review the [breaking changes](#preparation-review-breaking-changes-and-changelogs) for the version you're upgrading to.
1. Review any remaining [upgrade considerations](#preparation-upgrade-considerations).
1. Test migration in a pre-production environment.

**Performing the upgrade**

The actual execution of the upgrade is dependent on the type of deployment you have with {{site.base_gateway}}. 
In this part of the upgrade journey, you will use the strategy you determined during the preparation phase.

1. [Execute your chosen upgrade strategy on dev](#perform-the-upgrade).
2. Move from dev to prod.
3. Smoke test.
4. Wrap up the upgrade or roll back and try again.

Now, let's move on to preparation, starting with determining your upgrade path.

## Preparation: Review upgrade paths

{{site.base_gateway}} adheres to a structured approach to versioning its products, which makes a
distinction between major, minor, and patch versions.

The upgrade from 2.x to 3.x is a **major** upgrade.
The lowest version that {{site.base_gateway}} 3.0.x supports migrating from is 2.1.x.

{{site.base_gateway}} does not support directly upgrading from 1.x to 3.x.
If you are running 1.x, upgrade to 2.1.0 first at a minimum, then upgrade to 3.0.x from there.

While you can upgrade directly to the latest version, be aware of any
[breaking changes](/gateway/{{page.release}}/breaking-changes/)
between the 2.x and 3.x series (both this version and prior versions) and in the
open-source (OSS) and Enterprise Gateway [changelogs](/gateway/changelog/). Since {{site.base_gateway}}
is built on an open-source foundation, any breaking changes in OSS affect all {{site.base_gateway}} packages.

An upgrade path is subject to a wide spectrum of conditions, and there is not a one-size-fits-all way applicable to all users, depending on the deployment modes, custom plugins, technical capabilities, hardware capacities, SLA, and so on. You should discuss the upgrade process thoroughly and carefully with our engineers before you take any action.

We encourage you to stay updated with {{site.base_gateway}} releases, as that helps maintain a smooth upgrade path. 
The smaller the version gap is, the less complex the upgrade process becomes.

### Guaranteed upgrade paths

By default, {{site.base_gateway}} has migration tests between adjacent versions and hence the following upgrade paths are guaranteed officially:

1. Between patch releases of the same major and minor version.
2. Between adjacent minor releases of the same major version.
3. Between LTS versions.

    {{site.base_gateway}} maintains LTS versions and guarantees upgrades between adjacent LTS versions.
    The current LTS in the 2.x series is 2.8, and the current LTS in the 3.x series is 3.4.
    If you want to upgrade between the 2.8 and 3.4 LTS versions, 
    see the [LTS Upgrade guide](/gateway/{{page.release}}/upgrade/lts-upgrade/).

The following table outlines various upgrade path scenarios to {{page.release}} depending on the {{site.base_gateway}} version you are currently using:

{% if_version lte: 3.1.x %}

| **Current version** | **Topology** | **Direct upgrade possible?** | **Upgrade path** |
| ------------------- | ------------ | ---------------------------- | ---------------- |
| 2.x–2.7.x | Traditional | No | Upgrade to 2.8.2.x (required for blue/green deployments only), then upgrade to 3.0.x, and then upgrade to 3.1.x. |
| 2.x–2.7.x | Hybrid | No | Upgrade to 2.8.2.x, then upgrade to 3.0.x, and then upgrade to 3.1.x. |
| 2.x–2.7.x | DB-less | No | upgrade to 3.0.x, and then upgrade to 3.1.x. |
| 2.8.x | Traditional | No | upgrade to 3.0.x, and then upgrade to 3.1.x. |
| 2.8.x | Hybrid | No | upgrade to 3.0.x, and then upgrade to 3.1.1.3. |
| 2.8.x | DB-less | No | upgrade to 3.0.x, and then upgrade to 3.1.x. |
| 3.0.x | Traditional | Yes | upgrade to 3.1.x. |
| 3.0.x | Hybrid | Yes | upgrade to 3.1.x. |
| 3.0.x | DB-less | Yes | upgrade to 3.1.x. |

{% endif_version %}

{% if_version eq: 3.2.x %}

| **Current version** | **Topology** | **Direct upgrade possible?** | **Upgrade path** |
| ------------------- | ------------ | ---------------------------- | ---------------- |
| 2.x–2.7.x | Traditional | No | Upgrade to 2.8.2.x (required for blue/green deployments only), upgrade to 3.0.x, upgrade to 3.1.x, and then upgrade to 3.2.x. |
| 2.x–2.7.x | Hybrid | No | Upgrade to 2.8.2.x, upgrade to 3.0.x, upgrade to 3.1.x, and then upgrade to 3.2.x. |
| 2.x–2.7.x | DB-less | No | upgrade to 3.0.x, upgrade to 3.1.x, and then upgrade to 3.2.x. |
| 2.8.x | Traditional | No | Upgrade to 3.1.1.3, and then upgrade to 3.2.x. |
| 2.8.x | Hybrid | No | Upgrade to 3.1.1.3, and then upgrade to 3.2.x. |
| 2.8.x | DB-less | No | Upgrade to 3.1.1.3, and then upgrade to 3.2.x. |
| 3.0.x | Traditional | No | Upgrade to 3.1.x, and then upgrade to 3.2.x. |
| 3.0.x | Hybrid | No | Upgrade to 3.1.x, and then upgrade to 3.2.x. |
| 3.0.x | DB-less | No | Upgrade to 3.1.x, and then upgrade to 3.2.x. |
| 3.1.x | Traditional | Yes | upgrade to 3.2.x. |
| 3.1.0.x-3.1.1.2 | Hybrid | No | Upgrade to 3.1.1.3, and then upgrade to 3.2.x. |
| 3.1.1.3 | Hybrid | Yes | upgrade to 3.2.x. |
| 3.1.x | DB-less | Yes | upgrade to 3.2.x. |

{% endif_version %}

{% if_version eq: 3.3.x %}

| **Current version** | **Topology** | **Direct upgrade possible?** | **Upgrade path** |
| ------------------- | ------------ | ---------------------------- | ---------------- |
| 2.x–2.7.x | Traditional | No | Upgrade to 2.8.2.x (required for blue/green deployments only), upgrade to 3.0.x, upgrade to 3.1.x, upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 2.x–2.7.x | Hybrid | No | Upgrade to 2.8.2.x, upgrade to 3.0.x, upgrade to 3.1.x, upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 2.x–2.7.x | DB-less | No | upgrade to 3.0.x, upgrade to 3.1.x, upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 2.8.x | Traditional | No | Upgrade to 3.1.1.3, upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 2.8.x | Hybrid | No | Upgrade to 3.1.1.3, upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 2.8.x | DB-less | No | Upgrade to 3.1.1.3, upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 3.0.x | Traditional | No | Upgrade to 3.1.x, upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 3.0.x | Hybrid | No | Upgrade to 3.1.x, upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 3.0.x | DB-less | No | Upgrade to 3.1.x, upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 3.1.x | Traditional | No | upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 3.1.0.x-3.1.1.2 | Hybrid | No | Upgrade to 3.1.1.3, upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 3.1.1.3 | Hybrid | No | upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 3.1.x | DB-less | No | upgrade to 3.2.x, and then upgrade to 3.3.x. |
| 3.2.x | Traditional | Yes | upgrade to 3.3.x. |
| 3.2.x | Hybrid | Yes | upgrade to 3.3.x. |
| 3.2.x | DB-less | Yes | upgrade to 3.3.x. |

{% endif_version %}

{% if_version eq: 3.4.x %}

| **Current version** | **Topology** | **Direct upgrade possible?** | **Upgrade path** |
| ------------------- | ------------ | ---------------------------- | ---------------- |
| 2.x–2.7.x | Traditional | No | Upgrade to 2.8.2.x (required for blue/green deployments only), upgrade to 3.0.x, upgrade to 3.1.x, upgrade to 3.2.x, upgrade to 3.3.x, and then Upgrade to 3.4.x. |
| 2.x–2.7.x | Hybrid | No | Upgrade to 2.8.2.x, upgrade to 3.0.x, upgrade to 3.1.x, upgrade to 3.2.x, upgrade to 3.3.x, and then Upgrade to 3.4.x. |
| 2.x–2.7.x | DB-less | No | upgrade to 3.0.x, upgrade to 3.1.x, upgrade to 3.2.x, upgrade to 3.3.x, and then Upgrade to 3.4.x. |
| 2.8.x | Traditional | No | Upgrade to 3.1.1.3, upgrade to 3.2.x, upgrade to 3.3.x, and then Upgrade to 3.4.x. |
| 2.8.x | Hybrid | No | Upgrade to 3.1.1.3, upgrade to 3.2.x, upgrade to 3.3.x, and then Upgrade to 3.4.x. |
| 2.8.x | DB-less | No | Upgrade to 3.1.1.3, upgrade to 3.2.x, upgrade to 3.3.x, and then Upgrade to 3.4.x. |
| 3.0.x | Traditional | No | Upgrade to 3.1.x, upgrade to 3.2.x, upgrade to 3.3.x, and then Upgrade to 3.4.x. |
| 3.0.x | Hybrid | No | Upgrade to 3.1.x, upgrade to 3.2.x, upgrade to 3.3.x, and then Upgrade to 3.4.x. |
| 3.0.x | DB-less | No | Upgrade to 3.1.x, upgrade to 3.2.x, upgrade to 3.3.x, and then Upgrade to 3.4.x. |
| 3.1.x | Traditional | No | upgrade to 3.2.x, upgrade to 3.3.x, and then Upgrade to 3.4.x. |
| 3.1.0.x-3.1.1.2 | Hybrid | No | Upgrade to 3.1.1.3, upgrade to 3.2.x, upgrade to 3.3.x, and then Upgrade to 3.4.x. |
| 3.1.1.3 | Hybrid | No | upgrade to 3.2.x, upgrade to 3.3.x, and then Upgrade to 3.4.x. |
| 3.1.x | DB-less | No | upgrade to 3.2.x, upgrade to 3.3.x, and then Upgrade to 3.4.x. |
| 3.2.x | Traditional | No | upgrade to 3.3.x, and then Upgrade to 3.4.x. |
| 3.2.x | Hybrid | No | upgrade to 3.3.x, and then Upgrade to 3.4.x. |
| 3.2.x | DB-less | No | upgrade to 3.3.x, and then Upgrade to 3.4.x. |
| 3.3.x | Traditional | Yes | Upgrade to 3.4.x. |
| 3.3.x | Hybrid | Yes | Upgrade to 3.4.x. |
| 3.3.x | DB-less | Yes | Upgrade to 3.4.x. |

{% endif_version %}

{% if_version eq: 3.5.x %}

| **Current version** | **Topology** | **Direct upgrade possible?** | **Upgrade path** |
| ------------------- | ------------ | ---------------------------- | ---------------- |
| 2.x–2.7.x | Traditional | No | Upgrade to 2.8.2.x (required for blue/green deployments only), upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 2.x–2.7.x | Hybrid | No | Upgrade to 2.8.2.x, upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 2.x–2.7.x | DB-less | No | Upgrade to 3.0.x, upgrade to 3.1.x, upgrade to 3.2.x, upgrade to 3.3.x upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 2.8.x | Hybrid | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 2.8.x | DB-less | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.0.x | Traditional | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.0.x | Hybrid | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.0.x | DB-less | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.1.x | Traditional | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.1.0.x-3.1.1.2 | Hybrid | No | Upgrade to 3.1.1.3, upgrade to 3.2.x, upgrade to 3.3.x, upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.1.1.3 | Hybrid | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.1.x | DB-less | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.2.x | Traditional | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.2.x | Hybrid | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.2.x | DB-less | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.3.x | Traditional | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.3.x | Hybrid | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.3.x | DB-less | No | Upgrade to 3.4.x, and then upgrade to 3.5.x. |
| 3.4.x | Traditional | Yes | Upgrade to 3.5.x. |
| 3.4.x | Hybrid | Yes | Upgrade to 3.5.x. |
| 3.4.x | DB-less | Yes | Upgrade to 3.5.x. |

{% endif_version %}

{% if_version eq: 3.6.x %}
| **Current version** | **Topology** | **Direct upgrade possible?** | **Upgrade path** |
| ------------------- | ------------ | ---------------------------- | ---------------- |
| 2.x–2.7.x | Traditional | No | Upgrade to 2.8.2.x (required for blue/green deployments only), upgrade to 3.4.x, upgrade to 3.5.x, and then upgrade to 3.6.x. |
| 2.x–2.7.x | Hybrid | No | Upgrade to 2.8.2.x, upgrade to 3.4.x, upgrade to 3.5.x, and then upgrade to 3.6.x. |
| 2.x–2.7.x | DB-less | No | Upgrade to 3.0.x, upgrade to 3.1.x, upgrade to 3.2.x, upgrade to 3.3.x upgrade to 3.4.x, upgrade to 3.5.x, and then upgrade to 3.6.x. |
| 2.8.x | Hybrid | No | Upgrade to 3.4.x, upgrade to 3.5.x, and then upgrade to 3.6.x. |
| 2.8.x | DB-less | No | Upgrade to 3.4.x, upgrade to 3.5.x, and then upgrade to 3.6.x. |
| 3.0.x | Traditional | No | Upgrade to 3.4.x, upgrade to 3.5.x, and then upgrade to 3.6.x. |
| 3.0.x | Hybrid | No | Upgrade to 3.4.x, upgrade to 3.5.x, and then upgrade to 3.6.x. |
| 3.0.x | DB-less | No | Upgrade to 3.4.x, upgrade to 3.5.x, and then upgrade to 3.6.x. |
| 3.1.x | Traditional | No | Upgrade to 3.4.x, upgrade to 3.5.x, and then upgrade to 3.6.x. |
| 3.1.0.x-3.1.1.2 | Hybrid | No | Upgrade to 3.1.1.3, upgrade to 3.2.x, upgrade to 3.3.x, upgrade to 3.4.x, upgrade to 3.5.x, and then upgrade to 3.6.x. |
| 3.1.1.3 | Hybrid | No | Upgrade to 3.4.x, upgrade to 3.5.x, and then upgrade to 3.6.x. |
| 3.1.x | DB-less | No | Upgrade to 3.4.x, upgrade to 3.5.x, and then upgrade to 3.6.x. |
| 3.2.x | Traditional | No | Upgrade to 3.4.x, upgrade to 3.5.x, and then upgrade to 3.6.x. |
| 3.2.x | Hybrid | No | Upgrade to 3.4.x, upgrade to 3.5.x, and then upgrade to 3.6.x. |
| 3.2.x | DB-less | No | Upgrade to 3.4.x, upgrade to 3.5.x, and then upgrade to 3.6.x. |
| 3.3.x | Traditional | No | Upgrade to 3.4.x, upgrade to 3.5.x, and then upgrade to 3.6.x. |
| 3.3.x | Hybrid | No | Upgrade to 3.4.x, upgrade to 3.5.x, and then upgrade to 3.6.x. |
| 3.3.x | DB-less | No | Upgrade to 3.4.x, upgrade to 3.5.x, and then upgrade to 3.6.x. |
| 3.4.x | Traditional | No | Upgrade to 3.5.x and then upgrade to 3.6.x. |
| 3.4.x | Hybrid | No | Upgrade to 3.5.x and then upgrade to 3.6.x. |
| 3.4.x | DB-less | No | Upgrade to 3.5.x and then upgrade to 3.6.x. |
| 3.5.x | Traditional | Yes | Upgrade to 3.6.x. |
| 3.5.x | Hybrid | Yes | Upgrade to 3.6.x. |
| 3.5.x | DB-less | Yes | Upgrade to 3.6.x. |

{% endif_version %}


## Preparation: Choose a backup strategy

{% include_cached /md/gateway/upgrade-backup.md release=page.release %}

## Preparation: Choose an upgrade strategy based on deployment mode

Though you could define your own upgrade procedures, we recommend using one of the nominated strategies in this section. 
Any custom upgrade requirements may require a well-tailored upgrade strategy. 
For example, if you only want a small group of customer objects to be directed to the new version, use the 
Canary plugin and a load balancer that supports traffic interception.

Whichever upgrade strategy you choose, you should account for management downtime for {{site.base_gateway}}, as 
Admin API operations and database updates are not allowed during the upgrade process.

Based on your deployment type, we recommend one of the following upgrade strategies.
Carefully read the descriptions for each option to choose the upgrade strategy that works best for your situation.

* [Traditional](#traditional-mode) or [hybrid mode control planes](#control-planes):
    * [Dual-cluster upgrade](/gateway/{{page.release}}/upgrade/dual-cluster/)
    * [In-place upgrade](/gateway/{{page.release}}/upgrade/in-place/)
    * [Blue-green upgrade](/gateway/{{page.release}}/upgrade/blue-green/) (not recommended)

* [DB-less mode](#db-less-mode) or [hybrid mode data planes](#data-planes):
    * [Rolling upgrade](/gateway/{{page.release}}/upgrade/rolling-upgrade/)

Here's a flowchart that breaks down how the decision process works:

{% include_cached md/gateway/upgrade-flow.md %}

See the following sections for breakdowns and links to each upgrade strategy guide.

### Traditional mode

{% include_cached /md/gateway/traditional-upgrade.md %}

{:.important}
> **Important**: While the [blue-green upgrade strategy](/gateway/{{page.release}}/upgrade/blue-green/) is an option,
we do not recommend it. Support from Kong for upgrades using this strategy is limited. 
It is nearly impossible to fully cover all migration tests, because we have to cover all 
combinations, given the number of {{site.base_gateway}} versions, upgrade strategies, features adopted, and deployment modes. 
If you must use this strategy, only use it to upgrade between patch versions.

### DB-less mode

{% include_cached /md/gateway/db-less-upgrade.md release=page.release %}

### Hybrid mode

{% include_cached /md/gateway/hybrid-upgrade.md release=page.release %}

#### Upgrades from 3.1.0.0 or 3.1.1.1

There is a special case if you deployed {{site.base_gateway}} in hybrid mode and the version you are using is 3.1.0.0 or 3.1.1.1.
Kong removed the legacy WebSocket protocol between the CP and DP, replaced it with a new WebSocket protocol in 3.1.0.0,
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

## Preparation: Review breaking changes and changelogs

Review the [breaking changes](/gateway/{{page.release}}/breaking-changes/) and [changelogs](/gateway/changelog/) for the release or 
releases that you are upgrading to. 
Make any preparations or adjustments as directed in the breaking changes.

## Preparation: Upgrade considerations

There are some universal factors that may also influence the upgrade, regardless of your deployment mode.

Selecting a strategy for the target deployment mode doesn't guarantee that you can start the upgrade immediately.
You must also account for the following factors:

* During the upgrade process, no changes can be made to the database. 
Until the upgrade is completed:
  * Don't write to the database via the [Admin API](/gateway/{{page.release}}/admin-api).
  * Don't operate on the database directly.
  * Don't update configuration through [Kong Manager](/gateway/{{page.release}}/kong-manager/), 
  [decK](/deck/), or the [kong config CLI](/gateway/{{page.release}}/reference/cli/#kong-config).
* Review the compatibility between the new version Y and your existing platform. 
Factors may include, but are not limited to:
  * [OS version](/gateway/{{page.release}}/support-policy/#supported-versions)
  * [Kubernetes version and Helm prerequisites](/kubernetes-ingress-controller/latest/support-policy/)
  * [Hardware resources](/gateway/{{page.release}}/production/sizing-guidelines/)
  {% if_version gte:3.2.x -%}
  * [Database version](/gateway/{{page.release}}/support/third-party/)
  * [Dependency versions](/gateway/{{page.release}}/support/third-party/)
  {% endif_version %}
* Carefully review all [changelogs](/gateway/changelog/) starting from your current version X,
 all the way up to the target version Y. 
  * Look for any potential conflicts, especially for schema changes and functionality removal.
  * When configuring the new cluster, update `kong.conf` directly or via environment variables based on the changelog.

    Breaking changes in `kong.conf` in a minor version upgrade are infrequent, but do happen.

    For example, the parameter `pg_ssl_version` defaults to `tlsv1` in 2.8.2.4, but in 3.2.2.1, `tlsv1` is not a valid argument anymore.
    If you were depending on this setting, you would have to adjust your environment to fit one of the new options.

* If you have custom plugins, review the code against changelog and test the custom plugin using the new version Y.
* If you have modified any Nginx templates like `nginx-kong.conf` and `nginx-kong-stream.conf`, also make those changes to the templates for the new version Y. 
Refer to [Nginx Directives](/gateway/{{page.release}}/reference/nginx-directives/) for a detailed customization guide.
* If you're using {{site.ee_product_name}}, make sure to [apply the enterprise license](/gateway/{{page.release}}/licenses/deploy/) to the new Gateway cluster.
* Always remember to take a [backup](/gateway/{{page.release}}/upgrade/backup-and-restore/).
{% if_version gte:3.4.x -%}
* Cassandra DB support has been removed from {{site.base_gateway}} with 3.4.0.0.
Migrate to PostgreSQL according to the [Cassandra to PostgreSQL Migration Guidelines](/gateway/{{page.release}}/migrate-cassandra-to-postgres/).
{% endif_version %}

## Perform the upgrade

Once you have reviewed everything and chosen a strategy, proceed to upgrade {{site.base_gateway}} 
using your chosen strategy:

* [Dual-cluster upgrade](/gateway/{{page.release}}/upgrade/dual-cluster/)
* [In-place upgrade](/gateway/{{page.release}}/upgrade/in-place/)
* [Blue-green upgrade](/gateway/{{page.release}}/upgrade/blue-green/)
* [Rolling upgrade](/gateway/{{page.release}}/upgrade/rolling-upgrade/)
