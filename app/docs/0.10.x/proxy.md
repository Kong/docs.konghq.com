---
title: Proxy Reference
---

# Proxy Reference

Kong listens for traffic on four ports, which by default are:

- `:8000` on which Kong listens for incoming HTTP traffic from your clients,
  and forwards it to your upstream services. **This is the port that interests
  us in this guide.**
- `:8443` on which Kong listens for incoming HTTPS traffic. This port has a
  similar behavior as the `:8000` port, except that it expects HTTPS traffic
  only. This port can be disabled via the configuration file.
- `:8001` on which the [Admin API][API] used to configure Kong listens.
- `:8444` on which the [Admin API][API] listens for HTTPS traffic.

In this document we cover routing capabilities of Kong by explaining in detail
how incoming requests on port `:8000` are proxied to a configured upstream
service depending on their headers, URI, and HTTP method.

### Table of Contents

- [Terminology][proxy-terminology]
- [Overview][proxy-overview]
- [Reminder: How to add an API to Kong][proxy-reminder]
- [Routing capabilities][proxy-routing-capabilities]
    - [Request Host header][proxy-request-host-header]
        - [Using wildcard hostnames][proxy-using-wildcard-hostnames]
        - [The `preserve_host` property][proxy-preserve-host-property]
    - [Request URI][proxy-request-uri]
        - [The `strip_uri` property][proxy-strip-uri-property]
    - [Request HTTP method][proxy-request-http-method]
- [Routing priorities][proxy-routing-priorities]
- [Proxying behavior][proxy-proxying-behavior]
    - [1. Load balancing][proxy-load-balancing]
    - [2. Plugins execution][proxy-plugins-execution]
    - [3. Proxying & upstream timeouts][proxy-proxying-upstream-timeouts]
    - [4. Response][proxy-response]
- [Configuring a fallback API][proxy-configuring-a-fallback-api]
- [Configuring SSL for an API][proxy-configuring-ssl-for-an-api]
    - [The `https_only` property][proxy-the-https-only-property]
    - [The `http_if_terminated` property][proxy-the-http-if-terminated-property]
- [Proxy WebSocket traffic][proxy-websocket]
- [Conclusion][proxy-conclusion]

[proxy-terminology]: #terminology
[proxy-overview]: #overview
[proxy-reminder]: #reminder-how-to-add-an-api-to-kong
[proxy-routing-capabilities]: #routing-capabilities
[proxy-request-host-header]: #request-host-header
[proxy-using-wildcard-hostnames]: #using-wildcard-hostnames
[proxy-preserve-host-property]: #the-preserve_host-property
[proxy-request-uri]: #request-uri
[proxy-strip-uri-property]: #the-strip_uri-property
[proxy-request-http-method]: #request-http-method
[proxy-routing-priorities]: #routing-priorities
[proxy-proxying-behavior]: #proxying-behavior
[proxy-load-balancing]: #1-load-balancing
[proxy-plugins-execution]: #2-plugins-execution
[proxy-proxying-upstream-timeouts]: #3-proxying-upstream-timeouts
[proxy-response]: #proxy-response
[proxy-configuring-a-fallback-api]: #configuring-a-fallback-api
[proxy-configuring-ssl-for-an-api]: #configuring-ssl-for-an-api
[proxy-the-https-only-property]: #the-https_only-property
[proxy-the-http-if-terminated-property]: #the-http_if_terminated-property
[proxy-websocket]: #proxy-websocket-traffic
[proxy-conclusion]: #conclusion

---

### Terminology

- `API`: This term refers to the API entity of Kong. You configure your APIs,
  that point to your own upstream services, through the Admin API.
- `Plugin`: This refers to Kong "plugins", which are pieces of business logic
  that run in the proxying lifecycle. Plugins can be configured through the
  Admin API - either globally (all incoming traffic) or on a per-API basis.
- `Client` or : Refers to the *downstream* client making requests to Kong's
  proxy port.
