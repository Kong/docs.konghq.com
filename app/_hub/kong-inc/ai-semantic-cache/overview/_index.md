---
nav_title: Overview
---

## What is semantic caching?

Semantic caching enhances data retrieval efficiency by focusing on the meaning or context of queries rather than just exact matches. It stores responses based on the underlying intent and semantic similarities between different queries and can then retrieve those cached queries when a similar request is made. For example, if a user asks, "how to integrate our API with a mobile app" and later asks "what are the steps for connecting our API to a smartphone application?", the LLM recognizes that both queries are seeking similar information about the steps to integrate an API with an app. It can then retrieve and reuse previously cached responses if they are contextually relevant, even if they are phrased differently. By leveraging semantic caching, the LLM can reduce redudant processing and speeds up the response times.

When a new request is made, the system can retrieve and reuse previously cached responses if they are contextually relevant, even if the phrasing differs. This method reduces redundant processing, speeds up response times, and ensures that answers are more relevant to the user’s intent, ultimately improving overall system performance and user experience. 

By using the AI Semantic Cache plugin, the plugin can handle the caching for you. You can also configure the plugin to ?

## Why should I use the AI Semantic Cache plugin?

<!--use case table?-->

## How it works

{% mermaid %}
sequenceDiagram
    actor User
    participant Kong Gateway
    participant CachePlugin as AI Semantic Cache plugin
    participant LLM

    User->>KongGateway: Make API request
    KongGateway->>CachePlugin: Check cache
    alt Cached Response Available
        CachePlugin-->>KongGateway: Return cached response
        KongGateway-->>User: Return cached response
    else No Cached Response
        CachePlugin->>LLM: Forward request
        LLM-->>CachePlugin: Generate and return response
        CachePlugin-->>CachePlugin: Store response in cache
        CachePlugin-->>KongGateway: Return response
        KongGateway-->>User: Return response
    end
{% endmermaid %}

> Figure 1: This diagram shows how 

<!--detailed explanation of the tech-->

### Caching mechanisms

The AI Semantic Cache plugin improves how AI systems provide responses by using two kinds of caching mechanisms:

* **Exact Caching:** This stores precise, unaltered responses for specific queries. If a user asks the same question multiple times, the system can quickly retrieve the pre-stored response rather than generating it again each time. This speeds up response times and reduces computational load.
* **Semantic Caching:** This approach is more flexible and involves storing responses based on the meaning or intent behind the queries. Instead of relying on exact matches, the system can understand and reuse information that is conceptually similar. For instance, if a user asks about "Italian restaurants in New York City" and later about "New York City Italian cuisine," semantic caching can help provide relevant information based on their related meanings.

Together, these caching methods enhance the efficiency and relevance of AI responses, making interactions faster and more contextually accurate.




<!-- content to use
## Configuration

To use the Semantic Caching plugin, configure the following parameters:
* vectordb: Specifies the vector database strategy and settings.
* embeddings: Defines the embeddings provider, model, and configuration.
* cache_control: Enables or disables Cache-Control header handling.
* storage_ttl: Sets the time-to-live for cached responses.
* exact_caching: Enables or disables exact caching.
* message_countback: Specifies how many messages to consider for context.
* ignore_system_prompts: Ignores system messages if set to true.
* ignore_assistant_prompts: Ignores assistant messages if set to true.
* stop_on_failure: Stops processing if an error occurs, otherwise continues.

## Headers sent to the client

When the Semantic Caching plugin is active, Kong sends additional headers 
indicating the cache status and other relevant information:

```plaintext
X-Cache-Status: Hit
X-Cache-Status: Miss
X-Cache-Status: Bypass
X-Cache-Status: Refresh
X-Cache-Key: <cache_key>
X-Cache-Ttl: <ttl>
Age: <age>
```

These headers help clients understand whether a response was served from the cache,
the cache key used, the remaining time-to-live, and the age of the cached response.

### Cache Control

The plugin respects Cache-Control headers to determine the cacheability of requests 
and responses. It supports the following directives:

* no-store: Prevents caching of the request or response.
* no-cache: Forces validation with the origin server before serving the cached response.
* private: Ensures the response is not cached by shared caches.
* max-age and s-maxage: Sets the maximum age of the cached response.
-->

## Get started with the AI Semantic Caching plugin

* [Configuration reference](/hub/kong-inc/ai-semantic-caching/configuration/)
* [Basic configuration example](/hub/kong-inc/ai-semantic-caching/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/ai-semantic-caching/how-to/)

### All AI Gateway plugins

{% include_cached /md/ai-plugins-links.md release=page.release %}
