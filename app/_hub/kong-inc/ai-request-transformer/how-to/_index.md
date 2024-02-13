---
nav_title: Using the AI Request Transformer Plugin
title: Using the AI Request Transformer Plugin
---

## Overview

The AI Request Transformer plugin is designed to operate in two ways:

* As a transformer / security arbiter for your existing upstream APIs
* As an extension of another "AI Proxy" LLM route, inspecting and transforming the requests before sending to the upstream LLM service

The plugin configuration consists of two distinct sections:

* The LLM configuration, that uses the same [configuration options](/hub/kong-inc/ai-proxy/configuration/) as the AI Proxy plugin.
* The prompt (and additional options) containing the **instructions** for the LLM, which will transform your request.

See the same LLM block in the context of the `AI Proxy` plugin, and the `AI Request Transformer` plugin:

{% navtabs %}

{% navtab AI Proxy %}

```yaml
config:
  route_type: "llm/v1/chat"
  auth:
    header_name: "Authorization"
    header_value: "Bearer <openai_key>"  # add your own OpenAI API key
  model:
    provider: "openai"
    name: "gpt-4"
```

{% endnavtab %}

{% navtab AI Request Transformer %}

```yaml
llm:
  config:
    route_type: "llm/v1/chat"
    auth:
      header_name: "Authorization"
      header_value: "Bearer <openai_key>"  # add your own OpenAI API key
    model:
      provider: "openai"
      name: "gpt-4"

prompt: "Transform my message to XML - return me ONLY the XML output."
```

{% endnavtab %}

{% endnavtabs %}

When the plugin is accessed in any scope (global / service / route / consumer), it will **always** set the caller's request
body as the "user" prompt in a chat message, and then send it to the configured `llm:` configuration block.

## Examples

### Transforming Existing API Traffic

In this example, we'll use `ai-request-transformer` on an *existing* API, e.g. something that you have developed and maintain internally.

#### 1. Design the prompt

We want to intercept requests to our "customers" API - on each request, first forward it to our configured large language model, and ask
it to add the country name field to anywhere in the JSON where there is a city, and no associated country.

The plugin would be configured like so:

```yaml
config:
  prompt: >
    In my JSON message, anywhere there is a JSON tag for a "city" also add a "country" tag with the name of the country in which the city
    resides. Return me only the JSON message, no extra text.
  llm:
    # see `ai-proxy` plugin documentation for compatible fields for the "llm" block
```

and that should be all that's required.

#### 2. Attach the Plugin

Attach the `ai-request-transformer` plugin to the global level, route, service, or consumer on which you want to inspect/transform all requests.

#### 3. What Happens?

Firstly, a Kong client makes a request, for example:

```json
{
  "user": {
    "name": "Kong User",
    "city": "London"
  }
}
```

Next, Kong parses this into an `llm/v1/chat` type message, based on your `config.prompt`:

```json
{
  "messages": [
    {
      "role": "system",
      "content": "In my JSON message, anywhere there is a JSON tag for a \"city\" also add a \"country\" tag with the name of the country in which the city resides. Return me only the JSON message, no extra text."
    },
    {
      "role": "user",
      "content": "{\n\"user\":{\n\"name\":\"Kong User\",\n\"city\":\"London\"\n}\n}"
    }
  ]
}
```

Finally, it sends this to the configured LLM. On the response, it takes the trailing "assistant" response back from the LLM, and
**sets it as the outgoing HTTP body**:

```json
{
  "user": {
    "name": "Kong User",
    "city": "London",
    "country": "United Kingdom"
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
    In my JSON message, anywhere there is a JSON tag for a "city" also add a "country" tag with the name of the country in which the city
    resides. Return me only the JSON message, no extra text.
  transformation_extract_pattern: '\\{((.|\n)*)\\}'
```
