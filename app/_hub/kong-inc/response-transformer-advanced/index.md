---
name: Response Transformer Advanced
publisher: Kong Inc.
version: 0.35-x

desc: Modify the upstream response before returning it to the client
description: |
  Transform the response sent by the upstream server on the fly on Kong, before returning the response to the client.

  <div class="alert alert-warning">
    <strong>Note on transforming bodies:</strong> Be aware of the performance of transformations on the response body. In order to parse and modify a JSON body, the plugin needs to retain it in memory, which might cause pressure on the worker's Lua VM when dealing with large bodies (several MBs). Because of Nginx's internals, the `Content-Length` header will not be set when transforming a response body.
  </div>

type: plugin
categories:
  - transformations

kong_version_compatibility:
    enterprise_edition:
      compatible:
        - 0.35-x

params:
  name: response-transformer-advanced
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: remove.headers
      required: false
      value_in_examples: "x-toremove, x-another-one"
      description: List of header names. Unset the header(s) with the given name.
    - name: remove.json
      required: false
      value_in_examples: "json-key-toremove, another-json-key"
      description: List of property names. Remove the property from the JSON body if it is present.
    - name: remove.if_status
      required: false
      description: List of response status codes or status code ranges to which the transformation will apply. Empty means all response codes.
    - name: replace.headers
      required: false
      description: List of headername:value pairs. If and only if the header is already set, replace its old value with the new one. Ignored if the header is not already set.
    - name: replace.json
      required: false
      description: List of property:value pairs. If and only if the parameter is already present, replace its old value with the new one. Ignored if the parameter is not already present.
    - name: replace.body
      required: false
      description: String with which to replace the entire response body
    - name: replace.if_status
      required: false
      description: List of response status codes or status code ranges to which the transformation will apply. Empty means all response codes
    - name: add.headers
      required: false
      value_in_examples: "x-new-header:value,x-another-header:something"
      description: List of headername:value pairs. If and only if the header is not already set, set a new header with the given value. Ignored if the header is already set.
    - name: add.json
      required: false
      value_in_examples: "new-json-key:some_value, another-json-key:some_value"
      description: List of property:value pairs. If and only if the property is not present, add a new property with the given value to the JSON body. Ignored if the property is already present.
    - name: add.if_status
      required: false
      description: List of response status codes or status code ranges to which the transformation will apply. Empty means all response codes
    - name: append.headers
      required: false
      value_in_examples: "x-existing-header:some_value, x-another-header:some_value"
      description: List of headername:value pairs. If the header is not set, set it with the given value. If it is already set, a new header with the same name and the new value will be set.
    - name: append.json
      required: false
      description: List of property:value pairs. If the property is not present in the JSON body, add it with the given value. If it is already present, the two values (old and new) will be aggregated in an array.
    - name: append.if_status
      required: false
      description: List of response status codes or status code ranges to which the transformation will apply. Empty means all response codes

---

Note: if the value contains a `,` then the comma separated format for lists cannot be used. The array notation must be used instead.

## Order of execution

Plugin performs the response transformation in following order

remove --> replace --> add --> append

## Examples

In these examples we have the plugin enabled on a Route. This would work
similar for Services.

- Add multiple headers by passing each header:value pair separately:

```bash
$ curl -X POST http://localhost:8001/routes/{route id}/plugins \
  --data "name=response-transformer-advanced" \
  --data "config.add.headers[1]=h1:v1" \
  --data "config.add.headers[2]=h2:v1"
```

<table>
  <tr>
    <th>upstream response headers</th>
    <th>proxied response headers</th>
  </tr>
  <tr>
    <td>h1: v1</td>
    <td>
     <ul><li>h1: v1</li><li>h2: v1</li></ul>
    </td>
  </tr>
</table>

- Add multiple headers by passing comma separated header:value pair:

```bash
$ curl -X POST http://localhost:8001/routes/{route id}/plugins \
  --data "name=response-transformer-advanced" \
  --data "config.add.headers=h1:v1,h2:v2"
```

<table>
  <tr>
    <th>upstream response headers</th>
    <th>proxied response headers</th>
  </tr>
  <tr>
    <td>h1: v1</td>
    <td>
      <ul><li>h1: v1</li><li>h2: v1</li></ul>
    </td>
  </tr>
</table>


- Add multiple headers passing config as JSON body:

```bash
$ curl -X POST http://localhost:8001/routes/{route id}/plugins \
  --header 'content-type: application/json' \
  --data '{"name": "response-transformer-advanced", "config": {"add": {"headers": ["h1:v2", "h2:v1"]}}}'
```

<table>
  <tr>
    <th>upstream response headers</th>
    <th>proxied response headers</th>
  </tr>
  <tr>
    <td>h1: v1</td>
    <td>
      <ul><li>h1: v1</li><li>h2: v1</li></ul>
    </td>
  </tr>
</table>

- Add a body property and a header:

```bash
$ curl -X POST http://localhost:8001/routes/{route id}/plugins \
  --data "name=response-transformer-advanced" \
  --data "config.add.json=p1:v1,p2=v2" \
  --data "config.add.headers=h1:v1"
```

<table>
  <tr>
    <th>upstream response headers</th>
    <th>proxied response headers</th>
  </tr>
  <tr>
    <td>h1: v2</td>
    <td>
      <ul><li>h1: v2</li><li>h2: v1</li></ul>
    </td>
  </tr>
  <tr>
    <td>h3: v1</td>
    <td>
      <ul><li>h1: v1</li><li>h2: v1</li><li>h3: v1</li></ul>
    </td>
  </tr>
</table>


| upstream response JSON body | proxied response body |
| ---           | --- |
| {}            | {"p1" : "v1", "p2": "v2"} |
| {"p1" : "v2"}  | {"p1" : "v2", "p2": "v2"} |

- Append multiple headers and remove a body property:

```bash
$ curl -X POST http://localhost:8001/routes/{route id}/plugins \
  --header 'content-type: application/json' \
  --data '{"name": "response-transformer-advanced", "config": {"append": {"headers": ["h1:v2", "h2:v1"]}, "remove": {"json": ["p1"]}}}'
```

<table>
  <tr>
    <th>upstream response headers</th>
    <th>proxied response headers</th>
  </tr>
  <tr>
    <td>h1: v1</td>
    <td>
      <ul><li>h1: v1</li><li>h1: v2</li><li>h2: v1</li></ul>
    </td>
  </tr>
</table>

|upstream response JSON body | proxied response body |
|---           | --- |
|{"p2": "v2"}   | {"p2": "v2"} |
|{"p1" : "v1", "p2" : "v1"}  | {"p2": "v2"} |

- Replace entire response body if response code is 500

```
$ curl -X POST http://localhost:8001/routes/{route id}/plugins \
  --data "name=response-transformer-advanced" \
  --data "config.replace.body='{\"error\": \"internal server error\"}'" \
  --data "config.replace.if_status=500"
```

**Note**: the plugin doesn't validate the value in `config.replace.body` against
the content type as defined in the `Content-Type` response header.

[api-object]: /latest/admin-api/#api-object
[consumer-object]: /latest/admin-api/#consumer-object
[configuration]: /latest/configuration
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
