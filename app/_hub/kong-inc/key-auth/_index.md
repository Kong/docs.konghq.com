## Case sensitivity

Note that, according to their respective specifications, HTTP header names are treated as
case _insensitive_, while HTTP query string parameter names are treated as case _sensitive_.
Kong follows these specifications as designed, meaning that the `key_names`
configuration values are treated differently when searching the request header fields versus
searching the query string. As a best practice, administrators are advised against defining
case-sensitive `key_names` values when expecting the authorization keys to be sent in the request headers.

Once applied, any user with a valid credential can access the Service.
To restrict usage to certain authenticated users, also add the
[ACL](/plugins/acl/) plugin (not covered here) and create allowed or
denied groups of users.

## Usage

### Create a Consumer

You need to associate a credential to an existing [Consumer][consumer-object] object.
A Consumer can have many credentials.

{% navtabs %}
{% navtab With a database %}

To create a Consumer, make the following request:

```bash
curl -d "username=user123&custom_id=SOME_CUSTOM_ID" http://localhost:8001/consumers/
```
{% endnavtab %}

{% navtab Without a database %}

Your declarative configuration file will need to have one or more Consumers. You can create them
on the `consumers:` yaml section:

``` yaml
consumers:
- username: user123
  custom_id: SOME_CUSTOM_ID
```

{% endnavtab %}
{% endnavtabs %}

In both cases, the parameters are as described below:

parameter                       | description
---                             | ---
`username`<br>*semi-optional*   | The username of the Consumer. Either this field or `custom_id` must be specified.
`custom_id`<br>*semi-optional*  | A custom identifier used to map the Consumer to another database. Either this field or `username` must be specified.

If you are also using the [ACL](/plugins/acl/) plugin and allow lists with this
service, you must add the new Consumer to the allowed group. See
[ACL: Associating Consumers][acl-associating] for details.

