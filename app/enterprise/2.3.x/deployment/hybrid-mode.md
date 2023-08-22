---
title: Hybrid Mode Overview
---

## Introduction
Traditionally, Kong has always required a database, which could be either
Postgres or Cassandra, to store configured entities such as Routes, Services,
and Plugins.

Starting with {{site.ee_product_name}} 2.1, Kong can be deployed in
Hybrid mode, also known as Control Plane / Data Plane Separation (CP/DP).

In this mode, Kong nodes in a cluster are split into two roles: Control Plane
(CP), where configuration is managed and the Admin API is served from; and Data
Plane (DP), which serves traffic for the proxy. Each DP node is connected to one
of the CP nodes. Instead of accessing the database contents directly in the
traditional deployment method, the DP nodes maintain connection with CP nodes,
and receive the latest configuration.

![Hybrid mode topology](/assets/images/docs/ee/deployment/deployment-hybrid-2.png)

When you create a new Data Plane node, it establishes a connection to the
Control Plane. The Control Plane listens on port 8005 for connections and
tracks any incoming data from its Data Planes.

Once connected, every Admin API or Kong Manager action on the Control Plane
triggers an update to the Data Planes in the cluster.

## Benefits

Hybrid mode deployments have the following benefits:

* **Deployment flexibility:** Users can deploy groups of Data Planes in
different data centers, geographies, or zones without needing a local clustered
database for each DP group.
* **Increased reliability:** The availability of the database does not affect
the availability of the Data Planes. Each DP caches the latest configuration it
received from the Control Plane on local disk storage, so if CP nodes are down,
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

You can run {{site.ee_product_name}} in Hybrid mode on any platform where
{{site.ee_product_name}} is [supported](/enterprise/{{page.kong_version}}/deployment/installation/overview/).

### Kubernetes Support and Additional Documentation
[Kong Enterprise on Kubernetes](/enterprise/{{page.kong_version}}/deployment/installation/kong-on-kubernetes)
fully supports Hybrid mode deployments, with or without the Kong Ingress Controller.

For the full Kubernetes Hybrid mode documentation, see
[Hybrid mode](https://github.com/Kong/charts/blob/main/charts/kong/README.md#hybrid-mode)
in the `kong/charts` repository.


## Version Compatibility
{{site.base_gateway}} control planes only allow connections from data planes with the
same major version.
Control planes won't allow connections from data planes with newer minor versions.

For example, a {{site.ee_product_name}} v2.5.2 control plane:

- Accepts a {{site.ee_product_name}} 2.5.0, 2.5.1 and 2.5.2 data plane.
- Accepts a {{site.ee_product_name}} 2.3.8, 2.2.1 and 2.2.0 data plane.
- Accepts a {{site.ee_product_name}} 2.5.3 data plane (newer patch version on the data plane is accepted).
- Rejects a {{site.ee_product_name}} 1.0.0 data plane (major version differs).
- Rejects a {{site.ee_product_name}} 2.6.0 data plane (minor version on data plane is newer).

Furthermore, for every plugin that is configured on the {{site.ee_product_name}}
control plane, new configs are only pushed to data planes that have those configured
plugins installed and loaded. The major version of those configured plugins must
be the same on both the control planes and data planes. Also, the minor versions
of the plugins on the data planes can not be newer than versions installed on the
control planes. Similar to {{site.ee_product_name}} version checks,
plugin patch versions are also ignored when determining compatibility.

{:.important}
> Configured plugins means any plugin that is either enabled globally or
configured by services, routes, or consumers.

For example, if a {{site.ee_product_name}} control plane has `plugin1` v1.1.1
and `plugin2` v2.1.0 installed, and `plugin1` is configured by a `Route` object:

- It accepts {{site.ee_product_name}} data planes with `plugin1` v1.1.2,
`plugin2` not installed.
- It accepts {{site.ee_product_name}} data planes with `plugin1` v1.1.2,
`plugin2` v2.1.0, and  `plugin3` v9.8.1 installed.
- It accepts {{site.ee_product_name}} data planes with `plugin1` v1.1.1
and `plugin3` v9.8.1 installed.
- It rejects {{site.ee_product_name}} data planes with `plugin1` v1.2.0,
`plugin2` v2.1.0 installed (minor version of plugin on data plane is newer).
- It rejects {{site.ee_product_name}} data planes with `plugin1` not installed
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

```
unable to send updated configuration to DP node with hostname: localhost.localdomain ip: 127.0.0.1 reason: version mismatches, CP version: 2.2 DP version: 2.1
unable to send updated configuration to DP node with hostname: localhost.localdomain ip: 127.0.0.1 reason: CP and DP does not have same set of plugins installed or their versions might differ
```

In addition, the `/clustering/data-planes` Admin API endpoint returns
the version of the data plane node and the latest config hash the node is
using. This data helps detect version incompatibilities from the
control plane side.



## Limitations

### Configuration Inflexibility
When a configuration change is made at the Control Plane level via the Admin
API, it immediately triggers a cluster-wide update of all Data Plane
configurations. This means that the same configuration is synced from the CP to
all DPs, and the update cannot be scheduled or batched. For different DPs to
have different configurations, they will need their own CP instances.

### Plugin Incompatibility
When plugins are running on a Data Plane in hybrid mode, there is no Admin API
exposed directly from that DP. Since the Admin API is only exposed from the
Control Plane, all plugin configuration has to occur from the CP. Due to this
setup, and the configuration sync format between the CP and the DP, some plugins
have limitations in Hybrid mode:

* [**Key Auth Encrypted:**](/hub/kong-inc/key-auth-enc/) The time-to-live setting
(`ttl`), which determines the length of time a credential remains valid, does
not work in Hybrid mode.
* [**Rate Limiting Advanced:**](/hub/kong-inc/rate-limiting-advanced/)
This plugin does not support the `cluster` strategy in Hybrid mode. The `redis`
strategy must be used instead.
* [**OAuth 2.0 Authentication:**](/hub/kong-inc/oauth2/) This plugin is not
compatible with Hybrid mode. For its regular workflow, the plugin needs to both
generate and delete tokens, and commit those changes to the database, which is
not possible with CP/DP separation.

### Custom Plugins
Custom plugins (either your own plugins or third-party plugins that are not
shipped with Kong) need to be installed on both the Control Plane and the Data
Plane in Hybrid mode.

### Load Balancing
Currently, there is no automated load balancing for connections between the
Control Plane and the Data Plane. You can load balance manually by using
multiple Control Planes and redirecting the traffic using a TCP proxy.
