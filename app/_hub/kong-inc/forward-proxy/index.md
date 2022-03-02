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
enterprise: true
type: plugin
categories:
  - traffic-control
kong_version_compatibility:
  enterprise_edition:
    compatible:
      - 2.8.x

params:
  name: forward-proxy
  service_id: true
  route_id: true
  consumer_id: true
  dbless_compatible: 'yes'
  config:
    - name: http_proxy_host
      required: semi
      default: null
      value_in_examples: http://example.com
      datatype: string
      description: |
        The HTTP hostname or IP address of the forward proxy to which to connect.
        Required if `http_proxy_port` is set.

        At least one of `http_proxy_host` or `https_proxy_host` must be specified.
    - name: http_proxy_port
      required: semi
      default: null
      value_in_examples: 80
      datatype: string
      description: |
        The TCP port of the HTTP forward proxy to which to connect.
        Required if `http_proxy_host` is set.

        At least one of `http_proxy_port` or `https_proxy_port` must be specified.
    - name: https_proxy_host
      required: semi
      default: null
      value_in_examples:
      datatype: string
      description: |
        The HTTPS hostname or IP address of the forward proxy to which to connect.
        Required if `https_proxy_port` is set.

        At least one of `http_proxy_host` or `https_proxy_host` must be specified.
    - name: https_proxy_port
      required: semi
      default: null
      value_in_examples:
      datatype: string
      description: |
        The TCP port of the HTTPS forward proxy to which to connect.
        Required if `https_proxy_host` is set.

        At least one of `http_proxy_port` or `https_proxy_port` must be specified.
    - name: proxy_host
      required: false
      default: null
      value_in_examples:
      datatype: string
      description: |

        {:.important}
        > This parameter is deprecated as of Kong Gateway 2.8.0.0 and
        is planned to be removed in 3.x.x.
        > <br>
        > Use `http_proxy_host` or `https_proxy_host` instead.

        The hostname or IP address of the forward proxy to which to connect.
    - name: proxy_port
      required: false
      default: null
      value_in_examples:
      datatype: string
      description: |

        {:.important}
        > This parameter is deprecated as of Kong Gateway 2.8.0.0 and
        is planned to be removed in 3.x.x.
        > <br>
        > Use `http_proxy_host` or `https_proxy_host` instead.

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

        This field is _referenceable_, which means it can be securely stored as a
        [secret](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started)
        in a vault. References must follow a [specific format](/gateway/latest/plan-and-deploy/security/secrets-management/reference-format).
    - name: auth_password
      required: false
      default: null
      value_in_examples: example_pass
      datatype: string
      description: |
        The password to authenticate with, if the forward proxy is protected
        by basic authentication.

        This field is _referenceable_, which means it can be securely stored as a
        [secret](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started)
        in a vault. References must follow a [specific format](/gateway/latest/plan-and-deploy/security/secrets-management/reference-format).
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

### Kong Gateway 2.8.x (plugin version 1.2.0)

* Added `http_proxy_host`, `http_proxy_port`, `https_proxy_host`, and
`https_proxy_port` configuration parameters for mTLS support.

    {:.important}
    > These parameters replace the `proxy_port` and `proxy_host` fields, which
    are now **deprecated** and planned to be removed in 3.x.x.

* The `auth_password` and `auth_username` configuration fields are now marked as
referenceable, which means they can be securely stored as
[secrets](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started)
in a vault. References must follow a [specific format](/gateway/latest/plan-and-deploy/security/secrets-management/reference-format).

* Fixed a plugin version in the documentation. Previously, there was a plugin
version labelled as `1.0.x`. It is now updated to align with the
plugin's actual version, `1.1.x`.

### Kong Gateway 2.7.x (plugin version 1.1.0)

* Added `auth_username` and `auth_password` parameters for proxy authentication.
