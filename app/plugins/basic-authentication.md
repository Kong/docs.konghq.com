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
      - label: Paginate through the basic-auth Credentials
      - label: Retrieve the Consumer associated with a Credential
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
`config.hide_credentials`<br>*optional*    | `false` | An optional boolean value telling the plugin to hide the credentials from the upstream API server. If `true` credentials will be removed by Kong before proxying the request.
`config.anonymous`<br>*optional*           | ``      | An optional string (consumer uuid) value to use as an "anonymous" consumer if authentication fails. If empty (default), the request will fail with an authentication failure `4xx`. Please note that this value must refer to the Consumer `id` attribute which is internal to Kong, and **not** its `custom_id`.

----

## Usage

In order to use the plugin, you first need to create a consumer to associate one or more credentials to. The Consumer represents a developer using the final service/API.

A note about `hide_credentials`: If set to `true`, it implies that the upstream service does *not* require basic authentication, but that Kong will be handling this requirement on behalf of the upstream. Use cURL commands directly to the upstream service to determine how to set the `hide_credentials` flag.

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

### Paginate through the basic-auth Credentials

<div class="alert alert-warning">
  <strong>Note:</strong> This endpoint was introduced in Kong 0.11.2.
</div>

You can paginate through the basic-auth Credentials for all Consumers using the
following request:

```bash
$ curl -X GET http://kong:8001/basic-auths

{
    "total": 3,
    "data": [
        {
            "created_at": 1511379926000,
            "id": "805520f6-842b-419f-8a12-d1de8a30b29f",
            "password": "37b1af03d3860acf40bd9c681aa3ef3f543e49fe",
            "username": "baz",
            "consumer_id": "5e52251c-54b9-4c10-9605-b9b499aedb47"
        },
        {
            "created_at": 1511379863000,
            "id": "8edfe5c7-3151-4d92-971f-3faa5e6c5d7e",
            "password": "451b06c564a06ce60874d0ea2f542fa8ed26317e",
            "username": "foo",
            "consumer_id": "89a41fef-3b40-4bb0-b5af-33da57a7ffcf"
        },
        {
            "created_at": 1511379877000,
            "id": "f11cb0ea-eacf-4a6b-baea-a0e0b519a990",
            "password": "451b06c564a06ce60874d0ea2f542fa8ed26317e",
            "username": "foobar",
            "consumer_id": "89a41fef-3b40-4bb0-b5af-33da57a7ffcf"
        }
    ]
}
```

You can filter the list using the following query parameters:

Attributes | Description
---:| ---
`id`<br>*optional*                       | A filter on the list based on the basic-auth credential `id` field.
`username`<br>*optional*                 | A filter on the list based on the basic-auth credential `username` field.
`consumer_id`<br>*optional*              | A filter on the list based on the basic-auth credential `consumer_id` field.
`size`<br>*optional, default is __100__* | A limit on the number of objects to be returned.
`offset`<br>*optional*                   | A cursor used for pagination. `offset` is an object identifier that defines a place in the list.

### Retrieve the Consumer associated with a Credential

<div class="alert alert-warning">
  <strong>Note:</strong> This endpoint was introduced in Kong 0.11.2.
</div>

It is possible to retrieve a [Consumer][consumer-object] associated with a
basic-auth Credential using the following request:

```bash
curl -X GET http://kong:8001/basic-auths/{username or id}/consumer

{
   "created_at":1507936639000,
   "username":"foo",
   "id":"c0d92ba9-8306-482a-b60d-0cfdd2f0e880"
}
```

`username or id`: The `id` or `username` property of the basic-auth
Credential for which to get the associated [Consumer][consumer-object].
Note that the `username` accepted here is **not** the `username` property of a
Consumer.

[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
[acl-associating]: /plugins/acl/#associating-consumers
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
