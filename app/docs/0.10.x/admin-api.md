---
title: Admin API

api_body: |
    Attribute | Description
    ---:| ---
    `name`<br>*optional* | The API name. If none is specified, will default to the `request_host` or `request_path`.
    `request_host`<br>*semi-optional* | The public DNS address that points to your API. For example, `mockbin.com`. At least `request_host` or `request_path` or both should be specified.
    `request_path`<br>*semi-optional* | The public path that points to your API. For example, `/someservice`. At least `request_host` or `request_path` or both should be specified.
    `strip_request_path`<br>*optional* | Strip the `request_path` value before proxying the request to the final API. For example a request made to `/someservice/hello` will be resolved to `upstream_url/hello`. By default is `false`.
    `preserve_host`<br>*optional* | Preserves the original `Host` header sent by the client, instead of replacing it with the hostname of the `upstream_url`. By default is `false`.
    `upstream_url` | The base target URL that points to your API server, this URL will be used for proxying requests. For example, `https://mockbin.com`.

consumer_body: |
    Attributes | Description
    ---:| ---
    `username`<br>**semi-optional** | The username of the consumer. You must send either this field or `custom_id` with the request.
    `custom_id`<br>**semi-optional** | Field for storing an existing ID for the consumer, useful for mapping Kong with users in your existing database. You must send either this field or `username` with the request.

plugin_configuration_body: |
    Attributes | Description
    ---:| ---
    `name` | The name of the Plugin that's going to be added. Currently the Plugin must be installed in every Kong instance separately.
    `consumer_id`<br>*optional* | The unique identifier of the consumer that overrides the existing settings for this specific consumer on incoming requests.
    `config.{property}` | The configuration properties for the Plugin which can be found on the plugins documentation page in the [Plugin Gallery](/plugins).

target_body: |
    Attributes | Description
    ---:| ---
    `target` | The target address (ip or hostname) and port. If omitted the `port` defaults to `8000`. If the hostname resolves to an SRV record, the `port` value will overridden by the value from the dns record.
    `weight`<br>*optional* | The weight this target gets within the upstream loadbalancer (`0`-`1000`, defaults to `100`). If the hostname resolves to an SRV record, the `weight` value will overridden by the value from the dns record.

upstream_body: |
    Attributes | Description
    ---:| ---
    `name` | This is a hostname like name that can be referenced in an `upstream_url` field of an `api`.
    `slots`<br>*optional* | The number of slots in the loadbalancer algorithm (`10`-`65536`, defaults to `1000`).
    `orderlist`<br>*optional* | A list of sequential, but randomly ordered, integer numbers that determine the distribution of the slots in the balancer. If omitted it will be generated. If given, it must have exactly `slots` number of entries.
---

# Kong Admin API

Kong comes with an **internal** RESTful API for administration purposes. API commands can be run on any node in the cluster, and Kong will keep the configuration consistent across all nodes.

- The RESTful Admin API listens on port `8001` by default.

## Supported Content Types

The Admin API accepts 2 content types on every endpoint:

- **x-www-form-urlencoded**

Simple enough for basic request bodies, you will probably use it most of the time. Note that when sending nested values, Kong expects nested objects to be referenced with dotted keys. Example:

```
config.limit=10&config.period=seconds
```

- **application/json**

Handy for complex bodies (ex: complex plugin configuration), in that case simply send a JSON representaton of the data you want to send. Example:

```json
{
    "config": {
        "limit": 10,
        "period": "seconds"
    }
}
```

---

## Information routes

### Retrieve node information

Retrieve generic details about a node.

#### Endpoint

<div class="endpoint get">/</div>

#### Response

```
HTTP 200 OK
```

```json
{
    "hostname": "",
    "lua_version": "LuaJIT 2.1.0-alpha",
    "plugins": {
        "available_on_server": [
            ...
        ],
        "enabled_in_cluster": [
            ...
        ]
    },
    "configuration" : {
        ...
    },
    "tagline": "Welcome to Kong",
    "version": "0.6.0"
}
```

* `available_on_server`: Names of plugins that are installed on the node.
* `enabled_in_cluster`: Names of plugins that are enabled/configured. That is, the plugins configurations currently in the datastore shared by all Kong nodes.

