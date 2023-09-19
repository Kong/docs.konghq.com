---
title: About Self-Hosted Dev Portal
content_type: explanation
---

In {{site.konnect_saas}}, you have two out-of-the-box solutions for your Dev Portal: a cloud-hosted Dev Portal with {{site.konnect_short_name}} or a self-hosted, open source Dev Portal. 
* **Cloud-hosted Dev Portal in {{site.konnect_short_name}}**: Your Dev Portal is hosted for you and it simplifies your deployment experience. 
* **Self-hosted, open source Dev Portal**: Provides all the same features as the cloud-hosted portal, but also gives you control over your hosting platform. 

You can use the open source Dev Portal to display your APIs to developers on a self-hosted website. This page explains the benefits of using a self-hosted Dev Portal, a high-level overview of how the self-hosted portal works, and how to enable it.

## Self-hosted Dev Portal benefits

There are several benefits to keep in mind when deciding whether to use a {{site.konnect_short_name}}-hosted or self-hosted Dev Portal. The self-hosted portal provides the following benefits: 

* **Fully customizable:** Use the [example frontend Dev Portal application](https://github.com/Kong/konnect-portal) as a starting point and then customize Dev Portal for your needs using the [Portal API](/konnect/api/portal/v2/). You can also integrate the API specs with workflows tailored to your organization's own processes.
* **Hosting platform choice:** When you self-host, you also get to choose which hosting platform you use to deploy your Dev Portal. 
* **Range of customization options:** With the self-hosted Dev Portal, you determine how much you want to customize. You can choose to use the example application right out of the box, or you can use the [Portal API](/konnect/api/portal/v2/) and [Portal SDK](https://www.npmjs.com/package/@kong/sdk-portal-js) for more fine-grained control.

## How the self-hosted Dev Portal works 

The following diagram explains how the self-hosted Dev Portal works by using the example frontend application:

![self-hosted portal architecture](/assets/images/docs/konnect/konnect-self-hosted-portal-architecture.png)

> Figure 1: Diagram that shows how the example frontend application communicates with the developer's browser and {{site.konnect_short_name}}. The self-hosted Dev Portal is hosted in your infrastructure and the application is served to the developer browser. The developer browser communicates with the Portal API for API requests and {{site.konnect_short_name}} supplies the corresponding content. 

The Dev Portal API is always hosted by {{site.konnect_short_name}}, no matter if you use the self-hosted or {{site.konnect_short_name}}-hosted Dev Portal. The Dev Portal API maps to the Portal Domain (and optional Custom Hosted Domain, which is a CNAME). Depending on which domain settings you configure and if you are self-hosting or not, the Dev Portal UI domain will differ.

![Dev Portal URLs](/assets/images/docs/konnect/konnect-dev-portal-urls.png)

> Figure 2: Diagram that shows that self-hosted and {{site.konnect_short_name}}-hosted Dev Portals use different UI domains, but both use the same {{site.konnect_short_name}}-hosted Dev Portal API.
 
## Enable a self-hosted Dev Portal

You can enable the self-hosted Dev Portal through {% konnect_icon dev-portal %} **Dev Portal** > [**Settings**](https://cloud.konghq.com/portal/portal-settings), then setting up a custom domain in the **Portal Domain** tab. 

The following fields are required:
* Custom Hosted Domain
* Custom Self-Hosted UI Domain

After enabling the portal, configure your hosting provider to serve your Dev Portal. You can host it with Netlify using our [instructions](/konnect/dev-portal/customization/netlify/).

{:.note}
> **Note:** Enabling the self-hosted Dev Portal disables the {{site.konnect_short_name}}-hosted Dev Portal. Only one can be enabled at a time.

## More information

[Self-Host your Dev Portal with Netlify](/konnect/dev-portal/customization/netlify/) - Learn how to deploy your self-hosted Dev Portal on Netlify.
