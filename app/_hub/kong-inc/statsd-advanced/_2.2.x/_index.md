---
name: StatsD Advanced
publisher: Kong Inc.
version: 2.2.x
desc: Send metrics to StatsD with more flexible options
description: |
  Log [metrics](#metrics) for a Service, route
  to a StatsD server.
  It can also be used to log metrics on [Collectd](https://collectd.org/)
  daemon by enabling its
  [StatsD plugin](https://collectd.org/wiki/index.php/Plugin:StatsD).

  The StatsD Advanced plugin provides
  features not available in the open-source [StatsD](/hub/kong-inc/statsd/) plugin, such as:
  * Ability to choose status codes to log to metrics.
  * More granular status codes per workspace.
  * Ability to use TCP instead of UDP.
enterprise: true
type: plugin
categories:
  - analytics-monitoring
kong_version_compatibility:
  community_edition:
    compatible: null
  enterprise_edition:
    compatible:
    - 2.8.x
    - 2.7.x
    - 2.6.x
    - 2.5.x
    - 2.4.x
    - 2.3.x
    - 2.2.x
    - 2.1.x
    - 1.5.x
    - 1.3-x
    - 0.36-x
---
