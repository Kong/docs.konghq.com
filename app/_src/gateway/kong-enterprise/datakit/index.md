---
title: About Datakit
badge: enterprise
badge: tech-preview
---

The {{site.base_gateway}} Datakit is a tool that allows you to interact with third-party APIs. It uses response data from these requests to seed information for subsequent calls, either upstream/back to the client or to other APIs. 

Datakit is a data flow engine that is built on top of WASM inside {{site.base_gateway}}.

## How does it work?

The core component of Datakit is a node. Nodes are inputs to other nodes, which creates the execution path for a given Datakit configuration. 

There are several types of static nodes:
* Third-party HTTP calls
* Transform data and cast variables with `jq` to be shared with other nodes
* Get and set {{site.base_gateway}} configuration data
* Return directly to the client

You can also create your own node types.

Datakit, like any WASM filter, can be applied to services and routes.

The following diagram shows how Datakit can be used to combine two third-party API calls into one response:

{% mermaid %}
sequenceDiagram
    actor Client
    participant Datakit
    participant Cat facts API
    participant Dog facts API

    Client->>Datakit: Send a request to the `/animal-fact` API endpoint
    Datakit->>Cat facts API: Calls the third-party `/cat-facts` API endpoint
    Datakit->>Dog facts API: Calls the third-party `/dog-facts` API endpoint
    Cat facts API->>Datakit: Sends a cat fact
    Dog facts API->>Datakit: Sends a dog fact
    Datakit->>Client: Uses `jq` to pass both facts in a response
{% endmermaid %}

