---
title: Hybrid Mode Overview
---

Traditionally, Kong has always required a database, to store configured 
entities such as Routes, Services, and Plugins.

Starting with {{site.base_gateway}} 2.1, Kong can be deployed in
hybrid mode, also known as control plane / data plane separation (CP/DP).

In this mode, Kong nodes in a cluster are split into two roles: control plane
(CP), where configuration is managed and the Admin API is served from; and data
plane (DP), which serves traffic for the proxy. Each DP node is connected to one
of the CP nodes. Instead of accessing the database contents directly in the
traditional deployment method, the DP nodes maintain connection with CP nodes,
and receive the latest configuration.

![Hybrid mode topology](/assets/images/docs/ee/deployment/deployment-hybrid-2.png)

When you create a new data plane node, it establishes a connection to the
control plane. The control plane listens on port 8005 for connections and
tracks any incoming data from its data planes.

Once connected, every Admin API or Kong Manager action on the control plane
triggers an update to the data planes in the cluster.

## Benefits

Hybrid mode deployments have the following benefits:

* **Deployment flexibility:** Users can deploy groups of data planes in
different data centers, geographies, or zones without needing a local clustered
database for each DP group.
* **Increased reliability:** The availability of the database does not affect
the availability of the data planes. Each DP caches the latest configuration it
received from the control plane on local disk storage, so if CP nodes are down,
the DP nodes keep functioning.  
    * While the CP is down, DP nodes constantly try to reestablish communication.
    * DP nodes can be restarted while the CP is down, and still proxy traffic
    normally.
* **Traffic reduction:** Drastically reduces the amount of traffic to and from
the database, since only CP nodes need a direct connection to the database.
* **Increased security:** If one of the DP nodes is compromised, an attacker
won’t be able to affect other nodes in the Kong cluster.
* **Ease of management:** Admins only need to interact with the CP nodes to
control and monitor the status of the entire Kong cluster.

## Platform Compatibility

You can run {{site.base_gateway}} in hybrid mode on any platform where
{{site.base_gateway}} is [supported](/gateway/{{page.kong_version}}/install-and-run/).

### Kubernetes Support and Additional Documentation

[{{site.base_gateway}} on Kubernetes](/gateway/{{page.kong_version}}/install-and-run/kubernetes)
fully supports hybrid mode deployments, with or without the Kong Ingress Controller.

