---
title: SDK Usage
nav_title: Using Programmatic SDKs with AI Proxy
---

AI Proxy currently allows you to use an OpenAI-compatible SDK in multiple ways, depending on the required use-case.

## Templated Model Parameters

The plugin enables you to substitute values in the `config.model.name` and/or any `config.model.options.*` field,
with specific placeholders, similar to those in the [Request Transformer Advanced](/hub/kong-inc/request-transformer-advanced/)
templating system.

The available templated parameters are:

* `$(headers.name)`
* `$(uri_captures.name)`
* `$(query_params.name)`

where name is either the header name, URI named capture (in the route path), or the query parameter name, respectively.

## Example: Using OpenAI SDK with Multiple Models on the Same Provider

To read the desired model from the user, rather than hard-coding into the plugin config for each route,
you can e.g. read it from a path parameter, as with this example:

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

you can now target two different models using e.g. the Python SDK:

```python
client = OpenAI(
  base_url="http://localhost:8000/gpt-4"
)
```

The Python SDK (in OpenAI standard mode) will fill in the URL to: `http://localhost:8000/gpt-4/chat/completions` and thus
Kong will recognise the model as "gpt-4" and route appropriately.

## Example: Using OpenAI SDK with Multiple Providers

To use the same OpenAI SDK but with multiple LLM providers, Kong AI Proxy can arbitrate this for you.

Simply set up two routes like so:

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

now the user can select their desired provider using the SDK:

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

## Example: Multiple Azure OpenAI Deployments on One Route

With AI Proxy, it is easy to create two routes to point to two different deployments of an
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

But what if the requirement is to use one route to proxy multiple models deployed in the same instance?

We can use request parameters to do this, like this example:

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

Now the user can set the SDK endpoint to simply `http://localhost:8000/azure` and, when the "Azure Instance" parameter is
set to `"my-gpt-3-5"`, the Python SDK will produce the URL: `http://localhost:8000/openai/deployments/my-gpt-3-5/chat/completions` and
thus will be directed to the respective Azure Deployment ID and Model.

## Example: Using an 'Unsupported' Model (e.g. Whisper-2)

Kong can perform a **best-effort** to support models that are not programmed with to/from format transformers, or are untested.
These will be unsupported use-cases, but may work depending on your setup.

For these, you must use the `preserve` "route_type" mode.

For example, the Whisper-2 audio transcription model is tested, and is set up with a route like this:

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

Now you can POST a file (multipart form) for transcription:

```sh
curl --location 'http://localhost:8000/openai/v1/audio/transcriptions' \
     --form 'model=whisper-2' \
     --form 'file=@"me_saying_hello.m4a"'
```

and the response comes back un-altered:

```json
{
  "text": "Hello!"
}
```
