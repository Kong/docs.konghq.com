---
name: Request Transformer
publisher: Kong Inc.
version: 1.2.0

desc: Modify the request before hitting the upstream server
description: |
  Transform the request sent by a client on the fly on Kong, before hitting the upstream server.

  <div class="alert alert-warning">
    <strong>Note:</strong> The functionality of this plugin as bundled
    with versions of Kong prior to 0.10.0
    differs from what is documented herein. Refer to the
    <a href="https://github.com/Kong/kong/blob/master/CHANGELOG.md">CHANGELOG</a>
    for details.
  </div>

type: plugin
categories:
  - transformations

kong_version_compatibility:
    community_edition:
      compatible:
        - 1.2.x
        - 1.1.x
        - 1.0.x
        - 0.14.x
        - 0.13.x
        - 0.12.x
        - 0.11.x
        - 0.10.x
        - 0.9.x
        - 0.8.x
        - 0.7.x
        - 0.6.x
        - 0.5.x
        - 0.4.x
        - 0.3.x
    enterprise_edition:
      compatible:
        - 0.35-x
        - 0.34-x
        - 0.33-x
        - 0.32-x

params:
  name: request-transformer
  service_id: true
  route_id: true
  consumer_id: true
  protocols: ["http", "https"]
  dbless_compatible: yes
  config:
    - name: http_method
      required: false
      description: Changes the HTTP method for the upstream request.
    - name: remove.headers
      required: false
      value_in_examples: "x-toremove, x-another-one"
      description: List of header names. Unset the header(s) with the given name.
    - name: remove.querystring
      required: false
      value_in_examples: "qs-old-name:qs-new-name, qs2-old-name:qs2-new-name"
      description: List of querystring names. Remove the querystring if it is present.
    - name: remove.body
      required: false
      value_in_examples: "formparam-toremove, formparam-another-one"
      description: List of parameter names. Remove the parameter if and only if content-type is one the following [`application/json`, `multipart/form-data`,  `application/x-www-form-urlencoded`] and parameter is present.
    - name: replace.headers
      required: false
      description: List of headername:value pairs. If and only if the header is already set, replace its old value with the new one. Ignored if the header is not already set.
    - name: replace.querystring
      required: false
      description: List of queryname:value pairs. If and only if the field name is already set, replace its old value with the new one. Ignored if the field name is not already set.
    - name: replace.uri
      required: false
      default:
      value_in_examples:
      description: |
        Updates the upstream request URI with given value. This value can only be used to update the path part of the URI, not the scheme, nor the hostname.
    - name: replace.body
      required: false
      description: List of paramname:value pairs. If and only if content-type is one the following [`application/json`, `multipart/form-data`, `application/x-www-form-urlencoded`] and the parameter is already present, replace its old value with the new one. Ignored if the parameter is not already present.
    - name: rename.headers
      required: false
      value_in_examples: "header-old-name:header-new-name, another-old-name:another-new-name"
      description: List of headername:value pairs. If and only if the header is already set, rename the header. The value is unchanged. Ignored if the header is not already set.
    - name: rename.querystring
      required: false
      value_in_examples: "qs-old-name:qs-new-name, qs2-old-name:qs2-new-name"
      description: List of queryname:value pairs. If and only if the field name is already set, rename the field name. The value is unchanged. Ignored if the field name is not already set.
    - name: rename.body
      required: false
      value_in_examples: "param-old:param-new, param2-old:param2-new"
      description: List of parameter name:value pairs. Rename the parameter name if and only if content-type is one the following [`application/json`, `multipart/form-data`,  `application/x-www-form-urlencoded`] and parameter is present.
    - name: add.headers
      required: false
      value_in_examples: "x-new-header:value,x-another-header:something"
      description: List of headername:value pairs. If and only if the header is not already set, set a new header with the given value. Ignored if the header is already set.
    - name: add.querystring
      required: false
      value_in_examples: "new-param:some_value, another-param:some_value"
      description: List of queryname:value pairs. If and only if the querystring is not already set, set a new querystring with the given value. Ignored if the header is already set.
    - name: add.body
      required: false
      value_in_examples: "new-form-param:some_value, another-form-param:some_value"
      description: List of pramname:value pairs. If and only if content-type is one the following [`application/json`, `multipart/form-data`, `application/x-www-form-urlencoded`] and the parameter is not present, add a new parameter with the given value to form-encoded body. Ignored if the parameter is already present.
    - name: append.headers
      required: false
      value_in_examples: "x-existing-header:some_value, x-another-header:some_value"
      description: List of headername:value pairs. If the header is not set, set it with the given value. If it is already set, a new header with the same name and the new value will be set.
    - name: append.querystring
      required: false
      description: List of queryname:value pairs. If the querystring is not set, set it with the given value. If it is already set, a new querystring with the same name and the new value will be set.
    - name: append.body
      required: false
      description: List of paramname:value pairs. If the content-type is one the following [`application/json`, `application/x-www-form-urlencoded`], add a new parameter with the given value if the parameter is not present, otherwise if it is already present, the two values (old and new) will be aggregated in an array.
  extra: |
    Note: if the value contains a `,` then the comma-separated format for lists cannot be used. The array notation must be used instead.

