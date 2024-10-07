## Changelog

### {{site.base_gateway}} 3.8.x
* Added WWW-Authenticate headers to 401 responses.

### {{site.base_gateway}} 3.3.x

*  This plugin now restricts exchanging an authorization code created by one plugin instance for an access token by a different plugin instance.

### {{site.base_gateway}} 2.7.x

* Starting with {{site.base_gateway}} 2.7.0.0, if keyring encryption is enabled
and you are using OAuth2, the `config.provision_key` parameter value and the
consumer `oauth2_credentials.client_secret` will be encrypted.
