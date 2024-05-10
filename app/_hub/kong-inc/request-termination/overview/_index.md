---
nav_title: Overview
---

This plugin terminates incoming requests with a specified status code and
message. This can be used to temporarily stop traffic on a service or a route,
or even block a consumer. 

This plugin can also be used for debugging, as described in the 
[`echo` parameter](/hub/kong-inc/request-termination/configuration/#config-echo).

Once this plugin is enabled, every request (within the configured plugin scope of a service,
route, consumer, or global) will be immediately terminated by sending the configured response.

{:.important}
> **Note:** The Request Termination plugin will not execute if the [Forward Proxy plugin](/hub/kong-inc/forward-proxy/) is enabled. This is because the Forward Proxy plugin has a higher priority and when it executes, the request is forwardered according to the plugin configuration. If you need to change this behaviour, you can configure the Request Termination plugin to execute before the Forward Proxy plugin using [Dynamic Plugin Ordering](/gateway/latest/kong-enterprise/plugin-ordering/).

## Example Use Cases

- Temporarily disable a service, for example, if the service is under maintenance
- Temporarily disable a route, for example, if the rest of the service is up and running, but a particular endpoint must be disabled
- Temporarily disable a consumer, for example, due to excessive consumption
- Block anonymous access with multiple auth plugins in a logical `OR` setup
- Debug erroneous requests in live systems
