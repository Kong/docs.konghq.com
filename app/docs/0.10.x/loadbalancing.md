---
title: Loadbalancing reference
---

# Loadbalancing reference

Kong provides multiple ways of loadbalancing requests to multiple backend services.
A straight forward DNS based method and a more dynamic ring-balancer that also
allows for service registry without needing a DNS server.

### Table of Contents

- [DNS based loadbalancing](#dns-based-loadbalancing)
  - [A records](#a-records)
  - [SRV records](#srv-records)
  - [DNS priorities](#dns-priorities)

- [Ring-balancer](#ring-balancer)
  - [upstream](#upstream)
  - [target](#target)

### DNS based loadbalancing

When using dns based load balancing the registration of the backend services is
done outside of Kong and Kong only receives updates from the dns server.

Every api that has been defined with an `upstream_url` containing a hostname
(instead of an IP address) will automatically use dns based loadbalancing
if the name resolves to multiple ip addresses. Provided the hostname does not
resolve to an `upstream` name or a name in your `localhosts` file.

The dns record `ttl` setting (time to live) determines how often the information
is refreshed. When using a `ttl` of 0, every request will be resolved using its
own dns query. Obviously this will have a performance penalty, but the latency of
updates/changes will be very low.

[Back to TOC](#table-of-contents)

#### **A records**

An A record only contains (one or more) IP addresses. Hence when a hostname
resolves to an A record, each backend service must have its own IP address.

Because there is no `weight` information, all entries will be treated as equally 
weighted in the loadbalancer, and the balancer will do a straight forward
round-robin.

The initial pick of an ip address from a dns record is randomized. This is to
make sure that even with a `ttl` of 0 the load is properly distributed.

[Back to TOC](#table-of-contents)

#### **SRV records**

An SRV record contains weight and port information for all of its IP addresses.
A backend service can be identified by a unique combination of IP address 
and port number. Hence a single ip address can host multiple instances of the 
same service on different ports.

Because the `weight` information is available, each entry will get its own
weight in the loadbalancer and it will perform a weighted-round-robin.

Similarly any given port information will be overridden by the port information from
the dns server. If an api has an `upstream_url=http://myhost.com:123/somepath`
and `myhost.com` resolves to a SRV record with `127.0.0.1:456` then the request
will be proxied to `http://127.0.0.1:456/somepath`, as port `123` will be 
overridden by `456`.

The initial pick of an ip address + port combo is randomized, ensuring a proper
distribution, even with a `ttl` setting of 0.

**TIP**: whenever the dns record is refreshed a list is generated to handle the
weighting properly. Try to keep the weights as multiples of each other to keep
the algorithm performant. eg. 2 weights; 17 and 31 would result in a structure 
with 527 entries. Whereas weights 16 and 32 (or their smallest relative 
counterparts 1 and 2) would result in a structure with merely 3 entries.
Especially with a very small (or even 0) `ttl` value.

[Back to TOC](#table-of-contents)

#### **DNS priorities**

The DNS resolver will start resolving the following record types in order;

  1. the last succesful type previously resolved
  2. SRV record
  3. A record
  4. CNAME record

So if the hostname you use has both SRV entries and A entries, it will start
with SRV. If you want A records to be used, you must remove the SRV records from
the dns server. If you only have A records, then the SRV lookup will fail and
it will fallback on an A query, etc.

[Back to TOC](#table-of-contents)

### **Ring-balancer**

When using the ring-balancer, the adding and removing of backend services will
be handled by Kong, and no dns updates will be necessary. Kong will act as the
service registry. Nodes can be added/deleted with a single http request and
will instantly start/stop receiving traffic.

Configuring the ring-balancer is done through the `upstream` and `target`
entities.

  - `target` an IP address or hostname with a port number where a backend
    service resides, eg. "192.168.100.12:80". Each target gets an additional
    `weight` to indicate the relative load it gets.
  - `upstream` a 'virtual hostname' which can be used in an api `upstream_url`
    field. Eg. an upstream named `weather.v2.service` would get all requests
    from an api with `upstream_url=http://weather.v2.service/some/path`.

[Back to TOC](#table-of-contents)

#### **upstream**

Each upstream gets its own ring-balancer. Each `upstream` can have many 
`target` entries attached to it, and requests proxied to the 'virtual hostname' 
will be loadbalanced over the targets. A ring-balancer has a pre-defined
number of slots, and based on the target weights the slots get assigned to the
targets of the upstream. Incoming requests will be proxied in a weighted 
round-robin manner.

Adding and removing targets can be done with a simple http request on the 
management api. This operation is relatively cheap. Changing the upstream
itself is more expensive as the balancer will need to be rebuilt when the 
number of slots change for example.
The only occurence where the balancer will be rebuilt automatically is when 
the target history is cleaned. Other than that, only upon changes.

Within the balancer there are the positions (from 1 to `slots`) on the ring,
which each get a 'slot' assigned 1-on-1. Hence there are also `slots` number of slots, but
they are __randomly distributed__ over the ring-positions. This randomness can be
set by using the `orderlist`, but we strongly advice against doing that.

The randomness is required to make invoking the ring-balancer cheap at 
runtime. A simple round-robin over the wheel (the positions) will do to 
provide a well distributed weighted round-robin over the `targets`. Whilst
also having cheap operations when inserting/deleting targets.

The number of slots to use per target should (at least) be around 100 to make 
sure the slots are properly distributed. Eg. for an expected maximum of 8
targets, the `upstream` should be defined with at least `slots=800`. Even if
the initial setup only features 2 targets.

The tradeoff being that the higher the number of slots, the better the random 
distribution, but the more expensive the changes are (add/removing targets)

[Back to TOC](#table-of-contents)

#### **target**

Because the `upstream` maintains a history of changes, targets can only be 
added. Not modified nor deleted. To change a target, just add a new entry for
the target, and change the `weight` value. The last entry is the one that will
be used. As such setting `weight=0` will disable a target, effectively 
deleting it from the balancer.

The targets will be automatically cleaned when there are 10x more inactive 
entries than active ones. Cleaning will involve rebuilding the balancer, and
hence is more expensive than just adding a target entry.

A `target` can also have a hostname instead of an ip address. In that case
the name will be resolved and all entries found will individually be added to
the ring balancer. Eg. adding `api.host.com:123` with `weight=100`. The 
name 'api.host.com' resolves to an A record with 2 ip addresses. Then both
ip addresses will be added as target, each getting `weight=100` and port 123.
__NOTE__: the weight is used for the individual entries, not for the whole!

Would it resolve to an SRV record, then also the `port` and `weight` fields 
from the dns record would be picked up, and would overrule the given port `123`
and `weight=100`.

The balancer will honor the dns records `ttl` setting and requery and update 
the balancer when it expires.

__Exception__: when a dns record has `ttl=0` then the hostname will be added
as a single target, with the specified weight. And upon every proxied request
to this target it will query the nameserver again.


[Back to TOC](#table-of-contents)
