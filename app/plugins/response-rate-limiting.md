---
id: page-plugin
title: Plugins - Response Rate Limiting
header_title: Response Rate Limiting
header_icon: /assets/images/icons/plugins/response-rate-limiting.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Installation
      - label: Configuration
      - label: Usage
      - label: Headers sent to the client
---

This plugin allows you to limit the number of requests a developer can make based on a custom response header returned by the upstream API. You can arbitrary set as many rate-limiting objects (or quotas) as you want and instruct Kong to increase or decrease them by any number of units. Each custom rate-limiting object can limit the inbound requests per seconds, minutes, hours, days, months or years.

If the API has no authentication layer, the **Client IP** address will be used, otherwise the Consumer will be used if an authentication plugin has been configured.

----

## Installation

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml][configuration] configuration file:

```yaml
plugins_available:
  - response-ratelimiting
```

Every node in the Kong cluster should have the same `plugins_available` property value.

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=response-ratelimiting" \
    --data "config.limits.{limit_name}.minute=10"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter                      | required        | description
---                                 | ---             | ---
`name`                              | *required*      | The name of the plugin to use, in this case: `response-ratelimiting`
`consumer_id`                       | *optional*      | The CONSUMER ID that this plugin configuration will target. This value can only be used if [authentication has been enabled][faq-authentication] so that the system can identify the user making the request.
`config.header_name`                | *optional*      | The name of the response header used to increment the counters. By default is `X-Kong-Limit`.
`config.limits.{limit_name}`        | *required*      |  This is a list of custom objects that you can set on the API, with arbitrary names set in the `{limit_name`} placeholder, like `config.limits.sms.minute=20` if your object is called "SMS".
`config.limits.{limit_name}.second` | *semi-optional* | The amount of HTTP requests the developer can make per second. At least one limit must exist.
`config.limits.{limit_name}.minute` | *semi-optional* | The amount of HTTP requests the developer can make per minute. At least one limit must exist.
`config.limits.{limit_name}.hour`   | *semi-optional* | The amount of HTTP requests the developer can make per hour. At least one limit must exist.
`config.limits.{limit_name}.day`    | *semi-optional* | The amount of HTTP requests the developer can make per day. At least one limit must exist.
`config.limits.{limit_name}.month`  | *semi-optional* | The amount of HTTP requests the developer can make per month. At least one limit must exist.
`config.limits.{limit_name}.year`   | *semi-optional* | The amount of HTTP requests the developer can make per year. At least one limit must exist.

----

## Usage

After adding the plugin, you can increment the configured limits by adding the following response header:

```
Header-Name: Limit=Value [,Limit=Value]
```

Since `X-Kong-Limit` is the default header name (you can optionally change it), it will look like:

```
X-Kong-Limit: limitname1=2, limitname2=4
```

That will increment the limit `limitname1` by 2 units, and `limitname2` by 4 units.

You can optionally increment more than one limit by comma separating the entries. The header will be removed before returning the response to the original client.

## Headers sent to the client

When this plugin is enabled, Kong will send some additional headers back to the client telling how many units are available and how many are allowed. For example if you created a limit/quota called "Videos" with a per-minute limit:

```
X-RateLimit-Limit-Videos-Minute: 10
X-RateLimit-Remaining-Videos-Minute: 9
```

or it will return a combination of more time limits, if more than one is being set:

```
X-RateLimit-Limit-Videos-Second: 5
X-RateLimit-Remaining-Videos-Second: 5
X-RateLimit-Limit-Videos-Minute: 10
X-RateLimit-Remaining-Videos-Minute: 10
```

If any of the limits configured is being reached, the plugin will return a `HTTP/1.1 429` status code and an empty body.

[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
