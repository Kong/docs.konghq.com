---
title: Proxy Reference
---

# Proxy Reference

As you may already know, Kong listens for traffic on three ports, which by
default are:

- `:8001` on which the [Admin API][API] used to configure Kong listens.
- `:8000` on which Kong listens for incoming HTTP traffic from your clients, and 
forwards it to your upstream services. This is the port that interests us in 
this guide.
- `:8443` on which Kong listens for incoming HTTPs traffic. This port has a
similar behavior as the `:8000` port, except that it expects HTTPs traffic. This
port can be disabled via the configuration file.

We will cover routing capabilities of Kong by explaining in details how incoming 
requests on port `:8000` are proxied to a configured upstream service depending
on their headers, URI, and HTTP method.

It is worth pointing out that both of these ports can be configured. See the
[Configuration Reference] for more details.

### Table of Contents

- [Terminology][proxy-terminology]
- [Overview][proxy-overview]
- [Reminder: how to add an API to Kong][proxy-reminder]
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
[proxy-proxying-upstream-timeouts]: #3-proxying-amp-upstream-timeouts
[proxy-response]: #proxy-response
[proxy-configuring-a-fallback-api]: #configuring-a-fallback-api
[proxy-configuring-ssl-for-an-api]: #configuring-ssl-for-an-api
[proxy-the-https-only-property]: #the-https_only-property
[proxy-the-http-if-terminated-property]: #the-http_if_terminated-property
[proxy-websocket]: #proxy-websocket-traffic
[proxy-conclusion]: #conclusion

---

### Terminology

In this document, we will refer to various Kong concepts. For the sake of 
consistency, we will now define terms refering to such concepts:

- `API`: This term refers to the API entity of Kong. You configure your APIs,
that point to your own Upstream services through the Admin API.
- `Plugin`: This refers to Kong "plugins", which are pieces of business logic
that run in proxying lifecycle. Plugins can be configured globally (all 
incoming traffic), or on a per-API basis through the Admin API.
- `Client`: Refers to the - downstream - client making requests to Kong's proxy
port.
- `Upstream service`: Refers to your own API/service setting behind Kong,
where requests are forwarded to.

