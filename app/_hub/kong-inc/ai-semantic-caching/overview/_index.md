---
nav_title: Overview
---

The Semantic Caching plugin enhances AI responses by offering two types of caching: exact and semantic. 
When a cache response is returned as semantic, additional information such as the embeddings provider, 
embeddings model, and embeddings latency are included.

# Introduction

The Semantic Caching plugin extends AI capabilities by caching responses based on semantic similarity, 
allowing for more intelligent and context-aware response retrieval. This plugin is especially useful 
for applications where similar queries can yield the same or similar responses, enhancing performance 
and reducing load on AI service providers.

**Example**
Consider an AI-driven customer support system where users frequently ask similar questions. By using 
the Semantic Caching plugin, you can cache the responses to common questions semantically. When a new
query is similar to a previous one, the cached response is returned, reducing the need to generate a 
new response from the AI model, thus saving computational resources and improving response times.

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


## Get started with the AI Semantic Caching plugin

* [Configuration reference](/hub/kong-inc/ai-semantic-caching/configuration/)
* [Basic configuration example](/hub/kong-inc/ai-semantic-caching/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/ai-semantic-caching/how-to/)

### All AI Gateway plugins

{% include_cached /md/ai-plugins-links.md release=page.release %}
