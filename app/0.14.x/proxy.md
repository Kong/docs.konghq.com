---
title: Proxy Reference
---

## Introduction

In this document we will cover Kong's **proxying capabilities**  by explaining
its routing capabilities and internal workings in details.

Kong exposes several interfaces which can be tweaked by two configuration
properties:

- `proxy_listen`, which defines a list of addresses/ports on which Kong will
  accept **public traffic** from clients and proxy it to your upstream services
  (`8000` by default).
- `admin_listen`, which also defines a list of addresses and ports, but those
  should be restricted to only be accessed by administrators, as they expose
  Kong's configuration capabilities: the **Admin API** (`8001` by default).

<div class="alert alert-warning">
<p><strong>Note:</strong> Starting with 0.13.0, the API entity was
deprecated. This document will cover proxying with the new Routes and
Services entities.</p>
<p>See an older version of this document if you are using 0.12 or
below.</p>
</div>

## Terminology

- `client`: Refers to the *downstream* client making requests to Kong's
  proxy port.
- `upstream service`: Refers to your own API/service sitting behind Kong, to
  which client requests are forwarded.
- `Service`: Service entities, as the name implies, are abstractions of each of
  your own upstream services. Examples of Services would be a data
  transformation microservice, a billing API, etc.
- `Route`: This refers to the Kong Routes entity. Routes are entrypoints into
  Kong, and defining rules for a request to be matched, and routed to a given
  Service.
- `Plugin`: This refers to Kong "plugins", which are pieces of business logic
  that run in the proxying lifecycle. Plugins can be configured through the
  Admin API - either globally (all incoming traffic) or on specific Routes
  and Services.

