---
title: Plugin Development - Caching custom entities
book: plugin_dev
chapter: 7
---

## Modules

```
"kong.plugins.<plugin_name>.daos"
```

---

Your plugin may need to frequently access custom entities (explained in the
[previous chapter]({{page.book.previous}})) on every request and/or response.
Usually, loading them once and caching them in-memory dramatically improves
the performance while making sure the datastore is not stressed with an
increased load.

Think of an api-key authentication plugin that needs to validate the api-key on
every request, thus loading the custom credential object from the datastore on
every request. When the client provides an api-key along with the request,
normally you would query the datastore to check if that key exists, and then
either block the request or retrieve the Consumer ID to identify the user. This
would happen on every request, and it would be very inefficient:

* Querying the datastore adds latency on every request, making the request
  processing slower.
* The datastore would also be affected by an increase of load, potentially
  crashing or slowing down, which in turn would affect every Kong
  node.

To avoid querying the datastore every time, we can cache custom entities
in-memory on the node, so that frequent entity lookups don't trigger a
datastore query every time (only the first time), but happen in-memory, which
is much faster and reliable that querying it from the datastore (especially
under heavy load).

---

## Caching custom entities

Once you have defined your custom entities, you can cache them in-memory in
your code by using the `singletons.cache` module provided by Kong:

```
local singletons = require "kong.singletons"
local cache = singletons.cache
```

There are 2 levels of cache:

1. L1: Lua memory cache - local to an nginx worker
   This can hold any type of Lua value.
2. L2: Shared memory cache (SHM) - local to an nginx node, but shared between
   all workers. This can only hold scalar values, and hence requires
   (de)serialization.

When data is fetched from the database, it will be stored in both caches. Now
if the same worker process requests the data again, it will retrieve the
previously-deserialized data from the Lua memory cache. If a different
worker within the same nginx node requests that data, it will find the data
in the SHM, deserialize it (and store it in its own Lua memory cache) and
then return it.

This module exposes the following functions:

Function name                                 | Description
----------------------------------------------|---------------------------
`value, err = cache:get(key, opts?, cb, ...)` | Retrieves the value from the cache. If the cache does not have value (miss), invokes `cb` in protected mode. `cb` must return one (and only one) value that will be cached. It *can* throw errors, as those will be caught and properly logged by Kong, at the `ngx.ERR` level. This function **does** cache negative results (`nil`). As such, one must rely on its second argument `err` when checking for errors.
`ttl, err, value = cache:probe(key)`          | Checks if a value is cached. If it is, returns its remaining TTL. It not, returns `nil`. The value being cached can also be a negative caching. The third return value is the value being cached itself.
`cache:invalidate_local(key)`                       | Evicts a value from the node's cache.
`cache:invalidate(key)`                             | Evicts a value from the node's cache **and** propagates the eviction events to all other nodes in the cluster.
`cache:purge()`                                     | Evicts **all** values from the node's cache.

Bringing back our authentication plugin example, to lookup a credential with a
specific api-key, we would write something like:

```lua
-- access.lua
local singletons = require "kong.singletons"

local function load_entity_key(api_key)
  -- IMPORTANT: the callback is executed inside a lock, hence we cannot terminate
  -- a request here, we MUST always return.
  local apikeys, err = dao.apikeys:find_all({key = api_key}) -- Lookup in the datastore
  if err then
    error(err) -- caught by kong.cache and logged
  end

  if not apikeys then
    return nil -- nothing was found (cached for `neg_ttl`)
  end

  -- assuming the key was unique, we always only have 1 value...
  return apikeys[1] -- cache the credential (cached for `ttl`)
end

-- retrieve the apikey from the request querystring
local apikey = request.get_uri_args().apikey

-- We are using cache.get to first check if the apikey has been already
-- stored into the in-memory cache at the key: "apikeys." .. apikey
-- If it's not, then we lookup the datastore and return the credential
-- object. Internally cache.get will save the value in-memory, and then
-- return the credential.
local credential, err = cache:get("apikeys." .. apikey, nil,
                                  load_entity_key, apikey)
if err then
  return response.HTTP_INTERNAL_SERVER_ERROR(err)
end

if not credential then
  -- no credentials in cache nor datastore
  return responses.send_HTTP_FORBIDDEN("Invalid authentication credentials")
end

-- set an upstream header if the credential exists and is valid
ngx.req.set_header("X-API-Key", credential.apikey)
```

With the above mechanism in place, once a Consumer has made a request with
their API key, the cache will be considered warm and subsequent requests
won't result in a database query.

### Updating or deleting a custom entity

Every time a cached custom entity is updated or deleted in the datastore (i.e.
using the Admin API), it creates an inconsistency between the data in
the datastore, and the data cached in the Kong nodes' memory. To avoid this
inconsistency, we need to evict the cached entity from the in-memory store and
force Kong to request it again from the datastore. We refer to this process as
cache invalidation.

---

## Cache invalidation for your entities

