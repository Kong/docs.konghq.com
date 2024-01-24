---
nav_title: Verify registered claims
---

Kong can also perform verification on registered claims, as defined in [RFC 7519](https://tools.ietf.org/html/rfc7519). To perform verification on a claim, add it to the `config.claims_to_verify` property:

You can patch an existing JWT plugin:

```bash
# This adds verification for both nbf and exp claims:
curl -X PATCH http://localhost:8001/plugins/{jwt plugin id} \
  --data "config.claims_to_verify=exp,nbf"
```

Supported claims:

claim name | verification
-----------|-------------
`exp`      | Identifies the expiration time on or after which the JWT must not be accepted for processing.
`nbf`      | Identifies the time before which the JWT must not be accepted for processing.