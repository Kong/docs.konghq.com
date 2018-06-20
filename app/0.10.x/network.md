---
title: Network & Firewall
---

# Network & Firewall

In this section you will find a summary about the recommended network and firewall settings for Kong.

## Ports

Kong uses multiple connections for different purposes.

* proxy 
* management api
* clustering

Overview of ports and connections:
<div class="alert alert-info">
  <center><img title="Kong network overview" src="/assets/images/docs/networking.png"/></center>
</div>


### Proxy

The proxy ports is where Kong receives its incoming traffic. There are two ports with the following defaults;

* `8000` for proxying. This is where Kong listens for HTTP traffic. Be sure to change it to `80` once you go to production. See [proxy_listen].
* `8443` for proxying HTTPS traffic. Be sure to change it to `443` once you go to production. See [proxy_listen_ssl].

These are the **only ports** that should be made available to your clients.

### Management api

This is the port where Kong exposes its management api. Hence in production this port should be firewalled to protect
it from unauthorized access.

* `8001` provides Kong's **Admin API** that you can use to operate Kong. See [admin_api_listen].

### Clustering

This part is the hardest to get right in a multi-node cluster. Here there are also 2 parts: 

* `7373` used by Kong to communicate with the local clustering agent. See [cluster_listen_rpc]. The traffic here
  will be local to the Kong node and hence it does **not need to be exposed** anywhere.
* `7946` which Kong uses for intra-nodes communication. Both UDP and TCP traffic should be allowed on it. See [cluster_listen] 
  and [cluster_advertise]. The traffic on these ports should **only** be allowed between Kong nodes.

Kong will try to auto-detect the node's first, non-loopback, IPv4 address and advertise this address to other Kong nodes. 
Sometimes this is not enough and the IP address needs to be manually set, you can do that by changing the [cluster_listen] 
and [cluster_advertise] properties in the [cluster][cluster] configuration.

Diagram for intra-node port settings:
<div class="alert alert-info">
  <center><img title="Kong intra-node settings" src="/assets/images/docs/nat-clustering.png"/></center>
</div>

**Example**

A Kong node with a local ip address `192.168.23.45`, exposed to the rest of the Kong cluster through a NAT-layer on
ip address `192.168.10.5`. Where the NAT is configured to forward incoming connections on port `9000` to `80` on the 
local address, then the properties should be set as:

* `cluster_advertise=192.168.10.5:9000`
* `cluster_listen=192.168.23.45:80`


## Firewall

Below are the recommended firewall settings:

* The upstream APIs behind Kong will be available on [proxy_listen][proxy_listen] and [proxy_listen_ssl][proxy_listen_ssl]. 
  Configure these ports accordingly to the access level you wish to grant to the upstream APIs.
* **Protect** [admin_api_listen][admin_api_listen], and only allow trusted sources that can access the Admin API.
* Allow traffic on the [cluster_listen][cluster_listen] and [cluster_advertise][cluster_advertise] ports
  **only** between the Kong nodes. This port is used for intra-cluster communications.

## Network

Kong assumes a flat network topology in multi-datacenter setups. If you have a multi-datacenter setup, Kong nodes between the 
datacenters should communicate over a VPN connection.

[proxy_listen]: /{{page.kong_version}}/configuration/#proxy_listen
[proxy_listen_ssl]: /{{page.kong_version}}/configuration/#proxy_listen_ssl
[admin_api_listen]: /{{page.kong_version}}/configuration/#admin_api_listen
[cluster_listen]: /{{page.kong_version}}/configuration/#cluster_listen
[cluster_advertise]: /{{page.kong_version}}/configuration/#cluster_advertise
[cluster_listen_rpc]: /{{page.kong_version}}/configuration/#cluster_listen_rpc
[cluster]: /{{page.kong_version}}/configuration/#cluster
