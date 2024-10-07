## Changelog

### {{site.base_gateway}} 3.8.x
* Fixed an issue where the consumer's cache couldn't be invalidated when the OAuth2 Introspection plugin used `client_id` as `consumer_by`.

### {{site.base_gateway}} 3.6.x
* Added support for consumer group scoping by using the PDK `kong.client.authenticate` function.
* The `authorization_value` configuration parameter can now be encrypted.

### {{site.base_gateway}} 3.4.x
* Fixed an issue where the plugin failed when processing a request with JSON that is not a table.

### {{site.base_gateway}} 3.0.x
* The deprecated `X-Credential-Username` header has been removed.
