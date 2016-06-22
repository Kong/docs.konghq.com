---
id: page-plugin
title: Plugins - Rate Limiting
header_title: Rate Limiting
header_icon: /assets/images/icons/plugins/rate-limiting.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Configuration
  - label: Usage
    items:
      - label: Headers sent to the client
---

Rate limit how many HTTP requests a developer can make in a given period of seconds, minutes, hours, days, months or years. If the API has no authentication layer, the **Client IP** address will be used, otherwise the Consumer will be used if an authentication plugin has been configured.

----

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST --url http://kong:8001/apis/{api}/plugins \
    --data "name=rate-limiting" \
    --data "config.second=5" \
    --data "config.hour=10000"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter | required        | description
---            | ---             | ---
`name`         | *required*      | The name of the plugin to use, in this case: `rate-limiting`
`consumer_id`  | *optional*      | The CONSUMER ID that this plugin configuration will target. This value can only be used if [authentication has been enabled][faq-authentication] so that the system can identify the user making the request.
`config.second` | *semi-optional* |  The amount of HTTP requests the developer can make per second. At least one limit must exist.
`config.minute` | *semi-optional* |  The amount of HTTP requests the developer can make per minute. At least one limit must exist.
`config.hour`   | *semi-optional* |  The amount of HTTP requests the developer can make per hour. At least one limit must exist.
`config.day`    | *semi-optional* |  The amount of HTTP requests the developer can make per day. At least one limit must exist.
`config.month`  | *semi-optional* |  The amount of HTTP requests the developer can make per month. At least one limit must exist.
`config.year`   | *semi-optional* |  The amount of HTTP requests the developer can make per year. At least one limit must exist.
`config.async`  | *optional*      |  A boolean value that determines if the usage should be incremented asynchronously or not. If set to `true` it has the advantage of speeding up the performance of the plugin, at the cost of its accuracy: the usage is not incremented immediately before proxying the request, but on a separate light thread right after the request has been already proxied. By default is `false`.
`config.continue_on_error`  | *optional*      |  A boolean value that determines if the requests should be proxied even if Kong has troubles connecting to the datastore. If `true` requests will be proxied anyways effectively disabling the rate-limiting function until the datastore is working again. If `false` then the clients will see `500` errors. By default is `false`.

----

## Headers sent to the client

When this plugin is enabled, Kong will send some additional headers back to the client telling how many requests are available and what are the limits allowed, for example:

```
X-RateLimit-Limit-Minute: 10
X-RateLimit-Remaining-Minute: 9
```

or it will return a combination of more time limits, if more than one is being set:

```
X-RateLimit-Limit-Second: 5
X-RateLimit-Remaining-Second: 4
X-RateLimit-Limit-Minute: 10
X-RateLimit-Remaining-Minute: 9
```

If any of the limits configured is being reached, the plugin will return a `HTTP/1.1 429` status code to the client with the following JSON body:

```json
{"message":"API rate limit exceeded"}
```

[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
