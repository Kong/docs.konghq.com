---
name: Request Transformer Advanced
publisher: Kong Inc.
desc: Use powerful regular expressions, variables, and templates to transform API requests
description: |
  Transform client requests before they reach the upstream server. The plugin lets you match portions of incoming requests using regular expressions, save those matched strings into variables, and substitute the strings into transformed requests via flexible templates.

  The Request Transformer Advanced plugin builds on the open-source [Request Transformer plugin](/hub/kong-inc/request-transformer/) with the following enhanced capability:
  * Limit the list of allowed parameters in the request body. Set this up with the `allow.body` configuration parameter.

enterprise: true
type: plugin
categories:
  - transformations
kong_version_compatibility:
  community_edition:
    compatible: null
  enterprise_edition:
    compatible: true
params:
  name: request-transformer-advanced
  service_id: true
  route_id: true
  consumer_id: true
  konnect_examples: false
  dbless_compatible: 'yes'
  config:
    - name: http_method
      required: false
      default: null
      value_in_examples: null
      datatype: string
      description: |
        Changes the HTTP method for the upstream request.
    - name: remove.headers
      required: false
      default: null
      value_in_examples:
        - x-toremove
        - x-another-one
      datatype: array of string elements
      description: |
        List of header names. Unset the headers with the given name.
    - name: remove.querystring
      required: false
      default: null
      value_in_examples:
        - 'qs-old-name:qs-new-name'
        - 'qs2-old-name:qs2-new-name'
      datatype: array of string elements
      description: |
        List of querystring names. Remove the querystring if it is present.
    - name: remove.body
      required: false
      default: null
      value_in_examples:
        - formparam-toremove
        - formparam-another-one
      datatype: array of string elements
      description: |
        List of parameter names. Remove the parameter if and only if content-type is one of the
        following: [`application/json`, `multipart/form-data`, `application/x-www-form-urlencoded`]; and parameter is present.
    - name: replace.headers
      required: false
      default: null
      value_in_examples: null
      datatype: array of string elements
      description: |
        List of headername:value pairs. If and only if the header is already set,
        replace its old value with the new one. Ignored if the header is not already set.
    - name: replace.querystring
      required: false
      default: null
      value_in_examples: null
      datatype: array of string elements
      description: |
        List of queryname:value pairs. If and only if the querystring name is already set,
        replace its old value with the new one. Ignored if the header is not already set.
    - name: replace.uri
      required: false
      default: null
      value_in_examples: null
      datatype: string
      description: |
        Updates the upstream request URI with given value. This value can only
        be used to update the path part of the URI; not the scheme, nor the hostname.
    - name: replace.body
      required: false
      default: null
      value_in_examples:
        - 'body-param1:new-value-1'
        - 'body-param2:new-value-2'
      datatype: array of string elements
      description: |
        List of paramname:value pairs. If and only if content-type is one the
        following: [`application/json`, `multipart/form-data`, `application/x-www-form-urlencoded`];
        and the parameter is already present, replace its old value with the new one. Ignored if the parameter is not already present.
    - name: rename.headers
      required: false
      default: null
      value_in_examples:
        - 'header-old-name:header-new-name'
        - 'another-old-name:another-new-name'
      datatype: array of string elements
      description: |
        List of `headername:value` pairs. If and only if the header is already set,
        rename the header. The value is unchanged. Ignored if the header is not already set.
    - name: rename.querystring
      required: false
      default: null
      value_in_examples:
        - 'qs-old-name:qs-new-name'
        - 'qs2-old-name:qs2-new-name'
      datatype: array of string elements
      description: |
        List of `queryname:value` pairs. If and only if the field name is already set,
        rename the field name. The value is unchanged. Ignored if the field name is not already set.
    - name: rename.body
      required: false
      default: null
      value_in_examples:
        - 'param-old:param-new'
        - 'param2-old:param2-new'
      datatype: array of string elements
      description: |
        List of parameter `name:value` pairs. Rename the parameter name if and only if content-type is
        one of the following: [`application/json`, `multipart/form-data`, `application/x-www-form-urlencoded`]; and parameter is present.
    - name: add.headers
      required: false
      default: null
      value_in_examples:
        - 'x-new-header:value'
        - 'x-another-header:something'
      datatype: array of string elements
      description: |
        List of `headername:value` pairs. If and only if the header is not already set,
        set a new header with the given value. Ignored if the header is already set.
    - name: add.querystring
      required: false
      default: null
      value_in_examples:
        - 'new-param:some_value'
        - 'another-param:some_value'
      datatype: array of string elements
      description: |
        List of `queryname:value` pairs. If and only if the querystring name is not already set,
        set a new querystring with the given value. Ignored if the querystring name is already set.
    - name: add.body
      required: false
      default: null
      value_in_examples: null
      datatype: array of string elements
      description: |
        List of `paramname:value` pairs. If and only if content-type is one the following: [`application/json, multipart/form-data`, `application/x-www-form-urlencoded`]; and the parameter is not present, add a new parameter with the given value to form-encoded body.
        Ignored if the parameter is already present.
    - name: append.headers
      required: false
      default: null
      value_in_examples: null
      datatype: array of string elements
      description: |
        List of `headername:value` pairs. If the header is not set, set it with the given value.
        If it is already set, a new header with the same name and the new value will be set.
    - name: append.querystring
      required: false
      default: null
      value_in_examples: null
      datatype: array of string elements
      description: |
        List of `queryname:value` pairs. If the querystring is not set, set it with the given value.
        If it is already set, a new querystring with the same name and the new value will be set.
    - name: append.body
      required: false
      default: null
      value_in_examples: null
      datatype: array of string elements
      description: |
        List of `paramname:value` pairs. If the content-type is one the following: [`application/json`, `application/x-www-form-urlencoded`]; add a new parameter with the given value if the parameter is not present. Otherwise, if it is already present,
        the two values (old and new) will be aggregated in an array.
    - name: allow.body
      required: false
      default: null
      value_in_examples: null
      datatype: array of string elements
      description: |
        Set of parameter names. If and only if content-type is one the following:
        [`application/json`, `multipart/form-data`, `application/x-www-form-urlencoded`]; allow only allowed parameters in the body.
  extra: |
    **Notes:**
    * If the value contains a `,` (comma), then the comma-separated format for lists cannot be used. The array
    notation must be used instead.
    * The `X-Forwarded-*` fields are non-standard header fields written by Nginx to inform the upstream about client details and can't be overwritten by this plugin. If you need to overwrite these header fields, see the [post-function plugin in Serverless Functions](https://docs.konghq.com/hub/kong-inc/serverless-functions/).
