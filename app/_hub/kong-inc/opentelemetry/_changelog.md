## Changelog

### {{site.base_gateway}} 3.10.x
* This plugin now supports variable resource attributes.
* This plugin now supports instana headers in propagation.

### {{site.base_gateway}} 3.8.x
* Added support for OpenTelemetry-formatted logs.
[#13291](https://github.com/Kong/kong/issues/13291)

  As part of the rework, the following parameter has been deprecated and will be removed in a future major version: 
  * `config.endpoint`  is deprecated, use `config.traces_endpoint` instead.

* Fixed an issue where migration failed when upgrading from versions earlier than 3.3.x to 3.7.x.
   [#13391](https://github.com/Kong/kong/issues/13391)
* Removed redundant deprecation warnings.
  [#13220](https://github.com/Kong/kong/issues/13220)
* Improved the accuracy of sampling decisions.
  [#13275](https://github.com/Kong/kong/issues/13275)


### {{site.base_gateway}} 3.7.x
* The propagation module has been reworked. The new
options allow better control over the configuration of tracing header propagation.
 [#12670](https://github.com/Kong/kong/issues/12670).

  As part of the rework, the following parameters have been deprecated and will be removed in a future major version: 
  * `config.header_type`  is deprecated, use `config.propagation` instead.
  * `config.batch_span_count` is deprecated, use `config.queue.max_batch_size` instead.
  * `config.batch_flush_delay` is deprecated, use `config.queue.max_coalescing_delay` instead.
    
* Fixed an OTEL sampling mode Lua panic bug, which happened 
when the `http_response_header_for_traceid` option was enabled.
 [#12544](https://github.com/Kong/kong/issues/12544)

### {{site.base_gateway}} 3.6.x
* The tracing sampling rate can now be set via the [`config.sampling_rate`](/hub/kong-inc/opentelemetry/configuration/#configsampling_rate) property of the OpenTelemetry plugin 
instead of just being a global setting for {{site.base_gateway}}.
[#12054](https://github.com/Kong/kong/issues/12054)

### {{site.base_gateway}} 3.5.x
* Added support for [Google Cloud Project's X-Cloud-Trace-Context header](https://cloud.google.com/trace/docs/setup#force-trace)

* Added a new value to the parameter `header_type`, which allows {{site.base_gateway}} to inject Datadog headers into the headers of requests forwarding to the upstream.

* Fixed an issue that resulted in traces with invalid parent IDs when `balancer` instrumentation was enabled. 
[#11830](https://github.com/Kong/kong/pull/11830)

### {{site.base_gateway}} 3.4.x
* Added support for [AWS X-Ray header](https://docs.aws.amazon.com/xray/latest/devguide/xray-concepts.html#xray-concepts-tracingheader) propagation.
  
  The field `header_type`now accepts the `aws` value to handle this specific
  propagation header.
  [#11075](https://github.com/Kong/kong/pull/11075)

* The `endpoint` parameter is now referenceable, and can be stored as a secret in a vault.

### {{site.base_gateway}} 3.2.x
* This plugin can now be scoped to individual services, routes, and consumers.

### {{site.base_gateway}} 3.1.x
* The `headers` field is now marked as referenceable, which means it can be securely stored as a
[secret](/gateway/latest/kong-enterprise/secrets-management/)
in a vault.
