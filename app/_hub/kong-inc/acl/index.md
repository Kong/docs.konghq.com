---
name: ACL
publisher: Kong Inc.
version: 1.0.0

desc: Control which Consumers can access Services
description: |
  Restrict access to a Service or a Route by adding Consumers to allowed or
  denied lists using arbitrary ACL groups. This plugin requires an
  [authentication plugin](/hub/#authentication) (such as
  [Basic Authentication](/hub/kong-inc/basic-auth/),
  [Key Authentication](/hub/kong-inc/key-auth/), [OAuth 2.0](/hub/kong-inc/oauth2/),
  and [OpenID Connect](/hub/kong-inc/openid-connect/))
  to have been already enabled on the Service or Route.

type: plugin
categories:
  - traffic-control

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
  name: acl
  service_id: true
  route_id: true
  consumer_id: false
  protocols: ["http", "https"]
  dbless_compatible: partially
  dbless_explanation: |
    Consumers and ACLs can be created with declarative configuration.
    
    Admin API endpoints that POST, PUT, PATCH, or DELETE ACLs do not work in DB-less mode.
  config:
    - name: allow
      required: semi
      default:
      value_in_examples: [ "group1", "group2" ]
      datatype: array of string elements
      description: |
        Arbitrary group names that are allowed to consume the Service or Route. One of `config.allow` or `config.deny` must be specified.
    - name: deny
      required: semi
      default:
      datatype: array of string elements
      description: |
        Arbitrary group names that are not allowed to consume the Service or Route. One of `config.allow` or `config.deny` must be specified.
    - name: hide_groups_header
      required: true
      default: false
      value_in_examples: true
      datatype: boolean
      description: |
        Flag that if enabled (`true`), prevents the `X-Consumer-Groups` header to be sent in the request to the Upstream service.
  extra: |
    Note that you cannot configure an ACL with both `allow` and `deny` configurations. An ACL with an `allow` provides a positive security model, in which the configured groups are allowed access to the resources, and all others are inherently rejected. By contrast, a `deny` configuration provides a negative security model, in which certain groups are explicitly denied access to the resource (and all others are  allowed).
---

### Usage

Before you use the ACL plugin, configure your Service or
Route with an [authentication plugin](/hub/#authentication)
so that the plugin can identify the client Consumer making the request.

#### Associate Consumers to an ACL

{% navtabs %}
{% navtab With a database %}

After you have added an authentication plugin to a Service or a Route, and you have
created your [Consumers](/gateway/latest/admin-api/#consumer-object), you can now
associate a group to a Consumer using the following request:

```bash
curl -X POST http://{HOST}:8001/consumers/{CONSUMER}/acls \
    --data "group=group1, tags={'tag1', 'tag2'}"
```

`CONSUMER`: The `username` property of the Consumer entity to associate the credentials to.

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

You can have more than one group associated to a Consumer.

#### Upstream Headers

When a consumer has been validated, the plugin appends a `X-Consumer-Groups`
header to the request before proxying it to the Upstream service, so that you can
identify the groups associated with the Consumer. The value of the header is a
comma-separated list of groups that belong to the Consumer, like `admin, pro_user`.

This header will not be injected in the request to the Upstream service if
the `hide_groups_header` config flag is set to `true`.

#### Return ACLs

Retrieves paginated ACLs. 

```bash
curl -X GET http://{HOST}:8001/acls

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

#### Retrieve ACLs by Consumer

Retrieves ACLs by Consumer. 

```bash
curl -X GET http://{HOST}:8001/consumers/{CONSUMER}/acls

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

`CONSUMER`: The `username` or `id` of the Consumer.

#### Retrieve Consumer by ID

Retrieves a Consumer by ID if the ACL belongs to the specified Consumer. 

```bash
curl -X GET http://{HOST}:8001/consumers/{CONSUMER}/acls/{ID}

{
    "group": "foo-group",
    "created_at": 1511391159000,
    "id": "724d1be7-c39e-443d-bf36-41db17452c75",
    "consumer": { "id": "89a41fef-3b40-4bb0-b5af-33da57a7ffcf" }
}
```

`CONSUMER`: The `username` property of the Consumer entity.

`ID`: The Consumer ID.  

#### Retrieve the Consumer associated with an ACL

Retrieves a Consumer associated with an ACL
using the following request:

```bash
curl -X GET http://{HOST}:8001/acls/{ID}/consumer

{
   "created_at":1507936639000,
   "username":"foo",
   "id":"c0d92ba9-8306-482a-b60d-0cfdd2f0e880"
}
```

`ID`: The `id` property of the ACL for which to get the associated
Consumer.

#### Upsert an ACL group name

Upserts the group name of the ACL. 

```bash
curl -X PUT 'http://{HOST}:8001/consumers/{CONSUMER}/acls/{ID}'

{
    "group": "foo-group",
    "created_at": 1511391159000,
    "id": "724d1be7-c39e-443d-bf36-41db17452c75",
    "consumer": { "id": "89a41fef-3b40-4bb0-b5af-33da57a7ffcf" }
}
```

`CONSUMER`: The `username` property of the Consumer entity.

`ID`: The Consumer ID.  

#### Update an ACL group by ID

Updates an ACL group name by passing a new group name. 

```bash
curl -X POST http://{HOST}:8001/consumers/{CONSUMER}/acls \
    --data "group=group1"

{
    "group": "group1",
    "created_at": 1511391159000,
    "id": "724d1be7-c39e-443d-bf36-41db17452c75",
    "consumer": { "id": "89a41fef-3b40-4bb0-b5af-33da57a7ffcf" }
}
```

`CONSUMER`: The `username` property of the Consumer entity.

`group`: The arbitrary group name to associate to the Consumer.

#### Delete an ACL group

Deletes an ACL group by ID or group. 

```bash
curl -X DELETE http://{HOST}:8001/consumers/{CONSUMER}/acls 
```

A successful DELETE request returns a `204` status. 

#### See also
- [configuration](/gateway/latest/reference/configuration)
