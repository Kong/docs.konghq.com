## Changelog

**{{site.base_gateway}} 3.5.x**
* Added support for [Google Cloud Project's X-Cloud-Trace-Context header](https://cloud.google.com/trace/docs/setup#force-trace)

**{{site.base_gateway}} 3.4.x**
* Added support for [AWS X-Ray header](https://docs.aws.amazon.com/xray/latest/devguide/xray-concepts.html#xray-concepts-tracingheader) propagation.
* The `endpoint` parameter is now referenceable, and can be stored as a secret in a vault.

**{{site.base_gateway}} 3.2.x**
* This plugin can now be scoped to individual services, routes, and consumers.

**{{site.base_gateway}} 3.1.x**
* The `headers` field is now marked as referenceable, which means it can be securely stored as a
[secret](/gateway/latest/kong-enterprise/secrets-management/)
in a vault.