---

## Template as Value

User can use any of the the current request headers, query params, and captured URI named groups as template to populate above supported config fields.

| Request Param | Template
| --------- | -----------
| header | $(headers.<header_name> or $(headers['<header-name>']) or 'optional_default')
| querystring | $(query_params.<query_param_name> or $(query_params['query-param-name']) or 'optional_default')
| captured URIs | $(uri_captures.<group_name> or $(uri_captures['group-name']) or 'optional_default')

To escape a template, wrap it inside quotes and pass inside another template.<br>
Ex. $('$(some_needs_to_escaped)')

Note: Plugin creates a non mutable table of request headers, querystrings, and captured URIs before transformation. So any update or removal of params used in template does not affect the rendered value of template.

## Order of execution

Plugin performs the response transformation in following order

remove --> rename --> replace --> add --> append

## Examples

In these examples we have the plugin enabled on a Service. This would work
similarly for Routes.

- Add multiple headers by passing each header:value pair separately:

```bash
$ curl -X POST http://localhost:8001/services/example-service/plugins \
  --data "name=request-transformer" \
  --data "config.add.headers[1]=h1:v1" \
  --data "config.add.headers[2]=h2:v1"
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

- Add multiple headers by passing comma separated header:value pair:

```bash
$ curl -X POST http://localhost:8001/services/example-service/plugins \
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

- Add multiple headers passing config as JSON body:

```bash
$ curl -X POST http://localhost:8001/services/example-service/plugins \
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

```bash
$ curl -X POST http://localhost:8001/services/example-service/plugins \
  --data "name=request-transformer" \
  --data "config.add.querystring=q1:v2,q2:v1" \
  --data "config.add.headers=h1:v1"
```

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

```bash
$ curl -X POST http://localhost:8001/services/example-service/plugins \
  --header 'content-type: application/json' \
  --data '{"name": "request-transformer", "config": {"append": {"headers": ["h1:v2", "h2:v1"]}, "remove": {"body": ["p1"]}}}'
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
        <li>h1: v2</li>
        <li>h2: v1</li>
      </ul>
    </td>
  </tr>
</table>

|incoming url encoded body | upstream proxied url encoded body:
|---           | ---
|p1=v1&p2=v1   | p2=v1
|p2=v1         | p2=v1

[api-object]: /latest/admin-api/#api-object
[consumer-object]: /latest/admin-api/#consumer-object
[configuration]: /latest/configuration
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?

### Examples Using Template as Value

Add an API `test` with `uris` configured with a named capture group `user_id`

```bash
$ curl -X POST http://localhost:8001/apis \
    --data 'name=test' \
    --data 'upstream_url=http://mockbin.com' \
    --data-urlencode 'uris=/requests/user/(?<user_id>\w+)' \
    --data "strip_uri=false"
```

Enable the ‘request-transformer plugin to add a new header `x-consumer-id` and
its value is being set with the value sent with header `x-user-id` or with the
default value alice is `header` is missing.

```bash
$ curl -X POST http://localhost:8001/apis/test/plugins \
    --data "name=request-transformer" \
    --data-urlencode "config.add.headers=x-consumer-id:\$(headers['x-user-id'] or 'alice')" \
    --data "config.remove.headers=x-user-id"
```

Now send a request without setting header `x-user-id`

```bash
$ curl -i -X GET localhost:8000/requests/user/foo
```

Plugin will add a new header `x-consumer-id` with value alice before proxying
request upstream. Now try sending request with header `x-user-id` set

```bash
$ curl -i -X GET localhost:8000/requests/user/foo \
  -H "X-User-Id:bob"
```

This time plugin will add a new header `x-consumer-id` with value sent along
with header `x-user-id`, i.e.`bob`
