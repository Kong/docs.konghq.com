---
title: Konnect SaaS Updates
no_version: true
skip_read_time: true
---

The updates contained in this topic apply to {{site.konnect_short_name}}
SaaS, an application that lets you manage configuration for multiple runtimes
from a single, cloud-based control plane, and provides a catalog of all deployed
services.

### February 23, 2021

**{{site.base_gateway}} 2.3 support**
: {{site.konnect_short_name}} SaaS now supports {{site.base_gateway}} 2.3
runtimes. There is no upgrade path for existing runtimes.
: To use {{site.base_gateway}} 2.3, [reprovision a new runtime](/konnect/runtime-manager/kong-gateway-runtime).

**Advanced runtime configuration**
: You can now configure custom {{site.base_gateway}} data planes through the
Runtime Manager and run gateway instances outside of Docker. Use the
[advanced option](/konnect/runtime-manager/kong-gateway-runtime/) when
configuring a new runtime to get started.

**Logging plugins**
: The full set of {{site.base_gateway}}'s logging plugins is now available
through {{site.konnect_short_name}} SaaS. This includes:
* [File Log](/hub/kong-inc/file-log)
* [HTTP Log](/hub/kong-inc/http-log)
* [Kafka Log](/hub/kong-inc/kafka-log)
* [Loggly](/hub/kong-inc/loggly)
* [StatsD](/hub/kong-inc/statsd)
* [StatsD Advanced](/hub/kong-inc/statsd-advanced)
* [Syslog](/hub/kong-inc/syslog)
* [TCP Log](/hub/kong-inc/tcp-log)
* [UDP Log](/hub/kong-inc/udp-log)

### February 10, 2021

**Portal authentication**
: You can now [disable authentication on a Dev Portal](/konnect/dev-portal/administrators/public-portal/),
which exposes the Dev Portal publicly to anyone with the link. No one needs to register
for Dev Portal access.
: New application registrations aren't available through a public-facing portal.

### February 1, 2021

{{site.konnect_product_name}} ({{site.konnect_short_name}}) is now generally available!

To get started with {{site.konnect_short_name}}, see:
- [Quickstart Guide](/konnect/getting-started/configure-runtime/)
- [Kong {{site.konnect_short_name}} Overview](/konnect/overview/)
- [Using the {{site.konnect_short_name}} Docs](/konnect/using-konnect-docs/)

For more information about {{site.konnect_short_name}}, contact your Kong sales
representative.
