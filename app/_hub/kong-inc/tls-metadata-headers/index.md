---
name: TLS Metadata Headers
publisher: Kong Inc.
version: 0.1.x

desc: Proxies TLS Client Certificate Metadata to upstream Services via HTTP Headers
description: |
  Used in conjunction with any plugin which requests a client certificate such as
  the MTLS Authentication or TLS Handshake Modifier plugins.

  If the plugin detects a client certificate in a request, it retrieves the TLS Metadata, such as 
  the URL Encoded Client Certificate and proxies this metadata via HTTP Headers. This is useful when an 
  upstream service performs some validation for the proxied TLS client certificate.

enterprise: true
plus: true
type: plugin
categories:
  - security
kong_version_compatibility:
  enterprise_edition:
    compatible:
      - 2.8.x
params:
  name: tls-metadata-headers
  service_id: true
  consumer_id: false
  route_id: true
  protocols:
    - https
    - grpcs
    - tls
  dbless_compatible: 'yes'
  config:
    - name: inject_client_cert_details
      required: true
      default: '`false`'
      datatype: boolean
      value_in_examples: null
      description: |
        Enables TLS Metadata values to be injected into HTTP Headers.
    - name: client_cert_header_name
      required: true
      default: '`X-Client-Cert`'
      datatype: string
      value_in_examples: null
      description: |
        Define the HTTP Header name used for the PEM format URL encoded client certificate.
    - name: client_serial_header_name
      required: true
      default: '`X-Client-Cert-Serial`'
      datatype: string
      value_in_examples: null
      description: |
        Define the HTTP Header name used for the serial number of the client certificate.
    - name: client_cert_issuer_dn_header_name
      required: true
      default: '`X-Client-Cert-Issuer-DN`'
      datatype: string
      value_in_examples: null
      description: |
        Define the HTTP Header name used for the issuer DN of the client certificate.
    - name: client_cert_subject_dn_header_name
      required: true
      default: '`X-Client-Cert-Subject-DN'`
      datatype: string
      value_in_examples: null
      description: |
        Define the HTTP Header name used for the subject DN of the client certificate.
    - name: client_cert_fingerprint_header_name
      required: true
      default: '`X-Client-Cert-Fingerprint`'
      datatype: string
      value_in_examples: null
      description: |
        Define the HTTP Header name used for the SHA1 fingerprint of the client certificate.

  extra: |

    The plugin must be used in conjunction with any plugin which requests a client certificate such as
    the MTLS Authentication or TLS Handshake Modifier plugins.
---

## Configuration

### Enable the plugin on a service

Configure this plugin on a [service](/gateway/latest/admin-api/#service-object):

```bash
curl -X POST http://<admin-hostname>:8001/services/<service>/plugins \
  --data "name=tls-metadata-headers" \
  --data "config.inject_client_cert_details=true"
```

The `<service>` is the id or name of the service that this plugin configuration will target.

### Enable the plugin on a route

Configure this plugin on a [route](/gateway/latest/admin-api/#route-object) and define a custom
HTTP Header for the PEM formatted URL encoded client certificate:

```bash
$ curl -X POST http://<admin-hostname>:8001/routes/<route>/plugins \
   --data "name=tls-metadata-headers" \
   --data "config.inject_client_cert_details=true" \
   --data "config.client_cert_header_name=X-Forwarded-Client-Cert"
   ```

The `<route>` is the id or name of the route that this plugin configuration will target.

### Enable the plugin globally

A plugin that is not associated to any service, route, or consumer is considered global, and
will run on every request. Read the [Plugin Reference](/gateway/latest/admin-api/#add-plugin) and the
[Plugin Precedence](/gateway/latest/admin-api/#precedence) sections for more information.

Configure this plugin globally:

```bash
curl -X POST http://<admin-hostname>:8001/plugins/ \
    --data "name=tls-metadata-headers"  \
    --data "config.inject_client_cert_details=true"
```
