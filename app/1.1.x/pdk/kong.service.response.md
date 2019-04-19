---
title: kong.service.response
pdk: true
toc: true
---

## kong.service.response

Manipulation of the response from the Service



### kong.service.response.get_status()

Returns the HTTP status code of the response from the Service as a Lua number.

**Phases**

* `header_filter`, `body_filter`, `log`

**Returns**

* `number|nil`  the status code from the response from the Service, or `nil`
 if the request was not proxied (i.e. `kong.response.get_source()` returned
 anything other than `"service"`.


**Usage**

``` lua
kong.log.inspect(kong.service.response.get_status()) -- 418
```

[Back to TOC](#table-of-contents)


### kong.service.response.get_headers([max_headers])

Returns a Lua table holding the headers from the response from the Service.  Keys are
 header names. Values are either a string with the header value, or an array of
 strings if a header was sent multiple times. Header names in this table are
 case-insensitive and dashes (`-`) can be written as underscores (`_`); that is,
 the header `X-Custom-Header` can also be retrieved as `x_custom_header`.

 Unlike `kong.response.get_headers()`, this function will only return headers that
 were present in the response from the Service (ignoring headers added by Kong itself).
 If the request was not proxied to a Service (e.g. an authentication plugin rejected
 a request and produced an HTTP 401 response), then the returned `headers` value
 might be `nil`, since no response from the Service has been received.

 By default, this function returns up to **100** headers. The optional
 `max_headers` argument can be specified to customize this limit, but must be
 greater than **1** and not greater than **1000**.

**Phases**

* `header_filter`, `body_filter`, `log`

**Parameters**

* **max_headers** (number, _optional_):  customize the headers to parse

**Returns**

1.  `table` the response headers in table form

1.  `string` err If more headers than `max_headers` were present, a
 string with the error `"truncated"`.


**Usage**

``` lua
-- Given a response with the following headers:
-- X-Custom-Header: bla
-- X-Another: foo bar
-- X-Another: baz
local headers = kong.service.response.get_headers()
if headers then
  kong.log.inspect(headers.x_custom_header) -- "bla"
  kong.log.inspect(headers.x_another[1])    -- "foo bar"
  kong.log.inspect(headers["X-Another"][2]) -- "baz"
end
```

[Back to TOC](#table-of-contents)


### kong.service.response.get_header(name)

Returns the value of the specified response header.

 Unlike `kong.response.get_header()`, this function will only return a header
 if it was present in the response from the Service (ignoring headers added by Kong
 itself).


**Phases**

* `header_filter`, `body_filter`, `log`

**Parameters**

* **name** (string):  The name of the header.

 Header names in are case-insensitive and are normalized to lowercase, and
 dashes (`-`) can be written as underscores (`_`); that is, the header
 `X-Custom-Header` can also be retrieved as `x_custom_header`.


**Returns**

* `string|nil`  The value of the header, or `nil` if a header with
 `name` was not found in the response. If a header with the same name is present
 multiple times in the response, this function will return the value of the
 first occurrence of this header.


**Usage**

``` lua
-- Given a response with the following headers:
-- X-Custom-Header: bla
-- X-Another: foo bar
-- X-Another: baz

kong.log.inspect(kong.service.response.get_header("x-custom-header")) -- "bla"
kong.log.inspect(kong.service.response.get_header("X-Another"))       -- "foo bar"
```

[Back to TOC](#table-of-contents)

