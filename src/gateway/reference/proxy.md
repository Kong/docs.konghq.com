---
title: Proxy Reference
---

In this document we will cover Kong's **proxying capabilities**  by explaining
its routing capabilities and internal workings in details.

Kong exposes several interfaces which can be tweaked by the following configuration
properties:

- `proxy_listen`, which defines a list of addresses/ports on which Kong will
  accept **public HTTP (gRPC, WebSocket, etc) traffic** from clients and proxy
  it to your upstream services (`8000` by default).
- `admin_listen`, which also defines a list of addresses and ports, but those
  should be restricted to only be accessed by administrators, as they expose
  Kong's configuration capabilities: the **Admin API** (`8001` by default).
{% include_cached /md/admin-listen.md desc='short' %}
- `stream_listen`, which is similar to `proxy_listen` but for Layer 4 (TCP, TLS)
  generic proxy. This is turned off by default.

## Terminology

- `client`: Refers to the *downstream* client making requests to Kong's
  proxy port.
- `upstream service`: Refers to your own API/service sitting behind Kong, to
  which client requests/connections are forwarded.
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

## Overview

From a high-level perspective, Kong listens for HTTP traffic on its configured
proxy port(s) (`8000` and `8443` by default) and L4 traffic on explicitly configured
`stream_listen` ports. Kong will evaluate any incoming
HTTP request or L4 connection against the Routes you have configured and try to find a matching
one. If a given request matches the rules of a specific Route, Kong will
process proxying the request.

Because each Route may be linked to a Service, Kong will run the plugins you
have configured on your Route and its associated Service, and then proxy the
request upstream. You can manage Routes via Kong's Admin API. Routes have
special attributes that are used for routing - matching incoming HTTP requests.
Routing attributes differ by subsystem (HTTP/HTTPS, gRPC/gRPCS, and TCP/TLS).

Subsystems and routing attributes:
- `http`: `methods`, `hosts`, `headers`, `paths` (and `snis`, if `https`)
- `tcp`: `sources`, `destinations` (and `snis`, if `tls`)
- `grpc`: `hosts`, `headers`, `paths` (and `snis`, if `grpcs`)

If one attempts to configure a Route with a routing attribute it doesn't support
(e.g., an `http` route with `sources` or `destinations` fields), an error message
will be reported:

```
HTTP/1.1 400 Bad Request
Content-Type: application/json
Server: kong/<x.x.x>

{
    "code": 2,
    "fields": {
        "sources": "cannot set 'sources' when 'protocols' is 'http' or 'https'"
    },
    "message": "schema violation (sources: cannot set 'sources' when 'protocols' is 'http' or 'https')",
    "name": "schema violation"
}
```

If Kong receives a request that it cannot match against any of the configured
Routes (or if no Routes are configured), it will respond with:

```http
HTTP/1.1 404 Not Found
Content-Type: application/json
Server: kong/<x.x.x>

{
    "message": "no route and no Service found with those values"
}
```

## How to configure a Service

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

**Note:** The `url` argument is a shorthand argument to populate the
`protocol`, `host`, `port`, and `path` attributes at once.

Now, in order to send traffic to this Service through Kong, we need to specify
a Route, which acts as an entry point to Kong:

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

## Routes and matching capabilities

Let's now discuss how Kong matches a request against the configured routing
attributes.

Kong supports native proxying of HTTP/HTTPS, TCL/TLS, and GRPC/GRPCS protocols;
as mentioned earlier, each of these protocols accept a different set of routing
attributes:
- `http`: `methods`, `hosts`, `headers`, `paths` (and `snis`, if `https`)
- `tcp`: `sources`, `destinations` (and `snis`, if `tls`)
- `grpc`: `hosts`, `headers`, `paths` (and `snis`, if `grpcs`)

Note that all of these fields are **optional**, but at least **one of them**
must be specified.

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

Now that we understand how the routing properties work together, let's explore
each property individually.

### Request header

Kong supports routing by arbitrary HTTP headers. A special case of this
feature is routing by the Host header.

Routing a request based on its Host header is the most straightforward way to
proxy traffic through Kong, especially since this is the intended usage of the
HTTP Host header. Kong makes it easy to do via the `hosts` field of the Route
entity.

`hosts` accepts multiple values, which must be comma-separated when specifying
them via the Admin API, and is represented in a JSON payload:

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