---

### Retrieve node status

Retrieve usage information about a node, with some basic information about the connections being processed by the underlying nginx process, and the number of entities stored in the datastore collections (including plugin's collections). 

If you want to monitor the Kong process, since Kong is built on top of nginx, every existing nginx monitoring tool or agent can be used.

#### Endpoint

<div class="endpoint get">/status</div>

#### Response

```
HTTP 200 OK
```

```json
{
    "server": {
        "total_requests": 3,
        "connections_active": 1,
        "connections_accepted": 1,
        "connections_handled": 1,
        "connections_reading": 0,
        "connections_writing": 1,
        "connections_waiting": 0
    },
    "database": {
        "apis": 2,
        "consumers": 0,
        "plugins": 2,
        "nodes": 1,
        ...
    }
}
```

* `server`: Metrics about the nginx HTTP/S server.
    * `total_requests`: The total number of client requests.
    * `connections_active`: The current number of active client connections including Waiting connections.
    * `connections_accepted`: The total number of accepted client connections.
    * `connections_handled`: The total number of handled connections. Generally, the parameter value is the same as accepts unless some resource limits have been reached.
    * `connections_reading`: The current number of connections where Kong is reading the request header.
    * `connections_writing`: The current number of connections where nginx is writing the response back to the client.
    * `connections_waiting`: The current number of idle client connections waiting for a request.
* `database`: Metrics about the database collections.
    * `...`: For every database collection, shows the number of items stored in that collection.

---

## Cluster

You can see the Kong cluster members, and forcibly remove a node from the cluster, using the following endpoints. For more information read the [clustering][clustering] documentation. You can also execute some of these operations using the [CLI][cli].

---

### Cluster information

The entrypoint to the clustering API functionalities. Shows the total number of events that have been handled by the current node, and their types. The types starting with `ENTITY_` are events for database entities, while the types that start with `MEMBER-` are events of the cluster and its members.

#### Endpoint

<div class="endpoint get">/cluster</div>

#### Response

```
HTTP 200 OK
```

```json
{
    "events": {
        "MEMBER-JOIN": 1,
        "MEMBER-LEAVE": 1,
        "MEMBER-FAILED": 1,
        "MEMBER-UPDATE": 1,
        "MEMBER-REAP": 1,
        "ENTITY_CREATED": 1,
        "ENTITY_UPDATED": 1,
        "ENTITY_DELETED": 1,
        "OTHER": 1,
        "total": 9
    },
    "nodes": "http:\/\/127.0.0.1:8001\/cluster\/nodes"
}
```

---

### Retrieve cluster status

Retrieve the cluster status, returning information for each node in the cluster.

#### Endpoint

<div class="endpoint get">/cluster/nodes/</div>

#### Response

```
HTTP 200 OK
```

```json
{
    "total": 3,
    "data": [
        {
            "address": "192.168.1.107:7946",
            "name": "kong.prod1_7946",
            "status": "alive"
        },
        {
            "address": "192.168.2.127:7946",
            "name": "kong.prod2_7946",
            "status": "failed"
        },
        {
            "address": "192.168.3.112:8484",
            "name": "kong.prod3_8484",
            "status": "left"
        }
    ]
}
```

---

### Forcibly remove a node

Forcibly remove a node from the cluster.

#### Endpoint

<div class="endpoint delete">/cluster/nodes/{node_name}</div>

#### Request Body

Attributes | Description
---:| ---
`name` | The node name to remove.

#### Response

```
HTTP 200 OK
```

---

## API Object

The API object describes an API that's being exposed by Kong. Kong needs to know how to retrieve the API when a consumer is calling it from the Proxy port. Each API object must specify a request host, a request path or both. Kong will proxy all requests to the API to the specified upstream URL.

```json
{
    "name": "Mockbin",
    "request_host": "mockbin.com",
    "request_path": "/someservice",
    "strip_request_path": false,
    "preserve_host": false,
    "upstream_url": "https://mockbin.com"
}
```

---

### Add API

#### Endpoint

<div class="endpoint post">/apis/</div>

#### Request Body

{{ page.api_body }}

#### Response

```
HTTP 201 Created
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "name": "Mockbin",
    "request_host": "mockbin.com",
    "upstream_url": "http://mockbin.com",
    "preserve_host": false,
    "created_at": 1422386534
}
```

---

### Retrieve API

#### Endpoint

<div class="endpoint get">/apis/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the API to retrieve

#### Response

```
HTTP 200 OK
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "name": "Mockbin",
    "request_host": "mockbin.com",
    "upstream_url": "https://mockbin.com",
    "preserve_host": false,
    "created_at": 1422386534
}
```

---

### List APIs

#### Endpoint

<div class="endpoint get">/apis/</div>

#### Request Querystring Parameters

Attributes | Description
---:| ---
`id`<br>*optional* | A filter on the list based on the apis `id` field.
`name`<br>*optional* | A filter on the list based on the apis `name` field.
`request_host`<br>*optional* | A filter on the list based on the apis `request_host` field.
`request_path`<br>*optional* | A filter on the list based on the apis `request_path` field.
`upstream_url`<br>*optional* | A filter on the list based on the apis `upstream_url` field.
`size`<br>*optional, default is __100__* | A limit on the number of objects to be returned.
`offset`<br>*optional* | A cursor used for pagination. `offset` is an object identifier that defines a place in the list.

#### Response

```
HTTP 200 OK
```

```json
{
    "total": 10,
    "data": [
        {
            "id": "4d924084-1adb-40a5-c042-63b19db421d1",
            "name": "Mockbin",
            "request_host": "mockbin.com",
            "upstream_url": "https://mockbin.com",
            "preserve_host": false,
            "created_at": 1422386534
        },
        {
            "id": "3f924084-1adb-40a5-c042-63b19db421a2",
            "name": "PrivateAPI",
            "request_host": "internal.api.com",
            "upstream_url": "http://private.api.com",
            "preserve_host": false,
            "created_at": 1422386585
        }
    ],
    "next": "http://localhost:8001/apis/?size=2&offset=4d924084-1adb-40a5-c042-63b19db421d1"
}
```

---

### Update API

#### Endpoint

<div class="endpoint patch">/apis/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the API to update

#### Request Body

{{ page.api_body }}

#### Response

```
HTTP 200 OK
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "name": "Mockbin2",
    "request_host": "mockbin.com",
    "upstream_url": "http://mockbin.com",
    "preserve_host": false,
    "created_at": 1422386534
}
```

---

### Update Or Create API

#### Endpoint

<div class="endpoint put">/apis/</div>

#### Request Body

{{ page.api_body }}

The body needs an `id` parameter to trigger an update on an existing entity.

#### Response

```
HTTP 201 Created or HTTP 200 OK
```

See POST and PATCH responses.

---

### Delete API

#### Endpoint

<div class="endpoint delete">/apis/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the API to delete

#### Response

```
HTTP 204 No Content
```

---

## Consumer Object

The Consumer object represents a consumer - or a user - of an API. You can either rely on Kong as the primary datastore, or you can map the consumer list with your database to keep consistency between Kong and your existing primary datastore.

```json
{
    "custom_id": "abc123"
}
```

---

### Create Consumer

#### Endpoint

<div class="endpoint post">/consumers/</div>

#### Request Form Parameters

{{ page.consumer_body }}

#### Response

```
HTTP 201 Created
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "custom_id": "abc123",
    "created_at": 1422386534
}
```

---

### Retrieve Consumer

#### Endpoint

<div class="endpoint get">/consumers/{username or id}</div>

Attributes | Description
---:| ---
`username or id`<br>**required** | The unique identifier **or** the username of the consumer to retrieve

#### Response

```
HTTP 200 OK
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "custom_id": "abc123",
    "created_at": 1422386534
}
```

---

### List Consumers

#### Endpoint

<div class="endpoint get">/consumers/</div>

#### Request Querystring Parameters

Attributes | Description
---:| ---
`id`<br>*optional* | A filter on the list based on the consumer `id` field.
`custom_id`<br>*optional* | A filter on the list based on the consumer `custom_id` field.
`username`<br>*optional* | A filter on the list based on the consumer `username` field.
`size`<br>*optional, default is __100__* | A limit on the number of objects to be returned.
`offset`<br>*optional* | A cursor used for pagination. `offset` is an object identifier that defines a place in the list.

#### Response

```
HTTP 200 OK
```

```json
{
    "total": 10,
    "data": [
        {
            "id": "4d924084-1adb-40a5-c042-63b19db421d1",
            "custom_id": "abc123",
            "created_at": 1422386534
        },
        {
            "id": "3f924084-1adb-40a5-c042-63b19db421a2",
            "custom_id": "def345",
            "created_at": 1422386585
        }
    ],
    "next": "http://localhost:8001/consumers/?size=2&offset=4d924084-1adb-40a5-c042-63b19db421d1"
}
```

---

### Update Consumer

#### Endpoint

<div class="endpoint patch">/consumers/{username or id}</div>

Attributes | Description
---:| ---
`username or id`<br>**required** | The unique identifier **or** the username of the consumer to update

#### Request Body

{{ page.consumer_body }}

#### Response

```
HTTP 200 OK
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "custom_id": "updated_abc123",
    "created_at": 1422386534
}
```

---

### Update Or Create Consumer

#### Endpoint

<div class="endpoint put">/consumers/</div>

#### Request Body

{{ page.consumer_body }}

The body needs an `id` parameter to trigger an update on an existing entity.

#### Response

```
HTTP 201 Created or HTTP 200 OK
```

See POST and PATCH responses.

---

### Delete Consumer

#### Endpoint

<div class="endpoint delete">/consumers/{username or id}</div>

Attributes | Description
---:| ---
`username or id`<br>**required** | The unique identifier **or** the name of the consumer to delete

#### Response

```
HTTP 204 No Content
```

---

## Plugin Object

A Plugin entity represents a plugin configuration that will be executed during the HTTP request/response workflow, and it's how you can add functionalities to APIs that run behind Kong, like Authentication or Rate Limiting for example. You can find more information about how to install and what values each plugin takes by visiting the [Plugin Gallery](/plugins).

When creating adding Plugin on top of an API, every request made by a client will be evaluated by the Plugin's configuration you setup. Sometimes the Plugin needs to be tuned to different values for some specific consumers, you can do that by specifying the `consumer_id` value.

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "api_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
    "consumer_id": "a3dX2dh2-1adb-40a5-c042-63b19dbx83hF4",
    "name": "rate-limiting",
    "config": {
        "minute": 20,
        "hour": 500
    },
    "enabled": true,
    "created_at": 1422386534
}
```

---

### Add Plugin

You can add a plugin in four different ways:

* For every API and Consumer. Don't set `api_id` and `consumer_id`.
* For every API and a specific Consumer. Only set `consumer_id`.
* For every Consumer and a specific API. Only set `api_id`.
* For a specific Consumer and API. Set both `api_id` and `consumer_id`.

Note that not all plugins allow to specify `consumer_id`. Check the plugin documentation.

#### Endpoint

<div class="endpoint post">/apis/{name or id}/plugins/</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the API on which to add a plugin configuration. If you are adding a plugin to every API use the `/plugins` endpoint instead without specifying an `api_id`.

#### Request Body

{{ page.plugin_configuration_body }}

#### Response

```
HTTP 201 Created
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "api_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
    "consumer_id": "a3dX2dh2-1adb-40a5-c042-63b19dbx83hF4",
    "name": "rate-limiting",
    "config": {
        "minute": 20,
        "hour": 500
    },
    "enabled": true,
    "created_at": 1422386534
}
```

---

## Retrieve Plugin

<div class="endpoint get">/plugins/{id}</div>

#### Request Querystring Parameters

Attributes | Description
---:| ---
`id`<br>**required** | The unique identifier of the plugin to retrieve

#### Response

```
HTTP 200 OK
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "api_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
    "consumer_id": "a3dX2dh2-1adb-40a5-c042-63b19dbx83hF4",
    "name": "rate-limiting",
    "config": {
        "minute": 20,
        "hour": 500
    },
    "enabled": true,
    "created_at": 1422386534
}
```

---

### List All Plugins

#### Endpoint

<div class="endpoint get">/plugins/</div>

#### Request Querystring Parameters

Attributes | Description
---:| ---
`id`<br>*optional* | A filter on the list based on the `id` field.
`name`<br>*optional* | A filter on the list based on the `name` field.
`api_id`<br>*optional* | A filter on the list based on the `api_id` field.
`consumer_id`<br>*optional* | A filter on the list based on the `consumer_id` field.
`size`<br>*optional, default is __100__* | A limit on the number of objects to be returned.
`offset`<br>*optional* | A cursor used for pagination. `offset` is an object identifier that defines a place in the list.

#### Response

```
HTTP 200 OK
```

```json
{
    "total": 10,
    "data": [
      {
          "id": "4d924084-1adb-40a5-c042-63b19db421d1",
          "api_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
          "name": "rate-limiting",
          "config": {
              "minute": 20,
              "hour": 500
          },
          "enabled": true,
          "created_at": 1422386534
      },
      {
          "id": "3f924084-1adb-40a5-c042-63b19db421a2",
          "api_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
          "consumer_id": "a3dX2dh2-1adb-40a5-c042-63b19dbx83hF4",
          "name": "rate-limiting",
          "config": {
              "minute": 300,
              "hour": 20000
          },
          "enabled": true,
          "created_at": 1422386585
      }
    ],
    "next": "http://localhost:8001/plugins?size=2&offset=4d924084-1adb-40a5-c042-63b19db421d1"
}
```

---

### List Plugins per API

#### Endpoint

<div class="endpoint get">/apis/{api name or id}/plugins/</div>

#### Request Querystring Parameters

Attributes | Description
---:| ---
`id`<br>*optional* | A filter on the list based on the `id` field.
`name`<br>*optional* | A filter on the list based on the `name` field.
`api_id`<br>*optional* | A filter on the list based on the `api_id` field.
`consumer_id`<br>*optional* | A filter on the list based on the `consumer_id` field.
`size`<br>*optional, default is __100__* | A limit on the number of objects to be returned.
`offset`<br>*optional* | A cursor used for pagination. `offset` is an object identifier that defines a place in the list.

#### Response

```
HTTP 200 OK
```

```json
{
    "total": 10,
    "data": [
      {
          "id": "4d924084-1adb-40a5-c042-63b19db421d1",
          "api_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
          "name": "rate-limiting",
          "config": {
              "minute": 20,
              "hour": 500
          },
          "enabled": true,
          "created_at": 1422386534
      },
      {
          "id": "3f924084-1adb-40a5-c042-63b19db421a2",
          "api_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
          "consumer_id": "a3dX2dh2-1adb-40a5-c042-63b19dbx83hF4",
          "name": "rate-limiting",
          "config": {
              "minute": 300,
              "hour": 20000
          },
          "enabled": true,
          "created_at": 1422386585
      }
    ],
    "next": "http://localhost:8001/plugins?size=2&offset=4d924084-1adb-40a5-c042-63b19db421d1"
}
```

---

### Update Plugin

#### Endpoint

<div class="endpoint patch">/apis/{api name or id}/plugins/{id}</div>

Attributes | Description
---:| ---
`api name or id`<br>**required** | The unique identifier **or** the name of the API for which to update the plugin configuration
`id`<br>**required** | The unique identifier of the plugin configuration to update on this API

#### Request Body

{{ page.plugin_configuration_body }}

#### Response

```
HTTP 200 OK
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "api_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
    "consumer_id": "a3dX2dh2-1adb-40a5-c042-63b19dbx83hF4",
    "name": "rate-limiting",
    "config": {
        "minute": 20,
        "hour": 500
    },
    "enabled": true,
    "created_at": 1422386534
}
```

---

### Update or Add Plugin

#### Endpoint

<div class="endpoint put">/apis/{api name or id}/plugins/</div>

Attributes | Description
---:| ---
`api name or id`<br>**required** | The unique identifier **or** the name of the API for which to update or create the plugin configuration

#### Request Body

{{ page.plugin_configuration_body }}

The body needs an `id` parameter to trigger an update on an existing entity.

#### Response

```
HTTP 201 Created or HTTP 200 OK
```

See POST and PATCH responses.

---

### Delete Plugin

#### Endpoint

<div class="endpoint delete">/apis/{api name or id}/plugins/{id}</div>

Attributes | Description
---:| ---
`api name or id`<br>**required** | The unique identifier **or** the name of the API for which to delete the plugin configuration
`id`<br>**required** | The unique identifier of the plugin configuration to delete on this API

#### Response

```
HTTP 204 No Content
```

---

### Retrieve Enabled Plugins

Retrieve a list of all installed plugins on the Kong node.

#### Endpoint

<div class="endpoint get">/plugins/enabled</div>

#### Response

```
HTTP 200 OK
```

```json
{
    "enabled_plugins": [
        "ssl",
        "jwt",
        "acl",
        "cors",
        "oauth2",
        "tcp-log",
        "udp-log",
        "file-log",
        "http-log",
        "key-auth",
        "hmac-auth",
        "basic-auth",
        "ip-restriction",
        "mashape-analytics",
        "request-transformer",
        "response-transformer",
        "request-size-limiting",
        "rate-limiting",
        "response-ratelimiting"
    ]
}
```

---

### Retrieve Plugin Schema

Retrieve the schema of a plugin's configuration. This is useful to understand what fields a plugin accepts, and can be used for building third-party integrations to the Kong's plugin system.

<div class="endpoint get">/plugins/schema/{plugin name}</div>

#### Response

```
HTTP 200 OK
```

```json
{
    "fields": {
        "hide_credentials": {
            "default": false,
            "type": "boolean"
        },
        "key_names": {
            "default": "function",
            "required": true,
            "type": "array"
        }
    }
}
```

---

## Upstream Objects

The upstream object represents a virtual hostname and can be used to loadbalance 
incoming requests over multiple services (targets). So for example an upstream
named `service.v1.xyz` with an API object created with an `upstream_url=https://service.v1.xyz/some/path`.
Requests for this API would be proxied to the targets defined within the upstream.

