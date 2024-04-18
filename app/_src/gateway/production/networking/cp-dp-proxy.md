---
title: Control Plane and Data Plane Communication through a Forward Proxy
content_type: reference
---

If your control plane and data planes run on different sides of a firewall
that runs external communications through a proxy, you can configure
{{site.base_gateway}} to authenticate with the proxy server and allow
traffic through.

{{site.base_gateway}} only supports [HTTP CONNECT](https://httpwg.org/specs/rfc9110.html#CONNECT) proxies. 

{:.important}
> This feature does not support mTLS termination.

## Set up forward proxy connection

In [`kong.conf`](/gateway/{{page.release}}/production/kong-conf/),
configure the following parameters:

```
proxy_server = http(s)://<username>:<password>@<proxy-host>:<proxy-port>
proxy_server_tls_verify = on/off
cluster_use_proxy = on
lua_ssl_trusted_certificate = system | <certificate> | <path-to-cert>
```

* `proxy_server`: Proxy server defined as a URL. {{site.base_gateway}} will
only use this option if any component is explicitly configured to use the proxy.

* `proxy_server_tls_verify`: Toggles server certificate verification if
`proxy_server` is in HTTPS. Set to `on` if using HTTPS (default), or `off` if
using HTTP.

* `cluster_use_proxy`: Tells the cluster to use HTTP CONNECT proxy support for
hybrid mode connections. If turned on, {{site.base_gateway}} will use the
URL defined in `proxy_server` to connect.

* `lua_ssl_trusted_certificate` (*Optional*): If using HTTPS, you can also
specify a custom certificate authority with `lua_ssl_trusted_certificate`. If
using the [system default CA](/gateway/{{page.release}}/reference/configuration/#lua_ssl_trusted_certificate),
you don't need to change this value.

Reload {{site.base_gateway}} for the connection to take effect:

```
kong reload
```
