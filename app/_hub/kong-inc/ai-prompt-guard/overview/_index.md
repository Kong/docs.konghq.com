---
nav_title: Overview
---

The AI Prompt Guard plugin lets you to configure a series of PCRE-compatible regular expressions as allow or deny lists,
to guard against misuse of `llm/v1/chat` or `llm/v1/completions` requests.

You can use this plugin to _allow_ or _block_ specific prompts, words, phrases, or otherwise have more control over how an LLM service is
used when called via {{site.base_gateway}}.

It does this by scanning all chat messages (where the role is `user`) for the specific expressions set.

You can use a combination of `allow` and `deny` rules to preserve integrity and compliance when serving an LLM service using Kong Gateway.

* **For llm/v1/chat type models**: You can optionally configure the plugin to **ignore existing chat history**, wherein it will only scan the trailing `user` message.
* **For llm/v1/completions type models**: There is only one "prompt" field, thus the whole prompt is scanned on every request.

{:.note}
> This plugin extends the functionality of the [AI Proxy plugin](/hub/kong-inc/ai-proxy/), and requires AI Proxy to be configured first. 
Check out the [AI Gateway quickstart](/) to get an AI proxy up and running within minutes!

## How it works

The plugin matches lists of regular expressions to requests through AI Proxy.

The matching behavior is as follows:
* If any `deny` expressions are set, and the request matches any regex pattern in the `deny` list, the caller receives a 400 response.
* If any `allow` expressions are set, but the request matches none of the allowed expressions, the caller also receives a 400 response.
* If any `allow` expressions are set, and the request matches one of the `allow` expressions, the request passes through to the LLM.
* If there are both `deny` and `allow` expressions set, any request that doesn't match an entry on the `deny` must then also match one `allow` expression to be passed through to the LLM.

## Get started with the AI Prompt Guard plugin

* [AI Gateway quickstart: Set up AI Proxy](/gateway/latest/get-started/ai-gateway/)
* [Configuration reference](/hub/kong-inc/ai-prompt-guard/configuration/)
* [Basic configuration example](/hub/kong-inc/ai-prompt-guard/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/ai-prompt-guard/how-to/)

### Other AI plugins

You may also be interested in the following AI plugins:
* [AI Proxy](/hub/kong-inc/ai-proxy/)
* [AI Request Transformer](/hub/kong-inc/ai-request-transformer/)
* [AI Response Transformer](/hub/kong-inc/ai-request-transformer/)
* [AI Prompt Template](/hub/kong-inc/ai-prompt-template/)
* [AI Prompt Decorator](/hub/kong-inc/ai-prompt-decorator/)