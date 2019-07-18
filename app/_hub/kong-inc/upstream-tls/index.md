---

name: Upstream TLS
publisher: Kong Inc.
version: 0.0.2

desc: Add TLS to your Services
description: |
  Enable TLS on upstream traffic by providing Kong with a list of trusted
  certificates.

enterprise: true
type: plugin
categories:
  - authentication

kong_version_compatibility:
    enterprise_edition:
      compatible:
        - 0.35-x

params:
  name: upstream-tls
  config:
    - name: verify_mode
      required: false
      default: "`none`"
      description: |
        Sets the certification verification mode flags. `peer` enables client
        peer validation. `none` disables client peer validation.
    - name: verify_depth
      required: false
      default: "`4`"
      description: |
       Set the maximum validation chain depth
    - name: trusted_certificates
      required: true
      default: 
      description: |
        PEM-encoded public certificate authorities of the upstream

---

Upstream TLS can be added on top of an existing Service by executing the 
following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/services/1e6507e9-5c72-4dc2-9a3a-5131c4c5bea6/plugins \
    --data "name=upstream-tls" \
    --data "config.verify_mode=peer" \
    --data "config.trusted_certificates@path_to_cert.pem" \
    --data "config.verify_depth=2"
```

`service`: the `id` or `name` of the Service that this plugin configuration will target.

It can also be applied globally (for every Route, Service, or API) using the
`http://kong:8001/plugins/` endpoint.

### Known Issues

Only one root CA cert can be used to verify against the upstream. If you upload a pem file with multiple certs it must be the first certificate in your uploaded pem file.
