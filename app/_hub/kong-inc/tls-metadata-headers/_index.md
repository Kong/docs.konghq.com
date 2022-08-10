---
name: TLS Metadata Headers
publisher: Kong Inc.

desc: Proxies TLS client certificate metadata to upstream services via HTTP headers
description: |
  The TLS Metadata Header plugin detects client certificates in requests, retrieves the TLS metadata, such as the URL encoded client certificate, and proxies this metadata via HTTP headers.
  This is useful when an upstream service performs some validation for the proxied TLS client certificate.

  The plugin itself does not perform any validation on the client certificate.

  Used in conjunction with any plugin which requests a client certificate, such as the mTLS Authentication or TLS Handshake Modifier plugins.

enterprise: true
plus: false # need to update this once we verify that this plugin is in Konnect post-3.0 update.
cloud: false # need to update this once we verify that this plugin is in Konnect post-3.0 update.
type: plugin
categories:
  - security
kong_version_compatibility:
  enterprise_edition:
    compatible:
      - 3.0.x
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
  konnect_examples: false # need to update this once we verify that this plugin is in Konnect post-3.0 update.

  config:
    - name: inject_client_cert_details
      required: true
      default: false
      datatype: boolean
      value_in_examples: true
      description: |
        Enables TLS client certificate metadata values to be injected into HTTP headers.
    - name: client_cert_header_name
      required: true
      default: X-Client-Cert
      datatype: string
      value_in_examples: X-Forwarded-Client-Cert
      description: |
        Define the HTTP header name used for the PEM format URL encoded client certificate.
    - name: client_serial_header_name
      required: true
      default: X-Client-Cert-Serial
      datatype: string
      description: |
        Define the HTTP header name used for the serial number of the client certificate.
    - name: client_cert_issuer_dn_header_name
      required: true
      default: X-Client-Cert-Issuer-DN
      datatype: string
      value_in_examples: null
      description: |
        Define the HTTP header name used for the issuer DN of the client certificate.
    - name: client_cert_subject_dn_header_name
      required: true
      default: X-Client-Cert-Subject-DN
      datatype: string
      description: |
        Define the HTTP header name used for the subject DN of the client certificate.
    - name: client_cert_fingerprint_header_name
      required: true
      default: X-Client-Cert-Fingerprint
      datatype: string
      description: |
        Define the HTTP header name used for the SHA1 fingerprint of the client certificate.

  extra: |

    The plugin must be used in conjunction with any plugin which requests a client certificate, such as
    the mTLS Authentication or TLS Handshake Modifier plugins.
---