For more information about how to configure anonymous access, see [Anonymous Access](/gateway/latest/kong-plugins/authentication/reference/#anonymous-access).


### Multiple Authentication

{{site.base_gateway}} supports multiple authentication plugins for a given service, allowing different clients to use different authentication methods to access a given service or route. For more information, see [Multiple Authentication](/gateway/latest/kong-plugins/authentication/reference/#multiple-authentication).

### Create a Key

<div class="alert alert-warning">
  <strong>Note:</strong> It is recommended to let the API gateway autogenerate the key. Only specify it yourself if
  you are migrating an existing system to {{site.base_gateway}}. You must reuse your keys to make the
  migration to {{site.base_gateway}} transparent to your Consumers.
</div>

{% navtabs %}
{% navtab With a database %}

Provision new credentials by making the following HTTP request:

```bash
curl -X POST http://localhost:8001/consumers/{USERNAME_OR_ID}/key-auth
```

Response:

```
HTTP/1.1 201 Created
{
  "key": "5SRmk6gLnTy1SyQ1Cl9GzoRXJbjYGGbZ",
  "created_at": 1655412883,
  "tags": null,
  "ttl": null,
  "id": "0103844a-0b40-42c8-aa71-64e98e2e525f",
  "consumer": {
    "id": "d9e37c7d-3261-4b7b-81a6-a94bc203a0ca"
  }
}
```
{% endnavtab %}
{% navtab Without a database %}

Add credentials to your declarative config file in the `keyauth_credentials` YAML
entry:

```yaml
keyauth_credentials:
- consumer: {USERNAME_OR_ID}
  ttl: 5000
  tags:
    - example_tag
  key: example_apikey
```
{% endnavtab %}
{% endnavtabs %}

In both cases, the fields/parameters work as follows:

field/parameter      | description
---                  | ---
`{USERNAME_OR_ID}`   | The `id` or `username` property of the [Consumer][consumer-object] entity to associate the credentials to.
`ttl`<br>*optional*  | The number of seconds the key is going to be valid. If missing or set to zero, the `ttl` of the key is unlimited. If present, the value must be an integer between 0 and 100000000. Currently, it is incompatible with DB-less mode or Hybrid mode.
`tags`<br>*optional* | You can optionally assign a list of tags to your `key`.
`key`<br>*optional*  | You can optionally set your own unique `key` to authenticate the client. If missing, the plugin will generate one.

### Make a Request with the Key

{% if_plugin_version gte:2.3.x %}

Make a request with the key as a query string parameter:

```bash
curl http://localhost:8000/{proxy path}?apikey={some_key}
```

**Note:** The `key_in_query` plugin parameter must be set to `true` (default).


Make a request with the key in a header:

```bash
curl http://localhost:8000/{proxy path} \
    -H 'apikey: {some_key}'
```

**Note:** The `key_in_header` plugin parameter must be set to `true` (default).

{% endif_plugin_version %}

Make a request with the key in the body:

```bash
curl http://localhost:8000/{proxy path} \
    --data 'apikey: {some_key}'
```

**Note:** The `key_in_body` plugin parameter must be set to `true` (default is `false`).

gRPC clients are supported too:

```bash
grpcurl -H 'apikey: {some_key}' ...
```

{% if_plugin_version gte:2.3.x %}

### About API Key Locations in a Request

{% include /md/plugins-hub/api-key-locations.md %}

### Disable a Key Location

This example disables using a key in a query parameter:

```bash
curl -X POST http://localhost:8001/routes/{NAME_OR_ID}/plugins \
    --data "name=key-auth"  \
    --data "config.key_names=apikey" \
    --data "config.key_in_query=false"
```

{% endif_plugin_version %}

### Delete a Key

Delete an API Key by making the following request:

```bash
curl -X DELETE http://localhost:8001/consumers/{USERNAME_OR_ID}/key-auth/{ID}
```

Response:

```bash
HTTP/1.1 204 No Content
```

* `USERNAME_OR_ID`: The `id` or `username` property of the [Consumer][consumer-object] entity to associate the credentials to.
* `ID`: The `id` attribute of the key credential object.

### Upstream Headers

{% include_cached /md/plugins-hub/upstream-headers.md %}

### Paginate through keys

Paginate through the API keys for all Consumers by making the following
request:

```bash
curl -X GET http://localhost:8001/key-auths
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
         "consumer": { "id": "c0d92ba9-8306-482a-b60d-0cfdd2f0e880" }
      },
      {
         "id":"6cb76501-c970-4e12-97c6-3afbbba3b454",
         "created_at":1507936652000,
         "key":"nCztu5Jrz18YAWmkwOGJkQe9T8lB99l4",
         "consumer": { "id": "c0d92ba9-8306-482a-b60d-0cfdd2f0e880" }
      },
      {
         "id":"b1d87b08-7eb6-4320-8069-efd85a4a8d89",
         "created_at":1507941307000,
         "key":"26WUW1VEsmwT1ORBFsJmLHZLDNAxh09l",
         "consumer": { "id": "3c2c8fc1-7245-4fbb-b48b-e5947e1ce941" }
      }
   ]
   "next":null,
}
```

Filter the list by Consumer by using a different endpoint:

```bash
curl -X GET http://localhost:8001/consumers/{USERNAME_OR_ID}/key-auth
```

In the above, substitute the `username` or `id` property associated with the Consumer.

Response:

```json
...
{
    "data": [
       {
         "id":"6cb76501-c970-4e12-97c6-3afbbba3b454",
         "created_at":1507936652000,
         "key":"nCztu5Jrz18YAWmkwOGJkQe9T8lB99l4",
         "consumer": { "id": "c0d92ba9-8306-482a-b60d-0cfdd2f0e880" }
       }
    ]
    "next":null,
}
```

### Retrieve the Consumer associated with a key

Retrieve a [Consumer][consumer-object] associated with an API
key by making the following request:

```bash
curl -X GET http://localhost:8001/key-auths/{KEY_OR_ID}/consumer
```

In the above, substitute either the `key` or `id` property associated with the key authentication entity.

Response:

```json
{
   "created_at":1507936639000,
   "username":"foo",
   "id":"c0d92ba9-8306-482a-b60d-0cfdd2f0e880"
}
```

[configuration]: /gateway/latest/reference/configuration
[consumer-object]: /gateway/latest/admin-api/#consumer-object
[acl-associating]: /plugins/acl/#associating-consumers


### Request behavior matrix

The following table describes how {{site.base_gateway}} behaves in various scenarios:

Description | Proxied to upstream service? | Response status code
--------|-----------------------------|---------------------
The request has a valid API key. | Yes | 200
No API key is provided. | No | 401
The API key is known to {{site.base_gateway}} | No | 401
A runtime error occurred. | No | 500

