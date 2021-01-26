---
title: Plugin Development - Caching Custom Entities
book: plugin_dev
chapter: 7
---

## Introduction

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

## Modules

```
kong.plugins.<plugin_name>.daos
```

## Caching custom entities

Once you have defined your custom entities, you can cache them in-memory in
your code by using the [kong.cache](/{{page.kong_version}}/pdk/#kong-cache)
module provided by the [Plugin Development Kit]:

```
local cache = kong.cache
```

There are 2 levels of cache:

1. L1: Lua memory cache - local to an Nginx worker process.
   This can hold any type of Lua value.
2. L2: Shared memory cache (SHM) - local to an Nginx node, but shared between
   all the workers. This can only hold scalar values, and hence requires
   (de)serialization of a more complex types such as Lua tables.

When data is fetched from the database, it will be stored in both caches. 
If the same worker process requests the data again, it will retrieve the
previously deserialized data from the Lua memory cache. If a different
worker within the same Nginx node requests that data, it will find the data
in the SHM, deserialize it (and store it in its own Lua memory cache) and
then return it.

This module exposes the following functions:

Function name                                 | Description
----------------------------------------------|---------------------------
`value, err = cache:get(key, opts?, cb, ...)` | Retrieves the value from the cache. If the cache does not have value (miss), invokes `cb` in protected mode. `cb` must return one (and only one) value that will be cached. It *can* throw errors, as those will be caught and properly logged by Kong, at the `ngx.ERR` level. This function **does** cache negative results (`nil`). As such, one must rely on its second argument `err` when checking for errors.
`ttl, err, value = cache:probe(key)`          | Checks if a value is cached. If it is, returns its remaining ttl. It not, returns `nil`. The value being cached can also be a negative caching. The third return value is the value being cached itself.
`cache:invalidate_local(key)`                 | Evicts a value from the node's cache.
`cache:invalidate(key)`                       | Evicts a value from the node's cache **and** propagates the eviction events to all other nodes in the cluster.
`cache:purge()`                               | Evicts **all** values from the node's cache.

Bringing back our authentication plugin example, to lookup a credential with a
specific api-key, we would write something similar to:

```lua
-- handler.lua
local BasePlugin = require "kong.plugins.base_plugin"


local kong = kong


local function load_credential(key)
  local credential, err = kong.db.keyauth_credentials:select_by_key(key)
  if not credential then
    return nil, err
  end
  return credential
end


local CustomHandler = BasePlugin:extend()


CustomHandler.VERSION  = "1.0.0"
CustomHandler.PRIORITY = 1010


function CustomHandler:new()
  CustomHandler.super.new(self, "my-custom-plugin")
end


function CustomHandler:access(config)
  CustomHandler.super.access(self)
  
  -- retrieve the apikey from the request querystring
  local key = kong.request.get_query_arg("apikey")

  local credential_cache_key = kong.db.keyauth_credentials:cache_key(key)

  -- We are using cache.get to first check if the apikey has been already
  -- stored into the in-memory cache. If it's not, then we lookup the datastore
  -- and return the credential object. Internally cache.get will save the value
  -- in-memory, and then return the credential.
  local credential, err = kong.cache:get(credential_cache_key, nil,
                                         load_credential, credential_cache_key)
  if err then
    kong.log.err(err)
    return kong.response.exit(500, {
      message = "Unexpected error"
    })
  end
    
  if not credential then
    -- no credentials in cache nor datastore
    return kong.response.exit(401, {
      message = "Invalid authentication credentials"
    })
  end
    
  -- set an upstream header if the credential exists and is valid
  kong.service.request.set_header("X-API-Key", credential.apikey)
end


return CustomHandler
```

Note that in the above example, we use various components from the [Plugin
Development Kit] to interact with the request, cache module, or even produce a
response from our plugin.

Now, with the above mechanism in place, once a Consumer has made a request with
their API key, the cache will be considered warm and subsequent requests won't
result in a database query.

The cache is used in several places in the [Key-Auth plugin handler](https://github.com/Kong/kong/blob/master/kong/plugins/key-auth/handler.lua).
Give that file a look in order to see how an official plugin uses the cache.

### Updating or deleting a custom entity

Every time a cached custom entity is updated or deleted in the datastore (i.e.
using the Admin API), it creates an inconsistency between the data in the
datastore, and the data cached in the Kong nodes' memory. To avoid this
inconsistency, we need to evict the cached entity from the in-memory store and
force Kong to request it again from the datastore. We refer to this process as
cache invalidation.

---

## Cache invalidation for your entities

If you wish that your cached entities be invalidated upon a CRUD operation
rather than having to wait for them to reach their TTL, you have to follow a
few steps. This process can be automated for most entities, but manually
subscribing to some CRUD events might be required to invalidate some entities
with more complex relationships.

### Automatic cache invalidation

Cache invalidation can be provided out of the box for your entities if you rely
on the `cache_key` property of your entity's schema. For example, in the
following schema:

```lua
local typedefs = require "kong.db.schema.typedefs"


return {
  -- this plugin only results in one custom DAO, named `keyauth_credentials`:
  keyauth_credentials = {
    name                  = "keyauth_credentials", -- the actual table in the database
    endpoint_key          = "key",
    primary_key           = { "id" },
    cache_key             = { "key" },
    generate_admin_api    = true,
    admin_api_name        = "key-auths",
    admin_api_nested_name = "key-auth",    
    fields = {
      {
        -- a value to be inserted by the DAO itself
        -- (think of serial id and the uniqueness of such required here)
        id = typedefs.uuid,
      },
      {
        -- also interted by the DAO itself
        created_at = typedefs.auto_timestamp_s,
      },
      {
        -- a foreign key to a consumer's id
        consumer = {
          type      = "foreign",
          reference = "consumers",
          default   = ngx.null,
          on_delete = "cascade",
        },
      },
      {
        -- a unique API key
        key = {
          type      = "string",
          required  = false,
          unique    = true,
          auto      = true,
        },
      },
    },
  },
}
```

We can see that we declare the cache key of this API key entity to be its
`key` attribute. We use `key` here because it has a unique constraints
applied to it. Hence, the attributes added to `cache_key` should result in
a unique combination, so that no two entities could yield the same cache key.

Adding this value allows you to use the following function on the DAO of that
entity:

```lua
cache_key = kong.db.<dao>:cache_key(arg1, arg2, arg3, ...)
```

Where the arguments must be the attributes specified in your schema's
`cache_key` property, in the order they were specified. This function then
computes a string value `cache_key` that is ensured to be unique.

For example, if we were to generate the cache_key of an API key:

```lua
local cache_key = kong.db.keyauth_credentials:cache_key("abcd")
```

This would produce a cache_key for the API key `"abcd"` (retrieved from one
of the query's arguments) that we can the use to retrieve the key from the
cache (or fetch from the database if the cache is a miss):

```lua
local key       = kong.request.get_query_arg("apikey")
local cache_key = kong.db.keyauth_credentials:cache_key(key)

local credential, err = kong.cache:get(cache_key, nil, load_entity_key, apikey)
if err then
  kong.log.err(err)
  return kong.response.exit(500, { message = "Unexpected error" })
end

if not credential then
  return kong.response.exit(401, { message = "Invalid authentication credentials" })
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

See the [Clustering Guide](/{{page.kong_version}}/clustering/) to ensure
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
  -- listen to all CRUD operations made on Consumers
  kong.worker_events.register(function(data)

  end, "crud", "consumers")

  -- or, listen to a specific CRUD operation only
  kong.worker_events.register(function(data)
    kong.log.inspect(data.operation)  -- "update"
    kong.log.inspect(data.old_entity) -- old entity table (only for "update")
    kong.log.inspect(data.entity)     -- new entity table
    kong.log.inspect(data.schema)     -- entity's schema
  end, "crud", "consumers:update")
end
```

Once the above listeners are in place for the desired entities, you can perform
manual invalidations of any entity that your plugin has cached as you wish so.
For instance:

```lua
kong.worker_events.register(function(data)
  if data.operation == "delete" then
    local cache_key = data.entity.id
    kong.cache:invalidate("prefix:" .. cache_key)
  end
end, "crud", "consumers")
```

## Extending the Admin API

As you are probably aware, the [Admin API] is where Kong users communicate with
Kong to setup their APIs and plugins. It is likely that they also need to be
able to interact with the custom entities you implemented for your plugin (for
example, creating and deleting API keys). The way you would do this is by
extending the Admin API, which we will detail in the next chapter:
[Extending the Admin API]({{page.book.next}}).

---

Next: [Extending the Admin API &rsaquo;]({{page.book.next}})

[Admin API]: /{{page.kong_version}}/admin-api/
[Plugin Development Kit]: /{{page.kong_version}}/pdk
