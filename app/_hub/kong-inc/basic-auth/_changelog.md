## Changelog

### {{site.base_gateway}} 3.8.x
* Fixed an issue where the realm field wasn't recognized for older {{site.base_gateway}} versions (earlier than 3.6.x).
   [#13042](https://github.com/Kong/kong/issues/13042)
* Added WWW-Authenticate headers to all 401 responses and realm option.
   [#11833](https://github.com/Kong/kong/issues/11833)

### {{site.base_gateway}} 3.6.x
* Added missing `WWW-Authenticate` headers to 401 responses.
 [#11795](https://github.com/Kong/kong/issues/11795)

### {{site.base_gateway}} 3.0.x
* The deprecated `X-Credential-Username` header has been removed.

### {{site.base_gateway}} 2.7.x
* Starting with {{site.base_gateway}} 2.7.0.0, if keyring encryption is enabled
and you are using basic authentication, the `basicauth_credentials.password` field will be encrypted.
