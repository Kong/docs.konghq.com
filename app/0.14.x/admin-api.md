---
title: Admin API

service_body: |
    Attributes | Description
    ---:| ---
    `name` <br>*optional*         | The Service name.
    `protocol`                    | The protocol used to communicate with the upstream. It can be one of `http` (default) or `https`.
    `host`                        | The host of the upstream server.
    `port`                        | The upstream server port. Defaults to `80`.
    `path`<br>*optional*          | The path to be used in requests to the upstream server. Empty by default.
    `retries`<br>*optional*       | The number of retries to execute upon failure to proxy. The default is `5`.
    `connect_timeout`<br>*optional* | The timeout in milliseconds for establishing a connection to the upstream server. Defaults to `60000`.
    `write_timeout`<br>*optional*    | The timeout in milliseconds between two successive write operations for transmitting a request to the upstream server. Defaults to `60000`.
    `read_timeout`<br>*optional*    | The timeout in milliseconds between two successive read operations for transmitting a request to the upstream server. Defaults to `60000`.
    `url`<br>*shorthand-attribute*    | Shorthand attribute to set `protocol`, `host`, `port` and `path` at once. This attribute is write-only (the Admin API never "returns" the url).

service_json: |
    {
        "id": "4e13f54a-bbf1-47a8-8777-255fed7116f2",
        "created_at": 1488869076800,
        "updated_at": 1488869076800,
        "connect_timeout": 60000,
        "protocol": "http",
        "host": "example.org",
        "port": 80,
        "path": "/api",
        "name": "example-service",
        "retries": 5,
        "read_timeout": 60000,
        "write_timeout": 60000
    }

route_body: |
    Attributes | Description
    ---:| ---
    `protocols`<br>                | A list of the protocols this Route should allow. By default it is `["http", "https"]`, which means that the Route accepts both. When set to `["https"]`, HTTP requests are answered with a request to upgrade to HTTPS. With form-encoded, the notation is `protocols[]=http&protocols[]=https`. With JSON, use an Array.
    `methods`<br>*semi-optional*   | A list of HTTP methods that match this Route. For example: `["GET", "POST"]`. At least one of `hosts`, `paths`, or `methods` must be set. With form-encoded, the notation is `methods[]=GET&methods[]=OPTIONS`. With JSON, use an Array.
    `hosts`<br>*semi-optional*     | A list of domain names that match this Route. For example: `example.com`. At least one of `hosts`, `paths`, or `methods` must be set. With form-encoded, the notation is `hosts[]=foo.com&hosts[]=bar.com`. With JSON, use an Array.
    `paths`<br>*semi-optional*     | A list of paths that match this Route. For example: `/my-path`. At least one of `hosts`, `paths`, or `methods` must be set. With form-encoded, the notation is `paths[]=/foo&paths[]=/bar`. With JSON, use an Array.
    `regex_priority`<br>*optional* | When evaluating the regex path of a Route, the `regex_priority` of the Route will be considered. Determines the relative order in which incoming requests are evaluated against defined Routes. Defaults to `0`.
    `strip_path`<br>*optional*     | When matching a Route via one of the `paths`, strip the matching prefix from the upstream request URL. Defaults to `true`.
    `preserve_host`<br>*optional*  | When matching a Route via one of the `hosts` domain names, use the request `Host` header in the upstream request headers. By default set to `false`, and the upstream `Host` header will be that of the Service's `host`.
    `service`                      | The Service this Route is associated to. This is where the Route proxies traffic to. With form-encoded, the notation is `service.id=<service_id>`. With JSON, use `"service":{"id":"<service_id>"}`.

