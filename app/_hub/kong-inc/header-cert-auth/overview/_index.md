---
nav_title: Overview
---

The Header Cert Authentication plugin authenticates API calls using client certificates received in HTTP headers, 
rather than through traditional TLS termination. 
This is necessary in scenarios where TLS traffic is not terminated at {{site.base_gateway}}, but rather at an external CDN or load balancer, 
and the client certificate is preserved in an HTTP header for further validation.

## How it works


## Get started with the Header Cert Authentication plugin

* [Configuration reference](/hub/kong-inc/header-cert-auth/configuration/)
* [Basic configuration example](/hub/kong-inc/header-cert-auth/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/header-cert-auth/how-to/)
