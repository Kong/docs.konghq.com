---
title: Customize the Konnect Dev Portal
no_version: true
content_type: how-to
---

You can customize the {{site.konnect_short_name}} Dev Portal in the following ways:
* [Appearance](#appearance)
* [Custom URL](#custom-dev-portal-url)
* [Access](/konnect/dev-portal/access/)
* [Single-sign on](#single-sign-on)


## Appearance

The Dev Portal can be customized by those with admin roles via the **Appearance
settings** in the {{site.konnect_short_name}} admin UI. To access the appearance
settings, click {% konnect_icon dev-portal %} **Dev Portal**, then **Appearance**.

From the **Appearance** menu you have the ability to modify the following options:

* Logos: default logo and favicon
* Home Page Header: welcome message, primary header, and header image
* Colors: background, text, and button colors
* Themes: default theme and dark mode
* Fonts

For details on the requirements for each customizable option, hover over the information (`i`) icon next to each item in the UI.

## Custom Dev Portal URL

All Dev Portals come with a default Dev Portal URL like `https://mycompany1234.us.portal.konghq.com` generated 
when portal is first created. We provide a way to add a custom domain you own (e.g. `portal.example.com`)
and make the Dev Portal securely accessible using both the default URL and your custom URL.

To make the process of adding a custom domain to your Dev Portal as easy as possible, we handle SSL certificate
generation and any required HTTP rewrites for you automatically.

### Prerequisites

* A domain and access to configure the domain's DNS `CNAME` records
* Your organization's auto-generated default Dev Portal URL. For example, `https://mycompany1234.us.portal.konghq.com/`.

### Step 1: Configure DNS

Go to your DNS provider configuration and add a canonical name (CNAME) record to the domain you want to use.

The record should look like the following:

| Type  | Name   | Value                                                                                      |
|:------|--------|--------------------------------------------------------------------------------------------|
| CNAME | portal | (Auto-generated default Dev Portal URL, e.g. `https://mycompany1234.us.portal.konghq.com`) |

### Step 2: Update Portal URL settings

To add a custom URL to Dev Portal, open {% konnect_icon dev-portal %} **Dev Portal**, click **Settings**, then follow these steps: 

1. Open the **Portal URL** tab.

3. Enter the FQDN (full domain including a subdomain, if applicable, e.g. `portal.example.com`) into the **Custom Portal URL** field.
   Don't include a path or protocol (e.g. `https://`).

4. Click **Save Custom Domain**

5. Confirm your action in the displayed modal by clicking **Confirm**. This will begin the domain verification process.

### Step 3: Test your Custom URL

After the DNS verification process is complete, {{site.konnect_short_name}} will attempt to automatically generate 
an SSL certificate for your Custom Domain. This process can take several hours.

Note that if you open the Custom URL in a browser **before** the certificate generation process is finished,
you may see an SSL Certificate Error screen. This is an expected browser behavior.

{:.note}
> **Note:** If this process takes more than 24 hours, 
> please [check if the new DNS record is correctly applied.](./#checking-dns-records).
> and contact [Kong Support](https://support.konghq.com) if the issue persist

### Domain Name Restrictions

Most of the Top Level Domains for Custom URLs are supported in {{site.konnect_short_name}}.
However, due to our SSL Certificate Authority restrictions, we can't generate SSL certificates 
for some specific domains, and thus we don't support custom domains using:

* TLDs containing a brand name (`.aws`, `.microsoft`, `.ebay`, and so on...)
* subdomains of well-known hosting providers (`.amazonaws.com`, `.azurewebsites.net`, and so on...)
* TLDs restricted by US Export laws
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

Please [Contact Support](https://support.konghq.com) if you have any questions.

### Checking DNS records

DNS Propagation can take some time, and depending on a selected DNS server. It can give mixed results 
when changes are still synchronizing worldwide. You can query your domain's DNS server to see if the changes applied
for the Custom URL setup are correct using a DNS lookup tool like
[`dig`](https://linux.die.net/man/1/dig){:target="_blank"}.

#### Troubleshooting DNS using `dig`

Run the following command - replace `<CUSTOM_DOMAIN>` with the custom domain 
you're using and `<CUSTOM_DOMAIN_DNS>` with the DNS server for this custom domain.

```shell
$ dig +nocmd @<CUSTOM_DOMAIN_DNS> cname <CUSTOM_DOMAIN> +noall +answer
```

The command should output a result like this:
```text
portal.example.com.	172	IN	CNAME	mycompany1234.us.portal.konghq.com.
```
where `portal.example.com` is your Custom Domain and `mycompany1234.us.portal.konghq.com` is the default auto-generated 
URL for your Dev Portal.

If there's no output or the values don't seem correct, please check them in your Custom Domain DNS configuration
and contact your DNS provider if necessary.

You might need to reset your Dev Portal Custom Domain if you have to fix your DNS records.
In order to do so, [Delete your Custom URL](./#deleting-a-custom-url) and [Setup Portal URL](./#step-2-update-portal-url-settings) again.

### Deleting a Custom URL

Delete a Custom Portal URL through your organization's {{site.konnect_short_name}} Admin UI.

1. In {{site.konnect_short_name}}, open {% konnect_icon dev-portal %} **Dev Portal**, then click **Settings**.

2. Open the **Portal URL** tab.

3. Click **Delete Custom Domain**

4. Confirm your action in the displayed modal by clicking **Delete**

## Single Sign-On
{:.badge .enterprise}

A {{site.konnect_short_name}} admin can configure single sign-on (SSO) for the Dev Portal via the identity settings in the {{site.konnect_short_name}} admin interface.

To configure single sign-on, open {% konnect_icon dev-portal %} **Dev Portal**, click **Settings**, then follow these steps: 

1. Open the **Identity** tab.

   {:.note}
1. Copy the callback URL and enter it in your identity provider.

2. Enter the full domain, including the subdomain and protocol, into the  **Provider URL** field (also known as **Issuer**). For example, `https://accounts.google.com` for Google IdP.

3. Enter the unique identifier provided by the IdP into the **Client ID** field.

4. Enter the secret used to verify ownership of your IdP client into the **Client Secret** field.

### Configuration Requirements

You must always have a form of authentication configured. Built-in and SSO can be used individually or in combination. Each state results in a different user experience, as represented in the following table:

| State | SSO registration | SSO sign in | Built-in registration| Built-in sign in | Information|
| --- | :-----------: |  ----------- | :-----------: | ----------- |
| **SSO: Enabled**<br>**Built-in: Disabled** | ✅ | ✅ | ❌ | ❌ | - Developers can register and log in with SSO.<br><br>- Developers registered with Built-in are forced to use SSO.<br><br>- The Built-in authentication window does not display from the Dev Portal. 
| **SSO: Disabled**<br>**Built-in: Enabled** | ❌ | ❌ | ✅  |✅  | - Developers can register and log in with a username and password.| 
| **SSO: Enabled**<br>**Built-in: Enabled** | ✅  | ✅ | ✅  | ✅  | - Developers can register and log in with either form of authentication.|


### OIDC Details

* If a user account associated with a {{site.konnect_short_name}} developer is removed from the IdP, the {{site.konnect_short_name}} developer account is not deleted. A {{site.konnect_short_name}} Admin must delete it from the {{site.konnect_short_name}} dashboard.
* If a {{site.konnect_short_name}} developer associated with an IdP user is deleted, the same IdP user can re-authenticate with the Dev Portal and a new {{site.konnect_short_name}} developer account is created. To persistently revoke access for developers authenticating through your IdP, you must remove the ability for that user to authenticate with the IdP.
* User information from the IdP is not synced with {{site.konnect_short_name}} developers after the first login.
