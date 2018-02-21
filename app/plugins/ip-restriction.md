---
id: page-plugin
title: Plugins - IP Restriction
header_title: IP Restriction
header_icon: /assets/images/icons/plugins/ip-restriction.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Configuration
---

Restrict access to an API by either whitelisting or blacklisting IP addresses. Single IPs, multiple IPs or ranges in [CIDR notation][cidr] like `10.10.10.0/24` can be used.

----

## Configuration

Configuring the plugin is straightforward, you can add it on top of
a [Service][service-object], a [Route][route-object], an [API][api-object]
or a [Consumer][consumer-object] by executing the following request on
your Kong server:

```bash
$ curl -X POST http://kong:8001/plugins \
    --data "name=ip-restriction" \
    --data "consumer_id={consumer}"  \
    --data "service_id={service}"  \
    --data "route_id={route}"  \
    --data "api_id={api}"  \
    --data "config.whitelist=54.13.21.1, 143.1.0.0/24"
```

`consumer`: The `id` of the Consumer that this plugin configuration will target
`service`: The `id` of the Service that this plugin configuration will target
`route`: The `id` of the Route that this plugin configuration will target
`api`: The `id` of the API that this plugin configuration will target

The term `target` is used to refer any of the possible targets for the plugin.

You can also apply it globally using the `http://kong:8001/plugins/` by not
specifying the target. Read the [Plugin Reference](/docs/latest/admin-api/#add-plugin)
for more information.

form parameter                  | default | description
---                             | ---     | ---
`name`                          |         | The name of the plugin to use, in this case: `ip-restriction`
`config.whitelist`<br>*semi-optional* |   | Comma separated list of IPs or CIDR ranges to whitelist. One of `config.whitelist` or `config.blacklist` must be specified.
`config.blacklist`<br>*semi-optional* |   | Comma separated list of IPs or CIDR ranges to blacklist. One of `config.whitelist` or `config.blacklist` must be specified.

Note that the `whitelist` and `blacklist` models are mutually exclusive in their usage, as they provide complimentary approaches. That is, you cannot configure an ACL with both `whitelist` and `blacklist` configurations. An ACL with a `whitelist` provides a positive security model, in which the configured CIDR ranges are allowed access to the resource, and all others are inherently rejected. By contrast, a `blacklist` configuration provides a negative security model, in which certain CIDRS are explicitly denied access to the resource (and all others are inherently allowed).

[cidr]: https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing#CIDR_notation
[consumer-object]: /docs/latest/admin-api/#consumer-object
[service-object]: /docs/latest/admin-api/#service-object
[route-object]: /docs/latest/admin-api/#route-object
[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
