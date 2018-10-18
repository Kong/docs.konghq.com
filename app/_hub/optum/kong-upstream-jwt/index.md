---
name: Kong Upstream JWT
publisher: Optum

categories:
  - security

type: plugin

desc: Add a signed JWT into the header of proxied requests

description: |
  This plugin will add a signed JWT into the HTTP Header `JWT` of proxied requests through the Kong gateway. The purpose of this, is to provide means of _Authentication_, _Authorization_ and _Non-Repudiation_ to API providers (APIs for which Kong is a gateway).

  API Providers need a means of cryptographically validating that requests they receive were proxied by Kong and not tampered with during transmission from Kong -> API Provider. This token accomplishes both as follows:

  1. **Authentication** & **Authorization** - Provided by means of JWT signature validation. The API Provider will validate the signature on the JWT token (which is generating using Kong's RSA x509 private key), using Kong's public key. This public key can be maintained in a keystore, or sent with the token - provided API providers validate the signature chain against their truststore.

  2. **Non-Repudiation** - SHA256 is used to hash the body of the HTTP request body, and the resulting digest is included in the `payloadhash` element of the JWT body. API Providers will take the SHA256 hash of the HTTP Request Body, and compare the digest to that found in the JWT. If they are identical, the request remained intact during transmission.

support_url: https://github.com/Optum/kong-upstream-jwt/issues

source_url: https://github.com/Optum/kong-upstream-jwt/

license_type: Apache-2.0

kong_version_compatibility:
  community_edition:
    compatible:
      - 0.14.x
      - 0.13.x
      - 0.12.x
    incompatible:
      - 0.11.x
      - 0.10.x
      - 0.9.x
      - 0.8.x
      - 0.7.x
      - 0.6.x
      - 0.5.x
      - 0.3.x
      - 0.2.x
  enterprise_edition:
    compatible:
      - 0.34-x
      - 0.33-x
      - 0.32-x
      - 0.31-x
      - 0.30-x
    incompatible:
      - 0.29-x


params:
  name: kong-upstream-jwt
  api_id: true
  service_id: true
  consumer_id: false
  route_id: true

extra: |
  Installing this plugin globally will ensure security across all proxies for service providers who implement the JWT validation correctly.
###############################################################################
# END YAML DATA
# Beneath the next --- use Markdown (redcarpet flavor) and HTML formatting only.
#
# The remainder of this file is for free-form description, instruction, and
# reference matter.
# Your headers must be Level 3 or 4 (parsing to h3 or h4 tags in HTML).
# This is represented by ### or #### notation preceding the header text.
###############################################################################
# BEGIN MARKDOWN CONTENT
---

### Installation

Recommended:

```
$ luarocks install kong-upstream-jwt
```

Other:

```
$ git clone https://github.com/Optum/kong-upstream-jwt.git /path/to/kong/plugins/kong-upstream-jwt
$ cd /path/to/kong/plugins/kong-upstream-jwt
$ luarocks make *.rockspec
```

### Configuration

The plugin requires that Kong's private key be accessible in order to sign the JWT. [We also include the x509 cert in the `x5c` JWT Header for use by API providers to validate the JWT](https://tools.ietf.org/html/rfc7515#section-4.1.6). We access these via Kong's overriding environment variables `KONG_SSL_CERT_KEY` for the private key as well as `KONG_SSL_CERT_DER` for the public key. The first contains the path to your .key file, the second specifies the path to your public key in DER format .cer file.

If not already set, these can be done so as follows:

```
$ export KONG_SSL_CERT_KEY="/path/to/kong/ssl/privatekey.key"
$ export KONG_SSL_CERT_DER="/path/to/kong/ssl/kongpublickey.cer"
```

**One last step** is to make the environment variables accessible by a nginx worker. To do this, simply add these line to your _nginx.conf_

```
env KONG_SSL_CERT_KEY;
env KONG_SSL_CERT_DER;
```

### Maintainers

[jeremyjpj0916](https://github.com/jeremyjpj0916)  
[rsbrisci](https://github.com/rsbrisci)  

Feel free to [open issues](https://github.com/Optum/kong-upstream-jwt/issues), or refer to our [Contribution Guidelines](https://github.com/Optum/kong-upstream-jwt/blob/master/CONTRIBUTING.md) if you have any questions.
