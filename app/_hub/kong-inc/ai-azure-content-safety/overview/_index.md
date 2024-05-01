---
nav_title: Overview
---

The Azure Content Safety plugin allows administrators to enforce 
introspection with the [Azure Content Safety](https://azure.microsoft.com/en-us/products/ai-services/ai-content-safety) service 
for all requests handled by the AI Proxy plugin.
The plugin enables configurable thresholds for the different moderation categories 
and reports audit results into the {{Site.base_gateway}} log serializer for reporting purposes.

{:.note}
> This plugin extends the functionality of the [AI Proxy plugin](/hub/kong-inc/ai-proxy/), and requires AI Proxy to be configured first. 
Check out the [AI Gateway quickstart](/gateway/latest/get-started/ai-gateway/) to get an AI proxy up and running within minutes!

## Format 

This plugin supports large text documents, base64 images, and many more formats. It is mostly format-agnostic.

## Get started with the AI Prompt Decorator plugin

* [AI Gateway quickstart: Set up AI Proxy](/gateway/latest/get-started/ai-gateway/)
* [Configuration reference](/hub/kong-inc/ai-azure-content-safety/configuration/)
* [Basic configuration example](/hub/kong-inc/ai-prompt-decorator/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/ai-prompt-decorator/how-to/)

### Other AI plugins

You may also be interested in the following AI plugins:
* [AI Proxy](/hub/kong-inc/ai-proxy/)
* [AI Request Transformer](/hub/kong-inc/ai-request-transformer/)
* [AI Response Transformer](/hub/kong-inc/ai-request-transformer/)
* [AI Prompt Template](/hub/kong-inc/ai-prompt-template/)
* [AI Prompt Guard](/hub/kong-inc/ai-prompt-guard/)
