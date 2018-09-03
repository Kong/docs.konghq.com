---
title: Clustering Reference
---

# Clustering Reference

Multiple Kong nodes pointing to the same datastore **must** belong to the same "Kong cluster". A Kong cluster allows you to scale the system horizontally by adding more machines to handle a bigger load of incoming requests, and they all share the same data since they point to the same datastore.

A Kong cluster can be created in one datacenter, or in multiple datacenters, in both cloud or on-premise environments. Kong will take care of joining and leaving a node automatically in a cluster, as long as the node is configured properly.

## Summary

- 1. [Introduction][1]
- 2. [How does Kong clustering work?][2]
  - [Why do we need Kong Clustering?][2a]
- 3. [Adding new nodes to a cluster][3]
- 4. [Removing nodes from a cluster][4]
- 5. [Checking the cluster state][5]
- 6. [Network Assumptions][6]
- 7. [Edge-case scenarios][7]
  - [Asynchronous join on concurrent node starts][7a]
  - [Automatic cache purge on join][7b]
  - [Node failures][7c]

[1]: #1-introduction
[2]: #2-how-does-kong-clustering-work
[2a]: #why-do-we-need-kong-clustering
[3]: #3-adding-new-nodes-to-a-cluster
[4]: #4-removing-nodes-from-a-cluster
[5]: #5-checking-the-cluster-state
[6]: #6-network-assumptions
[7]: #7-edge-case-scenarios
[7a]: #asynchronous-join-on-concurrent-node-starts
[7b]: #automatic-cache-purge-on-join
[7c]: #node-failures
[8]: #8-problems-and-bug-reports

## 1. Introduction

Generally speaking having multiple Kong nodes is a good practice for a number of reasons, including:

* Scaling the system horizontally to process a greater number of incoming requests.
* Scaling the system on multiple datacenter to provide a distributed low latency geolocalized service.
* As a failure prevention response, so that even if a server crashes other Kong nodes can still process incoming requests without any downtime.

<center>
  <img src="/assets/images/docs/clustering.png" style="height: 400px"/>
</center>

To make sure every Kong node can process requests properly, each node must point to the same datastore so that they can share the same data. This means for example that APIs, Consumers and Plugins created by a Kong node will also be available to other Kong nodes that are pointing to the same datastore. 

By doing so it doesn't matter which Kong node is being requested, as long as they all point to the same datastore every node will be able to retrieve the same data and thus process requests in the same way.

## 2. How does Kong clustering work?

Every time a new Kong node is started, it must join other Kong nodes that are using the same datastore. This is done automatically given that the right configuration has been provided to Kong.

Kong cluster settings are specified in the configuration file at the following entries:

* [cluster_listen][cluster_listen]
* [cluster_listen_rpc][cluster_listen_rpc]
* [cluster][cluster]

#### Why do we need Kong Clustering?

To understand why a Kong Cluster is needed, we need to spend a few words on how Kong interacts with the datastore.

Every time a new incoming API requests hits a Kong server, Kong loads some data from the datastore to understand how to proxy the request, load any associated plugin, authenticate the Consumer, and so on. Doing this on every request would be very expensive in terms of performance, because Kong would need to communicate with the datastore on every request and this would be extremely inefficient. 

To avoid querying the datastore every time, Kong tries to cache as much data as possible locally in-memory after the first time it has been requested. Because a local in-memory lookup is tremendously faster than communicating with the datastore every time, this allows Kong to have a good performance on every request.

This works perfectly as long as data never changes, which is not the case with Kong. If the data changes in the datastore (because an API or a Plugin has been updated, for example), the previous in-memory cached version of the same data on each Kong node becomes immediately outdated. The Kong node will be unaware that the data changed on the datastore, unless something tells each Kong node that the data needs to be re-cached.

By clustering Kong nodes together we are making each Kong node aware of the presence of every other node, and every time an operation changes the data on the datastore, the Kong node responsible for that change can tell all the other nodes to invalidate the local in-memory cache and fetch again the data from the datastore.

This brings on the table very good performance, because Kong nodes will never talk to the datastore again unless they really have to. On the other side it introduces the concept of Kong Clustering, where we need to make sure that each node is aware of every other node so that they can communicate any change. Failure to do so would bring an inconsistency between the data effectively stored in the datastore, and the cached data store by each Kong node, leading to unexpected behavior.

## 3. Adding new nodes to a cluster

