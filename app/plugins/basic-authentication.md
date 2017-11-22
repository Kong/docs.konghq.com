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
      - label: Configuration
  - label: Usage
    items:
      - label: Create a Consumer
      - label: Create a Credential
      - label: Using the Credential
      - label: Upstream Headers
---

Add Basic Authentication to your APIs, with username and password protection. The plugin will check for valid credentials in the `Proxy-Authorization` and `Authorization` header (in this order).

----

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=basic-auth" \
    --data "config.hide_credentials=true"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

You can also apply it for every API using the `http://kong:8001/plugins/` endpoint. Read the [Plugin Reference](/docs/latest/admin-api/#add-plugin) for more information.

Once applied, any user with a valid credential can access the service/API.
To restrict usage to only some of the authenticated users, also add the
[ACL](/plugins/acl/) plugin (not covered here) and create whitelist or
blacklist groups of users.

form parameter                             | default | description
---                                        | ---     | ---
`name`                                     |         | The name of the plugin to use, in this case: `basic-auth`
`config.hide_credentials`<br>*optional*    | `false` | An optional boolean value telling the plugin to hide the credential to the upstream API server. It will be removed by Kong before proxying the request
`config.anonymous`<br>*optional*           | ``      | An optional string (consumer uuid) value to use as an "anonymous" consumer if authentication fails. If empty (default), the request will fail with an authentication failure `4xx`. Please note that this value must refer to the Consumer `id` attribute which is internal to Kong, and **not** its `custom_id`.

----

## Usage

In order to use the plugin, you first need to create a consumer to associate one or more credentials to. The Consumer represents a developer using the final service/API.

### Create a Consumer

You need to associate a credential to an existing [Consumer][consumer-object] object, that represents a user consuming the API. To create a [Consumer][consumer-object] you can execute the following request:

```bash
curl -d "username=user123&custom_id=SOME_CUSTOM_ID" http://kong:8001/consumers/
```

parameter                       | default | description
---                             | ---     | ---
`username`<br>*semi-optional*   |         | The username of the consumer. Either this field or `custom_id` must be specified.
`custom_id`<br>*semi-optional*  |         | A custom identifier used to map the consumer to another database. Either this field or `username` must be specified.

A [Consumer][consumer-object] can have many credentials.

If you are also using the [ACL](/plugins/acl/) plugin and whitelists with this
service, you must add the new consumer to a whitelisted group. See
[ACL: Associating Consumers][acl-associating] for details.

### Create a Credential

You can provision new username/password credentials by making the following HTTP request:

```bash
$ curl -X POST http://kong:8001/consumers/{consumer}/basic-auth \
    --data "username=Aladdin" \
    --data "password=OpenSesame"
```

`consumer`: The `id` or `username` property of the [Consumer][consumer-object] entity to associate the credentials to.

form parameter             | default | description
---                        | ---     | ---
`username`                 |         | The username to use in the Basic Authentication
`password`<br>*optional*   |         | The password to use in the Basic Authentication

### Using the Credential

The authorization header must be base64 encoded. For example, if the credential
uses `Aladdin` as the username and `OpenSesame` as the password, then the field's
value is the base64-encoding of `Aladdin:OpenSesame`, or `QWxhZGRpbjpPcGVuU2VzYW1l`.

Then the `Authorization` (or `Proxy-Authorization`) header must appear as:

```
Authorization: Basic QWxhZGRpbjpPcGVuU2VzYW1l
```

Simply make a request with the header:

```bash
$ curl http://kong:8000/{api path} \
    -H 'Authorization: Basic QWxhZGRpbjpPcGVuU2VzYW1l'
```

### Upstream Headers

When a client has been authenticated, the plugin will append some headers to the request before proxying it to the upstream API/Microservice, so that you can identify the consumer in your code:

* `X-Consumer-ID`, the ID of the Consumer on Kong
* `X-Consumer-Custom-ID`, the `custom_id` of the Consumer (if set)
* `X-Consumer-Username`, the `username` of the Consumer (if set)
* `X-Credential-Username`, the `username` of the Credential (only if the consumer is not the 'anonymous' consumer)
* `X-Anonymous-Consumer`, will be set to `true` when authentication failed, and the 'anonymous' consumer was set instead.

You can use this information on your side to implement additional logic. You can use the `X-Consumer-ID` value to query the Kong Admin API and retrieve more information about the Consumer.

[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
[acl-associating]: /plugins/acl/#associating-consumers
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
