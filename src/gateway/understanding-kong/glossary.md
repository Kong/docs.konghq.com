---
title: Glossary

---

## Glossary



| Term      | Definition |
| ----------- | ----------- |
|       |        |
|  Service  | The Kong entity representing an external upstream API or microservice. |
|  Route     |    The Kong entity representing a way to map downstream requests to upstream services.    |
|  Upstream  |   The Kong entity that refers to your own API/service sitting behind Kong, to which client requests are forwarded.      |
|  Consumer     |   An entity that makes requests for Kong to proxy. It represents either a user or an external service. |
| Plugin    |     An extension to the Kong Gateway, written in Lua or Go.    |
|   Kong plugin    |  A plugin developed, maintained, and supported by Kong.      |
|  Credential  |   A unique string associated with a Consumer; also referred to as an API key.      |
|   Third-party or Community plugin    |   A custom plugin developed, maintained, and supported by an external developer, not by Kong. Kong does not test these plugins, or update their version compatibility. If you need more information or need to have a third-party plugin updated, contact the maintainer through the Support link in a plugin documentation’s sidebar.     |
| Application   |   A software program that requires access to a given service exposed in a portal. App registration allows a developer to use a client ID/secret combination to access one or more services, as defined by the Kong administrator.|
|  Catalog     |    A list of all specs within a portal. This catalog can react to developer permissions, allowing a given developer to see whatever specs their role permits.|
|  Runtime  |     A Kuma Mesh or a Kong Gateway -- an infrastructure runtime. In the case of Kong, previously known as a Kong data plane node     |
|   Dev Portal, Developer Portal    |  A collection of Service Version specs & documentation objects. The purpose of a portal is to allow registration and consumption of services running through Kong to other teams, developers, partners, etc.      |
|  Proxy  |   A particular implementation of a service version in the form of a Kong Gateway proxy. A proxy is composed of the Kong Gateway configurations that make up the realization of the proxy when enabled on a Kong Gateway instance.  |
|   Service Configuration    |   The concrete configuration that a runtime group can be configured with in order to expose the service version’s functionality. At the onset, the only type of implementation that we will support will be a Kong proxy.|
|  Service Version  |    A specific version of a service (RESTful API, gPRC endpoint, GraphQL endpoint, or this could be used for sem-ver versioning) managed in Konnect.     |
|   Spec    |     A service version can have an optional spec (e.g. OAPI spec for a RESTful service) associated with it.    |
|  Groups  |    Sets of of role defined entities     |
|       |        |
|    |         |
|       |        |
|    |         |
|       |        |
|    |         |
|       |        |
|    |         |
|       |        |
|    |         |
|       |        |
|    |         |
|       |        |
|    |         |
|       |        |
|    |         |
|       |        |
|    |         |
|       |        |
|    |         |
|       |        |
|    |         |
|       |        |
|    |         |
|       |        |
|    |         |
|       |        |
|    |         |
|       |        |
|    |         |
|       |        |
|    |         |
|       |        |
|    |         |
|       |        |
|    |         |
|       |        |
|    |         |
|       |        |
|    |         |
|       |        |
|    |         |
