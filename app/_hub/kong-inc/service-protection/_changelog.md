## Changelog

### {{site.base_gateway}} 3.10.x
* Fixed an issue where the runtime failed due to `sync_rate` not being set if the `strategy` was `local`.
* Enhanced robustness for user misconfigurations. The following use cases are now handled:
  * Rate Limiting Advanced and Service Protection are configured on the same service.
  * There is no service but the Service Protection plugin is enabled with global scope.

### {{site.base_gateway}} 3.9.x

* Introduced the Service Protection plugin.
