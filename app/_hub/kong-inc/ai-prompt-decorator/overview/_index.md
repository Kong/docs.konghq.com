---
nav_title: Overview
---

The AI Prompt Decorator plugin adds an array of `llm/v1/chat` messages to either the start or end of a caller's chat history.
This lets the caller create more complex prompts.

You can use this plugin to set up specific prompt history, words, phrases, or otherwise have more control over how an LLM service is used when called via {{site.base_gateway}}.

{:.note}
> This plugin extends the functionality of the [AI Proxy plugin](/hub/kong-inc/ai-proxy/), and requires AI Proxy to be configured first. 
Check out the [AI Gateway quickstart](/) to get an AI proxy up and running within minutes!

## Get started with the AI Prompt Decorator plugin

* [AI Gateway quickstart: Set up AI Proxy](/gateway/latest/get-started/ai-gateway/)
* [Configuration reference](/hub/kong-inc/ai-prompt-decorator/configuration/)
* [Basic configuration example](/hub/kong-inc/ai-prompt-decorator/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/ai-prompt-decorator/how-to/)

### Other AI plugins

You may also be interested in the following AI plugins:
* [AI Proxy](/hub/kong-inc/ai-proxy/)
* [AI Request Transformer](/hub/kong-inc/ai-request-transformer/)
* [AI Response Transformer](/hub/kong-inc/ai-request-transformer/)
* [AI Prompt Template](/hub/kong-inc/ai-prompt-template/)
* [AI Prompt Guard](/hub/kong-inc/ai-prompt-guard/)