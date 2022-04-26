---
title: Word choice and naming
no_version: true
---

Generally:
* Use contractions
* Use simple words and short, concise sentences
* Avoid non-English words. Most commonly, this means avoiding Latin words and abbreviations.
* Use [bias-free, inclusive language](#bias-free-language).
* Capitalize most of Kong's product, application, and component names as proper names, with some notable exceptions. See the [naming table](#product-application-component-names) for details.

## Product, application, component names

Capitalize the following Kong-specific terms and component names:

Name | Description
-----|------------
Kong Konnect Cloud <br><br> Konnect Cloud | Use Kong Konnect Cloud for the first mention, Konnect Cloud or simply Konnect after.
Kong Gateway <br><br> Gateway | Kong's API gateway runtime, regardless of packaging or license. This term also refers to the enterprise version. <br><br> Use lowercase “gateway” when referring to the general concept of an API gateway. Use uppercase “Gateway” as a shorthand for “Kong Gateway”. When writing about "Kong Gateway", use "Kong Gateway" for the first mention and "Gateway" after.
Kong Gateway (OSS) | Kong's API gateway runtime, open-source package. Use this name to _specifically_ refer to the open-source package.
Kong Mesh <br><br> Mesh | Kong's service mesh. Use "Kong Mesh" for the first mention, "Mesh" after.
Kuma | Kong's open-source service mesh. <br><br> ❌&nbsp; Do not use "Kong Kuma". This is an open-source project supported by the CNCF and maintained, not owned, by Kong.
Insomnia | Kong's open-source API client.
Dev Portal <br><br> Dev Portal, self-managed <br> Dev Portal, cloud | A module for sharing APIs and their specs with developers, and enabling the developers to create applications based on Gateway or Konnect services. <br><br> ❌&nbsp; Do not use "Developer Portal".
ServiceHub | The service catalog in Konnect Cloud. <br><br> ❌&nbsp; Do not use "Service Hub", "Service hub", or "Servicehub".
Runtime Manager | The runtime management service in Konnect Cloud <br><br> ❌&nbsp; Do not use "Runtime manager".
Vitals | Analytics for Gateway.
decK | Kong's CLI tool for managing declarative configuration.<br><br> ❌&nbsp; Do not capitalize the first letter, even if the name appears at the start of a sentence.

### Generic terms

Don't capitalize the following generic terms:
- plugins
- control plane
- data plane
- hybrid mode
- service
- route
- consumer
- service mesh
- database

## Word choice

### Bias-free language

Use gender-neutral and unbiased language.

✅ &nbsp;Use  | ❌&nbsp; Don't use
--------------------------------|--------------------------------------
Denylist, allowlist             | Blacklist, whitelist
Main branch                     | Master branch
Neutral pronouns (you, they/them) | Gendered pronouns (he/his, she/her)

### Software terms

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

## See also

Follow Kong's style guide whenever possible. However, you can also refer to other external style guides for specific word choice and substitution examples.
We recommend using the [Google developer style guide](https://developers.google.com/style/word-list).
