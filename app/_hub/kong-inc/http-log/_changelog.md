## Changelog

**{{site.base_gateway}} 3.0.x**

* The `headers` parameter now takes a single string per header name, where it
previously took an array of values.

**{{site.base_gateway}} 2.7.x**

* If keyring encryption is enabled, the `config.http_endpoint` parameter value
will be encrypted.

**{{site.base_gateway}} 2.4.x**

* Added the `custom_fields_by_lua` parameter.

**{{site.base_gateway}} 2.3.x**

* Custom headers can now be specified for the log request using the `headers` parameter.