route_json: |
    {
        "id": "22108377-8f26-4c0e-bd9e-2962c1d6b0e6",
        "created_at": 14888869056483,
        "updated_at": 14888869056483,
        "protocols": ["http", "https"],
        "methods": null,
        "hosts": ["example.com"],
        "paths": null,
        "regex_priority": 0,
        "strip_path": true,
        "preserve_host": false,
        "service": {
            "id": "4e13f54a-bbf1-47a8-8777-255fed7116f2"
        }
    }

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
    `service_id`<br>*optional* | The unique identifier of the service that overrides the existing settings for this specific service on incoming requests.
    `route_id`<br>*optional* | The unique identifier of the route that overrides the existing settings for this specific route on incoming requests.
    `config.{property}` | The configuration properties for the Plugin which can be found on the plugins documentation page in the [Kong Hub](https://docs.konghq.com/hub/).
    `enabled` | Whether the plugin is applied. Default: `true`.

target_body: |
    Attributes | Description
    ---:| ---
    `target` | The target address (ip or hostname) and port. If omitted the `port` defaults to `8000`. If the hostname resolves to an SRV record, the `port` value will overridden by the value from the dns record.
    `weight`<br>*optional* | The weight this target gets within the upstream loadbalancer (`0`-`1000`, defaults to `100`). If the hostname resolves to an SRV record, the `weight` value will overridden by the value from the dns record.

upstream_body: |
    Attributes | Description
    ---:| ---
    `name` | This is a hostname, which must be equal to the `host` of a Service.
    `slots`<br>*optional* | The number of slots in the loadbalancer algorithm (`10`-`65536`, defaults to `1000`).
    `hash_on`<br>*optional* | What to use as hashing input: `none`, `consumer`, `ip`, `header`, or `cookie` (defaults to `none` resulting in a weighted-round-robin scheme).
    `hash_fallback`<br>*optional* | What to use as hashing input if the primary `hash_on` does not return a hash (eg. header is missing, or no consumer identified). One of: `none`, `consumer`, `ip`, `header`, or `cookie` (defaults to `none`, not available if `hash_on` is set to `cookie`).
    `hash_on_header`<br>*semi-optional* | The header name to take the value from as hash input (only required when `hash_on` is set to `header`).
    `hash_fallback_header`<br>*semi-optional* | The header name to take the value from as hash input (only required when `hash_fallback` is set to `header`).
    `hash_on_cookie`<br>*semi-optional* | The cookie name to take the value from as hash input (only required when `hash_on` or `hash_fallback` is set to `cookie`). If the specified cookie is not in the request, Kong will generate a value and set the cookie in the response.
    `hash_on_cookie_path`<br>*semi-optional* | The cookie path to set in the response headers (only required when `hash_on` or `hash_fallback` is set to `cookie`, defaults to `"/"`)
    `healthchecks.active.timeout`<br>*optional* | Socket timeout for active health checks (in seconds).
    `healthchecks.active.concurrency`<br>*optional* | Number of targets to check concurrently in active health checks.
    `healthchecks.active.http_path`<br>*optional* | Path to use in GET HTTP request to run as a probe on active health checks.
    `healthchecks.active.healthy.interval`<br>*optional* | Interval between active health checks for healthy targets (in seconds). A value of zero indicates that active probes for healthy targets should not be performed.
    `healthchecks.active.healthy.http_statuses`<br>*optional* | An array of HTTP statuses to consider a success, indicating healthiness, when returned by a probe in active health checks.
    `healthchecks.active.healthy.successes`<br>*optional* | Number of successes in active probes (as defined by `healthchecks.active.healthy.http_statuses`) to consider a target healthy.
    `healthchecks.active.unhealthy.interval`<br>*optional* | Interval between active health checks for unhealthy targets (in seconds). A value of zero indicates that active probes for unhealthy targets should not be performed.
    `healthchecks.active.unhealthy.http_statuses`<br>*optional* | An array of HTTP statuses to consider a failure, indicating unhealthiness, when returned by a probe in active health checks.
    `healthchecks.active.unhealthy.tcp_failures`<br>*optional* | Number of TCP failures in active probes to consider a target unhealthy.
    `healthchecks.active.unhealthy.timeouts`<br>*optional* | Number of timeouts in active probes to consider a target unhealthy.
    `healthchecks.active.unhealthy.http_failures`<br>*optional* | Number of HTTP failures in active probes (as defined by `healthchecks.active.unhealthy.http_statuses`) to consider a target unhealthy.
    `healthchecks.passive.healthy.http_statuses`<br>*optional* | An array of HTTP statuses which represent healthiness when produced by proxied traffic, as observed by passive health checks.
    `healthchecks.passive.healthy.successes`<br>*optional* | Number of successes in proxied traffic (as defined by `healthchecks.passive.healthy.http_statuses`) to consider a target healthy, as observed by passive health checks.
    `healthchecks.passive.unhealthy.http_statuses`<br>*optional* | An array of HTTP statuses which represent unhealthiness when produced by proxied traffic, as observed by passive health checks.
    `healthchecks.passive.unhealthy.tcp_failures`<br>*optional* | Number of TCP failures in proxied traffic to consider a target unhealthy, as observed by passive health checks.
    `healthchecks.passive.unhealthy.timeouts`<br>*optional* | Number of timeouts in proxied traffic to consider a target unhealthy, as observed by passive health checks.
    `healthchecks.passive.unhealthy.http_failures`<br>*optional* | Number of HTTP failures in proxied traffic (as defined by `healthchecks.passive.unhealthy.http_statuses`) to consider a target unhealthy, as observed by passive health checks.

certificate_body: |
    Attributes | Description
    ---:| ---
    `cert` | PEM-encoded public certificate of the SSL key pair.
    `key` | PEM-encoded private key of the SSL key pair.
    `snis`<br>*optional* | An array of zero or more hostnames to associate with this certificate as SNIs. This is a sugar parameter that will, under the hood, create an SNI object and associate it with this certificate for your convenience.

snis_body: |
    Attributes | Description
    ---:| ---
    `name` | The SNI name to associate with the given certificate.
    `certificate.id` | The `id` (a UUID) of the certificate with which to associate the SNI hostname. With form-encoded, the notation is `certificate.id=<certificate_id>`. With JSON, use `"certificate":{"id":"<certificate_id>"}`.

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

**Endpoint**

<div class="endpoint get">/</div>

**Response**

```
HTTP 200 OK
```

```json
{
    "hostname": "",
    "node_id": "6a72192c-a3a1-4c8d-95c6-efabae9fb969",
    "lua_version": "LuaJIT 2.1.0-beta3",
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
    "version": "0.14.0"
}
```

* `node_id`: A UUID representing the running Kong node. This UUID is randomly generated when Kong starts, so the node will have a different `node_id` each
  time it is restarted.
* `available_on_server`: Names of plugins that are installed on the node.
* `enabled_in_cluster`: Names of plugins that are enabled/configured. That is, the plugins configurations currently in the datastore shared by all Kong nodes.

---

### Retrieve node status

Retrieve usage information about a node, with some basic information about the connections being processed by the underlying nginx process, and the status of the database connection.

If you want to monitor the Kong process, since Kong is built on top of nginx, every existing nginx monitoring tool or agent can be used.

**Endpoint**

<div class="endpoint get">/status</div>

**Response**

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

## Service Object

Service entities, as the name implies, are abstractions of each of your own
upstream services. Examples of Services would be a data transformation
microservice, a billing API, etc.

The main attribute of a Service is its URL (where Kong should proxy traffic
to), which can be set as a single string or by specifying its `protocol`,
`host`, `port` and `path` individually.

Services are associated to Routes (a Service can have many Routes associated
with it). Routes are entry-points in Kong and define rules to match client
requests. Once a Route is matched, Kong proxies the request to its associated
Service. See the [Proxy Reference][proxy-reference] for a detailed explanation
of how Kong proxies traffic.

```json
{{ page.service_json }}
```

---

### Add Service

**Endpoint**

<div class="endpoint post">/services/</div>

#### Request Body

{{ page.service_body }}

**Response**

```
HTTP 201 Created
```

```json
{{ page.service_json }}
```

---

### Retrieve Service

**Endpoints**

<div class="endpoint get">/services/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the Service to retrieve.

<div class="endpoint get">/routes/{route id}/service</div>

Attributes | Description
---:| ---
`route id`<br>**required** | The unique identifier of a Route belonging to the Service to be retrieved.

**Response**

```
HTTP 200 OK
```

```json
{{ page.service_json }}
```
---

### List Services

**Endpoint**

<div class="endpoint get">/services/</div>

#### Request Querystring Parameters

Attributes | Description
---:| ---
`offset`<br>*optional* | A cursor used for pagination. `offset` is an object identifier that defines a place in the list.
`size`<br>*optional, default is __100__ max is __1000__* | A limit on the number of objects to be returned per page.

**Response**

```
HTTP 200 OK
```

```json
{
    "data": [{
        "id": "4e13f54a-bbf1-47a8-8777-255fed7116f2",
        "created_at": 1488869076800,
        "updated_at": 1488869076800,
        "connect_timeout": 60000,
        "protocol": "http",
        "host": "example.org",
        "port": 80,
        "path": "/api",
        "name": "example-service",
        "retries": 5,
        "read_timeout": 60000,
        "write_timeout": 60000
    }, {
        "id": "8e13faaa-ee42-44ea-8421-255bc12316a1",
        "created_at": 1488869077320,
        "updated_at": 1488869077320,
        "connect_timeout": 60000,
        "protocol": "http",
        "host": "example2.org",
        "port": 80,
        "path": "/api",
        "name": "example-service2",
        "retries": 5,
        "read_timeout": 60000,
        "write_timeout": 60000
    }],
    "next": "http://localhost:8001/services?offset=6378122c-a0a1-438d-a5c6-efabae9fb969"
}
```

---

### Update Service

**Endpoints**

<div class="endpoint patch">/services/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The `id` **or** the `name` attribute of the Service to update.

<div class="endpoint patch">/routes/{route id}/service</div>

Attributes | Description
---:| ---
`route id`<br>**required** | The `id` attribute of the Route whose Service is to be updated.

#### Request Body

{{ page.service_body }}

**Response**

```
HTTP 200 OK
```

```json
{{ page.service_json }}
```

---

### Update or create Service

**Endpoint**

<div class="endpoint put">/services/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The `id` **or** the `name` attribute of the Service to update.

#### Request Body

{{ page.service_body }}

Inserts (or replaces) the Service under the requested resource with the
definition specified in the body. The Service will be identified via the `name
or id` attribute.

When the `name or id` attribute has the structure of a UUID, the Service being
inserted/replaced will be identified by its `id`. Otherwise it will be
identified by its `name`.

When creating a new Service without specifying `id` (neither in the URL nor in
the body), then it will be auto-generated.

Notice that specifying a `name` in the URL and a different one in the request
body is not allowed.

**Response**

```
HTTP 201 Created or HTTP 200 OK
```

See POST and PATCH responses.

---

### Delete Service

**Endpoint**

<div class="endpoint delete">/services/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The `id` **or** the `name` attribute of the Service to delete.

**Response**

```
HTTP 204 No Content
```

---

## Route Object

The Route entities defines rules to match client requests. Each Route is
associated with a Service, and a Service may have multiple Routes associated to
it. Every request matching a given Route will be proxied to its associated
Service.

The combination of Routes and Services (and the separation of concerns between
them) offers a powerful routing mechanism with which it is possible to define
fine-grained entry-points in Kong leading to different upstream services of
your infrastructure.

```json
{{ page.route_json }}
```

---

### Add Route

**Endpoints**

<div class="endpoint post">/routes/</div>

#### Request Body

{{ page.route_body }}

**Response**

```
HTTP 201 Created
```

```json
{{ page.route_json }}
```

### Retrieve Route

**Endpoints**

<div class="endpoint get">/routes/{id}</div>

Attributes | Description
---:| ---
`id`<br>**required** | The `id` attribute of the Route to retrieve.

**Response**

```
HTTP 200 OK
```

```json
{{ page.route_json }}
```

---

### List Routes

**Endpoints**

<div class="endpoint get">/routes</div>

#### Request Querystring Parameters

Attributes | Description
---:| ---
`offset`<br>*optional* | A cursor used for pagination. `offset` is an object identifier that defines a place in the list.
`size`<br>*optional, default is __100__ max is __1000__* | A limit on the number of objects to be returned per page.

**Response**

```
HTTP 200 OK
```

```json
{
    "data": [{
      "id": "22108377-8f26-4c0e-bd9e-2962c1d6b0e6",
      "created_at": 14888869056483,
      "updated_at": 14888869056483,
      "protocols": ["http", "https"],
      "methods": null,
      "hosts": ["example.com"],
      "paths": null,
      "regex_priority": 0,
      "strip_path": true,
      "preserve_host": false,
      "service": {
          "id": "4e13f54a-bbf1-47a8-8777-255fed7116f2"
      }
    }, {
      "id": "8d9b862b-527c-4bf1-9786-bfbb728f6539",
      "created_at": 14888869056435,
      "updated_at": 14888869056435,
      "protocols": ["http"],
      "methods": ["GET"],
      "hosts": ["example.com"],
      "paths": ["/private"],
      "regex_priority": 0,
      "strip_path": true,
      "preserve_host": false,
      "service": {
          "id": "4e13f54a-bbf1-47a8-8777-255fed7116f2"
      }
    }],
    "next": "http://localhost:8001/services/foo/routes?offset=6378122c-a0a1-438d-a5c6-efabae9fb969"
}
```

---

### List Routes associated to a Service

**Endpoints**

<div class="endpoint get">/services/{service name or id}/routes</div>

#### Request Querystring Parameters

Attributes | Description
---:| ---
`service name or id`<br>**required** | The `id` **or** the `name` attribute of the Service whose routes are to be Retrieved. When using this endpoint, only the Routes belonging to the specified Service will be listed.

**Response**

```
HTTP 200 OK
```

```json
{
    "total": 10,
    "data": [{
      "id": "22108377-8f26-4c0e-bd9e-2962c1d6b0e6",
      "created_at": 14888869056483,
      "updated_at": 14888869056483,
      "protocols": ["http", "https"],
      "methods": null,
      "hosts": ["example.com"],
      "paths": null,
      "regex_priority": 0,
      "strip_path": true,
      "preserve_host": false,
      "service": {
          "id": "4e13f54a-bbf1-47a8-8777-255fed7116f2"
      }
    }, {
      "id": "8d9b862b-527c-4bf1-9786-bfbb728f6539",
      "created_at": 14888869056435,
      "updated_at": 14888869056435,
      "protocols": ["http"],
      "methods": ["GET"],
      "hosts": ["example.com"],
      "paths": ["/private"],
      "regex_priority": 0,
      "strip_path": true,
      "preserve_host": false,
      "service": {
          "id": "4e13f54a-bbf1-47a8-8777-255fed7116f2"
      }
    }],
    "next": "http://localhost:8001/services/foo/routes?offset=6378122c-a0a1-438d-a5c6-efabae9fb969"
}
```

---

### Update Route

**Endpoint**

<div class="endpoint patch">/routes/{id}</div>

Attributes | Description
---:| ---
`id`<br>**required** | The `id` attribute of the Route to update.

#### Request Body

{{ page.route_body }}

**Response**

```
HTTP 200 OK
```

```json
{{ page.service_json }}
```
---

### Update or create Route

**Endpoint**

<div class="endpoint put">/routes/{id}</div>

Attributes | Description
---:| ---
`id`<br>**required** | The `id` attribute of the Route to update.

#### Request Body

{{ page.route_body }}

Inserts (or replaces) the Route under the requested resource with the
definition specified in the body.

The Route will be identified by the `id` attribute given in the URL.

**Response**

```
HTTP 201 Created or HTTP 200 OK
```

```json
{{ page.route_json }}
```
---

### Delete Route

**Endpoint**

<div class="endpoint delete">/routes/{id}</div>

Attributes | Description
---:| ---
`id`<br>**required** | The `id` attribute of the Route to delete.

**Response**

```
HTTP 204 No Content
```

---

## Consumer Object

The Consumer object represents a consumer - or a user - of a Service. You can either rely on Kong as the primary datastore, or you can map the consumer list with your database to keep consistency between Kong and your existing primary datastore.

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
`custom_id`<br>*optional* | A filter on the list based on the consumer `custom_id` field.

**Response**

```
HTTP 200 OK
```

```json
{
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

### Update or create Consumer

**Endpoint**

<div class="endpoint put">/consumers/{username or id}</div>

Attributes | Description
---:| ---
`username or id`<br>**required** | The unique identifier **or** the username of the consumer to update

#### Request Body

{{ page.consumer_body }}

Inserts (or replaces) the Consumer under the requested resource with the
definition specified in the body. The Consumer will be identified via the
`username or id` attribute.

When the `username or id` attribute has the structure of a UUID, the Consumer
being inserted/replaced will be identified by its `id`. Otherwise it will be
identified by its `username`.

When creating a new Consumer without specifying `id` (neither in the URL nor in
the body), then it will be auto-generated.

Notice that specifying a `username` in the URL and a different one in the
request body is not allowed.

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
HTTP 204 No Content
```

---

## Plugin Object

A Plugin entity represents a plugin configuration that will be executed during
the HTTP request/response lifecycle. It is how you can add functionalities
to Services that run behind Kong, like Authentication or Rate Limiting for
example. You can find more information about how to install and what values
each plugin takes by visiting the [Kong Hub](https://docs.konghq.com/hub/).

When adding a Plugin Configuration to a Service, every request made by a client to
that Service will run said Plugin. If a Plugin needs to be tuned to different
values for some specific Consumers, you can do so by specifying the
`consumer_id` value:

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "service_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
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

A plugin will always be run once and only once per request. But the
configuration with which it will run depends on the entities it has been
configured for.

Plugins can be configured for various entities, combination of entities, or
even globally. This is useful, for example, when you wish to configure a plugin
a certain way for most requests, but make _authenticated requests_ behave
slightly differently.

Therefore, there exists an order of precedence for running a plugin when it has
been applied to different entities with different configurations. The rule of
thumb is: the more specific a plugin is with regards to how many entities it
has been configured on, the higher its priority.

The complete order of precedence when a plugin has been configured multiple
times is:

1. Plugins configured on a combination of: a Route, a Service, and a Consumer.
   _(Consumer means the request must be authenticated)._
2. Plugins configured on a combination of a Route and a Consumer.
   _(Consumer means the request must be authenticated)._
3. Plugins configured on a combination of a Service and a Consumer.
   _(Consumer means the request must be authenticated)._
4. Plugins configured on a combination of a Route and a Service.
5. Plugins configured on a Consumer.
   _(Consumer means the request must be authenticated)._
6. Plugins configured on a Route.
7. Plugins configured on a Service.
8. Plugins configured to run globally.

**Example**: if the `rate-limiting` plugin is applied twice (with different
configurations): for a Service (Plugin config A), and for a Consumer (Plugin
config B), then requests authenticating this Consumer will run Plugin config B
and ignore A. However, requests that do not authenticate this Consumer will
fallback to running Plugin config A. Note that if config B is disabled
(its `enabled` flag is set to `false`), config A will apply to requests that
would have otherwise matched config B.

---

### Add Plugin

You can add a plugin in four different ways:

* For every Service/Route and Consumer. Don't set `consumer_id` and set `service_id` or `route_id`.
* For every Service/Route and a specific Consumer. Only set `consumer_id`.
* For every Consumer and a specific Service. Only set `service_id` (warning: some plugins only allow setting their `route_id`)
* For every Consumer and a specific Route. Only set `route_id` (warning: some plugins only allow setting their `service_id`)
* For a specific Service/Route and Consumer. Set both `service_id`/`route_id` and `consumer_id`.

Note that not all plugins allow to specify `consumer_id`. Check the plugin documentation.

**Endpoint**

<div class="endpoint post">/plugins/</div>

#### Request Body

{{ page.plugin_configuration_body }}

**Response**

```
HTTP 201 Created
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "service_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
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

**Response**

```
HTTP 200 OK
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "service_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
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

**Endpoint**

<div class="endpoint get">/plugins/</div>

#### Request Querystring Parameters

Attributes | Description
---:| ---
`id`<br>*optional* | A filter on the list based on the `id` field.
`name`<br>*optional* | A filter on the list based on the `name` field.
`service_id`<br>*optional* | A filter on the list based on the `service_id` field.
`route_id`<br>*optional* | A filter on the list based on the `route_id` field.
`consumer_id`<br>*optional* | A filter on the list based on the `consumer_id` field.
`size`<br>*optional, default is __100__* | A limit on the number of objects to be returned.
`offset`<br>*optional* | A cursor used for pagination. `offset` is an object identifier that defines a place in the list.

**Response**

```
HTTP 200 OK
```

```json
{
    "total": 10,
    "data": [
      {
          "id": "4d924084-1adb-40a5-c042-63b19db421d1",
          "service_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
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
          "service_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
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

**Endpoint**

<div class="endpoint patch">/plugins/{plugin id}</div>

Attributes | Description
---:| ---
`plugin id`<br>**required** | The unique identifier of the plugin configuration to update

#### Request Body

{{ page.plugin_configuration_body }}

**Response**

```
HTTP 200 OK
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "service_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
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

**Endpoint**

<div class="endpoint put">/plugins/</div>

#### Request Body

{{ page.plugin_configuration_body }}

The behavior of `PUT` endpoints is the following: if the request payload **does
not** contain an entity's primary key (`id` and `name` for Plugins), the entity
will be created with the given payload. If the request payload **does** contain
an entity's primary key, the payload will "replace" the entity specified by the
given primary key. If the primary key is **not** that of an existing entity, `404
NOT FOUND` will be returned.

**Response**

```
HTTP 201 Created or HTTP 200 OK
```

See POST and PATCH responses.

---

### Delete Plugin

**Endpoint**

<div class="endpoint delete">/plugins/{plugin id}</div>

Attributes | Description
---:| ---
`plugin id`<br>**required** | The unique identifier of the plugin configuration to delete

**Response**

```
HTTP 204 No Content
```

---

### Retrieve Enabled Plugins

Retrieve a list of all installed plugins on the Kong node.

**Endpoint**

<div class="endpoint get">/plugins/enabled</div>

**Response**

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
        "statsd",
        "syslog"
    ]
}
```

---

### Retrieve Plugin Schema

Retrieve the schema of a plugin's configuration. This is useful to understand what fields a plugin accepts, and can be used for building third-party integrations to the Kong's plugin system.

<div class="endpoint get">/plugins/schema/{plugin name}</div>

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

**Endpoint**

<div class="endpoint post">/certificates/</div>

#### Request Body

{{ page.certificate_body }}

**Response**

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

**Endpoint**

<div class="endpoint get">/certificates/{sni or id}</div>

Attributes | Description
---:| ---
`SNI or id`<br>**required** | The unique identifier **or** an SNI name associated with this certificate.

**Response**

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

**Endpoint**

<div class="endpoint get">/certificates/</div>

**Response**

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

**Response**

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

### Update or create Certificate

**Endpoint**

<div class="endpoint put">/certificates/{sni or id}</div>

Attributes | Description
---:| ---
`SNI or id`<br>**required** | The unique identifier **or** an SNI name associated with this certificate.

#### Request Body

{{ page.certificate_body }}

Inserts (or replaces) the Certificate under the requested resource with the definition
specified in the body. The Certificate will be identified by the `SNI or id` attribute.

If the Certificate for the provided id exists, or an SNI with the provided name exists,
this request will update said certificate using the request body. If the body includes an `snis`
pseudo-attribute, then the list of snis associated with the certificate will also be updated.

If the certificate for the provided id does not exist, a new certificate will be created
using the request body with the provided `id`. If the request body includes an `snis` pseudo-attribute,
then it will also create a list SNIs associated to the new certificate.

If no SNI with the provided sni name can be found, then a new certificate will be created using the
request body. If no `id` is included on the body, the newly-created certificate will have a random `id`.

If present, the `snis` pseudo-attribute will be used to create other SNIs associated to the certificate.
Note that providing an `snis` pseudo-attribute which does not include the provided SNI name is not allowed.

**Response**

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

**Response**

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
    "id": "daa105c8-9208-49e7-83fa-2fc0da28c6bd",
    "name": "example.com",
    "certificate": {
        "id": "21b69eab-09d9-40f9-a55e-c4ee47fada68"
    },
    "created_at": 1485521710265
}
```

