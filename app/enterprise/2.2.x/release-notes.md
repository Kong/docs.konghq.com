---
title: Kong Gateway (Enterprise) 2.2.x Release Notes
---

These release notes provide a high-level overview of {{site.ee_product_name}} 2.2.x,
which includes the 2.2.0.0 (beta) release. For detailed information about 2.2.x,
2.2.0.0 (beta), and any subsequent 2.2.x patch releases, see the
[Changelog](https://docs.konghq.com/gateway/changelog/).

## New Features

### UDP Support

{{site.ee_product_name}} now supports UDP-based protocols. UDP is used in a wide range
of applications, ranging from audio/video streaming to gaming servers to
financial services and much more, giving {{site.ee_product_name}} 2.2.x a wider range
of supported APIs.

{{site.ee_product_name}} 2.2.x adds support for proxying, load balancing, and running
plugins on UDP data, giving users similar functionality for UDP to what was
already available for TCP. When using Kong for load balancing, there is no
inherent sense of a stateful connection in UDP. Kong ensures
that incoming packets are balanced consistently across upstream services,
providing optimal cache use in those services.

The following plugins support UDP-based protocols:
* [Datadog](/hub/kong-inc/datadog)
* [File Log](/hub/kong-inc/file-log)
* [HTTP Log](/hub/kong-inc/http-log)
* [Loggly](/hub/kong-inc/loggly)
* [Kafka Log](/hub/kong-inc/kafka-log)
* [StatsD](/hub/kong-inc/statsd)
* [StatsD Advanced](/hub/kong-inc/statsd-advanced)
* [Syslog](/hub/kong-inc/syslog)
* [TCP Log](/hub/kong-inc/tcp-log)
* [UDP Log](/hub/kong-inc/udp-log)
* [Zipkin](/hub/kong-inc/zipkin)

### Security Improvements

{{site.ee_product_name}} 2.2.x has new features that help make security simpler and
more robust.

#### Automatically Trust OS Certificates

{{site.ee_product_name}} 2.2.x introduces the ability to automatically load certificates
that are pre-installed with the operating system (OS) using the
`lua_ssl_trusted_certificate` configuration option. This configuration also allows
multiple entries alongside the certificate file bundled with the OS. This
makes it easier operationally to support HTTPS services in the open internet
while also enabling custom certificates for internal services.

For more information, see the
[Configuration Property Reference](/enterprise/{{page.kong_version}}/property-reference/#lua_ssl_trusted_certificate).

#### Running Kong as a Non-Root User

Kong 2.2.x allows you to reduce risk level and help meet compliance needs by
allowing Kong to run as a non-root user. This is generally a best practice for
the principle of least privilege.

If you have been using our Docker images, we had already taken steps
before 2.2.x to build those images in a way adds a “kong” user and
grants that user access to the necessary files/directories. This new change
helps cover the remaining use cases for non-Dockerized installations.

For more information, see [Running Kong as a Non-Root User](/enterprise/{{page.kong_version}}/deployment/kong-user).

#### TLS Connections with Redis

{{site.ee_product_name}} 2.2.x can now establish TLS connections to the Redis
database. This feature is useful in, for example, the [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced)
and [Proxy Caching Advanced](/hub/kong-inc/proxy-cache-advanced) plugins.

#### OpenID Connect

{{site.ee_product_name}} 2.2.x introduces new features in the OpenID Connect plugin:
* Improved resilience to discovery (and rediscovery).
* Can now pass `urn:ietf:params:oauth:grant-type:jwt-bearer` assertions with the
`client_credentials` authentication method.
* New parameters:
  * Adds the ability to specify a salt for a cache key using `cache_tokens_salt`,
  so that if you have two instances of the OIDC plugin, you can avoid cache collisions.
  * Allows you to set valid issuers using `issuers_allowed`.
  * Allows you to manually define the user info endpoint using the new
  `userinfo_endpoint` setting.
  * Adds the ability to enable or disable the verification of tokens signed with
  HMAC (HS256, HS384, or HS512) algorithms using the new `enable_hs_signatures`
  parameter.
  * Adds the option to compress session data using
  the `session_compressor` parameter.

For more information, see the [Open ID Connect plugin](/hub/kong-inc/openid-connect).

### Performance Improvements

#### Hybrid Mode

Several improvements have been made to Hybrid Mode in Kong 2.2.x, most of which
are transparent for the user but result in an overall smoother scenario. One
notable improvement is a more efficient mechanism for communication between
Control Plane and Data Plane nodes, especially when the Data Planes are
receiving large and frequent updates.

Along with this improvement comes an upgrade to the Control Plane Cluster API,
which replaces the `/clustering/status` endpoint with the
`/clustering/data-planes` endpoint. This new endpoint provides information about
all Data Planes in the cluster, regardless of the Control Plane node to which
they are connected.

For more information, see [Hybrid Mode Setup](/enterprise/{{page.kong_version}}/deployment/hybrid-mode-setup/#step-4-verify-that-nodes-are-connected).

#### Request and Response Buffering

Another improvement for users who route large amounts of data through Kong is
that we’ve added the ability to disable buffering of requests and responses on
a per-Route basis, creating potential to greatly reduce latency.

## Deprecated Features

Kong Brain is no longer available for use in {{site.ee_product_name}} version 2.1.4.2
and later.

## Changelog

For a complete list of features, fixes, known issues and workarounds, and other
changes, see the {{site.ee_product_name}} [Changelog](/gateway/changelog/).
