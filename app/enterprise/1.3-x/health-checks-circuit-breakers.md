---
title: Health Checks and Circuit Breakers Reference
---

## Introduction

You can make an API proxied by Kong use a [ring-balancer][ringbalancer], configured
by adding an [upstream][upstream] entity that contains one or more [target][ringtarget]
entities, each target pointing to a different IP address (or hostname) and
port. The ring-balancer will balance load among the various targets, and based
on the [upstream][upstream] configuration, will perform health checks on the targets,
making them as healthy or unhealthy whether they are responsive or not. The
ring-balancer will then only route traffic to healthy targets.

Kong supports two kinds of health checks, which can be used separately or in
conjunction:

* **active checks**, where a specific HTTP or HTTPS endpoint in the target is
periodically requested and the health of the target is determined based on its
response;

* **passive checks** (also known as **circuit breakers**), where Kong analyzes
the ongoing traffic being proxied and determines the health of targets based
on their behavior responding requests.

## Defining healthy and unhealthy

### Targets

The objective of the health checks functionality is to dynamically mark
targets as healthy or unhealthy, **for a given Kong node**. There is
no cluster-wide synchronization of health information: each Kong node
determines the health of its targets separately. This is desirable since at a
given point one Kong node may be able to connect to a target successfully
while another node is failing to reach it: the first node will consider
it healthy, while the second will mark it as unhealthy and start routing
traffic to other targets of the upstream.

Either an active probe (on active health checks) or a proxied request
(on passive health checks) produces data which is used to determine
whether a target is healthy or unhealthy. A request may produce a TCP
error, timeout, or produce an HTTP status code. Based on this
information, the health checker updates a series of internal counters:

* If the returned status code is one configured as "healthy", it will
increment the "Successes" counter for the target and clear all its other
counters;
* If it fails to connect, it will increment the "TCP failures" counter
for the target and clear the "Successes" counter;
* If it times out, it will increment the "timeouts" counter
for the target and clear the "Successes" counter;
* If the returned status code is one configured as "unhealthy", it will
increment the "HTTP failures" counter for the target and clear the "Successes" counter.

If any of the "TCP failures", "HTTP failures" or "timeouts" counters reaches
their configured threshold, the target will be marked as unhealthy.

If the "Successes" counter reaches its configured threshold, the target will be
marked as healthy.

The list of which HTTP status codes are "healthy" or "unhealthy", and the
individual thresholds for each of these counters are configurable on a
per-upstream basis. Below, we have an example of a configuration for an
Upstream entity, showcasing the default values of the various fields
available for configuring health checks. A description of each
field is included in the [Admin API][addupstream] reference documentation.

```json
{
    "name": "service.v1.xyz",
    "healthchecks": {
        "active": {
            "concurrency": 10,
            "healthy": {
                "http_statuses": [ 200, 302 ],
                "interval": 0,
                "successes": 0
            },
            "http_path": "/",
            "timeout": 1,
            "unhealthy": {
                "http_failures": 0,
                "http_statuses": [ 429, 404, 500, 501,
                                   502, 503, 504, 505 ],
                "interval": 0,
                "tcp_failures": 0,
                "timeouts": 0
            }
        },
        "passive": {
            "healthy": {
                "http_statuses": [ 200, 201, 202, 203,
                                   204, 205, 206, 207,
                                   208, 226, 300, 301,
                                   302, 303, 304, 305,
                                   306, 307, 308 ],
                "successes": 0
            },
            "unhealthy": {
                "http_failures": 0,
                "http_statuses": [ 429, 500, 503 ],
                "tcp_failures": 0,
                "timeouts": 0
            }
        },
        "threshold": 0
    },
    "slots": 10
}
```

If an upstream is unhealthy (the available capacity % is less than the configured
threshold), Kong will respond to requests to the upstream with
`503 Service Unavailable`.

Note:

1. health checks operate only on [*active* targets][targetobject] and do not
   modify the *active* status of a target in the Kong database.
2. unhealthy targets will not be removed from the loadbalancer, and hence will
   not have any impact on the balancer layout when using the hashing algorithm
   (they will just be skipped).
3. The [DNS caveats][dnscaveats] and [balancer caveats][balancercaveats]
   also apply to health checks. If using hostnames for the targets, then make
   sure the DNS server always returns the full set of IP addresses for a name,
   and does not limit the response. *Failing to do so might lead to health
   checks not being executed.*

### Upstreams

Along with health check functionality on individual targets, Upstreams also
have a notion of health. The health of an Upstream is determined based on the
status of its Targets.

Configuration of the Upstream's health is done though the property
`healthchecks.threshold`. This is a percentage of minimum available target
"weight" (capacity) for the Upstream to be considered healthy.

Here is a simple example:

- Assume an Upstream configured with `healthchecks.threshold=55`.
- It has 5 targets, each with `weight=100`, so the total weight in the ring-balancer is 500.

