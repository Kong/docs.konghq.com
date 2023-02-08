---

name: StatsD Advanced
publisher: Kong Inc.
version: 1.3-x

desc: Send metrics to StatsD with more flexible options
description: |
  Log [metrics](#metrics) for a Service, Route (or the deprecated API entity)
  to a StatsD server.
  It can also be used to log metrics on [Collectd](https://collectd.org/)
  daemon by enabling its [StatsD
  plugin](https://collectd.org/wiki/index.php/Plugin:StatsD).

enterprise: true
type: plugin
categories:
  - analytics-monitoring

kong_version_compatibility:
    community_edition:
      compatible:
    enterprise_edition:
      compatible:
        - 2.1.x
        - 1.5.x
        - 1.3-x
        - 0.36-x
        - 0.35-x
        - 0.34-x
---
