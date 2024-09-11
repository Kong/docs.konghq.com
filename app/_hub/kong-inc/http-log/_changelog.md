## Changelog

### {{site.base_gateway}} 3.8.x
* Fixed an issue where the plugin didn't include port information in the HTTP host header when sending requests to the log server.
   [#13116](https://github.com/Kong/kong/issues/13116)
   
### {{site.base_gateway}} 3.3.x

* This plugin now supports the `application/json; charset=utf-8` content type.

### {{site.base_gateway}} 3.0.x

* The `headers` parameter now takes a single string per header name, where it
previously took an array of values.

### {{site.base_gateway}} 2.7.x

* If keyring encryption is enabled, the `config.http_endpoint` parameter value
will be encrypted.

### {{site.base_gateway}} 2.4.x

* Added the `custom_fields_by_lua` parameter.

### {{site.base_gateway}} 2.3.x

* Custom headers can now be specified for the log request using the `headers` parameter.
