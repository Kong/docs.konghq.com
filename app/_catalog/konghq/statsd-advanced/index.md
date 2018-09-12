---

name: StatsD Advanced

desc: Send metrics to StatsD with more flexible options
description: |
  Log [metrics](#metrics) for a Service, Route (or the deprecated API entity)
  to a StatsD server.
  It can also be used to log metrics on [Collectd](https://collectd.org/)
  daemon by enabling its [StatsD
  plugin](https://collectd.org/wiki/index.php/Plugin:StatsD).

  * [Detailed documentation for the StatsD Advanced Plugin](/enterprise/latest/plugins/statsd-advanced/)

enterprise: true
type: plugin
categories:
  - logging

kong_version_compatibility:
    community_edition:
      compatible:
    enterprise_edition:
      compatible:
        - 0.34-x
        - 0.33-x

---
