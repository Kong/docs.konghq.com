---
title: About Self-Hosted Dev Portal
content_type: explanation
badge: oss
---

In {{site.konnect_saas}}, you have two hosting options for your Dev Portal: a cloud hosted Dev Portal with {{site.konnect_short_name}} or a self-hosted, open source Dev Portal. With the cloud hosted Dev Portal in {{site.konnect_short_name}}, your Dev Portal is hosted for you and it simplifies your deployment experience. The self-hosted, open source Dev Portal provides all the same features as the cloud-hosted portal, it just also gives you control over your hosting service and where your Dev Portal is hosted. 

You can use the self-hosted, open source Dev Portal to display your APIs to developers on a self-hosted website. This page explains the benefits of using a self-hosted Dev Portal, a high-level overview of how the self-hosted portal works, and how to enable it.

## Self-hosted Dev Portal benefits

There are several benefits to keep in mind when deciding whether to use a {{site.konnect_short_name}}-hosted or self-hosted Dev Portal: 

* **Fully customizable:** Use the example frontend Dev Portal application as a starting point and then customize Dev Portal for your needs using the Portal API. You can also integrate the API specs with workflows tailored to your organization's own processes.
* **Hosting service choice:** When you self-host, you also get to choose which hosting service you use to deploy your Dev Portal. 
* **Range of customization options:** With the self-hosted Dev Portal, you determine how much you want to customize. You can choose to use the example application right out of the box or you can use the Portal API to have more fine-grained control.

## How the self-hosted Dev Portal works   

<!-- more info here about what happens once I verify the right diagram-->

The following diagram explains how the self-hosted Dev Portal works by using the example frontend application:

![DIAGRAM HERE](/assets/images/docs/konnect/diagram.png)

> Figure 1: Diagram that shows how the example frontend application communicates with the developer's browser and {{site.konnect_short_name}}. 

 
## Enable a self-hosted Dev Portal

To enable the self-hosted Dev Portal in {{site.konnect_short_name}}, click {% konnect_icon dev-portal %} **Dev Portal** > [**Settings**](https://cloud.konghq.com/portal/portal-settings) in the sidebar and then click the **Portal Domain** tab. Once you specify a custom portal domain API in the **Custom Hosted Domain** field and a custom portal client domain in the **Customm Self-Hosted UI Domain** field, your self-hosted portal is enabled. After enabling the portal, you must configure the settings in your static site generator to deploy your Dev Portal.

{:.note}
> **Note:** Enabling the self-hosted Dev Portal disables the {{site.konnect_short_name}}-hosted Dev Portal. Only one can be enabled at a time.

## More information

[Self-Host your Dev Portal with Netlify](/konnect/dev-portal/self-hosted-portal/netlify/) - Learn how to deploy your self-hosted Dev Portal with Netlify.