---

### Add SNI

**Endpoint**

<div class="endpoint post">/snis/</div>

#### Request Body

{{ page.snis_body }}

**Response**

```
HTTP 201 Created
```

```json
{
    "id": "daa105c8-9208-49e7-83fa-2fc0da28c6bd",
    "name": "example.com",
    "certificate": {
        "id": "21b69eab-09d9-40f9-a55e-c4ee47fada68"
    },
    "created_at": 1485521710265
}
```

---

### Retrieve SNI

**Endpoint**

<div class="endpoint get">/snis/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The UUID of an SNI object or its unique name

**Response**

```
HTTP 200 OK
```

```json
{
    "id": "daa105c8-9208-49e7-83fa-2fc0da28c6bd",
    "name": "example.com",
    "certificate": {
        "id": "21b69eab-09d9-40f9-a55e-c4ee47fada68"
    },
    "created_at": 1485521710265
}
```

### List SNIs

**Endpoint**

<div class="endpoint get">/snis/</div>

**Response**

```
HTTP 200 OK
```

```json
{
    "total": 2,
    "data": [
        {
            "id": "daa105c8-9208-49e7-83fa-2fc0da28c6bd",
            "name": "example.com",
            "certificate": {
                "id": "21b69eab-09d9-40f9-a55e-c4ee47fada68"
            },
            "created_at": 1485521710265
        },
        {
            "id": "88c03fcd-9a48-4937-a976-0abd0eb6b60a",
            "name": "example.org",
            "certificate": {
                "id": "6b5b6f71-c0b3-426d-8f3b-8de2c67c816b"
            },
            "created_at": 1485521710265
        }
    ]
}
```

