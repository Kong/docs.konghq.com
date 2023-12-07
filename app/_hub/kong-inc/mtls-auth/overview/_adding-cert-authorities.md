---
nav_title: Adding Certificate Authorities
title: Adding Certificate Authorities
---

### Adding certificate authorities

To use this plugin, you must add certificate authority (CA) certificates. These are
stored in a separate `ca_certificates` store rather than the main certificates store because
they do not require private keys. To add one, obtain a PEM-encoded copy of your CA certificate
and POST it to `/ca_certificates`:

{% navtabs %}
{% navtab Kong Admin API %}
```bash
curl -sX POST https://localhost:8001/ca_certificates -F cert=@cert.pem
{
  "tags": null,
  "created_at": 1566597621,
  "cert": "-----BEGIN CERTIFICATE-----\FullPEMOmittedForBrevity==\n-----END CERTIFICATE-----\n",
  "id": "322dce96-d434-4e0d-9038-311b3520f0a3"
}
```
{% endnavtab %}

{% navtab Konnect %}

Go through the Gateway Manager:
1. In {{site.konnect_short_name}}, click {% konnect_icon runtimes %} **Gateway Manager**.
2. Select the control plane you want to add the CA certificate to.
3. Click **Certificates**.
4. Select the **CA Certificates** tab.
5. Click **+ Add CA Certificate**
6. Copy and paste your certificate information and click **Save**.

You can view your certificate listed in the **Certificates** tab.

To add a certificate via curl, you need:
* {{site.konnect_short_name}} ID
* A generated access cookie

```bash
curl -X POST https:konnect.konghq.com/api/control_planes/[Konnect-ID]/ca_certificates -F cert=@testCACert.pem --cookie '[generated access cookie]'
```
{% endnavtab %}
{% endnavtabs %}
The `id` value returned can now be used for mTLS plugin configurations or consumer mappings.

{% if_plugin_version gte:3.1.x %}
