---
id: page-plugin
title: Plugins - Basic Authentication
header_title: Basic Authentication
header_icon: /assets/images/icons/plugins/basic-authentication.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Installation
      - label: Configuration
  - label: Usage
    items:
      - label: Create a Consumer
      - label: Create a Credential
      - label: Upstream Headers
---

Add Basic Authentication to your APIs, with username and password protection. The plugin will check for valid credentials in the `Proxy-Authorization` and `Authorization` header (in this order).

----

## Installation

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml][configuration] configuration file:

```yaml
plugins_available:
  - basic-auth
```

Every node in the Kong cluster must have the same `plugins_available` property value.

----

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=basic-auth" \
    --data "config.hide_credentials=true"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter               | description
---                          | ---
`name`                       | The name of the plugin to use, in this case: `basic-auth`
`config.hide_credentials`    | Default `false`. An optional boolean value telling the plugin to hide the credential to the upstream API server. It will be removed by Kong before proxying the request

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

### Create a Credential

You can provision new username/password credentials by making the following HTTP request:

```bash
$ curl -X POST http://kong:8001/consumers/{consumer}/basic-auth \
    --data "username=user123" \
    --data "password=secret"
```

`consumer`: The `id` or `username` property of the [Consumer][consumer-object] entity to associate the credentials to.

form parameter             | description
---                        | ---
`username`                 | The username to use in the Basic Authentication
`password`<br>*optional*   | The password to use in the Basic Authentication

### Upstream Headers

When a client has been authenticated, the plugin will append some headers to the request before proxying it to the upstream API/Microservice, so that you can identify the consumer in your code:

* `X-Consumer-ID`, the ID of the Consumer on Kong
* `X-Consumer-Custom-ID`, the `custom_id` of to the Consumer (if set)
* `X-Consumer-Username`, the `username` of to the Consumer (if set)

You can use this information on your side to implement additional logic. You can use the `X-Consumer-ID` value to query the Kong Admin API and retrieve more information about the Consumer.

[api-object]: /docs/{{site.data.kong_latest.release}}/admin-api/#api-object
[configuration]: /docs/{{site.data.kong_latest.release}}/configuration
[consumer-object]: /docs/{{site.data.kong_latest.release}}/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
