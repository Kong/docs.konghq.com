---
title: Kong Konnect Overview
no_search: true
no_version: true
beta: true
---
## Introduction
{{site.konnect_product_name}} lets you manage multiple data planes (DPs) from a
single, cloud-based control plane (CP), giving you an overview of all deployed
services. You can deploy the data planes in different environments, data
centers, geographies, or zones without needing a local clustered database for
each data plane group.

This Getting Started Guide for {{site.konnect_product_name}} walks you through
Konnect concepts and foundational API gateway features and capabilities.

In this guide, you will:
* Create a Konnect account
* Configure a Service and Service Version, then implement the Version
* Secure a Service Version through IP restriction
* Set up key authentication on a Route
* Configure a self-hosted runtime (data plane)
* Enable the Developer Portal to publish API documentation for your service
* Monitor the health of the Service and its constituents with Vitals

## Concepts and Features in this Guide
Here’s the content covered in this guide, with an overview of entities and how
the pieces fit together:

| Concept/Feature {:width=20%:}| Description |
|------------------------------|-------------|
| Service                      | Service entities are abstractions of each of your own upstream services, e.g., a data transformation microservice, a billing API, etc.  In Konnect, a Service is implemented through one or more Versions. |
| Service Version              | One instance of a Service with a unique configuration. Each version can have different configurations, set up for a RESTful API, gPRC endpoint, GraphQL endpoint, etc. A version can be a numerical identifier, such as `1.0.0`, or an identifier using text such as `version_1`. |
| Service Implementation       | The concrete, runnable incarnation of a Service Version. It defines the configuration for the Version, including the upstream URL and routes. Each Service Version can have one Implementation. |
| Route                        | Routes specify how (and if) requests are sent to their Service Versions after they reach the API gateway. A single Service Version can have many Routes. |
| Data Plane (DP)              | (Also referred to as a *runtime*) A node that serves traffic for the proxy. Data plane nodes are not directly connected to a database. |
| Control Plane (CP)           | The central node which manages configuration for all data plane nodes. |
| Proxy                        | An implementation of a service version in the form of a Kong Gateway proxy. |
| Proxy URL                    | URL for requests to the proxy. |
| Developer Portal             | (Also referred to as *Portal*) A collection of Service Version specs and documentation objects. The Developer Portal provides a single source of truth for all developers and teams to locate, access, and consume services. |
| Spec                         | Documentation for a Service Version in the form of an OpenAPI spec. A spec can be either in YAML or JSON format. |
| API Catalog                  | The API Catalog is one component of the Developer Portal containing the documentation for Services. |

## Understanding Traffic Flow in Kong Konnect

The Konnect platform provides a cloud control plane (CP), which manages all
Service configurations. It propagates those configurations to all data plane
(DP) nodes, which use in-memory storage. The data plane nodes can be installed
anywhere, on-premise or in the cloud.

The control plane listens for connections from data planes on port 8005.

The data plane listens for traffic on its configured proxy port(s) 8000 and
8443, by default. It evaluates incoming client API requests and routes them to
the appropriate backend APIs. While routing requests and providing responses,
policies can be applied via plugins as necessary.

![Traffic flow in Kong Konnect](/assets/images/docs/konnect/Konnect-architecture-wide.png)

For example, before routing a request, the client might be required to
authenticate. This delivers several benefits, including:

* The service doesn’t need its own authentication logic since the data plane is
handling authentication.
* The service only receives valid requests and therefore cycles are not wasted
processing invalid requests.
* All requests are logged for central visibility of traffic.

For the Konnect beta, Kong will provision a single hosted data plane for you.
Later, you will also be able to configure additional self-managed data planes.

## Before you Begin
Note the following before you start using this guide:

### Installation and Deployment
<div class="alert alert-ee red">
<strong>Warning:</strong> Do not use {{site.konnect_product_name}} beta in a
production environment.
<br> <br>You can use this guide to get started in a test environment, but this
guide does not provide all of the necessary configurations and security settings
that you would need for a production environment.
</div>

For the {{site.konnect_product_name}} beta, there is nothing to manually
install or deploy. When you create a Konnect beta account, Kong provisions a
data plane for you and automatically connects it to your account.

### Using this Guide

This Getting Started Guide is meant to be followed topic by topic, each task
building on the previous one: creating a Service Version, then implementing that
Version with a Route, then enabling plugins on the Route and Service Version,
and so on. However, each topic can also stand alone as a reference if needed.

## Next Steps

Next, start by [creating a Kong Konnect account](/konnect/getting-started/access-beta).
