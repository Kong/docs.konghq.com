---
title: Troubleshoot Analytics
no_version: true
content-type: reference
---

## The latency graph on the analytics dashboard is empty

You may run into an issue where requests are being proxied through services, but the latency tab on the Analytics page displays the message **No data to display**.

This issue may be happening for one of the following reasons:

* The {{site.base_gateway}} version is incompatible.
Latency data is available starting with {{site.base_gateway}} 3.0.0.0. To collect latency information, [upgrade your runtime instances](/konnect/runtime-manager/runtime-instances/upgrade/) to the latest version.

* No requests were proxied in the requested time period.
