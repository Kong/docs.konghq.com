---
title: Key Concepts and Terminology
no_version: true
---

### Service

A Service is an API that can be defined as a *discrete* unit of functionality
and that can be accessed *remotely* by its consumers.

*Discrete* means the Service represents an independent piece of functionality
that is useful on its own in satisfying a specific purpose for its consumers.
*Remotely* means that the Service is not invoked locally (within the process
space) and requires a network call to be invoked.  

### Service Version

Different instances of the same Service representing different versions (for
example, `1.1`, `1.2`, if the version string is represented through a
semantic versioning model).

### Service Implementation

The connectivity logic associated with a Service version. Currently, the only
supported implementation type is a {{site.base_gateway}} proxy, which
consists of proxy configuration objects such as a Service object and Route
object.  

### Service Connectivity Platform

A platform that enables reliability, accelerated performance, and insight by
providing common, out-of-the-box connectivity logic, executed through runtimes
that capture data in motion and managed through functionality modules across
points of connectivity.

### Edge Connectivity

Connectivity management between organizational boundaries.

### Inter-app Connectivity

Connectivity management between application boundaries and teams.

### In-app Connectivity

Connectivity management within the services that constitute a single
application.

### Connectivity Endpoint

The remote access endpoint (often involving a port/IP address) through which
a Service’s connection is exposed for consumption. When a Service’s connectivity
endpoint is exposed through a connectivity runtime, then the runtime can apply
connectivity logic to manage the endpoint’s traffic.

### Connectivity Runtime

A process that enables the execution of connectivity logic on connectivity
endpoints.

### Connectivity Logic

Logic that addresses concerns such as ensuring that incoming requests are
authenticated, authorized, rate-limited, and logged, or that, as a new version
of a service is introduced, requests from incompatible older versions of the
service’s consumers are routed to the older version.

### Functionality Module

Functionality, delivered as a service or in a self-managed manner, that
leverages connectivity runtimes to provide a connectivity management capability
(for example, Dev Portal).
