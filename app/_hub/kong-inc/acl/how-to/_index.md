---
nav_title: Setting up and using ACLs
title: Setting up and using ACLs
---

## Setting up and using ACLs

{% if_plugin_version lte:2.8.x %}

{:.note}
> **Note**: We have deprecated the usage of `whitelist` and `blacklist` in favor of `allow` and `deny`. This change may require Admin API requests to be updated.
{% endif_plugin_version %}

### Prerequisites

* Configure your service or route with an [authentication plugin](/hub/#authentication)
so that the plugin can identify the client consumer making the request.
* [Enable the ACL plugin](/hub/kong-inc/acl/how-to/basic-example/)

### Associate consumers with an ACL

{% navtabs %}
{% navtab With a database %}

After you have added an authentication plugin to a Service or a Route, and you have
created your [consumers](/gateway/api/admin-ee/latest/#/Consumers/list-consumer/), you can now
associate a group to a consumer using the following request:

```bash
curl -X POST http://localhost:8001/consumers/{CONSUMER}/acls \
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

## Upstream headers

When a consumer has been validated, the plugin appends a `X-Consumer-Groups`
header to the request before proxying it to the Upstream service, so that you can
identify the groups associated with the consumer. The value of the header is a
comma-separated list of groups that belong to the consumer, like `admin, pro_user`.

This header will not be injected in the request to the upstream service if
the `hide_groups_header` config flag is set to `true`.

## More information
- [Using the ACLs API](/hub/kong-inc/acl/api/)
- [{{site.base_gateway}} configuration](/gateway/latest/reference/configuration/)
