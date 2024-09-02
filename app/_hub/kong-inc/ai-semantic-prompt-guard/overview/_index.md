---
nav_title: Overview
---

The AI Semantic Prompt Guard plugin is an enhancement of the AI Prompt Guard plugin; it lets you to allow or block prompts based on a list of similar prompts, to guard against misuse of `llm/v1/chat` or `llm/v1/completions` requests.

It does this by scanning all chat messages for the specific expressions set.

You can use a combination of `allow` and `deny` rules to preserve integrity and compliance when serving an LLM service using {{site.base_gateway}}.

{:.note}
> This plugin extends the functionality of the [AI Proxy plugin](/hub/kong-inc/ai-proxy/), and requires AI Proxy to be configured first. 
Check out the [AI Gateway quickstart](/gateway/latest/get-started/ai-gateway/) to get an AI proxy up and running within minutes!

## How it works



## Get started with the AI Prompt Guard plugin

* [AI Gateway quickstart: Set up AI Proxy](/gateway/latest/get-started/ai-gateway/)
* [Configuration reference](/hub/kong-inc/ai-semantic-prompt-guard/configuration/)
* [Basic configuration example](/hub/kong-inc/ai-semantic-prompt-guard/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/ai-semantic-prompt-guard/how-to/)

### All AI Gateway plugins

{% include_cached /md/ai-plugins-links.md release=page.release %}