```json
{
    "name": "service.v1.xyz",
    "orderlist": [
        1,
        2,
        7,
        9,
        6,
        4,
        5,
        10,
        3,
        8
    ],
    "slots": 10
}
```

```json
{
    "target": "1.2.3.4:80",
    "weight": 15
    "upstream_id": "ee3310c1-6789-40ac-9386-f79c0cb58432",
}
```

---

### Add upstream

#### Endpoint

<div class="endpoint post">/upstreams/</div>

#### Request Body

{{ page.upstream_body }}

#### Response

```
HTTP 201 Created
```

```json
{
    "id": "13611da7-703f-44f8-b790-fc1e7bf51b3e",
    "name": "service.v1.xyz",
    "orderlist": [
        1,
        2,
        7,
        9,
        6,
        4,
        5,
        10,
        3,
        8
    ],
    "slots": 10,
    "created_at": 1485521710265
}
```

---

### Retrieve upstream

#### Endpoint

<div class="endpoint get">/upstreams/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the upstream to retrieve

#### Response

```
HTTP 200 OK
```

```json
{
    "id": "13611da7-703f-44f8-b790-fc1e7bf51b3e",
    "name": "service.v1.xyz",
    "orderlist": [
        1,
        2,
        7,
        9,
        6,
        4,
        5,
        10,
        3,
        8
    ],
    "slots": 10,
    "created_at": 1485521710265
}
```

