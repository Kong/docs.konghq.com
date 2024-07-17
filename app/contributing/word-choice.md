---
title: Word choice and naming
---

Generally:
* Use contractions
* Use simple words and short, concise sentences
* Avoid non-English words. Most commonly, this means avoiding Latin words and abbreviations.
* Use [bias-free, inclusive language](#bias-free-language).
* Capitalize most of Kong's product and component names as proper names, with some notable exceptions. See the [naming table](#product-application-component-names) for details.

## Product and component names

* Product: Either an application that can be used on its own, or a group of modules packaged together (for example, {{site.konnect_short_name}}).
* Component: A module that's packaged with a product, for example, Dev Portal. Can't be used or sold on its own.

Capitalize the following Kong-specific terms and component names:

<!-- vale off -->

Name | Description
-----|------------
{{site.konnect_product_name}} <br><br> {{site.konnect_short_name}} | Use {{site.konnect_product_name}} for the first mention, and {{site.konnect_short_name}} after.
{{site.base_gateway}} <br><br> Gateway | Kong's API gateway runtime, regardless of packaging or license. This term also refers to the enterprise version. <br><br> Use lowercase “gateway” when referring to the general concept of an API gateway. Use uppercase “Gateway” as a shorthand for “Kong Gateway”. When writing about "Kong Gateway", use "Kong Gateway" for the first mention and "Gateway" after.
{{site.ce_product_name}} | Kong's API gateway runtime, open-source package. Use this name to _specifically_ refer to the open-source package.
{{site.ee_product_name}} | Kong Gateway packaged with Enterprise features. Use when talking about subscription levels or package types.
Kong Mesh <br><br> Mesh | Kong's service mesh. Use "Kong Mesh" for the first mention, "Mesh" after.
Kuma | Kong's open-source service mesh. <br><br> ❌&nbsp; Do not use "Kong Kuma". This is an open-source project supported by the CNCF and maintained, not owned, by Kong.
Insomnia | Kong's open-source API client.
Dev Portal <br><br> Dev Portal, self-managed <br> Dev Portal, cloud | A module for sharing APIs and their specs with developers, and enabling the developers to create applications based on Gateway or Konnect services. <br><br> ❌&nbsp; Do not use "Developer Portal".
{{site.service_catalog_name}} | The service catalog in Konnect. <br><br> ❌&nbsp; Do not use "Servicecatalog", "Service catalog", or "servicecatalog".
Gateway Manager | The runtime management service in Konnect <br><br> ❌&nbsp; Do not use "Gateway manager" with lowercase "manager".
Analytics | Analytics and monitoring for Gateway and Konnect. <br><br> ❌&nbsp; Do not use "Vitals".
decK | Kong's CLI tool for managing declarative configuration.<br><br> ❌&nbsp; Do not capitalize the first letter, even if the name appears at the start of a sentence.

<!-- vale on -->

## Word choice

### Bias-free language

Use gender-neutral and unbiased language.

<!-- vale off -->

✅ &nbsp;Use  | ❌&nbsp; Don't use
--------------------------------|--------------------------------------
Denylist, allowlist             | Blacklist, whitelist
Main branch                     | Master branch
Neutral pronouns (you, they/them) | Gendered pronouns (he/his, she/her)

<!-- vale on -->

### Software terms

<!-- vale off -->

✅ &nbsp;Use  | ❌ &nbsp;Don't use
--------------------------------|--------------------------------------
Self-managed                    | Self-hosted, on-premise(s)
Free tier                       | Free mode
Plus tier                       | Plus mode, Plus subscription
Enterprise tier                  | Enterprise mode, Enterprise subscription
Cloud                           | Software as a Service/SaaS
cURL                            | curl, CURL
HTTPie                          | httpie, HTTPIE
Unix                            | unix, UNIX
Nginx                           | nginx, NGINX

<!-- vale on -->

## See also

Follow Kong's style guide whenever possible. However, you can also refer to other external style guides for specific word choice and substitution examples.
We recommend using the [Google developer style guide](https://developers.google.com/style/word-list).
