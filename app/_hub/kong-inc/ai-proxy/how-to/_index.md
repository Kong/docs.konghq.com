---
nav_title: Getting started with AI Proxy
title: Getting started with AI Proxy
---

## Using the plugin

You can follow the [basic examples](/hub/kong-inc/ai-proxy/how-to/basic-example/), enabling
Kong to proxy requests to your chosen AI/LLM service.

### Prerequisites

Placeholder

### Getting started with the AI Proxy plugin

Placeholder

1. Add a sample service if needed:

    ```sh
    curl http://localhost:8001/services \
      -d name=ai-proxy \
      -d url=http://localhost:65535
    ```

2. Add a sample route if needed:

    ```
    curl http://localhost:8001/routes \
      -d name=ai-proxy-openai-chat \
      -d paths[]=/openai/chat \
      -d service.name=ai-proxy
    ```

3. Enable the plugin:

    ```sh
    curl http://localhost:8001/plugins \
      -d name=ai-proxy \
      -d config.PLACEHOLDER
      PLACEHOLDER
    ```
### More Docs

Placeholder.
