---
nav_title: Overview
---

The AI Request Transformer plugin uses a configured LLM service to introspect and transform the client's request body before proxying the request upstream.

This plugin supports `llm/v1/chat` and `llm/v1/completion` style requests for all of the following providers:
* OpenAI
* Cohere
* Azure
* Anthropic
* Mistral
* Llama2

The request and response formats are based on OpenAI.
This plugin follows the same schema format as the [AI Proxy plugin](/hub/kong-inc/ai-proxy/).
See the [sample OpenAPI specification for AI Proxy](https://github.com/kong/kong/blob/master/spec/fixtures/ai-proxy/oas.yaml) for descriptions of the supported formats.

The AI Request Transformer plugin runs **after** all of the [AI Prompt](/hub/?search=ai%2520prompt) plugins, allowing it to also introspect LLM requests against a different LLM.

## How it works

<!--vale off-->
{% mermaid %}
sequenceDiagram
    autonumber
    participant client as Client
    participant kong as Kong Gateway
    participant ai as AI LLM service
    participant backend as Backend service
    activate client
    activate kong
    client->>kong: Sends a request
    deactivate client
    activate ai
    kong->>ai: Sends client's request for transformation
    ai->>kong: Transforms request
    deactivate ai
    activate backend
    kong->>backend: Sends transformed request to backend
    backend->>kong: Returns response to Kong Gateway
    deactivate backend
    activate ai
    kong->>ai: Sends response to AI service
    ai->>kong: Transforms response
    deactivate ai
    activate client
    kong->>client: Returns transformed response to client
    deactivate kong
    deactivate client
{% endmermaid %}
<!--vale on-->

> _**Figure 1**: The diagram shows the journey of a consumer's request through {{site.base_gateway}} to the 
backend service, where it is transformed by both an AI LLM service and Kong's AI Request Transformer and the AI Response Transformer plugins._

1. The {{site.base_gateway}} admin sets up an `llm:` configuration block, following the same 
[schema format](https://github.com/kong/kong/blob/master/spec/fixtures/ai-proxy/oas.yaml) as the AI Proxy plugin, 
and the same `driver` capabilities.
1. The {{site.base_gateway}} admin sets up a `"prompt"` for the request introspection. 
The prompt becomes the `"system"` message in the LLM chat request.
1. The user makes an HTTP(S) call.
1. Before proxying the user's request to the backend, {{site.base_gateway}} sets the entire request body as the 
`"user"` message in the LLM chat request, and then sends it to the configured LLM service.
1. The LLM service returns a response `"assistant"` message, which is subsequently set as the upstream request body.

## Get started with the AI Request Transformer plugin

* [Configuration reference](/hub/kong-inc/ai-request-transformer/configuration/)
* [Basic configuration example](/hub/kong-inc/ai-request-transformer/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/ai-request-transformer/how-to/)

### Other AI plugins

You may also be interested in the following AI plugins:
* [AI Proxy](/hub/kong-inc/ai-proxy/)
* [AI Response Transformer](/hub/kong-inc/ai-request-transformer/)
* [AI Prompt Template](/hub/kong-inc/ai-prompt-template/)
* [AI Prompt Guard](/hub/kong-inc/ai-prompt-guard/)
* [AI Prompt Decorator](/hub/kong-inc/ai-prompt-decorator/)