---
nav_title: Overview
---

The Data Sanitization plugin for Kong Gateway helps protect sensitive information in client request bodies before they reach upstream services.
By integrating with an external PII service, the plugin ensures compliance with data privacy regulations while preserving the usability of request data.
It supports multiple sanitization modes, including replacing sensitive information with fixed placeholders or generating synthetic replacements that retain category-specific characteristics.
Additionally, it offers an optional restoration feature, allowing the original data to be reinstated in responses when needed.

## How it works

1. When a request reaches Kong Gateway, the plugin intercepts the request body and forwards it to the external PII service.

2. The PII service analyzes the content, identifies sensitive information, and applies the selected sanitization method (fixed placeholders or category-based synthetic replacements).

3. The sanitized request body is then forwarded to the upstream service through ai-proxy plugin.

4. If the restoration feature is enabled, the plugin can restore the original data in responses before returning them to the client, ensuring a seamless user experience.

{:.note}
> **Note**: This plugin requires the AI Proxy plugin to function properly, please make sure the AI Proxy plugin is enabled and configured correctly for this plugin to work as expected.
