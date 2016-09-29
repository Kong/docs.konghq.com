---
id: page-plugin
title: Plugins - Request Transformer
header_title: Request Transformer
header_icon: /assets/images/icons/plugins/request-transformer.png
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

Transform the request sent by a client on the fly on Kong, before hitting the upstream server.

----

## Configuration

Configuring the plugin is as simple as a single API call, you can configure and enable it for your [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=request-transformer" \
    --data "config.add.headers[1]=x-new-header:some,value" \
    --data "config.add.headers[2]=x-another-header:some,value" \
    --data "config.add.querystring=new-param:some_value, another-param:some_value" \
    --data "config.add.body=new-form-param:some_value, another-form-param:some_value" \
    --data "config.remove.headers=x-toremove, x-another-one" \
    --data "config.remove.querystring=param-toremove, param-another-one" \
    --data "config.remove.body=formparam-toremove, formparam-another-one"
```

Note: if the value contains a `,` then the comma separated format cannot be used. The array notation must be used instead.

`api`: The `id` or `name` of the API that this plugin configuration will target

You can also apply it for every API using the `http://kong:8001/plugins/` endpoint. Read the [Plugin Reference](/docs/latest/admin-api/#add-plugin) for more information.

form parameter                            | default | description
---:                                      | ---     | ---
`name`                                    | | Name of the plugin to use, in this case: `request-transformer`
`consumer_id`<br>*optional*               | | The CONSUMER ID that this plugin configuration will target. This value can only be used if [authentication has been enabled][faq-authentication] so that the system can identify the user making the request.
`config.http_method`<br>*optional*        | | Changes the HTTP method for the upstream request.
`config.remove.headers`<br>*optional*     | | List of header names. Unset the headers with the given name.
`config.remove.querystring`<br>*optional* | | List of querystring names. Remove the querystring if it is present.
`config.remove.body`<br>*optional*        | | List of parameter names. Remove the parameter if and only if content-type is one the following [`application/json`, `multipart/form-data`,  `application/x-www-form-urlencoded`] and parameter is present.
`config.replace.headers`<br>*optional*    | | List of headername:value pairs. If and only if the header is already set, replace its old value with the new one. Ignored if the header is not already set.
`config.replace.querystring`<br>*optional* | | List of queryname:value pairs. If and only if the header is already set, replace its old value with the new one. Ignored if the header is not already set.
`config.replace.body`<br>*optional*        | | List of paramname:value pairs. If and only if content-type is one the following [`application/json`, `multipart/form-data`, `application/x-www-form-urlencoded`] and the parameter is already present, replace its old value with the new one. Ignored if the parameter is not already present.
`config.add.headers`<br>*optional*         | | List of headername:value pairs. If and only if the header is not already set, set a new header with the given value. Ignored if the header is already set.
`config.add.querystring`<br>*optional*     | | List of queryname:value pairs. If and only if the querystring is not already set, set a new querystring with the given value. Ignored if the header is already set.
`config.add.body`<br>*optional*            | | List of pramname:value pairs. If and only if content-type is one the following [`application/json`, `multipart/form-data`, `application/x-www-form-urlencoded`] and the parameter is not present, add a new parameter with the given value to form-encoded body. Ignored if the parameter is already present.
`config.append.headers`<br>*optional*         | | List of headername:value pairs. If the header is not set, set it with the given value. If it is already set, a new header with the same name and the new value will be set.
`config.append.querystring`<br>*optional*     | | List of queryname:value pairs. If the querystring is not set, set it with the given value. If it is already set, a new querystring with the same name and the new value will be set.
`config.append.body`<br>*optional*     | | List of paramname:value pairs. If the content-type is one the following [`application/json`, `application/x-www-form-urlencoded`], add a new parameter with the given value if the parameter is not present, otherwise if it is already present, the two values (old and new) will be aggregated in an array.

## Order of execution

Plugin performs the response transformation in following order

remove --> replace --> add --> append

## Examples

- Add multiple headers by passing each header:value pair separately:

```
$ curl -X POST http://localhost:8001/apis/mockbin/plugins \
  --data "name=request-transformer" \
  --data "config.add.headers[1]=h1:v1" \
  --data "config.add.headers[2]=h2:v1"
```
incoming request headers | upstream proxied headers:
---           | ---          
h1: v1        | <ul><li>h1: v1</li><li>h2: v1</li></ul>
---

- Add multiple headers by passing comma separated header:value pair:

```
$ curl -X POST http://localhost:8001/apis/mockbin/plugins \
  --data "name=request-transformer" \
  --data "config.add.headers=h1:v1,h2:v2"
```
incoming request headers | upstream proxied headers:
---           | ---          
h1: v1        | <ul><li>h1: v1</li><li>h2: v1</li></ul>
---

- Add multiple headers passing config as JSON body:

```
$ curl -X POST http://localhost:8001/apis/mockbin/plugins \
  --header 'content-type: application/json' \
  --data '{"name": "request-transformer", "config": {"add": {"headers": ["h1:v2", "h2:v1"]}}}'
```

incoming request headers | upstream proxied headers:
---           | ---          
h1: v1        | <ul><li>h1: v1</li><li>h2: v1</li></ul>
---

- Add a querystring and a header:

```
$ curl -X POST http://localhost:8001/apis/mockbin/plugins \
  --data "name=request-transformer" \
  --data "config.add.querystring=q1:v2,q2=v1" \
  --data "config.add.headers=h1:v1"
```

incoming request headers | upstream proxied headers:
---           | ---          
h1: v2        | <ul><li>h1: v2</li><li>h2: v1</li></ul>
h3: v1        | <ul><li>h1: v1</li><li>h2: v1</li><li>h3: v1</li></ul>

incoming request querystring | upstream proxied querystring
---           | ---          
\?q1=v1       | \?q1=v1&q2=v1 
-             | \?q1=v2&q2=v1 
---

- Append multiple headers and remove a body parameter:

```
$ curl -X POST http://localhost:8001/apis/mockbin/plugins \
  --header 'content-type: application/json' \
  --data '{"name": "request-transformer", "config": {"append": {"headers": ["h1:v2", "h2:v1"]}, "remove": {"body": ["p1"]}}}'
```

incoming request headers | upstream proxied headers:
---           | ---          
h1: v1        | <ul><li>h1: v1</li><li>h1: v2</li><li>h2: v1</li></ul>

incoming url encoded body | upstream proxied url encoded body:
---           | ---          
p1=v1&p2=v1   | p2=v1 
p2=v1         | p2=v1 

[api-object]: /docs/latest/admin-api/#api-object
[consumer-object]: /docs/latest/admin-api/#consumer-object
[configuration]: /docs/latest/configuration
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
