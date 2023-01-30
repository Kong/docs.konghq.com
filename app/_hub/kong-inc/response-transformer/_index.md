---
name: Response Transformer
publisher: Kong Inc.
desc: Modify the upstream response before returning it to the client
description: |
  Transform the response sent by the upstream server on the fly before returning the response to the client.

  For additional response transformation features, check out the
  [Response Transformer Advanced plugin](/hub/kong-inc/response-transformer-advanced/). Response Transformer
  Advanced adds the following abilities:

  * When transforming a JSON payload, transformations are applied to nested JSON objects and
    arrays. This can be turned off and on using the `config.dots_in_keys` configuration parameter.
    See [Response Transformer Advanced arrays and nested objects](/hub/kong-inc/response-transformer-advanced/#arrays-and-nested-objects).
  * Transformations can be restricted to responses with specific status codes using various
    `config.*.if_status` configuration parameters.
  * JSON body contents can be restricted to a set of allowed properties with
    `config.allow.json`.
  * The entire response body can be replaced using `config.replace.body`.
  * Arbitrary transformation functions written in Lua can be applied.
  * The plugin will decompress and recompress Gzip-compressed payloads
    when the `Content-Encoding` header is `gzip`.

  Response Transformer Advanced includes the following additional configurations: `add.if_status`, `append.if_status`,
  `remove.if_status`, `replace.body`, `replace.if_status`, `transform.functions`, `transform.if_status`,
  `allow.json`, `rename.if_status`, `transform.json`, and `dots_in_keys`.

  {:.important}
  > **Note on transforming bodies:** Be aware of the performance of transformations
    on the response body. In order to parse and modify a JSON body, the plugin needs to retain it in memory,
    which might cause pressure on the worker's Lua VM when dealing with large bodies (several MBs).
    Because of Nginx's internals, the `Content-Length` header will not be set when transforming a response body.
type: plugin
categories:
  - transformations
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
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
curl -X POST http://localhost:8001/routes/{route}/plugins \
  --data "name=response-transformer" \
  --data "config.add.headers[1]=h1:v2" \
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
      headers: ["h1:v2", "h2:v1"]
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
curl -X POST http://localhost:8001/routes/{route}/plugins \
  --data "name=response-transformer" \
  --data "config.add.headers=h1:v2,h2:v1"
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
curl -X POST http://localhost:8001/routes/{route}/plugins \
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
curl -X POST http://localhost:8001/routes/{route}/plugins \
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
curl -X POST http://localhost:8001/routes/{route}/plugins \
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
curl -X POST http://localhost:8001/routes/{route}/plugins \
  --data "name=response-transformer" \
  --data "config.add.json=p1:-1" \
  --data "config.add.json_types=number"
```

[api-object]: /gateway/latest/admin-api/#api-object
[consumer-object]: /gateway/latest/admin-api/#consumer-object
[configuration]: /gateway/latest/reference/configuration
