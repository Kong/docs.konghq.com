---
title: Default and Custom Networking Configuration for Kong Manager
badge: enterprise
---

## Default Configuration

By default, Kong Manager starts up without authentication (see
[`admin_gui_auth`]), and it assumes that the Admin API is available
on port 8001 (see [Default Ports](/gateway/{{page.kong_version}}/plan-and-deploy/default-ports) of the same host that serves
Kong Manager.

## Custom Configuration

Common configurations to enable are

* Serving Kong Manager from a dedicated Kong node

  When Kong Manager is on a dedicated Kong node, it must make
  external calls to the Admin API. Set [`admin_api_uri`] to the
  location of your Admin API.

* Securing Kong Manager through a **Kong Authentication Plugin**

  When Kong Manager is **secured through an Authentication Plugin**
  and _not_ on a dedicated node, it makes calls to the Admin API on
  the same host. By default, the Admin API listens on ports 8001 and
  8444 on localhost. Change [`admin_listen`] if necessary, or set
  [`admin_api_uri`].

{% include_cached /md/admin-listen.md desc='short' %}

* Securing Kong Manager and serving it from a dedicated node

  When Kong Manager is **secured and served from a dedicated node**,
  set [`admin_api_uri`] to the location of the Admin API.

The table below summarizes which properties to set (or defaults to
verify) when configuring Kong Manager connectivity to the Admin API.

| authentication enabled | local API    | remote API    | auth settings                                     |
|------------------------|--------------|---------------|---------------------------------------------------|
| yes                    | [`admin_listen`] | [`admin_api_uri`] | [`admin_gui_auth`], [`enforce_rbac`], [`admin_gui_auth_conf`], [`admin_gui_session_conf`] |
| no                     | [`admin_listen`] | [`admin_api_uri`] | n/a                                               |

To enable authentication, configure the following properties:

* [`admin_gui_auth`] set to the desired plugin
* [`admin_gui_auth_conf`] (optional)
* [`admin_gui_session_conf`] set to the desired configuration
* [`enforce_rbac`] set to `on`

{:.important}
> **Important:** When Kong Manager authentication is enabled, RBAC must be turned
on to enforce authorization rules. Otherwise, whoever can log in
to Kong Manager can perform any operation available on the Admin API.

## TLS Certificates

By default, if Kong Manager’s URL is accessed over HTTPS _without_ a certificate issued by a CA, it will
receive  a self-signed certificate that modern web browsers will not trust, preventing the application
from accessing the Admin API.

In order to serve Kong Manager over HTTPS,  use a trusted certificate authority to issue TLS certificates,
and have the resulting `.crt` and `.key` files ready for the next step.

1) Move `.crt` and `.key` files into the desired directory of the Kong node.

2) Point [`admin_gui_ssl_cert`] and [`admin_gui_ssl_cert_key`] at the absolute paths of the certificate and key.

```
admin_gui_ssl_cert = /path/to/test.crt
admin_gui_ssl_cert_key = /path/to/test.key
```

3) Ensure that `admin_gui_url` is prefixed with `https` to use TLS, e.g.,

```
admin_gui_url = https://test.com:8445
```

### Using https://localhost

If serving Kong Manager on localhost, it may be preferable to use HTTP as the protocol. If also using RBAC,
set `cookie_secure=false` in `admin_gui_session_conf`. The reason to use HTTP for `localhost` is that
creating TLS certificates for `localhost` requires more effort and configuration, and there may not be any
reason to use it. The adequate use cases for TLS are (1) when data is in transit between hosts, or (2)
when testing an application with [mixed content](https://developer.mozilla.org/en-US/docs/Web/Security/Mixed_content)
(which Kong Manager does not use).

External CAs cannot provide a certificate since no one uniquely owns `localhost`, nor is it rooted in a top-level
domain (e.g., `.com`, `.org`). Likewise, self-signed certificates will not be trusted in modern browsers. Instead,
it is necessary to use a private CA that allows you to issue your own certificates. Also ensure that the SSL state
is cleared from the browser after testing to prevent stale certificates from interfering with future access to
`localhost`.


[`admin_gui_auth`]: /gateway/{{page.kong_version}}/reference/configuration/#admin_gui_auth
[`admin_gui_ssl_cert`]: /gateway/{{page.kong_version}}/reference/configuration/#admin_gui_ssl_cert
[`admin_gui_ssl_cert_key`]: /gateway/{{page.kong_version}}/reference/configuration/#admin_gui_ssl_cert_key
[`default_ports`]: /gateway/{{page.kong_version}}/plan-and-deploy/default-ports
[`admin_api_uri`]: /gateway/{{page.kong_version}}/reference/configuration/#admin_api_uri
[`admin_gui_auth_conf`]: /gateway/{{page.kong_version}}/reference/configuration/#admin_gui_auth_conf
[`enforce_rbac`]: /gateway/{{page.kong_version}}/reference/configuration/#enforce_rbac
[`admin_listen`]: /gateway/{{page.kong_version}}/reference/configuration/#admin_listen
[`admin_gui_session_conf`]: /gateway/{{page.kong_version}}/reference/configuration/#admin_gui_session_conf
