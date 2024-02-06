---
nav_title: Overview
---

The AI Proxy plugin lets you transform and proxy requests to a number of AI providers and models.

The plugin accepts requests in one of a few defined and standardised formats, translates them to the configured target format, and then transforms the response back into a standard format.

The AI Proxy plugin supports `llm/v1/chat` and `llm/v1/completion` style requests for all of the following providers:
* OpenAI
* Cohere
* Azure
* Anthropic
* Mistral
* Llama2

The request and response formats are based on OpenAI.
See the [sample OpenAPI specification](https://github.com/kong/kong/blob/master/spec/fixtures/ai-proxy/oas.yaml) for descriptions of the supported formats.

## How it works

Set up connections to an AI service using:
* The backend URL (unless it's a self-hosted model, in which case set [`config.model.options.upstream_url`](/hub/kong-inc/ai-proxy/#configmodel-options-upstream_url)).
* API key.

The plugin can then do the following:
* Request and response body transformation.
* Capturing and storing metrics from the upstream responses into normalised `kong.log` entries, which can then output via any configured logging platform (for example, [File Log](/hub/kong-inc/file-log/) or [Kafka Log](/hub/kong-inc/kafka-log/)).

Flattening all of the provider formats allows for standardised manipulation of the data before and after transmission.

This plugin only supports REST-based full text responses.

{:.note}
> Check out the [AI Gateway quickstart](/) to get an AI proxy up and running within minutes!

## Get started with the AI Proxy plugin

* [AI Gateway quickstart: Set up AI Proxy](/gateway/latest/get-started/ai-gateway/)
* [Configuration reference](/hub/kong-inc/ai-proxy/configuration/)
* [Basic configuration example](/hub/kong-inc/ai-proxy/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/ai-proxy/how-to/)

### Other AI plugins

The AI Proxy plugin enables using all of the following AI plugins:
* [AI Request Transformer](/hub/kong-inc/ai-request-transformer/)
* [AI Response Transformer](/hub/kong-inc/ai-request-transformer/)
* [AI Prompt Template](/hub/kong-inc/ai-prompt-template/)
* [AI Prompt Guard](/hub/kong-inc/ai-prompt-guard/)
* [AI Prompt Decorator](/hub/kong-inc/ai-prompt-decorator/)