---

### Update SNI

<div class="endpoint patch">/snis/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The UUID of an SNI object or its unique name

**Response**

```
HTTP 200 OK
```

```json
{
    "id": "daa105c8-9208-49e7-83fa-2fc0da28c6bd",
    "name": "example.com",
    "certificate": {
        "id": "21b69eab-09d9-40f9-a55e-c4ee47fada68"
    },
    "created_at": 1485521710265
}
```

---

### Update or create SNI

**Endpoint**

<div class="endpoint put">/snis/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The UUID of an SNI object or its unique name

#### Request Body

{{ page.snis_body }}

Inserts (or replaces) the SNI under the requested resource with the definition
specified in the body. The SNI will be identified via the `name or id` attribute.

When the `name or id` attribute has the structure of an UUID, the SNI being inserted/replaced
will be identified by its `id`. Otherwise it will be identified by its `name`.

When creating a new SNI, if an `id` is not specified (neither in the URL or the body) then
the newly created one will be random. If an `id` is provided, the newly created Service will have
said `id`.

Notice that specifying a `name` in the url and a different one on the request body is not allowed.

**Response**

```
HTTP 201 Created or HTTP 200 OK
```

See POST and PATCH responses.

---

### Delete SNI

<div class="endpoint delete">/snis/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The UUID of an SNI object or its unique name

