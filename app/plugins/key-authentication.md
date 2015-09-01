---
id: page-plugin
title: Plugins - Key Authentication
header_title: Key Authentication
header_icon: /assets/images/icons/plugins/key-authentication.png
breadcrumbs:
  Plugins: /plugins
---

Add a Key Authentication (like an apikey) to your APIs, either in a header, in querystring parameter, or in a form parameter.

----

## Installation

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml][configuration] configuration file:

```yaml
plugins_available:
  - key-auth
```

Every node in the Kong cluster should have the same `plugins_available` property value.

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=key-auth" \
    --data "config.key_names=key_name1,key_name2"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter                          | description
---                                     | ---
`name`                                  | The name of the plugin to use, in this case: `key-auth`
`config.key_names`                       | Describes an array of comma separated parameter names where the plugin will look for a valid credential. The client must send the authentication key in one of those key names, and the plugin will try to read the credential from a header, the querystring, a form parameter (in this order). For example: `apikey`
`config.hide_credentials`<br>*optional*  | Default `false`. An optional boolean value telling the plugin to hide the credential to the upstream API server. It will be removed by Kong before proxying the request

## Usage

In order to use the plugin, you first need to create a consumer to associate one or more credentials to. The Consumer represents a developer using the final service/API.

### Create a Consumer

You need to associate a credential to an existing [Consumer][consumer-object] object, that represents a user consuming the API. To create a [Consumer][consumer-object] you can execute the following request:

```bash
$ curl -X POST http://kong:8001/consumers/ \
    --data "username=user123" \
    --data "custom_id=SOME_CUSTOM_ID"
```

parameter                      | description
---                            | ---
`username`<br>*semi-optional*  | The username of the consumer. Either this field or `custom_id` must be specified.
`custom_id`<br>*semi-optional* | A custom identifier used to map the consumer to another database. Either this field or `username` must be specified.

A [Consumer][consumer-object] can have many credentials.

### Create a Key Authentication credential

Then you can finally provision new key credentials by making the following HTTP request:

```bash
$ curl -X POST http://kong:8001/consumers/{consumer}/key-auth \
    --data "key=some_key"
```

`consumer`: The `id` or `username` property of the [Consumer][consumer-object] entity to associate the credentials to.

form parameter      | description
---                 | ---
`key`<br>*optional* | You can optionally set your own unique `key` to authenticate the client. If missing, the plugin will generate one.

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
