---
title: Internal API
---

# Kong Internal API

Kong comes with an **internal** RESTful API for administration purposes. API commands can be run on any node in the cluster, and Kong will keep the configuration consistent across all nodes.

- The Internal API listens on port `8001`

---

## API Object

The API object describes an API that's being exposed by Kong. In order to do that Kong needs to know what is going to be the DNS address that will be pointing to the API, and what is the final target URL of the API where the requests will be proxied. Kong can serve more than one API domain.

```json
{
    "name": "Mockbin",
    "public_dns": "mockbin.com",
    "target_url": "https://mockbin.com"
}
```

---

### Add API

#### Endpoint

<div class="endpoint"><strong class="method POST">POST</strong><code class="path">/apis/</code></div>

#### Request Form Parameters

Attributes | Description
 ---:| ---
`name` | API name
`public_dns` | The public DNS address that points to your API. For example, `mockbin.com`.
`target_url` | The base target URL that points to your API server, this URL will be used for proxying requests. For example, `https://mockbin.com`.

#### Response

```
HTTP 201 Created
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "name": "Mockbin",
    "public_dns": "mockbin.com",
    "target_url": "http://mockbin.com",
    "created_at": 1422386534
}
```

---

### Retrieve API

#### Endpoint

<div class="endpoint"><strong class="method GET">GET</strong><code class="path">/apis/{id}</code></div>

Attributes | Description
 ---:| ---
`id`<br>**required** | The unique identifier of the API to be retrieved

#### Response

```
HTTP 200 OK
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "name": "Mockbin",
    "public_dns": "mockbin.com",
    "target_url": "https://mockbin.com",
    "created_at": 1422386534
}
```

---

### List APIs

#### Endpoint

<div class="endpoint"><strong class="method GET">GET</strong><code class="path">/apis/</code></div>

#### Request Querystring Parameters

Attributes | Description
 ---:| ---
`id`<br>*optional* | A filter on the list based on the apis `id` field.
`name`<br>*optional* | A filter on the list based on the apis `name` field.
`public_dns`<br>*optional* | A filter on the list based on the apis `public_dns` field.
`target_url`<br>*optional* | A filter on the list based on the apis `target_url` field.
`limit`<br>*optional, default is __10__* | A limit on the number of objects to be returned.
`offset`<br>*optional* | A cursor used for pagination. `offset` is an object identifier that defines a place in the list.

#### Response

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
            "created_at": 1422386534
        },
        {
            "id": "3f924084-1adb-40a5-c042-63b19db421a2",
            "name": "PrivateAPI",
            "public_dns": "internal.api.com",
            "target_url": "http://private.api.com",
            "created_at": 1422386585
        }
    ],
    "next": "http://localhost:8001/apis/?limit=10&offset=4d924084-1adb-40a5-c042-63b19db421d1",
    "previous": "http://localhost:8001/apis/?limit=10&offset=4d924084-1adb-40a5-c042-63b19db421d1"
}
```

---

### Update API

#### Endpoint

<div class="endpoint"><strong class="method PUT">PUT</strong><code class="path">/apis/{id}</code></div>

Attributes | Description
 ---:| ---
`id`<br>**required** | The unique identifier of the API to be updated

#### Request Body

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "name": "Mockbin2",
    "public_dns": "mockbin.com",
    "target_url": "http://mockbin.com",
    "created_at": 1422386534
}
```

#### Response

```
HTTP 200 OK
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "name": "Mockbin2",
    "public_dns": "mockbin.com",
    "target_url": "http://mockbin.com",
    "created_at": 1422386534
}
```

---

### Delete API

#### Endpoint

<div class="endpoint"><strong class="method DELETE">DELETE</strong><code class="path">/apis/{id}</code></div>

Attributes | Description
 ---:| ---
`id`<br>**required** | The unique identifier of the API to be deleted

#### Response

```
HTTP 204 NO CONTENT
```

---

## Consumer Object

The Consumer object represents a consumer, or a user, of an API. You can either rely on Kong as the primary datastore, or you can be map the consumer list with your database to keep consistency between Kong and your existing primary datastore.

```json
{
    "custom_id": "abc123"
}
```

---

### Create Consumer

#### Endpoint

<div class="endpoint"><strong class="method POST">POST</strong><code class="path">/consumers/</code></div>

#### Request Form Parameters

Attributes | Description
 ---:| ---
`username`<br>**semi-optional** | The username of the consumer. You must send either this field or `custom_id` with the request.
`custom_id`<br>**semi-optional** | Field for storing an existing ID for the consumer, useful for mapping Kong with users in your existing database. You must send either this field or `username` with the request.

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

<div class="endpoint"><strong class="method GET">GET</strong><code class="path">/consumers/{id}</code></div>

Attributes | Description
 ---:| ---
`id`<br>**required** | The unique identifier of the consumer to be retrieved

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

### List Consumer

#### Endpoint

<div class="endpoint"><strong class="method GET">GET</strong><code class="path">/consumers/</code></div>

#### Request Querystring Parameters

Attributes | Description
 ---:| ---
`id`<br>*optional* | A filter on the list based on the consumer `id` field.
`custom_id`<br>*optional* | A filter on the list based on the consumer `custom_id` field.
`username`<br>*optional* | A filter on the list based on the consumer `username` field.
`limit`<br>*optional, default is __10__* | A limit on the number of objects to be returned.
`offset`<br>*optional* | A cursor used for pagination. `offset` is an object identifier that defines a place in the list.

