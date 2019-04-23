---
name: Request Transformer
publisher: Kong Inc.
version: 1.0.0

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
        - 0.34-x
        - 0.33-x
        - 0.32-x

params:
  name: request-transformer
  service_id: true
  route_id: true
  consumer_id: true
  protocols: ["http", "https"]
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
    - name: append.headers
      required: false
      value_in_examples: "x-existing-header:some_value, x-another-header:some_value"
      description: List of headername:value pairs. If the header is not set, set it with the given value. If it is already set, a new header with the same name and the new value will be set.
    - name: replace.body
      required: false
      description: List of paramname:value pairs. If and only if content-type is one the following [`application/json`, `multipart/form-data`, `application/x-www-form-urlencoded`] and the parameter is already present, replace its old value with the new one. Ignored if the parameter is not already present.
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
      description: List of headername:value pairs. If the header is not set, set it with the given value. If it is already set, an additional new header with the same name and the new value will be appended.
    - name: append.querystring
      required: false
      description: List of queryname:value pairs. If the querystring is not set, set it with the given value. If it is already set, a new querystring with the same name and the new value will be set.
    - name: append.body
      required: false
      description: List of paramname:value pairs. If the content-type is one the following [`application/json`, `application/x-www-form-urlencoded`], add a new parameter with the given value if the parameter is not present, otherwise if it is already present, the two values (old and new) will be aggregated in an array.
  extra: |
    Note: if the value contains a `,` then the comma-separated format for lists cannot be used. The array notation must be used instead.

---

## Dynamic Transformation Based on Request Content

The Request Transformer plugin bundled with Kong Enterprise allows for
adding or replacing content in the upstream request based on variable data found
in the client request, such as request headers, query string parameters, or URI
parameters as defined by a URI capture group.

If you already are a Kong Enterprise customer, you can request access to this
plugin functionality by opening a support ticket using your Enterprise support
channels.

If you are not a Kong Enterprise customer, you can inquire about our
Enterprise offering by [contacting us](/enterprise).

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
