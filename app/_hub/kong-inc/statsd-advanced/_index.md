---
name: StatsD Advanced
publisher: Kong Inc.
desc: Send metrics to StatsD with more flexible options
description: |
  Log [metrics](#metrics) for a Service, route
  to a StatsD server.
  It can also be used to log metrics on [Collectd](https://collectd.org/)
  daemon by enabling its
  [StatsD plugin](https://collectd.org/wiki/index.php/Plugin:StatsD).

  {:.important}
  > Starting in Gateway version 3.0.x, StatsD Advanced has been combined with the open-sourced [StatsD](/hub/kong-inc/statsd/) plugin.
  StatsD Advanced has been deprecated.

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
    compatible: true
---
