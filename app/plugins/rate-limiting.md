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
`config.redis_password`<br>*optional* |      | When using the `redis` policy, this property specifies the password to connect to the Redis server.
`config.redis_timeout`<br>*optional* | `2000` | When using the `redis` policy, this property specifies the timeout in milliseconds of any command submitted to the Redis server.
`config.redis_database`<br>*optional* | `0` | When using the `redis` policy, this property specifies Redis database to use.

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

## Implementation considerations

The plugin supports 3 policies, which each have their specific pros and cons.

policy    | pros          | cons
---       | ---            | ---
`cluster` | accurate, no extra components to support  | relatively the biggest performance impact, each request forces a read and a write on the underlying datastore.
`redis`   | accurate, lesser performance impact than a `cluster` policy | extra redis installation required, bigger performance impact than a `local` policy
`local`   | minimal performance impact | less accurate, and unless a consistent-hashing load balancer is used in front of Kong, it diverges when scaling the number of nodes

There are 2 use cases that are most common:

1. _every transaction counts_. These are for example transactions with financial 
   consequences. Here the highest level of accuracy is required.
2. _backend protection_. This is where accuracy is not as relevant, but it is
   merely used to protect backend services from overload. Either by specific
   users, or to protect against an attack in general.

**NOTE**: the redis policy does not support the Sentinel protocol for high available
master-slave architectures. When using rate-limiting for general protection the chances
of both redis being down and the system being under attack are rather small. Check
with your own use case wether you can handle this (small) risk.

### Every transaction counts

In this scenario, the `local` policy is not an option. So here the decision is between
the extra performance of the `redis` policy against its extra support effort. Based on that balance,
the choice should either be `cluster` or `redis`.

The recommendation is to start with the `cluster` policy, with the option to move over to `redis`
if performance reduces drastically. Keep in mind existing usage metrics cannot
be ported from the datastore to redis. Generally with shortlived metrics (per second or per minute)
this is not an issue, but with longer lived ones (months) it might be, so you might want to plan
your switch more carefully.

### Backend protection

As accuracy is of lesser importance, the `local` policy can be used. It might require some experimenting
to get the proper setting. For example, if the user is bound to 100 requests per second, and you have an
equally balanced 5 node Kong cluster, setting the `local` limit to something like 30 requests per second
should work. If you are worried about too many false-negatives, increase the value.

Keep in mind as the cluster scales to more nodes, the users will get more requests granted, and likewise 
when the cluster scales down the probability of false-negatives increases. So in general, update your 
limits when scaling.

The above mentioned inaccuracy can be mitigated by using a consistent-hashing load balancer in front of
Kong, that ensures the same user is always directed to the same Kong node. This will both reduce the
inaccuracy and prevent the scaling issues.

Most likely the user will be granted more than was agreed when using the `local` policy, but it will 
effectively block any attacks while maintaining the best performance. 

[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
