---
redirect_to: /hub/kong-inc/request-transformer-advanced


# !!!!!!!!!!!!!!!!!!!!!!!!   WARNING   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# FIXME This file is dead code - it is no longer being rendered or utilized,
# and updates to this file will have no effect.
#
# The remaining contents of this file (below) will be deleted soon.
#
# Updates to the content below should instead be made to the file(s) in /app/_hub/
#
# !!!!!!!!!!!!!!!!!!!!!!!!   WARNING   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!


title: Request Transformer Plugin
---
# Request Transformer Plugin

Transform the request sent by a client on the fly on Kong, before hitting the upstream server.

## Configuration

Configuring the plugin is as simple as a single API call, you can configure and enable it for your [API](/latest/admin-api/#api-object)
(or [Consumer](/latest/admin-api/#consumer-object)) by executing the following request on your Kong server:

```
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=request-transformer-advanced" \
    --data "config.add.headers[1]=x-new-header:some_value" \
    --data "config.add.headers[2]=x-another-header:some_value" \
    --data "config.add.querystring=new-param:some_value, another-param:some_value" \
    --data "config.add.body=new-form-param:some_value, another-form-param:some_value" \
    --data "config.remove.headers=x-to-remove, x-another-one" \
    --data "config.remove.querystring=param-to-remove, param-another-one" \
    --data "config.remove.body=formparam-to-remove, formparam-another-one"
```
Note: if the value contains a `,` then the comma separated format cannot be used. The array notation must be used instead.

`api`: The `id` or `name` of the API that this plugin configuration will target

You can also apply it for every API using the http://kong:8001/plugins/ endpoint. Read the [Plugin Reference](/latest/admin-api/#add-plugin) for more information.

| Form Parameter | Description
| --------- | -----------
|`consumer_id`<br>*optional* | Name of the plugin to use, in this case:request-transformer-advanced consumer_id optional	The consumer ID that this plugin configuration will target. This value can only be used if [authentication has been enabled](/about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?)  so that the system can identify the user making the request.
|`config.http_method` <br>*optional* | Changes the HTTP method for the upstream request.
|`config.remove.headers` <br>*optional* | List of header names. Unset the headers with the given name.
|`config.remove.querystring`<br>*optional* | List of querystring names. Remove the querystring if it is present.
|`config.remove.body`<br>*optional* | List of parameter names. Remove the parameter if and only if content-type is one the following [`application/json`, `multipart/form-data`, `application/x-www-form-urlencoded`] and parameter is present.
|`config.replace.headers` <br>*optional* | List of headername:value pairs. If and only if the header is already set, replace its old value with the new one. Ignored if the header is not already set.
|`config.replace.querystring`<br>*optional* | List of queryname:value pairs. If and only if the querystring name is already set, replace its old value with the new one. Ignored if the header is not already set.
|`config.replace.uri`<br>*optional* | Updates the upstream request URI with given value. This value can only be used to update the path part of the uri, not the scheme, nor the hostname.
|`config.replace.body`<br>*optional* | List of paramname:value pairs. If and only if content-type is one the following [`application/json`, `multipart/form-data`, `application/x-www-form-urlencoded`] and the parameter is already present, replace its old value with the new one. Ignored if the parameter is not already present.
|`config.rename.headers`<br>*optional* | List of headername:value pairs. If and only if the header is already set, rename the header. The value is unchanged. Ignored if the header is not already set.
|`config.rename.querystring`<br>*optional* | List of queryname:value pairs. If and only if the field name is already set, rename the field name. The value is unchanged. Ignored if the field name is not already set.
|`config.rename.body`<br>*optional* | List of parameter name:value pairs. Rename the parameter name if and only if content-type is one the following [`application/json`, `multipart/form-data`, `application/x-www-form-urlencoded`] and parameter is present.
|`config.add.headers`<br>*optional* | List of headername:value pairs. If and only if the header is not already set, set a new header with the given value. Ignored if the header is already set.
|`config.add.querystring`<br>*optional* | List of queryname:value pairs. If and only if the querystring name is not already set, set a new querystring with the given value. Ignored if the querystring name is already set.
|`config.add.body`<br>*optional* | List of paramname:value pairs. If and only if content-type is one the following [`application/json, multipart/form-data`, `application/x-www-form-urlencoded`] and the parameter is not present, add a new parameter with the given value to form-encoded body. Ignored if the parameter is already present.
|`config.append.headers`<br>*optional* | List of headername:value pairs. If the header is not set, set it with the given value. If it is already set, a new header with the same name and the new value will be set.
|`config.append.querystring`<br>*optional* | List of queryname:value pairs. If the querystring is not set, set it with the given value. If it is already set, a new querystring with the same name and the new value will be set.
|`config.append.body`<br>*optional* | List of paramname:value pairs. If the content-type is one the following [`application/json`, `application/x-www-form-urlencoded`], add a new parameter with the given value if the parameter is not present, otherwise if it is already present, the two values (old and new) will be aggregated in an array.

## Template as value

User can use any of the the current request headers, query params, and captured URI named groups as template to populate above supported config fields.

| Request Param | Template
| --------- | -----------
| header | $(headers.<header_name> or $(headers['<header-name>']) or 'optional_default')
| querystring | $(query_params.<query_param_name> or $(query_params['query-param-name']) or 'optional_default')
| captured URIs | $(uri_captures.<group_name> or $(uri_captures['group-name']) or 'optional_default')

To escape a template, wrap it inside quotes and pass inside another template.<br>
Ex. $('$(some_needs_to_escaped)')

Note: Plugin creates a non mutable table of request headers, querystrings, and captured URIs before transformation. So any update or removal of params used in template does not affect the rendered value of template.

## Examples using template as value

Add an API `test` with `uris` configured with a named capture group `user_id`

```
$ curl -X POST http://localhost:8001/apis \
    --data 'name=test' \
    --data 'upstream_url=http://mockbin.com' \
    --data-urlencode 'uris=/requests/user/(?<user_id>\w+)' \
    --data "strip_uri=false"
```

Enable the ‘request-transformer-advanced’ plugin to add a new header `x-consumer-id`
and its value is being set with the value sent with header `x-user-id` or
with the default value alice is `header` is missing.

```
$ curl -X POST http://localhost:8001/apis/test/plugins \
    --data "name=request-transformer-advanced" \
    --data-urlencode "config.add.headers=x-consumer-id:\$(headers['x-user-id'] or 'alice')" \
    --data "config.remove.headers=x-user-id"
```

Now send a request without setting header `x-user-id`

```
$ curl -i -X GET localhost:8000/requests/user/foo
```

Plugin will add a new header `x-consumer-id` with value alice before proxying
request upstream. Now try sending request with header `x-user-id` set

```
$ curl -i -X GET localhost:8000/requests/user/foo \
  -H "X-User-Id:bob"
```

This time plugin will add a new header `x-consumer-id` with value sent along
with header `x-user-id`, i.e.`bob`

## Order of execution

Plugin performs the response transformation in following order

remove –> replace –> add –> append

## Configuration Examples

Add multiple headers by passing each header:value pair separately:

```
$ curl -X POST http://localhost:8001/apis/mockbin/plugins \
  --data "name=request-transformer-advanced" \
  --data "config.add.headers[1]=h1:v1" \
  --data "config.add.headers[2]=h2:v1"
```

| Incoming Request Headers | Upstream Proxied Headers
| --------- | -----------
| h1: v1 | h1: v1, h2: v1

Add multiple headers by passing comma separated header:value pair:

```
$ curl -X POST http://localhost:8001/apis/mockbin/plugins \
  --data "name=request-transformer-advanced" \
  --data "config.add.headers=h1:v1,h2:v2"
```

| Incoming Request Headers | Upstream Proxied Headers
| --------- | -----------
| h1: v1 | h1: v1, h2: v1

Add multiple headers passing config as JSON body:

```
$ curl -X POST http://localhost:8001/apis/mockbin/plugins \
  --header 'content-type: application/json' \
  --data '{"name": "request-transformer-advanced", "config": {"add": {"headers": ["h1:v2", "h2:v1"]}}}'
```

| Incoming Request Headers | Upstream Proxied Headers
| --------- | -----------
| h1: v1 | h1: v1, h2: v1

Add a querystring and a header:

```
$ curl -X POST http://localhost:8001/apis/mockbin/plugins \
  --data "name=request-transformer-advanced" \
  --data "config.add.querystring=q1:v2,q2=v1" \
  --data "config.add.headers=h1:v1"

```

| Incoming Request Headers | Upstream Proxied Headers
| --------- | -----------
| h1: v1 | h1: v1, h2: v1
| h3: v1 | h1: v1, h2: v1, h3: v1

| Incoming Request Querystring | Upstream Proxied Querystring
| --------- | -----------
| ?q1=v1 | ?q1=v1&q2=v1
|        | ?q1=v2&q2=v1

Append multiple headers and remove a body parameter:

```
$ curl -X POST http://localhost:8001/apis/mockbin/plugins \
  --data "name=request-transformer-advanced" \
  --data "config.add.headers=h1:v2,h2:v1" \
  --data "config.remove.body=p1" \

```

| Incoming Request Headers | Upstream Proxied Headers
| --------- | -----------
| h1: v1 | h1: v1, h1: v2, h2: v1

| Incoming URL Encoded Body | Upstream Proxied URL Encoded Body
| --------- | -----------
| p1=v1&p2=v1 | p2=v1
| p2=v1 | p2=v1

Add multiple headers and querystring parameters if not already set:

```
$ curl -X POST http://localhost:8001/apis/mockbin/plugins \
  --data "name=request-transformer-advanced" \
  --data "config.add.headers=h1:v1,h2:v1" \
  --data "config.add.querystring=q1:v2,q2:v1" \

```

| Incoming Request Headers | Upstream Proxied Headers
| --------- | -----------
| h1: v1 | h1: v1, h2: v1
| h3: v1 |  h1: v1, h2: v1, h3: v1

| Incoming Request Querystring | Upstream Proxied Querystring
| --------- | -----------
| ?q1=v1 | ?q1=v1&q2=v1
|        | ?q1=v2&q2=v1
