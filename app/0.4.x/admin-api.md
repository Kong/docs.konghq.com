---
title: Admin API

api_body: |
    Attribute | Description
    ---:| ---
    `name`<br>*optional* | The API name. If none is specified, will default to the `public_dns`.
    `public_dns`<br>*semi-optional* | The public DNS address that points to your API. For example, `mockbin.com`. At least `public_dns` or `path` or both should be specified.
    `path`<br>*semi-optional* | The public path that points to your API. For example, `/someservice`. At least `public_dns` or `path` or both should be specified.
    `strip_path`<br>*optional* | Strip the `path` value before proxying the request to the final API. For example a request made to `/someservice/hello` will be resolved to `target_url/hello`. By default is `false`.
    `preserve_host`<br>*optional* | Preserves the original `Host` header sent by the client, instead of replacing it with the hostname of the `target_url`. By default is `false`.
    `target_url` | The base target URL that points to your API server, this URL will be used for proxying requests. For example, `https://mockbin.com`.

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
    `value.{property}` | The configuration properties for the Plugin which can be found on the plugins documentation page in the [Kong Hub](https://docs.konghq.com/hub/).
    `enabled` | Whether the plugin is applied. Default: `true`.
---

# Kong Admin API

Kong comes with an **internal** RESTful API for administration purposes. API commands can be run on any node in the cluster, and Kong will keep the configuration consistent across all nodes.

- The RESTful Admin API listens on port `8001` by default.

## Supported Content Types

The Admin API accepts 2 content types on every endpoint:

- **x-www-form-urlencoded**

Simple enough for basic request bodies, you will probably use it most of the time. Note that when sending nested values, Kong expects nested objects to be referenced with dotted keys. Example:

```
value.limit=10&value.period=seconds
```

- **application/json**

Handy for complex bodies (ex: complex plugin configuration), in that case simply send a JSON representaton of the data you want to send. Example:

```json
{
    "value": {
        "limit": 10,
        "period": "seconds"
    }
}
```

---

## Information routes

### Retrieve node information

Retrieve installation details about a node.

**Endpoint**

<div class="endpoint get">/</div>

**Response**

```
HTTP 200 OK
```

```json
{
    "hostname": "",
    "lua_version": "LuaJIT 2.1.0-alpha",
    "plugins": {
        "available_on_server": [
            "ssl",
            "keyauth",
            "basicauth",
            "oauth2",
            "ratelimiting",
            "tcplog",
            "udplog",
            "filelog",
            "httplog",
            "cors",
            "request_transformer",
            "response_transformer",
            "requestsizelimiting",
            "ip_restriction",
            "mashape-analytics"
        ],
        "enabled_in_cluster": {}
    },
    "tagline": "Welcome to Kong",
    "version": "0.4.0"
}

```

---

### Retrieve node status

Retrieve usage information about a node, with some basic information about the connections being processed by the underlying nginx process. Because Kong is built on top of nginx, every existing nginx monitoring tool or agent can also be used.

**Endpoint**

<div class="endpoint get">/status</div>

**Response**

```
HTTP 200 OK
```

```json
{
    "total_requests": 3,
    "connections_active": 1,
    "connections_accepted": 1,
    "connections_handled": 1,
    "connections_reading": 0,
    "connections_writing": 1,
    "connections_waiting": 0
}
```

* `total_requests`: The total number of client requests.
* `connections_active`: The current number of active client connections including Waiting connections.
* `connections_accepted`: The total number of accepted client connections.
* `connections_handled`: The total number of handled connections. Generally, the parameter value is the same as accepts unless some resource limits have been reached.
* `connections_reading`: The current number of connections where Kong is reading the request header.
* `connections_writing`: The current number of connections where nginx is writing the response back to the client.
* `connections_waiting`: The current number of idle client connections waiting for a request.

---

## API Object

The API object describes an API that's being exposed by Kong. In order to do that Kong needs to know how to retrieve the API when a consumer is calling it from the Proxy port. This can be achieved either by specifying a custom DNS address or a specific URL path. Finally, Kong needs to know what is the final target URL of the API where the requests will be proxied.

```json
{
    "name": "Mockbin",
    "public_dns": "mockbin.com",
    "path": "/someservice",
    "strip_path": false,
    "preserve_host": false,
    "target_url": "https://mockbin.com"
}
```

---

### Add API

**Endpoint**

<div class="endpoint post">/apis/</div>

#### Request Body

{{ page.api_body }}

**Response**

```
HTTP 201 Created
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "name": "Mockbin",
    "public_dns": "mockbin.com",
    "target_url": "http://mockbin.com",
    "preserve_host": false,
    "created_at": 1422386534
}
```

---

### Retrieve API

**Endpoint**

<div class="endpoint get">/apis/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the API to retrieve

**Response**

```
HTTP 200 OK
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "name": "Mockbin",
    "public_dns": "mockbin.com",
    "target_url": "https://mockbin.com",
    "preserve_host": false,
    "created_at": 1422386534
}
```

---

### List APIs

**Endpoint**

<div class="endpoint get">/apis/</div>

#### Request Querystring Parameters

Attributes | Description
---:| ---
`id`<br>*optional* | A filter on the list based on the apis `id` field.
`name`<br>*optional* | A filter on the list based on the apis `name` field.
`public_dns`<br>*optional* | A filter on the list based on the apis `public_dns` field.
`target_url`<br>*optional* | A filter on the list based on the apis `target_url` field.
`size`<br>*optional, default is __100__* | A limit on the number of objects to be returned.
`offset`<br>*optional* | A cursor used for pagination. `offset` is an object identifier that defines a place in the list.

**Response**

```
HTTP 200 OK
```

```json
{
    "total": 2,
    "data": [
        {
            "id": "4d924084-1adb-40a5-c042-63b19db421d1",
            "name": "Mockbin",
            "public_dns": "mockbin.com",
            "target_url": "https://mockbin.com",
            "preserve_host": false,
            "created_at": 1422386534
        },
        {
            "id": "3f924084-1adb-40a5-c042-63b19db421a2",
            "name": "PrivateAPI",
            "public_dns": "internal.api.com",
            "target_url": "http://private.api.com",
            "preserve_host": false,
            "created_at": 1422386585
        }
    ],
    "next": "http://localhost:8001/apis/?size=10&offset=4d924084-1adb-40a5-c042-63b19db421d1"
}
```

---

### Update API

**Endpoint**

<div class="endpoint patch">/apis/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the API to update

#### Request Body

{{ page.api_body }}

**Response**

```
HTTP 200 OK
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "name": "Mockbin2",
    "public_dns": "mockbin.com",
    "target_url": "http://mockbin.com",
    "preserve_host": false,
    "created_at": 1422386534
}
```

---

### Update Or Create API

**Endpoint**

<div class="endpoint put">/apis/</div>

#### Request Body

{{ page.api_body }}

The body needs an `id` parameter to trigger an update on an existing entity.

**Response**

```
HTTP 201 Created or HTTP 200 OK
```

See POST and PATCH responses.

---

### Delete API

**Endpoint**

<div class="endpoint delete">/apis/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the API to delete

**Response**

```
HTTP 204 NO CONTENT
```

---

## Consumer Object

The Consumer object represents a consumer - or a user - of an API. You can either rely on Kong as the primary datastore, or you can be map the consumer list with your database to keep consistency between Kong and your existing primary datastore.

```json
{
    "custom_id": "abc123"
}
```

---

### Create Consumer

**Endpoint**

<div class="endpoint post">/consumers/</div>

#### Request Form Parameters

{{ page.consumer_body }}

**Response**

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

**Endpoint**

<div class="endpoint get">/consumers/{username or id}</div>

Attributes | Description
---:| ---
`username or id`<br>**required** | The unique identifier **or** the username of the consumer to retrieve

**Response**

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

**Endpoint**

<div class="endpoint get">/consumers/</div>

#### Request Querystring Parameters

Attributes | Description
---:| ---
`id`<br>*optional* | A filter on the list based on the consumer `id` field.
`custom_id`<br>*optional* | A filter on the list based on the consumer `custom_id` field.
`username`<br>*optional* | A filter on the list based on the consumer `username` field.
`size`<br>*optional, default is __100__* | A limit on the number of objects to be returned.
`offset`<br>*optional* | A cursor used for pagination. `offset` is an object identifier that defines a place in the list.

**Response**

```
HTTP 200 OK
```

```json
{
    "total": 2,
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
    "next": "http://localhost:8001/consumers/?size=10&offset=4d924084-1adb-40a5-c042-63b19db421d1"
}
```

---

### Update Consumer

**Endpoint**

<div class="endpoint patch">/consumers/{username or id}</div>

Attributes | Description
---:| ---
`username or id`<br>**required** | The unique identifier **or** the username of the consumer to update

#### Request Body

{{ page.consumer_body }}

**Response**

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

**Endpoint**

<div class="endpoint put">/consumers/</div>

#### Request Body

{{ page.consumer_body }}

The body needs an `id` parameter to trigger an update on an existing entity.

**Response**

```
HTTP 201 Created or HTTP 200 OK
```

See POST and PATCH responses.

---

### Delete Consumer

**Endpoint**

<div class="endpoint delete">/consumers/{username or id}</div>

Attributes | Description
---:| ---
`username or id`<br>**required** | The unique identifier **or** the name of the consumer to delete

**Response**

```
HTTP 204 NO CONTENT
```

---

## Plugin Object

Retrieve the installed plugins on your node and their configuration schema.

**Reminder:** Installed plugins does not mean a plugin is enabled. To enabled a plugin, you have to configure it for a given API. See [Plugin Configuration Object](#plugin-configuration-object).

---

### Retrieve Installed Plugins

Retrieve a list of all installed plugins on the Kong node.

**Endpoint**

<div class="endpoint get">/plugins/</div>

**Response**

```
HTTP 200 OK
```

```json
{
    "enabled_plugins": [
        "ssl",
        "keyauth",
        "basicauth",
        "oauth2",
        "ratelimiting",
        "tcplog",
        "udplog",
        "filelog",
        "httplog",
        "cors",
        "request_transformer",
        "response_transformer",
        "requestsizelimiting",
        "analytics"
    ]
}
```

### Retrieve Plugin Schema

Retrieve the schema of a plugin's configuration. This is useful to understand what fields a plugin accepts, and can be used for building third-party integrations to the Kong's plugin system.

<div class="endpoint get">/plugins/{plugin name}/schema</div>

**Response**

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

## Plugin Configuration Object

The Plugin Configuration object represents a plugin configuration that will be executed during the HTTP request/response workflow, and it's how you can add functionalities to APIs that run behind Kong, like Authentication or Rate Limiting for example. You can find more information about how to install and what values each plugin takes by visiting the [Kong Hub](https://docs.konghq.com/hub/).

When creating a Plugin Configuration on top of an API, every request made by a client will be evaluated by the plugin configuration you setup. Sometimes the Plugin Configuration needs to be tuned to different values for some specific consumers, you can do that by specifying the `consumer_id` value.

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "api_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
    "consumer_id": "a3dX2dh2-1adb-40a5-c042-63b19dbx83hF4",
    "name": "ratelimiting",
    "value": {
        "minute": 20,
        "hour": 500
    },
    "enabled": true,
    "created_at": 1422386534
}
```

---

### Create Plugin Configuration

**Endpoint**

<div class="endpoint post">/apis/{name or id}/plugins/</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the API on which to add a plugin configuration

#### Request Body

{{ page.plugin_configuration_body }}

**Response**

```
HTTP 201 Created
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "api_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
    "consumer_id": "a3dX2dh2-1adb-40a5-c042-63b19dbx83hF4",
    "name": "ratelimiting",
    "value": {
        "minute": 20,
        "hour": 500
    },
    "enabled": true,
    "created_at": 1422386534
}
```

---

### List Per-API Plugin Configurations

**Endpoint**

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

**Response**

```
HTTP 200 OK
```

```json
{
    "total": 2,
    "data": [
      {
          "id": "4d924084-1adb-40a5-c042-63b19db421d1",
          "api_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
          "name": "ratelimiting",
          "value": {
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
          "name": "ratelimiting",
          "value": {
              "minute": 300,
              "hour": 20000
          },
          "enabled": true,
          "created_at": 1422386585
      }
    ],
    "next": "http://localhost:8001/plugins_configurations/?size=10&offset=4d924084-1adb-40a5-c042-63b19db421d1"
}
```

---

### List All Plugin Configurations

You can use the `/plugins_configuration` endpoint to access a global list of all the configured plugins on your cluster.

**Endpoint**

<div class="endpoint get">/plugins_configurations/</div>

#### Request Querystring Parameters

Attributes | Description
---:| ---
`id`<br>*optional* | A filter on the list based on the `id` field.
`name`<br>*optional* | A filter on the list based on the `name` field.
`api_id`<br>*optional* | A filter on the list based on the `api_id` field.
`consumer_id`<br>*optional* | A filter on the list based on the `consumer_id` field.
`size`<br>*optional, default is __100__* | A limit on the number of objects to be returned.
`offset`<br>*optional* | A cursor used for pagination. `offset` is an object identifier that defines a place in the list.

**Response**

```
HTTP 200 OK
```

```json
{
    "total": 2,
    "data": [
      {
          "id": "4d924084-1adb-40a5-c042-63b19db421d1",
          "api_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
          "name": "ratelimiting",
          "value": {
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
          "name": "ratelimiting",
          "value": {
              "minute": 300,
              "hour": 20000
          },
          "enabled": true,
          "created_at": 1422386585
      }
    ],
    "next": "http://localhost:8001/plugins_configurations/?size=10&offset=4d924084-1adb-40a5-c042-63b19db421d1"
}
```

---

### Update Plugin Configuration

**Endpoint**

<div class="endpoint patch">/apis/{api name or id}/plugins/{id}</div>

Attributes | Description
---:| ---
`api name or id`<br>**required** | The unique identifier **or** the name of the API for which to update the plugin configuration
`id`<br>**required** | The unique identifier of the plugin configuration to update on this API

#### Request Body

{{ page.plugin_configuration_body }}

**Response**

```
HTTP 200 OK
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "api_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
    "consumer_id": "a3dX2dh2-1adb-40a5-c042-63b19dbx83hF4",
    "name": "ratelimiting",
    "value": {
        "minute": 20,
        "hour": 500
    },
    "enabled": true,
    "created_at": 1422386534
}
```

---

### Update Or Create Plugin Configuration

**Endpoint**

<div class="endpoint put">/apis/{api name or id}/plugins/</div>

Attributes | Description
---:| ---
`api name or id`<br>**required** | The unique identifier **or** the name of the API for which to update or create the plugin configuration

#### Request Body

{{ page.plugin_configuration_body }}

The body needs an `id` parameter to trigger an update on an existing entity.

**Response**

```
HTTP 201 Created or HTTP 200 OK
```

See POST and PATCH responses.

---

### Delete Plugin Configuration

**Endpoint**

<div class="endpoint delete">/apis/{api name or id}/plugins/{id}</div>

Attributes | Description
---:| ---
`api name or id`<br>**required** | The unique identifier **or** the name of the API for which to delete the plugin configuration
`id`<br>**required** | The unique identifier of the plugin configuration to delete on this API

**Response**

```
HTTP 204 NO CONTENT
```