---

## Template as Value

You can use any of the current request headers, query parameters, and captured
URI groups as templates to populate supported config fields.

| Request Parameter | Template
| ------------- | -----------
| header        | `$(headers.<header-name>)` or `$(headers["<header-name>"])`)
| querystring   | `$(query_params.<query-param-name>)` or `$(query_params["<query-param-name>"])`)
| captured URIs | `$(uri_captures.<group-name>)` or `$(uri_captures["<group-name>"])`)

To escape a template, wrap it inside quotes and pass inside another template.
For example:

```
$('$(something_that_needs_to_escaped)')
```

{:.note}
> **Note**: The plugin creates a non-mutable table of request headers,
query strings, and captured URIs before transformation. So any update or removal
 of parameters used in the template does not affect the rendered value of template.

### Advanced templates

The content of the placeholder `$(...)` is evaluated as a Lua expression, so
logical operators may be used. For example:

    Header-Name:$(uri_captures["user-id"] or query_params["user"] or "unknown")

This will first look for the path parameter (`uri_captures`); if not found, it will
return the query parameter; or if that also doesn't exist, it returns the default
value '"unknown"'.

Constant parts can be specified as part of the template outside the dynamic
placeholders. For example, creating a basic-auth header from a query parameter
called `auth` that only contains the base64-encoded part:

    Authorization:Basic $(query_params["auth"])

Lambdas are also supported if wrapped as an expression like this:

    $((function() ... implementation here ... end)())

A complete lambda example for prefixing a header value with "Basic " if not
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
> **Note**: Especially in multi-line templates like the example above, make sure not
to add any trailing white-space or new-lines. Since these would be outside the
placeholders, they would be considered part of the template, and hence would be
appended to the generated value.

The environment is sandboxed, meaning that Lambda's will not have access to any
library functions, except for the string methods (like `sub()` in the example
above).

### Examples Using Template as Value

Add a Service named `test` which routes requests to the mockbin.com upstream service:

