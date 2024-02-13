---
nav_title: Using the AI Response Transformer Plugin
title: Using the AI Response Transformer Plugin
---

## Overview

The AI Response Transformer plugin is designed to operate in two ways:

* As a transformer / security arbiter for your existing upstream APIs
* As an extension of another "AI Proxy" LLM route, inspecting and transforming the responses before sending to the upstream LLM service

The plugin configuration consists of two distinct sections:

* The LLM configuration, that uses the same [configuration options](/hub/kong-inc/ai-proxy/configuration/) as the AI Proxy plugin.
* The prompt (and additional options) containing the **instructions** for the LLM, which will transform your request.

See the same LLM block in the context of the `AI Proxy` plugin, and the `AI Response Transformer` plugin:

{% navtabs %}

{% navtab AI Proxy %}

```yaml
config:
  route_type: "llm/v1/chat"
  auth:
    header_name: "Authorization"
    header_value: "Bearer <azure_key>"  # add your own Azure API key
  model:
      provider: "azure"
      name: "gpt-3.5"
      azure_instance: "azure-openai-service"
      azure_deployment_id: "gpt-3-5-deployment"
```

{% endnavtab %}

{% navtab AI Response Transformer %}

```yaml
llm:
  config:
    route_type: "llm/v1/chat"
    auth:
      header_name: "Authorization"
      header_value: "Bearer <azure_key>"  # add your own Azure API key
    model:
      provider: "azure"
      name: "gpt-3.5"
      azure_instance: "azure-openai-service"
      azure_deployment_id: "gpt-3-5-deployment"

prompt: "Mask all credit card numbers in my JSON message with '*'. Return me ONLY the resulting JSON."
```

{% endnavtab %}

{% endnavtabs %}

When the plugin is accessed in any scope (global / service / route / consumer), it will **always** set the upstream's response
body as the "user" prompt in a chat message, and then send it to the configured `llm:` configuration block for inspection / transformation.

## Examples

### Transforming Existing API Traffic

In this example, we'll use `ai-response-transformer` on an *existing* API, e.g. something that you have developed and maintain internally.

#### 1. Design the prompt

We want to intercept *responses from* our "customers" API - on each client response, forward it to our configured large language model, and ask
it to mask all credit card numbers with asterisk characters.

The plugin would be configured like so:

```yaml
config:
  prompt: >
    Mask all credit card numbers in my JSON message with '*'. Return me ONLY the resulting JSON.
  llm:
    # see `ai-proxy` plugin documentation for compatible fields for the "llm" block
```

and that should be all that's required.

#### 2. Attach the Plugin

Attach the `ai-response-transformer` plugin to the global level, route, service, or consumer on which you want to inspect/transform all responses.

It can even be used on APIs that already have the `ai-request-transformer` plugin, or it can be used on its own.

#### 3. What Happens?

Firstly, an upstream API responds to a client request, for example:

```json
{
  "user": {
    "name": "Kong User",
    "city": "London",
    "credit_card_no": "1234-5678-9012-3456"
  }
}
```

Next, Kong parses this into an `llm/v1/chat` type message, based on your `config.prompt`:

```json
{
  "messages": [
    {
      "role": "system",
      "content": "Mask all credit card numbers in my JSON message with '*'. Return me ONLY the resulting JSON."
    },
    {
      "role": "user",
      "content": "{\n\"user\":{\n\"name\":\"Kong User\",\n\"city\":\"London\"\n\"credit_card_no\":\"1234-5678-9012-3456\"}\n}"
    }
  ]
}
```

Finally, it sends this to the configured LLM. On the response, it takes the trailing "assistant" response back from the LLM, and
**sets it as the HTTP body that will return to the original client**:

```json
{
  "user": {
    "name": "Kong User",
    "city": "London",
    "credit_card_no": "****-****-****-****"
  }
}
```

#### 4. Extraction Patterns

In the case that your LLM is a chat-bot type, or is unpredictable in responses, you can configure the additional field `transformation_extract_pattern`
with a (PCRE) regular expression to extract the first match from the LLM's response.

For example, if you have asked for a JSON response but you know that your LLM may add its own text around your answer, use this extraction pattern to
withdraw **only** the JSON object from the LLm's response:

```yaml
config:
  prompt: >
    Mask all credit card numbers in my JSON message with '*'. Return me ONLY the resulting JSON.
  transformation_extract_pattern: '\\{((.|\n)*)\\}'
```

### Setting Body, Headers, and Status Code

The `ai-response-transformer` has the additional feature that it can be used to modify:

* headers
* status code
* body

all independently.

This allows the Kong admin to configure the LLM to fully orchestrate the response phase inside the Kong Gateway.

This feature is enabled by setting the config option `parse_llm_response_json_instructions`.

#### 1. Design the prompt

We want to intercept *responses from* our "customers" API - on each client response, forward it to our configured large language model, and ask
it to mask all credit card numbers with asterisk characters.

The plugin would be configured like so:

```yaml
config:
  prompt: >
    If my JSON message has the user's name 'Kong User', then return me this exact JSON message: 
    {"status": 400, "headers": {"x-failed": "true"}, "body": "VALIDATION_FAILURE"}
  parse_llm_response_json_instructions: true
  llm:
    # see `ai-proxy` plugin documentation for compatible fields for the "llm" block
```

and that should be all that's required.

#### 2. Attach the Plugin

Attach the `ai-response-transformer` plugin to the global level, route, service, or consumer on which you want to inspect/transform all responses.

It can even be used on APIs that already have the `ai-request-transformer` plugin, or it can be used on its own.

#### 3. What Happens?

Firstly, an upstream API responds to a client request, for example:

```json
{
  "user": {
    "name": "Kong User",
    "city": "London",
    "credit_card_no": "1234-5678-9012-3456"
  }
}
```

Once sent to the LLM, the response will be:

```json
{
  "status": 400,
  "headers": {
    "x-failed": "true"
  },
  "body": "VALIDATION_FAILURE"
}
```

Kong will do the following actions:

* Set each response header from the `headers` object
* Set the HTTP status code to the `status` integer
* Set the body to be the `body` string