---

### List upstreams

#### Endpoint

<div class="endpoint get">/upstreams/</div>

#### Request Querystring Parameters

Attributes | Description
---:| ---
`id`<br>*optional* | A filter on the list based on the upstream `id` field.
`name`<br>*optional* | A filter on the list based on the upstream `name` field.
`slots`<br>*optional* | A filter on the list based on the upstream `slots` field.
`size`<br>*optional, default is __100__* | A limit on the number of objects to be returned.
`offset`<br>*optional* | A cursor used for pagination. `offset` is an object identifier that defines a place in the list.

#### Response

```
HTTP 200 OK
```

```json
{
    "total": 3,
    "data": [
        {
            "created_at": 1485521710265,
            "id": "13611da7-703f-44f8-b790-fc1e7bf51b3e",
            "name": "service.v1.xyz",
            "orderlist": [
                1,
                2,
                7,
                9,
                6,
                4,
                5,
                10,
                3,
                8
            ],
            "slots": 10
        },
        {
            "created_at": 1485522651185,
            "id": "07131005-ba30-4204-a29f-0927d53257b4",
            "name": "service.v2.xyz",
            "orderlist": [
                5,
                3,
                6,
                1,
                2,
                10,
                8,
                7,
                4,
                9
            ],
            "slots": 10
        }
    ],
    "next": "http://localhost:8001/upstreams?size=2&offset=Mg%3D%3D",
    "offset": "Mg=="
}
```