[Back to TOC](#table-of-contents)

## Overview

From a high-level perspective, Kong listens for HTTP traffic on its configured
proxy port(s) (`8000` and `8443` by default). Kong will evaluate any incoming
HTTP request against the Routes you have configured and try to find a matching
one. If a given request matches the rules of a specific Route, Kong will
process proxying the request. Because each Route is linked to a Service, Kong
will run the plugins you have configured on your Route and its associated
Service, and then proxy the request upstream.

You can manage Routes via Kong's Admin API. The `hosts`, `paths`, and `methods`
attributes of Routes define rules for matching incoming HTTP requests.

If Kong receives a request that it cannot match against any of the configured
Routes (or if no Routes are configured), it will respond with:

```http
HTTP/1.1 404 Not Found
Content-Type: application/json
Server: kong/<x.x.x>

{
    "message": "no route and no API found with those values"
}
```

**Note**: this message mentions "APIs" since for backwards-compatibility
reasons, Kong 0.13 still supports the API entity (and tries to match a request
against any configured API if no Route was matched first).

[Back to TOC](#table-of-contents)

## Reminder: How to configure a Service

The [Configuring a Service][configuring-a-service] quickstart guide explains
how Kong is configured via the [Admin API][API].

Adding a Service to Kong is done by sending an HTTP request to the Admin API:

```bash
$ curl -i -X POST http://localhost:8001/services/ \
    -d 'name=foo-service' \
    -d 'url=http://foo-service.com'
HTTP/1.1 201 Created
...

{
    "connect_timeout": 60000,
    "created_at": 1515537771,
    "host": "foo-service.com",
    "id": "d54da06c-d69f-4910-8896-915c63c270cd",
    "name": "foo-service",
    "path": "/",
    "port": 80,
    "protocol": "http",
    "read_timeout": 60000,
    "retries": 5,
    "updated_at": 1515537771,
    "write_timeout": 60000
}
```

This request instructs Kong to register a Service named "foo-service", which
points to `http://foo-service.com` (your upstream).

**Note:** the `url` argument is a shorthand argument to populate the
`protocol`, `host`, `port`, and `path` attributes at once.

Now, in order to send traffic to this Service through Kong, we need to specify
a Route, which acts as an entrypoint to Kong:

```bash
$ curl -i -X POST http://localhost:8001/routes/ \
    -d 'hosts[]=example.com' \
    -d 'paths[]=/foo' \
    -d 'service.id=d54da06c-d69f-4910-8896-915c63c270cd'
HTTP/1.1 201 Created
...

{
    "created_at": 1515539858,
    "hosts": [
        "example.com"
    ],
    "id": "ee794195-6783-4056-a5cc-a7e0fde88c81",
    "methods": null,
    "paths": [
        "/foo"
    ],
    "preserve_host": false,
    "priority": 0,
    "protocols": [
        "http",
        "https"
    ],
    "service": {
        "id": "d54da06c-d69f-4910-8896-915c63c270cd"
    },
    "strip_path": true,
    "updated_at": 1515539858
}
```

We have now configured a Route to match incoming requests matching the given
`hosts` and `paths`, and forward them to the `foo-service` we configured, thus
proxying this traffic to `http://foo-service.com`.

Kong is a transparent proxy, and it will by default forward the request to your
upstream service untouched, with the exception of various headers such as
`Connection`, `Date`, and others as required by the HTTP specifications.

[Back to TOC](#table-of-contents)

## Routes and matching capabilities

Let's now discuss how Kong matches a request against the configured `hosts`,
`paths` and `methods` properties (or fields) of a Route. Note that all three of
these fields are **optional**, but at least **one of them** must be specified.

For a request to match a Route:

- The request **must** include **all** of the configured fields
- The values of the fields in the request **must** match at least one of the
  configured values (While the field configurations accepts one or more values,
  a request needs only one of the values to be considered a match)

Let's go through a few examples. Consider a Route configured like this:

```json
{
    "hosts": ["example.com", "foo-service.com"],
    "paths": ["/foo", "/bar"],
    "methods": ["GET"]
}
```

Some of the possible requests matching this Route would look like:

```http
GET /foo HTTP/1.1
Host: example.com
```

```http
GET /bar HTTP/1.1
Host: foo-service.com
```

```http
GET /foo/hello/world HTTP/1.1
Host: example.com
```

All three of these requests satisfy all the conditions set in the Route
definition.

However, the following requests would **not** match the configured conditions:

```http
GET / HTTP/1.1
Host: example.com
```

```http
POST /foo HTTP/1.1
Host: example.com
```

```http
GET /foo HTTP/1.1
Host: foo.com
```

All three of these requests satisfy only two of configured conditions. The
first request's path is not a match for any of the configured `paths`, same for
the second request's HTTP method, and the third request's Host header.

Now that we understand how the `hosts`, `paths`, and `methods` properties work
together, let's explore each property individually.

[Back to TOC](#table-of-contents)

### Request Host header

Routing a request based on its Host header is the most straightforward way to
proxy traffic through Kong, especially since this is the intended usage of the
HTTP Host header. Kong makes it easy to do via the `hosts` field of the Route
entity.

`hosts` accepts multiple values, which must be comma-separated when specifying
them via the Admin API:

`hosts` accepts multiple values, which is straightforward to represent in a
JSON payload:

```bash
$ curl -i -X POST http://localhost:8001/routes/ \
    -H 'Content-Type: application/json' \
    -d '{"hosts":["example.com", "foo-service.com"]}'
HTTP/1.1 201 Created
...
```

But since the Admin API also supports form-urlencoded content types, you
can specify an array via the `[]` notation:

```bash
$ curl -i -X POST http://localhost:8001/routes/ \
    -d 'hosts[]=example.com' \
    -d 'hosts[]=foo-service.com'
HTTP/1.1 201 Created
...
```

To satisfy the `hosts` condition of this Route, any incoming request from a
client must now have its Host header set to one of:

```
Host: example.com
```

or:

```
Host: foo-service.com
```

[Back to TOC](#table-of-contents)

#### Using wildcard hostnames

To provide flexibility, Kong allows you to specify hostnames with wildcards in
the `hosts` field. Wildcard hostnames allow any matching Host header to satisfy
the condition, and thus match a given Route.

Wildcard hostnames **must** contain **only one** asterisk at the leftmost
**or** rightmost label of the domain. Examples:

- `*.example.com` would allow Host values such as `a.example.com` and
  `x.y.example.com` to match.
- `example.*` would allow Host values such as `example.com` and `example.org`
  to match.

A complete example would look like this:

```json
{
    "hosts": ["*.example.com", "service.com"]
}
```

Which would allow the following requests to match this Route:

```http
GET / HTTP/1.1
Host: an.example.com
```

```http
GET / HTTP/1.1
Host: service.com
```

[Back to TOC](#table-of-contents)

#### The `preserve_host` property

When proxying, Kong's default behavior is to set the upstream request's Host
header to the hostname specified in the Service's `host`. The
`preserve_host` field accepts a boolean flag instructing Kong not to do so.

For example, when the `preserve_host` property is not changed and a Route is
configured like so:

```json
{
    "hosts": ["service.com"],
    "service": {
        "id": "..."
    }
}
```

A possible request from a client to Kong could be:

```http
GET / HTTP/1.1
Host: service.com
```

Kong would extract the Host header value from the Service's `host` property, ,
and would send the following upstream request:

```http
GET / HTTP/1.1
Host: <my-service-host.com>
```

However, by explicitly configuring a Route with `preserve_host=true`:

```json
{
    "hosts": ["service.com"],
    "preserve_host": true,
    "service": {
        "id": "..."
    }
}
```

And assuming the same request from the client:

```http
GET / HTTP/1.1
Host: service.com
```

Kong would preserve the Host on the client request and would send the following
upstream request instead:

```http
GET / HTTP/1.1
Host: service.com
```

[Back to TOC](#table-of-contents)

### Request path

Another way for a Route to be matched is via request paths. To satisfy this
routing condition, a client request's path **must** be prefixed with one of the
values of the `paths` attribute.

For example, with a Route configured like so:

```json
{
    "paths": ["/service", "/hello/world"]
}
```

The following requests would be matched:

```http
GET /service HTTP/1.1
Host: example.com
```

```http
GET /service/resource?param=value HTTP/1.1
Host: example.com
```

```http
GET /hello/world/resource HTTP/1.1
Host: anything.com
```

For each of these requests, Kong detects that their URL path is prefixed with
one of the Routes's `paths` values. By default, Kong would then proxy the
request upstream without changing the URL path.

When proxying with path prefixes, **the longest paths get evaluated first**.
This allow you to define two Routes with two paths: `/service` and
`/service/resource`, and ensure that the former does not "shadow" the latter.

[Back to TOC](#table-of-contents)

#### Using regexes in paths

Kong supports regular expression pattern matching for an Route's `paths` field
via [PCRE](http://pcre.org/) (Perl Compatible Regular Expression). You can
assign paths as both prefixes and regexes to a Route at the same time.

For example, if we consider the following Route:

```json
{
    "paths": ["/users/\d+/profile", "/following"]
}
```

The following requests would be matched by this Route:

```http
GET /following HTTP/1.1
Host: ...
```

```http
GET /users/123/profile HTTP/1.1
Host: ...
```

The provided regexes are evaluated with the `a` PCRE flag (`PCRE_ANCHORED`),
meaning that they will be constrained to match at the first matching point
in the path (the root `/` character).

[Back to TOC](#table-of-contents)

##### Evaluation order

As previously mentioned, Kong evaluates prefix paths by length: the longest
prefix paths are evaluated first. However, Kong will evaluate regex paths based
on the `regex_priority` attribute of Routes from highest priority to lowest.
This means that considering the following Routes:

```json
[
    {
        "paths": ["/status/\d+"],
        "regex_priority": 0
    },
    {
        "paths": ["/version/\d+/status/\d+"],
        "regex_priority": 6
    },
    {
        "paths": ["/version"],
    },
    {
        "paths": ["/version/any/"],
    }
]
```

In this scenario, Kong will evaluate incoming requests against the following
defined URIs, in this order:

1. `/version/any/`
2. `/version
3. `/version/\d+/status/\d+`
4. `/status/\d+`

Prefix paths are always evaluated before regex paths.

As usual, a request must still match a Route's `hosts` and `methods` properties
as well, and Kong will traverse your Routes until it finds one that matches
the most rules (see [Routing priorities][proxy-routing-priorities]).

[Back to TOC](#table-of-contents)

##### Capturing groups

Capturing groups are also supported, and the matched group will be extracted
from the path and available for plugins consumption. If we consider the
following regex:

```
/version/(?<version>\d+)/users/(?<user>\S+)
```

And the following request path:

```
/version/1/users/john
```

Kong will consider the request path a match, and if the overall Route is
matched (considering the `hosts` and `methods` fields), the extracted capturing
groups will be available from the plugins in the `ngx.ctx` variable:

```lua
local router_matches = ngx.ctx.router_matches

-- router_matches.uri_captures is:
-- { "1", "john", version = "1", user = "john" }
```

[Back to TOC](#table-of-contents)

##### Escaping special characters

Next, it is worth noting that characters found in regexes are often
reserved characters according to
[RFC 3986](http://www.gbiv.com/protocols/uri/rfc/rfc3986.html) and as such,
should be percent-encoded. **When configuring Routes with regex paths via the
Admin API, be sure to URL encode your payload if necessary**. For example,
with `curl` and using an `application/x-www-form-urlencoded` MIME type:

```bash
$ curl -i -X POST http://localhost:8001/routes \
    --data-urlencode 'uris[]=/status/\d+'
HTTP/1.1 201 Created
...
```

Note that `curl` does not automatically URL encode your payload, and note the
usage of `--data-urlencode`, which prevents the `+` character to be URL decoded
and interpreted as a space ` ` by Kong's Admin API.

[Back to TOC](#table-of-contents)

#### The `strip_path` property

It may be desirable to specify a path prefix to match a Route, but not
include it in the upstream request. To do so, use the `strip_path` boolean
property by configuring a Route like so:

```json
{
    "paths": ["/service"],
    "strip_path": true,
    "service": {
        "id": "..."
    }
}
```

Enabling this flag instructs Kong that when matching this Route, and proceeding
with the proxying to a Service, it should **not** include the matched part of
the URL path in the upstream request's URL. For example, the following
client's request to the above Route:

```http
GET /service/path/to/resource HTTP/1.1
Host: ...
```

Will cause Kong to send the following upstream request:

```http
GET /path/to/resource HTTP/1.1
Host: ...
```

The same way, if a regex path is defined on a Route that has `strip_path`
enabled, the entirety of the request URL matching sequence will be stripped.
Example:

```json
{
    "paths": ["/version/\d+/service"],
    "strip_path": true,
    "service": {
        "id": "..."
    }
}
```

The following HTTP request matching the provided regex path:

```http
GET /version/1/service/path/to/resource HTTP/1.1
Host: ...
```

Will be proxied upstream by Kong as:

```http
GET /path/to/resource HTTP/1.1
Host: ...
```

[Back to TOC](#table-of-contents)

### Request HTTP method

The `methods` field allows matching the requests depending on their HTTP
method.  It accepts multiple values. Its default value is empty (the HTTP
method is not used for routing).

The following Route allows routing via `GET` and `HEAD`:

```json
{
    "methods": ["GET", "HEAD"],
    "service": {
        "id": "..."
    }
}
```

Such a Route would be matched with the following requests:

```http
GET / HTTP/1.1
Host: ...
```

```http
HEAD /resource HTTP/1.1
Host: ...
```

But it would not match a `POST` or `DELETE` request. This allows for much more
granularity when configuring plugins on Routes. For example, one could imagine
two Routes pointing to the same service: one with unlimited unauthenticated
`GET` requests, and a second one allowing only authenticated and rate-limited
`POST` requests (by applying the authentication and rate limiting plugins to
such requests).

[Back to TOC](#table-of-contents)

## Matching priorities

A Route may define matching rules based on its `hosts`, `paths`, and `methods`
fields. For Kong to match an incoming request to a Route, all existing fields
must be satisfied. However, Kong allows for quite some flexibility by allowing
two or more Routes to be configured with fields containing the same values -
when this occurs, Kong applies a priority rule.

The rule is: **when evaluating a request, Kong will first try to match the
Routes with the most rules**.

For example, if two Routes are configured like so:

```json
{
    "hosts": ["example.com"],
    "service": {
        "id": "..."
    }
},
{
    "hosts": ["example.com"],
    "methods": ["POST"],
    "service": {
        "id": "..."
    }
}
```

The second Route has a `hosts` field **and** a `methods` field, so it will be
evaluated first by Kong. By doing so, we avoid the first Route "shadowing"
calls intended for the second one.

Thus, this request will match the first Route

```http
GET / HTTP/1.1
Host: example.com
```

And this request will match the second one:

```http
POST / HTTP/1.1
Host: example.com
```

Following this logic, if a third Route was to be configured with a `hosts`
field, a `methods` field, and a `uris` field, it would be evaluated first by
Kong.

[Back to TOC](#table-of-contents)

## Proxying behavior

The proxying rules above detail how Kong forwards incoming requests to your
upstream services. Below, we detail what happens internally between the time
Kong *matches* an HTTP request with a registered Route, and the actual
*forwarding* of the request.

[Back to TOC](#table-of-contents)

### 1. Load balancing

Kong implements load balancing capabilities to distribute proxied
requests across a pool of instances of an upstream service.

You can find more information about configuring load balancing by consulting
the [Load Balancing Reference][load-balancing-reference].

[Back to TOC](#table-of-contents)

### 2. Plugins execution

Kong is extensible via "plugins" that hook themselves in the request/response
lifecycle of the proxied requests. Plugins can perform a variety of operations
in your environment and/or transformations on the proxied request.

Plugins can be configured to run globally (for all proxied traffic) or on
specific Routes and Services. In both cases, you must create a [plugin
configuration][plugin-configuration-object] via the Admin API.

Once a Route has been matched (and its associated Service entity), Kong will
run plugins associated to either of those entities. Plugins configured on a
Route run before plugins configured on a Service, but otherwise, the usual
rules of [plugins association][plugin-association-rules] apply.

These configured plugins will run their `access` phase, which you can find more
information about in the [Plugin development guide][plugin-development-guide].

[Back to TOC](#table-of-contents)

### 3. Proxying & upstream timeouts

Once Kong has executed all the necessary logic (including plugins), it is ready
to forward the request to your upstream service. This is done via Nginx's
[ngx_http_proxy_module][ngx-http-proxy-module]. You can configure the desired
timeouts for the connection between Kong and a given upstream, via the following
properties of a Service:

- `upstream_connect_timeout`: defines in milliseconds the timeout for
  establishing a connection to your upstream service. Defaults to `60000`.
- `upstream_send_timeout`: defines in milliseconds a timeout between two
  successive write operations for transmitting a request to your upstream
  service.  Defaults to `60000`.
- `upstream_read_timeout`: defines in milliseconds a timeout between two
  successive read operations for receiving a request from your upstream
  service.  Defaults to `60000`.

Kong will send the request over HTTP/1.1, and set the following headers:

- `Host: <your_upstream_host>`, as previously described in this document.
- `Connection: keep-alive`, to allow for reusing the upstream connections.
- `X-Real-IP: <remote_addr>`, where `$remote_addr` is the variable bearing
  the same name provided by
  [ngx_http_core_module][ngx-remote-addr-variable]. Please note that the
  `$remote_addr` is likely overridden by
  [ngx_http_realip_module][ngx-http-realip-module].
- `X-Forwarded-For: <address>`, where `<address>` is the content of
  `$realip_remote_addr` provided by
  [ngx_http_realip_module][ngx-http-realip-module] appended to the request
  header with the same name.
- `X-Forwarded-Proto: <protocol>`, where `<protocol>` is the protocol used by
  the client. In the case where `$realip_remote_addr` is one of the **trusted**
  addresses, the request header with the same name gets forwarded if provided.
  Otherwise, the value of the `$scheme` variable provided by
  [ngx_http_core_module][ngx-scheme-variable] will be used.
- `X-Forwarded-Host: <host>`, where `<host>` is the host name sent by
  the client. In the case where `$realip_remote_addr` is one of the **trusted**
  addresses, the request header with the same name gets forwarded if provided.
  Otherwise, the value of the `$host` variable provided by
  [ngx_http_core_module][ngx-host-variable] will be used.
- `X-Forwarded-Port: <port>`, where `<port>` is the port of the server which
  accepted a request. In the case where `$realip_remote_addr` is one of the
  **trusted** addresses, the request header with the same name gets forwarded
  if provided. Otherwise, the value of the `$server_port` variable provided by
  [ngx_http_core_module][ngx-server-port-variable] will be used.

All the other request headers are forwarded as-is by Kong.

One exception to this is made when using the WebSocket protocol. If so, Kong
will set the following headers to allow for upgrading the protocol between the
client and your upstream services:

- `Connection: Upgrade`
- `Upgrade: websocket`

More information on this topic is covered in the
[Proxy WebSocket traffic][proxy-websocket] section.

[Back to TOC](#table-of-contents)

### 4. Errors & retries

Whenever an error occurs during proxying, Kong will use the underlying
Nginx [retries][ngx-http-proxy-retries] mechanism to pass the request on to
the next upstream.

There are two configurable elements here:

1. The number of retries: this can be configured per Service using the
   `retries` property. See the [Admin API][API] for more details on this.

2. What exactly constitutes an error: here Kong uses the Nginx defaults, which
   means an error or timeout occurring while establishing a connection with the
   server, passing a request to it, or reading the response headers.

The second option is based on Nginx's
[proxy_next_upstream][proxy_next_upstream] directive. This option is not
directly configurable through Kong, but can be added using a custom Nginx
configuration. See the [configuration reference][configuration-reference] for
more details.

[Back to TOC](#table-of-contents)

### 5. Response

Kong receives the response from the upstream service and sends it back to the
downstream client in a streaming fashion. At this point Kong will execute
subsequent plugins added to the Route and/or Service that implement a hook in
the `header_filter` phase.

Once the `header_filter` phase of all registered plugins has been executed, the
following headers will be added by Kong and the full set of headers be sent to
the client:

- `Via: kong/x.x.x`, where `x.x.x` is the Kong version in use
- `X-Kong-Proxy-Latency: <latency>`, where `latency` is the time in milliseconds
  between Kong receiving the request from the client and sending the request to
  your upstream service.
- `X-Kong-Upstream-Latency: <latency>`, where `latency` is the time in
  milliseconds that Kong was waiting for the first byte of the upstream service
  response.

Once the headers are sent to the client, Kong will start executing
registered plugins for the Route and/or Service that implement the
`body_filter` hook. This hook may be called multiple times, due to the
streaming nature of Nginx. Each chunk of the upstream response that is
successfully processed by such `body_filter` hooks is sent back to the client.
You can find more information about the `body_filter` hook in the [Plugin
development guide][plugin-development-guide].

[Back to TOC](#table-of-contents)

## Configuring a fallback Route

As a practical use-case and example of the flexibility offered by Kong's
proxying capabilities, let's try to implement a "fallback Route", so that in
order to avoid Kong responding with an HTTP `404`, "no route found", we can
catch such requests and proxy them to a special upstream service, or apply a
plugin to it (such a plugin could, for example, terminate the request with a
different status code or response without proxying the request).

Here is an example of such a fallback Route:

```json
{
    "paths": ["/"],
    "service": {
        "id": "..."
    }
}
```

As you can guess, any HTTP request made to Kong would actually match this
Route, since all URIs are prefixed by the root character `/`. As we know from
the [Request path][proxy-request-path] section, the longest URL paths are
evaluated first by Kong, so the `/` path will eventually be evaluated last by
Kong, and effectively provide a "fallback" Route, only matched as a last
resort. You can then send traffic to a special Service or apply any plugin you
wish on this Route.

[Back to TOC](#table-of-contents)

## Configuring SSL for a Route

Kong provides a way to dynamically serve SSL certificates on a per-connection
basis. SSL certificates are directly handled by the core, and configurable via
the Admin API. Clients connecting to Kong over TLS must support the [Server
Name Indication][SNI] extension to make use of this feature.

SSL certificates are handled by two resources in the Kong Admin API:

- `/certificates`, which stores your keys and certificates.
- `/snis`, which associates a registered certificate with a Server Name
  Indication.

You can find the documentation for those two resources in the
[Admin API Reference][API].

Here is how to configure an SSL certificate on a given Route: first, upload
your SSL certificate and key via the Admin API:

```bash
$ curl -i -X POST http://localhost:8001/certificates \
    -F "cert=@/path/to/cert.pem" \
    -F "key=@/path/to/cert.key" \
    -F "snis=ssl-example.com,other-ssl-example.com"
HTTP/1.1 201 Created
...
```

The `snis` form parameter is a sugar parameter, directly inserting an SNI and
associating the uploaded certificate to it.

You must now register the following Route within Kong. We will match requests
to this Route using only the Host header for convenience:

```bash
$ curl -i -X POST http://localhost:8001/routes \
    -d 'hosts=ssl-example.com,other-ssl-example.com' \
    -d 'service.id=d54da06c-d69f-4910-8896-915c63c270cd'
HTTP/1.1 201 Created
...
```

You can now expect the Route to be served over HTTPS by Kong:

```bash
$ curl -i https://localhost:8443/ \
  -H "Host: ssl-example.com"
HTTP/1.1 200 OK
...
```

When establishing the connection and negotiating the SSL handshake, if your
client sends `ssl-example.com` as part of the SNI extension, Kong will serve
the `cert.pem` certificate previously configured.

[Back to TOC](#table-of-contents)

### Restricting the client protocol (HTTP/HTTPS)

Routes have a `protocols` property to restrict the client protocol they should
listen for. This attribute accepts a set of values, which can be `http` or
`https`.

A Route with `http` and `https` will accept traffic regardless of the protocol
the client is connecting with (plain-text or over TLS):

```json
{
    "hosts": ["..."],
    "paths": ["..."],
    "methods": ["..."],
    "protocols": ["http", "https"],
    "service": {
        "id": "..."
    }
}
```

Not specifying `https` has the same effect, a route would accept both
plain-text and TLS traffic:

```json
{
    "hosts": ["..."],
    "paths": ["..."],
    "methods": ["..."],
    "protocols": ["http"],
    "service": {
        "id": "..."
    }
}
```

However, a Route with only `https` would _only_ accept traffic over TLS. It
would _also_ accept unencrypted traffic _if_ SSL termination previously
occurred from a trusted IP. SSL termination is considered valid when the
request comes from one of the configured IPs in
[trusted_ips][configuration-trusted-ips] and if the `X-Forwarded-Proto: https`
header is set:

```json
{
    "hosts": ["..."],
    "paths": ["..."],
    "methods": ["..."],
    "protocols": ["https"],
    "service": {
        "id": "..."
    }
}
```

If a Route such as the above matches a request, but that request is in
plain-text without valid prior SSL termination, Kong responds with:

```http
HTTP/1.1 426 Upgrade Required
Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Connection: Upgrade
Upgrade: TLS/1.2, HTTP/1.1
Server: kong/x.y.z

{"message":"Please use HTTPS protocol"}
```

[Back to TOC](#table-of-contents)

## Proxy WebSocket traffic

Kong supports WebSocket traffic thanks to the underlying Nginx implementation.
When you wish to establish a WebSocket connection between a client and your
upstream services *through* Kong, you must establish a WebSocket handshake.
This is done via the HTTP Upgrade mechanism. This is what your client request
made to Kong would look like:

```http
GET / HTTP/1.1
Connection: Upgrade
Host: my-websocket-api.com
Upgrade: WebSocket
```

This will make Kong forward the `Connection` and `Upgrade` headers to your
upstream service, instead of dismissing them due to the hop-by-hop nature of a
standard HTTP proxy.

[Back to TOC](#table-of-contents)

### WebSocket and TLS

Kong will accept `ws` and `wss` connections on its respective `http` and
`https` ports. To enforce TLS connections from clients, set the `protocols`
property of the [Route][route-entity] to `https` only.

When setting up the [Service][service-entity] to point to your upstream
WebSocket service, you should carefully pick the protocol you want to use
between Kong and the upstream. If you want to use TLS (`wss`), then the
upstream WebSocket service must be defined using the `https` protocol in the
Service `protocol` property, and the proper port (usually 443). To connect
without TLS (`ws`), then the `http` protocol and port (usually 80) should be
used in `protocol` instead.

If you want Kong to terminate SSL/TLS, you can accept `wss` only from the
client, but proxy to the upstream service over plain text, or `ws`.

[Back to TOC](#table-of-contents)

## Conclusion

Through this guide, we hope you gained knowledge of the underlying proxying
mechanism of Kong, from how does a request match a Route to be routed to its
associated Service, on to how to allow for using the WebSocket protocol or
setup dynamic SSL certificates.

This website is Open-Source and can be found at
[github.com/Kong/docs.konghq.com](https://github.com/Kong/docs.konghq.com/).
Feel free to provide feedback to this document there, or propose improvements!

If you haven't already, we suggest that you also read the [Load balancing
Reference][load-balancing-reference], as it closely relates to the topic we
just covered.

[Back to TOC](#table-of-contents)

[plugin-configuration-object]: /{{page.kong_version}}/admin-api#plugin-object
[plugin-development-guide]: /{{page.kong_version}}/plugin-development
[plugin-association-rules]: /{{page.kong_version}}/admin-api/#precedence
[load-balancing-reference]: /{{page.kong_version}}/loadbalancing
[configuration-reference]: /{{page.kong_version}}/configuration-reference
[configuration-trusted-ips]: /{{page.kong_version}}/configuration/#trusted_ips
[configuring-a-service]: /{{page.kong_version}}/getting-started/configuring-a-service
[API]: /{{page.kong_version}}/admin-api
[service-entity]: /{{page.kong_version}}/admin-api/#add-service
[route-entity]: /{{page.kong_version}}/admin-api/#add-route

[ngx-http-proxy-module]: http://nginx.org/en/docs/http/ngx_http_proxy_module.html
[ngx-http-realip-module]: http://nginx.org/en/docs/http/ngx_http_realip_module.html
[ngx-remote-addr-variable]: http://nginx.org/en/docs/http/ngx_http_core_module.html#var_remote_addr
[ngx-scheme-variable]: http://nginx.org/en/docs/http/ngx_http_core_module.html#var_scheme
[ngx-host-variable]: http://nginx.org/en/docs/http/ngx_http_core_module.html#var_host
[ngx-server-port-variable]: http://nginx.org/en/docs/http/ngx_http_core_module.html#var_server_port
[ngx-http-proxy-retries]: http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_next_upstream_tries
[SNI]: https://en.wikipedia.org/wiki/Server_Name_Indication
