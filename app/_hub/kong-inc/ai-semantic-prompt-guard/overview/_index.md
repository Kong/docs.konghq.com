---
nav_title: Overview
---

The AI Semantic Prompt Guard plugin enhances the AI Prompt Guard plugin by allowing you to permit or block prompts based on a list of similar prompts, helping to prevent misuse of `llm/v1/chat` or `llm/v1/completions` requests.


You can use a combination of `allow` and `deny` rules to maintain integrity and compliance when serving an LLM service using {{site.base_gateway}}.

{:.note}
> This plugin extends the functionality of the [AI Proxy plugin](/hub/kong-inc/ai-proxy/), and requires AI Proxy to be configured first. 
Check out the [AI Gateway quickstart](/gateway/latest/get-started/ai-gateway/) to get an AI proxy up and running within minutes.

## How it works

The plugin matches lists of prompts to requests through AI Proxy.

The matching behavior is as follows:
* If any `deny` prompts are set, and the request matches prompt in the `deny` list, the caller receives a 400 response.
* If any `allow` prompts are set, but the request matches none of the allowed prompts, the caller also receives a 400 response.
* If any `allow` prompts are set, and the request matches one of the `allow` prompts, the request passes through to the LLM.
* If there are both `deny` and `allow` prompts set, any request that doesn't match an entry on the `deny` list must then also match one `allow` prompt to be passed through to the LLM.

## Get started with the AI Prompt Guard plugin

* [AI Gateway quickstart: Set up AI Proxy](/gateway/latest/get-started/ai-gateway/)
* [Configuration reference](/hub/kong-inc/ai-semantic-prompt-guard/configuration/)
* [Basic configuration example](/hub/kong-inc/ai-semantic-prompt-guard/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/ai-semantic-prompt-guard/how-to/)

### All AI Gateway plugins

{% include_cached /md/ai-plugins-links.md release=page.release %}
