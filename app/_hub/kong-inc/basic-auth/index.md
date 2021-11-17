---
name: Basic Authentication
publisher: Kong Inc.
version: 2.2.0

desc: Add Basic Authentication to your Services
description: |
  Add Basic Authentication to a Service or a Route with username and password protection. The plugin
  checks for valid credentials in the `Proxy-Authorization` and `Authorization` headers (in that order).


type: plugin
categories:
  - authentication

kong_version_compatibility:
    community_edition:
      compatible:
        - 2.4.x
        - 2.3.x
        - 2.2.x      
        - 2.1.x
        - 2.0.x
        - 1.5.x
        - 1.4.x
        - 1.3.x
        - 1.2.x
        - 1.1.x
        - 1.0.x
        - 0.14.x
        - 0.13.x
        - 0.12.x
        - 0.11.x
        - 0.10.x
        - 0.9.x
        - 0.8.x
        - 0.7.x
        - 0.6.x
        - 0.5.x
        - 0.4.x
        - 0.3.x
        - 0.2.x
    enterprise_edition:
      compatible:
        - 2.4.x
        - 2.3.x
        - 2.2.x
        - 2.1.x
        - 1.5.x
        - 1.3-x
        - 0.36-x

params:
  name: basic-auth
  service_id: true
  route_id: true
  consumer_id: false
  protocols: ["http", "https", "grpc", "grpcs"]
  dbless_compatible: partially
  dbless_explanation: |
    Consumers and Credentials can be created with declarative configuration.

    Admin API endpoints which do POST, PUT, PATCH or DELETE on Credentials are not available on DB-less mode.
  config:
    - name: hide_credentials
      required: false
      value_in_examples: true
      datatype: boolean
      default: "`false`"
      description: |
        An optional boolean value telling the plugin to show or hide the credential from the upstream service. If `true`, the plugin will strip the credential from the request (i.e. the `Authorization` header) before proxying it.

    - name: anonymous
      required: false
      default:
      datatype: string
      description: |
        An optional string (consumer uuid) value to use as an "anonymous" consumer if authentication fails. If empty (default), the request will fail with an authentication failure `4xx`. Please note that this value must refer to the Consumer `id` attribute which is internal to Kong, and **not** its `custom_id`.
  extra: |
    Once applied, any user with a valid credential can access the Service.
    To restrict usage to only some of the authenticated users, also add the
    [ACL](/plugins/acl/) plugin (not covered here) and create allowed or
    denied groups of users.

---

## Usage

To use the plugin, you first need to create a Consumer to associate one or more credentials to. The Consumer represents a developer or an application consuming the upstream service.

### Create a Consumer

You need to associate a credential to an existing [Consumer][consumer-object] object.
A Consumer can have many credentials.

{% navtabs %}
{% navtab With a Database %}
To create a Consumer, you can execute the following request:

```bash
curl -d "username={USER123}&custom_id={SOME_CUSTOM_ID}" http://kong:8001/consumers/
```
{% endnavtab %}
{% navtab Without a Database %}
Your declarative configuration file needs to have one or more Consumers.
You can create them using a `consumers:` YAML section:

``` yaml
consumers:
- username: {USER123}
  custom_id: {SOME_CUSTOM_ID}
```
{% endnavtab %}
{% endnavtabs %}

Consumer parameters:

Parameter                       | Description
---                             | ---
`username`<br>*semi-optional*   | The username of the consumer. Either this field or `custom_id` must be specified.
`custom_id`<br>*semi-optional*  | A custom identifier used to map the consumer to another database. Either this field or `username` must be specified.

If you are also using the [ACL](/plugins/acl/) plugin and allow lists with this
service, you must add the new consumer to the allowed group. See
[ACL: Associating Consumers][acl-associating] for details.

### Create a Credential

{% navtabs %}
{% navtab With a Database %}
You can provision new username/password credentials by making the following HTTP request:

```bash
curl -X POST http://kong:8001/consumers/{CONSUMER}/basic-auth \
  --data "username=Aladdin" \
  --data "password=OpenSesame"
```

{% endnavtab %}
{% navtab Without a Database %}

You can add credentials on your declarative config file with the `basicauth_credentials` YAML entry:

``` yaml
basicauth_credentials:
- consumer: {CONSUMER}
  username: Aladdin
  password: OpenSesame
```
{% endnavtab %}
{% endnavtabs %}

Consumer credential parameters:

field/parameter | description
---             | ---
`consumer`      | The `id` or `username` property of the [Consumer][consumer-object] entity to associate the credentials to.
`username`      | The username to use in the basic authentication credential.
`password`      | The password to use in the basic authentication credential.


### Using the Credential

The authorization header must be base64 encoded. For example, if the credential
uses `Aladdin` as the username and `OpenSesame` as the password, then the field's
value is the base64-encoding of `Aladdin:OpenSesame`, or `QWxhZGRpbjpPcGVuU2VzYW1l`.

