---
nav_title: Overview
---

The AI Response Transformer plugin uses a configured LLM service to introspect and transform the upstream's HTTP(S) response before returning it back to the client.
It can also be configured to terminate or otherwise nullify the response, should it fail (for example) a compliance or formatting check from the configured LLM service.

This plugin supports `llm/v1/chat` style requests for all of the same providers as the [AI Proxy plugin](/hub/kong-inc/ai-proxy/).

It also uses all of the same configuration and tuning parameters as the AI Proxy plugin, under the `config.llm` block.

The AI Response Transformer plugin runs **after** the AI Proxy plugin, and **after** proxying to the upstream (backend) service, allowing it to also introspect LLM responses against the same, or a different, LLM service.

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

> _**Figure 1**: The diagram shows the journey of a client's request through {{site.base_gateway}} to the backend service, 
 where it is transformed by both an AI LLM service and Kong's AI Request Transformer and the AI Response Transformer plugins._

1. The {{site.base_gateway}} admin sets up an `llm:` configuration block, following the same 
[configuration format](/hub/kong-inc/ai-proxy/configuration/) as the AI Proxy plugin, 
and the same `driver` capabilities.
1. The {{site.base_gateway}} admin sets up a `"prompt"` for the request introspection. 
The prompt becomes the `"system"` message in the LLM chat request, and prepares the LLM with transformation
instructions for the returning upstream response body.
1. The user makes an HTTP(S) call.
1. *After* proxying the user's request to the backend, {{site.base_gateway}} sets the entire response body as the 
`"user"` message in the LLM chat request, then sends it to the configured LLM service.
1. The LLM service returns a response `"assistant"` message, which is subsequently set as the upstream response body.
1. The plugin returns early (`kong.response.exit`) and can handle gzip or chunked requests, similarly to the Forward Proxy plugin.

### Adjusting response headers, status codes, and body

You can additionally instruct the LLM to respond in the following format, which lets you adjust the response headers, response status code, and response body:

```json
{
  "headers":
    {
      "new-header": "new-value"
    },
  "status": 201,
  "body": "new response body"
}
```

{{site.base_gateway}} will parse these instructions and set all given response headers, set the response status code, 
and set replacement response body. 
This lets you change specific headers such as `Content-Type`, or throw errors from the LLM.

## Get started with the AI Response Transformer plugin

* [Configuration reference](/hub/kong-inc/ai-response-transformer/configuration/)
* [Basic configuration example](/hub/kong-inc/ai-response-transformer/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/ai-response-transformer/how-to/)

### Other AI plugins

You may also be interested in the following AI plugins:
* [AI Proxy](/hub/kong-inc/ai-proxy/)
* [AI Request Transformer](/hub/kong-inc/ai-request-transformer/)
* [AI Prompt Template](/hub/kong-inc/ai-prompt-template/)
* [AI Prompt Guard](/hub/kong-inc/ai-prompt-guard/)
* [AI Prompt Decorator](/hub/kong-inc/ai-prompt-decorator/)