---
title: Plugin Development - Caching custom entities
book: plugin_dev
chapter: 7
---

# {{page.title}}

#### Modules

```
"kong.plugins.<plugin_name>.daos"
"kong.plugins.<plugin_name>.hooks"
```

---

Your plugin may need to frequently access custom entities (explained in the [previous chapter]({{page.book.previous}})) on every request and/or response. Usually loading them once, and caching them in-memory, dramatically improves the performance while making sure the datastore is not stressed with an increased load.

Think of an api-key authentication plugin that needs to validate the api-key on every request, thus loading the custom credential object from the datastore on every request. When the client provides an api-key along with the request, normally you would query the datastore to check if that key exists, and then either block the request or retrieve the Consumer ID to identify the user. This would happen on every request, and it would be very inefficient:

* Querying the datastore adds latency on every request, making the request processing slower.
* The datastore would also be affected by an increase of load, potentially crashing or slowing down the datastore, which in turn would affect every Kong node.

To avoid querying the datastore every time, we can cache custom entities in-memory on the node, so that frequent entity lookups don't trigger a datastore query every time (only the first time), but happen in-memory, which is much faster and reliable that querying it from the datastore (especially under heavy load).

<div class="alert alert-warning">
  <strong>Note:</strong> When caching custom entities in-memory, then you also need to provide an invalidation mechanism, implemented in the "hooks.lua" file.
</div>

---

### Caching custom entities

Once you have defined your custom entities, you can cache them in-memory in your code by requiring the `database_cache` dependency:

```
local cache = require "kong.tools.database_cache"
```

This module exposes the following functions:

| Function name                      | Description
|------------------------------------|---------------------------
| `ok, err = cache.set(key, value)`  | Stores a Lua object into the in-memory cache with the specified key. The value can be any Lua type, including tables. Returns `true` or `false`, and and `err` if the operation fails.
| `value = cache.get(key)`           | Retrieves the Lua object stored in a specific key.
| `cache.delete(key)`                | Deletes the cache object stored at the specified key.
| `newvalue, err = cache.incr(key, amount)` | Increments a number stored in the specified key, by an amount of units specified. The number needs to be already present in the cache or an error will be returned. If successful, it returns the new incremented value, otherwise an error.
| `value = cache.get_or_set(key, function)` | This is an utility method that retrieves an object with the specified key, but if the object is `nil` then the passed function will be executed instead, whose return value will be used to store the object at the specified key. This effectively makes sure that the object is only loaded from the datastore one time, since every other invocation will load the object from the in-memory cache.

Bringing back our authentication plugin example, to lookup a credential with a specific api-key, we would write something like:

```lua
-- access.lua

local credential

-- Retrieve the apikey from the request querystring
local apikey = request.get_uri_args().apikey
if apikey then -- If the apikey has been passed, we can check if it exists

  -- We are using cache.get_or_set to first check if the apikey has been already stored
  -- into the in-memory cache at the key: "apikeys."..apikey
  -- If it's not, then we lookup the datastore and return the credential object. Internally
  -- cache.get_or_set will save the value in-memory, and then return the credential.
  credential = cache.get_or_set("apikeys."..apikey, function()
    local apikeys, err = dao.apikeys:find_all({key = apikey}) -- Lookup in the datastore
    if err then
      return responses.send_HTTP_INTERNAL_SERVER_ERROR(err)
    elseif #apikeys == 1 then
      return apikeys[1] -- Return the credential (this will be also stored in-memory)
    end
  end)
end

if not credential then -- If the credential couldn't be found, show an error message
  return responses.send_HTTP_FORBIDDEN("Invalid authentication credentials")
end
```

By doing so it doesn't matter how many requests the client makes with that particular api-key, after the first request every lookup will be done in-memory without querying the datastore.

#### Updating or deleting a custom entity

Every time a cached custom entity is updated or deleted on the datastore, for example using the Admin API, it creates an inconsistency between the data in the datastore, and the data cached in-memory in the Kong node. To avoid this inconsistency, we need to delete the cached entity from the in-memory store and force Kong to request it again from the datastore. In order to do so we must implement an invalidation hook.

---

### Invalidating custom entities

