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
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=rate-limiting" \
    --data "config.second=5" \
    --data "config.hour=10000"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

You can also apply it for every API using the `http://kong:8001/plugins/` endpoint. Read the [Plugin Reference](/docs/latest/admin-api/#add-plugin) for more information.

form parameter                     | default | description
---                                | ---     | ---
`name`                             |         | The name of the plugin to use, in this case: `rate-limiting`
`consumer_id`<br>*optional*        |         | The CONSUMER ID that this plugin configuration will target. This value can only be used if [authentication has been enabled][faq-authentication] so that the system can identify the user making the request.
`config.second`<br>*semi-optional* |         | The amount of HTTP requests the developer can make per second. At least one limit must exist.
`config.minute`<br>*semi-optional* |         | The amount of HTTP requests the developer can make per minute. At least one limit must exist.
`config.hour`<br>*semi-optional*   |         | The amount of HTTP requests the developer can make per hour. At least one limit must exist.
`config.day`<br>*semi-optional*    |         | The amount of HTTP requests the developer can make per day. At least one limit must exist.
`config.month`<br>*semi-optional*  |         | The amount of HTTP requests the developer can make per month. At least one limit must exist.
`config.year`<br>*semi-optional*   |         | The amount of HTTP requests the developer can make per year. At least one limit must exist.
`config.limit_by`<br>*optional*    | `consumer` | The entity that will be used when aggregating the limits: `consumer`, `credential`, `ip`. If the `consumer` or the `credential` cannot be determined, the system will always fallback to `ip`.
`config.policy`<br>*optional*      | `cluster`  | The rate-limiting policies to use for retrieving and incrementing the limits. Available values are `local` (counters will be stored locally in-memory on the node), `cluster` (counters are stored in the datastore and shared across the nodes) and `redis` (counters are stored on a Redis server and will be shared across the nodes).
`config.fault_tolerant`<br>*optional* | `true` |  A boolean value that determines if the requests should be proxied even if Kong has troubles connecting a third-party datastore. If `true` requests will be proxied anyways effectively disabling the rate-limiting function until the datastore is working again. If `false` then the clients will see `500` errors.
`config.redis_host`<br>*semi-optional* |        | When using the `redis` policy, this property specifies the address to the Redis server.
`config.redis_port`<br>*optional* | `6379`     | When using the `redis` policy, this property specifies the port of the Redis server. By default is `6379`.
`config.redis_timeout`<br>*optional* | `2000` | When using the `redis` policy, this property specifies the timeout in milliseconds of any command submitted to the Redis server.

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
