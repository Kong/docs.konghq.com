---
title: Partials
badge: enterprise
concept_type: explanation
---

## What are Partials?

Some entities in {{site.base_gateway}} share common configuration settings that often need to be repeated. For example, multiple plugins that connect to Redis may require the same connection settings. Without Partials, you would need to replicate this configuration across all plugins. If the settings change, you would need to update each plugin individually.

Partials address this issue by allowing you to extract shared configurations into reusable entities that can be linked to multiple plugins. To ensure validation and consistency, Partials have defined types. 

{{site.base_gateway}} supports the following types of Partials:

- **`redis-ce`**: Stores common Redis configurations for plugins available in {{site.ce_product_name}}.
- **`redis-ee`**: Stores common Redis configurations for plugins available only in {{site.ee_product_name}}.

{:.note}
> An easy way to determine the required Redis configuration is by examining the fields in use. Redis CE has a shorter and simpler configuration, whereas Redis EE provides options for configuring Redis Sentinel or Redis Cluster for connection.

## Creating a Partial

To create a Partial, send a POST request to the Admin API:

```sh
curl -i -X POST http://localhost:8001/partials \
  -H "Content-Type: application/json" \
  --data '{
    "name": "YOUR-PARTIAL-NAME",
    "type": "redis-ce",
    "config": {
      "host": "REDIS-HOST"
    }
  }'
```

Additional fields can also be defined. To verify the available fields for each Partial type, refer to the `/schemas/partials/redis-ce` and `/schemas/partials/redis-ee` endpoints.

## Using a Partial in plugin configuration

After creating a Partial, you can link it to a plugin using a POST or PUT request. For example, to link a Rate Limiting plugin to a Partial:

```sh
curl -i -X POST http://localhost:8001/plugins \
  -H "Content-Type: application/json" \
  --data '{
    "name": "rate-limiting",
    "config": {
      "minute": 10
    },
    "partials": [
      { "id": "PARTIAL-ID-TO-LINK" }
    ]
  }'
```

This Rate Limiting plugin will now use all of the Redis configuration defined in the partial.
{:.important}
> You cannot provide inline Redis configuration alongside Partial-linked configurations. Either define Redis settings in the plugin, or skip the Redis key and use a Partial.

The response will include the plugin's configuration along with the expanded Partial configuration. Together, these represent the complete configuration the plugin will use, merging its individual settings with those inherited from the linked Partial. This ensures you can see exactly how the plugin will behave.



## Verifying Plugin-Partial links

To verify if a plugin is using a Partial, check the plugin's configuration:

```sh
curl -i -X GET http://localhost:8001/plugins/{plugin-id}
```

The partials key in the response will show the linked Partials. To view the complete configuration, including settings from linked Partials, append the `expand_partials=true` query parameter.


## Updating a Partial

Updates to a Partial are automatically reflected in all linked plugins. Use caution when updating Partials, as incorrect configurations (for example, a wrong Redis port) can disrupt multiple plugins.

## Detaching a Partial from a plugin

To unlink a plugin from a Partial, update the plugin configuration and omit the partials key, as shown below:

```sh
curl -i -X PUT http://localhost:8001/plugins/{PLUGIN_ID} \
  -H "Content-Type: application/json" \
  --data '{
    "name": "rate-limiting",
    "config": {
      "minute": 10,
      "redis": {
        "host": "YOUR-REDIS-HOST"
      }
    }
  }'
```

This action removes the link between the plugin and the Partial.

## Listing plugins linked to a Partial

To see which plugins are linked to a specific Partial:

```sh
curl -i -X GET http://localhost:8001/partials/{PARTIAL-ID}/links
```

The response provides a paginated list of linked plugins.

## Deleting a Partial

Before deleting a Partial, ensure all linked plugins are unlinked. Then, delete the Partial:

```sh
curl -i -X DELETE http://localhost:8001/partials/{PARTIAL-ID}
```

## Custom Plugins

Users can leverage the Partials feature in their custom plugins by adjusting the plugin schema.
To make custom plugins compatible with Partials, add the `supported_partials` key to the schema and specify
the appropriate Partial type. If the Redis configuration in use is of the {{site.ce_product_name}} type,
use `redis-ce`; otherwise, use `redis-ee`.

Below is an example schema for a custom plugin utilizing a Partial:

```lua
{
  name = "custom-plugin-with-redis",
  supported_partials = {
    ["redis-ee"] = { "config.redis" },
  },
  fields = {
    {
      config = {
        type = "record",
        fields = {
          { some_other_config_key = { type = "string", required = true }},
          { redis = redis.config_schema }
        },
      },
    },
  },
}
```

{:.important} > **Using DAO in custom plugins**
> Be aware that when using a Partial, the configuration belonging to the Partial is no longer stored alongside
> the plugin. If your code relies on Kong's dao and expects entities to contain Redis information,
> this data will not be retrieved when using `kong.db.plugins:select(plugin_id)`.
> Such a call will only fetch data stored in the plugin itself.
>
> To include the Partial's data within the plugin configuration, pass a special option parameter,
> such as: `kong.db.plugins:select(plugin_id, { expand_partials = true })`.


## Detailed API

For more information about Partial configurations and usage, see the [API spec](/gateway/api/admin-ee/latest/#/partials/listPartials).
