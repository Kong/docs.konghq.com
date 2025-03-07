---
title: Partials
badge: enterprise
concept_type: explanation
---

## What are Partials?

Some entities in Kong share common configuration settings that often need to be repeated. For example, multiple plugins that connect to Redis may require the same connection settings. Without Partials, you would need to replicate this configuration across all plugins. If the settings change, you would need to update each plugin individually.

Partials address this issue by allowing you to extract shared configurations into reusable entities that can be linked to multiple plugins. To ensure validation and consistency, Partials have defined types. The first two supported types are:

- **`redis-ce`**: Stores common Redis configurations for plugins available in Kong OSS.
- **`redis-ee`**: Stores common Redis configurations for plugins available in Kong Enterprise.


## Creating a Partial

Partials are a new core entity so in order to create a Partial you need to send a request to the AdminAPI like this:

```sh
curl -i -X POST http://{HOSTNAME}:8001/partials \
  -H "Content-Type: application/json" \
  --data '{
    "name": "YOUR-PARTIAL-NAME",
    "type": "redis-ce",
    "config": {
      "host": "REDIS-HOST"
    }
  }'
```

Additional fields can also be defined. To verify the available fields for each Partial type, refer to the `/schemas/partials/redis-ce` and `/schemas/partials/redis-ee endpoints`.

## Using a Partial in Plugin Configuration

After creating a Partial, you can link it to a plugin using a POST or PUT request. For example, to link a rate-limiting plugin to a Partial:

```sh
curl -i -X POST http://{HOSTNAME}:8001/plugins \
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

### Important Notes:
- You cannot provide inline Redis configuration alongside Partial-linked configurations. Either define Redis settings in the plugin or skip the Redis key and use a Partial.

- The response will include the plugin's configuration along with the expanded Partial configuration. Together, these represent the complete configuration the plugin will use, merging its individual settings with those inherited from the linked Partial. This ensures you can see exactly how the plugin will behave.


Example response:
```sh
HTTP/1.1 201 Created
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 1021
Content-Type: application/json; charset=utf-8
Date: Thu, 06 Mar 2025 17:21:56 GMT
Server: kong/3.10.0.0-enterprise-edition
X-Kong-Admin-Latency: 18
X-Kong-Admin-Request-ID: ecae700275f3aa1a7f48f4483305c465

{
    "config": {
        "day": null,
        "error_code": 429,
        "error_message": "API rate limit exceeded",
        "fault_tolerant": true,
        "header_name": null,
        "hide_client_headers": false,
        "hour": null,
        "limit_by": "consumer",
        "minute": 10,
        "month": null,
        "path": null,
        "policy": "redis",
        "redis": {
            "database": 0,
            "host": "localhost",
            "password": null,
            "port": 6379,
            "server_name": null,
            "ssl": false,
            "ssl_verify": false,
            "timeout": 2000,
            "username": null
        },
        "redis_database": 0,
        "redis_host": "localhost",
        "redis_password": null,
        "redis_port": 6379,
        "redis_server_name": null,
        "redis_ssl": false,
        "redis_ssl_verify": false,
        "redis_timeout": 2000,
        "redis_username": null,
        "second": null,
        "sync_rate": -1,
        "year": null
    },
    "consumer": null,
    "consumer_group": null,
    "created_at": 1741281716,
    "enabled": true,
    "id": "974a63f3-87e9-4f6b-ace8-5e54c9084760",
    "instance_name": null,
    "name": "rate-limiting",
    "ordering": null,
    "partials": [
        {
            "id": "a542d158-b73f-4bb7-921e-ab1debc772a0",
            "name": "my-ce-partial-1",
            "path": "config.redis"
        }
    ],
    "protocols": [
        "grpc",
        "grpcs",
        "http",
        "https"
    ],
    "route": null,
    "service": null,
    "tags": null,
    "updated_at": 1741281716
}
```

## Verifying Plugin-Partial Links

To verify if a plugin is using a Partial:

```sh
curl -i -X GET http://localhost:8001/plugins/974a63f3-87e9-4f6b-ace8-5e54c9084760
```

The partials key in the response will show the linked Partials. To view the complete configuration, including settings from linked Partials, append the `expand_partials=true` query parameter.


## Updating a Partial

Updates to a Partial are automatically reflected in all linked plugins. Use caution when updating Partials, as incorrect configurations (e.g., wrong Redis port) can disrupt multiple plugins.

## Unlinking a Plugin from a Partial

To unlink a plugin from a Partial, update the plugin configuration and omit the partials key, as shown below:

```sh
curl -i -X PUT http://{HOSTNAME}:8001/plugins/{PLUGIN_ID} \
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

## Listing Plugins Linked to a Partial

To see which plugins are linked to a specific Partial:

```sh
curl -i -X GET http://{HOSTNAME}:8001/partials/{PARTIAL-ID}/links
```

The response provides a paginated list of linked plugins:

```sh
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 101
Content-Type: application/json; charset=utf-8
Date: Thu, 06 Mar 2025 17:30:03 GMT
Server: kong/3.10.0.0-enterprise-edition
X-Kong-Admin-Latency: 12
X-Kong-Admin-Request-ID: 3fd3f547a4508a5dbc527f6b1bc4f956

{
    "count": 1,
    "data": [
        {
            "id": "974a63f3-87e9-4f6b-ace8-5e54c9084760",
            "name": "rate-limiting"
        }
    ],
    "next": null
}
```

## Deleting a Partial

Before deleting a Partial, ensure all linked plugins are unlinked. Then, delete the Partial:

```sh
curl -i -X DELETE http://{HOSTNAME}:8001/partials/{PARTIAL-ID}
```

## Detailed API

For more information about Partial configurations and usage, see #TODO