When failures start to occur, the circuit-breaker for the first target trips.
It is now considered unhealthy. This means that in the ring-balancer, 20% of
the capacity is now unhealthy (100 weight out of 500). This is still above the
threshold of 55, so the remaining targets will serve the traffic of the failed
one.

When a second failure occurs, another target fails, and another 100 weight is lost
as unhealthy. Now the ring-balancer operates at 60% of its capacity, but still
within the configured threshold.

If we assume that the 2 failures occured due to a system overload, we can now assume
that the remaining 60% will also not be able to cope with the full load and soon a third
node will fail, reducing healthy capacity to 40%. At this point, the Upstream health
will be less than its threshold, and it will be marked as unhealthy itself.

Once it enters an unhealthy state, the Upstream will only return errors. This lets the
targets/services recover from the cascading failure they were experiencing.

Once the Targets start recovering and the Upstream's available capacity passes the
threshold again, the health status of the ring-balancer will automatically be updated.


## Types of health checks

### Active health checks

Active health checks, as the name implies, actively probe targets for
their health. When active health checks are enabled in an upstream entity,
Kong will periodically issue HTTP or HTTPS requests to a configured path at each target
of the upstream. This allows Kong to automatically enable and disable targets
in the balancer based on the [probe results](#healthy-and-unhealthy-targets).

The periodicity of active health checks can be configured separately for
when a target is healthy or unhealthy. If the `interval` value for either
is set to zero, the checking is disabled at the corresponding scenario.
When both are zero, active health checks are disabled altogether.

<div class="alert alert-warning">
<strong>Note:</strong> Active health checks currently only support HTTP/HTTPS targets. They
do not apply to Upstreams assigned to Services with the protocol attribute set to "tcp" or "tls".
</div>

[Back to TOC](#table-of-contents)

### Passive health checks (circuit breakers)

Passive health checks, also known as circuit breakers, are
checks performed based on the requests being proxied by Kong (HTTP/HTTPS/TCP),
with no additional traffic being generated. When a target becomes
unresponsive, the passive health checker will detect that and mark
the target as unhealthy. The ring-balancer will start skipping this
target, so no more traffic will be routed to it.

Once the problem with a target is solved and it is ready to receive
traffic again, the Kong administrator can manually inform the
health checker that the target should be enabled again, via an
Admin API endpoint:

```bash
$ curl -i -X POST http://localhost:8001/upstreams/my_upstream/targets/10.1.2.3:1234/healthy
HTTP/1.1 204 No Content
```

This command will broadcast a cluster-wide message so that the "healthy"
status is propagated to the whole [Kong cluster][clustering]. This will cause Kong nodes to
reset the health counters of the health checkers running in all workers of the
Kong node, allowing the ring-balancer to route traffic to the target again.

Passive health checks have the advantage of not producing extra
traffic, but they are unable to automatically mark a target as
healthy again: the "circuit is broken", and the target needs to
be re-enabled again by the system administrator.


[Back to TOC](#table-of-contents)

## Summary of pros and cons

* Active health checks can automatically re-enable a target in the
ring balancer as soon as it is healthy again. Passive health checks cannot.
* Passive health checks do not produce additional traffic to the
target. Active health checks do.
* An active health checker demands a known URL with a reliable status response
in the target to be configured as a probe endpoint (which may be as
simple as `"/"`). Passive health checks do not demand such configuration.
* By providing a custom probe endpoint for an active health checker,
an application may determine its own health metrics and produce a status
code to be consumed by Kong. Even though a target continues to serve
traffic which looks healthy to the passive health checker,
it would be able to respond to the active probe with a failure
status, essentially requesting to be relieved from taking new traffic.

It is possible to combine the two modes. For example, one can enable
passive health checks to monitor the target health based solely on its
traffic, and only use active health checks while the target is unhealthy,
in order to re-enable it automatically. To do so, set the interval of
active health checks on `healthy` status to zero, and active checks on
`unhealthy` status to a non-zero interval.

## Enabling and disabling health checks

### Enabling active health checks

To enable active health checks, you need to specify the configuration items
under `healthchecks.active` in the [Upstream object][upstreamobjects] configuration. You
need to specify the necessary information so that Kong can perform periodic
probing on the target, and how to interpret the resulting information.

You can use the `healthchecks.active.type` field to specify whether to perform
HTTP or HTTPS probes (setting it to `"http"` or `"https"`), or by simply
testing if the connection to a given host and port is successful
(setting it to `"tcp"`).

For configuring the probe, you need to specify:

* `healthchecks.active.http_path` - The path that should be used when
issuing the HTTP GET request to the target. The default value is `"/"`.
* `healthchecks.active.timeout` - The connection timeout limit for the
HTTP GET request of the probe. The default value is 1 second.
* `healthchecks.active.concurrency` - Number of targets to check concurrently
in active health checks.

You also need to specify positive values for intervals, for running
probes:

* `healthchecks.active.healthy.interval` - Interval between active health
checks for healthy targets (in seconds). A value of zero indicates that active
probes for healthy targets should not be performed.
* `healthchecks.active.unhealthy.interval` - Interval between active health
checks for unhealthy targets (in seconds). A value of zero indicates that active
probes for unhealthy targets should not be performed.

This allows you to tune the behavior of the active health checks, whether you
want probes for healthy and unhealthy targets to run at the same interval, or
one to be more frequent than the other.

If you are using HTTPS healthchecks, you can also specify the following
fields:

* `healthchecks.active.https_verify_certificate` - Whether to check the
validity of the SSL certificate of the remote host when performing active
health checks using HTTPS.
* `healthchecks.active.https_sni` - The hostname to use as an SNI
(Server Name Identification) when performing active health checks
using HTTPS. This is particularly useful when Targets are configured
using IPs, so that the target host's certificate can be verified
with the proper SNI.

Note that failed TLS verifications will increment the "TCP failures" counter;
the "HTTP failures" refer only to HTTP status codes, whether probes are done
through HTTP or HTTPS.

Finally, you need to configure how Kong should interpret the probe, by setting
the various thresholds on the [health
counters](#healthy-and-unhealthy-targets), which, once reached will trigger a
status change. The counter threshold fields are:

* `healthchecks.active.healthy.successes` - Number of successes in active
probes (as defined by `healthchecks.active.healthy.http_statuses`) to consider
a target healthy.
* `healthchecks.active.unhealthy.tcp_failures` - Number of TCP failures
or TLS verification failures in active probes to consider a target unhealthy.
* `healthchecks.active.unhealthy.timeouts` - Number of timeouts in active
probes to consider a target unhealthy.
* `healthchecks.active.unhealthy.http_failures` - Number of HTTP failures in
active probes (as defined by `healthchecks.active.unhealthy.http_statuses`) to
consider a target unhealthy.

### Enabling passive health checks

Passive health checks do not feature a probe, as they work by interpreting
the ongoing traffic that flows from a target. This means that to enable
passive checks you only need to configure its counter thresholds:

* `healthchecks.passive.healthy.successes` - Number of successes in proxied
traffic (as defined by `healthchecks.passive.healthy.http_statuses`) to
consider a target healthy, as observed by passive health checks. This needs to
be positive when passive checks are enabled so that healthy traffic resets the
unhealthy counters.
* `healthchecks.passive.unhealthy.tcp_failures` - Number of TCP failures in
proxied traffic to consider a target unhealthy, as observed by passive health
checks.
* `healthchecks.passive.unhealthy.timeouts` - Number of timeouts in proxied
traffic to consider a target unhealthy, as observed by passive health checks.
* `healthchecks.passive.unhealthy.http_failures` - Number of HTTP failures in
proxied traffic (as defined by `healthchecks.passive.unhealthy.http_statuses`)
to consider a target unhealthy, as observed by passive health checks.

### Disabling health checks

In all counter thresholds and intervals specified in the `healthchecks`
configuration, setting a value to zero means that the functionality the field
represents is disabled. Setting a probe interval to zero disables a probe.
Likewise, you can disable certain types of checks by setting their counter
thresholds to zero. For example, to not consider timeouts when performing
healthchecks, you can set both `timeouts` fields (for active and passive
checks) to zero. This gives you a fine-grained control of the behavior of the
health checker.

In summary, to completely disable active health checks for an upstream, you
need to set both `healthchecks.active.healthy.interval` and
`healthchecks.active.unhealthy.interval` to `0`.

To completely disable passive health checks, you need to set all counter
thresholds under `healthchecks.passive` for its various counters to zero.

All counter thresholds and intervals in `healthchecks` are zero by default,
meaning that health checks are completely disabled by default in newly created
upstreams.

[Back to TOC](#table-of-contents)

[ringbalancer]: /enterprise/{{page.kong_version}}/loadbalancing#ring-balancer
[ringtarget]: /enterprise/{{page.kong_version}}/loadbalancing#target
[upstream]: /enterprise/{{page.kong_version}}/loadbalancing#upstream
[targetobject]: /enterprise/{{page.kong_version}}/admin-api#target-object
[addupstream]: /enterprise/{{page.kong_version}}/admin-api#add-upstream
[clustering]: /enterprise/{{page.kong_version}}/clustering
[upstreamobjects]: /enterprise/{{page.kong_version}}/admin-api#upstream-objects
[balancercaveats]: /enterprise/{{page.kong_version}}/loadbalancing#balancing-caveats
[dnscaveats]: /enterprise/{{page.kong_version}}/loadbalancing#dns-caveats
