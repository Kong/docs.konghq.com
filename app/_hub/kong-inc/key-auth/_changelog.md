## Changelog

### {{site.base_gateway}} 3.9.x
* Fixed an issue with the order of query arguments, ensuring that arguments retain order when hiding the credentials.

### {{site.base_gateway}} 3.8.x
* Fixed an issue where the realm field wasn't recognized for older {{site.base_gateway}} versions (earlier than 3.7).
   [#13042](https://github.com/Kong/kong/issues/13042)

### {{site.base_gateway}} 3.7.x
* Added missing `WWW-Authenticate` headers to all 401 responses.
 [#11794](https://github.com/Kong/kong/issues/11794)

### {{site.base_gateway}} 3.0.x
* The deprecated `X-Credential-Username` header has been removed.
* The `key-auth` plugin priority has changed from 1003 to 1250.

### {{site.base_gateway}} 2.3.x
* Added the configuration parameters `key_in_header` and `key_in_query`.