Every Kong node that points to the same datastore needs to join in a cluster with the other nodes. A Kong Cluster is made of at least two Kong nodes pointing to the same datastore.

Every time a new Kong node is being started it will register its first local, non-loopback, IPv4 address to the datastore. When another node is being started, it will query the datastore for nodes that have previously registered themselves, and join them using the IP address stored. If the auto-detected IP address is wrong, you can customize what address is being advertised to other nodes by using the `advertise` property in the [cluster settings][cluster].

A Kong node only needs to join one another node in a cluster, and it will automatically discover the entire cluster.

## 4. Removing nodes from a cluster

Everytime a new Kong node is stopped, that node will try to gracefully remove itself from the cluster. When a node has been successfully removed from a cluster, its state transitions from `alive` to `left`.

To gracefully stop and remove a node from the cluster just execute the `kong quit` or `kong stop` CLI commands.

When a node is not reachable for whatever reason, its state transitions to `failed`. Kong will automatically try to re-join a failed node just in case it becomes available again. You can exclude a failed node from the cluster in two ways:

* Using the [`kong cluster force-leave`][cli-cluster] CLI command
* Using the [API][cluster-api-remove]. 

Check the [Node Failures](#node-failures) paragraph for more info.

## 5. Checking the cluster state

You can check the cluster state, its nodes and the state of each node in two ways.

* By using the [`kong cluster members`][cli-cluster] CLI command. The output will include each node name, address and status in the cluster. The state can be `active` if a node is reachable, `failed` if it's status is currently unreachable or `left` if the node has been removed from the cluster.
* Another way to check the state of the cluster is by making a request to the Admin API at the [cluster status endpoint][cluster-api-status].

## 6. Network Assumptions

When configuring a cluster in either a single or multi-datancer setup, you need to know that Kong works on the IP layer (hostnames are not supported, only IPs are allowed) and it expects a flat network topology without any NAT between the two datacenters. A common setup is having a VPN between the two datacenters such that the "flat" network assumption of Kong is not violated. Or by advertising public addresses using the `advertise` property in the [cluster settings][cluster] without jumping through the NAT.

Kong will try to automatically determine the first non-loopback IPv4 address and share it with the other nodes, but you can override this address using the `advertise` property in the [cluster settings][cluster].

## 7. Edge-case scenarios

The implementation of the clustering feature of Kong is rather complex and may involve some edge case scenarios.

#### Asynchronous join on concurrent node starts

When multiple nodes are all being started simultaneously, a node may not be aware of the other nodes yet because the other nodes didn't have time to write their data to the datastore. To prevent this situation Kong implements by default a feature called "asynchronous auto-join".

Asynchronous auto-join will check the datastore every 3 seconds for 60 seconds after a Kong node starts, and will join any node that may appear in those 60 seconds. This means that concurrent environments where multiple nodes are started simultaneously it could take up to 60 seconds for them to auto-join the cluster.

#### Automatic cache purge on join

Every time a new node joins the cluster, or a failed node re-joins the cluster, the cache for every node is purged and all the data is forced to be reloaded. This is to avoid inconsistencies between the data that has already been invalidated in the cluster, and the data stored on the node.

This also means that after joining the cluster the new node's performance will be slower until the data has been re-cached into its memory.

#### Node failures

A node in the cluster can fail more multiple reasons, including networking problems or crashes. A node failure will also occur if Kong is not properly terminated by running `kong stop` or `kong quit`.

When a node fails, Kong will lose the ability to communicate with it and the cluster will try to reconnect to the node. Its status will show up as `failed` when looking up the cluster health with [`kong cluster members`][cli-cluster].

To remove a `failed` node from the cluster, use the [`kong cluster force-leave`][cli-cluster] command, and its status will transition to `left`.

The node data will persist for 1 hour in the datastore in case the node crashes, after which it will be removed from the datastore and new nodes will stop trying auto-joining it.

[cluster_listen]: /{{page.kong_version}}/configuration/#cluster_listen
[cluster_listen_rpc]: /{{page.kong_version}}/configuration/#cluster_listen_rpc
[cluster]: /{{page.kong_version}}/configuration/#cluster
[cli-cluster]: /{{page.kong_version}}/cli/#cluster
[cluster-api-status]: /{{page.kong_version}}/admin-api/#retrieve-cluster-status
[cluster-api-remove]: /{{page.kong_version}}/admin-api/#forcibly-remove-a-node
