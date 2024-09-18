---
nav_title: Add Certificate Authorities
title: Add Certificate Authorities
---

To use this plugin, you must add certificate authority (CA) certificates. These are
stored in a separate `ca_certificates` store rather than the main certificates store because
they do not require private keys. To add one, obtain a PEM-encoded copy of your CA certificate
and pass it to the `/ca_certificates` endpoint in a `POST` request:

{% navtabs %}
{% navtab Kong Admin API %}
```bash
curl -X POST https://localhost:8001/ca_certificates -F cert=@cert.pem
```

The response will contain an `id` value that can now be used for the Header Cert Auth plugin configurations or consumer mappings.

{% endnavtab %}

{% navtab Konnect %}

Go through the Gateway Manager:
1. From the {{site.konnect_short_name}} [{% konnect_icon runtimes %} **Gateway Manager**](https://cloud.konghq.com/us/gateway-manager/).
1. Select a control plane and click **Certificates**
1. Select the **CA Certificates** tab and **Add CA Certificate**
1. Copy and paste your certificate information and click **Save**.

You can view the certificate listed in the **Certificates** tab.

To add a certificate via the {{site.konnect_short_name}} API, you need:
* {{site.konnect_short_name}} control plane ID
* [A personal access token](/konnect/api/)

```bash
curl -X POST https://konnect.konghq.com/api/control_planes/{controlPlaneID}/ca_certificates \
  -F cert=@testCACert.pem \
  --header "Authorization: Bearer TOKEN"
```
{% endnavtab %}
{% endnavtabs %}
The `id` value returned can now be used for the Header Cert Auth plugin configurations or consumer mappings.

{:.important}
> **Important:** To ensure proper certificate validation, it is important to upload all required Certificate Authorities (CAs) and their intermediates into the Kong CA store.
> <br><br>
> Failure to do so may result in incomplete certificate validation, as some WAF and load balancer providers only send the end-leaf certificate in their header, rather than encoding the entire certificate chain sent by the client. This is especially crucial when using the `base64_encoded` format.
