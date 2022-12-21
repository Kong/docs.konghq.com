---
title: Upgrade Kong Gateway 3.1.x
---

Upgrade to major, minor, and patch {{site.base_gateway}}
releases using the `kong migrations` commands.

You can also use the commands to migrate all {{site.base_gateway}} open-source entities
to {{site.base_gateway}} (Enterprise). See
[Migrating from {{site.ce_product_name}} to {{site.base_gateway}}](/gateway/{{page.kong_version}}/migrate-ce-to-ke/).

If you experience any issues when running migrations, contact
[Kong Support](https://support.konghq.com/support/s/) for assistance.

## Upgrade path for {{site.base_gateway}} releases

Kong adheres to [semantic versioning](https://semver.org/), which makes a
distinction between major, minor, and patch versions.

The upgrade to {{page.kong_version}} is a **minor** upgrade.
The lowest version that Kong {{page.kong_version}} supports migrating from is 3.0.x.

{:.important}
> **Important**: Blue-green migration in traditional mode for versions below 2.8.2 to 3.0.x is not supported.
The 2.8.2 release includes blue-green migration support. If you want
to perform migrations for traditional mode with no downtime,
upgrade to 2.8.2, [then migrate to {{page.kong_version}}](#migrate-db).

While you can upgrade directly to the latest version, be aware of any
breaking changes between the 2.x and 3.x series noted in this document
(both this version and prior versions) and in the
[open-source (OSS)](https://github.com/Kong/kong/blob/release/3.1.x/CHANGELOG.md#310) and
[Enterprise](/gateway/changelog/#3000) Gateway changelogs. Since {{site.base_gateway}}
is built on an open-source foundation, any breaking changes in OSS affect all {{site.base_gateway}} packages.

{{site.base_gateway}} does not support directly upgrading from 1.x to {{page.kong_version}}.
If you are running 1.x, upgrade to 2.8.2 and then 3.0.x first at minimum, then upgrade to {{page.kong_version}} from there.

In either case, you can review the [upgrade considerations](#upgrade-considerations-and-breaking-changes),
then follow the [database migration](#migrate-db) instructions.

## Upgrade path for {{site.base_gateway}} 3.1.x 

The following table outlines various upgrade path scenarios to 3.1.x depending on the {{site.base_gateway}} version you are currently using:

| **Current version** | **Topology** | **Direct upgrade possible?** | **Upgrade path** |
| ------------------- | ------------ | ---------------------------- | ---------------- |
| 2.x | Traditional | No | [Upgrade to 2.8.2.x](/gateway/2.8.x/install-and-run/upgrade-enterprise/) (required for blue/green deployments only), then [upgrade to 3.0.x](/gateway/3.0.x/upgrade/), and then [upgrade to 3.1.x](#upgrade-from-30x-to-31x). |
| 2.x | Hybrid | No | [Upgrade to 2.8.2.x](/gateway/2.8.x/install-and-run/upgrade-enterprise/), then [upgrade to 3.0.x](/gateway/3.0.x/upgrade/), and then [upgrade to 3.1.x](#upgrade-from-30x-to-31x). |
| 2.x | DB less | No | [Upgrade to 3.0.x](/gateway/3.0.x/upgrade/), and then [upgrade to 3.1.x](#upgrade-from-30x-to-31x). |
| 3.0.x | Traditional | Yes | [Upgrade to 3.1.x](#upgrade-from-30x-to-31x). |
| 3.0.x | Hybrid | Yes | [Upgrade to 3.1.x](#upgrade-from-30x-to-31x). |
| 3.0.x | DB less | Yes | [Upgrade to 3.1.x](#upgrade-from-30x-to-31x). |

## Upgrade considerations and breaking changes

Before upgrading, review this list for any configuration or breaking changes that
affect your current installation.

### Kong for Kubernetes considerations

The Helm chart automates the upgrade migration process. When running `helm upgrade`,
the chart spawns an initial job to run `kong migrations up` and then spawns new
Kong pods with the updated version. Once these pods become ready, they begin processing
traffic and old pods are terminated. Once this is complete, the chart spawns another job
to run `kong migrations finish`.

While the migrations themselves are automated, the chart does not automatically ensure
that you follow the recommended upgrade path. If you are upgrading from more than one minor
{{site.base_gateway}} version back, check the upgrade path recommendations.

Although not required, users should upgrade their chart version and {{site.base_gateway}} version independently.
In the event of any issues, this will help clarify whether the issue stems from changes in
Kubernetes resources or changes in {{site.base_gateway}}.

For specific Kong for Kubernetes version upgrade considerations, see
[Upgrade considerations](https://github.com/Kong/charts/blob/main/charts/kong/UPGRADE.md)

#### Kong deployment split across multiple releases

The standard chart upgrade automation process assumes that there is only a single {{site.base_gateway}} release
in the {{site.base_gateway}} cluster, and runs both `migrations up` and `migrations finish` jobs.

If you split your {{site.base_gateway}} deployment across multiple Helm releases (to create proxy-only
and admin-only nodes, for example), you must set which migration jobs run based on your
upgrade order.

To handle clusters split across multiple releases, you should:

1. Upgrade one of the releases with:

   ```shell
   helm upgrade RELEASENAME -f values.yaml \
   --set migrations.preUpgrade=true \
   --set migrations.postUpgrade=false
   ```
2. Upgrade all but one of the remaining releases with:

   ```shell
   helm upgrade RELEASENAME -f values.yaml \
   --set migrations.preUpgrade=false \
   --set migrations.postUpgrade=false
   ```
3. Upgrade the final release with:

   ```shell
   helm upgrade RELEASENAME -f values.yaml \
   --set migrations.preUpgrade=false \
   --set migrations.postUpgrade=true
   ```

This ensures that all instances are using the new {{site.base_gateway}} package before running
`kong migrations finish`.

### Hybrid mode considerations

{:.important}
> **Important:** If you are currently running in [hybrid mode](/gateway/{{page.kong_version}}/production/deployment-topologies/hybrid-mode/),
upgrade the control plane first, and then the data planes.

* If you are currently running 2.8.x in classic (traditional)
  mode and want to run in hybrid mode instead, follow the hybrid mode
  [installation instructions](/gateway/{{page.kong_version}}/production/deployment-topologies/hybrid-mode/setup/)
  after running the migration.
* Custom plugins (either your own plugins or third-party plugins that are not shipped with {{site.base_gateway}})
  need to be installed on both the control plane and the data planes in hybrid mode. Install the
  plugins on the control plane first, and then the data planes.
* The [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced) plugin does not
    support the `cluster` strategy in hybrid mode. The `redis` strategy must be used instead.

### Template changes

There are changes in the Nginx configuration file between every minor and major
version of {{site.base_gateway}} starting with 2.0.x.

In 3.0.x, the deprecated alias of `Kong.serve_admin_api` was removed.
If your custom Nginx templates still use it, change it to `Kong.admin_content`.

{% navtabs %}
{% navtab OSS %}
To view all of the configuration changes between versions, clone the
[Kong repository](https://github.com/kong/kong) and run `git diff`
on the configuration templates, using `-w` for greater readability.

Here's how to see the differences between previous versions and 3.0.x:

```
git clone https://github.com/kong/kong
cd kong
git diff -w 2.0.0 3.0.0 kong/templates/nginx_kong*.lua
```

Adjust the starting version number (2.0.0 in the example) to the version number you are currently using.

To produce a patch file, use the following command:

```
git diff 2.0.0 3.0.0 kong/templates/nginx_kong*.lua > kong_config_changes.diff
```

Adjust the starting version number to the version number (2.0.0 in the example) you are currently using.

{% endnavtab %}
{% navtab Enterprise %}

The default template for {{site.base_gateway}} can be found using this command
on the system running your {{site.base_gateway}} instance:
`find / -type d -name "templates" | grep kong`.

When upgrading, make sure to run this command on both the old and new clusters,
diff the files to identify any changes, and apply them as needed.

{% endnavtab %}
{% endnavtabs %}

## Upgrade from 3.0.x to 3.1.x

### Traditional mode


1. Clone your database.
2. Download 3.1.x, and configure it to point to the cloned data store.
   Run `kong migrations up` and `kong migrations finish`.
3. Start the 3.1.x cluster.
4. Now both the old (3.0.x) and new (3.1.x)
   clusters can now run simultaneously. Start provisioning 3.1.x nodes.
3. Gradually divert traffic away from your old nodes, and into
   your 3.1.x cluster. Monitor your traffic to make sure everything
   is going smoothly.
4. When your traffic is fully migrated to the 3.1.x cluster,
   decommission your old nodes.

### Hybrid mode

Perform a rolling upgrade of your cluster:

1. Download 3.1.x.
2. Decommission your existing 3.0.x control plane. Your existing 3.0.x data
   planes can continue to handle proxy traffic during this time, even with no 
   active control plane.
4. Configure the new 3.1.x control plane to point to the same data store as
   your old control plane. Run `kong migrations up` and `kong migrations finish`.
5. Start the new 3.1.x control plane.
6. Start new 3.1.x data planes.
7. Gradually divert traffic away from your 3.0.x data planes, and into
   the new 3.1.x data planes. Monitor your traffic to make sure everything
   is going smoothly.
8. When your traffic is fully migrated to the 3.1.x cluster,
   decommission your old 3.0.x data planes.