**Response**

```
HTTP 204 No Content
```
---

## Upstream Objects

The upstream object represents a virtual hostname and can be used to loadbalance
incoming requests over multiple services (targets). So for example an upstream
named `service.v1.xyz` for a Service object whose `host` is `service.v1.xyz`.
Requests for this Service would be proxied to the targets defined within the upstream.

An upstream also includes a [health checker][healthchecks], which is able to
enable and disable targets based on their ability or inability to serve
requests. The configuration for the health checker is stored in the upstream
object, and applies to all of its targets.

```json
{
    "name": "service.v1.xyz",
    "hash_on": "none",
    "hash_fallback": "none",
    "healthchecks": {
        "active": {
            "concurrency": 10,
            "healthy": {
                "http_statuses": [ 200, 302 ],
                "interval": 0,
                "successes": 0
            },
            "http_path": "/",
            "timeout": 1,
            "unhealthy": {
                "http_failures": 0,
                "http_statuses": [ 429, 404, 500, 501,
                                   502, 503, 504, 505 ],
                "interval": 0,
                "tcp_failures": 0,
                "timeouts": 0
            }
        },
        "passive": {
            "healthy": {
                "http_statuses": [ 200, 201, 202, 203,
                                   204, 205, 206, 207,
                                   208, 226, 300, 301,
                                   302, 303, 304, 305,
                                   306, 307, 308 ],
                "successes": 0
            },
            "unhealthy": {
                "http_failures": 0,
                "http_statuses": [ 429, 500, 503 ],
                "tcp_failures": 0,
                "timeouts": 0
            }
        }
    },
    "slots": 10
}
```

