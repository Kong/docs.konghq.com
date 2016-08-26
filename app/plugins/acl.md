---
id: page-plugin
title: Plugins - ACL
header_title: ACL
header_icon: /assets/images/icons/plugins/acl.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Configuration
  - label: Usage
    items:
      - label: Associating Consumers
      - label: Upstream Headers
---

Restrict access to an API by whitelisting or blacklisting consumers using arbitrary ACL group names. This plugin requires an [authentication plugin][faq-authentication] to have been already enabled on the API.

----

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=acl" \
    --data "config.whitelist=group1, group2"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

You can also apply it for every API using the `http://kong:8001/plugins/` endpoint. Read the [Plugin Reference](/docs/latest/admin-api/#add-plugin) for more information.

form parameter                        | default| description
---                                   | ---    | ---
`name`                                |        | The name of the plugin to use, in this case: `acl`
`config.whitelist`<br>*semi-optional* |        | Comma separated list of arbitrary group names that are allowed to consume the API. At least one between `config.whitelist` or `config.blacklist` must be specified.
`config.blacklist`<br>*semi-optional* |        | Comma separated list of arbitrary group names that are not allowed to consume the API. At least one between `config.whitelist` or `config.blacklist` must be specified.

----

## Usage

In order to use this plugin, you need to properly have configured your APIs with an [authentication plugin][faq-authentication] so that the plugin can identify who is the client [Consumer][consumer-object] making the request.

### Associating Consumers

Once you have added an authentication plugin to an API, and you have created your [Consumers][consumer-object], you can now associate a group to a [Consumer][consumer-object] using the following request:

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

When a consumer has been validated, the plugin will append a `X-Consumer-Groups` header to the request before proxying it to the upstream API/Microservice, so that you can identify the groups associated with the consumer. The value of the header is a comma separated list of groups that belong to the consumer, like `admin, pro_user`.


[cidr]: https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing#CIDR_notation
[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
