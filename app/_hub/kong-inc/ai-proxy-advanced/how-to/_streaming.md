---
nav_title: Streaming
title: Configure Streaming with AI Proxy Advanced
minimum_version: 3.7.x
---

This guide walks you through setting up the AI Proxy Advanced plugin with streaming.

## What is request streaming

In an LLM (Large Language Model) inference request, {{site.base_gateway}} uses the upstream provider's REST API to generate the next chat message from the caller. 
Normally, this request is processed and completely buffered by the LLM before being sent back to {{site.base_gateway}} and then to the caller in a single large JSON block. This process can be time-consuming, depending on the `max_tokens`, other request parameters, and the complexity of the request sent to the LLM model.

To avoid making the user wait for their chat response with a loading animation, most models can stream each word (or sets of words and tokens) back to the client. This allows the chat response to be rendered in real time.
	
For example, a client could set up their streaming request using the OpenAI Python SDK like this:

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://127.0.0.1:8000/12/openai",
    api_key="none"
)

stream = client.chat.completions.create(
    model="gpt-4",
    messages=[{"role": "user", "content": "Tell me the history of Kong Inc."}],
    stream=True,
)

print('>')
for chunk in stream:
    print(chunk.choices[0].delta.content or "", end="", flush=True)
```

The client won't have to wait for the entire response. Instead, tokens will appear as they come in, for example:

```sh
$ python3 long-streaming-request.py
> Kong Inc. is a software company providing cloud-native connectivity solutions for APIs and....
```

## How AI Proxy streaming works

In streaming mode, a client can set `"stream": true` in their request, and the LLM server will stream each part of the response text (usually token-by-token) as a server-sent event.
{{site.base_gateway}} captures each batch of events and translates them into the {{site.base_gateway}} inference format. This ensures that all providers are compatible with the same framework including [OpenAI-compatible SDKs](/hub/kong-inc/ai-proxy-advanced/how-to/sdk-usage/) or similar.

In a standard LLM transaction, requests proxied directly to the LLM look like this:

{% mermaid %}
sequenceDiagram    
  actor Client
  participant {{site.base_gateway}}
  Note right of {{site.base_gateway}}: AI Proxy Advanced plugin
  Client->>+{{site.base_gateway}}: 
  destroy {{site.base_gateway}}
  {{site.base_gateway}}->>+Cloud LLM: Sends proxy request information
  Cloud LLM->>+Client: Sends chunk to client
{% endmermaid %}

When streaming is requested, requests proxied directly to the LLM look like this:

{% mermaid %}
flowchart LR
  A(client)
  B({{site.base_gateway}} Gateway with 
  AI Proxy Advanced plugin)
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

It also estimates tokens for LLM services that decided to not stream back the token use counts when the message is completed.

## Streaming limitations

Keep the following limitations in mind when you configure streaming for the AI Proxy Advanced plugin: 

* Multiple AI features shouldn’t expect to be applied and work simultaneously
* You can't use the [Response Transformer plugin](/hub/kong-inc/response-transformer/) or any other response phase plugin when streaming is configured.
* The [AI Request Transformer plugin](/hub/kong-inc/ai-request-transformer/) plugin **will** work, but the [AI Response Transformer plugin](/hub/kong-inc/ai-response-transformer/) **will not**. This is because {{site.base_gateway}} can't check every single response token against a separate system.
* Streaming currently doesn't work with the HTTP/2 protocol. You must disable this in your [`proxy_listen`](/gateway/latest/reference/configuration/#proxy_listen) configuration.

## Configuration

The AI Proxy Advanced plugin already supports request streaming, all you have to do is request {{site.base_gateway}} to stream the response tokens back to you.

The following is an example `llm/v1/completions` route-type streaming request:

```json
{
  "prompt": "What is the theory of relativity?",
  "stream": true
}
```

You should receive each batch of tokens as HTTP chunks, each containing one or many server-sent events.

### Response streaming configuration parameters

In the AI Proxy Advanced plugin configuration, you can set an optional field `config.response_streaming` to one of three values:

| Value  | Effect                                                                                    |
|--------|------------------------------------------------------------------------------------------------------|
| `allow`  | Allows the caller to optionally specify a streaming response in their request (default is not-stream) |
| `deny`   | Prevents the caller from setting `stream=true` in their request                                           |
| `always` | Always returns streaming responses, even if the caller hasn't specified it in their request       |
