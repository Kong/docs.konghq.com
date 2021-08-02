---
name: Response Transformer
publisher: Kong Inc.
version: 1.0.x

desc: Modify the upstream response before returning it to the client
description: |
  Transform the response sent by the upstream server on the fly before returning the response to the client.

  <div class="alert alert-warning">
    <strong>Note on transforming bodies:</strong> Be aware of the performance of transformations
    on the response body. In order to parse and modify a JSON body, the plugin needs to retain it in memory,
    which might cause pressure on the worker's Lua VM when dealing with large bodies (several MBs).
    Because of Nginx's internals, the `Content-Length` header will not be set when transforming a response body.
  </div>

  For additional response transformation features, check out the
  [Response Transformer Advanced plugin](/hub/kong-inc/response-transformer-advanced/).

type: plugin
categories:
  - transformations

kong_version_compatibility:
    community_edition:
      compatible:
        - 2.4.x
        - 2.3.x
        - 2.2.x
        - 2.1.x
        - 2.0.x
        - 1.5.x
        - 1.4.x
        - 1.3.x
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
    enterprise_edition:
      compatible:
        - 2.4.x
        - 2.3.x
        - 2.2.x
        - 2.1.x
        - 1.5.x
        - 1.3-x
        - 0.36-x


params:
  name: response-transformer
  service_id: true
  route_id: true
  consumer_id: true
  protocols: ["http", "https"]
  dbless_compatible: yes
  config:
    - name: remove.headers
      required: false
      value_in_examples: ["x-toremove", "x-another-one"]
      datatype: array of string elements
      description: List of header names. Unset the header(s) with the given name.
    - name: remove.json
      required: false
      value_in_examples: ["json-key-toremove", "another-json-key"]
      datatype: array of string elements
      description: List of property names. Remove the property from the JSON body if it is present.
    - name: rename.headers
      required: false
      datatype: array of string elements
      description: List of `original_header_name:new_header_name` pairs. If the header `original_headername` is already set, rename it to `new_headername`. Ignored if the header is not already set.
    - name: replace.headers
      required: false
      datatype: array of string elements
      description: List of `headername:value` pairs. If and only if the header is already set, replace its old value with the new one. Ignored if the header is not already set.
    - name: replace.json
      required: false
      datatype: array of string elements
      description: List of `property:value` pairs. If and only if the parameter is already present, replace its old value with the new one. Ignored if the parameter is not already present.
    - name: replace.json_types
      required: false
      datatype: array of string elements
      description: |
        List of JSON type names. Specify the types of the JSON values returned when
        replacing JSON properties. Each string
        element can be one of: boolean, number, or string.
    - name: add.headers
      required: false
      value_in_examples: ["x-new-header:value","x-another-header:something"]
      datatype: array of string elements
      description: List of `headername:value` pairs. If and only if the header is not already set, set a new header with the given value. Ignored if the header is already set.
    - name: add.json
      required: false
      value_in_examples: ["new-json-key:some_value", "another-json-key:some_value"]
      datatype: array of string elements
      description: List of `property:value` pairs. If and only if the property is not present, add a new property with the given value to the JSON body. Ignored if the property is already present.
    - name: add.json_types
      required: false
      value_in_examples: ["new-json-key:string", "another-json-key:boolean", "another-json-key:number"]
      datatype: array of string elements
      description: |
        List of JSON type names. Specify the types of the JSON values returned when adding
        a new JSON property. Each string element can be one of: boolean, number, or string.
    - name: append.headers
      required: false
      value_in_examples: ["x-existing-header:some_value", "x-another-header:some_value"]
      datatype: array of string elements
      description: |
        List of `headername:value` pairs. If the header is not set, set it with the given value. If it is
        already set, a new header with the same name and the new value will be set. Each string
        element can be one of: boolean, number, or string.
    - name: append.json
      required: false
      datatype: array of string elements
      description: List of `property:value` pairs. If the property is not present in the JSON body, add it with the given value. If it is already present, the two values (old and new) will be aggregated in an array.
    - name: append.json_types
      required: false
      datatype: array of string elements
      description: |
        List of JSON type names. Specify the types of the JSON values returned when appending
        JSON properties. Each string element can be one of: boolean, number, or string.

---

Note: if the value contains a `,` then the comma separated format for lists cannot be used. The array notation must be used instead.

## Order of execution

Plugin performs the response transformation in following order

remove --> rename --> replace --> add --> append

## Examples

In these examples we have the plugin enabled on a Route. This would work
similar for Services.

- Add multiple headers by passing each header:value pair separately:

{% navtabs %}
{% navtab With a database %}

```bash
$ curl -X POST http://localhost:8001/routes/{route}/plugins \
  --data "name=response-transformer" \
  --data "config.add.headers[1]=h1:v1" \
  --data "config.add.headers[2]=h2:v1"
```
{% endnavtab %}
{% navtab Without a database %}

```yaml
plugins:
- name: response-transformer
  route: {route}
  config:
    add:
      headers: ["h1:v1", "h2:v2"]
```

{% endnavtab %}
{% endnavtabs %}

<table>
  <tr>
    <th>upstream response headers</th>
    <th>proxied response headers</th>
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

- Add multiple headers by passing comma separated header:value pair (only possible with a database):

```bash
$ curl -X POST http://localhost:8001/routes/{route}/plugins \
  --data "name=response-transformer" \
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

- Add multiple headers passing config as JSON body (only possible with a database):

```bash
$ curl -X POST http://localhost:8001/routes/{route}/plugins \
  --header 'content-type: application/json' \
  --data '{"name": "response-transformer", "config": {"add": {"headers": ["h1:v2", "h2:v1"]}}}'
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

{% navtabs %}
{% navtab With a database %}

```bash
$ curl -X POST http://localhost:8001/routes/{route}/plugins \
  --data "name=response-transformer" \
  --data "config.add.json=p1:v1,p2=v2" \
  --data "config.add.headers=h1:v1"
```
{% endnavtab %}
{% navtab Without a database %}

```yaml
plugins:
- name: response-transformer
  route: {route}
  config:
    add:
      json: ["p1:v1", "p2=v2"]
      headers: ["h1:v1"]
```
{% endnavtab %}
{% endnavtabs %}

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

{% navtabs %}
{% navtab With a database %}

```bash
$ curl -X POST http://localhost:8001/routes/{route}/plugins \
  --header 'content-type: application/json' \
  --data '{"name": "response-transformer", "config": {"append": {"headers": ["h1:v2", "h2:v1"]}, "remove": {"json": ["p1"]}}}'
```

{% endnavtab %}
{% navtab Without a database %}

```yaml
plugins:
- name: response-transformer
  route: {route}
  config:
    append:
      headers: ["h1:v2", "h2:v1"]
    remove:
      json: ["p1"]
```
{% endnavtab %}
{% endnavtabs %}

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

| upstream response JSON body | proxied response body |
| ---           | --- |
| {"p2": "v2"}   | {"p2": "v2"} |
| {"p1" : "v1", "p2" : "v1"}  | {"p2": "v2"} |


- Explicitly set the type of the added JSON value `-1` to be a `number` (instead of the implicitly inferred type `string`) if the response code is 500:

```
$ curl -X POST http://localhost:8001/routes/{route}/plugins \
  --data "name=response-transformer" \
  --data "config.add.json=p1:-1" \
  --data "config.add.json_types=number"
```

[api-object]: /gateway-oss/latest/admin-api/#api-object
[consumer-object]: /gateway-oss/latest/admin-api/#consumer-object
[configuration]: /gateway-oss/latest/configuration

