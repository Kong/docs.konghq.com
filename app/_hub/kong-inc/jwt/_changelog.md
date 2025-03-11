## Changelog

### {{site.base_gateway}} 3.9.x
* Ensured that `rsa_public_key` isn't base64-decoded.

### {{site.base_gateway}} 3.8.x
* Added WWW-Authenticate headers to 401 responses.

### {{site.base_gateway}} 3.7.x
* Added support for EdDSA algorithms.
[#12726](https://github.com/Kong/kong/issues/12726)
* Added support for ES512, PS256, PS384, and PS512 algorithms.
[#12638](https://github.com/Kong/kong/issues/12638)
* Fixed an issue where the plugin would fail when using invalid public keys for ES384 and ES512 algorithms.
[#12724](https://github.com/Kong/kong/issues/12724)

### {{site.base_gateway}} 3.2.x

* Breaking changes
  * Denies a request that has different tokens in the JWT token search locations.