---

### Add upstream

**Endpoint**

<div class="endpoint post">/upstreams/</div>

#### Request Body

{{ page.upstream_body }}

**Response**

```
HTTP 201 Created
```

```json
{
    "id": "13611da7-703f-44f8-b790-fc1e7bf51b3e",
    "name": "service.v1.xyz",
    "hash_on": "none",
    "hash_fallback": "none",
    "healthchecks": {
        "active": {
            "concurrency": 10,
            "healthy": {
                "http_statuses": [ 200, 302 ],
                "interval": 0,
                "successes": 0
            },
            "http_path": "/",
            "timeout": 1,
            "unhealthy": {
                "http_failures": 0,
                "http_statuses": [ 429, 404, 500, 501,
                                   502, 503, 504, 505 ],
                "interval": 0,
                "tcp_failures": 0,
                "timeouts": 0
            }
        },
        "passive": {
            "healthy": {
                "http_statuses": [ 200, 201, 202, 203,
                                   204, 205, 206, 207,
                                   208, 226, 300, 301,
                                   302, 303, 304, 305,
                                   306, 307, 308 ],
                "successes": 0
            },
            "unhealthy": {
                "http_failures": 0,
                "http_statuses": [ 429, 500, 503 ],
                "tcp_failures": 0,
                "timeouts": 0
            }
        }
    },
    "slots": 10,
    "created_at": 1485521710265
}
```

---

### Retrieve upstream

**Endpoint**

<div class="endpoint get">/upstreams/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the upstream to retrieve

**Response**

```
HTTP 200 OK
```

```json
{
    "id": "13611da7-703f-44f8-b790-fc1e7bf51b3e",
    "name": "service.v1.xyz",
    "hash_on": "none",
    "hash_fallback": "none",
    "healthchecks": {
        "active": {
            "concurrency": 10,
            "healthy": {
                "http_statuses": [ 200, 302 ],
                "interval": 0,
                "successes": 0
            },
            "http_path": "/",
            "timeout": 1,
            "unhealthy": {
                "http_failures": 0,
                "http_statuses": [ 429, 404, 500, 501,
                                   502, 503, 504, 505 ],
                "interval": 0,
                "tcp_failures": 0,
                "timeouts": 0
            }
        },
        "passive": {
            "healthy": {
                "http_statuses": [ 200, 201, 202, 203,
                                   204, 205, 206, 207,
                                   208, 226, 300, 301,
                                   302, 303, 304, 305,
                                   306, 307, 308 ],
                "successes": 0
            },
            "unhealthy": {
                "http_failures": 0,
                "http_statuses": [ 429, 500, 503 ],
                "tcp_failures": 0,
                "timeouts": 0
            }
        }
    },
    "slots": 10,
    "created_at": 1485521710265
}
```

