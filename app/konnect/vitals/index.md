---
title: Monitoring Health with Vitals
no_version: true
---

You can monitor the health and performance of any Service, Service version,
Route, or Application managed by {{site.konnect_saas}}.

Vitals provides traffic reports to help you track the performance and
behavior of your APIs and runtimes. Use these reports to quickly access key
statistics, monitor vital signs, and pinpoint anomalies in real time.

Depending on your {{site.konnect_saas}} subscription tier, Vitals retains
historical data for the following lengths of time:
* **Free:** 24 hours
* **Plus:** 6 months
* **Enterprise:** 1 year

In the [ServiceHub](https://konnect.konghq.com/servicehub/), you can see
[activity graphs](/konnect/vitals/analyze/) for Services, Service versions, or
Routes for the past 12 hours.
For Services, these graphs display request counts. For Service versions and
Routes, the graphs show requests broken down by status codes.

To see historical data for a greater range than 12 hours or customize the
entities in a report, you can:
* [Export historical data in CSV format](/konnect/vitals/analyze/) for any
individual Service, Service version, or Route.
* [Create a custom report](/konnect/vitals/generate-reports/) for any number of
Services, Routes, or Applications, filtered by time frame and grouped by metric.

## Terms

**Request Count**
: Displays a count of all proxy requests received. This includes requests that
were rejected due to rate limiting, failed authentication, and so on.

**Status Codes**
: Displays visualizations of cluster-wide status code classes (1xx, 2xx, 3xx,
  4xx, 5xx). The Status Codes view contains the counts of status code classes
  graphed over time, as well as the ratio of code classes to total requests.

**Time frame selector**
: Controls the timeframe of data visualized, which indirectly controls the
granularity of the data. For example, the “5M” selection displays 5 minutes in
1-second resolution data, while longer time frames display minute, hour, or
days resolution data.

**Traffic metrics**
: Provide insight into which of your Services and Service versions are being
used and how they are responding.