Every time an entity is being created/updated/deleted in the datastore, Kong notifies the datastore operation across all the nodes telling what command has been executed and what entity has been affected by it. This happens for APIs, Plugins and Consumers, but also for custom entities.

Thanks to this behavior, we can listen to these events and response with the appropriate action, so that when a cached entity is being modified in the datastore, we can explicitly remove it from the cache to avoid having an inconsistent state between the datastore and the cache itself. Removing it from the in-memory cache will trigger the system to query the datastore again, and re-cache the entity.

The events that Kong propagates are:

| Event name                         | Description
|------------------------------------|---------------------------
| `ENTITY_CREATED`                   | When any entity is being created.
| `ENTITY_UPDATED`                   | When any entity is being updated.
| `ENTITY_DELETED`                   | When any entity is being deleted.

In order to listen to these events, we need to implement the `hooks.lua` file and distribute it with our plugin, for example:

```lua
-- hooks.lua

local events = require "kong.core.events"
local cache = require "kong.tools.database_cache"

local function invalidate_on_update(message_t)
  if message_t.collection == "apikeys" then
    cache.delete("apikeys."..message_t.old_entity.apikey)
  end
end

local function invalidate_on_create(message_t)
  if message_t.collection == "apikeys" then
    cache.delete("apikeys."..message_t.entity.apikey)
  end
end

return {
  [events.TYPES.ENTITY_UPDATED] = function(message_t)
    invalidate_on_update(message_t)
  end,
  [events.TYPES.ENTITY_DELETED] = function(message_t)
    invalidate_on_create(message_t)
  end
}

```

In the example above the plugin is listening to the `ENTITY_UPDATED` and `ENTITY_DELETED` events and responding by invoking the appropriate function. The `message_t` table contains the event properties:

| Property name                      | Type   | Description
|------------------------------------|--------|--------------------
| `collection`                       | String | The collection in the datastore affected by the operation.
| `entity`                           | Table  | The most recent updated entity, or the entity deleted or created.
| `old_entity`                       | Table  | Only for update events, the old version of the entity.

The entities being transmitted in the `entity` and `old_entity` properties do not have all the fields defined in the schema, but only a subset. This is required because every event is sent in a UDP packet with a payload size limit of 512 bytes. This subset is being returned by the `marshall_event` function in the schema, that you can optionally implement.

#### marshall_event

This function serializes the custom entity to a minimal version that only includes the fields we will later need to use in `hooks.lua`. If `marshall_event` is not implememented, by default Kong does not send any entity field value along with the event.

For example:

```lua
-- daos.lua

local SCHEMA = {
  primary_key = {"id"},
  -- clustering_key = {}, -- none for this entity
  fields = {
    id = {type = "id", dao_insert_value = true},
    created_at = {type = "timestamp", dao_insert_value = true},
    consumer_id = {type = "id", required = true, queryable = true, foreign = "consumers:id"},
    apikey = {type = "string", required = false, unique = true, queryable = true}
  },
  marshall_event = function(self, t) -- This is related to the invalidation hook
    return { id = t.id, consumer_id = t.consumer_id, apikey = t.apikey }
  end
}
```

In the example above the custom entity provides a `marshall_event` function that returns an object with its `id`, `consumer_id` and `apikey` fields. In our hooks we don't need `creation_date` to invalidate the entity, so we don't care to propagate it in the event. The `t` table in the arguments is the original object with all its fields.

<div class="alert alert-warning">
  <strong>Note:</strong> The JSON serialization of the Lua table that's being returned must not exceed 512 bytes, in order to fit the entire event in one UDP packet. Failure to meet this contraints will prevent invalidation events from being propagated, thus creating inconsistencies.
</div>

---

### Extending the Admin API

As you are probably aware, the [Admin API] is where Kong users communicate with Kong to setup their APIs and plugins. It is likely that they also need to be able to interact with the custom entities you implemented for your plugin (for example, creating and deleting API keys). The way you would do this is by extending the Admin API, which we will detail in the next chapter: [Extending the Admin API]({{page.book.next}}).

---

Next: [Extending the Admin API &rsaquo;]({{page.book.next}})

[Admin API]: /docs/{{page.kong_version}}/admin-api/
