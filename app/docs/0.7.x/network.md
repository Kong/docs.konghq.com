---
title: Network & Firewall
---

# Network & Firewall

In this section you will find a summary about the recommended network and firewall settings for Kong.

## Ports

These are the port settings in order for Kong to work:

* Allow HTTP traffic to [proxy_listen][proxy_listen]. By default `8000`.
* Allow HTTPs traffic to [proxy_listen_ssl][proxy_listen_ssl]. By default `8443`.
* Allow HTTP traffic to [admin_api_listen][admin_api_listen]. By default `8001`.
* Allow **both** TCP and UDP traffic to [cluster_listen][cluster_listen]. By default `7946`.

## Firewall

Below are the recommended firewall settings:

* The upstream APIs behind Kong will be available on [proxy_listen][proxy_listen] and [proxy_listen_ssl][proxy_listen_ssl]. Configure these ports accordingly to the access level you wish to grant to the upstream APIs.
* **Protect** [admin_api_listen][admin_api_listen], and only allow trusted sources that can access the Admin API.
* Allow traffic on [cluster_listen][cluster_listen] port **only** between other Kong nodes. This port is used for infra-cluster communications.

## Network

Kong assumes a flat network topology in multi-datacenter setups. If you have a multi-datacenter setup, Kong nodes between the datacentes should communicate over a VPN connection.

Kong will try to auto-detect the node's first, non-loopback, IPv4 address and advertise this address to other Kong nodes. Sometimes this is not enough and the IP address needs to be manually set, you can do that by changing the `advertise` property in the [cluster][cluster] configuration.

[proxy_listen]: /docs/{{page.kong_version}}/configuration/#proxy_listen
[proxy_listen_ssl]: /docs/{{page.kong_version}}/configuration/#proxy_listen_ssl
[admin_api_listen]: /docs/{{page.kong_version}}/configuration/#admin_api_listen
[cluster_listen]: /docs/{{page.kong_version}}/configuration/#cluster_listen
[cluster]: /docs/{{page.kong_version}}/configuration/#cluster
