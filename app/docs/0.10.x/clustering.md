---
title: Clustering Reference
---

# Clustering Reference

Multiple Kong nodes pointing to the same datastore **must** belong to the same "Kong Cluster". 

A Kong cluster allows you to scale the system horizontally by adding more machines to handle a bigger load of incoming requests, and they all share the same data since they point to the same datastore.

A Kong cluster can be created in one datacenter, or in multiple datacenters, in both cloud or on-premise environments. Kong will take care of joining and leaving a node automatically in a cluster, as long as the node is configured properly.

<div class="alert alert-warning">
  Failure to proper cluster together Kong nodes that are using the same datastore will result in out-of-sync data on Kong nodes, and therefore consistency problems will occur.
</div>

## Summary

- 1. [Getting Started][1]
- 2. [Node Discovery][2]
- 3. [Network Requirements][3]
- 4. [Node Health States][4]
- 5. [Removing a failed node][5]
- 6. [Edge-case scenarios][6]
  - [Asynchronous join on concurrent node starts][6a]
  - [Automatic cache purge on join][6b]
  - [Node failures][6c]

[1]: #1-getting-started
[2]: #2-node-discovery
[3]: #3-network-requirements
[4]: #4-node-health-states
[5]: #5-removing-a-failed-node
[6]: #6-edge-case-scenarios
[6a]: #asynchronous-join-on-concurrent-node-starts
[6b]: #automatic-cache-purge-on-join
[6c]: #node-failures

## 1. Getting Started

Kong nodes pointing to the same datastore must join together in a Kong cluster. Kong nodes in the same cluster need to be able to talk together on **both** TCP and UDP on the [cluster_listen][cluster_listen] address and port.

To check the status of the cluster and make sure the nodes can communicate with each other, you can run the [`kong cluster reachability`][cli-cluster] command.

To check the members of the cluster you can run the [`kong cluster members`][cli-cluster] command, or requesting the [cluster status endpoint][cluster-api-status] endpoint on the Admin API.

<center>
  <img src="/assets/images/docs/clustering.png" style="height: 400px"/>
</center>

Kong clustering settings are specified in the configuration file at the following entries:

* [cluster_listen][cluster_listen]
* [cluster_listen_rpc][cluster_listen_rpc]
* [cluster_advertise][cluster_advertise]
* [cluster_encrypt_key][cluster_encrypt_key]
* [cluster_ttl_on_failure][cluster_ttl_on_failure]
* [cluster_profile][cluster_profile]

## 2. Node Discovery

On startup, Kong will try to auto-detect the first private, non-loopback, IPv4 address and register the address into a `nodes` table in the datastore to be advertised to any other node that's being started with the same datastore. When another Kong node starts it will then read the `nodes` table and try to join at least one of the advertised addresses.

Once a Kong nodes joins one other node, it will automatically discover all the other nodes thanks to the underlying gossip protocol.

Sometimes the IPv4 address that's automatically advertised by Kong it's not the correct one. You can override the advertised IP address and port by specifying the [cluster_advertise][cluster_advertise].

## 3. Network Requirements

There are a few networking requirements that must be satisfied for this to work. Of course, all server nodes must be able to talk to each other in both TCP and UDP. Otherwise, the gossip protocol as well as RPC forwarding will not work. 

If Kong is to be used across datacenters, the network must be able to route traffic between IP addresses across regions as well. Usually, this means that all datacenters must be connected using a VPN or other tunneling mechanism. Kong does not handle VPN, address rewriting, or NAT traversal for you.

Even if all the Kong nodes seem to be successfully part of a cluster, that doesn't mean they will be able to successfully communicate together: to check the status of the cluster and make sure the nodes can communicate with each other, you can run the [`kong cluster reachability`][cli-cluster] command.

For multi-DC setups you will probably have to explicitly configure the [cluster_advertise][cluster_advertise] property on each node using an IP address and port that every Kong node (in any DC) can use to connect to that specific Kong node (in both TCP and UDP). For example if a node is available on DC1 at `1.1.1.1:7946` and another node is available at `2.2.2.2:7946` on DC2, the node on DC1 must have `cluster_advertise=1.1.1.1:7946` and the node on DC2 must have `cluster_advertise=2.2.2.2:7946`.

