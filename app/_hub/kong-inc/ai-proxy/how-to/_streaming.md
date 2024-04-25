---
nav_title: Streaming
title: Configure Streaming with AI Proxy
---

This guide walks you through setting up the AI Proxy plugin with streaming.

{% include_cached /md/plugins-hub/ai-providers-prereqs.md snippet='intro' %}

## How it works

Streaming is a mode where a client can specify `"stream": true` in their request and the LLM server will stream each piece of the response text (usually token-by-token) as a server-sent event.

Kong captures each batch of events and translates them back into the inference format, so that all providers are compatible with the same framework that you create on your side.

When streaming is disabled, requests proxy directly to the LLM look like this:

{% mermaid %}
sequenceDiagram
    actor Client
    participant Kong
    Note right of Kong: AI Proxy plugin
    Client->>+Kong: 
    Kong->>+Cloud LLM: Sets proxy request information
    Cloud LLM->>+Client: Sends chunk to client
{% endmermaid %}

When streaming is enabled, requests proxy directly to the LLM look like this:

{% mermaid %}
sequenceDiagram
    actor Client
    participant Kong
    Note right of Kong: AI Proxy plugin
    Client->>+Kong: 
    Kong->>+Cloud LLM: Sets proxy request information
    Cloud LLM->>+Kong:  
    Kong->>+Readframe: 
    Readframe->>+Transform frame: 
    Transform frame->>+Kong: 
    Kong->>+Client: ngx.EXIT
{% endmermaid %}

The new streaming framework captures each event, sends the chunk back to the client, and then exits early. 

It will also estimate tokens for LLM services that decided to not stream back the token use counts when the message completed.

## Streaming limitations

Keep the following limitations in mind when you configure streaming for the AI Proxy plugin: 

* Multiple AI features shouldn’t expect to be applied and work simultaneously
* You cannot use the [Response Transformer plugin](/hub/kong-inc/response-transformer/) when streaming is configured.

## Configuration

### Prerequisites

### Set up streaming

### Test the configuration

Make an `llm/v1/chat` type request to test your new endpoint:

