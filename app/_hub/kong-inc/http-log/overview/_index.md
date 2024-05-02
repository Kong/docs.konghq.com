---
nav_title: Overview
---

The HTTP Log plugin lets you send request and response logs to an HTTP server.

It also supports stream data (TCP, TLS, and UDP).

{% if_plugin_version gte:3.3.x %}
## Queueing

The HTTP Log plugin uses internal queues to decouple the production of
log entries from their transmission to the upstream log server.  In
contrast to other plugins that use queues, it shares one queue
between all plugin instances that use the same log server parameter.
The equivalence of the log server is determined by the parameters
`http_endpoint`, `method`, `content_type`, `timeout`, and `keepalive`.
All plugin instances that have the same values for these parameters
share one queue.

Queues are not shared between workers and queueing parameters are
scoped to one worker.  For whole-system capacity planning, the number
of workers need to be considered when setting queue parameters.
{% endif_plugin_version %}

## Kong process errors

{% include /md/plugins-hub/kong-process-errors.md %}

## Get started with the HTTP Log plugin
* [Configuration reference](/hub/kong-inc/http-log/configuration/)
* [Basic configuration example](/hub/kong-inc/http-log/how-to/basic-example/)
* [Log format](/hub/kong-inc/http-log/log-format/)
* [Custom fields and headers](/hub/kong-inc/http-log/using-custom-fields/)
* [Configure HTTP Log to send logs to Splunk](/hub/kong-inc/http-log/how-to/splunk/)