## 4. Node Health States

A Kong node can be in four different states:

* `active`: the node is active and part of the cluster.
* `failed`: the node is not reachable by the cluster.
* `leaving`: a node is in the process of leaving the cluster.
* `left`: the node has gracefully left the cluster.

When a node is `failed`, you need to manually remove it from the cluster.

## 5. Removing a failed node

Everytime a new Kong node is stopped, that node will try to gracefully remove itself from the cluster. When a node has been successfully removed from a cluster, its state transitions from `alive` to `left`.

To gracefully stop and remove a node from the cluster just execute the `kong quit` or `kong stop` CLI commands.

When a node is not reachable for whatever reason, its state transitions to `failed`. Kong will automatically try to re-join a failed node just in case it becomes available again. You can exclude a failed node from the cluster in two ways:

* Using the [`kong cluster force-leave`][cli-cluster] CLI command
* Using the [API][cluster-api-remove]. 

Check the [Node Failures](#node-failures) paragraph for more info.

## 6. Edge-case scenarios

The implementation of the clustering feature of Kong is rather complex and may involve some edge case scenarios.

#### Asynchronous join on concurrent node starts

When multiple nodes are all being started simultaneously, a node may not be aware of the other nodes yet because the other nodes didn't have time to write their data to the datastore. To prevent this situation Kong implements by default a feature called "asynchronous auto-join".

Asynchronous auto-join will check the datastore every 3 seconds for 60 seconds after a Kong node starts, and will join any node that may appear in those 60 seconds. This means that concurrent environments where multiple nodes are started simultaneously it could take up to 60 seconds for them to auto-join the cluster.

#### Automatic cache purge on join

Every time a new node joins the cluster, or a failed node re-joins the cluster, the in-memory cache for every node is purged and all the data is forced to be re-fetched from the datastore. This is to avoid inconsistencies between the data that has already been invalidated in the cluster, and the data stored on the node.

This also means that after joining the cluster the new node's performance will be slower until the data has been re-cached into the local memory.

#### Node failures

A node in the cluster can fail more multiple reasons, including networking problems or crashes. A node failure will also occur if Kong is not properly terminated by running `kong stop` or `kong quit`.

When a node fails, Kong will lose the ability to communicate with it and the cluster will try to reconnect to the node. Its status will show up as `failed` when looking up the cluster health with [`kong cluster members`][cli-cluster].

To remove a `failed` node from the cluster, use the [`kong cluster force-leave`][cli-cluster] command, and its status will transition to `left`.

The advertised address of the failed node will persist for 1 hour in the `nodes` table in the datastore, after which it will be removed from the datastore and new nodes will stop trying auto-joining it. You can customize this TTL by changing the [cluster_ttl_on_failure][cluster_ttl_on_failure] property.


[cluster_listen]: /docs/{{page.kong_version}}/configuration/#cluster_listen
[cluster_listen_rpc]: /docs/{{page.kong_version}}/configuration/#cluster_listen_rpc
[cluster_advertise]: /docs/{{page.kong_version}}/configuration/#cluster_advertise
[cluster_ttl_on_failure]: /docs/{{page.kong_version}}/configuration/#cluster_ttl_on_failure
[cluster_encrypt_key]: /docs/{{page.kong_version}}/configuration/#cluster_encrypt_key
[cluster_ttl_on_failure]: /docs/{{page.kong_version}}/configuration/#cluster_ttl_on_failure
[cluster_profile]: /docs/{{page.kong_version}}/configuration/#cluster_profile
[cli-cluster]: /docs/{{page.kong_version}}/cli/#cluster
[cluster-api-status]: /docs/{{page.kong_version}}/admin-api/#retrieve-cluster-status
[cluster-api-remove]: /docs/{{page.kong_version}}/admin-api/#forcibly-remove-a-node
