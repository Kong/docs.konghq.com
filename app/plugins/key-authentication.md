---
id: page-plugin
title: Plugins - Key Authentication
header_title: Key Authentication
header_icon: /assets/images/icons/plugins/key-authentication.png
breadcrumbs:
  Plugins: /plugins
---

Add Key Authentication (also referred to as an API key) to your APIs. Consumers then add their key either in a querystring parameter or a header to authenticate their requests.

---

## Summary

- 1. [Terminology][1]
- 2. [Installation][2]
- 3. [Configuration][3]
- 4. [Usage][4]
  - [Create a Consumer][4a]
  - [Create an API key][4b]
  - [Send the API key in a request][4c]
- 5. [Headers sent to the upstream service][5]

[1]: #1.-terminology
[2]: #2.-installation
[3]: #3.-configuration
[4]: #4.-usage
[4a]: #create-a-consumer
[4b]: #create-an-api-key
[4c]: #send-the-api-key-in-a-request
[5]: #5.-headers-sent-to-the-upstream-service

---

## 1. Terminology

- `api`: your upstream service placed behind Kong, for which Kong proxies requests to.
- `plugin`: a plugin executing actions inside Kong before or after a request has been proxied to the upstream API.
- `consumer`: a developer or service using the api. When using Kong, a Consumer only communicates with Kong which proxies every call to the said, upstream api.
- `credential`: in the key-auth plugin context, a unique string associated with a consumer, also referred to as an API key.

---

## 2. Installation

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml][configuration] configuration file:

```yaml
plugins_available:
  - key-auth
```

Every node in the Kong cluster should have the same `plugins_available` property value.

---

## 3. Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=key-auth"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter                          | description
---                                     | ---
`name`                                  | The name of the plugin to use, in this case: `key-auth`
`config.key_names`<br>*optional*        | Default: `apikey`. Describes an array of comma separated parameter names where the plugin will look for a key. The client must send the authentication key in one of those key names, and the plugin will try to read the credential from a header or the querystring parameter with the same name.
`config.hide_credentials`<br>*optional* | Default `false`. An optional boolean value telling the plugin to hide the credential to the upstream API server. It will be removed by Kong before proxying the request

---

## 4. Usage

In order to use the plugin, you first need to create a Consumer to associate one or more credentials to. The Consumer represents a developer using the final service/API.

### Create a Consumer

You need to associate a credential to an existing [Consumer][consumer-object] object, that represents a user consuming the API. To create a [Consumer][consumer-object] you can execute the following request:

```bash
$ curl -X POST http://kong:8001/consumers/ \
    --data "username=<USERNAME>" \
    --data "custom_id=<CUSTOM_ID>"
HTTP/1.1 201 Created
```

parameter                      | description
---                            | ---
`username`<br>*semi-optional*  | The username of the Consumer. Either this field or `custom_id` must be specified.
`custom_id`<br>*semi-optional* | A custom identifier used to map the Consumer to another database. Either this field or `username` must be specified.

A [Consumer][consumer-object] can have many credentials.

### Create a Key Authentication credential

You can provision new credentials by making the following HTTP request:

```bash
$ curl -X POST http://kong:8001/consumers/{consumer}/key-auth
HTTP/1.1 201 Created

{
    "consumer_id": "876bf719-8f18-4ce5-cc9f-5b5af6c36007",
    "created_at": 1443371053000,
    "id": "62a7d3b7-b995-49f9-c9c8-bac4d781fb59",
    "key": "62eb165c070a41d5c1b58d9d3d725ca1"
}
```

`consumer`: The `id` or `username` property of the [Consumer][consumer-object] entity to associate the credentials to.

form parameter      | description
---                 | ---
`key`<br>*optional* | You can optionally set your own unique `key` to authenticate the client. If missing, the plugin will generate one.

<div class="alert alert-warning">
  <strong>Note:</strong> It is recommended to let Kong auto-generate the key. Only specify it yourself if you are migrating an existing system to Kong, and must re-use your keys to make the migration to Kong transparent to your consumers.
</div>

### Use the key in a request

Simply make a request with the key as a querystring parameter:

```bash
$ curl http://kong:8000/{api path}?apikey=<some_key>
```

Or in a header:

```bash
$ curl http://kong:8000/{api path} \
    -H 'apikey: <some_key>'
```

---

## 5. Headers sent to the upstream server

When a client has been authenticated, the plugin will append some headers to the request before proxying it to the upstream API/Microservice, so that you can identify the Consumer in your code:

* `X-Consumer-ID`, the ID of the Consumer on Kong
* `X-Consumer-Custom-ID`, the `custom_id` of to the Consumer (if set)
* `X-Consumer-Username`, the `username` of to the Consumer (if set)

You can use this information on your side to implement additional logic. You can use the `X-Consumer-ID` value to query the Kong Admin API and retrieve more information about the Consumer.

[api-object]: /docs/{{site.data.kong_latest.release}}/admin-api/#api-object
[configuration]: /docs/{{site.data.kong_latest.release}}/configuration
[consumer-object]: /docs/{{site.data.kong_latest.release}}/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?