---
name: Canary Release
publisher: Kong Inc.
version: 0.5.x

desc: Slowly roll out software changes to a subset of users
description: |
  Reduce the risk of introducing a new software version in production by slowly
  rolling out the change to a small subset of users. This plugin also enables rolling
  back to your original upstream service, or shifting all traffic to the new version.

enterprise: true
type: plugin
categories:
  - traffic-control

type: plugin
categories:
  - traffic-control

kong_version_compatibility:
    enterprise_edition:
      compatible:
        - 2.4.x
        - 2.3.x
        - 2.2.x
        - 2.1.x
        - 1.5.x
        - 1.3-x
        - 0.36-x

params:
  name: canary
  service_id: true
  route_id: true
  consumer_id: false
  dbless_compatible: yes
  config:
    - name: start
      required: semi
      default:
      value_in_examples:
      datatype: number
      description: |
        Future time in seconds since epoch, when the canary release will start.
        Ignored when `percentage` is set, or when using `allow` or `deny` in `hash`.
    - name: duration
      required:
      default: 3600
      value_in_examples:
      datatype: number
      description: |
       The duration of the transition in seconds. Ignored when `percentage` is set, or
       when using `allow` or `deny` in `hash`.
    - name: percentage
      required: semi
      default:
      value_in_examples: 50
      datatype: number
      description: |
        Fixed percentage of traffic to be routed to new target, if given overrides `start` and `duration`. The
        value must be between 0 and 100.
    - name: steps
      required:
      default: 1000
      value_in_examples:
      datatype: number
      description: |
        Number of steps the release should be broken into.
    - name: upstream_host
      required: semi
      default:
      value_in_examples: example.com
      datatype: string
      description: |
        The target hostname where traffic will be routed. Required if `upstream_uri` and `upstream_port` are not set.
    - name: upstream_fallback
      required: true
      default: false
      value_in_examples:
      datatype: boolean
      description: |
        Whether the plugin will fall back to the original upstream if the Canary Upstream doesn't have at least one healthy target. (`upstream_host` must point to a valid Kong Upstream entity.)
    - name: upstream_port
      required: semi
      default:
      value_in_examples: 80
      datatype: integer
      description: |
        The target port where traffic will be routed. Required if `upstream_uri` and `upstream_host` are not set.
        Must be a value between 0 and 65535.
    - name: upstream_uri
      required: semi
      default:
      value_in_examples:
      datatype: string
      description: |
        The Upstream URI where traffic will be routed. Required if `upstream_port` and `upstream_host` are not set.
    - name: hash
      required:
      default: consumer
      value_in_examples:
      datatype: string
      description: |
        Entity to be used for hashing. Options: `consumer`, `ip`, `header`, `allow`, `deny`, or `none`.
        When using `consumer` or `ip`, make sure to properly set the settings for trusted IPs
        (see the `trusted_ips` and `real_ip_header` settings in the Kong configuration file.)
    - name: groups
      required:
      default:
      value_in_examples:
      datatype: array of string elements
      description: |
        An array of strings with the group names that are allowed or denied. Set `hash` to either `allow` (the listed groups
        go into the canary) or `deny` (the listed groups will NOT go into the canary.)
    - name: hash_header
      required: semi
      default: 
      value_in_examples:
      datatype: string
      description: |
        Header name whose value will be used as hash input. Required if `config.hash` is set to `header`.

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
[**Upstream Healthchecks**](/gateway-oss/latest/admin-api/#upstream-objects)
to skip applying the Canary upstream if it does not have at least one healthy
target. For this configuration to take effect, the following conditions must be met:

 - As this configuration relies on Kong's balancer (and healthchecks),
 the name specified in `config.upstream_host` must point to a valid Kong Upstream
 object
 - [**Healthchecks**](/gateway-oss/latest/health-checks-circuit-breakers/) are
 enabled in the canary upstream, i.e., the upstream specified in `upstream_host`
 needs to have healthchecks enabled it. It works with both passive and active
 healthchecks.
