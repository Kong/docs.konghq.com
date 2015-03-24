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

## Plugin Object

The Plugin object represents a plugin that will be executed during the HTTP request/response workflow, and it's how you can add functionalities to an API that runs behind Kong, like Authentication or Rate Limiting. You can learn how to install a plugin by visiting the [Plugin Gallery](/plugins/)

When installing a Plugin on top of an API, every request made by any application will be ruled by the plugin properties you setup. Sometimes the Plugin configuration needs to be tuned to different values for some specific applications, you can do that by specifying the `application_id` value.

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "api_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
    "application_id": "a3dX2dh2-1adb-40a5-c042-63b19dbx83hF4",
    "name": "ratelimiting",
    "value": {
        "limit": 20,
        "period": "minute"
    },
    "created_at": 1422386534
}
```

### Create Plugin

**Endpoint**

`POST /plugins/`

**Request Form Parameters**

* `name` - The name of the Plugin that's going to be added. The Plugin should have already been installed in every Kong server separately.
* `api_id` - The API ID that the Plugin will target
* `application_id` *optional* - An optional Application ID to customize the Plugin behavior when an incoming request is being sent by the specified Application overriding any other setup.
* `value.{property}` - The JSON configuration required for the Plugin. Each Plugin will have different configuration properties, so check the relative Plugin documentation to know which properties you can set.

**Response**:

```
HTTP 201 Created
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "api_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
    "application_id": "a3dX2dh2-1adb-40a5-c042-63b19dbx83hF4",
    "name": "ratelimiting",
    "value": {
        "limit": 20,
        "period": "minute"
    },
    "created_at": 1422386534
}
```

### Retrieve Plugin

**Endpoint**

`GET /plugins/{id}`

* `id` - The ID of the Plugin to retrieve

**Response**

```
HTTP 200 OK
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "api_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
    "application_id": "a3dX2dh2-1adb-40a5-c042-63b19dbx83hF4",
    "name": "ratelimiting",
    "value": {
        "limit": 20,
        "period": "minute"
    },
    "created_at": 1422386534
}
```

### List Plugins

**Endpoint**

`GET /plugins/`

**Request Querystring Parameters**

* `id` *optional* - The ID of the Plugin
* `name` *optional* - The name of the Plugin
* `api_id` *optional* - The ID of the API
* `application_id` *optional* - The ID of the Application

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
          "application_id": "a3dX2dh2-1adb-40a5-c042-63b19dbx83hF4",
          "name": "ratelimiting",
          "value": {
              "limit": 300,
              "period": "hour"
          },
          "created_at": 1422386585
      }
    ],
    "next": "http://localhost:8001/plugins/?limit=10&offset=4d924084-1adb-40a5-c042-63b19db421d1",
    "previous": "http://localhost:8001/plugins/?limit=10&offset=4d924084-1adb-40a5-c042-63b19db421d1"
}
```

### Update Plugin

**Endpoint**

`PUT /plugins/{id}`

* `id` - The ID of the Plugin to update

**Request Body**

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "api_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
    "application_id": "a3dX2dh2-1adb-40a5-c042-63b19dbx83hF4",
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
    "application_id": "a3dX2dh2-1adb-40a5-c042-63b19dbx83hF4",
    "name": "ratelimiting",
    "value": {
        "limit": 50,
        "period": "second"
    },
    "created_at": 1422386534
}
```


### Delete Plugin

**Endpoint**

`DELETE /plugins/{id}`

* `id` - The ID of the Plugin to delete

**Response**

```
HTTP 204 NO CONTENT
```

## Account Object

The Account object represents an account, or user, that can have one or more applications to consume the API objects. The Account object can be mapped with your database to keep consistency between Kong and your existing primary datastore.

```json
{
    "provider_id": "abc123"
}
```

### Create Account

**Endpoint**

`POST /accounts/`

**Request Form Parameters**

* `provider_id` *optional* - This is an optional field where you can store an existing ID for an Account, useful to map a Kong Account with a user in your existing database

**Response**

```
HTTP 201 Created
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "provider_id": "abc123",
    "created_at": 1422386534
}
```

### Retrieve Account

**Endpoint**

`GET /accounts/{id}`

* `id` - The ID of the Account to retrieve

**Response**

```
HTTP 200 OK
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "provider_id": "abc123",
    "created_at": 1422386534
}
```

### List Accounts

**Endpoint**

`GET /accounts/`

**Request Querystring Parameters**

* `id` *optional* - The ID of the Account
* `provider_id` *optional* - The custom ID you set for the Account

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
            "provider_id": "abc123",
            "created_at": 1422386534
        },
        {
            "id": "3f924084-1adb-40a5-c042-63b19db421a2",
            "provider_id": "def345",
            "created_at": 1422386585
        }
    ],
    "next": "http://localhost:8001/accounts/?limit=10&offset=4d924084-1adb-40a5-c042-63b19db421d1",
    "previous": "http://localhost:8001/accounts/?limit=10&offset=4d924084-1adb-40a5-c042-63b19db421d1"
}
```

