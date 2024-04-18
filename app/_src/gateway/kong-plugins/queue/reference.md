---
title: Plugin Queuing Reference
content_type: reference
---

This page is a reference for general plugin queuing parameters that you can set for certain plugins. Set these parameters in the configuration file for your plugin.

For more information, see the following plugin documentation:

* [HTTP Log](/hub/kong-inc/http-log/)
* [OpenTelemetry](/hub/kong-inc/opentelemetry/)
* [Datadog](/hub/kong-inc/datadog/)
* [StatsD](/hub/kong-inc/statsd/)

## Plugin queuing parameters

The unified queue parameter set consists of the following parameters:

| Parameter      | Type | Unit | Default value | Description |
| --------- | ---------- | ---------- | ---------- | ---------- |
|`max_batch_size` | integer | count | 1 | Maximum number of queue entries to process per batch. |
|`max_coalescing_delay` | fraction | seconds | 1 | Maximum time to wait after the first entry has been received in the queue before sending out the batch. As soon as the maximum number of entries are waiting on the queue, a batch is sent immediately. |
|`max_entries` | integer | count | 10000 | Maximum number of entries that the queue can hold. Once this limit is reached, the oldest entry will be dropped when a new entry is enqueued. |
|`max_retry_time` | fraction | seconds | 60 | Maximum time that a batch is retried. This can be set to a negative value to disable retries. |
|`initial_retry_delay` | fraction | seconds | 0.01 | Initial delay before retrying after processing a failed batch. |
|`max_retry_delay` | fraction | seconds | 60 | Maximum time to wait between retries. |

## More information

[About Plugin Queuing](/gateway/{{page.release}}/kong-plugins/queue/) - Find out how plugin queuing works.
