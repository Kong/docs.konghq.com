---
name: Forward Proxy Advanced
publisher: Kong Inc.
version: 1.0.x
desc: Allows Kong to connect to intermediary transparent HTTP proxies
description: |
  The Forward Proxy plugin allows Kong to connect to intermediary transparent
   HTTP proxies, instead of directly to the upstream_url, when forwarding requests
   upstream. This is useful in environments where Kong sits in an organization's
   internal network, the upstream API is available via the public internet, and
   the organization proxies all outbound traffic through a forward proxy server.
enterprise: true
type: plugin
categories:
  - traffic-control
kong_version_compatibility:
  enterprise_edition:
    compatible:
      - 2.7.x

params:
  name: forward-proxy
  service_id: true
  route_id: true
  consumer_id: true
  dbless_compatible: 'yes'
  config:
    - name: proxy_host
      required: true
      default: null
      value_in_examples: example.com
      datatype: string
      description: |
        The hostname or IP address of the forward proxy to which to connect.
    - name: proxy_port
      required: true
      default: null
      value_in_examples: 80
      datatype: string
      description: |
        The TCP port of the forward proxy to which to connect.
    - name: proxy_scheme
      required: true
      default: http
      value_in_examples: http
      datatype: string
      description: |
        The proxy scheme to use when connecting. Only `http` is supported.
    - name: auth_username
      required: false
      default: null
      value_in_examples: example_user
      datatype: string
      description: |
        The username to authenticate with, if the forward proxy is protected
        by basic authentication.
    - name: auth_password
      required: false
      default: null
      value_in_examples: example_pass
      datatype: string
      description: |
        The password to authenticate with, if the forward proxy is protected
        by basic authentication.
    - name: https_verify
      required: true
      default: false
      value_in_examples: false
      datatype: boolean
      description: |
        Whether the server certificate will be verified according to the CA certificates
        specified in
        [lua_ssl_trusted_certificate](https://www.nginx.com/resources/wiki/modules/lua/#lua-ssl-trusted-certificate).

  extra: |

    The plugin attempts to transparently replace upstream connections made by Kong
    core, sending the request instead to an intermediary forward proxy. Only
    transparent HTTP proxies are supported; TLS connections (via `CONNECT`)
    are not supported.

---
## Changelog

### 1.0.6

* Added `auth_username` and `auth_password` parameters for proxy authentication.
