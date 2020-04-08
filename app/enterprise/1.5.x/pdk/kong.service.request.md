---
title: kong.service.request
pdk: true
toc: true
---

## kong.service.request

Manipulation of the request to the Service



### kong.service.request.set_scheme(scheme)

Sets the protocol to use when proxying the request to the Service.

**Phases**

* `access`

**Parameters**

* **scheme** (string):  The scheme to be used. Supported values are `"http"` or `"https"`

**Returns**

*  Nothing; throws an error on invalid inputs.


**Usage**

``` lua
kong.service.request.set_scheme("https")
```

[Back to top](#kongservicerequest)


### kong.service.request.set_path(path)

Sets the path component for the request to the service.  It is not
 normalized in any way and should **not** include the querystring.

**Phases**

* `access`

**Parameters**

* **path** :  The path string. Example: "/v2/movies"

**Returns**

*  Nothing; throws an error on invalid inputs.


**Usage**

``` lua
kong.service.request.set_path("/v2/movies")
```

[Back to top](#kongservicerequest)


### kong.service.request.set_raw_query(query)

Sets the querystring of the request to the Service.  The `query` argument is a
 string (without the leading `?` character), and will not be processed in any
 way.

 For a higher-level function to set the query string from a Lua table of
 arguments, see `kong.service.request.set_query()`.

**Phases**

* `rewrite`, `access`

**Parameters**

* **query** (string):  The raw querystring. Example: "foo=bar&bla&baz=hello%20world"

**Returns**

*  Nothing; throws an error on invalid inputs.


**Usage**

``` lua
kong.service.request.set_raw_query("zzz&bar=baz&bar=bla&bar&blo=&foo=hello%20world")
```

[Back to top](#kongservicerequest)


### kong.service.request.set_method(method)

Sets the HTTP method for the request to the service.

**Phases**

* `rewrite`, `access`

**Parameters**

* **method** :  The method string, which should be given in all
 uppercase. Supported values are: `"GET"`, `"HEAD"`, `"PUT"`, `"POST"`,
 `"DELETE"`, `"OPTIONS"`, `"MKCOL"`, `"COPY"`, `"MOVE"`, `"PROPFIND"`,
 `"PROPPATCH"`, `"LOCK"`, `"UNLOCK"`, `"PATCH"`, `"TRACE"`.

**Returns**

*  Nothing; throws an error on invalid inputs.


**Usage**

``` lua
kong.service.request.set_method("DELETE")
```

[Back to top](#kongservicerequest)


### kong.service.request.set_query(args)

Set the querystring of the request to the Service.

 Unlike `kong.service.request.set_raw_query()`, the `query` argument must be a
 table in which each key is a string (corresponding to an arguments name), and
 each value is either a boolean, a string or an array of strings or booleans.
 Additionally, all string values will be URL-encoded.

 The resulting querystring will contain keys in their lexicographical order. The
 order of entries within the same key (when values are given as an array) is
 retained.

 If further control of the querystring generation is needed, a raw querystring
 can be given as a string with `kong.service.request.set_raw_query()`.


**Phases**

* `rewrite`, `access`

**Parameters**

* **args** (table):  A table where each key is a string (corresponding to an
   argument name), and each value is either a boolean, a string or an array of
   strings or booleans. Any string values given are URL-encoded.

**Returns**

*  Nothing; throws an error on invalid inputs.


**Usage**

``` lua
kong.service.request.set_query({
  foo = "hello world",
  bar = {"baz", "bla", true},
  zzz = true,
  blo = ""
})
-- Will produce the following query string:
-- bar=baz&bar=bla&bar&blo=&foo=hello%20world&zzz
```

[Back to top](#kongservicerequest)


### kong.service.request.set_header(header, value)

Sets a header in the request to the Service with the given value.  Any existing header
 with the same name will be overridden.

 If the `header` argument is `"host"` (case-insensitive), then this is
 will also set the SNI of the request to the Service.


**Phases**

* `rewrite`, `access`

**Parameters**

* **header** (string):  The header name. Example: "X-Foo"
* **value** (string|boolean|number):  The header value. Example: "hello world"

**Returns**

*  Nothing; throws an error on invalid inputs.


**Usage**

``` lua
kong.service.request.set_header("X-Foo", "value")
```

[Back to top](#kongservicerequest)


### kong.service.request.add_header(header, value)

Adds a request header with the given value to the request to the Service.  Unlike
 `kong.service.request.set_header()`, this function will not remove any existing
 headers with the same name. Instead, several occurences of the header will be
 present in the request. The order in which headers are added is retained.


**Phases**

* `rewrite`, `access`

**Parameters**

* **header** (string):  The header name. Example: "Cache-Control"
* **value** (string|number|boolean):  The header value. Example: "no-cache"

**Returns**

*  Nothing; throws an error on invalid inputs.


**Usage**

``` lua
kong.service.request.add_header("Cache-Control", "no-cache")
kong.service.request.add_header("Cache-Control", "no-store")
```

[Back to top](#kongservicerequest)


### kong.service.request.clear_header(header)

Removes all occurrences of the specified header in the request to the Service.

**Phases**

* `rewrite`, `access`

**Parameters**

* **header** (string):  The header name. Example: "X-Foo"

**Returns**

*  Nothing; throws an error on invalid inputs.
   The function does not throw an error if no header was removed.


**Usage**

``` lua
kong.service.request.set_header("X-Foo", "foo")
kong.service.request.add_header("X-Foo", "bar")
kong.service.request.clear_header("X-Foo")
-- from here onwards, no X-Foo headers will exist in the request
```

[Back to top](#kongservicerequest)


### kong.service.request.set_headers(headers)

Sets the headers of the request to the Service.  Unlike
 `kong.service.request.set_header()`, the `headers` argument must be a table in
 which each key is a string (corresponding to a header's name), and each value
 is a string, or an array of strings.

 The resulting headers are produced in lexicographical order. The order of
 entries with the same name (when values are given as an array) is retained.

 This function overrides any existing header bearing the same name as those
 specified in the `headers` argument. Other headers remain unchanged.

 If the `"Host"` header is set (case-insensitive), then this is
 will also set the SNI of the request to the Service.

**Phases**

* `rewrite`, `access`

**Parameters**

* **headers** (table):  A table where each key is a string containing a header name
   and each value is either a string or an array of strings.

**Returns**

*  Nothing; throws an error on invalid inputs.


**Usage**

``` lua
kong.service.request.set_header("X-Foo", "foo1")
kong.service.request.add_header("X-Foo", "foo2")
kong.service.request.set_header("X-Bar", "bar1")
kong.service.request.set_headers({
  ["X-Foo"] = "foo3",
  ["Cache-Control"] = { "no-store", "no-cache" },
  ["Bla"] = "boo"
})

-- Will add the following headers to the request, in this order:
-- X-Bar: bar1
-- Bla: boo
-- Cache-Control: no-store
-- Cache-Control: no-cache
-- X-Foo: foo3
```

[Back to top](#kongservicerequest)


### kong.service.request.set_raw_body(body)

Sets the body of the request to the Service.

 The `body` argument must be a string and will not be processed in any way.
 This function also sets the `Content-Length` header appropriately. To set an
 empty body, one can give an empty string `""` to this function.

 For a higher-level function to set the body based on the request content type,
 see `kong.service.request.set_body()`.

**Phases**

* `rewrite`, `access`

**Parameters**

* **body** (string):  The raw body

**Returns**

*  Nothing; throws an error on invalid inputs.


**Usage**

``` lua
kong.service.request.set_raw_body("Hello, world!")
```

[Back to top](#kongservicerequest)


### kong.service.request.set_body(args[, mimetype])

Sets the body of the request to the Service.  Unlike
 `kong.service.request.set_raw_body()`, the `args` argument must be a table, and
 will be encoded with a MIME type.  The encoding MIME type can be specified in
 the optional `mimetype` argument, or if left unspecified, will be chosen based
 on the `Content-Type` header of the client's request.

 If the MIME type is `application/x-www-form-urlencoded`:

 * Encodes the arguments as form-encoded: keys are produced in lexicographical
   order. The order of entries within the same key (when values are
   given as an array) is retained. Any string values given are URL-encoded.

 If the MIME type is `multipart/form-data`:

 * Encodes the arguments as multipart form data.

 If the MIME type is `application/json`:

 * Encodes the arguments as JSON (same as
   `kong.service.request.set_raw_body(json.encode(args))`)
 * Lua types are converted to matching JSON types.mej

 If none of the above, returns `nil` and an error message indicating the
 body could not be encoded.

 The optional argument `mimetype` can be one of:

 * `application/x-www-form-urlencoded`
 * `application/json`
 * `multipart/form-data`

 If the `mimetype` argument is specified, the `Content-Type` header will be
 set accordingly in the request to the Service.

 If further control of the body generation is needed, a raw body can be given as
 a string with `kong.service.request.set_raw_body()`.


**Phases**

* `rewrite`, `access`

**Parameters**

* **args** (table):  A table with data to be converted to the appropriate format
 and stored in the body.
* **mimetype** (string, _optional_):  can be one of:

**Returns**

1.  `boolean|nil` `true` on success, `nil` otherwise

1.  `string|nil` `nil` on success, an error message in case of error.
 Throws an error on invalid inputs.


**Usage**

``` lua
kong.service.set_header("application/json")
local ok, err = kong.service.request.set_body({
  name = "John Doe",
  age = 42,
  numbers = {1, 2, 3}
})

-- Produces the following JSON body:
-- { "name": "John Doe", "age": 42, "numbers":[1, 2, 3] }

local ok, err = kong.service.request.set_body({
  foo = "hello world",
  bar = {"baz", "bla", true},
  zzz = true,
  blo = ""
}, "application/x-www-form-urlencoded")

-- Produces the following body:
-- bar=baz&bar=bla&bar&blo=&foo=hello%20world&zzz
```

[Back to top](#kongservicerequest)
