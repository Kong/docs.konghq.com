---
nav_title: Overview
---

Add HMAC Signature authentication to a service or a route
to establish the integrity of incoming requests. The plugin validates the
digital signature sent in the `Proxy-Authorization` or `Authorization` header
(in that order). This plugin implementation is based off the
[draft-cavage-http-signatures](https://tools.ietf.org/html/draft-cavage-http-signatures)
draft with a slightly different signature scheme.

{:.important}
> **Important**: Once the plugin is enabled, any user with a valid credential can access the service or route.
To restrict usage to only some of the authenticated users, also add the
[ACL](/plugins/acl/) plugin (not covered here) and create allowed or
denied groups of users.

## Usage

In order to use the plugin, you first need to create a Consumer to associate
one or more credentials to.

Note: Because the HMAC signature is generated by the client, you should make sure that Kong does not
update or remove any request parameter used in HMAC signature before this plugin runs.

### Create a Consumer

You need to associate a credential to an existing [Consumer][consumer-object] object.
A Consumer can have many credentials.

{% navtabs %}
{% navtab With a Database %}
To create a Consumer, you can execute the following request:

```bash
curl -d "username=user123&custom_id=SOME_CUSTOM_ID" http://localhost:8001/consumers/
```
{% endnavtab %}
{% navtab Without a Database %}
Your declarative configuration file will need to have one or more Consumers. You can create them
on the `consumers:` yaml section:

``` yaml
consumers:
- username: user123
  custom_id: SOME_CUSTOM_ID
```
{% endnavtab %}
{% endnavtabs %}

In both cases, the parameters are as described below:

parameter                       | description
---                             | ---
`username`<br>*semi-optional*   | The username of the consumer. Either this field or `custom_id` must be specified.
`custom_id`<br>*semi-optional*  | A custom identifier used to map the consumer to another database. Either this field or `username` must be specified.

### Create a Credential

{% navtabs %}
{% navtab With a database %}

You can provision new username/password credentials by making the following
HTTP request:

```bash
curl -X POST http://localhost:8001/consumers/{consumer}/hmac-auth \
  --data "username=bob" \
  --data "secret=secret456"
```
{% endnavtab %}

{% navtab Without a database %}

You can add credentials on your declarative config file on the `hmacauth_credentials` yaml entry:

```yaml
hmacauth_credentials:
- consumer: {consumer}
  username: bob
  secret: secret456
```
{% endnavtab %}
{% endnavtabs %}

In both cases, the fields/parameters work as follows:

field/parameter            | description
---                        | ---
`{consumer}`               | The `id` or `username` property of the [Consumer][consumer-object] entity to associate the credentials to.
`username`                 | The username to use in the HMAC Signature verification.
`secret`<br>*optional*     | The secret to use in the HMAC Signature verification. Note that if this parameter isn't provided, Kong will generate a value for you and send it as part of the response body.

### Signature Authentication Scheme

The client is expected to send an `Authorization` or `Proxy-Authorization` header
with the following:

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

To generate the string that is signed with a key, the client
MUST take the values of each HTTP header specified by `headers` in
the order they appear.

1. If the header name is not `request-line` or `@request-target`,
  append the lowercase header name followed with an ASCII colon `:` and an
  ASCII space ` `.

2. If the header name is `request-line`, append the HTTP
  request line (in ASCII format).

3. If the header name is `@request-target`, append the lowercase request method,
 followed by a ASCII space ` ` and the request URI including any query strings;
 otherwise append the header value.

3. If value is not the last value then append an ASCII newline `\n`.
  The string MUST NOT include a trailing ASCII newline.

{:.note}
  > **Note:** The `@request-target` pseudo header was added in the 2.5.0
  version of the plugin release. It is similar to the `request-line` pseudo header
  except that the HTTP version was removed from the signature calculation. Otherwise,
  semantically equivalent requests that uses HTTP/1.x and HTTP/2 will generate different
  signature value. It is strongly recommended to use `@request-target`
  instead of `request-line` with releases of this plugin after 2.5.0.

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
body. If it's enabled the plugin will calculate the `SHA-256` HMAC digest of
the request body and match it against the value of the `Digest` header. The
Digest header needs to be in following format:

```
Digest: SHA-256=base64(sha256(<body>))
```

If there is no request body, the `Digest` should be set to the digest of a
body of 0 length.

Note: In order to create the digest of a request body, the plugin needs to
retain it in memory, which might cause pressure on the worker's Lua VM when
dealing with large bodies (several MB) or during high request concurrency.

### Enforcing Headers

`config.enforce_headers` can be used to enforce any of the headers to be part
of the signature creation. By default, the plugin doesn't enforce which header
needs to be used for the signature creation. The minimum recommended data to
sign is the `@request-target`, `host`, and `date`. A strong signature would
include all of the headers and a `digest` of the body.

### HMAC Example

The HMAC plugin can be enabled on a service or a route. This example uses a service.

1. Enable the plugin on a service:

    ```bash
    curl -i -X POST http://localhost:8001/services/example-service/plugins \
        -d "name=hmac-auth" \
        -d "config.enforce_headers=date, @request-target" \
        -d "config.algorithms=hmac-sha1, hmac-sha256"
    ```

    Response:
    ```
    HTTP/1.1 201 Created
    ...
    ```

2. Add a consumer:

    ```bash
    curl -i -X POST http://localhost:8001/consumers/ \
        -d "username=alice"
    ```

    Response:
    ```
    HTTP/1.1 201 Created
    ...
    ```

3. Add credential for the consumer:

    ```bash
    curl -i -X POST http://localhost:8001/consumers/alice/hmac-auth \
        -d "username=alice123" \
        -d "secret=secret"
    ```

    Response:
    ```
    HTTP/1.1 201 Created
    ...
    ```

4. Make an authorized request:

    ```bash
    curl -i -X GET http://localhost:8000/requests \
        -H "Host: hmac.com" \
        -H "Date: Thu, 22 Jun 2017 17:15:21 GMT" \
        -H 'Authorization: hmac username="alice123", algorithm="hmac-sha256", headers="date @request-target", signature="ujWCGHeec9Xd6UD2zlyxiNMCiXnDOWeVFMu5VeRUxtw="'
    ```

    Response:
    ```
    HTTP/1.1 200 OK
    ...
    ```

    In the above request, we are composing the signing string using the `date` and
    `@request-target` headers and creating the digest using the `hmac-sha256` to
    hash the digest:

    ```
    signing_string="date: Thu, 22 Jun 2017 17:15:21 GMT\nget /requests"
    digest=HMAC-SHA256(<signing_string>, "secret")
    base64_digest=base64(<digest>)
    ```

    So the final value of the `Authorization` header would look like:

    ```
    Authorization: hmac username="alice123", algorithm="hmac-sha256", headers="date @request-target", signature=<base64_digest>"
    ```

5. Validate the request body.

    To enable body validation we would need to set `config.validate_request_body`
    to `true`.

    The following example works the same way, whether the plugin was added to
    a service or a route.

    ```bash
    curl -i -X PATCH http://localhost:8001/plugins/{plugin-id} \
      -d "config.validate_request_body=true"
    ```
    Response:
    ```
    HTTP/1.1 200 OK
    ...
    ```

6. Now if the client includes the body digest in the request as the value of the
`Digest` header, the plugin will validate the request body by calculating the
`SHA-256` of the body and matching it against the `Digest` header's value.

    ```bash
    curl -i -X GET http://localhost:8000/requests \
        -H "Host: hmac.com" \
        -H "Date: Thu, 22 Jun 2017 21:12:36 GMT" \
        -H "Digest: SHA-256=SBH7QEtqnYUpEcIhDbmStNd1MxtHg2+feBfWc1105MA=" \
        -H 'Authorization: hmac username="alice123", algorithm="hmac-sha256", headers="date @request-target digest", signature="gaweQbATuaGmLrUr3HE0DzU1keWGCt3H96M28sSHTG8="' \
        -d "A small body"
    ```

    Response:
    ```
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

{% include_cached /md/plugins-hub/upstream-headers.md %}

### Paginate through the HMAC credentials

Paginate through the `hmac-auth` Credentials for all Consumers using the
following request:

```bash
curl -X GET http://localhost:8001/hmac-auths
```

Example output:
```json
{
    "total": 3,
    "data": [
        {
            "created_at": 1509681246000,
            "id": "75695322-e8a0-4109-aed4-5416b0308d85",
            "secret": "wQazJ304DW5huJklHgUfjfiSyCyTAEDZ",
            "username": "foo",
            "consumer": { "id": "c0d92ba9-8306-482a-b60d-0cfdd2f0e880" }
        },
        {
            "created_at": 1509419793000,
            "id": "11d5cbfb-31b9-4a6d-8496-2f4a76500643",
            "secret": "zi6YHyvLaUCe21XMXKesTYiHSWy6m6CW",
            "username": "bar",
            "consumer": { "id": "3c2c8fc1-7245-4fbb-b48b-e5947e1ce941" }
        },
        {
            "created_at": 1509681215000,
            "id": "eb0365bc-88ae-4568-be7c-db1eb7c16e5e",
            "secret": "NvHDTg5mp0ySFVJsITurtgyhEq1Cxbnv",
            "username": "baz",
            "consumer": { "id": "c0d92ba9-8306-482a-b60d-0cfdd2f0e880" }
        }
    ]
}
```

You can filter the list by consumer by using this other path:

```bash
curl -X GET http://localhost:8001/consumers/{username or id}/hmac-auth
```

Example output:
```json
{
    "total": 1,
    "data": [
        {
            "created_at": 1509419793000,
            "id": "11d5cbfb-31b9-4a6d-8496-2f4a76500643",
            "secret": "zi6YHyvLaUCe21XMXKesTYiHSWy6m6CW",
            "username": "bar",
            "consumer": { "id": "3c2c8fc1-7245-4fbb-b48b-e5947e1ce941" }
        }
    ]
}
```

`username or id`: The username or id of the consumer whose credentials need to be listed

### Retrieve the Consumer associated with a Credential

It is possible to retrieve a [Consumer][consumer-object] associated with an
HMAC Credential using the following request:

```bash
curl -X GET http://localhost:8001/hmac-auths/{hmac username or id}/consumer
```

Example output:
```json
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

[consumer-object]: /gateway/api/admin-ee/latest/#/operations/list-consumer
[clock-skew]: https://tools.ietf.org/html/draft-cavage-http-signatures-00#section-3.4

---

