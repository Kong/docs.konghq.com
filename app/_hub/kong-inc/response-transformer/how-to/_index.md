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