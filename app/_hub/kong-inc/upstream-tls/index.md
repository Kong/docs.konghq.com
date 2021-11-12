---

name: Upstream TLS
publisher: Kong Inc.
version: 0.36-x
# do not update! deprecated and removed from code source v 1.5. should delete from repo.

desc: Add TLS to your Services
description: |
  Enable TLS on upstream traffic by providing Kong with a list of trusted
  certificates.
  <div class="alert alert-warning">
    <p><strong>This plugin is deprecated in Kong Gateway version 1.3, and removed in version 1.5.</strong></p>
    <br>
    <p><strong>Starting with <a href="https://docs.konghq.com/gateway/changelog/#changes-2">Kong 1.3.0.0</a>:</strong></p>
    <p>To configure Upstream TLS, use the NGINX directives <code>proxy_ssl_trusted_certificate</code>, <code>proxy_ssl_verify</code>, and <code>proxy_ssl_verify_depth</code> instead of the Upstream TLS plugin. Instructions on how to inject NGINX directives to Kong can be found <a href="https://docs.konghq.com/2.1.x/configuration/#injecting-nginx-directives">here</a>. This plugin is <strong>only functional for Kong Gateway versions 0.35 and 0.36</strong>.</p>
  </div>

enterprise: true
type: plugin

kong_version_compatibility:
    enterprise_edition:
      compatible:
        - 0.36-x
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

In Enterprise versions 0.35 and 0.36, Upstream TLS can be added on top of an existing Service by executing the
following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/services/1e6507e9-5c72-4dc2-9a3a-5131c4c5bea6/plugins \
    --form "name=upstream-tls" \
    --form "config.verify_mode=peer" \
    --form "config.trusted_certificates=@path_to_cert.pem" \
    --form "config.verify_depth=2"
```

`service`: the `id` or `name` of the Service that this plugin configuration will target.

It can also be applied globally (for every Route, Service, or API) using the
`http://kong:8001/plugins/` endpoint.

### Known Issues

PATCH requests to the `trust_certificates` configuration will not take affect until Kong is reloaded. This can be accomplished with the `kong reload` command.
