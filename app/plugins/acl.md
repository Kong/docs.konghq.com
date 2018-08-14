---
id: page-plugin
title: Plugins - ACL
header_title: ACL
header_icon: /assets/images/icons/plugins/acl.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Usage
    items:
      - label: Associating Consumers
      - label: Upstream Headers
      - label: Paginate through the ACLs
      - label: Retrieve the Consumer associated with an ACL

description: |
  Restrict access to a Service or a Route (or the deprecated API entity) by whitelisting or blacklisting consumers using arbitrary ACL group names. This plugin requires an [authentication plugin](/about/faq/#how-can-i-add-authentication-to-a-microservice-api) to have been already enabled on the Service or the Route (or API).

params:
  name: acl
  api_id: true
  service_id: true
  route_id: true
  consumer_id: false
  config:
    - name: whitelist
      required: semi
      default:
      value_in_examples: group1, group2
      description: |
        Comma separated list of arbitrary group names that are allowed to consume the Service or the Route (or API). One of `config.whitelist` or `config.blacklist` must be specified.
    - name: blacklist
      required: semi
      default:
      description: |
        Comma separated list of arbitrary group names that are not allowed to consume the Service or the Route (or API). One of `config.whitelist` or `config.blacklist` must be specified.
    - name: hide_groups_header
      required: false
      default: false
      value_in_examples: true
      description: |
        Flag which if enabled (`true`), prevents the `X-Consumer-Groups` header to be sent in the request to the upstream service. 
  extra: |
    Note that the `whitelist` and `blacklist` models are mutually exclusive in their usage, as they provide complimentary approaches. That is, you cannot configure an ACL with both `whitelist` and `blacklist` configurations. An ACL with a `whitelist` provides a positive security model, in which the configured groups are allowed access to the resources, and all others are inherently rejected. By contrast, a `blacklist` configuration provides a negative security model, in which certain groups are explicitly denied access to the resource (and all others are inherently allowed).

---

## Usage

In order to use this plugin, you need to properly have configured your Service or Route (or API) with an [authentication plugin][faq-authentication] so that the plugin can identify who is the client [Consumer][consumer-object] making the request.

### Associating Consumers

Once you have added an authentication plugin to a Service or a Route (or API) and you have created your [Consumers][consumer-object], you can now associate a group to a [Consumer][consumer-object] using the following request:

```bash
$ curl -X POST http://kong:8001/consumers/{consumer}/acls \
    --data "group=group1"
```

`consumer`: The `id` or `username` property of the [Consumer][consumer-object] entity to associate the credentials to.

form parameter        | default| description
---                   | ---    | ---
`group`               |        | The arbitrary group name to associate to the consumer.

You can have more than one group associated to a consumer.

### Upstream Headers

When a consumer has been validated, the plugin will append a `X-Consumer-Groups` header to the request before proxying it to the upstream service, so that you can identify the groups associated with the consumer. The value of the header is a comma separated list of groups that belong to the consumer, like `admin, pro_user`.

This header will not be injected in the request to the upstream service if the `hide_groups_header` config flag is set to `true`.

### Paginate through the ACLs

<div class="alert alert-warning">
  <strong>Note:</strong> This endpoint was introduced in Kong 0.11.2.
</div>

You can retrieve all the ACLs for all Consumers using the following
request:

```bash
$ curl -X GET http://kong:8001/acls

{
    "total": 3,
    "data": [
        {
            "group": "foo-group",
            "created_at": 1511391159000,
            "id": "724d1be7-c39e-443d-bf36-41db17452c75",
            "consumer_id": "89a41fef-3b40-4bb0-b5af-33da57a7ffcf"
        },
        {
            "group": "bar-group",
            "created_at": 1511391162000,
            "id": "0905f68e-fee3-4ecb-965c-fcf6912bf29e",
            "consumer_id": "c0d92ba9-8306-482a-b60d-0cfdd2f0e880"
        },
        {
            "group": "baz-group",
            "created_at": 1509814006000,
            "id": "ff883d4b-aee7-45a8-a17b-8c074ba173bd",
            "consumer_id": "c0d92ba9-8306-482a-b60d-0cfdd2f0e880"
        }
    ]
}
```

You can filter the list using the following query parameters:

Attributes | Description
---:| ---
`id`<br>*optional*                       | A filter on the list based on the ACL `id` field.
`group`<br>*optional*                 	 | A filter on the list based on the ACL `group` field.
`consumer_id`<br>*optional*              | A filter on the list based on the ACL `consumer_id` field.
`size`<br>*optional, default is __100__* | A limit on the number of objects to be returned.
`offset`<br>*optional*                   | A cursor used for pagination. `offset` is an object identifier that defines a place in the list.

### Retrieve the Consumer associated with an ACL

<div class="alert alert-warning">
  <strong>Note:</strong> This endpoint was introduced in Kong 0.11.2.
</div>

It is possible to retrieve a [Consumer][consumer-object] associated with an ACL
using the following request:

```bash
curl -X GET http://kong:8001/acls/{id}/consumer

{
   "created_at":1507936639000,
   "username":"foo",
   "id":"c0d92ba9-8306-482a-b60d-0cfdd2f0e880"
}
```

`id`: The `id` property of the ACL for which to get the associated
[Consumer][consumer-object].

[cidr]: https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing#CIDR_notation
[api-object]: /latest/admin-api/#api-object
[configuration]: /latest/configuration
[consumer-object]: /latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-authentication-to-a-microservice-api