#### Response

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
    "next": "http://localhost:8001/consumers/?limit=10&offset=4d924084-1adb-40a5-c042-63b19db421d1",
    "previous": "http://localhost:8001/consumers/?limit=10&offset=4d924084-1adb-40a5-c042-63b19db421d1"
}
```

---

### Update Consumer

#### Endpoint

<div class="endpoint"><strong class="method PUT">PUT</strong><code class="path">/consumers/{id}</code></div>

Attributes | Description
 ---:| ---
`id`<br>**required** | The unique identifier of the consumer to be updated

#### Request Body

```json
{
    "custom_id": "updated_abc123"
}
```

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

### Delete Consumer

#### Endpoint

<div class="endpoint"><strong class="method DELETE">DELETE</strong><code class="path">/consumers/{id}</code></div>

Attributes | Description
 ---:| ---
`id`<br>**required** | The unique identifier of the consumer to be deleted

#### Response

```
HTTP 204 NO CONTENT
```

---

## Plugin Configuration Object

The Plugin Configuration object represents a plugin configuration that will be executed during the HTTP request/response workflow, and it's how you can add functionalities to an API that runs behind Kong, like Authentication or Rate Limiting. You can learn how to install a plugin by visiting the [Plugin Gallery](/plugins)

When installing a Plugin Configuration on top of an API, every request made by any application will be ruled by the plugin configuration you setup. Sometimes the Plugin Configuration needs to be tuned to different values for some specific consumers, you can do that by specifying the `consumer_id` value.

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "api_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
    "consumer_id": "a3dX2dh2-1adb-40a5-c042-63b19dbx83hF4",
    "name": "ratelimiting",
    "value": {
        "limit": 20,
        "period": "minute"
    },
    "created_at": 1422386534
}
```

---

### Create Plugin Configuration

#### Endpoint

<div class="endpoint"><strong class="method POST">POST</strong><code class="path">/plugins_configurations/</code></div>

#### Request Form Parameters

Attributes | Description
 ---:| ---
`name` | The name of the Plugin that's going to be added. Currently the Plugin must be installed in every Kong instance separately.
`api_id` | The unique identifier of the API the plugin will be enabled for.
`consumer_id`<br>*optional* | The unique identifier of the consumer that overrides the existing settings for this specific consumer on incoming requests.
`value.{property}` | The configuration properties for the Plugin which can be found on the plugins documentation page in the [Plugin Gallery](/plugins).

#### Response

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
        "limit": 20,
        "period": "minute"
    },
    "created_at": 1422386534
}
```

---

### Retrieve Plugin Configuration

#### Endpoint

<div class="endpoint"><strong class="method GET">GET</strong><code class="path">/plugins_configurations/{id}</code></div>

Attributes | Description
 ---:| ---
`id`<br>**required** | The unique identifier of the plugin configuration to be retrieved

#### Response

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
        "limit": 20,
        "period": "minute"
    },
    "created_at": 1422386534
}
```

---

### List Plugins Configurations

#### Endpoint

<div class="endpoint"><strong class="method GET">GET</strong><code class="path">/plugins_configurations/</code></div>

#### Request Querystring Parameters

Attributes | Description
 ---:| ---
`id`<br>*optional* | A filter on the list based on the `id` field.
`name`<br>*optional* | A filter on the list based on the `name` field.
`api_id`<br>*optional* | A filter on the list based on the `api_id` field.
`consumer_id`<br>*optional* | A filter on the list based on the `consumer_id` field.
`limit`<br>*optional, default is __10__* | A limit on the number of objects to be returned.
`offset`<br>*optional* | A cursor used for pagination. `offset` is an object identifier that defines a place in the list.

#### Response

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
              "limit": 20,
              "period": "minute"
          },
          "created_at": 1422386534
      },
      {
          "id": "3f924084-1adb-40a5-c042-63b19db421a2",
          "api_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
          "consumer_id": "a3dX2dh2-1adb-40a5-c042-63b19dbx83hF4",
          "name": "ratelimiting",
          "value": {
              "limit": 300,
              "period": "hour"
          },
          "created_at": 1422386585
      }
    ],
    "next": "http://localhost:8001/plugins_configurations/?limit=10&offset=4d924084-1adb-40a5-c042-63b19db421d1",
    "previous": "http://localhost:8001/plugins_configurations/?limit=10&offset=4d924084-1adb-40a5-c042-63b19db421d1"
}
```

---

### Update Plugin Configuration

#### Endpoint

<div class="endpoint"><strong class="method PUT">PUT</strong><code class="path">/plugins_configurations/{id}</code></div>

Attributes | Description
 ---:| ---
`id`<br>**required** | The unique identifier of the plugin configuration to be retrieved

#### Request Body

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "api_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
    "consumer_id": "a3dX2dh2-1adb-40a5-c042-63b19dbx83hF4",
    "name": "ratelimiting",
    "value": {
        "limit": 50,
        "period": "second"
    },
    "created_at": 1422386534
}
```

#### Response

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
        "limit": 50,
        "period": "second"
    },
    "created_at": 1422386534
}
```

---

### Delete Plugin Configurations

#### Endpoint

<div class="endpoint"><strong class="method DELETE">DELETE</strong><code class="path">/plugins_configurations/{id}</code></div>

Attributes | Description
 ---:| ---
`id`<br>**required** | The unique identifier of the plugin configuration to be deleted

#### Response

```
HTTP 204 NO CONTENT
```

[gitter-url]: https://gitter.im/Mashape/kong?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge
