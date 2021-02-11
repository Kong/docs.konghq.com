---
title: Kong Gateway (Enterprise) 2.3.x Release Notes
---
These release notes provide a high-level overview of Kong Gateway (Enterprise) 2.3.x,
which includes the 2.3.2.0 release. For detailed information about 2.3.x, 
and any subsequent 2.3.x patch releases, see the
[Changelog](https://docs.konghq.com/enterprise/changelog/).

## Overview
Kong Gateway (Enterprise) version 2.3.x now has a “free” operating mode. This free mode
allows anyone to use the Enterprise gateway product, which was previously reserved for 
paying customers. With or without a paid Kong subscription, you can now download the 
Enterprise version of Kong Gateway for free. Go to [Install Kong](https://konghq.com/install/). 

## New Features

### Kong Gateway (Enterprise) is available in free mode
The biggest change for Kong's 2.3 gateway is that anyone can now download 
**Kong Gateway (Enterprise)**, formerly known as **Kong Enterprise**, for free
and without any paywall or forms to fill out. 

This Enterprise edition of our gateway is built on our open source gateway, and notably
includes the Kong Manager user interface which you can use to configure routes, services,
plugins and consumers. If you are new to Kong, we think this is the easiest, fastest and
best way for you to get started.

For existing Kong customers, or if you are considering becoming one, note that the
Enterprise gateway continues to have differentiated features for those with paid licenses. 
In order to use our [OIDC plugin](https://docs.konghq.com/hub/kong-inc/openid-connect/), [Vitals](https://docs.konghq.com/enterprise/2.2.x/vitals/overview/) and other paid Enterprise
features, you’ll need a paid [Kong Konnect license](https://konghq.com/kong-konnect).
You’ll have the option of either running the control plane for your paid license on our
SaaS-hosted service and bringing your own dataplane, or managing it yourself using our 
self-hosted version. For more information about what you get with a subscription, 
see [Kong subscriptions](https://konghq.com/subscriptions/).

Because the Enterprise version of the gateway is no longer *only* applicable to our
“Enterprise” subscription package and can also be run in a free mode, we will be removing
the “Enterprise” terminology in future releases and referring instead to this package as
the “Kong Gateway.” In order to avoid any confusion/conflation with the Apache 2.0 licensed
builds, we will specifically call out “OSS” as in “Kong Gateway (OSS)” when referring to
that build.

### Simplified License Management
The Kong Gateway 2.3 brings simplified license management that makes license management
easier than before for multiple data planes. If you are a customer bringing your own
license, you only need to apply licenses to the Control Plane (CP) to have the licenses
distributed down to any of the connected Data Planes (DPs) within the cluster. This should
help avoid complex updating and restarting of data planes.

#### Kong ❤️ UTF-8
Kong Gateway 2.3 now accepts UTF-8 characters in route and service names. Being able to have
the gateway support your native character set is important, so now if you want to give a route
a name using character sets for Russian, Japanese, Chinese or any number of other languages,
you can do so with Kong Gateway 2.3 (and yes, emojis are now valid for use in route and
service names as well 😊).

#### New Plugin capabilities
The [Enterprise Rate Limiting Advanced plugin](https://docs.konghq.com/hub/kong-inc/rate-limiting-advanced/)
has a new configuration parameter (`retry_after_jitter_max`) to allow for an additional randomized delay,
or jitter, to the “Retry-After” header.

The [HTTP Log plugin](https://docs.konghq.com/hub/kong-inc/http-log/) is improved to allow you
to add headers to the HTTP request. This will help you integrate with many observability systems,
including Splunk, the Elastic Stack (“ELK”) and others.

Both the [Key Authentication plugin](https://docs.konghq.com/hub/kong-inc/key-auth/) and the
Enterprise [Key Authentication - Encrypted plugin](https://docs.konghq.com/hub/kong-inc/key-auth-enc/)
have two new configuration parameters: `key_in_header` and `key_in_query`. Both are booleans and
tell Kong whether to accept (true) or reject (false) passed in either the header or the query string.
Both default to true.

The [Request Size Limiting plugin](https://docs.konghq.com/hub/kong-inc/request-size-limiting/)
has a new configuration `require_content_length` that causes the plugin to ensure a valid
`Content-Length` header exists before reading the request body.

### More features and fixes
Kong Gateway 2.3 introduces some additional new features and fixes, including:
- **Postgres connections** can now be made using mTLS and SCRAM-SHA-256/SCRAM-SHA-256-PLUS
authentication.
- **Kong Gateway 2.3 now checks for version compatibility** between the control plane and
any data planes to ensure the data planes and any plugins have compatibility with the
control plane in hybrid mode.
- **Certificates now have `cert_alt` and `key_alt` fields** to specify an alternative
certificate and key pair.
- **The go-pluginserver stderr and stdout** are now written into Kong's logs, allowing
Golang’s native `log.Printf()`.
- **`client_max_body_size` and `client_body_buffer_size` are now configurable**. These
two parameters used to be hardcoded and set to 10m.
- **Custom plugins can now make use of new functionality**: 
  - `kong.node.get_hostname` unsurprisingly returns the hostname of the Kong node.
  - `kong.cluster.get_id` returns a unique global cluster ID (or `nil` if running in a
  declarative configuration).
  - `kong.log.set_serialize_value()` can now be used to set the format of log serialization
  in a custom plugin.

## Deprecated features
Kong Studio and Insomnia Designer are deprecated in Kong Gateway (Enterprise) 2.3. 
A redirect to [Insomnia](https://insomnia.rest/) will be added soon.

## Changelog
For a complete list of features, fixes, known issues and workarounds, and other
changes, see the Kong Gateway (Enterprise) [Changelog](/enterprise/changelog/).
