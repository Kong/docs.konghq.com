---
id: page-plugin
title: Plugins - HMAC Authentication
header_title: HMAC Authentication
header_icon: /assets/images/icons/plugins/hmac-authentication.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Configuration
  - label: Usage
    items:
      - label: Create a Consumer
      - label: Create a Credential
      - label: Signature Authentication Scheme
      - label: Signature Parameters
      - label: Signature String Construction
      - label: Clock Skew
      - label: Body Validation
      - label: Enforcing Headers
      - label: HMAC Example
      - label: Upstream Headers
      - label: Paginate through the HMAC Credentials
      - label: Retrieve the Consumer associated with a Credential
---

Add HMAC Signature authentication to your APIs to establish the integrity of
incoming requests. The plugin will validate the digital signature sent in the
`Proxy-Authorization` or `Authorization` header (in this order). This plugin
implementation is based off the [draft-cavage-http-signatures][draft] draft
with a slightly different signature scheme.

----

## Configuration

Configuring the plugin is straightforward, you can add it on top of an
[API][api-object] by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=hmac-auth"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

You can also apply it for every API using the `http://kong:8001/plugins/`
endpoint. Read the [Plugin Reference](/docs/latest/admin-api/#add-plugin)
for more information.

form parameter                          | default | description
---                                     | --- | ---
`name`                                  | | The name of the plugin to use, in this case: `hmac-auth`
`config.hide_credentials`<br>*optional* | `false` | A boolean value telling the plugin to hide the credential to the upstream API server. It will be removed by Kong before proxying the request
`config.clock_skew`<br>*optional*       | `300` | [Clock Skew][clock-skew] in seconds to prevent replay attacks.
`config.anonymous`<br>*optional*        | `` | A string (consumer uuid) value to use as an "anonymous" consumer if authentication fails. If empty (default), the request will fail with an authentication failure `4xx`
`config.validate_request_body`<br>*optional* | `false` | A boolean value telling the plugin to enable body validation
`config.enforce_headers`<br>*optional*  | `` | A list of headers which the client should at least use for HTTP signature creation
`config.algorithms`<br>*optional*       | `hmac-sha1`,<br>`hmac-sha256`,<br>`hmac-sha384`,<br>`hmac-sha512` | A list of HMAC digest algorithms which the user wants to support. Allowed values are `hmac-sha1`, `hmac-sha256`, `hmac-sha384`, and `hmac-sha512`
----

## Usage

In order to use the plugin, you first need to create a Consumer to associate
one or more credentials to.

### Create a Consumer

You need to associate a credential to an existing [Consumer][consumer-object]
object. To create a
[Consumer][consumer-object] you can execute the following request:

```bash
$ curl -d "username=user123&custom_id=SOME_CUSTOM_ID" http://kong:8001/consumers/
```

parameter                       | description
---                             | ---
`username`<br>*semi-optional*   | The username of the consumer. Either this field or `custom_id` must be specified.
`custom_id`<br>*semi-optional*  | A custom identifier used to map the consumer to another database. Either this field or `username` must be specified.

A [Consumer][consumer-object] can have many credentials.

### Create a Credential

You can provision new username/password credentials by making the following
HTTP request:

```bash
$ curl -X POST http://kong:8001/consumers/{consumer}/hmac-auth \
    --data "username=bob" \
    --data "secret=secret456"
```

`consumer`: The `id` or `username` property of the [Consumer][consumer-object]
entity to associate the credentials to.

form parameter             | description
---                        | ---
`username`                 | The username to use in the HMAC Signature verification.
`secret`<br>*optional*     | The secret to use in the HMAC Signature verification. Note that if this parameter isn't provided, Kong will generate a value for you and send it as part of the response body.

### Signature Authentication Scheme

The client is expected to send an `Authorization` or `Proxy-Authorization` header
with the following parameterization:

```
credentials := "hmac" params
params := keyId "," algorithm ", " headers ", " signature
keyId := "username" "=" plain-string
algorithm := "algorithm" "=" DQUOTE (hmac-sha1|hmac-sha256|hmac-sha384|hmac-sha512) DQUOTE
headers := "headers" "=" plain-string
signature := "signature" "=" plain-string
plain-string   = DQUOTE *( %x20-21 / %x23-5B / %x5D-7E ) DQUOTE
```

### Signature Parameters

parameter| description
---       | ---
username  | The `username` of the credential
algorithm | Digital signature algorithm used to create the signature
headers   | List of HTTP header names, separated by a single space character, used to sign the request
signature | `Base64` encoded digital signature generated by the client

### Signature String Construction

In order to generate the string that is signed with a key, the client
MUST take the values of each HTTP header specified by `headers` in
the order they appear.

1. If the header name is not `request-line` then append the
  lowercased header name followed with an ASCII colon `:` and an
  ASCII space ` `.

2. If the header name is `request-line` then append the HTTP
  request line, otherwise append the header value.

3. If value is not the last value then append an ASCII newline `\n`.
  The string MUST NOT include a trailing ASCII newline.

### Clock Skew

The HMAC Authentication plugin also implements a clock skew check as described
in the [specification][clock-skew] to prevent replay attacks. By default,
a minimum lag of 300s in either direction (past/future) is allowed. Any request
with a higher or lower date value will be rejected. The length of the clock
skew can be edited through the plugin's configuration by setting the
`clock_skew` property (`config.clock_skew` POST parameters).

The server and requesting client should be synchronized with NTP and a valid
date (using GMT format) should be sent with either the `X-Date` or `Date`
header.

### Body Validation

User can set `config.validate_request_body` as `true` to validate the request 
body. If it's enabled and if the client sends a `Digest` header in the request,
the plugin will calculate the `SHA-256` HMAC digest of the request body and
match it against the value of the `Digest` header. The Digest header needs to
be in following format:

```
Digest: SHA-256=base64(sha256(<body>))
```

Note: In order to create the digest of a request body, the plugin needs to
retain it in memory, which might cause pressure on the worker's Lua VM when
dealing with large bodies (several MBs) or during high request concurrency.

### Enforcing Headers

`config.enforce_headers` can be used to enforce any of the headers to be part 
of the signature creation. By default, the plugin doesn't enforce which header
needs to be used for the signature creation. The minimum recommended data to
sign is the `request-line`, `host`, and `date`. A strong signature would
include all of the headers and a `digest` of the body.

### HMAC Example

  **Add an API**

  ```bash
  $ curl -i -X POST http://localhost:8001/apis \
      -d "name=hmac-test" \
      -d "hosts=hmac.com" \
      -d "upstream_url=http://example.com"
  HTTP/1.1 201 Created
  ...

  ```
  
  **Enable plugin**

  ```bash
  $ curl -i -X POST http://localhost:8001/apis/hmac-test/plugins \
      -d "name=hmac-auth" \
      -d "config.enforce_headers=date, request-line" \
      -d "config.algorithms=hmac-sha1, hmac-sha256"
  HTTP/1.1 201 Created
  ...

  ```

  Here we are enabling the `hmac-auth` plugin on API the `hmac-test`.
  `config.enforce_headers` is set to force the client to at least use `date`
  and `request-line` in the HTTP signature creation. Also we are setting the
  `config.algorithms` to force the client to only use `hmac-sha1` or
  `hmac-sha256` for hashing the signing string.

  **Add a Consumer**

  ```bash
  $ curl -i -X POST http://localhost:8001/consumers/ \
      -d "username=alice"
  HTTP/1.1 201 Created
  ...

  ```

  **Add credential for Alice**

  ```bash
  $ curl -i -X POST http://localhost:8001/consumers/alice/hmac-auth \
      -d "username=alice123" \
      -d "secret=secret"
  HTTP/1.1 201 Created
  ...

  ```

  **Request to the API**

  ```bash
  $ curl -i -X GET http://localhost:8000/requests \
      -H "Host: hmac.com" \
      -H "Date: Thu, 22 Jun 2017 17:15:21 GMT" \
      -H 'Authorization: hmac username="alice123", algorithm="hmac-sha256", headers="date request-line", signature="ujWCGHeec9Xd6UD2zlyxiNMCiXnDOWeVFMu5VeRUxtw="'
  HTTP/1.1 200 OK
  ...
  
  ```
  
  In the above request, we are composing the signing string using the `date` and
  `request-line` headers and creating the digest using the `hmac-sha256` to
  hash the digest:
  
  ```
  signing_string="date: Thu, 22 Jun 2017 17:15:21 GMT\nGET /requests HTTP/1.1"
  digest=HMAC-SHA256(<signing_string>, "secret")
  base64_digest=base64(<digest>)
  ```
  
  So the final value of the `Authorization` header would look like: 

  
  ```
  Authorization: hmac username="alice123", algorithm="hmac-sha256", headers="date request-line", signature=<base64_digest>"
  ```

  **Validating request body**
  
  To enable body validation we would need to set `config.validate_request_body` 
  to `true`:

  ```bash
  $ curl -i -X PATCH http://localhost:8001/apis/hmac-test/plugins/:plugin_id \
      -d "config.validate_request_body=true"
  HTTP/1.1 200 OK
  ...
  
  ```

  Now if the client includes the body digest in the request as the value of the
  `Digest` header, the plugin will validate the request body by calculating the
  `SHA-256` of the body and matching it against the `Digest` header's value.

  ```bash
  $ curl -i -X GET http://localhost:8000/requests \
      -H "Host: hmac.com" \
      -H "Date: Thu, 22 Jun 2017 21:12:36 GMT" \
      -H "Digest: SHA-256=SBH7QEtqnYUpEcIhDbmStNd1MxtHg2+feBfWc1105MA=" \
      -H 'Authorization: hmac username="alice123", algorithm="hmac-sha256", headers="date request-line digest", signature="gaweQbATuaGmLrUr3HE0DzU1keWGCt3H96M28sSHTG8="' \
      -d "A small body"
  HTTP/1.1 200 OK
  ...

  ```

  In the above request we calculated the `SHA-256` digest of the body and set
  the `Digest` header with the following format:

  ```
  body="A small body" 
  digest=SHA-256(body)
  base64_digest=base64(digest)
  Digest: SHA-256=<base64_digest>
  ```

### Upstream Headers

When a client has been authenticated, the plugin will append some headers to
the request before proxying it to the upstream API/Microservice, so that you
can identify the Consumer in your code:

* `X-Consumer-ID`, the ID of the Consumer on Kong
* `X-Consumer-Custom-ID`, the `custom_id` of the Consumer (if set)
* `X-Consumer-Username`, the `username` of the Consumer (if set)
* `X-Credential-Username`, the `username` of the Credential (only if the consumer is not the 'anonymous' consumer)
* `X-Anonymous-Consumer`, will be set to `true` when authentication failed, and the 'anonymous' consumer was set instead.

You can use this information on your side to implement additional logic.
You can use the `X-Consumer-ID` value to query the Kong Admin API and retrieve
more information about the Consumer.

### Paginate through the HMAC Credentials

<div class="alert alert-warning">
  <strong>Note:</strong> This endpoint was introduced in Kong 0.11.2.
</div>

You can retrieve all the hmac-auth Credentials for all the Consumers using the
following request:

```bash
$ curl -X GET http://kong:8001/hmac-auths

{
    "total": 3,
    "data": [
        {
            "created_at": 1509681246000,
            "id": "75695322-e8a0-4109-aed4-5416b0308d85",
            "secret": "wQazJ304DW5huJklHgUfjfiSyCyTAEDZ",
            "username": "foo",
            "consumer_id": "c0d92ba9-8306-482a-b60d-0cfdd2f0e880"
        },
        {
            "created_at": 1509419793000,
            "id": "11d5cbfb-31b9-4a6d-8496-2f4a76500643",
            "secret": "zi6YHyvLaUCe21XMXKesTYiHSWy6m6CW",
            "username": "bar",
            "consumer_id": "3c2c8fc1-7245-4fbb-b48b-e5947e1ce941"
        },
        {
            "created_at": 1509681215000,
            "id": "eb0365bc-88ae-4568-be7c-db1eb7c16e5e",
            "secret": "NvHDTg5mp0ySFVJsITurtgyhEq1Cxbnv",
            "username": "baz",
            "consumer_id": "c0d92ba9-8306-482a-b60d-0cfdd2f0e880"
        }
    ]
}
```

You can filter the list using the following query parameters:

Attributes | Description
---:| ---
`id`<br>*optional*                       | A filter on the list based on the hmac-auth credential `id` field.
`username`<br>*optional*                 | A filter on the list based on the hmac-auth credential `username` field.
`consumer_id`<br>*optional*              | A filter on the list based on the hmac-auth credential `consumer_id` field.
`size`<br>*optional, default is __100__* | A limit on the number of objects to be returned.
`offset`<br>*optional*                   | A cursor used for pagination. `offset` is an object identifier that defines a place in the list.

### Retrieve the Consumer associated with a Credential

<div class="alert alert-warning">
  <strong>Note:</strong> This endpoint was introduced in Kong 0.11.2.
</div>

It is possible to retrieve a [Consumer][consumer-object] associated with an
HMAC Credential using the following request:

```bash
curl -X GET http://kong:8001/hmac-auths/{hmac username or id}/consumer

{
   "created_at":1507936639000,
   "username":"foo",
   "id":"c0d92ba9-8306-482a-b60d-0cfdd2f0e880"
}
```

`hmac username or id`: The `id` or `username` property of the HMAC Credential
for which to get the associated [Consumer][consumer-object].
Note that `username` accepted here is **not** the `username` property of a
Consumer.

[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
[draft]: https://tools.ietf.org/html/draft-cavage-http-signatures
[clock-skew]: https://tools.ietf.org/html/draft-cavage-http-signatures-00#section-3.4