---

### List upstreams

**Endpoint**

<div class="endpoint get">/upstreams/</div>

#### Request Querystring Parameters

Attributes | Description
---:| ---
`id`<br>*optional* | A filter on the list based on the upstream `id` field.
`name`<br>*optional* | A filter on the list based on the upstream `name` field.
`hash_on`<br>*optional* | A filter on the list based on the upstream `hash_on` field.
`hash_fallback`<br>*optional* | A filter on the list based on the upstream `hash_fallback` field.
`hash_on_header`<br>*optional* | A filter on the list based on the upstream `hash_on_header` field.
`hash_fallback_header`<br>*optional* | A filter on the list based on the upstream `hash_fallback_header` field.
`slots`<br>*optional* | A filter on the list based on the upstream `slots` field.
`size`<br>*optional, default is __100__* | A limit on the number of objects to be returned.
`offset`<br>*optional* | A cursor used for pagination. `offset` is an object identifier that defines a place in the list.

**Response**

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
            "hash_on": "none",
            "hash_fallback": "none",
            "healthchecks": {
                "active": {
                    "concurrency": 10,
                    "healthy": {
                        "http_statuses": [ 200, 302 ],
                        "interval": 0,
                        "successes": 0
                    },
                    "http_path": "/",
                    "timeout": 1,
                    "unhealthy": {
                        "http_failures": 0,
                        "http_statuses": [ 429, 404, 500, 501,
                                           502, 503, 504, 505 ],
                        "interval": 0,
                        "tcp_failures": 0,
                        "timeouts": 0
                    }
                },
                "passive": {
                    "healthy": {
                        "http_statuses": [ 200, 201, 202, 203,
                                           204, 205, 206, 207,
                                           208, 226, 300, 301,
                                           302, 303, 304, 305,
                                           306, 307, 308 ],
                        "successes": 0
                    },
                    "unhealthy": {
                        "http_failures": 0,
                        "http_statuses": [ 429, 500, 503 ],
                        "tcp_failures": 0,
                        "timeouts": 0
                    }
                }
            },
            "slots": 10
        },
        {
            "created_at": 1485522651185,
            "id": "07131005-ba30-4204-a29f-0927d53257b4",
            "name": "service.v2.xyz",
            "hash_on": "none",
            "hash_fallback": "none",
            "healthchecks": {
                "active": {
                    "concurrency": 10,
                    "healthy": {
                        "http_statuses": [ 200, 302 ],
                        "interval": 5,
                        "successes": 2
                    },
                    "http_path": "/health_status",
                    "timeout": 1,
                    "unhealthy": {
                        "http_failures": 5,
                        "http_statuses": [ 429, 404, 500, 501,
                                           502, 503, 504, 505 ],
                        "interval": 5,
                        "tcp_failures": 2,
                        "timeouts": 3
                    }
                },
                "passive": {
                    "healthy": {
                        "http_statuses": [ 200, 201, 202, 203,
                                           204, 205, 206, 207,
                                           208, 226, 300, 301,
                                           302, 303, 304, 305,
                                           306, 307, 308 ],
                        "successes": 5
                    },
                    "unhealthy": {
                        "http_failures": 5,
                        "http_statuses": [ 429, 500, 503 ],
                        "tcp_failures": 2,
                        "timeouts": 7
                    }
                }
            },
            "slots": 10
        }
    ],
    "next": "http://localhost:8001/upstreams?size=2&offset=Mg%3D%3D",
    "offset": "Mg=="
}
```

---

### Update upstream

**Endpoint**

<div class="endpoint patch">/upstreams/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the upstream to update

#### Request Body

{{ page.upstream_body }}

**Response**

```
HTTP 200 OK
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "name": "service.v1.xyz",
    "hash_on": "none",
    "hash_fallback": "none",
    "slots": 10,
    "healthchecks": {
        "active": {
            "concurrency": 10,
            "healthy": {
                "http_statuses": [ 200, 302 ],
                "interval": 0,
                "successes": 0
            },
            "http_path": "/",
            "timeout": 1,
            "unhealthy": {
                "http_failures": 0,
                "http_statuses": [ 429, 404, 500, 501,
                                   502, 503, 504, 505 ],
                "interval": 0,
                "tcp_failures": 0,
                "timeouts": 0
            }
        },
        "passive": {
            "healthy": {
                "http_statuses": [ 200, 201, 202, 203,
                                   204, 205, 206, 207,
                                   208, 226, 300, 301,
                                   302, 303, 304, 305,
                                   306, 307, 308 ],
                "successes": 0
            },
            "unhealthy": {
                "http_failures": 0,
                "http_statuses": [ 429, 500, 503 ],
                "tcp_failures": 0,
                "timeouts": 0
            }
        }
    },
    "created_at": 1422386534
}
```

---

### Update or create Upstream

**Endpoint**

<div class="endpoint put">/upstreams/</div>

#### Request Body

{{ page.upstream_body }}

The behavior of `PUT` endpoints is the following: if the request payload **does
not** contain an entity's primary key (`id` for Upstreams), the entity will be
created with the given payload. If the request payload **does** contain an
entity's primary key, the payload will "replace" the entity specified by the
given primary key. If the primary key is **not** that of an existing entity, `404
NOT FOUND` will be returned.

**Response**

```
HTTP 201 Created or HTTP 200 OK
```

See POST and PATCH responses.

---

### Delete upstream

**Endpoint**

<div class="endpoint delete">/upstreams/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the upstream to delete

**Response**

```
HTTP 204 No Content
```

---

### Show Upstream health for node

Displays the health status for all Targets of a given Upstream, according to
the perspective of a specific Kong node. Note that, being node-specific
information, making this same request to different nodes of the Kong cluster
may produce different results. For example, one specific node of the Kong
cluster may be experiencing network issues, causing it to fail to connect to
some Targets: these Targets will be marked as unhealthy by that node
(directing traffic from this node to other Targets that it can successfully
reach), but healthy to all others Kong nodes (which have no problems using that
Target).

The `data` field of the response contains an array of Target objects.
The health for each Target is returned in its `health` field:

* If a Target fails to be activated in the ring balancer due to DNS issues,
  its status displays as `DNS_ERROR`.
* When [health checks][healthchecks] are not enabled in the Upstream
  configuration, the health status for active Targets is displayed as
  `HEALTHCHECKS_OFF`.
* When health checks are enabled and the Target is determined to be healthy,
  either automatically or [manually](#set-target-as-healthy),
  its status is displayed as `HEALTHY`. This means that this Target is
  currently included in this Upstream's load balancer ring.
* When a Target has been disabled by either active or passive health checks
  (circuit breakers) or [manually](#set-target-as-unhealthy),
  its status is displayed as `UNHEALTHY`. The load balancer is not directing
  any traffic to this Target via this Upstream.

### Endpoint

<div class="endpoint get">/upstreams/{name or id}/health/</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the Upstream for which to display Target health.

**Response**

```
HTTP 200 OK
```

```json
{
    "total": 2,
    "node_id": "cbb297c0-14a9-46bc-ad91-1d0ef9b42df9",
    "data": [
        {
            "created_at": 1485524883980,
            "id": "18c0ad90-f942-4098-88db-bbee3e43b27f",
            "health": "HEALTHY",
            "target": "127.0.0.1:20000",
            "upstream_id": "07131005-ba30-4204-a29f-0927d53257b4",
            "weight": 100
        },
        {
            "created_at": 1485524914883,
            "id": "6c6f34eb-e6c3-4c1f-ac58-4060e5bca890",
            "health": "UNHEALTHY",
            "target": "127.0.0.1:20002",
            "upstream_id": "07131005-ba30-4204-a29f-0927d53257b4",
            "weight": 200
        }
    ]
}
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