```bash
curl -X POST http://localhost:8001/services \
    --data 'name=test' \
    --data 'url=http://mockbin.com/requests'
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
curl -X POST http://localhost:8001/services/test/routes --data "name=test_user" \
    --data-urlencode 'paths=/requests/user/(?<user_id>\w+)'
```

Enable the `request-transformer-advanced` plugin to add a new header, `x-user-id`,
whose value is being set from the captured group in the route path specified above:

```bash
curl -XPOST http://localhost:8001/routes/test_user/plugins --data "name=request-transformer-advanced" --data "config.add.headers=x-user-id:\$(uri_captures['user_id'])"
```

Now send a request with a user id in the route path:

```bash
curl -i -X GET localhost:8000/requests/user/foo
```

You should notice in the response that the `x-user-id` header has been added with a value of `foo`.

## Order of Execution

This plugin performs the response transformation in the following order:

* remove → rename → replace → add → append

## Configuration Examples

Add multiple headers by passing each header:value pair separately:

```bash
curl -X POST http://localhost:8001/services/mockbin/plugins \
  --data "name=request-transformer-advanced" \
  --data "config.add.headers[1]=h1:v1" \
  --data "config.add.headers[2]=h2:v1"
```

| Incoming Request Headers | Upstream Proxied Headers
| --------- | -----------
| h1: v1 | h1: v1, h2: v1

Add multiple headers by passing comma separated header:value pair:

```bash
curl -X POST http://localhost:8001/services/mockbin/plugins \
  --data "name=request-transformer-advanced" \
  --data "config.add.headers=h1:v1,h2:v2"
```

| Incoming Request Headers | Upstream Proxied Headers
| --------- | -----------
| h1: v1 | h1: v1, h2: v1

Add multiple headers passing config as a JSON body:

```bash
curl -X POST http://localhost:8001/services/mockbin/plugins \
  --header 'content-type: application/json' \
  --data '{"name": "request-transformer-advanced", "config": {"add": {"headers": ["h1:v2", "h2:v1"]}}}'
```

| Incoming Request Headers | Upstream Proxied Headers
| --------- | -----------
| h1: v1 | h1: v1, h2: v1

Add a query string and a header:

```bash
curl -X POST http://localhost:8001/services/mockbin/plugins \
  --data "name=request-transformer-advanced" \
  --data "config.add.querystring=q1:v2,q2=v1" \
  --data "config.add.headers=h1:v1"

```

| Incoming Request Headers | Upstream Proxied Headers
| --------- | -----------
| h1: v1 | h1: v1, h2: v1
| h3: v1 | h1: v1, h2: v1, h3: v1

| Incoming Request Query String | Upstream Proxied Query String
| --------- | -----------
| ?q1=v1 | ?q1=v1&q2=v1
|        | ?q1=v2&q2=v1

Append multiple headers and remove a body parameter:

```bash
curl -X POST http://localhost:8001/services/mockbin/plugins \
  --data "name=request-transformer-advanced" \
  --data "config.add.headers=h1:v2,h2:v1" \
  --data "config.remove.body=p1" \
```

| Incoming Request Headers | Upstream Proxied Headers
| --------- | -----------
| h1: v1 | h1: v1, h1: v2, h2: v1

| Incoming URL Encoded Body | Upstream Proxied URL Encoded Body
| --------- | -----------
| p1=v1&p2=v1 | p2=v1
| p2=v1 | p2=v1

Add multiple headers and query string parameters if not already set:

```bash
curl -X POST http://localhost:8001/services/mockbin/plugins \
  --data "name=request-transformer-advanced" \
  --data "config.add.headers=h1:v1,h2:v1" \
  --data "config.add.querystring=q1:v2,q2:v1" \
```

| Incoming Request Headers | Upstream Proxied Headers
| --------- | -----------
| h1: v1 | h1: v1, h2: v1
| h3: v1 |  h1: v1, h2: v1, h3: v1

| Incoming Request Query String | Upstream Proxied Query String
| --------- | -----------
| ?q1=v1 | ?q1=v1&q2=v1
|        | ?q1=v2&q2=v1


---

## Changelog

**{{site.base_gateway}} 3.0.x**
- Removed the deprecated `whitelist` parameter.
It is no longer supported.

**{{site.base_gateway}} 2.1.x**

- Use `allow` instead of `whitelist`.
