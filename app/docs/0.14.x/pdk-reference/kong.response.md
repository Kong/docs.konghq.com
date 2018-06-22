---
title: kong.response
---

# kong.response

Client response module

 The downstream response module contains a set of functions for producing and
 manipulating responses sent back to the client ("downstream").  Responses can be
 produced by Kong (e.g. an authentication plugin rejecting a request), or
 proxied back from an Service's response body.

 Unlike `kong.service.response`, this module allows mutating the response
 before sending it back to the client.


## Table of Contents


### [Functions](#Functions)

* [kong.response.add_header(name, value)](#kong_response_add_header)
* [kong.response.clear_header(name)](#kong_response_clear_header)
* [kong.response.exit(status[, body[, headers]])](#kong_response_exit)
* [kong.response.get_header(name)](#kong_response_get_header)
* [kong.response.get_headers([max_headers])](#kong_response_get_headers)
* [kong.response.get_source()](#kong_response_get_source)
* [kong.response.get_status()](#kong_response_get_status)
* [kong.response.set_header(name, value)](#kong_response_set_header)
* [kong.response.set_headers(headers)](#kong_response_set_headers)
* [kong.response.set_status(status)](#kong_response_set_status)


## <a name="Functions"></a>Functions



### <a name="kong_response_add_header"></a>kong.response.add_header(name, value)

Adds a response header with the given value.  Unlike
 `kong.response.set_header()`, this function does not remove any existing header
 with the same name. Instead, another header with the same name will be added to
 the response. If no header with this name already exists on the response, then
 it is added with the given value, similarly to `kong.response.set_header().`

 This function should be used in the `header_filter` phase, as Kong is
 preparing headers to be sent back to the client.

**Phases**

* `rewrite`, `access`, `header_filter`

**Parameters**

* **name**(`string`):  The header name
* **value**(`string|number|boolean`):  The header value

**Returns**

 Nothing; throws an error on invalid inputs.


**Usage**


``` lua
kong.response.add_header("Cache-Control", "no-cache")
kong.response.add_header("Cache-Control", "no-store")
```


### <a name="kong_response_clear_header"></a>kong.response.clear_header(name)

Removes all occurrences of the specified header in the response sent to
 the client.

 This function should be used in the `header_filter` phase, as Kong is
 preparing headers to be sent back to the client.

**Phases**

* `rewrite`, `access`, `header_filter`

**Parameters**

* **name**(`string`):  The name of the header to be cleared

**Returns**

 Nothing; throws an error on invalid inputs.


**Usage**


``` lua
kong.response.set_header("X-Foo", "foo")
kong.response.add_header("X-Foo", "bar")

kong.response.clear_header("X-Foo")
-- from here onwards, no X-Foo headers will exist in the response
```


### <a name="kong_response_exit"></a>kong.response.exit(status[, body[, headers]])

This function interrupts the current processing and produces a response.  It is
 typical to see plugins using it to produce a response before Kong has a chance
 to proxy the request (e.g. an authentication plugin rejecting a request, or a
 caching plugin serving a cached response).

 It is recommended to use this function in conjunction with the `return`
 operator, to better reflect its meaning:

     return kong.response.exit(200, "Success")

 Calling `kong.response.exit()` will interrupt the execution flow of plugins in
 the current phase. Subsequent phases will still be invoked. E.g. if a plugin
 called `kong.response.exit()` in the `access` phase, no other plugin will be
 executed in that phase, but the `header_filter`, `body_filter`, and `log`
 phases will still be executed, along with their plugins. Plugins should thus
 be programmed defensively against cases when a request was **not** proxied
 to the Service, but instead was produced by Kong itself.

 The first argument `status` will set the status code of the response that will
 be seen by the client.

 The second, optional, `body` argument will set the response body. If it is a
 string, no special processing will be done, and the body will be sent as-is.
 It is the caller's responsibility to set the appropriate Content-Type header
 via the third argument.
 As a convenience, `body` can be specified as a table; in which case, it will
 be JSON-encoded and the `application/json` Content-Type header will be set.

 The third, optional, `headers` argument can be a table specifying response
 headers to send. If specified, its behavior is similar to
 `kong.response.set_headers()`.

 Unless manually specified, this method will automatically set the
 Content-Length header in the produced response for convenience.

**Phases**

* `rewrite`, `access`

**Parameters**

* **status**(`number`):  The status to be used
* **body**(`table|string`, _optional_):  The body to be used
* **headers**(`table`, _optional_):  The headers to be used

**Returns**

 Nothing; throws an error on invalid inputs.


**Usage**


``` lua
return kong.response.exit(403, "Access Forbidden", {
  ["Content-Type"] = "text/plain",
  ["WWW-Authenticate"] = "Basic"
})

...

return kong.response.exit(403, [[{"message":"Access Forbidden"}]], {
  ["Content-Type"] = "application/json",
  ["WWW-Authenticate"] = "Basic"
})

...

return kong.response.exit(403, { message = "Access Forbidden" }, {
  ["WWW-Authenticate"] = "Basic"
})
```


### <a name="kong_response_get_header"></a>kong.response.get_header(name)

Returns the value of the specified response header, as would be seen by the
 client once received.

 The list of headers returned by this function can consist of both response
 headers from the proxied Service _and_ headers added by Kong (e.g. via
 `kong.response.add_header()`).

 The return value is either a `string`, or can be `nil` if a header with `name`
 was not found in the response. If a header with the same name is present
 multiple times in the request, this function will return the value of the first
 occurrence of this header.

**Phases**

* `header_filter`, `body_filter`, `log`

**Parameters**

* **name**(`string`):  The name of the header

 Header names are case-insensitive and dashes (`-`) can be written as
 underscores (`_`); that is, the header `X-Custom-Header` can also be retrieved
 as `x_custom_header`.


**Returns**

`string|nil` The value of the header


**Usage**


``` lua
-- Given a response with the following headers:
-- X-Custom-Header: bla
-- X-Another: foo bar
-- X-Another: baz

kong.log.inspect(kong.response.get_header("x-custom-header")) -- "bla"
kong.log.inspect(kong.response.get_header("X-Another"))       -- "foo bar"
kong.log.inspect(kong.response.get_header("X-None"))          -- nil
```


### <a name="kong_response_get_headers"></a>kong.response.get_headers([max_headers])

Returns a Lua table holding the response headers.  Keys are header names. Values
 are either a string with the header value, or an array of strings if a header
 was sent multiple times. Header names in this table are case-insensitive and
 are normalized to lowercase, and dashes (`-`) can be written as underscores
 (`_`); that is, the header `X-Custom-Header` can also be retrieved as
 `x_custom_header`.

 A response initially has no headers until a plugin short-circuits the proxying
 by producing one (e.g. an authentication plugin rejecting a request), or the
 request has been proxied, and one of the latter execution phases is currently
 running.

 Unlike `kong.service.response.get_headers()`, this function returns *all*
 headers as the client would see them upon reception, including headers
 added by Kong itself.

 By default, this function returns up to **100** headers. The optional
 `max_headers` argument can be specified to customize this limit, but must be
 greater than **1** and not greater than **1000**.

**Phases**

* `header_filter`, `body_filter`, `log`

**Parameters**

* **max_headers**(`number`, _optional_):  Limits how many headers are parsed

**Returns**

1. `table` headers A table representation of the headers in the response

1. `string` err If more headers than `max_headers` were present, a
 string with the error `"truncated"`.


**Usage**


``` lua
-- Given an response from the Service with the following headers:
-- X-Custom-Header: bla
-- X-Another: foo bar
-- X-Another: baz

local headers = kong.response.get_headers()

kong.log.inspect(headers.x_custom_header) -- "bla"
kong.log.inspect(headers.x_another[1])    -- "foo bar"
kong.log.inspect(headers["X-Another"][2]) -- "baz"
```


### <a name="kong_response_get_source"></a>kong.response.get_source()

This function helps determining where the current response originated from.
 Kong being a reverse proxy, it can short-circuit a request and produce a
 response of its own, or the response can come from the proxied Service.

 Returns a string with three possible values:

 * "exit" is returned when, at some point during the processing of the request,
   there has been a call to `kong.response.exit()`. In other words, when the
   request was short-circuited by a plugin or by Kong itself (e.g. invalid
   credentials)
 * "error" is returned when an error has happened while processing the request -
   for example, a timeout while connecting to the upstream service.
 * "service" is returned when the response was originated by successfully
   contacting the proxied Service.

**Phases**

* `header_filter`, `body_filter`, `log`

**Returns**

`string` the source.


**Usage**


``` lua
if kong.response.get_source() == "service" then
  kong.log("The response comes from the Service")
elseif kong.response.get_source() == "error" then
  kong.log("There was an error while processing the request")
elseif kong.response.get_source() == "exit" then
  kong.log("There was an early exit while processing the request")
end
```


### <a name="kong_response_get_status"></a>kong.response.get_status()

Returns the HTTP status code currently set for the downstream response (as a
 Lua number).

 If the request was proxied (as per `kong.service.get_source()`), the return
 value will be that of the response from the Service (identical to
 `kong.service.response.get_status()`).

 If the request was _not_ proxied, and the response was produced by Kong itself
 (i.e. via `kong.response.exit()`), the return value will be returned as-is.

**Phases**

* `header_filter`, `body_filter`, `log`

**Returns**

`number` status The HTTP status code currently set for the downstream response


**Usage**


``` lua
kong.log.inspect(kong.response.get_status()) -- 200
```


### <a name="kong_response_set_header"></a>kong.response.set_header(name, value)

Sets a response header with the given value.  This function overrides any
 existing header with the same name.

 This function should be used in the `header_filter` phase, as Kong is
 preparing headers to be sent back to the client.

**Phases**

* `rewrite`, `access`, `header_filter`

**Parameters**

* **name**(`string`):  The name of the header
* **value**(`string|number|boolean`):  The new value for the header

**Returns**

 Nothing; throws an error on invalid inputs.


**Usage**


``` lua
kong.response.set_header("X-Foo", "value")
```


### <a name="kong_response_set_headers"></a>kong.response.set_headers(headers)

Sets the headers for the response.  Unlike `kong.response.set_header()`, the
 `headers` argument must be a table in which each key is a string (corresponding
 to a header's name), and each value is a string, or an array of strings.

 This function should be used in the `header_filter` phase, as Kong is
 preparing headers to be sent back to the client.

 The resulting headers are produced in lexicographical order. The order of
 entries with the same name (when values are given as an array) is retained.

 This function overrides any existing header bearing the same name as those
 specified in the `headers` argument. Other headers remain unchanged.

**Phases**

* `rewrite`, `access`, `header_filter`

**Parameters**

* **headers**(`table`):

**Returns**

 Nothing; throws an error on invalid inputs.


**Usage**


``` lua
kong.response.set_headers({
  ["Bla"] = "boo",
  ["X-Foo"] = "foo3",
  ["Cache-Control"] = { "no-store", "no-cache" }
})

-- Will add the following headers to the response, in this order:
-- X-Bar: bar1
-- Bla: boo
-- Cache-Control: no-store
-- Cache-Control: no-cache
-- X-Foo: foo3
```


### <a name="kong_response_set_status"></a>kong.response.set_status(status)

Allows changing the downstream response HTTP status code before sending it to
 the client.

 This function should be used in the `header_filter` phase, as Kong is
 preparing headers to be sent back to the client.

**Phases**

* `rewrite`, `access`, `header_filter`

**Parameters**

* **status**(`number`):  The new status

**Returns**

 Nothing; throws an error on invalid inputs.


**Usage**


``` lua
kong.response.set_status(404)
```

