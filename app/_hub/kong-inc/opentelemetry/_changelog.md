## Changelog

**{{site.base_gateway}} 3.5.x**
* Added support for [Google Cloud Project's X-Cloud-Trace-Context header](https://cloud.google.com/trace/docs/setup#force-trace)

* Added a new value to the parameter `header_type`, which allows Kong Gateway to inject Datadog headers into the headers of requests forwarding to the upstream.

* Fixed an issue that resulted in traces with invalid parent IDs when `balancer` instrumentation was enabled. 
[#11830](https://github.com/Kong/kong/pull/11830)

**{{site.base_gateway}} 3.4.x**
* Added support for [AWS X-Ray header](https://docs.aws.amazon.com/xray/latest/devguide/xray-concepts.html#xray-concepts-tracingheader) propagation.
  
  The field `header_type`now accepts the `aws` value to handle this specific
  propagation header.
  [#11075](https://github.com/Kong/kong/pull/11075)

* The `endpoint` parameter is now referenceable, and can be stored as a secret in a vault.

**{{site.base_gateway}} 3.2.x**
* This plugin can now be scoped to individual services, routes, and consumers.

**{{site.base_gateway}} 3.1.x**
* The `headers` field is now marked as referenceable, which means it can be securely stored as a
[secret](/gateway/latest/kong-enterprise/secrets-management/)
in a vault.
