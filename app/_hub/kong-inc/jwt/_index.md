---
name: JWT
publisher: Kong Inc.
desc: Verify and authenticate JSON Web Tokens
description: |
  Verify requests containing HS256 or RS256 signed JSON Web Tokens (as specified
  in [RFC 7519](https://tools.ietf.org/html/rfc7519)). Each of your Consumers
  will have JWT credentials (public and secret keys), which must be used to sign
  their JWTs. A token can then be passed through:

  - a query string parameter
  - a cookie
  - HTTP request headers

  Kong will either proxy the request to your Upstream services if the token's
  signature is verified, or discard the request if not. Kong can also perform
  verifications on some of the registered claims of RFC 7519 (exp and nbf).
type: plugin
categories:
  - authentication
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
---
