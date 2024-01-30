---
nav_title: Overview
---

The AI Prompt Guard plugin lets you to configure a series of regular expressions as allow or deny lists to verify `llm/v1/chat` or `llm/v1/completions` requests.
You can use this plugin to _block_ specific prompts, words, phrases, or otherwise have more control over how an LLM model is used when called via {{site.base_gateway}}.

{:.note}
> This plugin extends the functionality of the [AI Proxy plugin](/hub/kong-inc/ai-proxy/), and requires AI Proxy to be configured first. Check out the [AI Gateway quickstart](/) to get an AI proxy up and running within minutes!

## How it works

The plugin matches lists of regular expressions to requests through AI Proxy.

The matching behavior is as follows:
* If the request matches any regex pattern in the `deny` list, the caller receives a 400 response.
* If there is any `allow` expression specified, but the request matches none of the allowed expressions, the caller also receives a 400 response.
* If the expression matches an `allow` list entry, the request passes through with a 200 response.
* If there is a `deny` list but no `allow` list, any request that doesn't match an entry on the `deny` list also passes through with a 200 response.

## Get started with the AI Prompt Guard plugin

* [AI Gateway quickstart](/)
* [Configuration reference](/hub/kong-inc/ai-prompt-guard/configuration/{{page.release}})
* [Basic configuration example](/hub/kong-inc/ai-prompt-guard/how-to/basic-example/{{page.release}})
* [Learn how to use the plugin](/hub/kong-inc/ai-prompt-guard/how-to/{{page.release}})

### Other AI plugins

You may also be interested in the following AI plugins:
* [AI Proxy](/hub/kong-inc/ai-proxy/)
* [AI Request Transformer](/hub/kong-inc/ai-request-transformer/)
* [AI Response Transformer](/hub/kong-inc/ai-request-transformer/)
* [AI Prompt Template](/hub/kong-inc/ai-prompt-template/)
* [AI Prompt Decorator](/hub/kong-inc/ai-prompt-decorator/)