---

name: Canary Release
publisher: Kong Inc.
version: 0.36-x

desc: Slowly roll out software changes to a subset of users
description: |
  Reduce the risk of introducing a new software version in production by slowly rolling out the change to a small subset of users. This plugin also enables roll back to your original upstream service, or shift all traffic to the new version.

enterprise: true
type: plugin
categories:
  - traffic-control

enterprise: true
type: plugin
categories:
  - traffic-control

kong_version_compatibility:
    enterprise_edition:
      compatible:
        - 0.36-x

params:
  name: canary
  api_id: true
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: start
      required:
      default:
      value_in_examples:
      description: |
        Future time in seconds since epoch, when the release will start (ignored when percentage is set, or when using whitelist or blacklist)
    - name: duration
      required:
      default: 3600
      value_in_examples:
      description: |
       How long, in seconds, should the transition take (ignored when percentage is set, or when using whitelist or blacklist)
    - name: percentage
      required:
      default:
      value_in_examples:
      description: |
        Fixed % of traffic to be routed to new target, if given overrides `start` and `duration`
    - name: steps
      required:
      default: 1000
      value_in_examples:
      description: |
        Number of steps the release should be broken into
    - name: upstream_host
      required:
      default:
      value_in_examples:
      description: |
        Target hostname where traffic will be routed, required if `upstream_uri` is not set
    - name: upstream_fallback
      required:
      default: false
      value_in_examples:
      description: |
        Whether the plugin should fallback to the original upstream if the canary upstream doesn't have at least one healthy target. `upstream_host` must point to a valid Kong Upstream entity
    - name: upstream_port
      required:
      default:
      value_in_examples:
      description: |
        Target port where traffic will be routed, required if `upstream_uri/host` is not set
    - name: upstream_uri
      required:
      default:
      value_in_examples:
      description: |
        Upstream URI where traffic will be routed, required if `upstream_host` is not set
    - name: hash
      required:
      default: consumer
      value_in_examples:
      description: |
        Entity to be used for hashing. Options: consumer, ip, or none. Please make sure when not using none, to properly set the settings for `trusted_ips` (see settings `trusted_ips` and `real_ip_header` in the Kong config file)

---

### Usage

The Canary Release plugin allows you to route traffic to two separate upstream 
services, referred to as _Service A_ and _Service B_. The location of _Service A_
is defined by the `upstream_url` property of the **Route** on which the Canary
Release plugin is enabled. The location of _Service B_ is defined by the 
`config.upstream_host`, `config.upstream_port`, and/or `config.upstream_uri` as
configured on the plugin.

There are 3 modes of operation:

1. Set a fixed percentage to be routed to _Service B_. See parameter
   `config.percentage`.
2. Define a white- or blacklist group with consumers to use/not use destination
   B. The consumer-group association can be configured using the ACL plugin.
3. Set a period over which (in linear time) the traffic will be moved over
   from _Service A_ to _Service B_. See parameters `config.start` and 
   `config.duration`.

### Determining Where to Route a Request

(This does not apply to white/blacklisting)

The Canary Release plugin defines a number of "buckets" (`config.steps`). 
Each of these buckets can be routed to either _Service A_ or _Service B_ 

For example: If you set `config.steps` to 100 steps, and `percentage` to 10%, 
Canary will create 100 "buckets", 10 of which will be routed to _Service B_, 
while the other 90 will remain routed to _Service A_.

Which requests end up in a specific bucket is determined by the `config.hash` 
parameter. When set to `consumer`, Canary ensures each consumer will 
consistently end up in the same bucket. The effect being that once a bucket a 
consumer belongs to is switched to _Service B_, it will then always go to 
_Service B_, and will not "flip-flop" between A and B. Alternatively if it is set to
`ip` then the same concept applies, but based on the originating ip address.

When using either the `consumer` or `ip` setting, if any specific consumer or ip 
is responsible for more than the average percentage of traffic, the migration 
may not be evenly distributed. Eg. if the percentage is set to 50%, then 50% of 
either the consumers or ips will be rerouted, but not necessarily 50% of the total requests.

When set to `none` the requests will be evenly distributed, each bucket 
will get the same number of requests, but a consumer or ip might flip-flop between 
_Service A_ and _Service B_ on consecutive requests.

Canary provides an automatic fallback if, for some reason, a consumer or ip can 
not be identified. The fall-back order is be `consumer`->`ip`->`none`.

### Finalizing the Canary

Once the canary is complete, either going to 100% for a percent-based canary, 
or the timed canary has reached 100%, the configuration will need to be updated:

1. Update the `upstream_url` to point to _Service B_ by matching it the url as 
specified by `config.upstream_host` or `config.upstream_uri`.
2. Remove the Canary plugin from the **Route** with a `DELETE` request.

Removing or disabling the Canary Release plugin before the canary is complete will
instantly switch all traffic to _Service B_.


### Upstream Healthchecks

The configuration item `upstream_fallback` uses 
[**Upstream Healthchecks**]({{page.kong_version}}/admin-api/#upstream-objects) 
to skip applying the canary upstream if it does not have at least one healthy 
target. For this configuration to take effect, the following conditions must be met:

 - As this configuration relies on Kong's balancer (and healthchecks), 
 the name specified in config.upstream_host must point to a valid Kong Upstream 
 object
 - [**Healthchecks**]({{page.kong_version}}/health-checks-circuit-breakers/) are 
 enabled in the canary upstream - i.e., the upstream specified in `upstream_host` 
 needs to have healthchecks enabled it. It works with both passive and active 
 healthchecks.
