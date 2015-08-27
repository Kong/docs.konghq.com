---
id: page-plugin
title: Plugins - IP Restriction
header_title: IP Restriction
header_icon: /assets/images/icons/plugins/ip-restriction.png
breadcrumbs:
  Plugins: /plugins
---

Restrict access to an API by either whitelisting or blacklisting IP addresses. Single IPs, multiple IPs or ranges in [CIDR notation][cidr] like `10.10.10.0/24` can be used.

----

## Installation

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml][configuration] configuration file:

```yaml
plugins_available:
  - ip-restriction
```

Every node in the Kong cluster should have the same `plugins_available` property value.

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=ip-restriction" \
    --data "value.whitelist=54.13.21.1, 143.1.0.0/24" \
    --data "value.blacklist=184.31.52.75"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter                  | description
---                             | ---
`name`                          | The name of the plugin to use, in this case: `ip-restriction`
`consumer_id`<br>*optional*     | The CONSUMER ID that this plugin configuration will target. This value can only be used if [authentication has been enabled][faq-authentication] so that the system can identify the user making the request.
`value.whitelist`<br>*optional* | Comma separated list of IPs or CIDR ranges to whitelist. Whitelist always takes the precedence over blackist.
`value.blacklist`<br>*optional* | Comma separated list of IPs or CIDR ranges to blacklist.

[cidr]: https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing#CIDR_notation
[api-object]: /docs/{{site.data.kong_latest.release}}/admin-api/#api-object
[configuration]: /docs/{{site.data.kong_latest.release}}/configuration
[consumer-object]: /docs/{{site.data.kong_latest.release}}/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
