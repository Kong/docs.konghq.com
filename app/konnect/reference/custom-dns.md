---
title: Custom Domains
---

{{site.konnect_short_name}} integrates domain name management and configuration in the Dev Portal and with [managed data planes](/konnect/gateway-manager/dedicated-cloud-gateways/). 


## Managed data planes
### {{site.konnect_short_name}} configuration

1. Open {% konnect_icon runtimes %} **Gateway Manager**, choose a control plane to open the **Overview** dashboard, then click **Connect**.
    
    The **Connect** menu will open and display the URL for the **Public Edge DNS**. Save this URL.


1. Select **Custom Domains** from the side navigation, then **New Custom Domain**, and enter your domain name.

    Save the values that appear under **CNAME** and **Content**. 


### Domain registrar configuration

1. Log in to your domain registrar's dashboard.
1. Navigate to the DNS settings section. This area might be labeled differently depending on your registrar.
1. Locate the option to add a new CNAME record and create the following records using the values saved in the [{{site.konnect_short_name}} configuration](#konnect-configuration) section. For example, in AWS Route 53, it would look like this: 

| Host Name                       | Record Type | Routing Policy | Alias | Evaluate Target Health | Value                                                | TTL |
|---------------------------------|-------------|----------------|-------|------------------------|------------------------------------------------------|-----|
| `_acme-challenge.example.com` | CNAME       | Simple         | No    | No                     | `_acme-challenge.9e454bcfec.acme.gateways.konghq.com`| 300 |
| `example.com`             | CNAME       | Simple         | No    | No                     | `9e454bcfec.gateways.konghq.com`                     | 300 |


## Dev Portal 

Every Dev Portal instance has an auto-generated default URL. You can also manage custom URLs within {{site.konnect_short_name}}. This gives users the ability to access the Dev Portal from either the default URL, for example `https://example.us.portal.konghq.com`, or a custom URL like `portal.example.com`.

To add a custom URL to Dev Portal, you need:

* A domain and access to configure the domain's DNS `CNAME` records
* Your organization's auto-generated default Dev Portal URL
* A [CAA DNS](https://datatracker.ietf.org/doc/html/rfc6844) record that only allows `pki.goog` if any pre-existing CAA DNS records are present on the domain

You can also choose to [self-host the Dev Portal with Netlify](/konnect/dev-portal/customization/netlify/) or any other static hosting service that supports single page applications.

### Configure DNS

In your DNS configuration, create a CNAME record for the domain you want to use using the automatically generated Dev Portal URL.
The record will look like this:

| Type  | Name   | Value                                  |
|:------|--------|----------------------------------------|
| CNAME | portal | `https://example.us.portal.konghq.com` |

If your domain has specific CAA DNS records that list authorized certificate authorities/issuers, you'll also need to create a new CAA DNS record to permit [Google Trust Services](https://pki.goog/faq/#caa) as an issuer. If your domain doesn't currently have any CAA DNS records, it means all issuers are implicitly allowed, and there's no need for a new CAA DNS record in that case.

### Update Dev Portal URL settings {#update-portal}

To add a custom URL to Dev Portal, open {% konnect_icon dev-portal %} **Dev Portal**, click **Settings**, then follow these steps:

1. Open the **Portal Domain** tab.

3. Enter the fully qualified domain name (FQDN) including the subdomain, if applicable, into the **Custom Hosted Domain** field.
   Don't include a path or protocol (e.g. `https://`).

4. Click **Save Custom Domain**.

5. Click **Confirm** to begin the domain verification process.

### Domain name restrictions

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

### Delete a custom URL {#delete-url}

Delete a custom Dev Portal URL through your organization's {{site.konnect_short_name}} admin UI.

1. In {{site.konnect_short_name}}, open {% konnect_icon dev-portal %} **Dev Portal**, then click **Settings**.

2. Open the **Portal Domain** tab.

3. Click **Delete Custom Domain**

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
   portal.example.com.	172	IN	CNAME	example.us.portal.konghq.com.
   ```

where `portal.example.com` is your custom domain and `example.us.portal.konghq.com` is the default auto-generated
URL for your Dev Portal.

{:.note}
>**Note:** If the command returns no output, or the values are incorrect, check the custom domain DNS configuration or contact your DNS provider.
>You may need to reset your Dev Portal domain settings to fix your DNS records, you can do this by [deleting the custom URL](#delete-url) and [setting the portal URL](#update-portal) again.