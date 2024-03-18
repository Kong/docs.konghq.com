---
title: Network Resiliency and Availability
toc: false
---

{{site.konnect_saas}} deployments run in hybrid mode, which means that there is
a separate control plane attached to a data plane consisting of one or more 
data plane nodes. Control planes and data plane nodes must communicate with 
each other to receive and send configurations. If communication is interrupted 
and either side can't send or receive config, data plane nodes can still continue 
proxying traffic to clients.

Whenever a data plane node receives new configuration from the control plane,
it immediately loads that config into memory. At the same time, it caches
the config to the file system. The location of the cache differs depending
on the major release of your Gateway:

* **2.x Gateway**: By default, data plane nodes store their configuration in an
unencrypted cache file, `config.json.gz`, in {{site.base_gateway}}’s prefix path.
* **3.x Gateway**: By default, data plane nodes store their configuration in an
unencrypted LMDB database directory, `dbless.lmdb`, in {{site.base_gateway}}’s
prefix path.

## Communication

### How do the control plane and data plane communicate?

Data traveling between control planes and data planes is secured through a
mutual TLS handshake.
Data plane nodes initiate the connection to the {{site.konnect_short_name}} control plane.
Once the connection is established, the control plane can send configuration data to the 
connected data plane nodes.

Normally, each data plane node maintains a persistent connection with the control
plane. The node sends a heartbeat to the control plane every 30 seconds to
keep the connection alive. If it receives no answer, it tries to reconnect to the
control plane after a 5-10 second delay.


### How does network peering work with Cloud Gateway nodes?

Each Cloud Gateway node is part of a dedicated Cloud Gateway network that corresponds to a specific cloud region, such as `us-east-1` or `us-west-2`. For enhanced security and seamless connectivity between your cloud network and the {{site.konnect_short_name}} environment, users have the option to peer their Cloud Gateway network with their own network in AWS. This integration is facilitated through the use of AWS's [TransitGateway](https://aws.amazon.com/transit-gateway/) feature, enabling secure network connections across both platforms.

### What types of data travel between the {{site.konnect_saas}} control plane and the data plane nodes, and how?

There are two types of data that travel between the planes: configuration
and telemetry. Both use the secure TCP port `443`.

* **Configuration:** The control plane sends configuration data to any connected
  data plane node in the cluster.

* **Telemetry:** Data plane nodes send usage information to the control plane
  for Analytics and for account billing. Analytics tracks aggregate traffic by
  service, route, and the consuming application. For billing, Kong tracks the
  number of services, API calls, and active dev portals.

Telemetry data does not include any customer information or any data processed
by the data plane. All telemetry data is encrypted using mTLS.

### How frequently does data travel between the Konnect control plane and data plane nodes?

When you make a configuration change on the control plane, that change is
immediately pushed to any connected data plane nodes.

## Connection behavior and incident recovery

### What happens if {{site.konnect_saas}} goes down?

If the Kong-hosted control plane goes down, the control plane/data plane
connection gets interrupted. You can't access the control plane or
change any configuration during this time.

A connection interruption has no negative effect on the function of your
data plane nodes. They continue to proxy and route traffic normally.

### What happens if the control plane and data plane nodes disconnect?

If a data plane node becomes disconnected from its control plane, configuration can't
travel between them. In that situation, the data plane node continues to use cached
configuration until it reconnects to the control plane and receives new
configuration.

Whenever a connection is re-established with the control plane, it pushes the latest 
configuration to the data plane node. It doesn't queue up or try to apply older changes.

If your control plane is a {{site.mesh_product_name}} global control plane, see [Failure modes](/mesh/latest/production/deployment/multi-zone/#failure-modes) in the {{site.mesh_product_name}} documentation for more details on what happens when there are {{site.mesh_product_name}} connectivity issues.

### How long can data plane nodes remain disconnected from the control plane?

A data plane node will keep pinging the
control plane, until the connection is re-established or the data plane node
is stopped.

The data plane node needs to connect to the control plane at least once.
The control plane pushes configuration to the data plane, and each data plane
node caches that configuration in-memory. It continues to use this cached
configuration until it receives new instructions from the control plane.

There are situations that can cause further problems:
* If the license that the data plane node received from the control plane expires,
the node stops working.
* If the data plane node's configuration cache file (`config.json.gz`) or directory (`dbless.lmdb`)
gets deleted, it loses access to the last known configuration and starts
up empty.

### Can I restart a data plane node if the control plane is down or disconnected?

Yes. If you restart a data plane node, it uses a cached configuration to continue
functioning the same as before the restart.

### Can I create a new data plane node when the connection is down?

Yes. Starting in version 3.2, {{site.base_gateway}} can be configured to support configuring new data
plane nodes in the event of a control plane outage. See 
[How to Configure Data Plane Resilience](/gateway/latest/kong-enterprise/cp-outage-handling/) 
for more information. 

## Backups and alternative options

### Can I create a backup configuration to use in case the cache fails?

You can set the [`declarative_config`](/gateway/latest/reference/configuration/#declarative_config)
option to load a fallback YAML config.

### Can I change a data plane node's configuration when it's disconnected from the control plane?

Yes, if necessary, though any manual configuration will be overwritten the next
time the control plane connects to the node.

You can load configuration manually in one of the following ways:
* Copy the configuration cache file (`config.json.gz`) or directory (`dbless.lmdb`) from another data
plane node with a working connection and overwrite the cache file on disk
for the disconnected node.
* Remove the cache file, then start the data plane node with
[`declarative_config`](/gateway/latest/reference/configuration/#declarative_config)
 to load a fallback YAML config.