### Update Account

**Endpoint**

`PUT /accounts/{id}`

* `id` - The ID of the Account to update

**Request Body**

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "provider_id": "updated_abc123",
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
    "provider_id": "updated_abc123",
    "created_at": 1422386534
}
```


### Delete Account

**Endpoint**

`DELETE /accounts/{id}`

* `id` - The ID of the Account to delete

**Response**

```
HTTP 204 NO CONTENT
```

## Application Object

The Application object represents an application belonging to an existing Account, and stores credentials for consuming the API objects. An Account can have more than one Application. An Application can represent one or more API keys, for example.

```json
{
    "account_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
    "secret_key": "SECRET-xaWijqenkln81jA",
    "public_key": "PUBLIC-08landkl123sa"
}
```

### Create Application

**Endpoint**

`POST /applications/`

**Request Form Parameters**

* `account_id` - The Account ID of an existing Account whose this application belongs to.
* `secret_key` - This is where the secret credential, like an API key or a password, will be stored. It is required.
* `public_key` *optional* - Some authentication types require both a public and a secret key. This field is reserved for public keys, and can be empty if not used.

**Response**

```
HTTP 201 Created
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "account_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
    "secret_key": "SECRET-xaWijqenkln81jA",
    "public_key": "PUBLIC-08landkl123sa",
    "created_at": 1422386534
}
```

### Retrieve Application

**Endpoint**

`GET /applications/{id}`

* `id` - The ID of the Application to retrieve

**Response**

```
HTTP 200 OK
```

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "account_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
    "secret_key": "SECRET-uajZwmSnLHBiRGb",
    "public_key": "PUBLIC-74YmAGcirwkMdS6",
    "created_at": 1422386534
}
```

### List Applications

**Endpoint**

`GET /applications/`

**Request Querystring Parameters**

* `id` *optional* - The ID of the Application
* `account_id` *optional* - The ID of the Account
* `public_key` *optional* - The public key to lookup
* `secret_key` *optional* - The secret key to lookup

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
            "account_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
            "secret_key": "SECRET-uajZwmSnLHBiRGb",
            "public_key": "PUBLIC-74YmAGcirwkMdS6",
            "created_at": 1422386534
        },
        {
            "id": "3f924084-1adb-40a5-c042-63b19db421a2",
            "account_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
            "secret_key": "SECRET-4hvoM6xcHMLb6QK",
            "public_key": "PUBLIC-y5JlLqGeswN2JcB",
            "created_at": 1422386585
        }
    ],
    "next": "http://localhost:8001/applications/?limit=10&offset=4d924084-1adb-40a5-c042-63b19db421d1",
    "previous": "http://localhost:8001/applications/?limit=10&offset=4d924084-1adb-40a5-c042-63b19db421d1"
}
```

### Update Application

**Endpoint**

`PUT /applications/{id}`

* `id` - The ID of the Application to update

**Request Body**

```json
{
    "id": "4d924084-1adb-40a5-c042-63b19db421d1",
    "account_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
    "secret_key": "UPDATED-SECRET-uajZwmSnLHBiRGb",
    "public_key": "UPDATED-PUBLIC-74YmAGcirwkMdS6",
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
    "account_id": "5fd1z584-1adb-40a5-c042-63b19db49x21",
    "secret_key": "UPDATED-SECRET-uajZwmSnLHBiRGb",
    "public_key": "UPDATED-PUBLIC-74YmAGcirwkMdS6",
    "created_at": 1422386534
}
```

### Delete Application

**Endpoint**

`DELETE /applications/{id}`

* `id` - The ID of the Application to delete

**Response**

```
HTTP 204 NO CONTENT
```

[gitter-url]: https://gitter.im/Mashape/kong?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge
