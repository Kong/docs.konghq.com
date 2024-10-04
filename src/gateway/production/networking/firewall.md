---
title: Network and Firewall
content_type: reference
---

In this section you will find a summary about the recommended network and firewall settings for Kong.

## Ports

Kong uses multiple connections for different purposes.

* proxy
* admin api

### Proxy

The proxy ports is where Kong receives its incoming traffic. There are two ports with the following defaults:

* `8000` for proxying HTTP traffic, and
* `8443` for proxying HTTPS traffic

See [proxy_listen] for more details on HTTP/HTTPS proxy listen options. For production environment it is common
to change HTTP and HTTPS listen ports to `80` and `443`.

Kong can also proxy TCP/TLS streams. The stream proxying is disabled by default. See [stream_listen] for
additional details on stream proxy listen options, and how to enable it (if you plan to proxy anything other than
HTTP/HTTPS traffic).

In general the proxy ports are the **only ports** that should be made available to your clients.

### Admin API

This is the port where Kong exposes its management API. Hence in production this port should be firewalled to protect
it from unauthorized access.

* `8001` provides Kong's **Admin API** that you can use to operate Kong with HTTP. See [admin_listen].

{% include_cached /md/admin-listen.md desc='short' release=page.release %}

* `8444` provides the same Kong **Admin API** but using HTTPS. See [admin_listen] and the `ssl` suffix.

## Firewall

Below are the recommended firewall settings:

* The upstream Services behind Kong will be available via the [proxy_listen] interface/port values.
  Configure these values according to the access level you wish to grant to the upstream Services.
* If you are binding the Admin API to a public-facing interface (via [admin_listen]), then **protect** it to only
  allow trusted clients to access the Admin API. See also [Securing the Admin API][secure_admin_api].
* Your proxy will need have rules added for any HTTP/HTTPS and TCP/TLS stream listeners that you configure.
  For example, if you want Kong to manage traffic on port `4242`, your firewall will need to allow traffic
  on said port.



[proxy_listen]: /gateway/{{page.release}}/reference/configuration/#proxy_listen
[stream_listen]: /gateway/{{page.release}}/reference/configuration/#stream_listen
[admin_listen]: /gateway/{{page.release}}/reference/configuration/#admin_listen
[secure_admin_api]: /gateway/{{page.release}}/production/running-kong/secure-admin-api
