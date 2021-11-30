---
title: Estimating Vitals Storage in PostgreSQL
badge: enterprise
---

Vitals data can be divided into two categories, Kong Gateway node statistics and request response codes.

## Kong Gateway Node Statistics

These types of metrics are proxy latency, upstream latency, cache hit/miss. Kong Gateway node statistics are stored in tables like these: `vitals_stats_seconds_timestamp`, `vitals_stats_minutes`, `vitals_stats_days`

* `vitals_stats_seconds_timestamp` stores 1 new row for every second that kong runs
* `vitals_stats_minutes` stores 1 new row for every minute that kong runs.
* `vitals_stats_days` stores 1 new row for every day that kong runs.

Kong Gateway node statistics are not associated with specific Kong Gateway entities like workspaces, services, or routes. They were designed to represent the cluster's state in time. This means those tables will have new rows regardless if Kong Gateway is routing traffic or idle. Those tables do not grow infinitely, however.

* `vitals_stats_seconds_timestamp` will hold data for the last hour (3600 rows)
* `vitals_stats_minutes` will hold data for the last 25 hours (90000 rows)
* `vitals_stats_days` will hold data for the last 2 years (730 rows)

## Request Response Codes

Request response codes are stored in the other group of tables following a different rationale. Tables in this group share the same structure (`entity_id`, `at`, `duration`, `status_code`, `count`):

* `vitals_code_classes_by_workspace`
* `vitals_code_classes_by_cluster`
* `vitals_codes_by_route`

The `entity_id` does not exist in `vitals_code_classes_by_cluster` as it doesn't store per any entity.
`entity_id` is `workspace_id` in `vitals_code_classes_by_workspace` and `service_id`, `route_id` in `vitals_codes_by_route`.

`at`, a timestamp, is the start of the period a row represents, while `duration` is the duration of that period.

`status_code` and `count` are the quantity of the HTTP status codes (200, 300, 400, 500) observed in the period represented by a row.

While Kong Gateway node statistic tables grow only according to time, status code tables will only have new rows when Kong Gateway proxies traffic, and the number of new rows depends on the traffic itself.

## An Example

Consider a brand new Kong Gateway that hasn't proxied any traffic yet. Kong Gateway node statistic tables will have rows but status codes tables will not.

When Kong Gateway proxies its first request at `t` returning status code 200, the following rows will be added:

```
vitals_codes_by_cluster
[second(t), 1, 200, 1]
[minute(t), 60, 200, 1] 
[day(t), 84600, 200, 1]
``` 

Where, `second(t)` is `t` trimmed to seconds, e.g. `second(2021-01-01 20:21:30)` would be `2021-01-01 20:21:30`; `minute(t)` is the `t` trimmed to minutes, e.g. `minute(2021-01-01 20:21:30.234)` would be `2021-01-01 20:21:00` and `day(t)` is the `t` trimmed to day, e.g. `day(2021-01-01 20:21:30.234)` would be `2021-01-01 00:00:00`.

```
vitals_codes_by_workspace
[workspace_id, second(t), 1, 200, 1]
[workspace_id, minute(t), 60, 200, 1]
[workspace_id, day(t), 84600, 200, 1]

vitals_codes_by_route
[service_id, route_id, second(t), 1, 200, 1]
[service_id, route_id, minute(t), 60, 200, 1]
[service_id, route_id, day(t), 84600, 200, 1]
```

Lets consider what happens when new requests are proxied in some scenarios.

### Scenario 1

If we make the same request again at the same `t` and it also receives 200, no new rows will be inserted.
In this case, the existing rows will only have their count column incremented accordingly:

```
vitals_codes_by_cluster
[second(t), 1, 200, 2]
[minute(t), 60, 200, 2]
[day(t), 84600, 200, 2]

vitals_codes_by_workspace
[workspace_id, second(t), 1, 200, 2]
[workspace_id, minute(t), 60, 200, 2]
[workspace_id, day(t), 84600, 200, 2]

vitals_codes_by_route
[service_id, route_id, second(t), 1, 200, 2]
[service_id, route_id, minute(t), 60, 200, 2]
[service_id, route_id, day(t), 84600, 200, 2]
```

