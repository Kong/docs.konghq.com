---
nav_title: Overview
---

The AI RAG Injector plugin simplifies the creation of retrieval-augmented generation (RAG) pipelines by automatically injecting content from a vector database of choice on the existing requests.

This plugin provides the following benefits:
* Improves productivity and accelerates creating RAG pipelines, as you don't have to build the semantic association.
* Lets you lock down sensitive vector databases, so that developers don't have direct access. AI Gateway becomes the client, instead of the developer applications.
* Enables building RAG pipelines in more places, even in places where connectivity to the vector database was originally not possible.

## How it works

1. You configure the AI RAG Injector plugin via the Kong Admin API or decK, setting up the RAG content to send to the vector database.
2. When a request reaches the AI Gateway, the plugin generates embeddings for request prompts, then queries the vector database for the top-k most similar embeddings.
3. The plugin injects the retrieved content from the vector search result into the request body, and forwards the request to the upstream service.


## Get started with the AI RAG Injector plugin

* [AI Gateway quickstart: Set up AI Proxy](/gateway/latest/get-started/ai-gateway/)
* [Configuration reference](/hub/kong-inc/ai-rag-injector/configuration/)
* [Basic configuration example](/hub/kong-inc/ai-rag-injector/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/ai-rag-injector/how-to/)

### All AI Gateway plugins

{% include_cached /md/ai-plugins-links.md release=page.release %}