[Back to TOC](#table-of-contents)

### Overview

From a high level perspective, Kong will listen for HTTP traffic on its
configured proxy port (`8000` by default), recognize which upstream service is
being requested, run the configured plugins for that API, and forward the HTTP 
request upstream to your own API or service. Kong can also run plugins once the 
response from your upstream service is received, but that topic is not as
relevant to this guide.

When a client makes a request to the proxy port, Kong will decide where to route
(or forward) that incoming request (that is, to which of your upstream 
services). Kong achieves this through the APIs you configured (via the Admin 
API). You can configure APIs with various properties, but the three relevant 
ones for routing incoming traffic are `hosts`, `uris` and `methods`.

If Kong cannot determine to which API a given request should be routed to, it
will response with:

```http
HTTP/1.1 404 Not Found
Content-Type: application/json
Server: kong/<x.x.x>

{
    "message": "no API found with those values"
}
```

### Reminder: how to add an API to Kong

Before goign any further, let's take a few moments to make sure you know how to
add an API to Kong.

As explained in the [Adding your API][adding-your-api] quickstart guide, Kong is
configured via its internal [Admin API][API] running by default on port `8001`. 
Adding an API to Kong is as easy as sending an HTTP request:

```bash
$ curl -i -X POST http://localhost:8001/apis/ \
    -d 'name=my-api' \
    -d 'upstream_url=http://my-api.com' \
    -d 'hosts=my-api.com' \
    -d 'uris=/my-api' \
    -d 'methods=GET,HEAD'
HTTP/1.1 201 Created
...
```

This request instructs Kong to register an API named "my-api", reachable at
"http://my-api.com". It also specifies various routing properties. In reality,
**only one of** `hosts`, `uris` and `methods` is actually required. More on this
later.

Adding such an API would mean that you configured Kong to proxy all incoming 
requests matching `hosts`, `uris`, and `methods` to `http://my-api.com`.
Kong being a transparent proxy, it will forward the request to your upstream
service - practically - untouched (exception made of various headers such as
`Connection`, or in case a plugin performs some transformations to it).

[Back to TOC](#table-of-contents)

### Routing capabilities

Let's now investigate in details how Kong matches a request to the configured
`hosts`, `uris` and `methods` properties of your API:

- All of those fields are **optional**, but at least **one of them** must be 
specified.
- For a request to match an API, all of configured fields **must** be satisfied
(present in the client HTTP request).
- All of those fields accept one or more values. A field only needs one of 
values to be considered a match.

Let's go through a few concrete examples. Consider such an API:

```json
{
    "name": "my-api",
    "upstream_url": "http://my-api.com",
    "hosts": ["example.com", "service.com"],
    "uris": ["/foo", "bar"],
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

All three of those requests satisfy all of the three conditions set in the API
definition.

However, the following requests would **not** match this API:

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

All three of those requests are only satisfying two out of the three configured
conditions. The first request's URI is not a match for any of the configured 
`uris`, and it is so for the second request's HTTP method, or the third's Host
header.

Now that we grasp how each of those three properties play together, let's go
into more details and explore each one of them individually.

[Back to TOC](#table-of-contents)

#### Request Host header

It shouldn't come as a surprise that routing a request based on its Host header
is the most straightforward way to proxy traffic through Kong, as this is the
intended usage of the HTTP Host header itself. Hence, Kong certainly makes it 
easy to do so via the `hosts` field of the API entity.

This field accepts multiple values, which must be comma-separated when 
specifying them via the Admin API:

```bash
$ curl -i -X POST http://localhost:8001/apis/ \
    -d 'name=my-api' \
    -d 'upstream_url=http://my-api.com' \
    -d 'hosts=my-api.com,example.com,service.com'
HTTP/1.1 201 Created
...
```

To satisfy the `hosts` condition of this API, any incoming request from a client
must now have its Host header set to one of:

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
the `hosts` field. Such hostnames allow any matching Host header to satisfy the
condition, and match a given API. 

Such hostnames **must** contain **only one** asterisk at the leftmost **or** 
rightmost label of the domain. Examples:

- `*.example.org` would allow Host values such as `a.example.com` and
`x.y.example.com` to match.
- `example.*` would allow Host values such as `example.com` and `example.org` to
match.

A complete example would look like this:

```json
{
    "name": "my-api",
    "upstream_url": "http://my-api.com",
    "hosts": ["*.example.com", "service.com"]
}
```

And allow the following requests to match this API:

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

By default when proxying, Kong's behavior is to set the upstream request's Host
header to the hostname of the API's `upstream_url` property. The `preserve_host`
field accepts a boolean flag instructing Kong not to do so.

Example:

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

By default, Kong would send the following request to your upstream service:

```http
GET / HTTP/1.1
Host: my-api.com
```

The Host header value is extracted from the hostname of the API's `upstream_url`
field.

However, by configuring your API with `preserve_host=true`:

```json
{
    "name": "my-api",
    "upstream_url": "http://my-api.com",
    "hosts": ["service.com"],
    "preserve_host": true
}
```

Assuming the same request from the client, Kong will send the following request
to your upstream service:

```http
GET / HTTP/1.1
Host: service.com
```

[Back to TOC](#table-of-contents)

#### Request URI

Another way for Kong to route a request to a given upstream service of yours is
to specify a request URI via the `uris` property. To satisfy this field's 
condition, a client request's URI **must** be prefixed with one of the values of
the `uris` field. Example:

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

For each of those requests, Kong detects that their URI is prefixed with one of
the API's `uris` values. By default, Kong would then forward the request 
upstream with the untouched, **same URI**.

When proxying with URIs prefixes, **the longest URIs get evaluated first**. This
allow you to define two APIs with two URIs: `/service` and `/service/resource`,
and ensure that the former does not "shadow" the later.

[Back to TOC](#table-of-contents)

##### The `strip_uri` property

Sometimes, you might want to specify a URI prefix to match an API, but not
include it in the upstream request. You can use the `strip_uri` boolean 
property for that:

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
following client's request:

```http
GET /service/path/to/resource HTTP/1.1
Host:
```

Will make Kong send the following request to your upstream service:

```http
GET /path/to/resource HTTP/1.1
Host: my-api.com
```

This property can come very handy at times.

[Back to TOC](#table-of-contents)

#### Request HTTP method

Starting with Kong 0.10, client requests can also be routed depending on their
HTTP method by specifying the `methods` field. By default, Kong will route a 
request to an API regardless of its HTTP method. But when this field is set, 
only requests with the specified HTTP methods will be matched.

This field also accepts multiple values. Here is an example of an API allowing
routing via a simple HTTP method:

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

But would not match a `POST` or a `DELETE` request. This allows for much more 
granularity when configuring APIs and Plugins. For example, one could imagine 
two APIs pointing to the same upstream service: one allowing for `GET` requests
and unprotected, and a second one filtering out `POST` requests and applying 
authentication or rate limiting plugins on such requests.

[Back to TOC](#table-of-contents)

### Routing priorities

It is now clear that an API may define matching rules based on its `hosts`, 
`uris`, and `methods` fields. It is also clear that for Kong to match an
incoming request to an API, all existing fields must be satisfied. However,
Kong allows for quite some flexibility by allowing one to define two APIs with
fields containing the same values. Let's explore the priority rules when such 
APIs are configured.

The rule of thumb is the following: **when evaluating a request, Kong will try
to match the APIs with the most rules first**. Example:

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

Here, because api-2 has a `hosts` field **and** a `methods` field, it will be
evaluated first by Kong. As such, we avoid api-1 to "shadow" calls initially
intended for api-2. This request will match api-1:

```http
GET / HTTP/1.1
Host: example.com
```

And this one will effectively match api-2:

```http
POST / HTTP/1.1
Host: example.com
```

Following this reasoning, if a third API, api-3, was to be configured with a
`hosts`, a `methods` and a `uris` field, it would be evaluated first by Kong.

[Back to TOC](#table-of-contents)

### Proxying behavior

Now that all the proxying rules have been studied and that you have a better
understanding about how Kong forwards incoming requests to your upstream 
services, now is a good opportunity to spend some time detailing what happens 
internally between the time Kong *recognized* an HTTP request to target a 
service, and actual *forwarding* of the request to it.

[Back to TOC](#table-of-contents)

#### 1. Load balancing

Sarting with Kong 0.10, Kong implements load balancing capabilities, allowing it
to distribute the forwarded requests accrodd replicas of your upstream services.

Ordinarily, Kong would simply decide that your API's `upstream_url` would be the
target it has to send the proxied request to, and this step would be mostly 
ignored. However, would you have configured load balancing for this particular
API, this phase would be the moment at which Kong determines which of your
replicas it should target.

You can find more informations about adding load balancing to your APIs by
consulting the [Load balancing Reference][load-balancing-reference].

[Back to TOC](#table-of-contents)

#### 2. Plugins execution

As you may know, Kong is extensible via "plugins" that hook themselves in the
request/response lifecycle of the proxied requests. Such plugins can perform a
variety of operations in your environment and/or transformations on the proxied
request.

Plugins can be configured to run globally (for all proxied traffic), or on a
per-API basis, by creating a [plugin configuration][plugin-configuration-object]
through the Admin API. 

When configured for a given API, and such API has been matched from an incoming 
request, Kong will then move on to executing such plugins for this request, 
before proxying it to your upstream service. This includes the `access` phase of
your plugin, on which you can find more informations about in the 
[Plugin development guide][plugin-development-guide].

[Back to TOC](#table-of-contents)

#### 3. Proxying & upstream timeouts

Kong has now executed all the necessary logic (including plugins) and is ready
to forward the request to your upstream service. This is done via Nginx's
[ngx_http_proxy_module][ngx-http-proxy-module]. Since 0.10, you have control
over the timeout values used for the connections between Kong and your upstream
services, via these three properties of the API object:

- `upstream_connect_timeout`: defines in milliseconds the timeout for 
establishing a connection to your upstream service. Defaults to `60000`.
- `upstream_send_timeout`: defines in milliseconds a timeout between two 
successive write operations for transmitting a request to your upstream service.
Defaults to `60000`.
- `upstream_read_timeout`: defines in milliseconds a timeout between two
successive read operations for receiving a request from your upstream service.
Defaults to `60000`.

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
will set the following headers to allow for upgrading the protocol bewteen the
client and your upstream services:

- `Connection: Upgrade`
- `Upgrade: websocket`

More information on this topic will be covered in the
[Proxy WebSocket traffic][proxy-websocket] section.

[Back to TOC](#table-of-contents)

#### 4. Response

Kong will receive the response from your upstream service and send it back to
your downstream client in a streaming fashion. It is at this time that Kong will
execute subsequent plugins added to that particular API that implement a hook in
the `header_filter` phase.

Once the `header_filter` phase of all registered plugins has been executed, the
following headers will be added by Kong and sent back to your client:

- `Via: kong/x.x.x`, where `x.x.x` is the Kong version in use
- `Kong-Proxy-Latency: <latency>`, where `latency` is the time in milliseconds
taken by Kong between receiving the request from the client and sending the 
request to your upstream service.
- `Kong-Upstream-Latency: <latency>`, where `latency` is the time in 
milliseconds spent by Kong waiting for the first byte of your upstream service
response.

Once the headers are sent back to the client, Kong will start executing 
registered plugins for that API that implement the `body_filter` hook. This hook
may be called multiple times, due to the streaming nature of Nginx itself. Each
chunk of the upstream response that is successfuly processed by such 
`body_filter` hooks is sent back to the client. You can find more informations
about the `body_filter` hook in the
[Plugin development guide][plugin-development-guide].

[Back to TOC](#table-of-contents)

### Configuring a fallback API

As a practical use-case and example of the flexibility offered by Kong's 
proxying capabilities, let's try to implement a "fallback API", so that in order
to avoid Kong responding with an HTTP `404`, "API not found", we can catch such
requests and proxy them to a special upstream service of yours, or apply a
plugin to it (such a plugin could, for example, terminate the request with a 
different status code or response without proxying the request).

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

You must know register the following API withing Kong. We'll route requests to
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

### Proxy WebSocket traffic

Kong supports WebSocket traffic thanks to the underlying Nginx implementation.
When you wish to establish a WebSocket connection between a client and your
upstream services *through* Kong, you must establish a WebSocket handshake. This
is done via the HTTP Upgrade mechanism. This is what your client request made to
Kong would look like:

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
mehanism of Kong, from how is a request matched to an API, to how to allow for
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