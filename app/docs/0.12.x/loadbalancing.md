---
title: Loadbalancing reference
---

# Load Balancing Reference

Kong provides multiple ways of load balancing requests to multiple backend services:
a straightforward DNS-based method, and a more dynamic ring-balancer that also
allows for service registry without needing a DNS server.

### Table of Contents

- [DNS-based loadbalancing](#dns-based-loadbalancing)
  - [A records](#a-records)
  - [SRV records](#srv-records)
  - [DNS priorities](#dns-priorities)
- [Ring-balancer](#ring-balancer)
  - [Upstream](#upstream)
  - [Target](#target)
- [Blue-green Deployments](#blue-green-deployments)
- [Canary Releases](#canary-releases)

### DNS-based loadbalancing

When using DNS based load balancing the registration of the backend services is
done outside of Kong, and Kong only receives updates from the DNS server.

Every API that has been defined with an `upstream_url` containing a hostname
(instead of an IP address) will automatically use DNS based load balancing
if the name resolves to multiple IP addresses, provided the hostname does not
resolve to an `upstream` name or a name in your `localhosts` file.

The DNS record `ttl` setting (time to live) determines how often the information
is refreshed. When using a `ttl` of 0, every request will be resolved using its
own dns query. Obviously this will have a performance penalty, but the latency of
updates/changes will be very low.

[Back to TOC](#table-of-contents)

#### **A records**

An A record contains one or more IP addresses. Hence, when a hostname
resolves to an A record, each backend service must have its own IP address.

Because there is no `weight` information, all entries will be treated as equally
weighted in the load balancer, and the balancer will do a straight forward
round-robin.

The initial pick of an IP address from a DNS record is not randomized. So when
using records with a `ttl` of 0, the nameserver is expected to randomize the
record entries.

[Back to TOC](#table-of-contents)

#### **SRV records**

An SRV record contains weight and port information for all of its IP addresses.
A backend service can be identified by a unique combination of IP address
and port number. Hence, a single IP address can host multiple instances of the
same service on different ports.

Because the `weight` information is available, each entry will get its own
weight in the load balancer and it will perform a weighted round-robin.

Similarly, any given port information will be overridden by the port information from
the DNS server. If an API has an `upstream_url=http://myhost.com:123/somepath`
and `myhost.com` resolves to a SRV record with `127.0.0.1:456` then the request
will be proxied to `http://127.0.0.1:456/somepath`, as port `123` will be
overridden by `456`.

The initial pick of an IP address + port combo is randomized, ensuring a proper
distribution, even with a `ttl` setting of 0.

**TIP**: whenever the DNS record is refreshed a list is generated to handle the
weighting properly. Try to keep the weights as multiples of each other to keep
the algorithm performant, e.g., 2 weights of 17 and 31 would result in a structure
with 527 entries, whereas weights 16 and 32 (or their smallest relative
counterparts 1 and 2) would result in a structure with merely 3 entries,
especially with a very small (or even 0) `ttl` value.

[Back to TOC](#table-of-contents)

#### **DNS priorities**

The DNS resolver will start resolving the following record types in order:

  1. The last successful type previously resolved
  2. SRV record
  3. A record
  4. CNAME record

So if the hostname you use has both SRV entries and A entries, it will start
with SRV. If you want A records to be used, you must remove the SRV records from
the DNS server. If you only have A records, then the SRV lookup will fail and
it will fallback on an A query, etc.

[Back to TOC](#table-of-contents)

### **Ring-balancer**

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
  - `upstream`: a 'virtual hostname' which can be used in an API `upstream_url`
    field, e.g., an upstream named `weather.v2.service` would get all requests
    from an API with `upstream_url=http://weather.v2.service/some/path`.

[Back to TOC](#table-of-contents)

#### **Upstream**

Each upstream gets its own ring-balancer. Each `upstream` can have many
`target` entries attached to it, and requests proxied to the 'virtual hostname'
will be load balanced over the targets. A ring-balancer has a pre-defined
number of slots, and based on the target weights the slots get assigned to the
targets of the upstream. Incoming requests will be proxied in a weighted
round-robin manner.

Adding and removing targets can be done with a simple HTTP request on the
management API. This operation is relatively cheap. Changing the upstream
itself is more expensive as the balancer will need to be rebuilt when the
number of slots change for example.

The only occurrence where the balancer will be rebuilt automatically is when
the target history is cleaned; other than that, it will only rebuild upon changes.

Within the balancer there are the positions (from 1 to `slots`),
which are __randomly distributed__ on the ring.
The randomness is required to make invoking the ring-balancer cheap at
runtime. A simple round-robin over the wheel (the positions) will do to
provide a well distributed weighted round-robin over the `targets`, whilst
also having cheap operations when inserting/deleting targets.

The number of slots to use per target should (at least) be around 100 to make
sure the slots are properly distributed. Eg. for an expected maximum of 8
targets, the `upstream` should be defined with at least `slots=800`, even if
the initial setup only features 2 targets.

The tradeoff here is that the higher the number of slots, the better the random
distribution, but the more expensive the changes are (add/removing targets)

In addition to the pure pure (weighted) round-robin on each upstream,
it is often desirable that the same kinds of request are routed consistently to the
same target. The options options `hash_on` and `hash_fallback` allow for this consistent
hashing. They can have the following values:

* `"none"`: don't use a hash, just do (weighted) round-robin. This is the default.
* `"consumer"`: use the `consumer_id`, or if not found the `credential_id`, which is used
  auth plugins like oauth2 or LDAP.
* `"ip"`: use the originating ip address
* `"header"`: use the header specified.
  When `hash_on` is set to `"header"`, the additional option `hash_on_header` allows specifying
  the header. `hash_fallback_header` fulfills the same role when `hash_fallback` is `"header"`.
  If there are multiple headers by the same name, they are all concatenated and used as a single value.

The option specified by `hash_on` is tried first. If it can't be used (for example, if the specified
header isn't found) then `hash_fallback` is tried.

[Back to TOC](#table-of-contents)

#### **Target**

Because the `upstream` maintains a history of changes, targets can only be
added, not modified nor deleted. To change a target, just add a new entry for
the target, and change the `weight` value. The last entry is the one that will
be used. As such setting `weight=0` will disable a target, effectively
deleting it from the balancer. Detailed information on adding and manipulating
targets is available in the `target` section of the [Admin API reference][target-object-reference].

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

[Back to TOC](#table-of-contents)

### **Blue-Green Deployments**

Using the ring-balancer a [blue-green deployment][blue-green-canary] can be easily orchestrated for
an API. Switching target infrastructure only requires a `PATCH` request on an
API, to change the `upstream` name.

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

# create an API targeting the Blue upstream
$ curl -X POST http://kong:8001/apis/ \
    --data "name=address-service" \
    --data "hosts=address.mydomain.com" \
    --data "upstream_url=http://address.v1.service/address"
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

To activate the Blue/Green switch, we now only need to update the API:

```bash
# Switch the API from Blue to Green upstream, v1 -> v2
$ curl -X PATCH http://kong:8001/apis/address-service \
    --data "upstream_url=http://address.v2.service/address"
```

Incoming requests with host header set to `address.mydomain.com` will now be
proxied by Kong to the new targets; 1/2 of the requests will go to
`http://192.168.34.17:80/address` (`weight=100`), and the other 1/2 will go to
`http://192.168.34.18:80/address` (`weight=100`).

As always, the changes through the Kong management API are dynamic and will take
effect immediately. No reload or restart is required, and no in progress
requests will be dropped.

[Back to TOC](#table-of-contents)

### **Canary Releases**

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

The changes through the Kong management API are dynamic and will take
effect immediately. No reload or restart is required, and no in progress
requests will be dropped.

[Back to TOC](#table-of-contents)

[target-object-reference]: /docs/{{page.kong_version}}/admin-api#target-object
[blue-green-canary]: http://blog.christianposta.com/deploy/blue-green-deployments-a-b-testing-and-canary-releases/
