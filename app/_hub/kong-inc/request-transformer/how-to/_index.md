---
nav_title: Examples of different transforms
title: Examples of different transforms
--- 

{:.note}
> **Kubernetes users:** Version `v1beta1` of the Ingress
  specification does not allow the use of named regex capture groups in paths.
  If you use the ingress controller, you should use unnamed groups, e.g.
  `(\w+)/`instead of `(?&lt;user_id&gt;\w+)`. You can access
  these based on their order in the URL path. For example `$(uri_captures[1])`
  obtains the value of the first capture group.

In the following examples, the plugin is enabled on a service. This would work
similarly for routes.

## Examples: Passing multiple headers in one request

### Pass each header separately
 
Add multiple headers by passing each `header:value` pair separately:

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

### Comma-separated `header:value` pairs

Add multiple headers by passing comma-separated `header:value` pair (only possible with a database):

```bash
curl -X POST http://localhost:8001/services/example-service/plugins \
  --data "name=request-transformer" \
  --data "config.add.headers=h1:v1,h2:v1"
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

### Config as JSON body

Add multiple headers by passing config as a JSON body (only possible with a database):

```bash
curl -X POST http://localhost:8001/services/example-service/plugins \
  --header 'content-type: application/json' \
  --data '{"name": "request-transformer", "config": {"add": {"headers": ["h1:v1", "h2:v1"]}}}'
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

## Example: Adding a querystring and a header

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


## Example: Appending and removing in one request

Append multiple headers and remove a body parameter:

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
