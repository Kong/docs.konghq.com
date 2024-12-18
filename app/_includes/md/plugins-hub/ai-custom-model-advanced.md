
For all providers, the Kong AI Proxy Advanced plugin attaches to **route** entities.

### Custom model

You can configure the AI Proxy Advanced Plugin using a custom model of your choice by setting the `name` and `upstream_url` when configuring the model. 

<!--vale off-->
{% plugin_example %}
plugin: kong-inc/ai-proxy-advanced
name: ai-proxy-advanced
config:
  targets:
  - route_type: "llm/v1/chat"
    auth:
      header_name: "Authorization"
      header_value: "Bearer <openai_key>"
    model:
      name: custom_model_name
      provider: openai|azure|anthropic|cohere|mistral|llama2|gemini|bedrock|huggingface
      options:
        upstream_url: http://localhost:8000/vi/chat/completions
targets:
  - route
formats:
  - curl
  - konnect
  - yaml
  - kubernetes
  - terraform
{% endplugin_example %}
<!--vale on-->
