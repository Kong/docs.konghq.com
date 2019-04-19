---

name: Forward Proxy Advanced
publisher: Kong Inc.
version: 0.34-x

desc: Allows Kong to connect to intermediary transparent HTTP proxies
description: |
  The Forward Proxy plugin allows Kong to connect to intermediary transparent HTTP proxies, instead of directly to the upstream_url, when forwarding requests upstream. This is useful in environments where Kong sits in an organization's internal network, the upstream API is available via the public internet, and the organization proxies all outbound traffic through a forward proxy server.

enterprise: true
type: plugin
categories:
  - traffic-control

kong_version_compatibility:
    community_edition:
      compatible:
    enterprise_edition:
      compatible:
        - 0.34-x

params:
  name: forward-proxy
  api_id: true
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: proxy_host
      required:
      default:
      value_in_examples:
      description: |
        The hostname or IP address of the forward proxy to which to connect
    - name: proxy_port
      required:
      default:
      value_in_examples:
      description: |
        The TCP port of the forward proxy to which to connect
    - name: proxy_scheme
      required:
      default: http
      value_in_examples:
      description: |
        The proxy scheme to use when connecting. Currently only `http` is supported

---

### Notes

The plugin attempts to transparently replace upstream connections made by Kong core, sending the request instead to an intermediary forward proxy. Currently only transparent HTTP proxies are supported; TLS connections (via `CONNECT`) are not yet supported.

---
