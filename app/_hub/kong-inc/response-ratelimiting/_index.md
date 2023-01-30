---
name: Response Rate Limiting
publisher: Kong Inc.
version: 2.0.x
desc: Rate-limiting based on a custom response header value
description: |
  This plugin allows you to limit the number of requests a developer can make
  based on a custom response header returned by the upstream service. You can
  arbitrarily set as many rate-limiting objects (or quotas) as you want and
  instruct Kong to increase or decrease them by any number of units. Each custom
  rate-limiting object can limit the inbound requests per seconds, minutes, hours,
  days, months, or years.

  If the underlying Service/Route has no authentication
  layer, the **Client IP** address will be used; otherwise, the Consumer will be
  used if an authentication plugin has been configured.
type: plugin
categories:
  - traffic-control
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
---

## Configuring Quotas

After adding the plugin, you can increment the configured limits by adding the following response header:

```
Header-Name: Limit=Value [,Limit=Value]
```

Because `X-Kong-Limit` is the default header name (you can optionally change it),
the request looks like:

```bash
curl -v -H 'X-Kong-Limit: limitname1=2, limitname2=4'
```

The above example increments the limit `limitname1` by 2 units, and `limitname2` by 4 units.

You can optionally increment more than one limit with comma-separated entries.
The header is removed before returning the response to the original client.

----

## Headers sent to the client

When the plugin is enabled, Kong sends some additional headers back to the
client telling how many units are available and how many are allowed.

For example, if you created a limit/quota called "Videos" with a per-minute limit:

```
X-RateLimit-Limit-Videos-Minute: 10
X-RateLimit-Remaining-Videos-Minute: 9
```

If more than one limit value is being set, it returns a combination of more time limits:

```
X-RateLimit-Limit-Videos-Second: 5
X-RateLimit-Remaining-Videos-Second: 5
X-RateLimit-Limit-Videos-Minute: 10
X-RateLimit-Remaining-Videos-Minute: 10
```

If any of the limits configured is being reached, the plugin
returns an `HTTP/1.1 429` (Too Many Requests) status code and an empty response body.

### Upstream Headers

The plugin appends the usage headers for each limit before proxying it to the
upstream service, so that you can properly refuse to process the request if there
are no more limits remaining. The headers are in the form of
`X-RateLimit-Remaining-{limit_name}`, for example:

```
X-RateLimit-Remaining-Videos: 3
X-RateLimit-Remaining-Images: 0
```

[configuration]: /gateway/latest/reference/configuration
[consumer-object]: /gateway/latest/admin-api/#consumer-object

---

