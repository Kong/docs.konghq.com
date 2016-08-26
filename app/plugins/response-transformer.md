---
id: page-plugin
title: Plugins - Response Transformer
header_title: Response Transformer
header_icon: /assets/images/icons/plugins/response-transformer.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Installation
      - label: Configuration
      - label: Order of execution
      - label: Examples
---

Transform the response sent by the upstream server on the fly on Kong, before returning the response to the client.

<div class="alert alert-warning">
  <strong>Note on transforming bodies:</strong> Be aware of the performamce of transformations on the response body. In order to parse and modify a JSON body, the plugin needs to retain it in memory, which might cause pressure on the worker's Lua VM when dealing with large bodies (several MBs). Because of Nginx's internals, the `Content-Length` header will not be set when transforming a response body.
</div>
----

## Configuration

Configuring the plugin is as simple as a single API call, you can configure and enable it for your [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=response-transformer" \
    --data "config.add.headers[1]=x-new-header:some,value" \
    --data "config.add.headers[2]=x-another-header:some,value" \
    --data "config.add.json=new-json-key:some_value, another-json-key:some_value" \
    --data "config.remove.headers=x-toremove, x-another-one" \
    --data "config.remove.json=json-key-toremove, another-json-key" \
    --data "config.append.headers=x-existing-header:some_value, x-another-header:some_value"
```

Note: if the value contains a `,` then the comma separated format cannot be used. The array notation must be used instead.

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter                        | description
---:                                  | ---
`name`                                | Name of the plugin to use, in this case: `response-transformer`
`consumer_id`<br>*optional*           | The CONSUMER ID that this plugin configuration will target. This value can only be used if [authentication has been enabled][faq-authentication] so that the system can identify the user making the request.
`config.remove.headers`<br>*optional*  | List of header names. Unset the header(s) with the given name.
`config.remove.json`<br>*optional*     | List of property names. Remove the property from the JSON body if it is present.
`config.replace.headers`<br>*optional*  | List of headername:value pairs. If and only if the header is already set, replace its old value with the new one. Ignored if the header is not already set. 
`config.replace.json`<br>*optional*  | List of property:value pairs. If and only if the parameter is already present, replace its old value with the new one. Ignored if the parameter is not already present.
`config.add.headers`<br>*optional*     | List of headername:value pairs. If and only if the header is not already set, set a new header with the given value. Ignored if the header is already set. 
`config.add.json`<br>*optional*        | List of property:value pairs. If and only if the property is not present, add a new property with the given value to the JSON body. Ignored if the property is already present.
`config.append.headers`<br>*optional*     | List of headername:value pairs. If the header is not set, set it with the given value. If it is already set, a new header with the same name and the new value will be set.
`config.append.json`<br>*optional*     | List of property:value pairs. If the property is not present in the JSON body, add it with the given value. If it is already present, the two values (old and new) will be aggregated in an array.

## Order of execution

Plugin performs the response transformation in following order

remove --> replace --> add --> append

## Examples

- Add multiple headers by passing each header:value pair separately:

```
$ curl -X POST http://localhost:8001/apis/mockbin/plugins \
  --data "name=response-transformer" \
  --data "config.add.headers[1]=h1:v1" \
  --data "config.add.headers[2]=h2:v1"
```
upstream response headers | proxied response headers
---           | ---          
h1: v1        | <ul><li>h1: v1</li><li>h2: v1</li></ul>
---

- Add multiple headers by passing comma separated header:value pair:

```
$ curl -X POST http://localhost:8001/apis/mockbin/plugins \
  --data "name=response-transformer" \
  --data "config.add.headers=h1:v1,h2:v2"
```
upstream response headers | proxied response headers
---           | ---          
h1: v1        | <ul><li>h1: v1</li><li>h2: v1</li></ul>
---

- Add multiple headers passing config as JSON body:

```
$ curl -X POST http://localhost:8001/apis/mockbin/plugins \
  --header 'content-type: application/json' \
  --data '{"name": "response-transformer", "config": {"add": {"headers": ["h1:v2", "h2:v1"]}}}'
```

upstream response headers | proxied response headers
---           | ---          
h1: v1        | <ul><li>h1: v1</li><li>h2: v1</li></ul>
---

- Add a body property and a header:

```
$ curl -X POST http://localhost:8001/apis/mockbin/plugins \
  --data "name=response-transformer" \
  --data "config.add.json=p1:v1,p2=v2" \
  --data "config.add.headers=h1:v1"
```

upstream response headers | proxied response headers:
---           | ---          
h1: v2        | <ul><li>h1: v2</li><li>h2: v1</li></ul>
h3: v1        | <ul><li>h1: v1</li><li>h2: v1</li><li>h3: v1</li></ul>

upstream response JSON body | proxied response body
---           | ---          
{}            | {"p1" : "v1", "p2": "v2"}
{"p1" : "v2"}  | {"p1" : "v2", "p2": "v2"}
---

- Append multiple headers and remove a body property:

```
$ curl -X POST http://localhost:8001/apis/mockbin/plugins \
  --header 'content-type: application/json' \
  --data '{"name": "response-transformer", "config": {"append": {"headers": ["h1:v2", "h2:v1"]}, "remove": {"json": ["p1"]}}}'
```

upstream response headers | proxied response headers
---           | ---          
h1: v1        | <ul><li>h1: v1</li><li>h1: v2</li><li>h2: v1</li></ul>

upstream response JSON body | proxied response body
---           | ---          
{"p2": "v2"}   | {"p2": "v2"}
{"p1" : "v1", "p2" : "v1"}  | {"p2": "v2"}

[api-object]: /docs/latest/admin-api/#api-object
[consumer-object]: /docs/latest/admin-api/#consumer-object
[configuration]: /docs/latest/configuration
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
