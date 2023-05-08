---
title: About Batch Queuing 
content_type: explanation
---

Starting with {{site.base_gateway}} 3.3.x, some Kong plugins now use batch queuing to decouple the production of data in the proxy path and the submission of that data to a server, such as a log server. This ensures that the upstream server isn't taxed by recieving many proxy requests at the same time.

The following plugins now use batch queuing:

* [HTTP Log](/hub/kong-inc/http-log/)
* [OpenTelemetry](/hub/kong-inc/opentelemetry/)
* [Datadog](/hub/kong-inc/datadog/)
* [StatsD](/hub/kong-inc/statsd/)

This page describes why queues are needed and how batch queuing works.

## Why are queues needed? 

Some analytic and monitoring plugins, like HTTP Log and Datadog, must send request information that was processed by {{site.base_gateway}} to another server (the upstream server). 

Without batch queuing, the information is sent during the log phase to avoid introducing any latency to request or response. This isn't ideal because directly sending data from the log handler to the upstream server creates a large number of requests when {{site.base_gateway}} is under a high load. Sending out a large number of concurrent outbound requests can overload the log server and can negatively impact the ability of the machine running {{site.base_gateway}} to proxy requests.

The solution to this is to use batch requests. With batch queuing, request information is put in a configurable queue before being sent to the upstream server. This approach has the following benefits:
* Reduces any possible concurrency on the upstream server
* Helps deal with temporary outages of the upstream server due to network or administrative changes
* Can reduce resource usage both in {{site.base_gateway}} and in the upstream server by collecting multiple entries from the queue in one request

{:.note}
> **Note:** Because queues are structural elements for components in {{site.base_gateway}}, they only live in the main memory of each worker process and are not shared between workers. Therefore, queued content isn't preserved under abnormal operational situations, like power loss or unexpected worker process shutdown due to memory shortage or program errors.
 
## How batch queuing works

When {{site.base_gateway}} processes a request from certain plugins, it uses batch queuing to group the requests togehter before sending them to the upstream server. 

[DIAGRAM HERE?]
> _**Figure 1:** Description of diagram._

You can use several different configurable parameters for batch queuing. The following sections explain these features of batch queuing in detail.

### Queue capacity limit

Previously, the queue didn't have any capacity limits. This resulted in a worker process exhausting all available memory if data was produced fast enough and the upstream server would be slow or unavailable.

Now, you can configure the maximum number of entries that can be queued at any time with the `max_entries` queue parameter. When a queue reaches the maximum number of entries queued and another entry is enqueued, the oldest entry in the queue is deleted to make space for the new entry.
The queue code provides warning log entries when it reaches a capacity threshold of 80% and when it starts to delete entries from the queue. It also writes log entries when the situation normalizes.

### Reduced timer usage

Only one timer is used to start queue processing in the background. Once the queue is empty, the timer handler terminates and a new timer is created as soon as a new entry is pushed onto the queue.

### Queue flush on shutdown

When a {{site.base_gateway}} shutdown is initiated, the queue is flushed. This allows {{site.base_gateway}} to shutdown even if it was waiting for new entries to be batched, ensuring upstream servers can be contacted. 

### Retry logic

If a batch queue fails to process, the queue library can automatically retry to process it if the failure is temporary (for example, there are network problems or upstream unavailability). Before retrying, the library waits for the amount of time specified by the `initial_retry_delay` parameter. This wait time is doubled every time the retry fails, until it reaches the maximum wait time specified by the `max_retry_time` parameter.

## More information

[Batch Queuing Reference](/gateway/{{page.kong_version}}/kong-plugins/batch-queue/reference/) - Learn more about the batch queuing parameters you can configure.