**Endpoint**

<div class="endpoint post">/upstreams/{name or id}/targets</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the upstream to which to add the target

#### Request Body

{{ page.target_body }}

**Response**

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

Lists all targets currently active on the upstream's load balancing wheel.

**Endpoint**

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

**Response**

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

### List all targets

Lists all targets of the upstream. Multiple target objects for the same
target may be returned, showing the history of changes for a specific target.
The target object with the latest `created_at` is the current definition.

### Endpoint

<div class="endpoint get">/upstreams/{name or id}/targets/all/</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the upstream for which to list the targets.

**Response**

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

**Endpoint**

<div class="endpoint delete">/upstreams/{upstream name or id}/targets/{target or id}</div>

Attributes | Description
---:| ---
`upstream name or id`<br>**required** | The unique identifier **or** the name of the upstream for which to delete the target.
`target or id`<br>**required** | The host/port combination element of the target to remove, or the `id` of an existing target entry.

**Response**

```
HTTP 204 No Content
```

---

### Set target as healthy

Set the current health status of a target in the load balancer to "healthy"
in the entire Kong cluster.

This endpoint can be used to manually re-enable a target that was previously
disabled by the upstream's [health checker][healthchecks]. Upstreams only
forward requests to healthy nodes, so this call tells Kong to start using this
target again.

This resets the health counters of the health checkers running in all workers
of the Kong node, and broadcasts a cluster-wide message so that the "healthy"
status is propagated to the whole Kong cluster.

**Endpoint**

<div class="endpoint post">/upstreams/{upstream name or id}/targets/{target or id}/healthy</div>

Attributes | Description
---:| ---
`upstream name or id`<br>**required** | The unique identifier **or** the name of the upstream.
`target or id`<br>**required** | The host/port combination element of the target to set as healthy, or the `id` of an existing target entry.

**Response**

```
HTTP 204 No Content
```

---

### Set target as unhealthy

Set the current health status of a target in the load balancer to "unhealthy"
in the entire Kong cluster.

This endpoint can be used to manually disable a target and have it stop
responding to requests. Upstreams only forward requests to healthy nodes, so
this call tells Kong to start skipping this target in the ring-balancer
algorithm.

This call resets the health counters of the health checkers running in all
workers of the Kong node, and broadcasts a cluster-wide message so that the
"unhealthy" status is propagated to the whole Kong cluster.

[Active health checks][active] continue to execute for unhealthy
targets. Note that if active health checks are enabled and the probe detects
that the target is actually healthy, it will automatically re-enable it again.
To permanently remove a target from the ring-balancer, you should [delete a
target](#delete-target) instead.

**Endpoint**

<div class="endpoint post">/upstreams/{upstream name or id}/targets/{target or id}/unhealthy</div>

Attributes | Description
---:| ---
`upstream name or id`<br>**required** | The unique identifier **or** the name of the upstream.
`target or id`<br>**required** | The host/port combination element of the target to set as unhealthy, or the `id` of an existing target entry.

**Response**

```
HTTP 204 No Content
```

[clustering]: /{{page.kong_version}}/clustering
[cli]: /{{page.kong_version}}/cli
[active]: /{{page.kong_version}}/health-checks-circuit-breakers/#active-health-checks
[healthchecks]: /{{page.kong_version}}/health-checks-circuit-breakers
[secure-admin-api]: /{{page.kong_version}}/secure-admin-api
[proxy-reference]: /{{page.kong_version}}/proxy
