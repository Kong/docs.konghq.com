---
name: Kong JWE Decrypt
publisher: Kong Inc.
desc: Decrypt a JWE token in a request
description: |
  The Kong Jwe Decrypt plugin makes it possible to decrypt an inbound token(JWE) in a request.

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
        The name of the header that is used to set the decrypted value to.
    - name: strict
      required: false
      default: false
      datatype: boolean
      description: |
        Defines how the plugin behaves in cases where no token was found in the request. When using `strict` mode the request requires a token to be present and subsequently raise an error if none could be found.
    - name: key-sets
      required: true
      datatype: array of string elements
      description: |
        Denote the name(s) of all keysets that should be inspected when trying to find a suitable key to decrypt the JWE token.
---


## Manage keys and keysets

Ref to new keys and key-sets entity (when https://github.com/Kong/docs.konghq.com/pull/4804 is merged)


## Supported Content Encryption Algorithms

Currently we support

* A256GCM

more is planned.


## Failure modes

This section describes the behavior of this plugin in case of an error.

request                        | proxied to upstream service | response status code
--------                       |--------------------------|---------------------
has no JWE with strict=true    | no                       | 403
has no JWE with strict=false   | yes                      | x
failed to decode JWE           | no                       | 400
failed to decode JWE           | no                       | 400
missing mandatory header values| no                       | 400
references key-set not found   | no                       | 403
failed to decrypt              | no                       | 403
