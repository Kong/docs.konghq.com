---
title: Custom Domains for Dev Portal
---

Konnect integrates domain name management and configuration in [Settings](/dev-portal/settings/general). Select your Dev Portal and click **Settings** to view your configuration.

## Dev Portal 

Every Dev Portal instance has an auto-generated default URL. You can also manage custom URLs within Konnect. This gives users the ability to access the Dev Portal from either the default URL, for example `https://example.edge.us.portal.konghq.com`, or a custom URL like `portal.example.com`.

{:.note}
> *Beta Dev Portals use `edge` before region in the default URL, previous Dev Portals do not*

To add a custom URL to Dev Portal, you need:

* A domain and access to configure the domain's DNS `CNAME` records
* Your organization's auto-generated default Dev Portal URL
* A [CAA DNS](https://datatracker.ietf.org/doc/html/rfc6844) record that only allows `pki.goog` if any pre-existing CAA DNS records are present on the domain

## Configure DNS

In your DNS configuration, create a CNAME record for the domain you want to use using the automatically generated Dev Portal URL.
The record will look like this:

| Type  | Name   | Value                                  |
|:------|--------|----------------------------------------|
| CNAME | portal | `https://example.edge.us.portal.konghq.com` |

If your domain has specific CAA DNS records that list authorized certificate authorities/issuers, you'll also need to create a new CAA DNS record to permit [Google Trust Services](https://pki.goog/faq/#caa) as an issuer. If your domain doesn't currently have any CAA DNS records, it means all issuers are implicitly allowed, and there's no need for a new CAA DNS record in that case.

## Update Dev Portal URL settings {#update-portal}

To add a custom URL to Dev Portal, select your Dev Portal, click **Settings**, then follow these steps:

1. Select **Custom hosted domain**.

2. Enter the fully qualified domain name (FQDN) including the subdomain, if applicable, into the **Custom Domain** field.
   Don't include a path or protocol (e.g. `https://`).

3. Click **Save Changes**.

4. CNAME status and SSL status will show `Pending`, while the DNS record TTL expires and SSL is configured. The status of these changes will update as they have been completed.

## Domain name restrictions

Because of SSL certificate authority restrictions, {{site.konnect_short_name}} can't generate SSL certificates
for the following domains:

* TLDs containing a brand name: `.aws`, `.microsoft`, `.ebay`
* Hosting provider subdomains: `.amazonaws.com`, `.azurewebsites.net`
* TLDs restricted by US export laws:
  * `.af` Afghanistan
  * `.by` The Republic of Belarus
  * `.cu` Cuba
  * `.er` Eritrea
  * `.gn` Guinea
  * `.ir` Islamic Republic of Iran
  * `.kp` Democratic People's Republic of Korea
  * `.lr` Liberia
  * `.ru` The Russian Federation
  * `.ss` South Sudan
  * `.su` Soviet Union
  * `.sy` Syrian Arab Republic
  * `.zw` Zimbabwe

If you have any questions, [contact Support](https://support.konghq.com).

## Delete a custom URL {#delete-url}

To delete a custom domain for a Dev Portal, select your Dev Portal, click **Settings**, then click the delete icon.

## Troubleshoot DNS {#troubleshoot}

After the DNS verification process is complete, {{site.konnect_short_name}} will attempt to automatically generate
an SSL certificate for your custom domain. This process can take several hours. If you attempt to access the custom URL from a browser _before_ the certificate generation process is finished,
you will receive an SSL certificate error.  If this process takes more than 24 hours,
check if the new DNS record is correctly applied. You can use the `dig` tool to troubleshoot your DNS:

* Run `dig`, replacing `CUSTOM_DOMAIN` with your custom domain
and `CUSTOM_DOMAIN_DNS` with the DNS server for the custom domain:

   ```shell
   dig +nocmd @CUSTOM_DOMAIN_DNS cname CUSTOM_DOMAIN +noall +answer
   ```

   The output will look like this:

   ```shell
   portal.example.com.	172	IN	CNAME	example.edge.us.portal.konghq.com.
   ```

where `portal.example.com` is your custom domain and `example.edge.us.portal.konghq.com` is the default auto-generated
URL for your Dev Portal.

{:.note}
> *If the command returns no output, or the values are incorrect, check the custom domain DNS configuration or contact your DNS provider.*

{:.note}
> *You may need to reset your Dev Portal domain settings to fix your DNS records, you can do this by [deleting the custom URL](#delete-url) and [setting the portal URL](#update-portal) again.*