---

### Update upstream

#### Endpoint

<div class="endpoint patch">/upstreams/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the upstream to update

#### Request Body

{{ page.upstream_body }}

#### Response

```
HTTP 200 OK
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "name": "service.v1.xyz",
    "orderlist": [
        1,
        2,
        7,
        9,
        6,
        4,
        5,
        10,
        3,
        8
    ],
    "slots": 10,
    "created_at": 1422386534
}
```

---

### Update Or Create upstream

#### Endpoint

<div class="endpoint put">/upstreams/</div>

#### Request Body

{{ page.upstream_body }}

The body needs an `id` parameter to trigger an update on an existing entity.

#### Response

```
HTTP 201 Created or HTTP 200 OK
```

See POST and PATCH responses.

---

### Delete upstream

#### Endpoint

<div class="endpoint delete">/upstreams/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the upstream to delete

#### Response

```
HTTP 204 No Content
```

---

## Target Object

A target is an ip address/hostname with a port that identifies an instance of a backend
service. Every upstream can have many targets, and the targets can be 
dynamically added and removed. So changes are effectuated on the fly.

Because the upstream maintains a history of target changes, the targets cannot
be deleted or modified. To disable a target, post a new one with `weight=0`.

```json
{
    "target": "1.2.3.4:80",
    "weight": 15
    "upstream_id": "ee3310c1-6789-40ac-9386-f79c0cb58432",
}
```

