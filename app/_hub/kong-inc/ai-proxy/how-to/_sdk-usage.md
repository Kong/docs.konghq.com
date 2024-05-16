---
title: SDK Usage
nav_title: Using Programmatic SDKs with AI Proxy
---

You can use an OpenAI-compatible SDK with the AI Proxy plugin in multiple ways, depending on the required use case.

| You want to...                                                                         | Then use...                                        |
| -------------------------------------------------------------------------------------- | -------------------------------------------------- |
| Allow the user to select their target model, based on some header or request parameter | [Using OpenAI SDK with Multiple Models on the Same Provider](#using-openai-sdk-with-multiple-models-on-the-same-provider) |
| Proxy the same request to an LLM provider of the user's choosing | [Using OpenAI SDK with Multiple Providers](#using-openai-sdk-with-multiple-providers) |
| Use the OpenAI SDK for Azure, and allow the user to choose the Azure Deployment ID | [Multiple Azure OpenAI Deployments on One Route](#multiple-azureopenai-deployments-on-one-route) |
| Proxy an unsupported model, like Whisper-2. | [OpenAI-compatible SDK for unsupported models](#using-an-unsupported-model)               |


## Templated Model Parameters

The plugin enables you to substitute values in the `config.model.name` and/or any `config.model.options.*` field,
with specific placeholders, similar to those in the [Request Transformer Advanced](/hub/kong-inc/request-transformer-advanced/)
templating system.

The available templated parameters are:

* `$(headers.name)`
* `$(uri_captures.name)`
* `$(query_params.name)`

`name` is either the header name, URI named capture (in the route path), or the query parameter name, respectively.

## Use case examples
### Using OpenAI SDK with Multiple Models on the Same Provider

To read the desired model from the user, rather than hard coding it into the plugin config for each route,
you can read it from a path parameter, for example:

```yaml
- name: openai-chat
  paths:
  - "~/(?<model>[^#?/]+)/chat/completions$"
  methods:
  - POST
  plugins:
  - name: ai-proxy
    config:
      route_type: "llm/v1/chat"
      auth:
        header_name: "Authorization"
        header_value: "{vault://env/OPENAI_AUTH_HEADER}"
      logging:
        log_statistics: true
        log_payloads: false
      model:
        provider: "openai"
        name: "$(uri_captures.model)"
```

You can now target two different models using an OpenAI-compatible SDK:

```python
client = OpenAI(
  base_url="http://localhost:8000/gpt-4"
)
```

The Python SDK (in OpenAI standard mode) will fill in the URL with `http://localhost:8000/gpt-4/chat/completions`. {{site.base_gateway}} recognizes the model as "gpt-4" and the route appropriately.

### Using OpenAI SDK with Multiple Providers

To use the same OpenAI SDK but with multiple LLM providers, Kong AI Proxy can arbitrate this for you.

Set up two routes:

```yaml
- name: cohere-chat
  paths:
  - "~/cohere/(?<model>[^#?/]+)/chat/completions$"
  methods:
  - POST
  plugins:
  - name: ai-proxy
    config:
      route_type: "llm/v1/chat"
      auth:
        header_name: "Authorization"
        header_value: "{vault://env/COHERE_AUTH_HEADER}"
      logging:
        log_statistics: true
        log_payloads: false
      model:
        provider: "cohere"
        name: "$(uri_captures.model)"

- name: mistral-chat
  paths:
  - "~/mistral(?<model>[^#?/]+)/chat/completions$"
  methods:
  - POST
  plugins:
  - name: ai-proxy
    config:
      route_type: "llm/v1/chat"
      auth:
        header_name: "Authorization"
        header_value: "{vault://env/MISTRAL_AUTH_HEADER}"
      logging:
        log_statistics: true
        log_payloads: false
      model:
        provider: "mistral"
        name: "$(uri_captures.model)"
```

Now, the user can select their desired provider using the SDK:

```python
client = OpenAI(
  base_url="http://127.0.0.1:8000/cohere"
)
```

or

```python
client = OpenAI(
  base_url="http://127.0.0.1:8000/mistral"
)
```

### Multiple Azure OpenAI Deployments on One Route

With AI Proxy, you can create two routes to point to two different deployments of an
Azure OpenAI model:

```yaml
- name: azure-chat-gpt-3-5
  paths:
  - "~/openai/deployments/azure-gpt-3-5/chat/completions$"
  methods:
  - POST
  plugins:
  - name: ai-proxy
    config:
      route_type: "llm/v1/chat"
      auth:
        header_name: "api-key"
        header_value: "{vault://env/AZURE_AUTH_HEADER}"
      logging:
        log_statistics: true
        log_payloads: false
      model:
        provider: "azure"
        name: "gpt-35-turbo"
        options:
          azure_instance: "my-openai-instace"
          azure_deployment_id: "my-gpt-3-5"

- name: azure-chat-gpt-4
  paths:
  - "~/openai/deployments/azure-gpt-4/chat/completions$"
  methods:
  - POST
  plugins:
  - name: ai-proxy
    config:
      route_type: "llm/v1/chat"
      auth:
        header_name: "api-key"
        header_value: "{vault://env/AZURE_AUTH_HEADER}"
      logging:
        log_statistics: true
        log_payloads: false
      model:
        provider: "azure"
        name: "gpt-4"
        options:
          azure_instance: "my-openai-instace"
          azure_deployment_id: "my-gpt-4"
```

But if you are required to only use one route to proxy multiple models deployed in the same instance, you can use request parameters:

```yaml
- name: azure-chat
  paths:
  - "~/openai/deployments/(?<azure_instance>[^#?/]+)/chat/completions"
  methods:
  - POST
  plugins:
  - name: ai-proxy
    config:
      route_type: "llm/v1/chat"
      auth:
        header_name: "api-key"
        header_value: "{vault://env/AZURE_AUTH_HEADER}"
      logging:
        log_statistics: true
        log_payloads: false
      model:
        provider: "azure"
        name: "$(uri_captures.azure_instance)"
        options:
          azure_instance: "my-openai-instace"
          azure_deployment_id: "$(uri_captures.azure_instance)"
```

Now the user can set the SDK endpoint to `http://localhost:8000/azure`. When the Azure instance parameter is
set to `"my-gpt-3-5"`, the Python SDK produces the URL (`http://localhost:8000/openai/deployments/my-gpt-3-5/chat/completions`) and
is directed to the respective Azure deployment ID and model.

### Use an unsupported model

{{site.base_gateway}} can perform a **best-effort** to support models that are not programmed with to/from format transformers or are untested.
These will be unsupported use-cases, but may work depending on your setup.

For these, you must use the `preserve` "route_type" mode.

For example, you could use the Whisper-2 audio transcription model with a route:

```yaml
- name: openai-any
  paths:
  - "~/openai/(?<op_path>[^#?]+)"
  methods:
  - POST
  plugins:
  - name: ai-proxy
    config:
      route_type: "preserve"
      auth:
        header_name: "Authorization"
        header_value: "{vault://env/OPENAI_AUTH_HEADER}"
      logging:
        log_statistics: true
        log_payloads: false
      model:
        name: "whisper-2"
        provider: "openai"
        options:
          upstream_path: "$(uri_captures.op_path)"
```

Now you can `POST` a file (multi-part form) for transcription:

```sh
curl --location 'http://localhost:8000/openai/v1/audio/transcriptions' \
     --form 'model=whisper-2' \
     --form 'file=@"me_saying_hello.m4a"'
```

The response comes back unaltered:

```json
{
  "text": "Hello!"
}
```
