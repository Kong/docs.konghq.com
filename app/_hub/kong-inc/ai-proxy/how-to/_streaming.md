---
nav_title: Streaming
title: Configure Streaming with AI Proxy
---

This guide walks you through setting up the AI Proxy plugin with streaming.

{% include_cached /md/plugins-hub/ai-providers-prereqs.md snippet='intro' %}

## How it works

Streaming is a mode where a client can specify `"stream": true` in their request and the LLM server will stream each piece of the response text (usually token-by-token) as a server-sent event.

Kong captures each batch of events and translates them back into the Kong inference format, so that all providers are compatible with the same framework that you create on your side (including OpenAI-compatible SDKs or similar).

In a standard LLM transaction, requests proxy directly to the LLM look like this:

{% mermaid %}
flowchart LR
  A(client)
  B(Kong Gateway with 
  AI Proxy plugin)
  C(Cloud LLM)

  A --> B
  B --sends request 
  information--> C
  C --> A
{% endmermaid %}

When streaming is requested, requests proxy directly to the LLM look like this:

{% mermaid %}
flowchart LR
  A(client)
  B(Kong Gateway with 
  AI Proxy plugin)
  C(Cloud LLM)
  D[[transform frame]]
  E[[read frame]]

subgraph main
direction LR
  subgraph 1
  A
  end
  subgraph 3
  C
  end
  subgraph 2
  D
  E
  end
  A --> B --request--> C
  C --response--> B
  B --> D-->E
  E --> B
  B --> A
end

  linkStyle 2,3,4,5,6 stroke:#b6d7a8,color:#b6d7a8
  style 1 color:#fff,stroke:#fff
  style 2 color:#fff,stroke:#fff
  style 3 color:#fff,stroke:#fff
  style main color:#fff,stroke:#fff
{% endmermaid %}

The new streaming framework captures each event, sends the chunk back to the client, and then exits early. 

It will also estimate tokens for LLM services that decided to not stream back the token use counts when the message completed.

## Streaming limitations

Keep the following limitations in mind when you configure streaming for the AI Proxy plugin: 

* Multiple AI features shouldn’t expect to be applied and work simultaneously
* You cannot use the [Response Transformer plugin](/hub/kong-inc/response-transformer/) plugin or any other "response" phase plugin when streaming is configured
* The [AI Request Transformer plugin](/hub/kong-inc/ai-request-transformer/) plugin **will** work, but the [AI Response Transformer plugin](/hub/kong-inc/ai-response-transformer/) **will not**. This is a limitation of the fact that Kong cannot check every single response token against a separate system.
* Streaming currently does not work with the HTTP/2 protocol - you must disable this in your `proxy_listen` configuration.

## Configuration

The `ai-proxy` plugin already supports request streaming - simply ask the Kong gateway to stream the response tokens back to you!

An example `llm/v1/completions` route-type streaming request:

```json
{
  "prompt": "What is the theory of relativity?",
  "stream": true
}
```

and you should receive each batch of tokens as HTTP chunks, each containing one-or-many Server-Sent Events.

### Disable Response Streaming

In AI Proxy, there is an optional configuration field `config.response_streaming`, which can be set to one of three values:

| Value  | Effect                                                                                                |
|--------|-------------------------------------------------------------------------------------------------------|
| allow  | Allows the caller to optionally specify a streaming response in their request (default is not-stream) |
| deny   | Blocks the caller from setting stream=true in their request                                           |
| always | Will always return streaming responses, even if the caller hasn't specified it in their request       |
