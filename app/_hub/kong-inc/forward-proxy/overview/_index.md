---
nav_title: Overview
---

The Forward Proxy plugin allows {{site.base_gateway}} to connect to intermediary transparent
HTTP proxies, instead of directly to the `upstream_url`, when forwarding requests
upstream. This is useful in environments where {{site.base_gateway}} sits in an organization's
internal network, the upstream API is available via the public internet, and
the organization proxies all outbound traffic through a forward proxy server.

The plugin attempts to transparently replace upstream connections made by Kong
core, sending the request instead to an intermediary forward proxy. Only
transparent HTTP proxies are supported; TLS connections (via `CONNECT`)
are not supported.

Note that this plugin can't be used with an [upstream](/gateway/latest/get-started/comprehensive/load-balancing/). 
As a workaround for load balancing,
configure the host field in service to a domain name so that you can
use a DNS-based load balancing technique.

