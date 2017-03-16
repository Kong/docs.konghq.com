---
title: Authentication Reference
---

# Authentication Reference

Client access to upstream API services is typically controlled by the application and configuration of 
Kong authentication plugins. 

Authetication plugins are [documented individually][plugins]. 

Prior to Kong 0.10.x, only one authentication plugin could be configured for a given API.

Kong 0.10.x introduces the ability to apply multiple authentication plugins for a given API, allowing 
different clients to provide different authentication methods to the same API endpoint.

## Multiple Authentication

<div class="alert alert-warning">
  Currently, when multiple authentication plugins are .
</div>


- 1. [Getting Started][1]
- 2. [Node Discovery][2]
- 6. [Edge-case scenarios][6]
  - [Asynchronous join on concurrent node starts][6a]
  - [Automatic cache purge on join][6b]
  - [Node failures][6c]

[1]: #1-getting-started
[2]: #2-node-discovery
[6]: #6-edge-case-scenarios
[6a]: #asynchronous-join-on-concurrent-node-starts
[6b]: #automatic-cache-purge-on-join
[6c]: #node-failures

## 1. Getting Started

Kong nodes pointing to the same datastore must join together in a Kong cluster. Kong nodes in the 
same cluster need to be able to talk together on **both** TCP and UDP on the [cluster_listen][cluster_listen] address and port.

To check the status of the cluster and make sure the nodes can communicate with each other, you can run the [`kong cluster reachability`][cli-cluster] command.

To check the members of the cluster you can run the [`kong cluster members`][cli-cluster] command, or requesting the [cluster status endpoint][cluster-api-status] endpoint on the Admin API.


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




[plugins]: https://getkong.org/plugins/
