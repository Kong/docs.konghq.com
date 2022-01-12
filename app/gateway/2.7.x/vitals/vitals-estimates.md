---
title: Estimate Vitals Storage in PostgreSQL
badge: enterprise
---

Vitals data can be divided into two categories: {{site.base_gateway}} node statistics and request response codes.

## {{site.base_gateway}} node statistics

These types of metrics are proxy latency, upstream latency, and cache hit/miss. {{site.base_gateway}} node statistics are stored in tables like the following:

* `vitals_stats_seconds_timestamp` stores 1 new row for every _second_ Kong runs
* `vitals_stats_minutes` stores 1 new row for every _minute_ Kong runs
* `vitals_stats_days` stores 1 new row for every _day_ Kong runs

{{site.base_gateway}} node statistics are not associated with specific {{site.base_gateway}} entities like Workspaces, Services, or Routes. They're designed to represent the cluster's state in time. This means the tables will have new rows regardless if {{site.base_gateway}} is routing traffic or idle.

The tables do not grow infinitely and hold data for the following duration of time:

* `vitals_stats_seconds_timestamp` holds data for 1 hour (3600 rows)
* `vitals_stats_minutes` holds data for 25 hours (90000 rows)
* `vitals_stats_days` holds data for 2 years (730 rows)

## Request response codes

Request response codes are stored in the other group of tables following a different rationale. Tables in this group share the same structure (`entity_id`, `at`, `duration`, `status_code`, `count`):

* `vitals_code_classes_by_workspace`
* `vitals_code_classes_by_cluster`
* `vitals_codes_by_route`

The `entity_id` does not exist in `vitals_code_classes_by_cluster` as this table doesn't store entity-specific information.
In the `vitals_code_classes_by_workspace` table, `entity_id` is `workspace_id`. In the `vitals_codes_by_route` table, `entity_id` is `service_id` and `route_id`.

`at` is a timestamp. It logs the start of the period a row represents, while `duration` is the duration of that period.

`status_code` and `count` are the quantity of the HTTP status codes (200, 300, 400, 500) observed in the period represented by a row.

While {{site.base_gateway}} node statistic tables grow only according to time, status code tables only have new rows when {{site.base_gateway}} proxies traffic, and the number of new rows depends on the traffic itself.

## Example

Consider a brand new {{site.base_gateway}} that hasn't proxied any traffic yet. {{site.base_gateway}} node statistic tables have rows but status codes tables don't.

When {{site.base_gateway}} proxies its first request at `t` returning status code 200, the following rows are added:

```bash
vitals_codes_by_cluster
[second(t), 1, 200, 1]
[minute(t), 60, 200, 1] 
[day(t), 84600, 200, 1]
```

Second, minute, and day content is trimmed in the following way:

* `second(t)` is `t` trimmed to seconds, for example: `second(2021-01-01 20:21:30)` would be `2021-01-01 20:21:30`.
* `minute(t)` is `t` trimmed to minutes, for example: `minute(2021-01-01 20:21:30.234)` would be `2021-01-01 20:21:00`.
* `day(t)` is `t` trimmed to day, for example: `day(2021-01-01 20:21:30.234)` would be `2021-01-01 00:00:00`.

```bash
vitals_codes_by_workspace
[workspace_id, second(t), 1, 200, 1]
[workspace_id, minute(t), 60, 200, 1]
[workspace_id, day(t), 84600, 200, 1]

vitals_codes_by_route
[service_id, route_id, second(t), 1, 200, 1]
[service_id, route_id, minute(t), 60, 200, 1]
[service_id, route_id, day(t), 84600, 200, 1]
```

Let's consider what happens when new requests are proxied in some scenarios.

### Scenario where no rows are inserted

If we make the same request again at the same `t` and it also receives 200, no new rows will be inserted.

In this case, the existing rows have their count column incremented accordingly:

```bash
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

### Scenario where new rows are inserted

If the last request received a 500 status code, new rows are inserted:

```bash
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

### Scenario where a second row is inserted

Assume that at `t + 5s`, where `minute(t)==minute(t + 5s)`, {{site.base_gateway}} proxies the same request returning 200. Since `minute()` and `day()` for both `t` and `t + 5s` are the same, minute and day rows should just be updated. Since `second()` is different for the two instants, a new second row should be inserted in each table.

```bash
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

* The number of status codes observed in {{site.base_gateway}} proxied requests
* The number of {{site.base_gateway}} entities involved in those requests
* The constant flow of proxied requests

In an estimate of row numbers in scenario, consider a {{site.base_gateway}} cluster with the following characteristics:  

* A constant flow of requests returning all 5 possible groups of status codes (1xx, 2xx, 3xx, 4xx and 5xx).
* Just 1 workspace, 1 service, and 1 route

After 24 hours of traffic, the status codes tables will have this number of rows:

Status code table name | Day | Minute | Seconds | Total
---------------------- | --- | ------ | ------- | -----
**vitals_codes_by_cluster** | 5 | 7200 | 18000 | 25200
**vitals_codes_by_workspace** | 5 | 7200 | 18000 | 25200
**vitals_codes_by_route** | 5 | 7200 | 18000 | 25200

It's important to note that this assumes that all 5 groups of status codes had been observed in those 24 hours of traffic. This is why quantities were multiplied by 5.

With this baseline scenario, it's easier to calculate what happens when the number of {{site.base_gateway}} entities (Workspaces and Routes) involved in the traffic increases. Tables `vitals_codes_by_workspace` and `vitals_codes_by_route` have their row number change with increase in workspaces and routes, respectively.

If the above {{site.base_gateway}} cluster is expanded to have 10 workspaces with 1 route each (10 routes total) and it proxies traffic for 24 hours and returns all 5 status codes, `vitals_codes_by_workspace` and `vitals_codes_by_route` would have 252,000 rows.
