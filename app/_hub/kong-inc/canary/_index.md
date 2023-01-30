---
name: Canary Release
publisher: Kong Inc.
desc: Slowly roll out software changes to a subset of users
description: |
  Reduce the risk of introducing a new software version in production by slowly
  rolling out the change to a small subset of users. This plugin also enables rolling
  back to your original upstream service, or shifting all traffic to the new version.
enterprise: true
type: plugin
categories:
  - traffic-control
kong_version_compatibility:
  enterprise_edition:
    compatible: true
---

### Usage

The Canary Release plugin allows you to route traffic to two separate upstream
**Services** referred to as _Service A_ and _Service B_. The location of _Service A_
is defined by the `service` entity for the request being proxied. The location
of _Service B_ is defined by the
`config.upstream_host`, `config.upstream_port`, and/or `config.upstream_uri` as
configured on the plugin.

There are 3 modes of operation:

1. Set a fixed percentage to be routed to _Service B_. See parameter
   `config.percentage`.
2. Define an allow or deny group comprised of Consumers with allowed or denied access to _Service B_.
   The Consumer-group association can be configured using the [ACL plugin](/hub/kong-inc/acl/).
3. Set a period (in linear time) over which the traffic will be transferred
   from _Service A_ to _Service B_. See parameters `config.start` and
   `config.duration`.

### Determining Where to Route a Request

(This does not apply to allowing or denying groups).

The Canary Release plugin defines a number of "buckets" (`config.steps`).
Each of these buckets can be routed to either _Service A_ or _Service B_.

For example: If you set `config.steps` to 100 steps, and `percentage` to 10%,
Canary will create 100 "buckets", 10 of which will be routed to _Service B_,
while the other 90 will remain routed to _Service A_.

The `config.hash` parameter determines which requests end up in a specific bucket.
When set to `consumer`, Canary ensures each Consumer will
consistently end up in the same bucket. The effect is that once a Consumer's bucket
switches to _Service B_, it will then always go to
_Service B_, and will not flip-flop between A and B. Alternatively, if it is set to
`ip` or `header`, then the same concept applies but on the basis of the originating IP address
or header value.

When using either the `consumer`, `header`, or `ip` setting, if any specific Consumer, Header, or IP
is responsible for more than the average percentage of traffic, the migration
may not be evenly distributed, e.g., if the percentage is set to 50%, then 50% of
either the Consumers or IPs will be rerouted, but not necessarily 50% of the total requests.

When set to `none`, the requests will be evenly distributed; each bucket
will get the same number of requests, but a Consumer or IP might flip-flop between
_Service A_ and _Service B_ on consecutive requests.

Canary provides an automatic fallback if, for some reason, a Consumer, Header, or IP can
not be identified. The fallback order is `consumer`->`ip`->`none`.

{% if_plugin_version gte:2.8.x %}
### Overriding the Canary

In some cases, you may want to allow clients to pick _Service A_ or _Service B_
instead of applying the configured canary rules. By setting the `config.canary_by_header_name`,
clients can send the value `always` to always use the canary service (_Service B_) or send the
value `never` to never use the canary service (always use _Service A_).

{% endif_plugin_version %}

### Finalizing the Canary

Once the Canary is complete, either going to 100% for a percentage-based Canary,
or when the timed Canary has reached 100%, the configuration will need to be updated.
Note: If the plugin is configured on a `route`, then all routes for the current
`service` must have completed the Canary.

1. Update the `service` entity to point to _Service B_ by matching it to the URL as
specified by `config.upstream_host`, `config.upstream_uri`, and  `config.upstream_port`.
2. Remove the Canary plugin with a `DELETE` request.

Removing or disabling the Canary Release plugin before the Canary is complete will
instantly switch all traffic to _Service A_.


### Upstream Healthchecks

The configuration item `upstream_fallback` uses
[**Upstream Healthchecks**](/gateway/latest/admin-api/#upstream-object)
to skip applying the Canary upstream if it does not have at least one healthy
target. For this configuration to take effect, the following conditions must be met:

 - As this configuration relies on Kong's balancer (and healthchecks),
 the name specified in `config.upstream_host` must point to a valid Kong Upstream
 object
 - [**Healthchecks**](/gateway/latest/reference/health-checks-circuit-breakers/#enabling-and-disabling-health-checks) are
 enabled in the canary upstream, i.e., the upstream specified in `upstream_host`
 needs to have healthchecks enabled it. It works with both passive and active
 healthchecks.

---
<<<<<<< HEAD

## Changelog

**{{site.base_gateway}} 3.2.x**
* The `start` field now defaults to the current timestamp.

**{{site.base_gateway}} 2.8.x**
* Added the `canary_by_header_name` configuration parameter.

**{{site.base_gateway}} 2.1.x**
* Use `allow` and `deny` instead of `whitelist` and `blacklist` in the `groups` parameter.
* Added the `hash_header` configuration parameter.
=======
>>>>>>> 2bf6ac1fa1 ([Plugin Hub] Split `_index.md` into several files)
