---
nav_title: Overview
---

The Kong JWE Decrypt plugin makes it possible to decrypt an inbound token (JWE) in a request.

## Manage keys and Key Sets

For more information, see [Key and Key Set Management in {{site.base_gateway}}](/gateway/latest/reference/key-management/).


## Supported Content Encryption Algorithms

{% if_version lte:3.9.x %}
Currently, A256GCM is supported. More encryption algorithms will be supported in future releases.
{% endif_version %}

{% if_version gte:3.10.x %}
This plugin supports the following encryption algorithms:
* A128GCM
* A192GCM
* A256GCM
* A128CBC-HS256
* A192CBC-HS384
* A256CBC-HS512
{% endif_version %}

## Failure modes

The following table describes the behavior of this plugin in the event of an error.

| Request message                | Proxied to upstream service? | Response status code |
| --------                       | ---------------------------- |--------------------- |
| Has no JWE with strict=true    | No                           | 403                  |
| Has no JWE with strict=false   | Yes                          | x                    |
| Failed to decode JWE           | No                           | 400                  |
| Failed to decode JWE           | No                           | 400                  |
| Missing mandatory header values| No                           | 400                  |
| References key-set not found   | No                           | 403                  |
| Failed to decrypt              | No                           | 403                  |
