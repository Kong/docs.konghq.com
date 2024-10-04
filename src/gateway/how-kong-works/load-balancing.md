---
title: Load Balancing Reference
---

Kong provides multiple ways of load balancing requests to multiple backend
services: the default DNS-based method, and an advanced set of load-balancing
algorithms using the Upstream entity.

The DNS load balancer is enabled by default and is limited to round-robin
load-balancing. The `upstream` entity has health-check and circuit-breaker
functionalities, besides the more advanced algorithms like least-connections,
consistent-hashing, and lowest-latency.

Refer to the [DNS caveats](#dns-caveats) depending on your infrastructure .

## DNS-based load balancing

Every Service that has been defined with a `host` containing a hostname
(instead of an IP address) will automatically use DNS-based load balancing
if the name resolves to multiple IP addresses.

The DNS record `ttl` setting (time to live) determines how often the information
is refreshed. When using a `ttl` of 0, every request will be resolved using its
own DNS query. Obviously this will have a performance penalty, but the latency of
updates/changes will be very low.

The round-robin algorithm used, weighted or not, depends on the DNS record type of the
hostname.

### A records

An A record contains one or more IP addresses. Hence, when a hostname
resolves to an A record, each backend service must have its own IP address.

Because there is no `weight` information, all entries will be treated as equally
weighted in the load balancer, and the balancer will do a straight forward
round-robin.

### SRV records

An SRV record contains weight and port information for all of its IP addresses.
A backend service can be identified by a unique combination of IP address
and port number. Hence, a single IP address can host multiple instances of the
same service on different ports.

SRV records also feature a `priority` property. Kong will only use the entries with
the highest priority, and ignore all others (note that the "highest priority" in an
SRV record actually is the record with the lowest `priority` value).

Because the `weight` information is available, each entry will get its own
weight in the load balancer and it will perform a weighted round-robin.

Similarly, any given port information will be overridden by the port information from
the DNS server. If a Service has attributes `host=myhost.com` and `port=123`,
and `myhost.com` resolves to an SRV record with `127.0.0.1:456`, then the request
will be proxied to `http://127.0.0.1:456/somepath`, as port `123` will be
overridden by `456`.

### DNS caveats

- Kong will trust the nameserver. This means that information retrieved via a DNS
query will have higher precedence than the configured values. This mostly relates
to SRV records which carry `port` and `weight` information.

- Whenever the DNS record is refreshed a list is generated to handle the
weighting properly. Try to keep the weights as multiples of each other to keep
the algorithm performant, e.g., 2 weights of 17 and 31 would result in a structure
with 527 entries, whereas weights 16 and 32 (or their smallest relative
counterparts 1 and 2) would result in a structure with merely 3 entries. This is
especially relevant with a very small (or even 0) `ttl` value.

- DNS is carried over UDP with a default limit of 512 Bytes. If there are many entries
to be returned, a DNS Server will respond with partial data and set a truncate flag,
indicating there are more entries unsent.
DNS clients, including Kong's, will then make a second request over TCP to retrieve the full
list of entries.

- Some nameservers by default do not respond with the truncate flag, but trim the response
to be under 512 byte UDP size.
   - Consul is an example. Consul, in its default configuration, returns up to the first
three entries only, and does not set the truncate flag to indicate there are remaining entries unsent.
Consul includes an option to enable the truncate flag. Please refer to [Consul documentation](https://www.consul.io/docs/agent/options.html#enable_truncate)
for more information.

- If a deployed nameserver does not provide the truncate flag, the pool
of upstream instances might be loaded inconsistently. The Kong node is effectively
unaware of some of the instances, due to the limited information provided by the nameserver.
To mitigate this, use a different nameserver, use IP addresses instead of names, or make sure
you use enough Kong nodes to still keep all upstream services in use.

- When the nameserver returns a `3 name error`, then that is a valid response
for Kong. If this is unexpected, first validate the correct name is being
queried for, and second check your nameserver configuration.

- The initial pick of an IP address from a DNS record (A or SRV) is not
randomized. So when using records with a `ttl` of 0, the nameserver is
expected to randomize the record entries.

## Advanced load-balancing

Advanced load-balancing algorithms are available through the `upstream` entity.

When using these load balancers, the adding and removing of backend services will
be handled by Kong, and no DNS updates will be necessary. Kong will act as the
service registry.

Configuring the load balancers is done through the `upstream` and `target`
entities.

  - `upstream`: a 'virtual hostname' which can be used in a Service `host`
    field, e.g., an `upstream` named `weather.v2.service` would get all requests
    from a `service` with `host=weather.v2.service`. The `upstream` carries the
    properties that determine the load-balancing behaviour (as well
    as the health-checks and circuit-breaker configuration).

  - `target`: an IP address or hostname with a port number where a backend
    service resides, e.g. "192.168.100.12:80". Each `target` gets an additional
    `weight` to indicate the relative load it gets. IP addresses can be
    in both IPv4 and IPv6 format.


### Upstream

Each `upstream` can have many `target` entries attached to it, and requests proxied
to the 'virtual hostname' will be load balanced over the targets.

Adding and removing targets can be done with a simple HTTP request on the
Admin API. This operation is relatively cheap. Changing the upstream
itself is more expensive as the balancer will need to be rebuilt when the
number of slots change for example.

Detailed information on adding and manipulating
upstreams is available in the `upstream` section of the
[Admin API reference][upstream-object-reference].

### Target

A target is an IP address/hostname with a port that identifies an instance of
a backend service. Each upstream can have many targets.
Detailed information on adding and manipulating targets is available in the
`target` section of the [Admin API reference][target-object-reference].

The targets will be automatically cleaned when there are 10x more inactive
entries than active ones. Cleaning will involve rebuilding the balancer, and
hence is more expensive than just adding a target entry.

A `target` can also have a hostname instead of an IP address. In that case
the name will be resolved and all entries found will individually be added to
the ring balancer, e.g., adding `api.host.com:123` with `weight=100`. The
name 'api.host.com' resolves to an A record with 2 IP addresses. Then both
IP addresses will be added as target, each getting `weight=100` and port 123.
__NOTE__: the weight is used for the individual entries, not for the whole!

Would it resolve to an SRV record, then also the `port` and `weight` fields
from the DNS record would be picked up, and would overrule the given port `123`
and `weight=100`.
{:.note}
> **Note**: similar to the DNS based load-balancing, only the highest priority
entries (the lowest values) in an SRV record will be used.

The balancer will honor the DNS record's `ttl` setting, upon expiry it queries the
nameserver and updates the balancer.

{:.important}
> **Exception**: When a DNS record has `ttl=0`, the hostname will be added
as a single target, with the specified weight. Upon every proxied request
to this target it will query the nameserver again.

### Fighting load-balancers

As described in the [target](#target) paragraph, the targets can be specified as hostnames.
In orchestrated environments like k8s or docker-compose, the IP addresses and ports
are mostly ephemeral and SRV records must be used to find the appropriate backends and
to stay up to date.

On a DNS level many infrastructure tools can also provide load-balancing type features.
These are mostly service-discovery tools that will have their own health-checks and
will randomize DNS records, or only return a small subset of available peers.

The Kong load balancers and the DNS based tools often fight each other. The nameserver will
provide as little information as possible to force clients to follow its scheme, where
Kong tries to get all backends to properly set up its load balancers and health-checks.

In your environment, ensure that:

- the nameserver sets the truncation flag on the responses when it cannot fit all
  records in the UDP response. This will force Kong to retry using TCP. 
- TCP queries are allowed on the nameserver.



## Balancing algorithms


The load balancers support the following load-balancing algorithms:
* `round-robin`
* `consistent-hashing`
* `least-connections`
{% if_version gte:3.2.x -%}
* `latency`
{% endif_version %}

These algorithms are only available when using the `upstream` entity, see
[Advanced load-balancing](#advanced-load-balancing).

{:.note}
> **Note**: for all these algorithms it is important to understand how the weights
and ports of the individual backends are being set up. See the [Target](#target)
paragraph on how the actual weights and ports are being determined based on user
configuration as well DNS results.

### Round-Robin

The round-robin algorithm will be done in a weighted manner. It will be identical
in results to the DNS based load-balancing, but due to it being an `upstream`
the additional features for health-checks and circuit-breakers will be available
in this case.

When choosing this algorithm, consider the following:
- good distribution of requests.
- fairly static, as only DNS updates or `target` updates can influence the
  distribution of traffic.
- does not improve cache-hit ratios.


### Consistent-Hashing

With the consistent-hashing algorithm a configurable client-input will be used to
calculate a hash-value. This hash-value will then be tied to a specific backend
server.

A common example would be to use the `consumer` as a hash-input. Since this ID is
the same for every request from that user, it will ensure that the same user will
consistently be dealt with by the same backend server. This will allow for cache
optimizations on the backend, since each of the servers only serves a fixed subset
of the users, and hence can improve its cache-hit-ratio for user related data.

This algorithm implements the [ketama principle](https://github.com/RJ/ketama) to
maximize hashing stability and minimize consistency loss upon changes to the list
of known backends.

When using the `consistent-hashing` algorithm, the input for the hash can be either
`none`, `consumer`, `ip`, `header`, or `cookie`. When set to `none`, the
`round-robin` scheme will be used, and hashing will be disabled. The `consistent-hashing`
algorithm supports a primary and a fallback hashing attribute; in case the primary
fails (e.g., if the primary is set to `consumer`, but no Consumer is authenticated),
the fallback attribute is used. This maximizes upstream cache hits.

Supported hashing attributes are:

- `none`: Do not use `consistent-hashing`; use `round-robin` instead (default).
- `consumer`: Use the Consumer ID as the hash input. If no Consumer ID is available,
  it will fall back on the Credential ID (for example, in case of an external authentication mechanism like LDAP).
- `ip`: Use the originating IP address as the hash input. Review the configuration
  settings for [determining the real IP][real-ip-config] when using this.
- `header`: Use a specified header as the hash input. The header name is
  specified in either `hash_on_header` or `hash_fallback_header`, depending on whether
  `header` is a primary or fallback attribute, respectively.
- `cookie`: Use a specified cookie with a specified path as the hash input.
  The cookie name is specified in the `hash_on_cookie` field and the path is
  specified in the `hash_on_cookie_path` field. If the specified cookie is not
  present in the request, it will be set by the response. Hence, the `hash_fallback`
  setting is invalid if `cookie` is the primary hashing mechanism.
  The generated cookie will have a random UUID value. So the first assignment will
  be random, but then sticks because it is preserved in the cookie.

The consistent-hashing balancer is designed to work both with a single node as well
as in a cluster. When using the hash based algorithm it is important that all nodes
build the exact same balancer-layout to make sure they all work identical. To do
this the balancer must be built in a deterministic way. 

When choosing this algorithm, consider the following: 

- improves backend cache-hit ratios.
- requires enough cardinality in the hash-inputs to distribute evenly (for example, hashing on
  a header that only has 2 possible values does not make sense).
- the cookie based approach will work well for browser based requests, but less so
  for machine-2-machine clients which will often omit the cookie.
- avoid using hostnames in the balancer as the
  balancers might/will slowly diverge because the DNS ttl has only second precision
  and renewal is determined by when a name is actually requested. On top of this is
  the issue with some nameservers not returning all entries, which exacerbates
  this problem. So when using the hashing approach in a Kong cluster, preferably add
  `target` entities by their IP address. This problem can be mitigated by balancer
  rebuilds and higher ttl settings. 


### Least-Connections

This algorithm keeps track of the number of in-flight requests for each backend.
The weights are used to calculate "connection-capacity" of a backend. Requests are
routed towards the backend with the highest spare capacity.

When choosing this algorithm, consider the following:
- good distribution of traffic.
- does not improve cache-hit ratio's.
- more dynamic since slower backends will have more connections open, and hence
  new requests will be routed to other backends automatically.

{% if_version gte:3.2.x %}
### Latency

The `latency` algorithm is based on peak EWMA (exponentially weighted moving average),
which ensures that the balancer selects the backend by lowest latency
(`upstream_response_time`). The latency metric used is the full request cycle, from
TCP connect to body response time. Since it is a moving average, the metrics will
"decay" over time.

Weights will not be taken into account.

When choosing this algorithm, consider the following:
- good distribution of traffic provided there is enough base-load to keep the
  metrics alive, since they are "decaying".
- not suitable for long-lived connections like websockets or server-sent events (SSE)
- very dynamic since it will constantly optimize.
- ideally, this works best with low variance in latencies. This means mostly similar
  shaped traffic and even workloads for the backends. For example, usage
  with a GraphQL backend serving small-fast queries as well big-slow ones will result
  in high variance in the latency metrics, which will skew the metrics.
- properly set up the backend capacity and ensure proper network latency to prevent
  resource starvation. For example, use 2 servers: one a small capacity close by (low
  network latency), the other high capacity far away (high latency). Most traffic
  will be routed to the small one, until its latency starts going up. The latency
  going up however means the small server is most likely suffering from resource
  starvation. So, in this case, the algorithm will keep the small server in a constant
  state of resource starvation, which is most likely not efficient.

{% endif_version %}



[upstream-object-reference]: /gateway/{{page.release}}/admin-api#upstream-object
[target-object-reference]: /gateway/{{page.release}}/admin-api#target-object
[dns-order-config]: /gateway/{{page.release}}/reference/configuration/#dns_order
[real-ip-config]: /gateway/{{page.release}}/reference/configuration/#real_ip_header
