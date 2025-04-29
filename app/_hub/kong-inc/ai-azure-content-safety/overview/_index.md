---
nav_title: Overview
---

The Azure Content Safety plugin allows administrators to enforce
introspection with the [Azure Content Safety](https://azure.microsoft.com/en-us/products/ai-services/ai-content-safety) service
for all requests handled by the AI Proxy plugin.
The plugin enables configurable thresholds for the different moderation categories
and you can specify an array set of pre-configured blocklist IDs from your Azure Content Safety instance.

Audit failures can be observed and reported on using the {{Site.base_gateway}} logging plugins.

{:.note}
> This plugin extends the functionality of the [AI Proxy plugin](/hub/kong-inc/ai-proxy/), and requires AI Proxy to be configured first.
Check out the [AI Gateway quickstart](/gateway/latest/get-started/ai-gateway/) to get an AI proxy up and running within minutes!

## Format

This plugin works with all of the AI Proxy plugin's `route_type` settings (excluding the `preserve` mode), and is able to
compose an Azure Content Safety text check by compiling all chat history, or just the `'user'` content.

## Get started with the AI Azure Content Safety plugin

* [AI Gateway quickstart: Set up AI Proxy](/gateway/latest/get-started/ai-gateway/)
* [Configuration reference](/hub/kong-inc/ai-azure-content-safety/configuration/)
* [Basic configuration example](/hub/kong-inc/ai-azure-content-safety/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/ai-azure-content-safety/how-to/)

### All AI Gateway plugins

{% include_cached /md/ai-plugins-links.md release=page.release %}
