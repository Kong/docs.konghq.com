---
nav_title: Streaming
title: Configure Streaming with AI Proxy
---

This guide walks you through setting up the AI Proxy plugin with streaming.

Streaming is a mode where a client can specify "stream": true in their request, and the LLM server will stream each piece piece of the response text (usually token-by-token) as a server-sent event.

We need to capture each (batch of) event(s) in order to translate them back into our inference format, so that all providers are compatible with the same framework that our users will create on their side.

Where "streaming=false" requests proxy directly to the LLM, and look like this:

{% mermaid %}

{% endmermaid %}

{% include_cached /md/plugins-hub/ai-providers-prereqs.md snippet='intro' %}

## Prerequisites