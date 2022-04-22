---
title: Load Balancing Reference
---

Kong provides multiple ways of load balancing requests to multiple backend
services: a straightforward DNS-based method, and a more dynamic ring-balancer
that also allows for service registry without needing a DNS server.

## DNS-based load balancing

When using DNS-based load balancing, the registration of the backend services
is done outside of Kong, and Kong only receives updates from the DNS server.

Every Service that has been defined with a `host` containing a hostname
(instead of an IP address) will automatically use DNS-based load balancing
if the name resolves to multiple IP addresses, provided the hostname does not
resolve to an `upstream` name or a name in your DNS hostsfile.

The DNS record `ttl` setting (time to live) determines how often the information
is refreshed. When using a `ttl` of 0, every request will be resolved using its
own DNS query. Obviously this will have a performance penalty, but the latency of
updates/changes will be very low.

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

Because the `weight` information is available, each entry will get its own
weight in the load balancer and it will perform a weighted round-robin.

Similarly, any given port information will be overridden by the port information from
the DNS server. If a Service has attributes `host=myhost.com` and `port=123`,
and `myhost.com` resolves to an SRV record with `127.0.0.1:456`, then the request
will be proxied to `http://127.0.0.1:456/somepath`, as port `123` will be
overridden by `456`.

### DNS priorities

The DNS resolver will start resolving the following record types in order:

  1. The last successful type previously resolved
  2. SRV record
  3. A record
  4. CNAME record

This order is configurable through the [`dns_order` configuration property][dns-order-config].

### DNS caveats

- Whenever the DNS record is refreshed a list is generated to handle the
weighting properly. Try to keep the weights as multiples of each other to keep
the algorithm performant, e.g., 2 weights of 17 and 31 would result in a structure
with 527 entries, whereas weights 16 and 32 (or their smallest relative
counterparts 1 and 2) would result in a structure with merely 3 entries,
especially with a very small (or even 0) `ttl` value.

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

## Ring-balancer

When using the ring-balancer, the adding and removing of backend services will
be handled by Kong, and no DNS updates will be necessary. Kong will act as the
service registry. Nodes can be added/deleted with a single HTTP request and
will instantly start/stop receiving traffic.

Configuring the ring-balancer is done through the `upstream` and `target`
entities.

  - `target`: an IP address or hostname with a port number where a backend
    service resides, eg. "192.168.100.12:80". Each target gets an additional
    `weight` to indicate the relative load it gets. IP addresses can be
    in both IPv4 and IPv6 format.

  - `upstream`: a 'virtual hostname' which can be used in a Route `host`
    field, e.g., an upstream named `weather.v2.service` would get all requests
    from a Service with `host=weather.v2.service`.

### Upstream

Each upstream gets its own ring-balancer. Each `upstream` can have many
`target` entries attached to it, and requests proxied to the 'virtual hostname'
(which can be overwritten before proxying, using `upstream`'s property
`host_header`) will be load balanced over the targets. A ring-balancer has a
maximum predefined number of slots, and based on the target weights the slots get
assigned to the targets of the upstream.

Adding and removing targets can be done with a simple HTTP request on the
Admin API. This operation is relatively cheap. Changing the upstream
itself is more expensive as the balancer will need to be rebuilt when the
number of slots change for example.

Within the balancer there are the positions (from 1 up to the value defined in the `slots` attribute),
which are __randomly distributed__ on the ring.
The randomness is required to make invoking the ring-balancer cheap at
runtime. A simple round-robin over the wheel (the positions) will do to
provide a well distributed weighted round-robin over the `targets`, while
also having cheap operations when inserting/deleting targets.

Detailed information on adding and manipulating
upstreams is available in the `upstream` section of the
[Admin API reference][upstream-object-reference].

### Target

A target is an ip address/hostname with a port that identifies an instance of
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
ip addresses will be added as target, each getting `weight=100` and port 123.
__NOTE__: the weight is used for the individual entries, not for the whole!

Would it resolve to an SRV record, then also the `port` and `weight` fields
from the DNS record would be picked up, and would overrule the given port `123`
and `weight=100`.

The balancer will honor the DNS record's `ttl` setting and requery and update
the balancer when it expires.

__Exception__: When a DNS record has `ttl=0`, the hostname will be added
as a single target, with the specified weight. Upon every proxied request
to this target it will query the nameserver again.

### Balancing algorithms

The ring-balancer supports the following load balancing algorithms: `round-robin`,
`consistent-hashing`, and `least-connections`. By default, a ring-balancer
uses the `round-robin` algorithm, which provides a well-distributed weighted
round-robin over the targets.

When using the `consistent-hashing` algorithm, the input for the hash can be either
`none`, `consumer`, `ip`, `header`, or `cookie`. When set to `none`, the
`round-robin` scheme will be used, and hashing will be disabled. The `consistent-hashing`
algorithm supports a primary and a fallback hashing attribute; in case the primary
fails (e.g., if the primary is set to `consumer`, but no Consumer is authenticated),
the fallback attribute is used.

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

The `consistent-hashing` algorithm is based on _Consistent Hashing_ (or the
_Ketama Principle_), which ensures that when the balancer gets modified by
a change in its targets (adding, removing, failing, or changing weights), only
the minimum number of hashing losses occur. This maximizes upstream cache hits.

The ring-balancer also supports the `least-connections` algorithm, which selects
the target with the lowest number of connections, weighted by the Target's
`weight` attribute.