Similarly, any other header can be used for routing:

```
$ curl -i -X POST http://localhost:8001/routes/ \
    -d 'headers.region=north'
HTTP/1.1 201 Created
```

Incoming requests containing a `Region` header set to `North` will be routed to
said Route.

```
Region: North
```

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

### Additional request headers

It's possible to route requests by other headers besides `Host`.

To do this, use the `headers` property in your Route:

```json
{
    "headers": { "version": ["v1", "v2"] },
    "service": {
        "id": "..."
    }
}
```

Given a request with a header such as:

```http
GET / HTTP/1.1
version: v1
```

This request will be routed through to the Service. The same will happen with this one:

```http
GET / HTTP/1.1
version: v2
```

But this request will not be routed to the Service:

```http
GET / HTTP/1.1
version: v3
```

**Note**: The `headers` keys are a logical `AND` and their values a logical `OR`.

### Request path

Another way for a Route to be matched is via request paths. To satisfy this
routing condition, a client request's normalized path **must** be prefixed with one of the
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

For each of these requests, Kong detects that their normalized URL path is prefixed with
one of the Routes's `paths` values. By default, Kong would then proxy the
request upstream without changing the URL path.

When proxying with path prefixes, **the longest paths get evaluated first**.
This allow you to define two Routes with two paths: `/service` and
`/service/resource`, and ensure that the former does not "shadow" the latter.

#### Using Regex in paths

