---
title: General notes about Kuma policies
---

You may have already noticed that most `Kuma` policies have very similar structure, namely

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

where

* `sources` - a list of selectors to match those `Dataplanes` where network traffic originates
* `destinations` - a list of selectors to match those `Dataplanes` where network traffic destined at
* `conf` - configuration to apply to network traffic between `sources` and `destinations`

To keep configuration model simple and consistent, `Kuma` assumes that every `Dataplane` represents a `service`, even if it's a cron job that doesn't normally handle incoming traffic.

Consequently, `service` tag is mandatory for `sources` and `destinations` selectors.

If you need your policy to apply to every connection between `Dataplane`s, or simply don't know yet what is the right scope for that policy, you can always use `'*'` (wildcard) instead if the exact value.

E.g., the following policy will apply to network traffic between all `Dataplane`s

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

In contrast, the next policy will apply only to network traffic between  `Dataplane`s that represent `web` and `backend` services:

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

Finally, you can further limit the scope of a policy by including additional tags into `sources` and `destinations` selectors:

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

{% warning %}
While all policies support arbitrary tags in `sources` selectors, it's not generally the case for `destinations` selectors.

E.g., policies that get appied on the client side of a connection between 2 `Dataplane`s - such as `TrafficRoute`, `TrafficLog`, `HealthCheck` - only support `service` tag in `destinations` selectors.

In some cases there is a fundamental technical cause for that (e.g., `TrafficRoute`), in other cases it's a simplification of the initial implementation (e.g., `TrafficLog` and `HealthCheck`).

Please let us know if such constraints become critical to your use case.
{% endwarning %}