The `Authorization` (or `Proxy-Authorization`) header must appear as:

```
Authorization: Basic QWxhZGRpbjpPcGVuU2VzYW1l
```

Make a request with the header:

```bash
curl http://kong:8000/{PATH_MATCHING_CONFIGURED_ROUTE} \
  -H 'Authorization: Basic QWxhZGRpbjpPcGVuU2VzYW1l'
```

gRPC clients are supported too:

```bash
grpcurl -H 'Authorization: Basic QWxhZGRpbjpPcGVuU2VzYW1l' ...
```

### Upstream Headers

When a client has been authenticated, the plugin appends some headers to the request before proxying it to the upstream service, so that you can identify the Consumer in your code:

* `X-Consumer-ID`: the ID of the Consumer in Kong Gateway
* `X-Consumer-Custom-ID`: the `custom_id` of the Consumer (if set)
* `X-Consumer-Username`: the `username` of the Consumer (if set)
* `X-Credential-Identifier`: the identifier of the Credential (only if the consumer is not the 'anonymous' consumer)
* `X-Anonymous-Consumer`: set to `true` if authentication fails, and the 'anonymous' consumer is set instead

You can use this information on your side to implement additional logic. Use the `X-Consumer-ID` value to query the Kong Admin API and retrieve more information about the Consumer.

{:.important}
> **Important:** `X-Credential-Username` was deprecated in favor of `X-Credential-Identifier` in Kong 2.1.

### Paginate through the basic-auth Credentials

You can paginate through the basic-auth Credentials for all Consumers using the
following request:

{% navtabs codeblock %}
{% navtab Request %}
```bash
curl -X GET http://kong:8001/basic-auths
```
{% endnavtab %}
{% navtab Response %}
```json
{
    "total": 3,
    "data": [
        {
            "created_at": 1511379926000,
            "id": "805520f6-842b-419f-8a12-d1de8a30b29f",
            "password": "37b1af03d3860acf40bd9c681aa3ef3f543e49fe",
            "username": "baz",
            "consumer": { "id": "5e52251c-54b9-4c10-9605-b9b499aedb47" }
        },
        {
            "created_at": 1511379863000,
            "id": "8edfe5c7-3151-4d92-971f-3faa5e6c5d7e",
            "password": "451b06c564a06ce60874d0ea2f542fa8ed26317e",
            "username": "foo",
            "consumer": { "id": "89a41fef-3b40-4bb0-b5af-33da57a7ffcf" }
        },
        {
            "created_at": 1511379877000,
            "id": "f11cb0ea-eacf-4a6b-baea-a0e0b519a990",
            "password": "451b06c564a06ce60874d0ea2f542fa8ed26317e",
            "username": "foobar",
            "consumer": { "id": "89a41fef-3b40-4bb0-b5af-33da57a7ffcf" }
        }
    ]
}
```
{% endnavtab %}
{% endnavtabs %}

You can filter the list by Consumer with the following endpoint:

{% navtabs codeblock %}
{% navtab Request %}
```bash
curl -X GET http://kong:8001/consumers/{USERNAME_OR_ID}/basic-auth
```
{% endnavtab %}
{% navtab Response %}
```json
{
    "total": 1,
    "data": [
        {
            "created_at": 1511379863000,
            "id": "8edfe5c7-3151-4d92-971f-3faa5e6c5d7e",
            "password": "451b06c564a06ce60874d0ea2f542fa8ed26317e",
            "username": "foo",
            "consumer": { "id": "89a41fef-3b40-4bb0-b5af-33da57a7ffcf" }
        }
    ]
}
```
{% endnavtab %}
{% endnavtabs %}

`username` or `id`: The username or id of the consumer whose credentials need
to be listed.

### Retrieve the Consumer associated with a Credential

It is possible to retrieve a [Consumer][consumer-object] associated with a
basic-auth Credential using the following request:

{% navtabs codeblock %}
{% navtab Request %}
```bash
curl -X GET http://kong:8001/basic-auths/{USERNAME_OR_ID}/consumer
```
{% endnavtab %}
{% navtab Response %}
```json
{
   "created_at":1507936639000,
   "username":"foo",
   "id":"c0d92ba9-8306-482a-b60d-0cfdd2f0e880"
}
```
{% endnavtab %}
{% endnavtabs %}

`username or id`: The `id` or `username` property of the basic-auth
Credential for which to get the associated [Consumer][consumer-object].
Note that the `username` accepted here is **not** the `username` property of a
Consumer.

[configuration]: /gateway/latest/reference/configuration
[consumer-object]: /gateway/latest/admin-api/#consumer-object
[acl-associating]: /plugins/acl/#associating-consumers
