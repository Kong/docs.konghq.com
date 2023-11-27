---
nav_title: Using templates as values
title: Using templates as values
---

## Using templates as values

You can use any of the current request headers, query parameters, and captured URI
groups as templates to populate supported configuration fields.

| Request Parameter | Template
| ------------- | -----------
| header        | `$(headers.<header_name>)`, `$(headers["<Header-Name>"])` or `$(headers["<header-name>"])`)
| querystring   | `$(query_params.<query-param-name>)` or `$(query_params["<query-param-name>"])`)
| captured URIs | `$(uri_captures.<group-name>)` or `$(uri_captures["<group-name>"])`)

To escape a template, wrap it inside quotes and pass inside another template.
For example:

```
$('$(something_that_needs_to_escaped)')
```

{:.note}
> **Note:** The plugin creates a non-mutable table of request headers, query strings, and captured URIs
before transformation. Therefore, any update or removal of parameters used in a template
does not affect the rendered value of a template.

## Advanced templates {#advanced-templates}

The content of the placeholder `$(...)` is evaluated as a Lua expression, so
logical operators may be used. For example:

    Header-Name:$(uri_captures["user-id"] or query_params["user"] or "unknown")

This will first look for the path parameter (`uri_captures`). If not found, it will
return the query parameter. If that also doesn't exist, it returns the default
value '"unknown"'.

Constant parts can be specified as part of the template outside the dynamic
placeholders. For example, creating a basic-auth header from a query parameter
called `auth` that only contains the base64-encoded part:

    Authorization:Basic $(query_params["auth"])

Lambdas are also supported if wrapped as an expression like this:

    $((function() ... implementation here ... end)())

A complete Lambda example for prefixing a header value with "Basic" if not
already there:

    Authorization:$((function()
        local value = headers.Authorization
        if not value then
          return
        end
        if value:sub(1, 6) == "Basic " then
          return value            -- was already properly formed
        end
        return "Basic " .. value  -- added proper prefix
      end)())

{:.note}
> **Note:** Especially in multi-line templates like the example above, make sure not
to add any trailing white space or new lines. Because these would be outside the
placeholders, they would be considered part of the template, and hence would be
appended to the generated value.
The environment is sandboxed, meaning that Lambdas will not have access to any
library functions, except for the string methods (like `sub()` in the example
above).

## Examples using template as a value

Add a Service named `test` which routes requests to the httpbin.org upstream service:

```bash
curl -X POST http://localhost:8001/services \
    --data 'name=test' \
    --data 'url=http://httpbin.org/anything'
```

Create a route for the `test` service, capturing a `user_id` field from the third segment of the request path:

{:.note}
> **Kubernetes users:** Version `v1beta1` of the Ingress
  specification does not allow the use of named regex capture groups in paths.
  If you use the ingress controller, you should use unnamed groups, e.g.
  `(\w+)/`instead of `(?&lt;user_id&gt;\w+)`. You can access
  these based on their order in the URL path. For example `$(uri_captures[1])`
  obtains the value of the first capture group.
```bash
curl -X POST http://localhost:8001/services/test/routes \
  --data "name=test_user" \
  --data-urlencode 'paths=~/requests/user/(?<user_id>\w+)'
```

Enable the `request-transformer` plugin to add a new header, `x-user-id`,
whose value is being set from the captured group in the route path specified above:

```bash
curl -XPOST http://localhost:8001/routes/test_user/plugins \
  --data "name=request-transformer" \
  --data "config.add.headers=x-user-id:\$(uri_captures['user_id'])"
```

Now send a request with a user id in the route path:

```bash
curl -i -X GET localhost:8000/requests/user/foo
```

You should notice in the response that the `x-user-id` header has been added with a value of `foo`.