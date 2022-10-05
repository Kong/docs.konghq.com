---
title: kong.request
pdk: true
toc: true
---

## kong.request

Client request module
 A set of functions to retrieve information about the incoming requests made
 by clients.



### kong.request.get_scheme()

Returns the scheme component of the request's URL.  The returned value is
 normalized to lower-case form.


**Phases**

* rewrite, access, header_filter, body_filter, log, admin_api

**Returns**

* `string` a string like `"http"` or `"https"`


**Usage**

``` lua
-- Given a request to https://example.com:1234/v1/movies

kong.request.get_scheme() -- "https"
```

[Back to TOC](#table-of-contents)


### kong.request.get_host()

Returns the host component of the request's URL, or the value of the
 "Host" header.  The returned value is normalized to lower-case form.


**Phases**

* rewrite, access, header_filter, body_filter, log, admin_api

**Returns**

* `string` the host


**Usage**

``` lua
-- Given a request to https://example.com:1234/v1/movies

kong.request.get_host() -- "example.com"
```

[Back to TOC](#table-of-contents)


### kong.request.get_port()

Returns the port component of the request's URL.  The value is returned
 as a Lua number.


**Phases**

* certificate, rewrite, access, header_filter, body_filter, log, admin_api

**Returns**

* `number` the port


**Usage**

``` lua
-- Given a request to https://example.com:1234/v1/movies

kong.request.get_port() -- 1234
```

[Back to TOC](#table-of-contents)


### kong.request.get_forwarded_scheme()

Returns the scheme component of the request's URL, but also considers
 `X-Forwarded-Proto` if it comes from a trusted source.  The returned
 value is normalized to lower-case.

 Whether this function considers `X-Forwarded-Proto` or not depends on
 several Kong configuration parameters:

 * [trusted\_ips](https://getkong.org/docs/latest/configuration/#trusted_ips)
 * [real\_ip\_header](https://getkong.org/docs/latest/configuration/#real_ip_header)
 * [real\_ip\_recursive](https://getkong.org/docs/latest/configuration/#real_ip_recursive)

 **Note**: support for the Forwarded HTTP Extension (RFC 7239) is not
 offered yet since it is not supported by ngx\_http\_realip\_module.


**Phases**

* rewrite, access, header_filter, body_filter, log, admin_api

**Returns**

* `string` the forwarded scheme


**Usage**

``` lua
kong.request.get_forwarded_scheme() -- "https"
```

[Back to TOC](#table-of-contents)


### kong.request.get_forwarded_host()

Returns the host component of the request's URL or the value of the "host"
 header.  Unlike `kong.request.get_host()`, this function will also consider
 `X-Forwarded-Host` if it comes from a trusted source. The returned value
 is normalized to lower-case.

 Whether this function considers `X-Forwarded-Proto` or not depends on
 several Kong configuration parameters:

 * [trusted\_ips](https://getkong.org/docs/latest/configuration/#trusted_ips)
 * [real\_ip\_header](https://getkong.org/docs/latest/configuration/#real_ip_header)
 * [real\_ip\_recursive](https://getkong.org/docs/latest/configuration/#real_ip_recursive)

 **Note**: we do not currently offer support for Forwarded HTTP Extension
 (RFC 7239) since it is not supported by ngx_http_realip_module.


**Phases**

* rewrite, access, header_filter, body_filter, log, admin_api

**Returns**

* `string` the forwarded host


**Usage**

``` lua
kong.request.get_forwarded_host() -- "example.com"
```

[Back to TOC](#table-of-contents)


### kong.request.get_forwareded_port()

Returns the port component of the request's URL, but also considers
 `X-Forwarded-Host` if it comes from a trusted source.  The value
 is returned as a Lua number.

 Whether this function considers `X-Forwarded-Proto` or not depends on
 several Kong configuration parameters:

 * [trusted\_ips](https://getkong.org/docs/latest/configuration/#trusted_ips)
 * [real\_ip\_header](https://getkong.org/docs/latest/configuration/#real_ip_header)
 * [real\_ip\_recursive](https://getkong.org/docs/latest/configuration/#real_ip_recursive)

 **Note**: we do not currently offer support for Forwarded HTTP Extension
 (RFC 7239) since it is not supported by ngx_http_realip_module.


**Phases**

* rewrite, access, header_filter, body_filter, log, admin_api

**Returns**

* `number` the forwared port


**Usage**

``` lua
kong.request.get_forwarded_port() -- 1234
```

[Back to TOC](#table-of-contents)


### kong.request.get_http_version()

Returns the HTTP version used by the client in the request as a Lua
 number, returning values such as `1`, `1.1`, `2.0`, or `nil` for
 unrecognized values.

**Phases**

* rewrite, access, header_filter, body_filter, log, admin_api

**Returns**

* `number|nil` the http version


**Usage**

``` lua
kong.request.get_http_version() -- 1.1
```

[Back to TOC](#table-of-contents)


### kong.request.get_method()

Returns the HTTP method of the request.  The value is normalized to
 upper-case.


**Phases**

* rewrite, access, header_filter, body_filter, log, admin_api

**Returns**

* `string` the request method


**Usage**

``` lua
kong.request.get_method() -- "GET"
```

[Back to TOC](#table-of-contents)


### kong.request.get_path()

Returns the path component of the request's URL.  It is not normalized in
 any way and does not include the querystring.


**Phases**

* rewrite, access, header_filter, body_filter, log, admin_api

**Returns**

* `string` the path


**Usage**

``` lua
-- Given a request to https://example.com:1234/v1/movies?movie=foo

kong.request.get_path() -- "/v1/movies"
```

[Back to TOC](#table-of-contents)


### kong.request.get_path_with_query()

Returns the path, including the querystring if any.  No
 transformations/normalizations are done.


**Phases**

* rewrite, access, header_filter, body_filter, log, admin_api

**Returns**

* `string` the path with the querystring


**Usage**

``` lua
-- Given a request to https://example.com:1234/v1/movies?movie=foo

kong.request.get_raw_path_and_query() -- "/v1/movies?movie=foo"
```

[Back to TOC](#table-of-contents)


### kong.request.get_raw_query()

Returns the query component of the request's URL.  It is not normalized in
 any way (not even URL-decoding of special characters) and does not
 include the leading `?` character.


**Phases**

* rewrite, access, header_filter, body_filter, log, admin_api

**Returns**

*  string the query component of the request's URL


**Usage**

``` lua
-- Given a request to https://example.com/foo?msg=hello%20world&bla=&bar

kong.request.get_raw_query() -- "msg=hello%20world&bla=&bar"
```

[Back to TOC](#table-of-contents)


### kong.request.get_query_arg()

Returns the value of the specified argument, obtained from the query
 arguments of the current request.

 The returned value is either a `string`, a boolean `true` if an
 argument was not given a value, or `nil` if no argument with `name` was
 found.

 If an argument with the same name is present multiple times in the
 querystring, this function will return the value of the first occurrence.


**Phases**

* rewrite, access, header_filter, body_filter, log, admin_api

**Returns**

* `string|boolean|nil` the value of the argument


**Usage**

``` lua
-- Given a request GET /test?foo=hello%20world&bar=baz&zzz&blo=&bar=bla&bar

kong.request.get_query_arg("foo") -- "hello world"
kong.request.get_query_arg("bar") -- "baz"
kong.request.get_query_arg("zzz") -- true
kong.request.get_query_arg("blo") -- ""
```

[Back to TOC](#table-of-contents)


### kong.request.get_query([max_args])

Returns the table of query arguments obtained from the querystring.  Keys
 are query argument names. Values are either a string with the argument
 value, a boolean `true` if an argument was not given a value, or an array
 if an argument was given in the query string multiple times. Keys and
 values are unescaped according to URL-encoded escaping rules.

 Note that a query string `?foo&bar` translates to two boolean `true`
 arguments, and `?foo=&bar=` translates to two string arguments containing
 empty strings.

 By default, this function returns up to **100** arguments. The optional
 `max_args` argument can be specified to customize this limit, but must be
 greater than **1** and not greater than **1000**.


**Phases**

* rewrite, access, header_filter, body_filter, log, admin_api

**Parameters**

* **max_args** (number, _optional_):  set a limit on the maximum number of parsed
 arguments

**Returns**

* `table` A table representation of the query string


**Usage**

``` lua
-- Given a request GET /test?foo=hello%20world&bar=baz&zzz&blo=&bar=bla&bar

for k, v in pairs(kong.request.get_query()) do
  kong.log.inspect(k, v)
end

-- Will print
-- "foo" "hello world"
-- "bar" {"baz", "bla", true}
-- "zzz" true
-- "blo" ""
```

[Back to TOC](#table-of-contents)


### kong.request.get_header(name)

Returns the value of the specified request header.

 The returned value is either a `string`, or can be `nil` if a header with
 `name` was not found in the request. If a header with the same name is
 present multiple times in the request, this function will return the value
 of the first occurrence of this header.

 Header names in are case-insensitive and are normalized to lowercase, and
 dashes (`-`) can be written as underscores (`_`); that is, the header
 `X-Custom-Header` can also be retrieved as `x_custom_header`.


**Phases**

* rewrite, access, header_filter, body_filter, log, admin_api

**Parameters**

* **name** (string):  the name of the header to be returned

**Returns**

* `string|nil` the value of the header or nil if not present


**Usage**

``` lua
-- Given a request with the following headers:

-- Host: foo.com
-- X-Custom-Header: bla
-- X-Another: foo bar
-- X-Another: baz

kong.request.get_header("Host")            -- "foo.com"
kong.request.get_header("x-custom-header") -- "bla"
kong.request.get_header("X-Another")       -- "foo bar"
```

[Back to TOC](#table-of-contents)


### kong.request.get_headers([max_headers])

Returns a Lua table holding the request headers.  Keys are header names.
 Values are either a string with the header value, or an array of strings
 if a header was sent multiple times. Header names in this table are
 case-insensitive and are normalized to lowercase, and dashes (`-`) can be
 written as underscores (`_`); that is, the header `X-Custom-Header` can
 also be retrieved as `x_custom_header`.

 By default, this function returns up to **100** headers. The optional
 `max_headers` argument can be specified to customize this limit, but must
 be greater than **1** and not greater than **1000**.


**Phases**

* rewrite, access, header_filter, body_filter, log, admin_api

**Parameters**

* **max_headers** (number, _optional_):  set a limit on the maximum number of
 parsed headers

**Returns**

* `table` the request headers in table form


**Usage**

``` lua
-- Given a request with the following headers:

-- Host: foo.com
-- X-Custom-Header: bla
-- X-Another: foo bar
-- X-Another: baz
local headers = kong.request.get_headers()

headers.host            -- "foo.com"
headers.x_custom_header -- "bla"
headers.x_another[1]    -- "foo bar"
headers["X-Another"][2] -- "baz"
```

[Back to TOC](#table-of-contents)


### kong.request.get_raw_body()

Returns the plain request body.

 If the body has no size (empty), this function returns an empty string.

 If the size of the body is greater than the Nginx buffer size (set by
 `client_body_buffer_size`), this function will fail and return an error
 message explaining this limitation.


**Phases**

* rewrite, access, admin_api

**Returns**

* `string` the plain request body


**Usage**

``` lua
-- Given a body with payload "Hello, Earth!":

kong.request.get_raw_body():gsub("Earth", "Mars") -- "Hello, Mars!"
```

[Back to TOC](#table-of-contents)


### kong.request.get_body([mimetype[, max_args]])

Returns the request data as a key/value table.
 A high-level convenience function.
 The body is parsed with the most appropriate format:

 * If `mimetype` is specified:
   * Decodes the body with the requested content type (if supported).
 * If the request content type is `application/x-www-form-urlencoded`:
   * Returns the body as form-encoded.
 * If the request content type is `multipart/form-data`:
   * Decodes the body as multipart form data
     (same as `multipart(kong.request.get_raw_body(),
     kong.request.get_header("Content-Type")):get_all()` ).
 * If the request content type is `application/json`:
   * Decodes the body as JSON
     (same as `json.decode(kong.request.get_raw_body())`).
   * JSON types are converted to matching Lua types.
 * If none of the above, returns `nil` and an error message indicating the
   body could not be parsed.

 The optional argument `mimetype` can be one of the following strings:

 * `application/x-www-form-urlencoded`
 * `application/json`
 * `multipart/form-data`

 The optional argument `max_args` can be used to set a limit on the number
 of form arguments parsed for `application/x-www-form-urlencoded` payloads.

 The third return value is string containing the mimetype used to parsed
 the body (as per the `mimetype` argument), allowing the caller to identify
 what MIME type the body was parsed as.


**Phases**

* rewrite, access, admin_api

**Parameters**

* **mimetype** (string, _optional_):  the MIME type
* **max_args** (number, _optional_):  set a limit on the maximum number of parsed
 arguments

**Returns**

1.  `table|nil` a table representation of the body

1.  `string|nil` an error message

1.  `string|nil` mimetype the MIME type used


**Usage**

``` lua
local body, err, mimetype = kong.request.get_body()
body.name -- "John Doe"
body.age  -- "42"
```

[Back to TOC](#table-of-contents)

