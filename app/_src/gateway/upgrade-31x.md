---
title: Upgrade Kong Gateway 3.x.x
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
The lowest version that Kong {{page.kong_version}} supports migrating from **directly** is 3.0.x.

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

## Upgrade path for {{site.base_gateway}} {{page.kong_version}} 

The following table outlines various upgrade path scenarios to {{page.kong_version}} depending on the {{site.base_gateway}} version you are currently using:

{% if_version lte: 3.1.x %}

| **Current version** | **Topology** | **Direct upgrade possible?** | **Upgrade path** |
| ------------------- | ------------ | ---------------------------- | ---------------- |
| 2.x–2.7.x | Traditional | No | [Upgrade to 2.8.2.x](/gateway/2.8.x/install-and-run/upgrade-enterprise/) (required for blue/green deployments only), then [upgrade to 3.0.x](/gateway/3.0.x/upgrade/), and then [upgrade to 3.1.x](#migrate-db). |
| 2.x–2.7.x | Hybrid | No | [Upgrade to 2.8.2.x](/gateway/2.8.x/install-and-run/upgrade-enterprise/), then [upgrade to 3.0.x](/gateway/3.0.x/upgrade/), and then [upgrade to 3.1.x](#migrate-db). |
| 2.x–2.7.x | DB less | No | [Upgrade to 3.0.x](/gateway/3.0.x/upgrade/), and then [upgrade to 3.1.x](#migrate-db). |
| 2.8.x | Traditional | Only if you upgrade to 3.1.1.3 | [Upgrade to 3.1.1.3](#migrate-db). |
| 2.8.x | Hybrid | Only if you upgrade to 3.1.1.3 | [Upgrade to 3.1.1.3](#migrate-db). |
| 2.8.x | DB less | Only if you upgrade to 3.1.1.3 | [Upgrade to 3.1.1.3](#migrate-db). |
| 3.0.x | Traditional | Yes | [Upgrade to 3.1.x](#migrate-db). |
| 3.0.x | Hybrid | Yes | [Upgrade to 3.1.x](#migrate-db). |
| 3.0.x | DB less | Yes | [Upgrade to 3.1.x](#migrate-db). |

{% endif_version %}

{% if_version gte: 3.2.x %}

| **Current version** | **Topology** | **Direct upgrade possible?** | **Upgrade path** |
| ------------------- | ------------ | ---------------------------- | ---------------- |
| 2.x–2.7.x | Traditional | No | [Upgrade to 2.8.2.x](/gateway/2.8.x/install-and-run/upgrade-enterprise/) (required for blue/green deployments only), then [upgrade to 3.0.x](/gateway/3.0.x/upgrade/), and then [upgrade to 3.2.x](#migrate-db). |
| 2.x–2.7.x | Hybrid | No | [Upgrade to 2.8.2.x](/gateway/2.8.x/install-and-run/upgrade-enterprise/), then [upgrade to 3.0.x](/gateway/3.0.x/upgrade/), and then [upgrade to 3.2.x](#migrate-db). |
| 2.x–2.7.x | DB less | No | [Upgrade to 3.0.x](/gateway/3.0.x/upgrade/), and then [upgrade to 3.2.x](#migrate-db). |
| 2.8.x | Traditional | No | [Upgrade to 3.1.1.3](#migrate-db), and then [upgrade to 3.2.x](#migrate-db). |
| 2.8.x | Hybrid | No | [Upgrade to 3.1.1.3](#migrate-db), and then [upgrade to 3.2.x](#migrate-db). |
| 2.8.x | DB less | No | [Upgrade to 3.1.1.3](#migrate-db), and then [upgrade to 3.2.x](#migrate-db). |
| 3.0.x | Traditional | Yes | [Upgrade to 3.2.x](#migrate-db). |
| 3.0.x | Hybrid | Yes | [Upgrade to 3.2.x](#migrate-db). |
| 3.0.x | DB less | Yes | [Upgrade to 3.2.x](#migrate-db). |
| 3.1.x | Traditional | Yes | [Upgrade to 3.2.x](#migrate-db). |
| 3.1.0.x-3.1.1.2 | Hybrid | No | [Upgrade to 3.1.1.3](#migrate-db), and then [upgrade to 3.2.x](#migrate-db). |
| 3.1.1.3 | Hybrid | Yes | [upgrade to 3.2.x](#migrate-db) |
| 3.1.x | DB less | Yes | [Upgrade to 3.2.x](#migrate-db). |

{% endif_version %}

## Upgrade considerations and breaking changes

Before upgrading, review this list for any configuration or breaking changes that
affect your current installation.

{% if_version gte:3.2.x %}

### PostgreSQL SSL version bump

The default PostgreSQL SSL version has been bumped to TLS 1.2. 

This causes changes to [`pg_ssl_version`](/gateway/latest/reference/configuration/#postgres-settings) (set through `kong.conf`):
* The default value is now `tlsv1_2`.  
* `pg_ssl_version` previously accepted any string. In this version, it requires one of the following values: `tlsv1_1`, `tlsv1_2`, `tlsv1_3` or `any`.

This mirrors the setting `ssl_min_protocol_version` in PostgreSQL 12.x and onward. 
See the [PostgreSQL documentation](https://postgresqlco.nf/doc/en/param/ssl_min_protocol_version/)
for more information about that parameter.

To use the default setting in `kong.conf`, verify that your Postgres server supports TLS 1.2 or higher versions, or set the TLS version yourself. 

TLS versions lower than `tlsv1_2` are already deprecated and are considered insecure from PostgreSQL 12.x onward.
  
### Changes to the Kong-Debug header

Added the [`allow_debug_header`](/gateway/latest/reference/configuration/#allow_debug_header) 
configuration property to `kong.conf` to constrain the `Kong-Debug` header for debugging. This option defaults to `off`.

If you were previously relying on the `Kong-Debug` header to provide debugging information, set `allow_debug_header: on` in `kong.conf` to continue doing so.

### JWT plugin
    
The [JWT plugin](/hub/kong-inc/jwt/) now denies any request that has different tokens in the JWT token search locations.

### Session library upgrade

The [`lua-resty-session`](https://github.com/bungle/lua-resty-session) library has been upgraded to v4.0.0. 
This version includes a full rewrite of the session library.

This upgrade affects the following: 
* [Session plugin](/hub/kong-inc/session/)
* [OpenID Connect plugin](/hub/kong-inc/openid-connect/)
* [SAML plugin](/hub/kong-inc/saml)
* Any session configuration that uses the Session or OpenID Connect plugin in the background, including sessions for Kong Manager and Dev Portal.

All existing sessions are invalidated when upgrading to this version.
For sessions to work as expected in this version, all nodes must run {{site.base_gateway}} 3.2.x or later.
If multiple data planes run different versions, every time a user hits a different DP, 
even for the same endpoint, the previous session is invalidated.

For that reason, we recommend that during upgrades, proxy nodes with
mixed versions run for as little time as possible. During that time, the invalid sessions could cause 
failures and partial downtime. 

You can expect the following behavior:
* **After upgrading the control plane**: Existing Kong Manager and Dev Portal sessions will be invalidated and all users will be required to log back in.
* **After upgrading the data planes**: Existing proxy sessions will be invalidated. If you have an IdP configured, users will be required to log back into the IdP.

#### Session configuration parameter changes

The session library upgrade includes new, changed, and removed parameters. Here's how they function:

* The new parameter `idling_timeout`, which replaces `cookie_lifetime`, has a default value of 900. 
Unless configured differently, sessions expire after 900 seconds (15 minutes) of idling. 
* The new parameter `absolute_timeout` has a default value of 86400. 
Unless configured differently, sessions expire after 86400 seconds (24 hours).
* All renamed parameters will still work by their old names.
* Any removed parameters will not work anymore. They won't break your configuration, and sessions will 
continue to function, but they will not contribute anything to the configuration.

Existing session configurations will still work as configured with the old parameters. 

**Do not** change any parameters to the new ones until all CP and DP nodes are upgraded.

After you have upgraded all of your CP and DP nodes to 3.2 and ensured that your environment is stable, we 
recommend updating parameters to their new renamed versions, and cleaning out any removed parameters 
from session configuration to avoid unpredictable behavior.

#### Session plugin

Old parameter name | New parameter name
-------------------|--------------------
`cookie_lifetime` | `rolling_timeout`
`cookie_idletime` | `idling_timeout`
`cookie_samesite` | `cookie_same_site`
`cookie_httponly` | `cookie_http_only`
`cookie_discard` | `stale_ttl`
`cookie_renew` | Removed, no replacement parameter. 
  

#### SAML plugin

Old parameter name | New parameter name
-------------------|--------------------
`session_cookie_lifetime` | `session_rolling_timeout`
`session_cookie_idletime` | `session_idling_timeout`
`session_cookie_samesite` | `session_cookie_same_site` 
`session_cookie_httponly` | `session_cookie_http_only`
`session_memcache_prefix` | `session_memcached_prefix`
`session_memcache_socket` | `session_memcached_socket`
`session_memcache_host` | `session_memcached_host`
`session_memcache_port` | `session_memcached_port`
`session_redis_cluster_maxredirections` |  `session_redis_cluster_max_redirections`
`session_cookie_renew` | Removed, no replacement parameter. 
`session_cookie_maxsize` | Removed, no replacement parameter. 
`session_strategy` | Removed, no replacement parameter. 
`session_compressor` | Removed, no replacement parameter. 

#### OpenID Connect plugin

Old parameter name | New parameter name
-------------------|--------------------
`authorization_cookie_lifetime` | `authorization_rolling_timeout`
`authorization_cookie_samesite` | `authorization_cookie_same_site`
`authorization_cookie_httponly` | `authorization_cookie_http_only`
`session_cookie_lifetime` | `session_rolling_timeout`
`session_cookie_idletime` | `session_idling_timeout`
`session_cookie_samesite` | `session_cookie_same_site`
`session_cookie_httponly` | `session_cookie_http_only`
`session_memcache_prefix` | `session_memcached_prefix`
`session_memcache_socket` | `session_memcached_socket`
`session_memcache_host` | `session_memcached_host`
`session_memcache_port` | `session_memcached_port`
`session_redis_cluster_maxredirections` | `session_redis_cluster_max_redirections`
`session_cookie_renew` | Removed, no replacement parameter. 
`session_cookie_maxsize` | Removed, no replacement parameter. 
`session_strategy` | Removed, no replacement parameter. 
`session_compressor` | Removed, no replacement parameter. 

{% endif_version %}

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

* If you are currently running the previous version in classic (traditional)
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

Here's how to see the differences between previous versions and {{page.versions.ce}}:

```
git clone https://github.com/kong/kong
cd kong
git diff -w 2.0.0 {{page.versions.ce}} kong/templates/nginx_kong*.lua
```

Adjust the starting version number (2.0.0 in the example) to the version number you are currently using.

To produce a patch file, use the following command:

```
git diff 2.0.0 {{page.versions.ce}} kong/templates/nginx_kong*.lua > kong_config_changes.diff
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

## General upgrade path {#migrate-db}

### Traditional mode


1. Clone your database.
2. Download the version of {{site.base_gateway}} you want to upgrade to, and configure it to point to the cloned data store.
   Run `kong migrations up` and `kong migrations finish`.
3. Start the new {{site.base_gateway}} version cluster.
4. Now both the old and new
   clusters can now run simultaneously. Start provisioning the new {{site.base_gateway}} version nodes.
3. Gradually divert traffic away from your old nodes, and into
   your new cluster. Monitor your traffic to make sure everything
   is going smoothly.
4. When your traffic is fully migrated to the new cluster,
   decommission your old nodes.

### Hybrid mode

{:.important}
> Do not make any changes to Kong configuration (`kong.conf`) or use the Admin API 
in the middle of an upgrade. This can cause incompatibilities between data plane nodes.

Perform a rolling upgrade of your cluster:

1. Download the version of {{site.base_gateway}} you want to upgrade to.
2. Decommission your existing control plane. Your existing data
   planes can continue to handle proxy traffic during this time, even with no 
   active control plane.
4. Configure the new {{site.base_gateway}} version control plane to point to the same data store as
   your old control plane. Run `kong migrations up` and `kong migrations finish`.
5. Start the new control plane.
6. Start new data planes.
7. Gradually divert traffic away from your old data planes, and into
   the new data planes. Monitor your traffic to make sure everything
   is going smoothly.
8. When your traffic is fully migrated to the new cluster,
   decommission your old data planes.
