---
id: page-plugin
title: Plugins - HMAC Authentication
header_title: HMAC Authentication
header_icon: /assets/images/icons/plugins/hmac-authentication.png
breadcrumbs:
  Plugins: /plugins
---

Add HMAC Signature Authentication to your APIs to establish the identity of consumer. 

## HMAC Credentials

The plugin will check for valid signature in the `Proxy-Authorization` and   `Authorization` header (in this order). Plugin follows little modified version of the Internet Draft  [draft-cavage-http-signatures-00](https://tools.ietf.org/html/draft-cavage-http-signatures-00) for signature creation. To generate the string that is signed with a secret shared between Consumer and Api Provider, the client must take the values of each HTTP header specified by `headers` in the order they appear.

```
credentials := "hmac" params
params :=  username ","algorithm [", " headers]", " signature
username := "username" "=" plain-string
algorithm := "algorithm" "=" DQUOTE ( hmac-sha1 ) DQUOTE
headers := "headers" "=" plain-string
signature := "signature" "=" plain-string
plain-string   = DQUOTE *( %x20-21 / %x23-5B / %x5D-7E ) DQUOTE
```
### HMAC Signature String Construction

1.  If the header name is not `request-line` then append the lowercased header name followed with an ASCII colon `:` and an ASCII space ' '.

2. If the header name is `request-line` then appened the HTTP request line, otherwise append the header value.

3. If value is not the last value then append an ASCII newline `\n`. The string MUST NOT include a trailing ASCII newline.

ex. 
```bash
PUT /path/ HTTP/1.0
Content-Type: text/html
Date: Fri, 18 Sep 2015 21:10:11 GMT
Authorization:hmac username="bob", algorithm="hmac-sha1", headers="date", signature="BxjR4DLoxQ/seZvPBwy8gso6U+o="
```

----

## Installation

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml][configuration] configuration file:

```yaml
plugins_available:
  - hmac-auth
```

Every node in the Kong cluster must have the same `plugins_available` property value.

----

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=hmac-auth" \
    --data "config.hide_credentials=true"
    --data "config.clock_skew=<in seconds>"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter               | description
---                          | ---
`name`                       | The name of the plugin to use, in this case: `hmac-auth`
`config.hide_credentials`     | Default `false`. An optional boolean value telling the plugin to hide the credential to the upstream API server. It will be removed by Kong before proxying the request
`config.clock_skew`          | Default `300`. Clock Skew in second to prevent replay attack   

----

## Usage

In order to use the plugin, you first need to create a consumer to associate one or more credentials to. The Consumer represents a developer using the final service/API.

### Create a Consumer

You need to associate a credential to an existing [Consumer][consumer-object] object, that represents a user consuming the API. To create a [Consumer][consumer-object] you can execute the following request:

```bash
curl -d "username=user123&custom_id=SOME_CUSTOM_ID" http://kong:8001/consumers/
```

parameter                       | description
---                             | ---
`username`<br>*semi-optional*   | The username of the consumer. Either this field or `custom_id` must be specified.
`custom_id`<br>*semi-optional*  | A custom identifier used to map the consumer to another database. Either this field or `username` must be specified.

A [Consumer][consumer-object] can have many credentials.

### Create a HMAC Authentication credential

You can provision new username/password credentials by making the following HTTP request:

```bash
$ curl -X POST http://kong:8001/consumers/{consumer}/hmac-auth \
    --data "username=user123" \
    --data "secret=somethinglong"
```

`consumer`: The `id` or `username` property of the [Consumer][consumer-object] entity to associate the credentials to.

form parameter             | description
---                        | ---
`username`                 | The username to use in the HMAC Signature verification
`secret`<br>*optional*   | The secret to use in the HMAC Signature verification

## Headers sent to the upstream server

When a client has been authenticated, the plugin will append some headers to the request before proxying it to the upstream API/Microservice, so that you can identify the consumer in your code:

* `X-Consumer-ID`, the ID of the Consumer on Kong
* `X-Consumer-Custom-ID`, the `custom_id` of to the Consumer (if set)
* `X-Consumer-Username`, the `username` of to the Consumer (if set)

You can use this information on your side to implement additional logic. You can use the `X-Consumer-ID` value to query the Kong Admin API and retrieve more information about the Consumer.

[api-object]: /docs/{{site.data.kong_latest.release}}/admin-api/#api-object
[configuration]: /docs/{{site.data.kong_latest.release}}/configuration
[consumer-object]: /docs/{{site.data.kong_latest.release}}/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
