---
nav_title: Overview
---

The Prompt Guard plugin lets you to configure a series of regular expressions as allow or deny lists to verify `llm/v1/chat` or `llm/v1/completions` requests.
You can use this plugin to block specific prompts, words, phrases, or otherwise have more control over how an AI / LLM model is used when called via Kong.

This plugin extends the functionality of the [AI Proxy plugin](/hub/kong-inc/ai-proxy/), and requires AI Proxy to be configured first.

Matching behavior:
* If the request matches any regex pattern in the `deny` list, the caller receives a 400 response.
* If there is any `allow` expression specified, but the request matches none of the allowed expressions, the caller also receives a 400 response.
* If the expression matches an `allow` list entry, the request passes through with a 200 response.
* If there is a `deny` list but no `allow` list, any request that doesn't match an entry on the `deny` list also passes through with a 200 response.

## Get started with the AI Prompt Guard plugin

* [Configuration reference](/hub/kong-inc/ai-prompt-guard/configuration/)
* [Basic configuration example](/hub/kong-inc/ai-prompt-guard/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/ai-prompt-guard/how-to/)
