---
name: Request Transformer
publisher: Kong Inc.
version: 1.3.x
desc: 'Use regular expressions, variables, and templates to transform requests'
description: |
  The Request Transformer plugin for Kong allows simple transformation of requests
  before they reach the upstream server. These transformations can be simple substitutions
  or complex ones matching portions of incoming requests using regular expressions, saving
  those matched strings into variables, and substituting those strings into transformed requests using flexible templates.
type: plugin
categories:
  - transformations
kong_version_compatibility:
  community_edition:
    compatible:
      - 2.8.x
      - 2.7.x
      - 2.6.x
      - 2.5.x
      - 2.4.x
  enterprise_edition:
    compatible:
      - 2.8.x
      - 2.7.x
      - 2.6.x
      - 2.5.x
      - 2.4.x
params:
  name: request-transformer
  service_id: true
  route_id: true
  consumer_id: true
  konnect_examples: false
  protocols:
    - http
    - https
  dbless_compatible: 'yes'
  config:
    - name: http_method
      required: false
      datatype: string
      description: Sets the HTTP method for the upstream request.
    - name: remove.headers
      required: false
      value_in_examples:
        - x-toremove
        - x-another-one
      datatype: array of string elements
      description: List of header names. Unset the headers with the given name.
    - name: remove.querystring
      required: false
      value_in_examples:
        - 'qs-old-name:qs-new-name'
        - 'qs2-old-name:qs2-new-name'
      datatype: array of string elements
      description: List of querystring names. Remove the querystring if it is present.
    - name: remove.body
      required: false
      value_in_examples:
        - formparam-toremove
        - formparam-another-one
      datatype: array of string elements
      description: |
        List of parameter names. Remove the parameter if and only if content-type is one the following:
        [`application/json`, `multipart/form-data`, `application/x-www-form-urlencoded`] and the parameter is present.
    - name: replace.uri
      required: false
      datatype: string
      description: |
        Updates the upstream request URI with a given value. This value can be used to update
        only the path part of the URI, not the scheme or the hostname.
    - name: replace.body
      required: false
      value_in_examples:
        - 'body-param1:new-value-1'
        - 'body-param2:new-value-2'
      datatype: array of string elements
      description: |
        List of `paramname:value` pairs. If and only if content-type is one the following
        [`application/json`, `multipart/form-data`, `application/x-www-form-urlencoded`] and the
        parameter is already present, replace its old value with the new one. Ignored if
        the parameter is not already present.
    - name: replace.headers
      required: false
      datatype: array of string elements
      description: |
        List of `headername:value` pairs. If and only if the header is already set, replace
        its old value with the new one. Ignored if the header is not already set.
    - name: replace.querystring
      required: false
      datatype: array of string elements
      description: |
        List of `queryname:value pairs`. If and only if the field name is already set,
        replace its old value with the new one. Ignored if the field name is not already set.
    - name: rename.headers
      required: false
      value_in_examples:
        - 'header-old-name:header-new-name'
        - 'another-old-name:another-new-name'
      datatype: array of string elements
      description: |
        List of `headername:value` pairs. If and only if the header is already set, rename
        the header. The value is unchanged. Ignored if the header is not already set.
    - name: rename.querystring
      required: false
      value_in_examples:
        - 'qs-old-name:qs-new-name'
        - 'qs2-old-name:qs2-new-name'
      datatype: array of string elements
      description: |
        List of queryname:value pairs. If and only if the field name is already set, rename the field name.
        The value is unchanged. Ignored if the field name is not already set.
    - name: rename.body
      required: false
      value_in_examples:
        - 'param-old:param-new'
        - 'param2-old:param2-new'
      datatype: array of string elements
      description: |
        List of `paramname:value` pairs. Rename the parameter name if and only if
        content-type is one the following [`application/json`, `multipart/form-data`, `application/x-www-form-urlencoded`]
        and the parameter is present.
    - name: replace.body
      required: false
      datatype: array of string elements
      description: |
        List of `paramname:value` pairs. If and only if content-type is one the following
        [`application/json`, `multipart/form-data`, `application/x-www-form-urlencoded`] and the parameter
        is already present, replace its old value with the new one. Ignored if the parameter is not already present.
    - name: add.headers
      required: false
      value_in_examples:
        - 'x-new-header:value'
        - 'x-another-header:something'
      datatype: array of string elements
      description: |
        List of `headername:value` pairs. If and only if the header is not already set, set a new header
        with the given value. Ignored if the header is already set.
    - name: add.querystring
      required: false
      value_in_examples:
        - 'new-param:some_value'
        - 'another-param:some_value'
      datatype: array of string elements
      description: |
        List of `queryname:value` pairs. If and only if the querystring is not already set, set a new
        querystring with the given value. Ignored if the header is already set.
    - name: add.body
      required: false
      value_in_examples:
        - 'new-form-param:some_value'
        - 'another-form-param:some_value'
      datatype: array of string elements
      description: |
        List of `paramname:value` pairs. If and only if content-type is one the
        following [`application/json`, `multipart/form-data`, `application/x-www-form-urlencoded`]
        and the parameter is not present, add a new parameter with the given value to the form-encoded
        body. Ignored if the parameter is already present.
    - name: append.headers
      required: false
      datatype: array of string elements
      description: |
        List of `headername:value` pairs. If the header is not set, set it with the given value.
        If it is already set, an additional new header with the same name and the new value will be appended.
    - name: append.querystring
      required: false
      datatype: array of string elements
      description: 'List of `queryname:value` pairs. If the querystring is not set, set it with the given value. If it is already set, a new querystring with the same name and the new value will be set.'
    - name: append.body
      required: false
      datatype: array of string elements
      description: |
        List of `paramname:value` pairs. If the content-type is one the following
        [`application/json`, `application/x-www-form-urlencoded`], add a new parameter
        with the given value if the parameter is not present. Otherwise, if it is already present,
        aggregate the two values (old and new) in an array.
  extra: |
    **Notes**:
    * If the value contains a `,` (comma), then the comma-separated format for lists cannot be used. The array
    notation must be used instead.
    * The `X-Forwarded-*` fields are non-standard header fields written by Nginx to inform the upstream about
    client details and can't be overwritten by this plugin. If you need to overwrite these header fields, see the
    [post-function plugin in Serverless Functions](https://docs.konghq.com/hub/kong-inc/serverless-functions/).
---

## Template as a Value

You can use any of the current request headers, query params, and captured URI
groups as templates to populate supported configuration fields.

| Request Param | Template
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
> **Note:** The plugin creates a non-mutable table of request headers, querystrings, and captured URIs
before transformation. Therefore, any update or removal of params used in a template
does not affect the rendered value of a template.

### Advanced templates

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

### Examples Using Template as a Value

Add a Service named `test` with `uris` configured with a named capture group `user_id`:

```bash
curl -X POST http://localhost:8001/services \
  --data 'name=test' \
  --data 'upstream_url=http://mockbin.com' \
  --data-urlencode 'uris=/requests/user/(?<user_id>\w+)' \
  --data "strip_uri=false"
```

Enable the `request-transformer` plugin to add a new header `x-consumer-id`
whose value is being set with the value sent with header `x-user-id` or
with the default value `alice`. The `header` is missing.

```bash
curl -X POST http://localhost:8001/services/test/plugins \
  --data "name=request-transformer" \
  --data-urlencode "config.add.headers=x-consumer-id:\$(headers['x-user-id'] or 'alice')" \
  --data "config.remove.headers=x-user-id"
```

Now send a request without setting header `x-user-id`:

```bash
curl -i -X GET localhost:8000/requests/user/foo
```

The plugin adds a new header `x-consumer-id` with the value `alice` before
proxying the request upstream.

Now try sending request with the header `x-user-id` set:

```bash
curl -i -X GET localhost:8000/requests/user/foo \
  -H "X-User-Id:bob"
```

This time, the plugin adds a new header `x-consumer-id` with the value sent along
with the header `x-user-id`, i.e.`bob`.

## Order of execution

This plugin performs the response transformation in the following order:

* remove → rename → replace → add → append

## Examples

{:.note}
> **Kubernetes users:** Version `v1beta1` of the Ingress
  specification does not allow the use of named regex capture groups in paths.
  If you use the ingress controller, you should use unnamed groups, e.g.
  `(\w+)/`instead of `(?&lt;user_id&gt;\w+)`. You can access
  these based on their order in the URL path. For example `$(uri_captures[1])`
  obtains the value of the first capture group.

In the following examples, the plugin is enabled on a Service. This would work
similarly for Routes.

- Add multiple headers by passing each `header:value` pair separately:

{% navtabs %}
{% navtab With a database %}
```bash
curl -X POST http://localhost:8001/services/example-service/plugins \
  --data "name=request-transformer" \
  --data "config.add.headers[1]=h1:v1" \
  --data "config.add.headers[2]=h2:v1"
```
{% endnavtab %}
{% navtab Without a database %}
```yaml
plugins:
- name: request-transformer
  config:
    add:
      headers: ["h1:v1", "h2:v1"]
```
{% endnavtab %}
{% endnavtabs %}

<table>
  <tr>
    <th>incoming request headers</th>
    <th>upstream proxied headers:</th>
  </tr>
  <tr>
    <td>h1: v1</td>
    <td>
      <ul>
        <li>h1: v1</li>
        <li>h2: v1</li>
      </ul>
    </td>
  </tr>
</table>

- Add multiple headers by passing comma-separated `header:value` pair (only possible with a database):

```bash
curl -X POST http://localhost:8001/services/example-service/plugins \
  --data "name=request-transformer" \
  --data "config.add.headers=h1:v1,h2:v2"
```

<table>
  <tr>
    <th>incoming request headers</th>
    <th>upstream proxied headers:</th>
  </tr>
  <tr>
    <td>h1: v1</td>
    <td>
      <ul>
        <li>h1: v1</li>
        <li>h2: v1</li>
      </ul>
    </td>
  </tr>
</table>

- Add multiple headers passing config as a JSON body (only possible with a database):

```bash
curl -X POST http://localhost:8001/services/example-service/plugins \
  --header 'content-type: application/json' \
  --data '{"name": "request-transformer", "config": {"add": {"headers": ["h1:v2", "h2:v1"]}}}'
```

<table>
  <tr>
    <th>incoming request headers</th>
    <th>upstream proxied headers:</th>
  </tr>
  <tr>
    <td>h1: v1</td>
    <td>
      <ul>
        <li>h1: v1</li>
        <li>h2: v1</li>
      </ul>
    </td>
  </tr>
</table>

- Add a querystring and a header:

{% navtabs %}
{% navtab With a database %}
```bash
curl -X POST http://localhost:8001/services/example-service/plugins \
  --data "name=request-transformer" \
  --data "config.add.querystring=q1:v2,q2:v1" \
  --data "config.add.headers=h1:v1"
```
{% endnavtab %}
{% navtab Without a database %}
```yaml
plugins:
- name: request-transformer
  config:
    add:
      headers: ["h1:v1"],
      querystring: ["q1:v1", "q2:v2"]

```
{% endnavtab %}
{% endnavtabs %}

<table>
  <tr>
    <th>incoming request headers</th>
    <th>upstream proxied headers:</th>
  </tr>
  <tr>
    <td>h1: v2</td>
    <td>
      <ul>
        <li>h1: v2</li>
        <li>h2: v1</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td>h3: v1</td>
    <td>
      <ul>
        <li>h1: v1</li>
        <li>h2: v1</li>
        <li>h3: v1</li>
      </ul>
    </td>
  </tr>
</table>

|incoming request querystring | upstream proxied querystring
|---           | ---
| ?q1=v1       |  ?q1=v1&q2=v1
|              |  ?q1=v2&q2=v1

- Append multiple headers and remove a body parameter:

{% navtabs %}
{% navtab With a database %}
```bash
curl -X POST http://localhost:8001/services/example-service/plugins \
  --header 'content-type: application/json' \
  --data '{"name": "request-transformer", "config": {"append": {"headers": ["h1:v2", "h2:v1"]}, "remove": {"body": ["p1"]}}}'
```
{% endnavtab %}
{% navtab Without a database %}
``` yaml
plugins:
- name: request-transformer
  config:
    add:
      headers: ["h1:v1", "h2:v1"]
    remove:
      body: [ "p1" ]

```
{% endnavtab %}
{% endnavtabs %}

<table>
  <tr>
    <th>incoming request headers</th>
    <th>upstream proxied headers:</th>
  </tr>
  <tr>
    <td>h1: v1</td>
    <td>
      <ul>
        <li>h1: v1</li>
        <li>h1: v2</li>
        <li>h2: v1</li>
      </ul>
    </td>
  </tr>
</table>

|incoming url encoded body | upstream proxied url encoded body
|---           | ---
|p1=v1&p2=v1   | p2=v1
|p2=v1         | p2=v1
