---
title: Upstreams
concept_type: explanation
---

Upstream refers to an API, application, or micro-service that {{site.base_gateway}} forwards requests to.
In {{site.base_gateway}}, an upstream object represents a virtual hostname and can be used to health check, circuit break, and load balance incoming requests over multiple services.

## Upstream and service interaction

You can configure a [service](/gateway/{{ page.kong_version }}/key-concepts/services/) to point to an upstream instead of a host. 
For example, if you have a service called `example_service` and an upstream called `example_upstream`, you can point `example_service` to `example_upstream` instead of specifying a host. 
The `example_upstream` upstream can then point to two different targets: `httpbin.org` and `httpbun.com`. 
In a real environment, the upstream points to the same service running on multiple systems.

This setup allows you to [load balance](/gateway/{{ page.kong_version }}/how-kong-works/load-balancing) between upstream targets. 
For example, if an application is deployed across two different servers or upstream targets, {{site.base_gateway}} needs to load balance across both servers. 
This is so that if one of the servers (like `httpbin.org` in the previous example) is unavailable, it automatically detects the problem and routes all traffic to the working server (`httpbun.com`). 


## Upstream configuration

You can add upstreams to a service in {{site.base_gateway}} using the following methods:

* Using Kong Manager
* Using the Admin API
* Using decK (YAML)

For more information about how to configure upstreams, see [Configure Load Balancing](/gateway/{{ page.kong_version }}/get-started/load-balancing/). 