For the full Kubernetes hybrid mode documentation, see
[hybrid mode](https://github.com/Kong/charts/blob/main/charts/kong/README.md#hybrid-mode)
in the `kong/charts` repository.

## Version Compatibility

{{site.base_gateway}} control planes only allow connections from data planes with the
same major version.
Control planes won't allow connections from data planes with newer minor versions.

For example, a {{site.base_gateway}} v2.5.2 control plane:

- Accepts a {{site.base_gateway}} 2.5.0, 2.5.1 and 2.5.2 data plane.
- Accepts a {{site.base_gateway}} 2.3.8, 2.2.1 and 2.2.0 data plane.
- Accepts a {{site.base_gateway}} 2.5.3 data plane (newer patch version on the data plane is accepted).
- Rejects a {{site.base_gateway}} 1.0.0 data plane (major version differs).
- Rejects a {{site.base_gateway}} 2.6.0 data plane (minor version on data plane is newer).

Furthermore, for every plugin that is configured on the {{site.base_gateway}}
control plane, new configs are only pushed to data planes that have those configured
plugins installed and loaded. The major version of those configured plugins must
be the same on both the control planes and data planes. Also, the minor versions
of the plugins on the data planes can not be newer than versions installed on the
control planes. Similar to {{site.base_gateway}} version checks,
plugin patch versions are also ignored when determining compatibility.

{:.important}
> Configured plugins means any plugin that is either enabled globally or
configured by services, routes, or consumers.

For example, if a {{site.base_gateway}} control plane has `plugin1` v1.1.1
and `plugin2` v2.1.0 installed, and `plugin1` is configured by a `Route` object:

- It accepts {{site.base_gateway}} data planes with `plugin1` v1.1.2,
`plugin2` not installed.
- It accepts {{site.base_gateway}} data planes with `plugin1` v1.1.2,
`plugin2` v2.1.0, and  `plugin3` v9.8.1 installed.
- It accepts {{site.base_gateway}} data planes with `plugin1` v1.1.1
and `plugin3` v9.8.1 installed.
- It rejects {{site.base_gateway}} data planes with `plugin1` v1.2.0,
`plugin2` v2.1.0 installed (minor version of plugin on data plane is newer).
- It rejects {{site.base_gateway}} data planes with `plugin1` not installed
(plugin configured on control plane but not installed on data plane).

Version compatibility checks between the control plane and data plane
occur at configuration read time. As each data plane proxy receives
configuration updates, it checks to see if it can enable the requested
features. If the control plane has a newer version of {{site.base_gateway}}
than the data plane proxy, but the configuration doesn’t include any new features
from that newer version, the data plane proxy reads and applies it as expected.

For instance, a new version of {{site.base_gateway}} includes a new
plugin offering, and you update your control plane with that version. You can
still send configurations to your data planes that are on a less recent version
as long as you have not added the new plugin offering to your configuration.
If you add the new plugin to your configuration, you will need to update your
data planes to the newer version for the data planes to continue to read from
the control plane.

If the compatibility checks fail, the control plane stops
pushing out new config to the incompatible data planes to avoid breaking them.

If a config can not be pushed to a data plane due to failure of the
compatibility checks, the control plane will contain `warn` level lines in the
`error.log` similar to the following:

```bash
unable to send updated configuration to DP node with hostname: localhost.localdomain ip: 127.0.0.1 reason: version mismatches, CP version: 2.2 DP version: 2.1
unable to send updated configuration to DP node with hostname: localhost.localdomain ip: 127.0.0.1 reason: CP and DP does not have same set of plugins installed or their versions might differ
```

In addition, the `/clustering/data-planes` Admin API endpoint returns
the version of the data plane node and the latest config hash the node is
using. This data helps detect version incompatibilities from the
control plane side.

## Fault tolerance

If control plane nodes are down, the data plane will keep functioning. Data plane caches
the latest configuration it received from the control plane on the local disk.
In case the control plane stops working, the data plane will keep serving requests using
cached configurations. It does so while constantly trying to reestablish communication
with the control plane.

This means that the data plane nodes can be stopped even for extended periods
of time, and the data plane will still proxy traffic normally. Data plane
nodes can be restarted while in disconnected mode, and will load the last
configuration in the cache to start working. When the control plane is brought
up again, the data plane nodes will contact them and resume connected mode.

### Disconnected Mode

The viability of the data plane while disconnected means that control plane
updates or database restores can be done with peace of mind. First bring down
the control plane, perform all required downtime processes, and only bring up
the control plane after verifying the success and correctness of the procedure.
During that time, the data plane will keep working with the latest configuration.

A new data plane node can be provisioned during control plane downtime. This
requires either copying the config cache file (`config.json.gz`) from another
data plane node, or using a declarative configuration. In either case, if it
has the role of `"data_plane"`, it will also keep trying to contact the control
plane until it's up again.

To change a disconnected data plane node's configuration, you have to remove
the config cache file (`config.json.gz`), ensure the `declarative_config`
parameter or the `KONG_DECLARATIVE_CONFIG` environment variable is set, and set
the whole configuration in the referenced YAML file.

### Data plane cache configuration
{:.badge .enterprise}

By default, data planes store their configuration to the file system
in an unencrypted cache file, `config.json.gz`, in {{site.base_gateway}}'s
`prefix` path. You can also choose to encrypt this cache, or disable it entirely.

If encrypted, the data plane uses the cluster certificate key to decrypt the
configuration cache on startup.

See [`data_plane_config_cache_mode`](/gateway/{{page.kong_version}}/reference/configuration/#data_plane_config_cache_mode)
and [`data_plane_config_cache_path`](/gateway/{{page.kong_version}}/reference/configuration/#data_plane_config_cache_path).

## Limitations

### Configuration Inflexibility

When a configuration change is made at the control plane level via the Admin
API, it immediately triggers a cluster-wide update of all data plane
configurations. This means that the same configuration is synced from the CP to
all DPs, and the update cannot be scheduled or batched. For different DPs to
have different configurations, they will need their own CP instances.

### Plugin Incompatibility

When plugins are running on a data plane in hybrid mode, there is no Admin API
exposed directly from that DP. Since the Admin API is only exposed from the
control plane, all plugin configuration has to occur from the CP. Due to this
setup, and the configuration sync format between the CP and the DP, some plugins
have limitations in hybrid mode:

* [**Key Auth Encrypted:**](/hub/kong-inc/key-auth-enc) The time-to-live setting
(`ttl`), which determines the length of time a credential remains valid, does
not work in hybrid mode.
* [**Rate Limiting Advanced:**](/hub/kong-inc/rate-limiting-advanced)
This plugin does not support the `cluster` strategy in hybrid mode. The `redis`
strategy must be used instead.
* [**OAuth 2.0 Authentication:**](/hub/kong-inc/oauth2) This plugin is not
compatible with hybrid mode. For its regular workflow, the plugin needs to both
generate and delete tokens, and commit those changes to the database, which is
not possible with CP/DP separation.

### Custom Plugins

Custom plugins (either your own plugins or third-party plugins that are not
shipped with Kong) need to be installed on both the control plane and the data
plane in hybrid mode.

### Load Balancing

Currently, there is no automated load balancing for connections between the
control plane and the data plane. You can load balance manually by using
multiple control planes and redirecting the traffic using a TCP proxy.

## Readonly Status API endpoints on data plane

Several readonly endpoints from the [Admin API](/gateway/{{page.kong_version}}/admin-api)
are exposed to the [Status API](/gateway/{{page.kong_version}}/reference/configuration/#status_listen) on data planes, including the following:

- [GET /upstreams/{upstream}/targets/](/gateway/{{page.kong_version}}/admin-api/#list-targets)
- [GET /upstreams/{upstream}/health/](/gateway/{{page.kong_version}}/admin-api/#show-upstream-health-for-node)
- [GET /upstreams/{upstream}/targets/all/](/gateway/{{page.kong_version}}/admin-api/#list-all-targets)
- GET /upstreams/{upstream}/targets/{target}

Please refer to [Upstream objects](/gateway/{{page.kong_version}}/admin-api/#upstream-object) in the Admin API documentation for more information about the
endpoints.

## Keyring encryption in hybrid mode

Because the keyring module encrypts data in the database, it can't encrypt
data on data plane nodes, since these nodes run without a database and get
data from the control plane.
