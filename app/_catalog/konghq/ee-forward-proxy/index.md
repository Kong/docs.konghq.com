---

name: EE Forward Proxy

desc: Allows Kong to connect to intermediary transparent HTTP proxies
description: |
  The Forward Proxy plugin allows Kong to connect to intermediary transparent HTTP proxies, instead of directly to the upstream_url, when forwarding requests upstream. This is useful in environments where Kong sits in an organization's internal network, the upstream API is available via the public internet, and the organization proxies all outbound traffic through a forward proxy server.

  * [Detailed documentation for the EE Forward Proxy Plugin](/enterprise/latest/plugins/forward-proxy/)

type: plugin
categories:
  - traffic-control

---
