---
title: About Datakit
badge: enterprise
alpha: true
---

The {{site.base_gateway}} Datakit is a tool that allows you to interact with third-party APIs. 
It uses response data from these requests to seed information for subsequent calls, either upstream/back to the client or to other APIs. 

Datakit is a data flow engine built on top of WASM inside {{site.base_gateway}}. 
It allows you to create an API workflow, which can include:
* Making calls to third party APIs
* Transforming or combining API responses
* Modifying client requests and service responses
* Adjusting Kong entity configuration
* Returning directly to users instead of proxying

## Use cases for Datakit

The following are examples of common use cases for Datakit:

Use case | Description
---------|------------
Internal authentication | Use internal auth within your ecosystem by sending response headers to upstreams.
Service augmentation | ?
Dynamic service discovery | ?
Get and set Kong entity properties | Use Datakit to adjust {{site.base_gateway}} entity configurations. For example, you could replace the service URL or set a header on a route.

## How does it work?

The core component of Datakit is a node. Nodes are inputs to other nodes, which creates the execution path for a given Datakit configuration. 

Datakit provides the following node types:
* [`call`](/gateway/{{page.release}}/kong-enterprise/datakit/configuration/#call-node-type): Third-party HTTP calls
* [`jq`](/gateway/{{page.release}}/kong-enterprise/datakit/configuration/#jq-node-type): Transform data and cast variables with `jq` to be shared with other nodes
* [`handlebars`](/gateway/{{page.release}}/kong-enterprise/datakit/configuration/#handlebars-node-type): Apply a [Handlebars](https://docs.rs/handlebars/latest/handlebars/) template to a raw string, useful for producing arbitrary non-JSON content types
* [`exit`](/gateway/{{page.release}}/kong-enterprise/datakit/configuration/#exit-node-type): Return directly to the client
* [`property`](/gateway/{{page.release}}/kong-enterprise/datakit/configuration/#property-node-type): Get and set {{site.base_gateway}} configuration data

Datakit, like any WASM filter, can be applied to services and routes,
You can configure Datakit via the `/plugins` endpoint.

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

## More information

* [Get started with Datakit](/gateway/{{page.release}}/kong-enterprise/datakit/get-started/)
* [Datakit configuration reference](/gateway/{{page.release}}/kong-enterprise/datakit/configuration/)
* [Datakit examples reference](/gateway/{{page.release}}/kong-enterprise/datakit/examples/)