---
name: PASETO
publisher: peter-evans

categories:
  - authentication

type: plugin

desc: PASETO (Platform-Agnostic Security Tokens)
description: |
  Paseto (Platform-Agnostic SEcurity TOkens) is a specification and reference implementation for secure stateless tokens.

  Verify requests containing signed PASETOs (as specified in [PASETO RFC](https://paseto.io/rfc/){:target="_blank"}{:rel="noopener noreferrer"}).
  Each of your Consumers will have PASETO credentials (public and secret keys) which must be used to sign their PASETOs.
  A token can then be passed through:

  - a query string parameter,
  - a cookie,
  - or the Authorization header.

  The plugin will either proxy the request to your upstream services if the token's signature is verified, or discard the request if not.
  The plugin can also perform verifications on registered claims and custom claims.

  **Feature Support**

  - v2.public JSON payload PASETOs
  - Registered claims validation
  - Custom claims validation

support_url: https://github.com/peter-evans/kong-plugin-paseto/issues

source_code: https://github.com/peter-evans/kong-plugin-paseto

license_type: MIT

license_url: https://github.com/peter-evans/kong-plugin-paseto/blob/master/LICENSE

kong_version_compatibility:
  community_edition:
    compatible:
      - 0.12.x
      - 0.13.x
      - 0.14.x
    incompatible:
  enterprise_edition:
    compatible:
      - 0.32-x
      - 0.33-x
      - 0.34-x
    incompatible:

---
