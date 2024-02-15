---
nav_title: Overview
---

The AI Prompt Template plugin lets you provide tuned AI prompts to users. 
Users only need to fill in the blanks with variable placeholders in the following format: `{% raw %}{{variable}}{% endraw %}`. 

This lets admins set up templates, which can be then be used by anyone in the organization. It also allows admins to present an LLM
as an API in its own right - for example, a bot that can provide software class examples and/or suggestions.

This plugin also sanitizes string inputs to ensure that JSON control characters are escaped, preventing arbitrary prompt injection.

{:.note}
> This plugin extends the functionality of the [AI Proxy plugin](/hub/kong-inc/ai-proxy/), and requires AI Proxy to be configured first. 
Check out the [AI Gateway quickstart](/gateway/latest/get-started/ai-gateway/) to get an AI proxy up and running within minutes!

## How it works

When calling a template, simply replace the `messages` (`llm/v1/chat`) or `prompt` (`llm/v1/completions`) with a template reference, in the
following format: `{template://TEMPLATE_NAME}`

When activated the template restricts an LLM usage to just those pre-defined templates, which are called in the following example format:

```json
{
  "prompt": "{template://sample-template}",
  "properties": {
    "thing": "gravity"
  }
}
```

## Get started with the AI Prompt Template plugin

* [AI Gateway quickstart: Set up AI Proxy](/gateway/latest/get-started/ai-gateway/)
* [Configuration reference](/hub/kong-inc/ai-prompt-template/configuration/)
* [Basic configuration example](/hub/kong-inc/ai-prompt-template/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/ai-prompt-template/how-to/)

### Other AI plugins

You may also be interested in the following AI plugins:
* [AI Proxy](/hub/kong-inc/ai-proxy/)
* [AI Request Transformer](/hub/kong-inc/ai-request-transformer/)
* [AI Response Transformer](/hub/kong-inc/ai-request-transformer/)
* [AI Prompt Guard](/hub/kong-inc/ai-prompt-guard/)
* [AI Prompt Decorator](/hub/kong-inc/ai-prompt-decorator/)