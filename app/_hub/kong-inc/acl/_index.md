---
name: ACL
publisher: Kong Inc.
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
      - 2.8.x
      - 2.7.x
      - 2.6.x
      - 2.5.x
      - 2.4.x
      - 2.3.x
      - 2.2.x
      - 2.1.x
      - 2.0.x
  enterprise_edition:
    compatible:
      - 2.8.x
      - 2.7.x
      - 2.6.x
      - 2.5.x
      - 2.4.x
      - 2.3.x
      - 2.2.x
      - 2.1.x

params:
  name: acl
  service_id: true
  route_id: true
  consumer_id: false
  protocols:
    - http
    - https
  dbless_compatible: partially
  dbless_explanation: |
    Consumers and ACLs can be created with declarative configuration.

    Admin API endpoints that POST, PUT, PATCH, or DELETE ACLs do not work in DB-less mode.
  config:
  # deprecated parameters
    - name: whitelist
      required: semi
      default:
      value_in_examples: group1, group2
      description: |
        Comma separated list of arbitrary group names that are allowed to consume the Service or the Route (or API). One of `config.whitelist` or `config.blacklist` must be specified.
      maximum_version: "2.0.x"
    - name: blacklist
      required: semi
      default:
      description: |
        Comma separated list of arbitrary group names that are not allowed to consume the Service or the Route (or API). One of `config.whitelist` or `config.blacklist` must be specified.
      maximum_version: "2.0.x"

  # current parameters
    - name: allow
      required: semi
      default: null
      value_in_examples:
        - group1
        - group2
      datatype: array of string elements
      description: |
        Arbitrary group names that are allowed to consume the Service or Route. One of `config.allow` or `config.deny` must be specified.
      minimum_version: "2.1.x"
    - name: deny
      required: semi
      default: null
      datatype: array of string elements
      description: |
        Arbitrary group names that are not allowed to consume the Service or Route. One of `config.allow` or `config.deny` must be specified.
      minimum_version: "2.1.x"
    - name: hide_groups_header
      required: true
      default: false
      value_in_examples: true
      datatype: boolean
      description: |
        Flag that if enabled (`true`), prevents the `X-Consumer-Groups` header to be sent in the request to the Upstream service.
---

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
so that the plugin can identify the client Consumer making the request.

### Associate Consumers to an ACL

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

### Upstream Headers

When a consumer has been validated, the plugin appends a `X-Consumer-Groups`
header to the request before proxying it to the Upstream service, so that you can
identify the groups associated with the Consumer. The value of the header is a
comma-separated list of groups that belong to the Consumer, like `admin, pro_user`.

This header will not be injected in the request to the Upstream service if
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

### Retrieve ACLs by Consumer

Retrieves ACLs by Consumer.

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

`CONSUMER`: The `username` or `id` of the Consumer.

### Retrieve ACL by ID

Retrieves ACL by ID if the ACL belongs to the specified Consumer.

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

`CONSUMER`: The `username` property of the Consumer entity.

`ID`: The `id` property of the ACL.  

### Retrieve the Consumer associated with an ACL

Retrieves a Consumer associated with an ACL
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

### Upsert an ACL group name

Upserts the group name of the ACL by passing a new group name.

```bash
curl -X PUT http://{HOST}:8001/consumers/{CONSUMER}/acls/{ID}
  --data "group=newgroupname"
```

`CONSUMER`: The `username` property of the Consumer entity.

`ID`: The `id` property of the ACL.  

### Update an ACL group by ID

Updates an ACL group name by passing a new group name.

```bash
curl -X POST http://{HOST}:8001/consumers/{CONSUMER}/acls \
    --data "group=group1"

```

`CONSUMER`: The `username` property of the Consumer entity.

### Remove an ACL group for a Consumer

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
- [configuration](/gateway/latest/reference/configuration)

{% if_plugin_version gte:2.1.x %}

---

## Changelog

{% if_plugin_version gte:3.0.x %}

### Kong Gateway 3.0.x
- Removed the deprecated `whitelist` and `blacklist` parameters.
They are no longer supported.

{% endif_plugin_version %}

### Kong Gateway 2.1.x (plugin version 2.0.0)

- Use `allow` and `deny` instead of `whitelist` and `blacklist`

{% endif_plugin_version %}
