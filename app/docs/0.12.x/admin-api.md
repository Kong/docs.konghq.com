---
title: Admin API

api_body: |
    Attribute | Description
    ---:| ---
    `name`                        | The API name.
    `hosts`<br>*semi-optional*    | A comma-separated list of domain names that point to your API. For example: `example.com`. At least one of `hosts`, `uris`, or `methods` should be specified.
    `uris`<br>*semi-optional*     | A comma-separated list of URIs prefixes that point to your API. For example: `/my-path`. At least one of `hosts`, `uris`, or `methods` should be specified.
    `methods`<br>*semi-optional*  | A comma-separated list of HTTP methods that point to your API. For example: `GET,POST`. At least one of `hosts`, `uris`, or `methods` should be specified.
    `upstream_url`                | The base target URL that points to your API server. This URL will be used for proxying requests. For example: `https://example.com`.
    `strip_uri`<br>*optional*     | When matching an API via one of the `uris` prefixes, strip that matching prefix from the upstream URI to be requested. Default: `true`.
    `preserve_host`<br>*optional* | When matching an API via one of the `hosts` domain names, make sure the request `Host` header is forwarded to the upstream service. By default, this is `false`, and the upstream `Host` header will be extracted from the configured `upstream_url`.
    `retries`<br>*optional*       | The number of retries to execute upon failure to proxy. The default is `5`.
    `upstream_connect_timeout`<br>*optional* | The timeout in milliseconds for establishing a connection to your upstream service. Defaults to `60000`.
    `upstream_send_timeout`<br>*optional*    | The timeout in milliseconds between two successive write operations for transmitting a request to your upstream service Defaults to `60000`.
    `upstream_read_timeout`<br>*optional*    | The timeout in milliseconds between two successive read operations for transmitting a request to your upstream service Defaults to `60000`.
    `https_only`<br>*optional*               | To be enabled if you wish to only serve an API through HTTPS, on the appropriate port (`8443` by default). Default: `false`.
    `http_if_terminated`<br>*optional*       | Consider the `X-Forwarded-Proto` header when enforcing HTTPS only traffic. Default: `false`.

consumer_body: |
    Attributes | Description
    ---:| ---
    `username`<br>**semi-optional** | The unique username of the consumer. You must send either this field or `custom_id` with the request.
    `custom_id`<br>**semi-optional** | Field for storing an existing unique ID for the consumer - useful for mapping Kong with users in your existing database. You must send either this field or `username` with the request.

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

certificate_body: |
    Attributes | Description
    ---:| ---
    `cert` | PEM-encoded public certificate of the SSL key pair.
    `key` | PEM-encoded private key of the SSL key pair.
    `snis`<br>*optional* | One or more hostnames to associate with this certificate as an SNI. This is a sugar parameter that will, under the hood, create an SNI object and associate it with this certificate for your convenience.

snis_body: |
    Attributes | Description
    ---:| ---
    `name` | The SNI name to associate with the given certificate.
    `ssl_certificate_id` | The `id` (a UUID) of the certificate with which to associate the SNI hostname.

---

# Kong Admin API

Kong comes with an **internal** RESTful Admin API for administration purposes.
Requests to the Admin API can be sent to any node in the cluster, and Kong will
keep the configuration consistent across all nodes.

- `8001` is the default port on which the Admin API listens.
- `8444` is the default port for HTTPS traffic to the Admin API.

This API is designed for internal use and provides full control over Kong, so
care should be taken when setting up Kong environments to avoid undue public
exposure of this API. See [this document][secure-admin-api] for a discussion
of methods to secure the Admin API.

## Supported Content Types

The Admin API accepts 2 content types on every endpoint:

- **application/x-www-form-urlencoded**

Simple enough for basic request bodies, you will probably use it most of the time. Note that when sending nested values, Kong expects nested objects to be referenced with dotted keys. Example:

```
config.limit=10&config.period=seconds
```

- **application/json**