If you wish that your cached entities be invalidated upon a CRUD operation
rather than having to wait for them to reach their TTL, you have to follow
a few steps. This process can be automated since 0.11.0 for most entities,
but manually subscribing to some CRUD events might be required to invalidate
some entities with more complex relationships.

### Automatic cache invalidation

Cache invalidation can be provided out of the box for your entities if you
rely on the `cache_key` property of your entity's schema. For example, in the
following schema:

```lua
local SCHEMA = {
  primary_key = { "id" },
  table = "keyauth_credentials",
  cache_key = { "key" }, -- cache key for this entity
  fields = {
    id = { type = "id" },
    created_at = { type = "timestamp", immutable = true },
    consumer_id = { type = "id", required = true, foreign = "consumers:id"},
    key = { type = "string", required = false, unique = true }
  }
}

return { keyauth_credentials = SCHEMA }
```

We can see that we declare the cache key of this API key entity to be its
`key` attribute. We use `key` here because it has a unique constraints
applied to it. Hence, the attributes added to `cache_key` should result in
a unique combination, so that no two entities could yield the same cache key.

Adding this value allows you to use the following function on the DAO of that
entity:

```lua
cache_key = dao:cache_key(arg1, arg2, arg3, ...)
```

Where the arguments must be the attributes specified in your schema's
`cache_key` property, in the order they were specified. This function then
computes a string value `cache_key` that is ensured to be unique.

For example, if we were to generate the cache_key of an API key:

```lua
local cache_key = singletons.dao.keyauth_credentials:cache_key("abcd")
```

This would produce a cache_key for the API key `"abcd"` (retrieved from one
of the query's arguments) that we can the use to retrieve the key from the
cache (or fetch from the database if the cache is a miss):

```lua
local apikey = request.get_uri_args().apikey
local cache_key = singletons.dao.keyauth_credentials:cache_key(apikey)

local credential, err = cache:get(cache_key, nil, load_entity_key, apikey)
if err then
  return response.HTTP_INTERNAL_SERVER_ERROR(err)
end

-- do something with the credential
```

If the `cache_key` is generated like so and specified in an entity's schema,
cache invalidation will be an automatic process: every CRUD operation that
affects this API key will be make Kong generate the affected `cache_key`, and
broadcast it to all of the other nodes on the cluster so they can evict
that particular value from their cache, and fetch the fresh value from the
datastore on the next request.

When a parent entity is receiving a CRUD operation (e.g. the Consumer owning
this API key, as per our schema's `consumer_id` attribute), Kong performs the
cache invalidation mechanism for both the parent and the child entity.

**Note**: Be aware of the negative caching that Kong provides. In the above
example, if there is no API key in the datastore for a given key, the cache
module will store the miss just as if it was a hit. This means that a
"Create" event (one that would create an API key with this given key) is also
propagated by Kong so that all nodes that stored the miss can evict it, and
properly fetch the newly created API key from the datastore.

See the [Clustering Guide](/enterprise/{{page.kong_version}}/clustering/) to ensure
that you have properly configured your cluster for such invalidation events.

### Manual cache invalidation

In some cases, the `cache_key` property of an entity's schema is not flexible
enough, and one must manually invalidate its cache. Reasons for this could be
that the plugin is not defining a relationship with another entity via the
traditional `foreign = "parent_entity:parent_attribute"` syntax, or because
it is not using the `cache_key` method from its DAO, or even because it is
somehow abusing the caching mechanism.

In those cases, you can manually setup your own subscriber to the same
invalidation channels Kong is listening to, and perform your own, custom
invalidation work.

To listen on invalidation channels inside of Kong, implement the following in
your plugin's `init_worker` handler:

```lua
function MyCustomHandler:init_worker()
  local worker_events = singletons.worker_events

  -- listen to all CRUD operations made on Consumers
  worker_events.register(function(data)

  end, "crud", "consumers")

  -- or, listen to a specific CRUD operation only
  worker_events.register(function(data)
    print(data.operation)  -- "update"
    print(data.old_entity) -- old entity table (only for "update")
    print(data.entity)     -- new entity table
    print(data.schema)     -- entity's schema
  end, "crud", "consumers:update")
end
```

Once the above listeners are in place for the desired entities, you can perform
manual invalidations of any entity that your plugin has cached as you wish so.
For instance:

```lua
singletons.worker_events.register(function(data)
  if data.operation == "delete" then
    local cache_key = data.entity.id
    singletons.cache:invalidate("prefix:" .. cache_key)
  end
end, "crud", "consumers")
```

## Extending the Admin API

As you are probably aware, the [Admin API] is where Kong users communicate with
Kong to setup their APIs and plugins. It is likely that they also need to be
able to interact with the custom entities you implemented for your plugin (for
example, creating and deleting API keys). The way you would do this is by
extending the Admin API, which we will detail in the next chapter: [Extending
the Admin API]({{page.book.next}}).

---

Next: [Extending the Admin API &rsaquo;]({{page.book.next}})

[Admin API]: /enterprise/{{page.kong_version}}/admin-api/
