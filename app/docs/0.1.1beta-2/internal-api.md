---
title: Internal API
---

# Kong Internal API

Kong comes with an **internal** RESTful API for administration purposes. API commands can be run on any node in the cluster, and Kong will keep the configuration consistent across all nodes.

- The Internal API listens on port `8001`

## API Object

The API object describes an API that's being exposed by Kong. In order to do that Kong needs to know what is going to be the DNS address that will be pointing to the API, and what is the final target URL of the API where the requests will be proxied. Kong can serve more than one API domain.

```json
{
    "name": "HttpBin",
    "public_dns": "my.api.com",
    "target_url": "http://httpbin.org"
}
```

### Create API

**Endpoint**

`POST /apis/`

**Request Form Parameters**

* `name` - The name of the API
* `public_dns` - The public DNS address that will be pointing to the API. For example: *myapi.com*
* `target_url` - The base target URL that points to the API server, that will be used for proxying the requests. For example: *http://httpbin.org*

**Response**

```
HTTP 201 Created
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "name": "HttpBin",
    "public_dns": "my.api.com",
    "target_url": "http://httpbin.org",
    "created_at": 1422386534
}
```

### Retrieve API

**Endpoint**

`GET /apis/{id}`

* `id` - The ID of the API to retrieve

**Response**

```
HTTP 200 OK
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "name": "HttpBin",
    "public_dns": "my.api.com",
    "target_url": "http://httpbin.org",
    "created_at": 1422386534
}
```

### List APIs

**Endpoint**

`GET /apis/`

**Request Querystring Parameters**

* `id` *optional* - The ID of the API
* `name` *optional* - The name of the API
* `public_dns` *optional* - The public DNS
* `target_url` *optional* - The target URL

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
            "name": "HttpBin",
            "public_dns": "my.api.com",
            "target_url": "http://httpbin.org",
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

### Update API

**Endpoint**

`PUT /apis/{id}`

* `id` - The ID of the API to update

**Request Body**

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "name": "HttpBin2",
    "public_dns": "my.api2.com",
    "target_url": "http://httpbin2.org",
    "created_at": 1422386534
}
```

**Response**

```
HTTP 200 OK
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "name": "HttpBin2",
    "public_dns": "my.api2.com",
    "target_url": "http://httpbin2.org",
    "created_at": 1422386534
}
```


### Delete API

**Endpoint**

`DELETE /apis/{id}`

* `id` - The ID of the API to delete

**Response**

```
HTTP 204 NO CONTENT
```


## Consumer Object

The Consumer object represents a consumer, or a user, of an API. You can either rely on Kong as the primary datastore, or you can be map the consumer list with your database to keep consistency between Kong and your existing primary datastore.

```json
{
    "custom_id": "abc123"
}
```

### Create Consumer

**Endpoint**

`POST /consumers/`

**Request Form Parameters**

* `username` *optional* - The username for the consumer. At least this field or `custom_id` must be sent.
* `custom_id` *optional* - This is a field where you can store an existing ID for a Consumer, useful to map a Kong Consumer with a user in your existing database. At least this field or `username` must be sent.

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

### Retrieve Consumer

**Endpoint**

`GET /consumers/{id}`

* `id` - The ID of the Consumer to retrieve

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

### List Consumer

**Endpoint**

`GET /consumers/`

**Request Querystring Parameters**

* `id` *optional* - The ID of the Consumer
* `custom_id` *optional* - The custom ID you set for the Consumer

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
    "next": "http://localhost:8001/consumers/?limit=10&offset=4d924084-1adb-40a5-c042-63b19db421d1",
    "previous": "http://localhost:8001/consumers/?limit=10&offset=4d924084-1adb-40a5-c042-63b19db421d1"
}
```

### Update Consumer

**Endpoint**

`PUT /consumers/{id}`

* `id` - The ID of the Consumer to update

**Request Body**

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "custom_id": "updated_abc123",
    "created_at": 1422386534
}
```

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


### Delete Consumer

**Endpoint**

`DELETE /consumers/{id}`

* `id` - The ID of the Consumer to delete

**Response**

```
HTTP 204 NO CONTENT
```

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

### Create Plugin Configuration

**Endpoint**

`POST /plugins_configurations/`

**Request Form Parameters**

* `name` - The name of the Plugin that's going to be added. The Plugin should have already been installed in every Kong server separately.
* `api_id` - The API ID that the Plugin will target
* `consumer_id` *optional* - An optional Consumer ID to customize the Plugin behavior when an incoming request is being sent by the specified Consumer overriding any other setup.
* `value.{property}` - The JSON configuration required for the Plugin. Each Plugin will have different configuration properties, so check the relative Plugin documentation to know which properties you can set.

**Response**:

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

### Retrieve Plugin Configuration

**Endpoint**

`GET /plugins_configurations/{id}`

* `id` - The ID of the Plugin Configuration to retrieve

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
        "limit": 20,
        "period": "minute"
    },
    "created_at": 1422386534
}
```

### List Plugins Configurations

**Endpoint**

`GET /plugins_configurations/`

**Request Querystring Parameters**

* `id` *optional* - The ID of the Plugin
* `name` *optional* - The name of the Plugin
* `api_id` *optional* - The ID of the API
* `consumer_id` *optional* - The ID of the Consumer

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

### Update Plugin Configuration

**Endpoint**

`PUT /plugins_configurations/{id}`

* `id` - The ID of the Plugin Configuration to update

**Request Body**

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
        "limit": 50,
        "period": "second"
    },
    "created_at": 1422386534
}
```


### Delete Plugin Configurations

**Endpoint**

`DELETE /plugins_configurations/{id}`

* `id` - The ID of the Plugin Configuration to delete

**Response**

```
HTTP 204 NO CONTENT
```

[gitter-url]: https://gitter.im/Mashape/kong?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge
