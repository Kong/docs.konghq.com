## Changelog

**{{site.base_gateway}} 3.5.x**
* Fixed an issue to prevent caching network failures during revocation checks.

**{{site.base_gateway}} 3.4.x**
* Fixed several revocation verification issues:
  * If `revocation_check_mode=IGNORE_CA_ERROR`, then the CRL revocation failure will be ignored.
  * Once a CRL is added into the store, it will always do CRL revocation check with this CRL file.
  * OCSP verification failed with `no issuer certificate in chain` error if the client only sent a leaf certificate.
  * `http_timeout` wasn't correctly set.
* Optimized CRL revocation verification.
* Fixed a bug that would cause an unexpected error when `skip_consumer_lookup` is enabled and 
  `authenticated_group_by` is set to `null`.

**{{site.base_gateway}} 3.0.x**
* The deprecated `X-Credential-Username` header has been removed.

**{{site.base_gateway}} 2.8.1.1**

* Introduced certificate revocation list (CRL) and OCSP server support with the
following parameters: `http_proxy_host`, `http_proxy_port`, `https_proxy_host`,
and `https_proxy_port`.
