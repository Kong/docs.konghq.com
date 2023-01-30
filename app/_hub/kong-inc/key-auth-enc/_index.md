---
name: Key Authentication - Encrypted
publisher: Kong Inc.
desc: Add key authentication to your services
description: |
  Add key authentication (also sometimes referred to as an _API key_) to a service
  or a route. Consumers then add their key either in a query string parameter or a
  header to authenticate their requests. This plugin is functionally identical to the
  open source [Key Authentication](/hub/kong-inc/key-auth/) plugin, with the
  exception that API keys are stored in an encrypted format within the API gateway datastore.

  {:.note}
  > **Note**: Before configuring this plugin, you must enable Kong Gateway's encryption keyring. See the
  [keyring getting started guide](/gateway/latest/kong-enterprise/db-encryption#getting-started) for more details.

enterprise: true
cloud: false
type: plugin
categories:
  - authentication
kong_version_compatibility:
  enterprise_edition:
    compatible: true
---

## Case sensitivity

Note that, according to their respective specifications, HTTP header names are treated as
case _insensitive_, while HTTP query string parameter names are treated as case _sensitive_.
Kong follows these specifications as designed, meaning that the `key_names`
configuration values are treated differently when searching the request header fields versus
searching the query string. As a best practice, administrators are advised against defining
case-sensitive `key_names` values when expecting the authorization keys to be sent in the request headers.

Once applied, any user with a valid credential can access the service.
To restrict usage to certain authenticated users, also add the
[ACL](/hub/kong-inc/acl/) plugin (not covered here) and create allowed or
denied groups of users.

## Usage

### Create a consumer

You need to associate a credential to an existing [consumer][consumer-object] object.
A consumer can have many credentials.

{% navtabs %}
{% navtab With a database %}

To create a consumer, make the following request:

```bash
curl -i -X POST http://localhost:8001/consumers/ \
  --data "username=example_user" \
  --data "custom_id=SOME_CUSTOM_ID"
```
{% endnavtab %}

{% navtab Without a database %}

Your declarative configuration file will need to have one or more consumers. You can create them
on the `consumers:` yaml section:

``` yaml
consumers:
- username: example_user
  custom_id: SOME_CUSTOM_ID
```

{% endnavtab %}
{% endnavtabs %}

In both cases, the parameters are as described below:

parameter                       | description
---                             | ---
`username`<br>*semi-optional*   | The username of the consumer. Either this field or `custom_id` must be specified.
`custom_id`<br>*semi-optional*  | A custom identifier used to map the consumer to another database. Either this field or `username` must be specified.

If you are also using the [ACL](/hub/kong-inc/acl/) plugin and allow lists with this
service, you must add the new consumer to the allowed group. See
[ACL: Associating Consumers][acl-associating] for details.

### Create a key

{:.note}
> **Note:** We recommend that {{site.base_gateway}} auto generates the key.
Only specify it yourself if you are migrating an existing system to {{site.base_gateway}}.
You must reuse your keys to make the migration to {{site.base_gateway}} transparent to your consumers.

{% navtabs %}
{% navtab With a database %}

Provision new credentials by making the following HTTP request:

```bash
curl -X POST http://localhost:8001/consumers/{USERNAME_OR_ID}/key-auth-enc
```

Response:

```json
HTTP/1.1 201 Created

{
    "consumer":
       {
           "id": "876bf719-8f18-4ce5-cc9f-5b5af6c36007"
           },
    "created_at": 1443371053000,
    "id": "62a7d3b7-b995-49f9-c9c8-bac4d781fb59",
    "key": "62eb165c070a41d5c1b58d9d3d725ca1",
}
```

If you prefer to specify a key, set the `key` in the request body:

```bash
curl -X POST http://localhost:8001/consumers/{USERNAME_OR_ID}/key-auth-enc
  --data "key=myapikey"
```

Response:

```json
HTTP/1.1 201 Created

{
    "consumer": {
      "id": "876bf719-8f18-4ce5-cc9f-5b5af6c36007"
    },
    "created_at": 1443371053000,
    "id": "62a7d3b7-b995-49f9-c9c8-bac4d781fb59",
    "key": "myapikey",
}
```

{% endnavtab %}
{% navtab Without a database %}

Add credentials to your declarative config file in the `keyauth_credentials` YAML
entry:

```yaml
keyauth_credentials:
- consumer: {USERNAME_OR_ID}
  tags:
    - example_tag
  key: example_apikey
```
{% endnavtab %}
{% endnavtabs %}

The fields/parameters work as follows:

Field/parameter      | Description
---                  | ---
`{consumer}`         | The `id` or `username` property of the [consumer][consumer-object] entity to associate the credentials to.
`tags`<br>*optional* | You can optionally assign a list of tags to your `key`.
`key`<br>*optional*  | You can optionally set your own unique `key` to authenticate the client. If missing, the plugin will generate one.
`ttl`<br>*optional* | The number of seconds the key is going to be valid. If missing or set to zero, the `ttl` of the key is unlimited. If present, the value must be an integer between `0` and `100000000`. Currently, it is incompatible with DB-less mode or Hybrid mode.

### Make a request with the key

#### Key in query

To use the key in URL queries, set the configuration parameter `key_in_query` to `true` (default option).

Make a request with the key as a query string parameter:

```bash
curl http://localhost:8000/{proxy path}?apikey=<some_key>
```

#### Key in body

To use the key in a request body, set the configuration parameter `key_in_body` to `true`.
The default value is `false`.

Make a request with the key in the body:

```bash
curl http://kong:8000/{proxy path} \
  --data 'apikey: <some_key>'
```

#### Key in header

To use the key in a request body, set the configuration parameter `key_in_header` to `true` (default option).

Make a request with the key in a header:

```bash
curl http://kong:8000/{proxy path} \
  -H 'apikey: <some_key>'
```


You can also use this option with a gRPC client:

```bash
grpcurl -H 'apikey: <some_key>' ...
```

### API key locations in a request

{% include /md/plugins-hub/api-key-locations.md %}

### Disable a key location

This example disables using a key in a query parameter:

```bash
curl -X POST http://localhost:8001/routes/{route}/plugins \
    --data "name=key-auth-enc"  \
    --data "config.key_names=apikey" \
    --data "config.key_in_query=false"
```

### Delete a key

Delete an API key by making the following request:

```bash
curl -X DELETE http://localhost:8001/consumers/{USERNAME_OR_ID}/key-auth-enc/{ID}
```

Response:

```bash
HTTP/1.1 204 No Content
```

* `{USERNAME_OR_ID}`: The `id` or `username` property of the [consumer][consumer-object] entity to associate the credentials to.
* `{ID}`: The `id` attribute of the key credential object.

### Upstream Headers

{% include_cached /md/plugins-hub/upstream-headers.md %}

### Paginate through keys

Paginate through the API keys for all consumers using the following
request:

```bash
curl -X GET http://localhost:8001/key-auths-enc
```

Response:

```json
...
{
   "data":[
      {
         "id":"17ab4e95-9598-424f-a99a-ffa9f413a821",
         "created_at":1507941267000,
         "key":"Qslaip2ruiwcusuSUdhXPv4SORZrfj4L",
         "consumer": {
              "id": "c0d92ba9-8306-482a-b60d-0cfdd2f0e880"
         }
      },
      {
         "id":"6cb76501-c970-4e12-97c6-3afbbba3b454",
         "created_at":1507936652000,
         "key":"nCztu5Jrz18YAWmkwOGJkQe9T8lB99l4",
         "consumer": {
              "id": "c0d92ba9-8306-482a-b60d-0cfdd2f0e880"
         }
      },
      {
         "id":"b1d87b08-7eb6-4320-8069-efd85a4a8d89",
         "created_at":1507941307000,
         "key":"26WUW1VEsmwT1ORBFsJmLHZLDNAxh09l",
         "consumer": {
              "id": "3c2c8fc1-7245-4fbb-b48b-e5947e1ce941"
         }
      }
   ]
   "next":null,
}
```

Filter the list by consumer by using a different endpoint:

```bash
curl -X GET http://kong:8001/consumers/{USERNAME_OR_ID}/key-auth-enc
```

`{USERNAME_OR_ID}`: The username or ID of the consumer whose credentials need to be listed.

Response:

```json
...
{
    "data": [
       {
         "id":"6cb76501-c970-4e12-97c6-3afbbba3b454",
         "created_at":1507936652000,
         "key":"nCztu5Jrz18YAWmkwOGJkQe9T8lB99l4",
         "consumer": {
              "id": "c0d92ba9-8306-482a-b60d-0cfdd2f0e880"
         }
       }
    ]
    "next":null,
}
```

`{USERNAME_OR_ID}`: The username or ID of the consumer whose credentials need to be listed.

### Retrieve the consumer associated with a key

Retrieve a [consumer][consumer-object] associated with an API
key by making the following request:

```bash
curl -X GET http://kong:8001/key-auths-enc/{key or id}/consumer
```

`key or id`: The `id` or `key` property of the API key for which to get the
associated consumer.

```json
{
   "created_at":1507936639000,
   "username":"foo",
   "id":"c0d92ba9-8306-482a-b60d-0cfdd2f0e880"
}
```

[db-encryption]: /gateway/latest/plan-and-deploy/security/db-encryption
[configuration]: /gateway/latest/reference/configuration
[consumer-object]: /gateway/latest/admin-api/#consumer-object
[acl-associating]: /plugins/acl/#associating-consumers

---

