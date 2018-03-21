---
id: page-plugin
title: Plugins - Rate Limiting
header_title: Rate Limiting
header_icon: /assets/images/icons/plugins/rate-limiting.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Usage
    items:
      - label: Headers sent to the client
description: |
  Rate limit how many HTTP requests a developer can make in a given period of seconds, minutes, hours, days, months or years. If the underlying Service/Route (or deprecated API entity) has no authentication layer, the **Client IP** address will be used, otherwise the Consumer will be used if an authentication plugin has been configured.

params:
  name: rate-limiting
  api_id: true
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: second
      required: semi
      value_in_examples: 5
      description: The amount of HTTP requests the developer can make per second. At least one limit must exist.
    - name: minute
      required: semi
      description: The amount of HTTP requests the developer can make per minute. At least one limit must exist.
    - name: hour
      required: semi
      value_in_examples: 10000
      description: The amount of HTTP requests the developer can make per hour. At least one limit must exist.
    - name: day
      required: semi
      description: The amount of HTTP requests the developer can make per day. At least one limit must exist.
    - name: month
      required: semi
      description: The amount of HTTP requests the developer can make per month. At least one limit must exist.
    - name: year
      required: semi
      description: The amount of HTTP requests the developer can make per year. At least one limit must exist.
    - name: limit_by
      required: false
      default: "`consumer`"
      description: |
        The entity that will be used when aggregating the limits: `consumer`, `credential`, `ip`. If the `consumer` or the `credential` cannot be determined, the system will always fallback to `ip`.
    - name: policy
      required: false
      default: "`cluster`"
      description: |
        The rate-limiting policies to use for retrieving and incrementing the limits. Available values are `local` (counters will be stored locally in-memory on the node), `cluster` (counters are stored in the datastore and shared across the nodes) and `redis` (counters are stored on a Redis server and will be shared across the nodes).
    - name: fault_tolerant
      required: false
      default: "`true`"
      description: |
        A boolean value that determines if the requests should be proxied even if Kong has troubles connecting a third-party datastore. If `true` requests will be proxied anyways effectively disabling the rate-limiting function until the datastore is working again. If `false` then the clients will see `500` errors.
    - name: hide_client_headers
      required: false
      default: "`false`"
      description: Optionally hide informative response headers.
    - name: redis_host
      required: semi
      description: |
        When using the `redis` policy, this property specifies the address to the Redis server.
    - name: redis_port
      required: false
      default: "`6379`"
      description: |
        When using the `redis` policy, this property specifies the port of the Redis server. By default is `6379`.
    - name: redis_password
      required: false
      description: |
        When using the `redis` policy, this property specifies the password to connect to the Redis server.
    - name: redis_timeout
      required: false
      default: "`2000`"
      description: |
        When using the `redis` policy, this property specifies the timeout in milliseconds of any command submitted to the Redis server.
    - name: redis_database
      required: false
      default: "`0`"
      description: |
        When using the `redis` policy, this property specifies Redis database to use.

---

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

**NOTE**:

<div class="alert alert-warning">
  <strong>Enterprise-Only</strong> The Kong Community Edition of this Rate Limiting plugin does not
include <a href="https://redis.io/topics/sentinel">Redis Sentinel</a> support.
<a href="https://www.konghq.com/enterprise/">Kong Enterprise Subscription</a> customers have the option
of using Redis Sentinel with Kong Rate Limiting to deliver highly available master-slave deployments.
</div>

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