---

### Add target

#### Endpoint

<div class="endpoint post">/upstreams/{name or id}/targets</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the upstream to which to add the target

#### Request Body

{{ page.target_body }}

#### Response

```
HTTP 201 Created
```

```json
{
    "id": "4661f55e-95c2-4011-8fd6-c5c56df1c9db",
    "target": "1.2.3.4:80",
    "weight": 15,
    "upstream_id": "ee3310c1-6789-40ac-9386-f79c0cb58432",
    "created_at": 1485523507446
}
```

---

### List targets

#### Endpoint

<div class="endpoint get">/upstreams/{name or id}/targets</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the upstream for which to list the targets

#### Request Querystring Parameters

Attributes | Description
---:| ---
`id`<br>*optional* | A filter on the list based on the target `id` field.
`target`<br>*optional* | A filter on the list based on the target `target` field.
`weight`<br>*optional* | A filter on the list based on the target `weight` field.
`size`<br>*optional, default is __100__* | A limit on the number of objects to be returned.
`offset`<br>*optional* | A cursor used for pagination. `offset` is an object identifier that defines a place in the list.

#### Response

```
HTTP 200 OK
```

```json
{
    "total": 30
    "data": [
        {
            "created_at": 1485524883980,
            "id": "18c0ad90-f942-4098-88db-bbee3e43b27f",
            "target": "127.0.0.1:20000",
            "upstream_id": "07131005-ba30-4204-a29f-0927d53257b4",
            "weight": 100
        },
        {
            "created_at": 1485524897232,
            "id": "9b96f13d-65af-4f30-bbe9-b367121dd26b",
            "target": "127.0.0.1:20001",
            "upstream_id": "07131005-ba30-4204-a29f-0927d53257b4",
            "weight": 0
        },
        {
            "created_at": 1485524914883,
            "id": "6c6f34eb-e6c3-4c1f-ac58-4060e5bca890",
            "target": "127.0.0.1:20002",
            "upstream_id": "07131005-ba30-4204-a29f-0927d53257b4",
            "weight": 200
        }
    ]
}
```

[clustering]: /docs/{{page.kong_version}}/clustering
[cli]: /docs/{{page.kong_version}}/cli
