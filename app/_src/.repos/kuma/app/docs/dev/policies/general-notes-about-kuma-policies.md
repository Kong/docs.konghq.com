---
title: General notes about Kuma policies
---

{% tip %}
This only applies to source/destination policies.
If you are unfamiliar with these, checkout [introduction to policies](../introduction).
{% endtip %}

Policies applied to data plane proxies all follow the same basic structure:

```yaml
sources:
- match:
    kuma.io/service: ... # unique name OR '*'
    ... # (optionally) other tags

destinations:
- match:
    kuma.io/service: ... # unique name OR '*'
    ... # (optionally) other tags

conf:
  ... # policy-specific configuration
```

* sources - list of selectors that specify the dataplane objects where network traffic originates
* destinations - list of selectors that specify the dataplane object the source traffic is sent to
* conf - configuration to apply to network traffic between sources and destinations

{{site.mesh_product_name}} assumes that every dataplane object represents a service, even if it's a cron job that doesn't normally handle incoming traffic. This means the `kuma.io/service` tag is required for sources and destinations. Note the following requirements for values:

* The wildcard character (*) is supported only as the selector value to match all traffic.
* Tag values can contain only alphanumeric characters, dots (`.`), dashes (`-`), colons (`:`), and underscores (`_`).
* Selector values can contain only alphanumeric characters, dots (`.`), dashes (`-`), colons (`:`), underscores (`_`). slashes (`_`).

Tag and selector names can contain only alphanumeric characters, dots (`.`), dashes (`-`), colons (`:`), underscores (`_`), and slashes (`_`).

All policies support arbitrary tags for the `sources` selector, but there are tag limitations for the `destinations` selector. For example, policies that are applied on the client side of a connection between two dataplane objects do not support arbitrary tags in the `destinations` selector. Only the `kuma.io/service` tag is supported in this case. This includes TrafficRoute, TrafficLog, and HealthCheck.

For example, this policy applies to all network traffic between all dataplane objects:

```yaml
sources:
- match:
    kuma.io/service: '*'

destinations:
- match:
    kuma.io/service: '*'

conf:
  ...
```

This policy applies only to network traffic between dataplane objects for the specified services:

```yaml
sources:
- match:
    kuma.io/service: web

destinations:
- match:
    kuma.io/service: backend

conf:
  ...
```

You can provide additional tags to further limit policy scope:

```yaml
sources:
- match:
    kuma.io/service: web
    cloud:   aws
    region:  us

destinations:
- match:
    kuma.io/service: backend
    version: v2      # notice that not all policies support arbitrary tags in `destinations` selectors

conf:
  ...
```