For more information on the exact settings see the `upstream` section of the
[Admin API reference][upstream-object-reference].

### Balancing caveats

The ring-balancer is designed to work both with a single node as well as in a cluster.
For the weighted-round-robin algorithm there isn't much difference, but when using
the hash based algorithm it is important that all nodes build the exact same
ring-balancer to make sure they all work identical. To do this the balancer
must be build in a deterministic way.

- Do not use hostnames in the balancer as the
balancers might/will slowly diverge because the DNS ttl has only second precision
and renewal is determined by when a name is actually requested. On top of this is
the issue with some nameservers not returning all entries, which exacerbates
this problem. So when using the hashing approach in a Kong cluster, add `target`
entities only by their IP address, and never by name.

- When picking your hash input make sure the input has enough variance to get
to a well distributed hash. Hashes will be calculated using the CRC-32 digest.
So for example, if your system has thousands of users, but only a few consumers, defined
per platform (eg. 3 consumers: Web, iOS and Android) then picking the `consumer`
hash input will not suffice, using the remote IP address by setting the hash to
`ip` would provide more variance in the input and hence a better distribution
in the hash output. However, if many clients will be behind the same NAT gateway (e.g. in
call center), `cookie` will provide a better distribution than `ip`.

# Blue-Green Deployments

Using the ring-balancer a [blue-green deployment][blue-green-canary] can be easily orchestrated for
a Service. Switching target infrastructure only requires a `PATCH` request on a
Service, to change its `host` value.

Set up the "Blue" environment, running version 1 of the address service:

```bash
# create an upstream
$ curl -X POST http://kong:8001/upstreams \
    --data "name=address.v1.service"

# add two targets to the upstream
$ curl -X POST http://kong:8001/upstreams/address.v1.service/targets \
    --data "target=192.168.34.15:80"
    --data "weight=100"
$ curl -X POST http://kong:8001/upstreams/address.v1.service/targets \
    --data "target=192.168.34.16:80"
    --data "weight=50"

# create a Service targeting the Blue upstream
$ curl -X POST http://kong:8001/services/ \
    --data "name=address-service" \
    --data "host=address.v1.service" \
    --data "path=/address"

# finally, add a Route as an entry-point into the Service
$ curl -X POST http://kong:8001/services/address-service/routes/ \
    --data "hosts[]=address.mydomain.com"
```

Requests with host header set to `address.mydomain.com` will now be proxied
by Kong to the two defined targets; 2/3 of the requests will go to
`http://192.168.34.15:80/address` (`weight=100`), and 1/3 will go to
`http://192.168.34.16:80/address` (`weight=50`).

Before deploying version 2 of the address service, set up the "Green"
environment:

```bash
# create a new Green upstream for address service v2
$ curl -X POST http://kong:8001/upstreams \
    --data "name=address.v2.service"

# add targets to the upstream
$ curl -X POST http://kong:8001/upstreams/address.v2.service/targets \
    --data "target=192.168.34.17:80"
    --data "weight=100"
$ curl -X POST http://kong:8001/upstreams/address.v2.service/targets \
    --data "target=192.168.34.18:80"
    --data "weight=100"
```

To activate the Blue/Green switch, we now only need to update the Service:

```bash
# Switch the Service from Blue to Green upstream, v1 -> v2
$ curl -X PATCH http://kong:8001/services/address-service \
    --data "host=address.v2.service"
```

Incoming requests with host header set to `address.mydomain.com` will now be
proxied by Kong to the new targets; 1/2 of the requests will go to
`http://192.168.34.17:80/address` (`weight=100`), and the other 1/2 will go to
`http://192.168.34.18:80/address` (`weight=100`).

As always, the changes through the Kong Admin API are dynamic and will take
effect immediately. No reload or restart is required, and no in progress
requests will be dropped.

# Canary Releases

Using the ring-balancer, target weights can be adjusted granularly, allowing
for a smooth, controlled [canary release][blue-green-canary].

Using a very simple 2 target example:

```bash
# first target at 1000
$ curl -X POST http://kong:8001/upstreams/address.v2.service/targets \
    --data "target=192.168.34.17:80"
    --data "weight=1000"

# second target at 0
$ curl -X POST http://kong:8001/upstreams/address.v2.service/targets \
    --data "target=192.168.34.18:80"
    --data "weight=0"
```

By repeating the requests, but altering the weights each time, traffic will
slowly be routed towards the other target. For example, set it at 10%:

```bash
# first target at 900
$ curl -X POST http://kong:8001/upstreams/address.v2.service/targets \
    --data "target=192.168.34.17:80"
    --data "weight=900"

# second target at 100
$ curl -X POST http://kong:8001/upstreams/address.v2.service/targets \
    --data "target=192.168.34.18:80"
    --data "weight=100"
```

The changes through the Kong Admin API are dynamic and will take
effect immediately. No reload or restart is required, and no in progress
requests will be dropped.

[upstream-object-reference]: /gateway/{{page.kong_version}}/admin-api#upstream-object
[target-object-reference]: /gateway/{{page.kong_version}}/admin-api#target-object
[dns-order-config]: /gateway/{{page.kong_version}}/reference/configuration/#dns_order
[real-ip-config]: /gateway/{{page.kong_version}}/reference/configuration/#real_ip_header
[blue-green-canary]: http://blog.christianposta.com/deploy/blue-green-deployments-a-b-testing-and-canary-releases/
