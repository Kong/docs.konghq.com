## Changelog

### {{site.base_gateway}} 3.6.x

* The Azure Functions plugin now eliminates the upstream/request URI and only uses the [`routeprefix`](/hub/kong-inc/azure-functions/configuration/#config-routeprefix) 
configuration field to construct the request path when requesting the Azure API.

### {{site.base_gateway}} 2.7.x

* Starting with {{site.base_gateway}} 2.7.0.0, if keyring encryption is enabled,
 the `config.apikey` and `config.clientid` parameter values will be encrypted.
