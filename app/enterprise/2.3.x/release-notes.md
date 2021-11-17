---
title: Kong Gateway (Enterprise) 2.3.x Release Notes
---
These release notes provide a high-level overview of Kong Gateway (Enterprise) 2.3.x,
which includes the 2.3.2.0 release. For detailed information about 2.3.x,
and any subsequent 2.3.x patch releases, see the
[Changelog](/gateway/changelog/).

## New Features

### Kong Gateway (Enterprise) is available in free mode
Starting in this release, anyone can now download
**Kong Gateway (Enterprise)**, formerly known as **Kong Enterprise**, in a free
mode, and without any paywall or forms to fill out.

The free mode allows anyone to use the Enterprise gateway, which was
previously reserved for paying customers. With or without a paid subscription,
you can now **download Kong Gateway for free**, then optionally add an Enterprise
license to it. The free mode gives you access to Kong Manager and an
easy upgrade path to an Enterprise subscription, if that's ever desired.

A [Kong Konnect license](https://konghq.com/kong-konnect) is still
required for Enterprise features, such as the
[OIDC plugin](/hub/kong-inc/openid-connect/),
[Vitals](/enterprise/{{page.kong_version}}/vitals/overview/),
[Dev Portal](/enterprise/{{page.kong_version}}/developer-portal), and others.

Learn more:
* [Kong subscriptions](https://konghq.com/subscriptions/)
* [Learn about free and enterprise modes](/enterprise/{{page.kong_version}}/deployment/licensing/)
* [Install Kong Gateway](https://konghq.com/install/)

### Name changes

Because the Enterprise version of the gateway is no longer *only* applicable to
the Enterprise subscription package and can also run in a free mode, we will
be removing the "Enterprise" terminology in future releases and referring to
this package simply as **Kong Gateway**.

In the documentation, the following applies:
* Kong Enterprise &#8594; Kong Gateway (Enterprise), or simply Kong Gateway
* Kong Gateway Community &#8594; Kong Gateway (OSS)

The documentation will fully transition to this terminology over time.

### Simplified license management in Hybrid mode
In 2.3, Kong Gateway introduces simplified license management for multiple data
planes in hybrid mode. If you have an Enterprise license, you only need to
apply the license to the control plane (CP) of a cluster. The control plane will
distribute that license to any connected data planes (DPs) within that same
cluster.

#### Kong ❤️ UTF-8
Kong Gateway 2.3 now accepts UTF-8 characters in route and service names. Being
able to have the gateway support your native character set is important, so now
if you want to give a route a name using character sets for Russian, Japanese,
Chinese or any number of other languages, you can do so with Kong Gateway 2.3
(and yes, emojis are now valid for use in route and service names as well 😊).

#### New Plugin capabilities
The [Rate Limiting Advanced plugin](https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/)
has a new configuration parameter (`retry_after_jitter_max`) to allow for an
additional randomized delay, or jitter, to the `Retry-After` header.

The [HTTP Log plugin](https://docs.konghq.com/hub/kong-inc/http-log/) now allows
you to add headers to the HTTP request. This will help you integrate with many
observability systems, including Splunk, the Elastic Stack (“ELK”), and others.

Both the [Key Authentication plugin](https://docs.konghq.com/hub/kong-inc/key-auth/)
and the Enterprise [Key Authentication - Encrypted plugin](https://docs.konghq.com/hub/kong-inc/key-auth-enc/)
have two new configuration parameters: `key_in_header` and `key_in_query`. Both
are booleans and tell the gateway whether to accept (`true`) or reject (`false`)
a key passed in either the header or the query string. Both default to `true`.

The [Request Size Limiting plugin](https://docs.konghq.com/hub/kong-inc/request-size-limiting/)
has a new configuration parameter (`require_content_length`) that causes the
plugin to ensure a valid `Content-Length` header exists before reading the
request body.

### More features and fixes
Kong Gateway 2.3 introduces some additional new features and fixes, including:
- **Postgres connections** can now be made using mTLS and SCRAM-SHA-256/SCRAM-SHA-256-PLUS
authentication.
- **Kong Gateway 2.3 now checks for version compatibility** between the control plane and
any data planes to ensure the data planes and any plugins have compatibility with the
control plane in hybrid mode.
- **Certificates now have `cert_alt` and `key_alt` fields** to specify an alternative
certificate and key pair.
- **The go-pluginserver stderr and stdout** are now written into Kong Gateway's
logs, allowing Golang’s native `log.Printf()`.
- **`client_max_body_size` and `client_body_buffer_size` are now configurable**.
These two parameters used to be hardcoded and set to 10m.
- **Custom plugins can now make use of new functionality**:
  - `kong.node.get_hostname` returns the hostname of the Kong Gateway node.
  - `kong.cluster.get_id` returns a unique global cluster ID (or `nil` if running in a
  declarative configuration).
  - `kong.log.set_serialize_value()` can now be used to set the format of log
  serialization in a custom plugin.

## Deprecated features
The Kong Studio plugin bundle is deprecated. It is
replaced with tighter Insomnia integration in [Insomnia 2021.1.0](https://insomnia.rest/changelog#2021.1.0).

## Changelog
For a complete list of features, fixes, known issues and workarounds, and other
changes, see the Kong Gateway (Enterprise) [Changelog](/gateway/changelog/).
