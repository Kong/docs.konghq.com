---
title: Clustering Reference
---

# Introduction

A Kong cluster allows you to scale the system horizontally by adding more
machines to handle more incoming requests. They will all share the same
configuration since they point to the same database. Kong nodes pointing to the
**same datastore** will be part of the same Kong cluster.

You need a load-balancer in front of your Kong cluster to distribute traffic
across your available nodes.

## What a Kong cluster does and doesn't do

**Having a Kong cluster does not mean that your clients traffic will be
load-balanced across your Kong nodes out of the box.** You still need a
load-balancer in front of your Kong nodes to distribute your traffic. Instead,
a Kong cluster means that those nodes will share the same configuration.

For performance reasons, Kong avoids database connections when proxying
requests, and caches the contents of your database in memory. The cached
entities include APIs, Consumers, Plugins, Credentials, etc... Since those
values are in memory, any change made via the Admin API of one of the nodes
needs to be propagated to the other nodes.

This document describes how those cached entities are being invalidated and how
to configure your Kong nodes for your use case, which lies somewhere between
performance and consistency.

[Back to TOC](#table-of-contents)

## Single node Kong clusters

A single Kong node connected to a database (Cassandra or PostgreSQL) creates a
Kong cluster of one node. Any changes applied via the Admin API of this node
will instantly take effect. Example:

Consider a single Kong node `A`. If we delete a previously registered API:

```bash
$ curl -X DELETE http://127.0.0.1:8001/apis/test-api
```

Then any subsequent request to `A` would instantly return `404 Not Found`, as
the node purged it from its local cache:

```bash
$ curl -i http://127.0.0.1:8000/test-api
```

[Back to TOC](#table-of-contents)

## Multiple nodes Kong clusters

In a cluster of multiple Kong nodes, other nodes connected to the same database
would not instantly be notified that the API was deleted by node `A`.  While
the API is **not** in the database anymore (it was deleted by node `A`), it is
**still** in node `B`'s memory.

All nodes perform a periodic background job to synchronize with changes that
may have been triggered by other nodes. The frequency of this job can be
configured via:

* [db_update_frequency][db_update_frequency] (default: 5 seconds)

Every `db_update_frequency` seconds, all running Kong nodes will poll the
database for any update, and will purge the relevant entities from their cache
if necessary.

If we delete an API from node `A`, this change will not be effective in node
`B` until node `B`s next database poll, which will occur up to
`db_update_frequency` seconds later (though it could happen sooner).

This makes Kong clusters **eventually consistent**.

[Back to TOC](#table-of-contents)

## What is being cached?

All of the core entities such as APIs, Plugins, Consumers, Credentials are
cached in memory by Kong and depend on their invalidation via the polling
mechanism to be updated.

Additionally, Kong also caches **database misses**. This means that if you
configure an API with no plugin, Kong will cache this information. Example:

On node `A`, we add an API:

```bash
# node A
$ curl -X POST http://127.0.0.1:8001/apis \
    --data "name=example" \
    --data "upstream_url=http://example.com" \
    --data "uris=example"
```

A request to the Proxy port of both node `A` and `B` will cache this API, and
the fact that no plugin is configured on it:

```bash
# node A
$ curl http://127.0.0.1:8000/example
HTTP 200 OK
...
```

```bash
# node B
$ curl http://127.0.0.2:8000/example
HTTP 200 OK
...
```

Now, say we add a plugin to this API via node `A`'s Admin API:

```bash
# node A
$ curl -X POST http://127.0.0.1:8001/apis/example/plugins \
    --data "name=example-plugin"
```

Because this request was issued via node `A`'s Admin API, node `A` will locally
invalidate its cache and on subsequent requests, it will detect that this API
has a plugin configured.

However, node `B` hasn't run a database poll yet, and still caches that this
API has no plugin to run. It will be so until node `B` runs its database
polling job.

**Conclusion**: all CRUD operations trigger cache invalidations. Creation
(`POST`, `PUT`) will invalidate cached database misses, and update/deletion
(`PATCH`, `DELETE`) will invalidate cached database hits.

[Back to TOC](#table-of-contents)

## How to configure database caching?

You can configure 3 properties in the Kong configuration file, the most
important one being `db_update_frequency`, which determine where your Kong
nodes stand on the performance vs consistency trade off.

Kong comes with default values tuned for consistency, in order to let you
experiment with its clustering capabilities while avoiding "surprises". As you
prepare a production setup, you should consider tuning those values to ensure
that your performance constraints are respected.

### 1. [db_update_frequency][db_update_frequency] (default: 5s)

This value determines the frequency at which your Kong nodes will be polling
the database for invalidation events. A lower value will mean that the polling
job will be executed more frequently, but that your Kong nodes will keep up
with changes you apply. A higher value will mean that your Kong nodes will
spend less time running the polling jobs, and will focus on proxying your
traffic.

**Note**: changes propagate through the cluster in up to `db_update_frequency`
seconds.

[Back to TOC](#table-of-contents)

### 2. [db_update_propagation][db_update_propagation] (default: 0s)

If your database itself is eventually consistent (ie: Cassandra), you **must**
configure this value. It is to ensure that the change has time to propagate
across your database nodes. When set, Kong nodes receiving invalidation events
from their polling jobs will delay the purging of their cache for
`db_update_propagation` seconds.

If a Kong node connected to an eventual consistent database was not delaying
the event handling, it could purge its cache, only to cache the non-updated
value again (because the change hasn't propagated through the database yet)!

You should set this value to an estimate of the amount of time your database
cluster takes to propagate changes.

**Note**: when this value is set, changes propagate through the cluster in
up to `db_update_frequency + db_update_propagation` seconds.

[Back to TOC](#table-of-contents)

### 3. [db_cache_ttl][db_cache_ttl] (default: 3600s)

The time (in seconds) for which Kong will cache database entities (both hits
and misses). This Time-To-Live value acts as a safeguard in case a Kong node
misses an invalidation event, to avoid it from running on stale data for too
long. When the TTL is reached, the value will be purged from its cache, and the
next database result will be cached again.

You can configure your cache to not invalidate data based on this TTL, by
disabling it. To disable it, set this value to `0`. But be wary: if a Kong
node misses an invalidation event for any reason, it might run with a stale
value in its cache for an undefined amount of time, until the cache is
manually purged, or the node is restarted.

[Back to TOC](#table-of-contents)

### 4. When using Cassandra

If you use Cassandra as your Kong database, you **must** set
[db_update_propagation][db_update_propagation] to a non-zero value. Since
Cassandra is eventually consistent by nature, this will ensure that Kong nodes
do not prematurely invalidate their cache, only to fetch and catch a
not up-to-date entity again. Kong will present you a warning logs if you did
not configure this value when using Cassandra.

Additionally, you might want to configure `cassandra_consistency` to a value
like `QUORUM` or `LOCAL_QUORUM`, to ensure that values being cached by your
Kong nodes are up-to-date values from your database.

[Back to TOC](#table-of-contents)

## Interacting with the cache via the Admin API

If for some reason, you wish to investigate the cached values, or manually
invalidate a value cached by Kong (a cached hit or miss), you can do so via the
Admin API `/cache` endpoint.

### Inspect a cached value

**Endpoint**

<div class="endpoint get">/cache/{cache_key}</div>

**Response**

If a value with that key is cached:

```
HTTP 200 OK
...
{
    ...
}
```

Else:

```
HTTP 404 Not Found
```

**Note**: retrieving the `cache_key` for each entity being cached by Kong is
currently an undocumented process. Future versions of the Admin API will make
this process easier.

[Back to TOC](#table-of-contents)

### Purge a cached value

**Endpoint**

<div class="endpoint delete">/cache/{cache_key}</div>

**Response**

```
HTTP 204 No Content
...
```

**Note**: retrieving the `cache_key` for each entity being cached by Kong is
currently an undocumented process. Future versions of the Admin API will make
this process easier.

[Back to TOC](#table-of-contents)

### Purge a node's cache

**Endpoint**

<div class="endpoint delete">/cache</div>

**Response**

```
HTTP 204 No Content
```

**Note**: be wary of using this endpoint on a warm, production running node.
If the node is receiving a lot of traffic, purging its cache at the same time
will trigger many requests to your database, and could cause a
[dog-pile effect](https://en.wikipedia.org/wiki/Cache_stampede).

[Back to TOC](#table-of-contents)

[db_update_frequency]: /{{page.kong_version}}/configuration/#db_update_frequency
[db_update_propagation]: /{{page.kong_version}}/configuration/#db_update_propagation
[db_cache_ttl]: /{{page.kong_version}}/configuration/#db_cache_ttl