- `Upstream service`: Refers to your own API/service sitting behind Kong, to
  which client requests are forwarded.

[Back to TOC](#table-of-contents)

### Overview

From a high level perspective, Kong will listen for HTTP traffic on its
configured proxy port (`8000` by default), recognize which upstream service is
being requested, run the configured plugins for that API, and forward the HTTP
request upstream to your own API or service.

When a client makes a request to the proxy port, Kong will decide to which
upstream service or API to route (or forward) the incoming request, depending
on the API configuration in Kong, which is managed via the Admin API. You can
configure APIs with various properties, but the three relevant ones for routing
incoming traffic are `hosts`, `uris`, and `methods`.

If Kong cannot determine to which upstream API a given request should be
routed, Kong will respond with:

```http
HTTP/1.1 404 Not Found
Content-Type: application/json
Server: kong/<x.x.x>

{
    "message": "no API found with those values"
}
```

[Back to TOC](#table-of-contents)

### Reminder: How to add an API to Kong

The [Adding your API][adding-your-api] quickstart guide explains how Kong is
configured via Kong's [Admin API][API] running by default on port `8001`.
Adding an API to Kong is as easy as sending an HTTP request:

```bash
$ curl -i -X POST http://localhost:8001/apis/ \
    -d 'name=my-api' \
    -d 'upstream_url=http://my-api.com' \
    -d 'hosts=example.com' \
    -d 'uris=/my-api' \
    -d 'methods=GET,HEAD'
HTTP/1.1 201 Created
...
```

This request instructs Kong to register an API named "my-api", reachable at
"http://example.com". It also specifies various routing properties, though note
that **only one of** `hosts`, `uris` and `methods` is  required.

Adding such an API would mean that you configured Kong to proxy all incoming
requests matching the specified `hosts`, `uris`, and `methods` to
`http://example.com`. Kong is a transparent proxy, and it will forward the
request to your upstream service untouched, with the exception of the addition
of various headers such as `Connection`.

[Back to TOC](#table-of-contents)

### Routing capabilities

Let's now discuss how Kong matches a request to the configured `hosts`, `uris`
and `methods` properties (or fields) of your API. Note that all three of these
fields are **optional**, but at least **one of them** must be specified. For a
client request to match an API:

- The request **must** include **all** of the configured fields
- The values of the fields in the request **must** match at least one of the
  configured values (While the field configurations accepts one or more values,
  a request needs only one of the values to be considered a match)

Let's go through a few examples. Consider an API configured like this:

```json
{
    "name": "my-api",
    "upstream_url": "http://my-api.com",
    "hosts": ["example.com", "service.com"],
    "uris": ["/foo", "/bar"],
    "methods": ["GET"]
}
```

Some of the possible requests matching this API could be:

```http
GET /foo HTTP/1.1
Host: example.com
```

```http
GET /bar HTTP/1.1
Host: service.com
```

```http
GET /foo/hello/world HTTP/1.1
Host: example.com
```

All three of these requests satisfy all the conditions set in the API
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
first request's URI is not a match for any of the configured `uris`, same for
the second request's HTTP method, and the third request's Host header.

Now that we understand how the `hosts`, `uris`, and `methods` properties work
together, let's explore each property individually.

[Back to TOC](#table-of-contents)

#### Request Host header

Routing a request based on its Host header is the most straightforward way to
proxy traffic through Kong, as this is the intended usage of the HTTP Host
header. Kong makes it easy to do so via the `hosts` field of the API entity.

`hosts` accepts multiple values, which must be comma-separated when specifying
them via the Admin API:

```bash
$ curl -i -X POST http://localhost:8001/apis/ \
    -d 'name=my-api' \
    -d 'upstream_url=http://my-api.com' \
    -d 'hosts=my-api.com,example.com,service.com'
HTTP/1.1 201 Created
...
```

To satisfy the `hosts` condition of this API, any incoming request from a
client must now have its Host header set to one of:

```
Host: my-api.com
```

or:

```
Host: example.com
```

or:

```
Host: service.com
```

[Back to TOC](#table-of-contents)

##### Using wildcard hostnames

To provide flexibility, Kong allows you to specify hostnames with wildcards in
the `hosts` field. Wildcard hostnames allow any matching Host header to satisfy
the condition, and thus match a given API.

Wildcard hostnames **must** contain **only one** asterisk at the leftmost
**or** rightmost label of the domain. Examples:

- `*.example.com` would allow Host values such as `a.example.com` and
  `x.y.example.com` to match.
- `example.*` would allow Host values such as `example.com` and `example.org`
  to match.

A complete example would look like this:

```json
{
    "name": "my-api",
    "upstream_url": "http://my-api.com",
    "hosts": ["*.example.com", "service.com"]
}
```

Which would allow the following requests to match this API:

```http
GET / HTTP/1.1
Host: an.example.com
```

```http
GET / HTTP/1.1
Host: service.com
```

[Back to TOC](#table-of-contents)

##### The `preserve_host` property

When proxying, Kong's default behavior is to set the upstream request's Host
header to the hostname of the API's `upstream_url` property. The
`preserve_host` field accepts a boolean flag instructing Kong not to do so.

For example, when the `preserve_host` property is not changed and an API is
configured like this:

```json
{
    "name": "my-api",
    "upstream_url": "http://my-api.com",
    "hosts": ["service.com"],
}
```

A possible request from a client to Kong could be:

```http
GET / HTTP/1.1
Host: service.com
```

Kong would extract the Host header value from the the hostname of the API's
`upstream_url` field, and would send the following request to your upstream
service:

```http
GET / HTTP/1.1
Host: my-api.com
```

However, by explicitly configuring your API with `preserve_host=true`:

```json
{
    "name": "my-api",
    "upstream_url": "http://my-api.com",
    "hosts": ["service.com"],
    "preserve_host": true
}
```

And assuming the same request from the client:

```http
GET / HTTP/1.1
Host: service.com
```

Kong would preserve the Host on the client request and would send the following
request to your upstream service:

```http
GET / HTTP/1.1
Host: service.com
```

[Back to TOC](#table-of-contents)

#### Request URI

Another way for Kong to route a request to a given upstream service is to
specify a request URI via the `uris` property. To satisfy this field's
condition, a client request's URI **must** be prefixed with one of the values
of the `uris` field.

For example, in an API configured like this:

```json
{
    "name": "my-api",
    "upstream_url": "http://my-api.com",
    "uris": ["/service", "/hello/world"]
}
```

The following requests would match the configured API:

```http
GET /service HTTP/1.1
Host: my-api.com
```

```http
GET /service/resource?param=value HTTP/1.1
Host: my-api.com
```

```http
GET /hello/world/resource HTTP/1.1
Host: anything.com
```

For each of these requests, Kong detects that their URI is prefixed with one of
the API's `uris` values. By default, Kong would then forward the request
upstream with the untouched, **same URI**.

When proxying with URIs prefixes, **the longest URIs get evaluated first**.
This allow you to define two APIs with two URIs: `/service` and
`/service/resource`, and ensure that the former does not "shadow" the latter.

[Back to TOC](#table-of-contents)

##### The `strip_uri` property

It may be desirable to specify a URI prefix to match an API, but not
include it in the upstream request. To do so, use the `strip_uri` boolean
property by configuring an API like this:

```json
{
    "name": "my-api",
    "upstream_url": "http://my-api.com",
    "uris": ["/service"],
    "strip_uri": true
}
```

Enabling this flag instructs Kong that when proxying this API, it should **not**
include the matching URI prefix in the upstream request's URI. For example, the
following client's request to the API configured as above:

```http
GET /service/path/to/resource HTTP/1.1
Host:
```

Will cause Kong to send the following request to your upstream service:

```http
GET /path/to/resource HTTP/1.1
Host: my-api.com
```

[Back to TOC](#table-of-contents)

#### Request HTTP method

Starting with Kong 0.10, client requests can also be routed depending on their
HTTP method by specifying the `methods` field. By default, Kong will route a
request to an API regardless of its HTTP method. But when this field is set,
only requests with the specified HTTP methods will be matched.

This field also accepts multiple values. Here is an example of an API allowing
routing via `GET` and `HEAD` HTTP methods:

```json
{
    "name": "api-1",
    "upstream_url": "http://my-api.com",
    "methods": ["GET", "HEAD"]
}
```

Such an API would be matched with the following requests:

```http
GET / HTTP/1.1
Host:
```

```http
HEAD /resource HTTP/1.1
Host:
```

But would not match a `POST` or `DELETE` request. This allows for much more
granularity when configuring APIs and Plugins. For example, one could imagine
two APIs pointing to the same upstream service: one API allowing unlimited
unauthenticated `GET` requests, and a second API allowing only authenticated
and rate-limited `POST` requests (by applying the authentication and rate
limiting plugins to such requests).

[Back to TOC](#table-of-contents)

### Routing priorities

An API may define matching rules based on its `hosts`, `uris`, and `methods`
fields. For Kong to match an incoming request to an API, all existing fields
must be satisfied. However, Kong allows for quite some flexibility by allowing
two or more APIs to be configured with fields containing the same values - when
this occurs, Kong applies a priority rule.

The rule is that : **when evaluating a request, Kong will first try
to match the APIs with the most rules**.

For example, two APIs are configured like this:

```json
{
    "name": "api-1",
    "upstream_url": "http://my-api.com",
    "hosts": ["example.com"]
},
{
    "name": "api-2",
    "upstream_url": "http://my-api-2.com",
    "hosts": ["example.com"],
    "methods": ["POST"]
}
```

api-2 has a `hosts` field **and** a `methods` field, so it will be
evaluated first by Kong. By doing so, we avoid api-1 "shadowing" calls
intended for api-2.

Thus, this request will match api-1:

```http
GET / HTTP/1.1
Host: example.com
```

And this request will match api-2:

```http
POST / HTTP/1.1
Host: example.com
```

Following this logic, if a third API was to be configured with a `hosts` field,
a `methods` field, and a `uris` field, it would be evaluated first by Kong.

[Back to TOC](#table-of-contents)

### Proxying behavior

The proxying rules above detail how Kong forwards incoming requests to your
upstream services. Below we detail what happens internally between the time
Kong *recognizes* an HTTP request to a target service, and the actual
*forwarding* of the request upstream.

[Back to TOC](#table-of-contents)

#### 1. Load balancing

Starting with Kong 0.10, Kong implements load balancing capabilities to
distribute the forwarded requests across multiple instances of an upstream
service.

Previous to Kong 0.10, Ordinarily, Kong would send proxied requests to the
`upstream_url`, and load balancing across multiple upstream instances required
an external load balancer.

You can find more informations about adding load balancing to your APIs by
consulting the [Load Balancing Reference][load-balancing-reference].

[Back to TOC](#table-of-contents)

#### 2. Plugins execution

Kong is extensible via "plugins" that hook themselves in the
request/response lifecycle of the proxied requests. Plugins can perform a
variety of operations in your environment and/or transformations on the proxied
request.

Plugins can be configured to run globally (for all proxied traffic) or on a
per-API basis by creating a [plugin configuration][plugin-configuration-object]
through the Admin API.

When a plugin is configured for a given API, and the API has been matched from
an incoming request, Kong will execute the configured plugin(s) for this
request before proxying it to your upstream service. This includes, among
others, the `access` phase of the plugin, on which you can find more
informations about in the [Plugin development guide][plugin-development-guide].

[Back to TOC](#table-of-contents)

#### 3. Proxying & upstream timeouts

Once Kong has executed all the necessary logic (including plugins), it is ready
to forward the request to your upstream service. This is done via Nginx's
[ngx_http_proxy_module][ngx-http-proxy-module]. Since Kong `0.10`, the timeout
duration for the connections between Kong and your upstream services may be
configured via these three properties of the API object:

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
- `Connection: keep-alive`, to allow for reusing the upstream connections
- `X-Real-IP: <$proxy_add_x_forwarded_for>`, where `$proxy_add_x_forwarded_for`
  is the variable bearing the same name provided by
  [ngx_http_proxy_module][ngx-http-proxy-module].
- `X-Forwarded-Proto: <protocol>`, where `<protocol>` is the protocol used by
  the client.

All the other request headers are forwarded as-is by Kong.

One exception to this is made when using the WebSocket protocol. If so, Kong
will set the following headers to allow for upgrading the protocol between the
client and your upstream services:

- `Connection: Upgrade`
- `Upgrade: websocket`

More information on this topic is covered in the
[Proxy WebSocket traffic][proxy-websocket] section.

[Back to TOC](#table-of-contents)

#### 4. Response

Kong receives the response from the upstream service and send it back to the
downstream client in a streaming fashion. At this point Kong will execute
subsequent plugins added to that particular API that implement a hook in the
`header_filter` phase.

Once the `header_filter` phase of all registered plugins has been executed, the
following headers will be added by Kong and the full set of headers be sent to
the client:

- `Via: kong/x.x.x`, where `x.x.x` is the Kong version in use
- `Kong-Proxy-Latency: <latency>`, where `latency` is the time in milliseconds
  between Kong receiving the request from the client and sending the request to
  your upstream service.
- `Kong-Upstream-Latency: <latency>`, where `latency` is the time in
  milliseconds that Kong was waiting for the first byte of the upstream service
  response.

Once the headers are sent to the client, Kong will start executing
registered plugins for that API that implement the `body_filter` hook. This
hook may be called multiple times, due to the streaming nature of Nginx itself.
Each chunk of the upstream response that is successfully processed by such
`body_filter` hooks is sent back to the client. You can find more informations
about the `body_filter` hook in the [Plugin development
guide][plugin-development-guide].

[Back to TOC](#table-of-contents)

### Configuring a fallback API

As a practical use-case and example of the flexibility offered by Kong's
proxying capabilities, let's try to implement a "fallback API", so that in
order to avoid Kong responding with an HTTP `404`, "API not found", we can
catch such requests and proxy them to a special upstream service of yours, or
apply a plugin to it (such a plugin could, for example, terminate the request
with a different status code or response without proxying the request).

Here is an example of such a fallback API:

```json
{
    "name": "root-fallback",
    "upstream_url": "http://dummy.com",
    "uris": ["/"]
}
```

As you can guess, any HTTP request made to Kong would actually match this API,
since all URIs are prefixed by the root character `/`. As we know from the
[Request URI][proxy-request-uri] section, the longest URIs are evaluated first
by Kong, so the `/` URI will eventually be evaluated last by Kong, and
effectively provide a "fallback" API, only matched as a last resort.

[Back to TOC](#table-of-contents)

### Configuring SSL for an API

Kong provides a way to dynamically serve SSL certificates on a per-connection
basis. Starting with 0.10, the SSL plugin has been removed and SSL certificates
are directly handled by the core, and configurable via the Admin API. Your
client HTTP library must support the [Server Name Indication][SNI] extension to
make use of this feature.

SSL certificates are handled by two resources of the Kong Admin API:

- `/certificates`, which stores your keys and certificates.
- `/snis`, which associates a registered certificate with a Server Name
  Indication.

You can find the documentation for those two resources in the
[Admin API Reference][API].

Here is how to configure an SSL certificate for a given API: first, upload your
SSL certificate and key via the Admin API:

```bash
$ curl -i -X POST http://localhost:8001/certificates \
    -d "cert=@/path/to/cert.pem" \
    -d "key=@/path/to/cert.key" \
    -d "snis=ssl-example.com,other-ssl-example.com"
HTTP/1.1 201 Created
...
```

The `snis` form parameter is a sugar parameter, directly inserting an SNI and
associating the uploaded certificate to it.

You must now register the following API within Kong. We'll route requests to
this API using the Host header for convenience:

```bash
$ curl -i -X POST http://localhost:8001/apis \
    -d "name=ssl-api" \
    -d "upstream_url=http://my-api.com" \
    -d "hosts=ssl-example.com,other-ssl-example.com"
HTTP/1.1 201 Created
...
```

You can now expect the API to be served over HTTPs by Kong:

```bash
$ curl -i https://localhost:8443/ \
  -H "Host: ssl-example.com"
HTTP/1.1 200 OK
...
```

[Back to TOC](#table-of-contents)

#### The `https_only` property

If you wish an API to only be served through HTTPS, you can do so by enabling
its `https_only` property:

```bash
$ curl -i -X POST http://localhost:8001/apis \
    -d "name=ssl-only-api" \
    -d "upstream_url=http://example.com" \
    -d "hosts=my-api.com" \
    -d "https_only=true"
HTTP/1.1 201 Created
...
```

By configuring your API like so, Kong will refuse to proxy traffic for it
without HTTPS. A request to Kong over plain HTTP targetting this API would
instruct your clients to upgrade to HTTPS:

```bash
$ curl -i http://localhost:8000 \
    -H "Host: my-api.com"
HTTP/1.1 426
Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Connection: Upgrade
Upgrade: TLS/1.2, HTTP/1.1
Server: kong/x.x.x

{"message":"Please use HTTPS protocol"}
```

[Back to TOC](#table-of-contents)

#### The `http_if_terminated` property

If you wish to consider the `X-Forwarded-Proto` header of your requests when
enforcing HTTPS only traffic, enable the `http_if_terminated` property of your
API definition.

Following the previous example, if we update our HTTPS-only API:

```bash
$ curl -i -X PATCH http://localhost:8001/apis/ssl-only-api \
    -d "http_if_terminated=true"
HTTP/1.1 200 OK
...
```

And we make a request with the `X-Forwarded-Proto` header (assuming it is
coming from a **trusted** client):

```bash
$ curl -i http://localhost:8000 \
    -H "Host: my-api.com" \
    -H "X-Forwarded-Proto: https"
HTTP/1.1 200 OK
...
```

Kong now proxies this request, because it assumes SSL termination has been
achieved by a previous component of your architecture.

[Back to TOC](#table-of-contents)

### Proxy WebSocket traffic

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

### Conclusion

Through this guide, we hope you gained knowledge of the underlying proxying
mechanism of Kong, from how is a request matched to an API, to how to allow for
using the WebSocket protocol or setup SSL for an API.

This website is Open-Source and can be found at
[github.com/Mashape/getkong.org][https://github.com/Mashape/getkong.org/].
Feel free to provide feedback to this document there, or propose improvements!

If not already done, we suggest that you also read the
[Load balancing Reference][load-balancing-guide], as it closely relates to the
topic we just covered.

[Back to TOC](#table-of-contents)

[plugin-configuration-object]: /docs/{{page.kong_version}}/admin-api#plugin-configuration-object
[plugin-development-guide]: /docs/{{page.kong_version}}/admin-api#plugin-development-guide
[load-balancing-reference]: /docs/{{page.kong_version}}/admin-api#load-balancing-guide
[configuration-reference]: /docs/{{page.kong_version}}/configuration-reference
[adding-your-api]: /docs/{{page.kong_version}}/getting-started/adding-your-api
[API]: /docs/{{page.kong_version}}/admin-api

[ngx-http-proxy-module]: http://nginx.org/en/docs/http/ngx_http_proxy_module.html
[SNI]: https://en.wikipedia.org/wiki/Server_Name_Indication
