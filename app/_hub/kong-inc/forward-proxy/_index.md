---
name: Forward Proxy Advanced
publisher: Kong Inc.
version: 1.2.x
desc: Allows Kong to connect to intermediary transparent HTTP proxies
description: |
  The Forward Proxy plugin allows Kong to connect to intermediary transparent
   HTTP proxies, instead of directly to the upstream_url, when forwarding requests
   upstream. This is useful in environments where Kong sits in an organization's
   internal network, the upstream API is available via the public internet, and
   the organization proxies all outbound traffic through a forward proxy server.
   Please note that this plugin can't be used with an [upstream](/gateway/latest/get-started/comprehensive/load-balancing/). As a workaround for load balancing,
   configure the host field in service to a domain name so that you can
   use a DNS-based load balancing technique.
enterprise: true
type: plugin
categories:
  - traffic-control
kong_version_compatibility:
  enterprise_edition:
    compatible: true
---

