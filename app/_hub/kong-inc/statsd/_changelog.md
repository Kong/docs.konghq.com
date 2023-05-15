## Changelog

**{{site.base_gateway}} 3.2.x**
* Added the `tag_style` configuration parameter. This allows you to send metrics with [tags](https://github.com/prometheus/statsd_exporter#tagging-extensions). Defaults to `nil`, which doesn't add any tags to the metrics.

**{{site.base_gateway}} 3.1.x**
* Added support for managing queues and connection retries when sending messages to the upstream with 
the `queue_size`,`flush_timeout`, and `retry_count` configuration parameters. 

### {{site.base_gateway}} 3.0.x

* Merged features of the StatsD Advanced plugin into the StatsD plugin. The StatsD plugin now includes the following:
  * New parameters for StatsD: `hostname_in_prefix`, `udp_packet_size`, `ues_tcp`, `allow_status_codes`, `consumer_identifier_default`, `service_identifier_default`, `workspace_identifier_default`.
  * New metrics: `status_count_per_workspace`, `status_count_per_user_per_route`, `shdict_usage`
  * New metric fields: `service_identifier`, `workspace_identifier`

* Breaking changes
  * The metric name that is related to the service has been renamed by adding a `service.` prefix. e.g. `kong.service.<service_identifier>.request.count`
  * The metric `kong.<service_identifier>.request.status.<status>.count` from metrics `status_count` and `status_count_per_user` has been renamed to `kong.service.<service_identifier>.status.<status>.count`
  * The metric `*.status.<status>.total` from metrics `status_count` and `status_count_per_user` has been removed.
  * The metric `kong.<service_identifier>.request_size` and `kong.<service_identifier>.response_size` stat type has been changed from `timer` to `counter`.