Kong supports regular expression pattern matching for an Route's `paths` field
via [PCRE](http://pcre.org/) (Perl Compatible Regular Expression). You can
assign paths as both prefixes and Regex to a Route at the same time.

For a path to be considered as Regex, it must fall **outside** of the following regex:

```
^[a-zA-Z0-9\.\-_~/%]*$
```

In other words, if a path contains any character that is **not** alphanumerical, dot (`.`),
dash (`-`), underscore (`_`), tilde (`~`), forward-slash (`/`), or percent (`%`), then
it will be considered a Regex path. This determination is done on a per-path basis
and it is allowed to mix plain text and regex paths inside the same `paths` array of the same
Route object.

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

The provided Regex are evaluated with the `a` PCRE flag (`PCRE_ANCHORED`),
meaning that they will be constrained to match at the first matching point
in the path (the root `/` character).

**Note**: Regex matching is in general very fast, but it is possible to
construct expressions that take a very long time to determine that they don't
actually match.  This happens when the expression results in a "backtrace
exponential explosion", which means that there's an astronomical number of
tests to be performed before it's conclusive that they're all negative.
If undetected, this could take hours to finish with a single regular expression.
The [PCRE](http://pcre.org/) engine automatically detects most types of this
and replaces with more direct approaches, but there are more complex expressions
that could result in this scenario.

To limit the worst-case scenario, Kong applies the OpenResty
[`lua_regex_match_limit`](https://github.com/openresty/lua-nginx-module#lua_regex_match_limit)
to ensure that any regex operation terminates in around two seconds in the
worst case.  Apart from that, a smaller limit is applied to some "critical"
regex operations, like those for path selection, in order to terminate them
within two milliseconds, at most.

##### Evaluation order

As previously mentioned, Kong evaluates prefix paths by length, the longest
prefix paths are evaluated first. However, Kong will evaluate Regex paths based
on the `regex_priority` attribute of Routes from highest priority to lowest.
Regex paths are furthermore evaluated before prefix paths.

Consider the following Routes:

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

1. `/version/\d+/status/\d+`
2. `/status/\d+`
3. `/version/any/`
4. `/version`

Take care to avoid writing Regex rules that are overly broad and may consume
traffic intended for a prefix rule. Adding a rule with the path `/version/.*` to
the ruleset above would likely consume some traffic intended for the `/version`
prefix path. If you see unexpected behavior, sending `Kong-Debug: 1` in your
request headers will indicate the matched Route ID in the response headers for
troubleshooting purposes.

As usual, a request must still match a Route's `hosts` and `methods` properties
as well, and Kong will traverse your Routes until it finds one that [matches
the most rules](#matching-priorities).

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
matched (considering other routing attributes), the extracted capturing groups
will be available from the plugins in the `ngx.ctx` variable:

```lua
local router_matches = ngx.ctx.router_matches

-- router_matches.uri_captures is:
-- { "1", "john", version = "1", user = "john" }
```

##### Escaping special characters

Next, it is worth noting that characters found in Regex are often
reserved characters according to
[RFC 3986](https://tools.ietf.org/html/rfc3986) and as such,
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

The same way, if a Regex path is defined on a Route that has `strip_path`
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

The following HTTP request matching the provided Regex path:

```http
GET /version/1/service/path/to/resource HTTP/1.1
Host: ...
```

Will be proxied upstream by Kong as:

```http
GET /path/to/resource HTTP/1.1
Host: ...
```

#### Normalization behavior

To prevent trivial Route match bypass, the incoming request URI from client
is always normalized according to [RFC 3986](https://tools.ietf.org/html/rfc3986)
before router matching occurs. Specifically, the following normalization techniques are
used for incoming request URIs, which are selected because they generally do not change
semantics of the request URI:

1. Percent-encoded triplets are converted to uppercase.  For example: `/foo%3a` becomes `/foo%3A`.
2. Percent-encoded triplets of unreserved characters are decoded. For example: `/fo%6F` becomes `/foo`.
3. Dot segments are removed as necessary.  For example: `/foo/./bar/../baz` becomes `/foo/baz`.
4. Duplicate slashes are merged. For example: `/foo//bar` becomes `/foo/bar`.

The `paths` attribute of the Route object are also normalized. It is achieved by first determining
if the path is a plain text or regex path. Based on the result, different normalization techniques
are used.

For plain text Route path:

Same normalization technique as above is used, that is, methods 1 through 4.

For regex Route path:

Only methods 1 and 2 are used. In addition, if the decoded character becomes a regex
meta character, it will be escaped with backslash.

Kong normalizes any incoming request URI before performing router
matches. As a result, any request URI sent over to the upstream services will also
be in normalized form that preserves the original URI semantics.

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

### Request source

<div class="alert alert-warning">
    **Note:** This section only applies to TCP and TLS routes.
</div>

The `sources` routing attribute allows
matching a route by a list of incoming connection IP and/or port sources.

The following Route allows routing via a list of source IP/ports:

```json
{
    "protocols": ["tcp", "tls"],
    "sources": [{"ip":"10.1.0.0/16", "port":1234}, {"ip":"10.2.2.2"}, {"port":9123}],
    "id": "...",
}
```

TCP or TLS connections originating from IPs in CIDR range "10.1.0.0/16" or IP
address "10.2.2.2" or Port "9123" would match such Route.

### Request destination

<div class="alert alert-warning">
    **Note:** This section only applies to TCP and TLS routes.
</div>

The `destinations` attribute, similarly to `sources`,
allows matching a route by a list of incoming connection IP and/or port, but
uses the destination of the TCP/TLS connection as routing attribute.

### Request SNI

When using secure protocols (`https`, `grpcs`, or `tls`), a [Server
Name Indication][SNI] can be used as a routing attribute. The following Route
allows routing via SNIs:

```json
{
  "snis": ["foo.test", "example.com"],
  "id": "..."
}
```

Incoming requests with a matching hostname set in the TLS connection's SNI
extension would be routed to this Route. As mentioned, SNI routing applies not
only to TLS, but also to other protocols carried over TLS - such as HTTPS and
If multiple SNIs are specified in the Route, any of them can match with the incoming request's SNI.
with the incoming request (OR relationship between the names).

The SNI is indicated at TLS handshake time and cannot be modified after the TLS connection has
been established. This means, for example, that multiple requests reusing the same keepalive connection
will have the same SNI hostname while performing router match, regardless of the `Host` header.
has been established. This means keepalive connections that send multiple requests
will have the same SNI hostnames while performing router match
(regardless of the `Host` header).

Please note that creating a route with mismatched SNI and `Host` header matcher
is possible, but generally discouraged.

## Matching priorities

A Route may define matching rules based on its `headers`, `hosts`, `paths`, and
`methods` (plus `snis` for secure routes - `"https"`, `"grpcs"`, `"tls"`)
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

If the rule count for the given request is the same in two Routes `A` and
`B`, then the following tiebreaker rules will be applied in the order they
are listed. Route `A` will be selected over `B` if:

* `A` has only "plain" Host headers and `B` has one or more "wildcard"
  host headers
* `A` has more non-Host headers than `B`.
* `A` has at least one "regex" paths and `B` has only "plain" paths.
* `A`'s longest path is longer than `B`'s longest path.
* `A.created_at < B.created_at`

## Proxying behavior

The proxying rules above detail how Kong forwards incoming requests to your
upstream services. Below, we detail what happens internally between the time
Kong *matches* an HTTP request with a registered Route, and the actual
*forwarding* of the request.

### 1. Load balancing

Kong implements load balancing capabilities to distribute proxied
requests across a pool of instances of an upstream service.

You can find more information about configuring load balancing by consulting
the [Load Balancing Reference][load-balancing-reference].

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

### 3. Proxying and upstream timeouts

Once Kong has executed all the necessary logic (including plugins), it is ready
to forward the request to your upstream service. This is done via Nginx's
[ngx_http_proxy_module][ngx-http-proxy-module]. You can configure the desired
timeouts for the connection between Kong and a given upstream, via the following
properties of a Service:

- `connect_timeout`: defines in milliseconds the timeout for
  establishing a connection to your upstream service. Defaults to `60000`.
- `write_timeout`: defines in milliseconds a timeout between two
  successive write operations for transmitting a request to your upstream
  service.  Defaults to `60000`.
- `read_timeout`: defines in milliseconds a timeout between two
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
- `X-Forwarded-Prefix: <path>`, where `<path>` is the path of the request which
  was accepted by Kong. In the case where `$realip_remote_addr` is one of the
  **trusted** addresses, the request header with the same name gets forwarded
  if provided. Otherwise, the value of the `$request_uri` variable (with
  the query string stripped) provided by [ngx_http_core_module][ngx-server-port-variable]
  will be used.
  
  {:.note}
  > **Note**: Kong returns `"/"` for an empty path, but it doesn't do any other 
  > normalization on the request path.

All the other request headers are forwarded as-is by Kong.

One exception to this is made when using the WebSocket protocol. If so, Kong
will set the following headers to allow for upgrading the protocol between the
client and your upstream services:

- `Connection: Upgrade`
- `Upgrade: websocket`

More information on this topic is covered in the
[Proxy WebSocket traffic][proxy-websocket] section.

### 4. Errors and retries

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

## Configuring TLS for a Route

Kong provides a way to dynamically serve TLS certificates on a per-connection
basis. TLS certificates are directly handled by the core, and configurable via
the Admin API. Clients connecting to Kong over TLS must support the [Server
Name Indication][SNI] extension to make use of this feature.

TLS certificates are handled by two resources in the Kong Admin API:

- `/certificates`, which stores your keys and certificates.
- `/snis`, which associates a registered certificate with a Server Name
  Indication.

You can find the documentation for those two resources in the
[Admin API Reference][API].

Here is how to configure a TLS certificate on a given Route: first, upload
your TLS certificate and key via the Admin API:

```bash
$ curl -i -X POST http://localhost:8001/certificates \
    -F "cert=@/path/to/cert.pem" \
    -F "key=@/path/to/cert.key" \
    -F "snis=*.tls-example.com,other-tls-example.com"
HTTP/1.1 201 Created
...
```

The `snis` form parameter is a sugar parameter, directly inserting an SNI and
associating the uploaded certificate to it.

Note that one of the SNI names defined in `snis` above contains a wildcard
(`*.tls-example.com`). An SNI may contain a single wildcard in the leftmost (prefix) or
rightmost (suffix) postion. This can be useful when maintaining multiple subdomains. A
single `sni` configured with a wildcard name can be used to match multiple
subdomains, instead of creating an SNI for each.

Valid wildcard positions are `mydomain.*`, `*.mydomain.com`, and `*.www.mydomain.com`.

A default certificate can be added using the following parameters in Kong configuration:
1. [`ssl_cert`](/gateway/{{page.kong_version}}/reference/configuration/#ssl_cert)
2. [`ssl_cert_key`](/gateway/{{page.kong_version}}/reference/configuration/#ssl_cert_key)

Or, by dynamically configuring the default certificate with an SNI of `*`:

```bash
$ curl -i -X POST http://localhost:8001/certificates \
    -F "cert=@/path/to/default-cert.pem" \
    -F "key=@/path/to/default-cert.key" \
    -F "snis=*"
HTTP/1.1 201 Created
...
```

Matching of `snis` respects the following priority:

 1. Exact SNI matching certificate
 2. Search for a certificate by prefix wildcard
 3. Search for a certificate by suffix wildcard
 4. Search for a certificate associated with the SNI `*`
 5. The default certificate on the file system

You must now register the following Route within Kong. We will match requests
to this Route using only the Host header for convenience:

```bash
$ curl -i -X POST http://localhost:8001/routes \
    -d 'hosts=prefix.tls-example.com,other-tls-example.com' \
    -d 'service.id=d54da06c-d69f-4910-8896-915c63c270cd'
HTTP/1.1 201 Created
...
```

You can now expect the Route to be served over HTTPS by Kong:

```bash
$ curl -i https://localhost:8443/ \
  -H "Host: prefix.tls-example.com"
HTTP/1.1 200 OK
...
```

When establishing the connection and negotiating the TLS handshake, if your
client sends `prefix.tls-example.com` as part of the SNI extension, Kong will serve
the `cert.pem` certificate previously configured. This is the same for both HTTPS and
TLS connections.

### Restricting the client protocol

Routes have a `protocols` property to restrict the client protocol they should
listen for. This attribute accepts a set of values, which can be `"http"`,
`"https"`, `"grpc"`, `"grpcs"`, `"tcp"`, or `"tls"`.

A Route with `http` and `https` will accept traffic in both protocols.

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

Not specifying any protocol has the same effect, since routes default to
`["http", "https"]`.

However, a Route with *only* `https` would _only_ accept traffic over HTTPS. It
would _also_ accept unencrypted traffic _if_ TLS termination previously
occurred from a trusted IP. TLS termination is considered valid when the
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
plain-text without valid prior TLS termination, Kong responds with:

```http
HTTP/1.1 426 Upgrade Required
Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Connection: Upgrade
Upgrade: TLS/1.2, HTTP/1.1
Server: kong/x.y.z

{"message":"Please use HTTPS protocol"}
```

It's possible to create routes for raw TCP (not necessarily HTTP)
connections by using `"tcp"` in the `protocols` attribute:

```json
{
    "hosts": ["..."],
    "paths": ["..."],
    "methods": ["..."],
    "protocols": ["tcp"],
    "service": {
        "id": "..."
    }
}
```

Similarly, we can create routes which accept raw TLS traffic (not necessarily HTTPS) with
the `"tls"` value:

```json
{
    "hosts": ["..."],
    "paths": ["..."],
    "methods": ["..."],
    "protocols": ["tls"],
    "service": {
        "id": "..."
    }
}
```

A Route with *only* `TLS` would _only_ accept traffic over TLS.

It is also possible to accept both TCP and TLS simultaneously:

```
{
    "hosts": ["..."],
    "paths": ["..."],
    "methods": ["..."],
    "protocols": ["tcp", "tls"],
    "service": {
        "id": "..."
    }
}

```

For L4 TLS proxy to work, it is necessary to create route that accepts
the `tls` `protocol`, as well as having the appropriate TLS certificate
uploaded and their `sni` attribute properly set to match incoming connection's
SNI. Please refer to the [Configuring TLS for a Route](#configuring-tls-for-a-route)
section above for instructions on setting this up.

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

If you want Kong to terminate TLS, you can accept `wss` only from the
client, but proxy to the upstream service over plain text, or `ws`.

## Proxy gRPC traffic

gRPC proxying is natively supported in Kong. In order
to manage gRPC services and proxy gRPC requests with Kong, create Services and
Routes for your gRPC Services (check out the [Configuring a gRPC Service guide][conf-grpc-service]).

Only observability and logging plugins are supported with
gRPC - plugins known to be supported with gRPC have "grpc" and "grpcs" listed
under the supported protocols field in their Kong Hub page - for example,
check out the [File Log][file-log] plugin's page.

## Proxy TCP/TLS traffic

TCP and TLS proxying is natively supported in Kong.

In this mode, data of incoming connections reaching the `stream_listen` endpoints will
be passed through to the upstream. It is possible to terminate TLS connections
from clients using this mode as well.

To use this mode, aside from defining `stream_listen`, appropriate Route/Service
object with protocol types of `tcp` or `tls` should be created.

If TLS termination by Kong is desired, the following conditions must be met:

1. The Kong port where TLS connection connects to must have the `ssl` flag enabled
2. A certificate/key that can be used for TLS termination must be present inside Kong,
   as shown in [Configuring TLS for a Route](#configuring-tls-for-a-route)

Kong will use the connecting client's TLS SNI server name extension to find
the appropriate TLS certificate to use.

On the Service side, depends on whether connection between Kong and the upstream
service need to be encrypted, `tcp` or `tls` protocol types can be set accordingly.
This means all of the below setup are supported in this mode:

1. Client <- TLS -> Kong <- TLS -> Upstream
2. Client <- TLS -> Kong <- Cleartext -> Upstream
3. Client <- Cleartext -> Kong <- TLS -> Upstream

**Note:** In L4 proxy mode, only plugins that has `tcp` or `tls` in the supported
protocol list are supported. This list can be found in their respective documentation
on [Kong Hub](https://docs.konghq.com/hub/).

[Back to top](#introduction)

## Proxy TLS passthrough traffic

{{site.base_gateway}} supports proxying a TLS request without terminating or known
as SNI proxy.

{{site.base_gateway}} uses the connecting 
client's TLS SNI extension to find the matching Route and Service and forward the
complete TLS request upstream, without decrypting the incoming TLS traffic.

In this mode, you need to:
* Create a Route object with the protocol `tls_passthrough`, and the 
`snis` field set to one or more SNIs.
* Set the corresponding Service object's protocol to `tcp`. 
* Send requests to a port that has the `ssl` flag in its `stream_listen` 
directive.

Separate SNI and Certificate entities aren't required and won't be used.

Routes are not allowed to match `tls` and `tls_passthrough` protocols at same time. 
However, the same SNI is allowed to match `tls` and `tls_passthrough` in different 
Routes. 

It's also possible to set Route to `tls_passthrough` and Service to `tls`. In this 
mode, the connection to the upstream will be TLS-encrypted twice.

{:.note}
> **Note:**  To run any plugins in this mode, the plugin's `protocols` field must
include `tls_passthrough`.

[Back to top](#introduction)

## Conclusion

Through this guide, we hope you gained knowledge of the underlying proxying
mechanism of Kong, from how does a request match a Route to be routed to its
associated Service, on to how to allow for using the WebSocket protocol or
setup dynamic TLS certificates.

This website is open-source and can be found at
[github.com/Kong/docs.konghq.com](https://github.com/Kong/docs.konghq.com/).
Feel free to provide feedback to this document there, or propose improvements!

If you haven't already, we suggest that you also read the [Load balancing
Reference][load-balancing-reference], as it closely relates to the topic we
just covered.

[plugin-configuration-object]: /gateway/{{page.kong_version}}/admin-api#plugin-object
[plugin-development-guide]: /gateway/{{page.kong_version}}/plugin-development
[plugin-association-rules]: /gateway/{{page.kong_version}}/admin-api/#precedence
[proxy-websocket]: /gateway/{{page.kong_version}}/reference/proxy/#proxy-websocket-traffic
[load-balancing-reference]: /gateway/{{page.kong_version}}/reference/loadbalancing
[configuration-reference]: /gateway/{{page.kong_version}}/reference/configuration/
[configuration-trusted-ips]: /gateway/{{page.kong_version}}/reference/configuration/#trusted_ips
[configuring-a-service]: /gateway/{{page.kong_version}}/get-started/quickstart/configuring-a-service
[API]: /gateway/{{page.kong_version}}/admin-api
[service-entity]: /gateway/{{page.kong_version}}/admin-api/#add-service
[route-entity]: /gateway/{{page.kong_version}}/admin-api/#add-route

[ngx-http-proxy-module]: http://nginx.org/en/docs/http/ngx_http_proxy_module.html
[ngx-http-realip-module]: http://nginx.org/en/docs/http/ngx_http_realip_module.html
[ngx-remote-addr-variable]: http://nginx.org/en/docs/http/ngx_http_core_module.html#var_remote_addr
[ngx-scheme-variable]: http://nginx.org/en/docs/http/ngx_http_core_module.html#var_scheme
[ngx-host-variable]: http://nginx.org/en/docs/http/ngx_http_core_module.html#var_host
[ngx-server-port-variable]: http://nginx.org/en/docs/http/ngx_http_core_module.html#var_server_port
[ngx-http-proxy-retries]: http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_next_upstream_tries
[SNI]: https://en.wikipedia.org/wiki/Server_Name_Indication
[conf-grpc-service]: /gateway/{{page.kong_version}}/get-started/quickstart/configuring-a-grpc-service
[file-log]: /hub/kong-inc/file-log