### Scenario 2

Had the last request received 500, new rows would have been inserted:

```
vitals_codes_by_cluster
[second(t), 1, 200, 1]
[minute(t), 60, 200, 1]
[day(t), 84600, 200, 1]

[second(t), 1, 500, 1]
[minute(t), 60, 500, 1]
[day(t), 84600, 500, 1]

vitals_codes_by_workspace
[workspace_id, second(t), 1, 200, 1]
[workspace_id, minute(t), 60, 200, 1]
[workspace_id, day(t), 84600, 200, 1]

[workspace_id, second(t), 1, 500, 1]
[workspace_id, minute(t), 60, 500, 1]
[workspace_id, day(t), 84600, 500, 1]

vitals_codes_by_route
[service_id, route_id, second(t), 1, 200, 1]
[service_id, route_id, minute(t), 60, 200, 1]
[service_id, route_id, day(t), 84600, 200, 1]

[service_id, route_id, second(t), 1, 500, 1]
[service_id, route_id, minute(t), 60, 500, 1]
[service_id, route_id, day(t), 84600, 500, 1]
```

### Scenario 3
Assume that at `t + 5s`, where `minute(t)==minute(t + 5s)`, Kong Gateway proxies the same request returning 200. Since `minute()` and `day()` for both `t` and `t + 5s` are the same, minute and day rows should just be updated. Since `second()` is different for the two instants, a new second row should be inserted in each table.

```
vitals_codes_by_cluster
[second(t), 1, 200, 1]
[second(t + 5s), 1, 200, 1]
[minute(t), 60, 200, 2]
[day(t), 84600, 200, 2]

vitals_codes_by_workspace
[workspace_id, second(t), 1, 200, 1]
[workspace_id, second(t + 5s), 1, 200, 1]
[workspace_id, minute(t), 60, 200, 2]
[workspace_id, day(t), 84600, 200, 2]

vitals_codes_by_route
[service_id, route_id, second(t), 1, 200, 1]
[service_id, route_id, second(t + 5s), 1, 200, 1]
[service_id, route_id, minute(t), 60, 200, 2]
[service_id, route_id, day(t), 84600, 200, 2]
```

In summary, the number of rows in those status codes tables is directly related to:

* the number of status codes observed in Kong Gateway’s proxied requests
* the number of Kong Gateway entities involved in those requests
* the contant flow of proxied requests

In an estimate of row numbers in scenario, consider a Kong Gateway cluster with the following characteristics:  

* A constant flow of requests returning all 5 possible groups of status codes (1xx, 2xx, 3xx, 4xx and 5xx).
* Just 1 workspace, 1 service and 1 route

After 24 hours of traffic, the status codes tables will have this number of rows:

* **vitals_codes_by_cluster**: 5 row for day, (5 * 24 * 60 = 7200) rows for minutes and (5 * 60 * 60 = 18000) rows for seconds. Total = 25200 rows.
* **vitals_codes_by_workspace**: 5 row for day, (5 * 24 * 60 = 7200) rows for minutes and (5 * 60 * 60 = 18000) rows for seconds. Total = 25200 rows.
* **vitals_codes_by_route**: 5 row for day, (5 * 24 * 60 = 7200) rows for minutes and (5 * 60 * 60 = 18000) rows for seconds. Total = 25200 rows.

It is important to note that this assumes that all 5 groups of status codes had been observed in those 24 hours of traffic. This is why quantities were multiplied by 5.

With this baseline scenario it is easier to calculate what happens when the number of Kong Gateway entities (workspaces and routes) involved in the traffic increases. Tables `vitals_codes_by_workspace` and `vitals_codes_by_route` have their row number change with increase in workspaces and routes, respectively.

If the above Kong Gateway cluster is expanded to have 10 workspaces with one route each (10 routes total) and it proxies traffic for 24 hours and returns all 5 status codes, `vitals_codes_by_workspace` and `vitals_codes_by_route`, would have 252,000 rows. 