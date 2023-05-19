{% if_plugin_version eq:2.0.x %}

The `whitelist` and `blacklist` models are mutually exclusive in their usage, as they provide complimentary approaches. That is, you cannot configure an ACL with both `whitelist` and `blacklist` configurations. An ACL with a `whitelist` provides a positive security model, in which the configured groups are allowed access to the resources, and all others are inherently rejected. By contrast, a `blacklist` configuration provides a negative security model, in which certain groups are explicitly denied access to the resource (and all others are inherently allowed).

{% endif_plugin_version %}

{% if_plugin_version gte:2.1.x %}

You can't configure an ACL with both `allow` and `deny` configurations. An ACL with an `allow` provides a positive security model, in which the configured groups are allowed access to the resources, and all others are inherently rejected. By contrast, a `deny` configuration provides a negative security model, in which certain groups are explicitly denied access to the resource (and all others are  allowed).

{% endif_plugin_version %}

## Usage

{% if_plugin_version gte:2.1.x and lte:2.8.x %}

{:.note}
> **Note**: We have deprecated the usage of `whitelist` and `blacklist` in favor of `allow` and `deny`. This change may require Admin API requests to be updated.
{% endif_plugin_version %}

Before you use the ACL plugin, configure your Service or
Route with an [authentication plugin](/hub/#authentication)
so that the plugin can identify the client consumer making the request.

#### Associate consumers with an ACL

{% navtabs %}
{% navtab With a database %}

After you have added an authentication plugin to a Service or a Route, and you have
created your [consumers](/gateway/latest/admin-api/#consumer-object), you can now
associate a group to a consumer using the following request:

```bash
curl -X POST http://{HOST}:8001/consumers/{CONSUMER}/acls \
    --data "group=group1" \
    --data "tags[]=tag1" \
    --data "tags[]=tag2"
```

`CONSUMER`: The `username` property of the consumer entity to associate the credentials with.

form parameter        | default| description
---                   | ---    | ---
`group`               |        | The arbitrary group name to associate with the consumer.
`tags`                |        | Optional descriptor tags for the group.

{% endnavtab %}
{% navtab Without a database %}
You can create ACL objects via the `acls` entry in the declarative configuration file:

``` yaml
acls:
- consumer: {CONSUMER}
  group: group1
  tags: { tag1 }
```

* `CONSUMER`: The `id` or `username` property of the Consumer entity to associate the credentials to.
* `group`: The arbitrary group name to associate to the Consumer.
* `tags`: Optional descriptor tags for the group.
{% endnavtab %}
{% endnavtabs %}

You can have more than one group associated to a consumer.

### Upstream Headers

When a consumer has been validated, the plugin appends a `X-Consumer-Groups`
header to the request before proxying it to the Upstream service, so that you can
identify the groups associated with the consumer. The value of the header is a
comma-separated list of groups that belong to the consumer, like `admin, pro_user`.

This header will not be injected in the request to the upstream service if
the `hide_groups_header` config flag is set to `true`.

### Return ACLs

Retrieves paginated ACLs.

```bash
curl -X GET http://{HOST}:8001/acls
```

Result:
```
{
    "total": 3,
    "data": [
        {
            "group": "foo-group",
            "created_at": 1511391159000,
            "id": "724d1be7-c39e-443d-bf36-41db17452c75",
            "consumer": { "id": "89a41fef-3b40-4bb0-b5af-33da57a7ffcf" }
        },
        {
            "group": "bar-group",
            "created_at": 1511391162000,
            "id": "0905f68e-fee3-4ecb-965c-fcf6912bf29e",
            "consumer": { "id": "c0d92ba9-8306-482a-b60d-0cfdd2f0e880" }
        },
        {
            "group": "baz-group",
            "created_at": 1509814006000,
            "id": "ff883d4b-aee7-45a8-a17b-8c074ba173bd",
            "consumer": { "id": "c0d92ba9-8306-482a-b60d-0cfdd2f0e880" }
        }
    ]
}
```

#### Retrieve ACLs by consumer

Retrieves ACLs by consumer.

```bash
curl -X GET http://{HOST}:8001/consumers/{CONSUMER}/acls
```

Result:
```
{
    "total": 1,
    "data": [
        {
            "group": "bar-group",
            "created_at": 1511391162000,
            "id": "0905f68e-fee3-4ecb-965c-fcf6912bf29e",
            "consumer": { "id": "c0d92ba9-8306-482a-b60d-0cfdd2f0e880" }
        }
    ]
}
```

`CONSUMER`: The `username` or `id` of the consumer.

### Retrieve ACL by ID

Retrieves ACL by ID if the ACL belongs to the specified consumer.

```bash
curl -X GET http://{HOST}:8001/consumers/{CONSUMER}/acls/{ID}
```

Result:
```
{
    "group": "foo-group",
    "created_at": 1511391159000,
    "id": "724d1be7-c39e-443d-bf36-41db17452c75",
    "consumer": { "id": "89a41fef-3b40-4bb0-b5af-33da57a7ffcf" }
}
```

`CONSUMER`: The `username` property of the consumer entity.

`ID`: The `id` property of the ACL.  

#### Retrieve the consumer associated with an ACL

Retrieves a consumer associated with an ACL
using the following request:

```bash
curl -X GET http://{HOST}:8001/acls/{ID}/consumer
```

Result:
```
{
   "created_at":1507936639000,
   "username":"foo",
   "id":"c0d92ba9-8306-482a-b60d-0cfdd2f0e880"
}
```

`ID`: The `id` property of the ACL.

#### Update and insert an ACL group name

Update and insert the group name of the ACL by passing a new group name.

```bash
curl -X PUT http://{HOST}:8001/consumers/{CONSUMER}/acls/{ID}
  --data "group=newgroupname"
```

`CONSUMER`: The `username` property of the consumer entity.

`ID`: The `id` property of the ACL.  

### Update an ACL group by ID

Updates an ACL group name by passing a new group name.

```bash
curl -X POST http://{HOST}:8001/consumers/{CONSUMER}/acls \
    --data "group=group1"
```

`CONSUMER`: The `username` property of the consumer entity.

#### Remove an ACL group for a consumer

Deletes an ACL group by ID or group name.

```bash
curl -X DELETE http://{HOST}:8001/consumers/{CONSUMER}/acls/{ID}
```

`ID`: The `id` property of the ACL.  

Deletes an ACL group by group name.

```bash
curl -X DELETE http://{HOST}:8001/consumers/{CONSUMER}/acls/{GROUP}
```

`GROUP`: The `group` property of the ACL.  

A successful DELETE request returns a `204` status.

### See also
- [configuration](/gateway/latest/reference/configuration/)
