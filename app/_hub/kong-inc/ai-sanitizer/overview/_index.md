---
nav_title: Overview
---

The AI Sanitizer plugin for {{site.base_gateway}} helps protect sensitive information in client request bodies before they reach upstream services.
By integrating with an external PII service, the plugin ensures compliance with data privacy regulations while preserving the usability of request data.
It supports multiple sanitization modes, including replacing sensitive information with fixed placeholders or generating synthetic replacements that retain category-specific characteristics.

Additionally, it offers an optional restoration feature, allowing the original data to be reinstated in responses when needed.

{:.note}
> This plugin extends the functionality of the [AI Proxy plugin](/hub/kong-inc/ai-proxy/) or the [AI Proxy Advanced](/hub/kong-inc/ai-proxy-advanced/) plugin, and requires an AI proxy to be configured first. 
Check out the [AI Gateway quickstart](/gateway/latest/get-started/ai-gateway/) to get an AI proxy up and running within minutes!

{:.note}
> The AI Sanitizer plugin is relying on the [AI PII Services](https://github.com/Kong/ai-pii-service) service for identifying and sanitizing sensitive information, which can be deployed as a standalone service or docker container. Check out the [AI Sanitizer plugin](/hub/kong-inc/ai-sanitizer) for more information on how to config the plugin with the AI PII Services.

## How it works

1. When a request reaches {{site.base_gateway}}, the plugin intercepts the request body and forwards it to the external PII service.
2. The PII service analyzes the content, identifies sensitive information, and applies the selected sanitization method (fixed placeholders or category-based synthetic replacements).
3. The sanitized request body is then forwarded to the upstream service through the AI Proxy or AI Proxy Advanced plugin.
4. If the restoration feature is enabled, the plugin can restore the original data in responses before returning them to the client, ensuring a seamless user experience.