Handy for complex bodies (ex: complex plugin configuration), in that case simply send a JSON representation of the data you want to send. Example:

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
    "version": "0.11.0"
}
```

* `available_on_server`: Names of plugins that are installed on the node.
* `enabled_in_cluster`: Names of plugins that are enabled/configured. That is, the plugins configurations currently in the datastore shared by all Kong nodes.

---

### Retrieve node status

Retrieve usage information about a node, with some basic information about the connections being processed by the underlying nginx process, and the status of the database connection.

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
        "reachable": true
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
* `database`: Metrics about the database.
    * `reachable`: A boolean value reflecting the state of the database connection. Please note that this flag **does not** reflect the health of the database itself.

---

## API Object

The API object describes an API that's being exposed by Kong. Kong needs to know how to retrieve the 
API when a consumer is calling it from the Proxy port. Each API object must specify some combination 
of `hosts`, `uris`, and `methods`. Kong will proxy all requests to the API to the specified upstream URL.

```json
{
    "created_at": 1488830759000,
    "hosts": [
        "example.org"
    ],
    "http_if_terminated": false,
    "https_only": false,
    "id": "6378122c-a0a1-438d-a5c6-efabae9fb969",
    "name": "example-api",
    "preserve_host": false,
    "retries": 5,
    "strip_uri": true,
    "upstream_connect_timeout": 60000,
    "upstream_read_timeout": 60000,
    "upstream_send_timeout": 60000,
    "upstream_url": "http://httpbin.org"
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
    "created_at": 1488830759000,
    "hosts": [
        "example.org"
    ],
    "http_if_terminated": false,
    "https_only": false,
    "id": "6378122c-a0a1-438d-a5c6-efabae9fb969",
    "name": "example-api",
    "preserve_host": false,
    "retries": 5,
    "strip_uri": true,
    "upstream_connect_timeout": 60000,
    "upstream_read_timeout": 60000,
    "upstream_send_timeout": 60000,
    "upstream_url": "http://httpbin.org"
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
    "created_at": 1488830759000,
    "hosts": [
        "example.org"
    ],
    "http_if_terminated": false,
    "https_only": false,
    "id": "6378122c-a0a1-438d-a5c6-efabae9fb969",
    "name": "example-api",
    "preserve_host": false,
    "retries": 5,
    "strip_uri": true,
    "upstream_connect_timeout": 60000,
    "upstream_read_timeout": 60000,
    "upstream_send_timeout": 60000,
    "upstream_url": "http://httpbin.org"
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
`upstream_url`<br>*optional* | A filter on the list based on the apis `upstream_url` field.
`retries`<br>*optional* | A filter on the list based on the apis `retries` field.
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
            "created_at": 1488830759000,
            "hosts": [
                "example.org"
            ],
            "http_if_terminated": false,
            "https_only": false,
            "id": "6378122c-a0a1-438d-a5c6-efabae9fb969",
            "name": "example-api",
            "preserve_host": false,
            "retries": 5,
            "strip_uri": true,
            "upstream_connect_timeout": 60000,
            "upstream_read_timeout": 60000,
            "upstream_send_timeout": 60000,
            "upstream_url": "http://httpbin.org"
        },
        {
            "created_at": 1488830708000,
            "hosts": [
                "api.com"
            ],
            "http_if_terminated": false,
            "https_only": false,
            "id": "0924978e-eb19-44a0-9adc-55f20db2f04d",
            "name": "my-api",
            "preserve_host": false,
            "retries": 10,
            "strip_uri": true,
            "upstream_connect_timeout": 1000,
            "upstream_read_timeout": 1000,
            "upstream_send_timeout": 1000,
            "upstream_url": "http://my-api.com"
        }
    ],
    "next": "http://localhost:8001/apis?size=2&offset=6378122c-a0a1-438d-a5c6-efabae9fb969"
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
    "created_at": 1488830759000,
    "hosts": [
        "updated-example.org"
    ],
    "http_if_terminated": false,
    "https_only": false,
    "id": "6378122c-a0a1-438d-a5c6-efabae9fb969",
    "name": "my-updated-api",
    "preserve_host": false,
    "retries": 5,
    "strip_uri": true,
    "upstream_connect_timeout": 60000,
    "upstream_read_timeout": 60000,
    "upstream_send_timeout": 60000,
    "upstream_url": "http://httpbin.org"
}
```

---

### Update Or Create API

#### Endpoint

<div class="endpoint put">/apis/</div>

#### Request Body

{{ page.api_body }}

The behavior of `PUT` endpoints is the following: if the request payload **does
not** contain an entity's primary key (`id` for APIs), the entity will be
created with the given payload. If the request payload **does** contain an
entity's primary key, the payload will "replace" the entity specified by the
given primary key. If the primary key is **not** that of an existing entity, `404
NOT FOUND` will be returned.

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

The behavior of `PUT` endpoints is the following: if the request payload **does
not** contain an entity's primary key (`id` for Consumers), the entity will be
created with the given payload. If the request payload **does** contain an
entity's primary key, the payload will "replace" the entity specified by the
given primary key. If the primary key is **not** that of an existing entity, `404
NOT FOUND` will be returned.

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

A Plugin entity represents a plugin configuration that will be executed during
the HTTP request/response lifecycle. It is how you can add functionalities
to APIs that run behind Kong, like Authentication or Rate Limiting for
example. You can find more information about how to install and what values
each plugin takes by visiting the [Plugins Gallery](/plugins).

When adding a Plugin Configuration to an API, every request made by a client to
that API will run said Plugin. If a Plugin needs to be tuned to different
values for some specific Consumers, you can do so by specifying the
`consumer_id` value:

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

See the [Precedence](#precedence) section below for more details.

#### Precedence

Plugins can be added globally (all APIs), on a single API, single Consumer,
or a combination of both an API and a Consumer. Additionally, a given plugin
(e.g. `key-auth`) will only run once per request, even if it is configured
twice (e.g. globally *and* on an API).

Therefore, there exists an order of precedence when the same plugin is applied
to different entities with different configurations. This order implies that
such a plugin that is configured twice, will only run once.

The order of precedence is, from highest to lowest:

1. Plugins applied on a combination of an API and a Consumer (if the request is
   authenticated).
2. Plugins applied to a Consumer (if the request is authenticated).
3. Plugins applied to an API.
4. Plugins configured to run globally.

**Example**: if the `rate-limiting` plugin is applied twice (with different
configurations): for an API (Plugin config A), and for a Consumer (Plugin
config B), then requests authenticating this Consumer will run Plugin config B
and ignore A (2.). However, requests that do not authenticate this Consumer
will fallback to running Plugin config A (3.).

This behavior is particularly useful when the intent is to override the
configuration of a particular plugin (e.g. allow a higher rate limiting) for a
given API or Consumer.

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

<div class="endpoint patch">/apis/{api name or id}/plugins/{plugin id}</div>

Attributes | Description
---:| ---
`api name or id`<br>**required** | The unique identifier **or** the name of the API for which to update the plugin configuration
`plugin id`<br>**required** | The unique identifier of the plugin configuration to update on this API

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

The behavior of `PUT` endpoints is the following: if the request payload **does
not** contain an entity's primary key (`id` and `name` for Plugins), the entity
will be created with the given payload. If the request payload **does** contain
an entity's primary key, the payload will "replace" the entity specified by the
given primary key. If the primary key is **not** that of an existing entity, `404
NOT FOUND` will be returned.

#### Response

```
HTTP 201 Created or HTTP 200 OK
```

See POST and PATCH responses.

---

### Delete Plugin

#### Endpoint

<div class="endpoint delete">/apis/{api name or id}/plugins/{plugin id}</div>

Attributes | Description
---:| ---
`api name or id`<br>**required** | The unique identifier **or** the name of the API for which to delete the plugin configuration
`plugin id`<br>**required** | The unique identifier of the plugin configuration to delete on this API

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
        "request-transformer",
        "response-transformer",
        "request-size-limiting",
        "rate-limiting",
        "response-ratelimiting",
        "aws-lambda",
        "bot-detection",
        "correlation-id",
        "datadog",
        "galileo",
        "ldap-auth",
        "loggly",
        "runscope",
        "statsd",
        "syslog"
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

## Certificate Object

A certificate object represents a public certificate/private key pair for an SSL
certificate. These objects are used by Kong to handle SSL/TLS termination for
encrypted requests. Certificates are optionally associated with SNI objects to
tie a cert/key pair to one or more hostnames.

```json
{
    "cert": "-----BEGIN CERTIFICATE-----...",
    "key": "-----BEGIN RSA PRIVATE KEY-----..."
}
```

---

### Add Certificate

#### Endpoint

<div class="endpoint post">/certificates/</div>

#### Request Body

{{ page.certificate_body }}

#### Response

```
HTTP 201 Created
```

```json
{
    "id": "21b69eab-09d9-40f9-a55e-c4ee47fada68",
    "cert": "-----BEGIN CERTIFICATE-----...",
    "key": "-----BEGIN RSA PRIVATE KEY-----...",
    "snis": [
        "example.com"
    ],
    "created_at": 1485521710265
}
```

---

### Retrieve Certificate

#### Endpoint

<div class="endpoint get">/certificates/{sni or id}</div>

Attributes | Description
---:| ---
`SNI or id`<br>**required** | The unique identifier **or** an SNI name associated with this certificate.

#### Response

```
HTTP 200 OK
```

```json
{
    "id": "21b69eab-09d9-40f9-a55e-c4ee47fada68",
    "cert": "-----BEGIN CERTIFICATE-----...",
    "key": "-----BEGIN RSA PRIVATE KEY-----...",
    "snis": [
        "example.com"
    ],
    "created_at": 1485521710265
}
```
---

### List Certificates

#### Endpoint

<div class="endpoint get">/certificates/</div>

#### Response

```
HTTP 200 OK
```

```json
{
    "total": 2,
    "data": [
        {
            "id": "21b69eab-09d9-40f9-a55e-c4ee47fada68",
            "cert": "-----BEGIN CERTIFICATE-----...",
            "key": "-----BEGIN RSA PRIVATE KEY-----...",
            "snis": [
                "example.com"
            ],
            "created_at": 1485521710265
        },
        {
            "id": "6b5b6f71-c0b3-426d-8f3b-8de2c67c816b",
            "cert": "-----BEGIN CERTIFICATE-----...",
            "key": "-----BEGIN RSA PRIVATE KEY-----...",
            "snis": [
                "example.org"
            ],
            "created_at": 1485522651185
        }
    ]
}
```
---

### Update Certificate

<div class="endpoint patch">/certificates/{sni or id}</div>

Attributes | Description
---:| ---
`SNI or id`<br>**required** | The unique identifier **or** an SNI name associated with this certificate.

#### Request Body

{{ page.certificate_body }}

#### Response

```
HTTP 200 OK
```

```json
{
    "id": "21b69eab-09d9-40f9-a55e-c4ee47fada68",
    "cert": "-----BEGIN CERTIFICATE-----...",
    "key": "-----BEGIN RSA PRIVATE KEY-----...",
    "snis": [
        "example.com"
    ],
    "created_at": 1485521710265
}
```

---

### Update or Create Certificate

#### Endpoint

<div class="endpoint put">/certificates/</div>

#### Request Body

{{ page.certificate_body }}

The behavior of `PUT` endpoints is the following: if the request payload **does
not** contain an entity's primary key (`id` for Certificates), the entity will
be created with the given payload. If the request payload **does** contain an
entity's primary key, the payload will "replace" the entity specified by the
given primary key. If the primary key is **not** that of an existing entity, `404
NOT FOUND` will be returned.

#### Response

```
HTTP 201 Created or HTTP 200 OK
```

See POST and PATCH responses.

---

### Delete Certificate

<div class="endpoint delete">/certificates/{sni or id}</div>

Attributes | Description
---:| ---
`sni or id`<br>**required** | The unique identifier **or** an SNI name associated with this certificate.

#### Response

```
HTTP 204 No Content
```

---

## SNI Objects

An SNI object represents a many-to-one mapping of hostnames to a certificate.
That is, a certificate object can have many hostnames associated with it; when
Kong receives an SSL request, it uses the SNI field in the Client Hello to
lookup the certificate object based on the SNI associated with the certificate.

```json
{
    "name": "example.com",
    "ssl_certificate_id": "21b69eab-09d9-40f9-a55e-c4ee47fada68"
}
```

---

### Add SNI

#### Endpoint

<div class="endpoint post">/snis/</div>

#### Request Body

{{ page.snis_body }}

#### Response

```
HTTP 201 Created
```

```json
{
    "name": "example.com",
    "ssl_certificate_id": "21b69eab-09d9-40f9-a55e-c4ee47fada68",
    "created_at": 1485521710265
}
```

---

### Retrieve SNI

#### Endpoint

<div class="endpoint get">/snis/{name}</div>

Attributes | Description
---:| ---
`name`<br>**required** | The name of the SNI object.

#### Response

```
HTTP 200 OK
```

```json
{
    "name": "example.com",
    "ssl_certificate_id": "21b69eab-09d9-40f9-a55e-c4ee47fada68",
    "created_at": 1485521710265
}
```

### List SNIs

#### Endpoint

<div class="endpoint get">/snis/</div>

#### Response

```
HTTP 200 OK
```

```json
{
    "total": 2,
    "data": [
        {
            "name": "example.com",
            "ssl_certificate_id": "21b69eab-09d9-40f9-a55e-c4ee47fada68",
            "created_at": 1485521710265
        },
        {
            "name": "example.org",
            "ssl_certificate_id": "6b5b6f71-c0b3-426d-8f3b-8de2c67c816b",
            "created_at": 1485521710265
        }
    ]
}
```

---

### Update SNI

<div class="endpoint patch">/snis/{name}</div>

Attributes | Description
---:| ---
`name`<br>**required** | The name of the SNI object.

#### Response

```
HTTP 200 OK
```

```json
{
    "name": "example.com",
    "ssl_certificate_id": "21b69eab-09d9-40f9-a55e-c4ee47fada68",
    "created_at": 1485521710265
}
```

---

### Update or Create SNI

#### Endpoint

<div class="endpoint put">/snis/</div>

#### Request Body

{{ page.snis_body }}

The behavior of `PUT` endpoints is the following: if the request payload **does
not** contain an entity's primary key (`name` for SNIs), the entity will be
created with the given payload. If the request payload **does** contain an
entity's primary key, the payload will "replace" the entity specified by the
given primary key. If the primary key is **not** that of an existing entity, `404
NOT FOUND` will be returned.

#### Response

```
HTTP 201 Created or HTTP 200 OK
```

See POST and PATCH responses.

---

### Delete SNI

<div class="endpoint delete">/snis/{name}</div>

Attributes | Description
---:| ---
`name`<br>**required** | The name of the SNI object.

#### Response

```
HTTP 204 No Content
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
    "slots": 10
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
            "slots": 10
        },
        {
            "created_at": 1485522651185,
            "id": "07131005-ba30-4204-a29f-0927d53257b4",
            "name": "service.v2.xyz",
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
    "slots": 10,
    "created_at": 1422386534
}
```

---

### Update Or create Upstream

#### Endpoint

<div class="endpoint put">/upstreams/</div>

#### Request Body

{{ page.upstream_body }}

The behavior of `PUT` endpoints is the following: if the request payload **does
not** contain an entity's primary key (`id` for Upstreams), the entity will be
created with the given payload. If the request payload **does** contain an
entity's primary key, the payload will "replace" the entity specified by the
given primary key. If the primary key is **not** that of an existing entity, `404
NOT FOUND` will be returned.

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
dynamically added. Changes are effectuated on the fly.

Because the upstream maintains a history of target changes, the targets cannot
be deleted or modified. To disable a target, post a new one with `weight=0`;
alternatively, use the `DELETE` convenience method to accomplish the same.

The current target object definition is the one with the latest `created_at`.

```json
{
    "target": "1.2.3.4:80",
    "weight": 15,
    "upstream_id": "ee3310c1-6789-40ac-9386-f79c0cb58432"
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

Lists all targets of the upstream. Multiple target objects for the same
target may be returned, showing the history of changes for a specific target.
The target object with the latest `created_at` is the current definition.

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
    "total": 30,
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

---

### List active targets

Retrieve a list of active targets (targets whose most recent weight is not 0)
for a given upstream.

<div class="alert alert-warning">
  <strong>Note:</strong> This endpoint is only available with Kong 0.10.1+
</div>

### Endpoint

<div class="endpoint get">/upstreams/{name or id}/targets/active/</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the upstream for which to list the targets.

#### Response

```
HTTP 200 OK
```

```json
{
    "total": 2,
    "data": [
        {
            "created_at": 1485524883980,
            "id": "18c0ad90-f942-4098-88db-bbee3e43b27f",
            "target": "127.0.0.1:20000",
            "upstream_id": "07131005-ba30-4204-a29f-0927d53257b4",
            "weight": 100
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

---

### Delete target

Disable a target in the load balancer. Under the hood, this method creates
a new entry for the given target definition with a `weight` of 0.

<div class="alert alert-warning">
  <strong>Note:</strong> This endpoint is only available with Kong 0.10.1+
</div>

#### Endpoint

<div class="endpoint delete">/upstreams/{upstream name or id}/targets/{target or id}</div>

Attributes | Description
---:| ---
`upstream name or id`<br>**required** | The unique identifier **or** the name of the upstream for which to delete the target.
`target or id`<br>**required** | The host/port combination element of the target to remove, or the `id` of an existing target entry.

#### Response

```
HTTP 204 No Content
```

[clustering]: /docs/{{page.kong_version}}/clustering
[cli]: /docs/{{page.kong_version}}/cli
[secure-admin-api]: /docs/{{page.kong_version}}/secure-admin-api
