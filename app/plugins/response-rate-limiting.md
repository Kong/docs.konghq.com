---
id: page-plugin
title: Plugins - Response Rate Limiting
header_title: Response Rate Limiting
header_icon: /assets/images/icons/plugins/response-rate-limiting.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Usage
    items:
      - label: Configuring Quotas
      - label: Headers sent to the client
      - label: Upstream Headers

description: |
  This plugin allows you to limit the number of requests a developer can make based on a custom response header returned by the upstream API, Route, or Service. You can arbitrary set as many rate-limiting objects (or quotas) as you want and instruct Kong to increase or decrease them by any number of units. Each custom rate-limiting object can limit the inbound requests per seconds, minutes, hours, days, months or years.
  
  If the API, Route, or Service has no authentication layer, the **Client IP** address will be used, otherwise the Consumer will be used if an authentication plugin has been configured.

params:
  name: response-ratelimiting
  api_id: true
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: limits.{limit_name}
      required: true
      description: This is a list of custom objects that you can set, with arbitrary names set in the `{limit_name`} placeholder, like `config.limits.sms.minute=20` if your object is called "SMS".
    - name: limits.{limit_name}.second
      required: semi
      description: The amount of HTTP requests the developer can make per second. At least one limit must exist.
    - name: limits.{limit_name}.minute
      required: semi
      value_in_examples: 10
      description: The amount of HTTP requests the developer can make per minute. At least one limit must exist.
    - name: limits.{limit_name}.hour
      required: semi
      description: The amount of HTTP requests the developer can make per hour. At least one limit must exist.
    - name: limits.{limit_name}.day
      required: semi
      description: The amount of HTTP requests the developer can make per day. At least one limit must exist.
    - name: limits.{limit_name}.month
      required: semi
      description: The amount of HTTP requests the developer can make per month. At least one limit must exist.
    - name: limits.{limit_name}.year
      required: semi
      description: The amount of HTTP requests the developer can make per year. At least one limit must exist.
    - name: header_name
      required: false
      default: "`X-Kong-Limit`"
      description: The name of the response header used to increment the counters.
    - name: block_on_first_violation
      required: false
      default: "`false`"
      description: A boolean value that determines if the requests should be blocked as soon as one limit is being exceeded. This will block requests that are supposed to consume other limits too.
    - name: limit_by
      required: false
      default: "`consumer`"
      description: The entity that will be used when aggregating the limits: `consumer`, `credential`, `ip`. If the `consumer` or the `credential` cannot be determined, the system will always fallback to `ip`.
    - name: policy
      required: false
      default: "`cluster`"
      description: The rate-limiting policies to use for retrieving and incrementing the limits. Available values are `local` (counters will be stored locally in-memory on the node), `cluster` (counters are stored in the datastore and shared across the nodes) and `redis` (counters are stored on a Redis server and will be shared across the nodes).
    - name: fault_tolerant
      required: false
      default: "`true`"
      description: A boolean value that determines if the requests should be proxied even if Kong has troubles connecting a third-party datastore. If `true` requests will be proxied anyways effectively disabling the rate-limiting function until the datastore is working again. If `false` then the clients will see `500` errors.
    - name: hide_client_headers
      required: false
      default: "`false`"
      description: Optionally hide informative response headers.
    - name: redis_host
      required: semi
      description: When using the `redis` policy, this property specifies the address to the Redis server.
    - name: redis_port
      required: false
      default: "`6379`"
      description: When using the `redis` policy, this property specifies the port of the Redis server.
    - name: redis_password
      required: false
      description: When using the `redis` policy, this property specifies the password to connect to the Redis server.
    - name: redis_timeout
      required: false
      default: "`2000`"
      description: When using the `redis` policy, this property specifies the timeout in milliseconds of any command submitted to the Redis server.
    - name: redis_database
      required: false
      default: "`0`"
      description: When using the `redis` policy, this property specifies Redis database to use.

---

## Configuring Quotas

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

----

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

### Upstream Headers

The plugin will append the usage headers for each limit before proxying it to the upstream API, Route, or Service, so that you can properly refuse to process the request if there are no more limits remaining. The headers are in the form of `X-RateLimit-Remaining-{limit_name}`, like:

```
X-RateLimit-Remaining-Videos: 3
X-RateLimit-Remaining-Images: 0
```

[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
