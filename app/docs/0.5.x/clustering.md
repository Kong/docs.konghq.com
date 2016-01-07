---
title: Clustering Reference
---

# Clustering Reference

Explicit Kong clustering has been introduced with Kong >= v0.6.0 to dramatically increase the performance of the system when multiple Kong nodes are being used to process incoming requests.

Multiple Kong nodes pointing to the same datastore **must** belong to the same "Kong cluster". A Kong cluster allows you to scale the system horizontally by adding more machines to handle a bigger load of incoming requests, and they all share the same data since they point to the same datastore.

A Kong cluster can be created in one datacenter, or in multiple datacenters, in both cloud or on-premise environments.

## Summary

- 1. [Introduction][1]
- 2. [How does Kong clustering work?][2]
  - [Why do we need Kong Clustering?][2a]
- 3. [Adding new nodes to a cluster][3]
  - [Joining automatically][3a]
  - [Joining manually][3b]
- 4. [Removing nodes from a cluster][4]
  - [Leaving automatically][4a]
  - [Leaving manually][4b]
- 5. [Checking the cluster state][5]
  - [Using the CLI][5a]
  - [Using the API][5b]
- 6. [Multi-Datacenter clustering][6]
- 7. [Failure scenarios][7]

[1]: #1-introduction
[2]: #2-how-does-kong-clustering-work
[2a]: #why-do-we-need-kong-clustering
[3]: #3-adding-new-nodes-to-a-cluster
[3a]: #joining-automatically
[3b]: #joining-manually
[4]: #4-removing-nodes-from-a-cluster
[4a]: #leaving-automatically
[4b]: #leaving-manually
[5]: #5-checking-the-cluster-state
[5a]: #using-the-cli
[5b]: #using-the-api
[6]: #6-multi-datacenter-clustering
[7]: #7-failure-scenarios

## 1. Introduction

Adding multiple Kong nodes is a good practice for a number of reasons, including:

* Scaling the system horizontally to process a greater number of incoming requests.
* Scaling the system on multiple datacenter to provide a distributed low latency geolocalized service.
* As a failure prevention response, so that even if a server crashes other Kong nodes can still process incoming requests without any downtime.

To make sure every Kong node can process requests properly, each node must point to the same datastore so that they can share the same data. This means for example that APIs, Consumers and Plugins created by a Kong node will also be available to other Kong nodes that are pointing to the same datastore. 

By doing so it doesn't matter which Kong node is being requested, as long as they all point to the same datastore every node will be able to retrieve the same data and thus process requests in the same way.

## 2. How does Kong clustering work?

Every time a new Kong node is being added, there are two requirements:

* It must point to the same datastore.
* It must join other existing Kong nodes and be part of the same Kong Cluster.

Bear in mind that a Kong Cluster has nothing to do with any third-party datastore clustering which involves the datastore nodes instead:

<div class="alert alert-info">
  <a title="Kong Cluster" href="/assets/images/docs/cluster.png" target="_blank"><img src="/assets/images/docs/cluster.png"/></a>
</div>

Every time a new Kong node is added or removed, it also needs to be added and removed from the respective Kong Cluster. This can be done in two ways, automatically (with a few limitations) or manually.

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

A Kong Cluster is made of at least two Kong nodes pointing to the same datastore. Everytime a new node is being started, we also need to join it with the other existing nodes and make sure it belongs to the same Kong Cluster. This can be done in two different ways, automatically or manually.

#### Joining automatically

This is the default behavior, as specified by the `auto-join` property in the [cluster settings][cluster]. Every time a new Kong node is being started it will register its first local, non-loopback, IPv4 address to the datastore. When that happens, it will also try to join any other node that has previously registered its address as well.

Sometimes the automatically determined address is not always the appropriate one. You can override the advertised address by specifiying your own custom address in the `advertise` property in the [cluster settings][cluster].

#### Joining manually

By setting to `false` the `auto-join` property in the [cluster settings][cluster], Kong will not try to auto-join a cluster on startup. Instead, you will need to use the [`kong cluster join [address]`][cli-cluster] CLI command to manually add the Kong node to a cluster. 

## 4. Removing nodes from a cluster

Everytime a new Kong node is stopped, that node needs to be removed from the cluster or its state will be marked as `failed`. When a node has been successfully removed from a cluster, its state transitions to `left`. There are two ways to remove a node from the cluster, automatically or manually.

#### Leaving automatically

This is the default behavior, as specified by the `auto-join` property in the [cluster settings][cluster]. Everytime a node is being stopped by executing either `kong quit` or `kong stop` CLI commands, Kong will also try to remove the node from the cluster automatically, transitioning its state to `left`.

#### Leaving manually

By setting to `false` the `auto-join` property in the [cluster settings][cluster], Kong will not automatically remove the node from the cluster. Instead, you will need to use the [`kong cluster force-leave [node_name]`][cli-cluster] CLI command to remove the node from the cluster.

Note that `force-leave` requires a node name, instead of the address of the node. You can find node names by running `kong cluster members`.

## 5. Checking the cluster state

You can check the cluster state, its nodes and the state of each node in two ways.

#### Using the CLI

By using the [`kong cluster members`][cli-cluster] CLI command. The output will include each node name, address and status in the cluster. The state can be `active` if a node is reachable, `failed` if it's status is currently unreachable or `left` if the node has been removed from the cluster.

#### Using the API

Another way to check the state of the cluster is by making a request to the Admin API at the [cluster status endpoint][cluster-endpoint].

## 6. Multi-datacenter clustering

When configuring a multi-datancer Kong cluster, you need to know that Kong works on the IP layer (hostnames are not supported) and it expects a flat network topology without any NAT between the two datacenters. A common setup is having a VPN between the two datacenters such that the "flat" network assumption of Kong is not violated. Or by advertising public addresses using the `advertise` property in the [cluster settings][cluster] without jumping through the NAT.

## 7. Failure scenarios



[cluster_listen]: /docs/{{page.kong_version}}/configuration/#cluster_listen
[cluster_listen_rpc]: /docs/{{page.kong_version}}/configuration/#cluster_listen_rpc
[cluster]: /docs/{{page.kong_version}}/configuration/#cluster
[cli-cluster]: /docs/{{page.kong_version}}/cli/#cluster
[cluster-endpoint]: /docs/{{page.kong_version}}/admin-api/#retrieve-cluster-status
