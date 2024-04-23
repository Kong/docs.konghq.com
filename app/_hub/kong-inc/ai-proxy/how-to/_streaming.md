---
nav_title: Streaming
title: Configure Streaming with AI Proxy
---

This guide walks you through setting up the AI Proxy plugin with streaming.

{% include_cached /md/plugins-hub/ai-providers-prereqs.md snippet='intro' %}

## How it works

Streaming is a mode where a client can specify "stream": true in their request, and the LLM server will stream each piece piece of the response text (usually token-by-token) as a server-sent event.

We need to capture each (batch of) event(s) in order to translate them back into our inference format, so that all providers are compatible with the same framework that our users will create on their side.

Where "streaming=false" requests proxy directly to the LLM, and look like this:

{% mermaid %}

{% endmermaid %}

the new streaming framework captures each event, and sends the chunk back to the client, like this:

{% mermaid %}

{% endmermaid %}

and then it exits early. 

It will also count/estimate tokens for LLM services that have decided to not stream back the token utilisation counts when the message has completed...

## Limitations

* multiple AI features shouldn’t expect to be applied and work simultaneously
* no response transformer

## Configuration

### Prerequisites

### Set up streaming

### Test the configuration