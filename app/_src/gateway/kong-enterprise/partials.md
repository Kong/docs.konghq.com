---
title: Partials
badge: enterprise
concept_type: explanation
---

## What are Partials?

Some entites in Kong share the same configuration that has to be repeated. An example here is defining how to connect to Redis for Plugins that support it. If you have multiple instances of the same plugin and they all need to connect to Redis, withouth partials, you would have to repeat the same configuration in every one of them. When this configuration were to change you would have to update every plugin.

Partials are a way alieviating the pain of repeatable configuration. They allow you to extract parts of configuration to a separate entity that can be linked. To provide useful validation rules we specify types of Partials that are supported and the first two supported Partials types are:
- `redis-ce` - to store common Redis configuration for all plugins that are available on Kong OSS
- `redis-ee` - to store common Redis configuration for all plugins that are available on Kong Enterprise


## How to create a Partial

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

You can define other fields as well. In order to verify what configuration fields are available for what type of Partial please refer to the `/schemas/partials/redis-ce` and `/schemas/partials/redis-ee` endpoints.

## How to use a Partial in a Plugins configuration

Once a Partial has been created it can be linked to a Plugin via `POST` or `PUT` requests. Below is an example how how to link `rate-limiting` Plugin to a Partial.

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

That request will establish a link between the Partial and the Plugin. Please note that you cannot provide "inline" Redis configuration alongside the configuration that comes from the Partial. You can either create a Plugin and provide the Redis configuration inside the Plugins configuration or you should skip the "redis" key entirely and link to the partials as shown above.

Please note that in response Kong Gateway will respond with the Plugin conifguration as well Partial configuration so that you can immediately see what is the "effective" configuration that the plugin will act upon.

Example Plugin Creation response with "expanded" Partial configuration.
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

## Verifying that the Plugin is connected to a Partial

You can query the Admin API to verify if a Plugin is using a Partial:


```sh
curl -i -X GET http://localhost:8001/plugins/974a63f3-87e9-4f6b-ace8-5e54c9084760
```

```sh
HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 675
Content-Type: application/json; charset=utf-8
Date: Thu, 06 Mar 2025 17:22:03 GMT
Server: kong/3.10.0.0-enterprise-edition
X-Kong-Admin-Latency: 16
X-Kong-Admin-Request-ID: 99e96a36513d8d5f9f29547645456748

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

Here under "partials" key you can see that this Plugin is linked to a "my-ce-partial-1" Partial under "config.redis" path. Please note that the Partial configuration in this response is skipped. If you'd like to see what's the "effective" configuration upon which the Plugin will act you can pass a query parameter `expand_partials=true`.

## Updating a Partial

An update to a Partial will be reflected in all of the Plugins that are linked to it. Please update your Partials with special care as erroneous Partial configuration (ex. wrong Redis port) can make mulitple Plugins crash.

## Unlinking a Plugin from a Partial

If you would like to unlink your plugin from using a Partial please send a PUT request and skip "partials" key - just as you would configure the plugin without using a Partial in the first place.

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

A request like this will clear all links from the Plugin to the Partial

## Verifying what Plugins are connected to a Partial

To see what Partials a Plugin is using you can simply query the Plugin and it will report which Partials are linked to it. To see the reverse relation - what Plugins are connected to a Partial you can send a request like this:

```sh
curl -i -X GET http://{HOSTNAME}:8001/partials/{PARTIAL-ID}/links
```

The response will be a paginated list of linked Plugins alongside total count of linked Plugins:

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

Since a Partial can be connected to multiple Plugins first you have to clear all Plugin links before you can delete a Partial. Once that is done simply send:

```sh
curl -i -X DELETE http://{HOSTNAME}:8001/partials/{PARTIAL-ID}
```

## Detailed API

For more information about how to configure Partials, see #TODO
