---
nav_title: ACME Plugin API Reference
---

## Monitoring and debugging

The ACME plugin exposes several endpoints through the Admin API that can be used for
debugging and monitoring certificate creation and renewal.

To configure and enable the plugin itself, [use the `/plugins` API endpoint](/hub/kong-inc/acme/how-to/basic-example/).
The `/acme` endpoints only appear once the plugin has been enabled. 

### Apply certificate

**Endpoint**

<div class="endpoint post">/acme</div>
Applies or renews the certificate and returns the result.

**Request body**

Attribute | Description
---:| ---
`host`<br>*required* | The domain where to create the certificate.
`test_http_challenge_flow`<br>*optional* | When set, only checks if the configuration is valid. Does not apply the certificate.

### Update certificate

Apply or renew the certificate and return the result. Unlike `POST`, `PATCH` runs the process in the background.

**Endpoint**

<div class="endpoint patch">/acme</div>

**Request body**

Attribute | Description
---:| ---
`host`<br>*required* | The domain where to create the certificate.
`test_http_challenge_flow`<br>*optional* | When set, only checks if the configuration is valid. Does not apply the certificate.

### Get ACME certificates

List the certificates being created by the ACME plugin. You can use this endpoint to monitor certificate existence and expiry.

**Endpoint**
<div class="endpoint get">/acme/certificates</div>

### Get certificate by host

List certificates with a specific host.

**Endpoint**
<div class="endpoint get">/acme/certificates/{HOST}</div>

Attribute | Description
---:| ---
`HOST` | The IP or hostname of the host to target.

Example response for listing certificates:

```json
{
  "data": [
    {
      "not_after": "2022-09-21 23:59:59",
      "pubkey_type": "id-ecPublicKey",
      "digest": "A9:49:55:06:A7:B6:1D:2B:13:47:C5:58:5B:AC:DA:43:B5:25:E0:86",
      "issuer_cn": "ZeroSSL ECC Domain Secure Site CA",
      "valid": true,
      "host": "subdomain1.domain.com",
      "not_before": "2022-06-23 00:00:00",
      "serial_number": "93:B8:E9:D5:C6:36:ED:B4:A8:B3:FD:C5:9E:A8:08:88"
    },
    {
      "not_after": "2022-09-21 23:59:59",
      "pubkey_type": "id-ecPublicKey",
      "digest": "26:12:A2:C4:6A:F5:A5:90:9D:03:15:CB:FE:A7:BF:32:1C:42:49:CE",
      "issuer_cn": "ZeroSSL ECC Domain Secure Site CA",
      "valid": true,
      "host": "subdomain2.domain.com",
      "not_before": "2022-06-23 00:00:00",
      "serial_number": "F1:15:74:E3:E1:DD:21:72:48:C0:4F:06:25:1B:71:F7"
    }
  ]
}
```
