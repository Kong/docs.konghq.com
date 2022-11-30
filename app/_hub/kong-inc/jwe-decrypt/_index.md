---
name: Kong JWE Decrypt
publisher: Kong Inc.
desc: Decrypt a JWE token in a request
description: |
  The Kong JWE Decrypt plugin makes it possible to decrypt an inbound token(JWE) in a request.

enterprise: true
plus: true
type: plugin
categories:
  - authentication
kong_version_compatibility:
  community_edition:
    compatible: null
  enterprise_edition:
    compatible: true
params:
  name: jwe-decrypt
  service_id: true
  route_id: true
  consumer_id: false
  protocols:
    - name: http
    - name: https
    - name: grpc
    - name: grpcs
  dbless_compatible: 'yes'
  config:
    - name: lookup_token_name
      required: false
      default: Authorization
      datatype: string
      description: |
        The name of the header to look for the JWE token.
    - name: forward_token_name
      required: false
      default: Authorization
      datatype: string
      description: |
        The name of the header that is used to set the decrypted value.
    - name: strict
      required: false
      default: false
      datatype: boolean
      description: |
        Defines how the plugin behaves in cases where no token was found in the request. When using `strict` mode, the request requires a token to be present and subsequently raise an error if none could be found.
    - name: key-sets
      required: true
      datatype: array of string elements
      description: |
        Denote the name or names of all Key Sets that should be inspected when trying to find a suitable key to decrypt the JWE token.
---


## Manage keys and Key Sets

For more information, see [Key and Key Set Management in Kong Gateway](/gateway/latest/reference/key-management/).


## Supported Content Encryption Algorithms

Currently, A256GCM is supported. More encryption algorithms will be supported in future releases.


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
