---
nav_title: Overview
---

## What is semantic caching?

Semantic caching enhances data retrieval efficiency by focusing on the meaning or context of queries rather than just exact matches. It stores responses based on the underlying intent and semantic similarities between different queries and can then retrieve those cached queries when a similar request is made. For example, if a user asks, "how to integrate our API with a mobile app" and later asks "what are the steps for connecting our API to a smartphone application?", the LLM recognizes that both queries are seeking similar information about the steps to integrate an API with an app. It can then retrieve and reuse previously cached responses if they are contextually relevant, even if they are phrased differently. By leveraging semantic caching, the LLM can reduce redundant processing and speeds up the response times.

When a new request is made, the system can retrieve and reuse previously cached responses if they are contextually relevant, even if the phrasing differs. This method reduces redundant processing, speeds up response times, and ensures that answers are more relevant to the user’s intent, ultimately improving overall system performance and user experience. 

By using the AI Semantic Cache plugin, the plugin can handle the caching for you. You can also configure the vector database, caching mechanism, as well as embeddings.

The AI Semantic Cache plugin might not be the best fit for you if following apply to you:
* Storing semantic vectors or embeddings and performing similarity searches can require significant storage and computational resources. If you have limited hardware or budget constraints, this might be a concern.
* If your application data isn't inherently semantic or exact matches are sufficient, the benefits of semantic caching might be minimal. Simple keyword-based or traditional caching might be more appropriate and efficient.

## How it works

{% mermaid %}
sequenceDiagram
    actor User
    participant {{site.base_gateway}}/AI Semantic Cache plugin
    participant Vector database
    participant Embeddings LLM
    participant Prompt/Chat LLM

    User->>{{site.base_gateway}}/AI Semantic Cache plugin: LLM chat request
    {{site.base_gateway}}/AI Semantic Cache plugin->>Embeddings LLM: Generate embeddings for `config.message_countback` messages
    Embeddings LLM-->>{{site.base_gateway}}/AI Semantic Cache plugin: Return embeddings
    {{site.base_gateway}}/AI Semantic Cache plugin->>Vector database: Query for semantically similar previous requests
    Vector database-->>User: If response, return it or stream it back
    alt If not cached response
        {{site.base_gateway}}/AI Semantic Cache plugin->>Prompt/Chat LLM: Make LLM request
        Prompt/Chat LLM-->>{{site.base_gateway}}/AI Semantic Cache plugin: Receive response
        {{site.base_gateway}}/AI Semantic Cache plugin->>Vector database: Store vectors
        {{site.base_gateway}}/AI Semantic Cache plugin->>Vector database: Store response message options
        {{site.base_gateway}}/AI Semantic Cache plugin-->>User: Return realtime response
    end
{% endmermaid %}

> Figure 1: This diagram shows how the AI Semantic Cache plugin uses cached responses to respond to semantically similar requests from users.

The AI Semantic Cache plugin uses a vector database and cache to store responses to requests. The plugin can then retrieve a cached response if a new request matches the semantics of a previous request, or it can tell the vector database to store a new response if there are no matches. 

<!--vale off-->
{% mermaid %}
graph LR
    %% Define the color for subgraphs
    style UserInteraction fill:#f9f,stroke:#333,stroke-width:2px
    style APIGateway fill:#ccf,stroke:#333,stroke-width:2px
    style AISemanticCache fill:#cfc,stroke:#333,stroke-width:2px
    style DataStorageRedis fill:#fcf,stroke:#333,stroke-width:2px

    subgraph UserInteraction["User Interaction"]
        User[User]
    end

    subgraph APIGateway["API Gateway"]
        Kong[{{site.base_gateway}}]
    end

    subgraph AISemanticCache["AI Semantic Cache"]
        Plugin[AI Semantic Cache Plugin]
    end

    subgraph DataStorageRedis["Data Storage (Redis)"]
        VectorDB[Vector Database Role]
        Cache[Cache Role]
    end

    User -->|Request| Kong
    Kong -->|Forward Request| Plugin
    Plugin -->|Check Cache| Cache
    Cache -->|Cache Hit| Plugin
    Cache -->|Cache Miss| VectorDB
    VectorDB -->|Retrieve Embedding| Plugin
    Plugin -->|Generate Response| Kong
    Kong -->|Send Response| User
{% endmermaid %}
<!--vale on-->

> Figure 2: This diagram shows how the AI Semantic Cache plugin works with a vector database, cache, and {{site.base_gateway}}.

### Vector databases

A vector database can be used to store vector embeddings, or numerical representations, of data items. For example, a response would be converted to a numerical representation and stored in the vector database so that it can compare new requests against the stored vectors to find relevant cached items.

Currently, the AI Semantic Cache plugin supports Redis as vector databases.

For more information, see [Deploy and manage a vector database](/hub/kong-inc/ai-semantic-cache/vector-database/).

### Cache management

With the AI Semantic Cache plugin, you can configure a cache of your choice to store the responses from the LLM.

For more information, see [Cache management](/hub/kong-inc/ai-semantic-cache/cache-management/).

#### Caching mechanisms

The AI Semantic Cache plugin improves how AI systems provide responses by using two kinds of caching mechanisms:

* **Exact Caching:** This stores precise, unaltered responses for specific queries. If a user asks the same question multiple times, the system can quickly retrieve the pre-stored response rather than generating it again each time. This speeds up response times and reduces computational load.
* **Semantic Caching:** This approach is more flexible and involves storing responses based on the meaning or intent behind the queries. Instead of relying on exact matches, the system can understand and reuse information that is conceptually similar. For instance, if a user asks about "Italian restaurants in New York City" and later about "New York City Italian cuisine," semantic caching can help provide relevant information based on their related meanings.

Together, these caching methods enhance the efficiency and relevance of AI responses, making interactions faster and more contextually accurate.

### Configuration parameters

You can configure the following required parameters for the AI Semantic Cache plugin:

* `vectordb`: Specifies the vector database strategy and settings
* `embeddings`: Defines the embeddings provider, model, and configuration
* `cache_control`: Enables or disables Cache-Control header handling
* `storage_ttl`: Sets the time-to-live for cached responses
* `exact_caching`: Enables or disables exact caching
* `message_countback`: Specifies how many messages in the incoming array from the user will be vectorized. The whole response will still be cached. This only counts how many messages back in the chat history to turn into embeddings and query to the vector database.
* `ignore_system_prompts`: Ignores system messages (`role = system`) in the chat history when sending the embeddings (to generate vectors) if set to `true`. 
* `ignore_assistant_prompts`: Ignores assistant messages (`role = assistant`) in the chat history when sending the embeddings (to generate vectors) if set to `true`. 
* `stop_on_failure`: Stops processing if an error occurs, otherwise continues

### Headers sent to the client

When the AI Semantic Cache plugin is active, Kong sends additional headers 
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

### Cache control headers

The plugin respects cache control headers to determine if requests and responses should be cached or not. It supports the following directives:

* `no-store`: Prevents caching of the request or response
* `no-cache`: Forces validation with the origin server before serving the cached response
* `private`: Ensures the response is not cached by shared caches
* `max-age` and `s-maxage`: Sets the maximum age of the cached response. This causes the vector database to drop and delete the cached response message after expiration, so it’s never seen again. 

## Get started with the AI Semantic Caching plugin

* [Configuration reference](/hub/kong-inc/ai-semantic-caching/configuration/)
* [Basic configuration example](/hub/kong-inc/ai-semantic-caching/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/ai-semantic-caching/how-to/)

### All AI Gateway plugins

{% include_cached /md/ai-plugins-links.md release=page.release %}
