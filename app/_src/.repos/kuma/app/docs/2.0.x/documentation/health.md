---
title: Dataplane Health
---

Health is an important aspect of a microservice architecture. {{site.mesh_product_name}} can use health status
to select endpoints for communication between dataplane proxies.
Orchestrators, such as Kubernetes, use service health status to manage container lifecycles.
Also, users want the service state to be observable through the GUI or CLI.

{{site.mesh_product_name}} supports several mechanisms to regulate traffic depending on the health of a service:

## [Circuit Breaker](/docs/{{ page.version }}/policies/circuit-breaker) Policy

  A **passive** {{site.mesh_product_name}} policy which configures a dataplane proxy to monitor its existing
  mesh traffic in order to evaluate dataplane health. The dataplane can be configured to
  respond to a widely configurable range of errors and events that it may detect in communication
  with remote endpoints.

## [Kubernetes](/docs/{{ page.version }}/policies/service-health-probes#kubernetes) and [Universal](/docs/{{ page.version }}/policies/service-health-probes#universal-probes) Service Probes

  Configuration of centralized health probing of services, either directly by {{site.mesh_product_name}} Control Plane,
  or by the underlying platform, such as Kubernetes.  These can detect problems from the
  Control Plane's perspective, and propagate failures to the entire mesh. However, it is necessary
  for the Control Plane to be available, unlike policies which operate independently on the
  dataplane itself.

## [Health Check](/docs/{{ page.version }}/policies/health-check) Policy

  An **active** {{site.mesh_product_name}} policy which configures a dataplane proxy to send extra traffic
  to other dataplane proxies in order to evaluate their health. The amount of extra traffic
  for all dataplane proxies to actively probe each other grows quickly for large meshes. In some
  meshes, Health Check can be useful for specific routes which are not frequently traversed,
  but still need to detect failures quickly.
