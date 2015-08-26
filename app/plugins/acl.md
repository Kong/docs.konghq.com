---
id: page-plugin
title: Plugins - ACL
header_title: ACL
header_icon: /assets/images/icons/plugins/ip-restriction.png
breadcrumbs:
  Plugins: /plugins
---

Restrict access to an API by whitelisting or blacklisting consumers using arbitrary ACL group names. This plugin requires an [authentication plugin][faq-authentication] to have been already enabled on the API.

----

## Installation

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml][configuration] configuration file:

```yaml
plugins_available:
  - acl
```

Every node in the Kong cluster should have the same `plugins_available` property value.

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=acl" \
    --data "value.whitelist=group1, group2" \
    --data "value.blacklist=group3, group4"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter                  | description
---                             | ---
`name`                          | The name of the plugin to use, in this case: `acl`
`value.whitelist`<br>*optional* | Comma separated list of arbitrary group names that are allowed to consume the API. Whitelist always takes the precedence over blackist.
`value.blacklist`<br>*optional* | Comma separated list of arbitrary group names that are not allowed to consume the API.

## Usage

In order to use this plugin, you need to properly have configured your APIs with an [authentication plugin][faq-authentication] so that the plugin can identify who is the client [Consumer][consumer-object] making the request.

### Associating a consumer with an ACL group

Once you have added an authentication plugin to an API, and you have created your [Consumers][consumer-object], you can now associate a group to a [Consumer][consumer-object] using the following request:

```bash
$ curl -X POST http://kong:8001/consumers/{consumer}/acls \
    --data "group=group1"
```

`consumer`: The `id` or `username` property of the [Consumer][consumer-object] entity to associate the credentials to.

form parameter      | description
---                 | ---
`group`             | The arbitrary group name to associate to the consumer.

You can have more than one group associated to a consumer.

[cidr]: https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing#CIDR_notation
[api-object]: /docs/{{site.data.kong_latest.release}}/admin-api/#api-object
[configuration]: /docs/{{site.data.kong_latest.release}}/configuration
[consumer-object]: /docs/{{site.data.kong_latest.release}}/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
