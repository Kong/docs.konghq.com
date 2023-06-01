---
nav_title: Setting up and using ACLs
---

{% if_plugin_version lte:2.8.x %}

{:.note}
> **Note**: We have deprecated the usage of `whitelist` and `blacklist` in favor of `allow` and `deny`. This change may require Admin API requests to be updated.
{% endif_plugin_version %}

## Prerequisite

Before you use the ACL plugin, configure your service or
route with an [authentication plugin](/hub/#authentication)
so that the plugin can identify the client consumer making the request.

## Associate consumers with an ACL

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

## Upstream Headers

When a consumer has been validated, the plugin appends a `X-Consumer-Groups`
header to the request before proxying it to the Upstream service, so that you can
identify the groups associated with the consumer. The value of the header is a
comma-separated list of groups that belong to the consumer, like `admin, pro_user`.

This header will not be injected in the request to the upstream service if
the `hide_groups_header` config flag is set to `true`.

### See also
- [Using the ACLs API](/)
- [{{site.base_gateway}} configuration](/gateway/latest/reference/configuration/)
