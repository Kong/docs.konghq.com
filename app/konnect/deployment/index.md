---
title: Deployment Overview
no_version: true
---
## Architecture

The {{site.konnect_product_name}} platform provides a cloud control plane (CP),
which manages all service configurations. It propagates those configurations to
all runtime nodes, which use in-memory storage. These nodes can be installed
anywhere, on-premise or in the cloud.

Runtime nodes, acting as data planes, listen for traffic on the proxy port 443
by default. The {{site.konnect_short_name}} data plane evaluates
incoming client API requests and routes them to the appropriate backend APIs.
While routing requests and providing responses, policies can be applied with
plugins as necessary.

![Konnect Cloud Architecture](/assets/images/docs/konnect/Konnect-architecture-wide.png)

For example, before routing a request, the client might be required to
authenticate. This delivers several benefits, including:

* The Service doesn’t need its own authentication logic since the data plane is
handling authentication.
* The Service only receives valid requests and therefore cycles are not wasted
processing invalid requests.
* All requests are logged for central visibility of traffic.

## Compatibility

### Supported Browsers

|                                  | IE | Edge | Firefox | Chrome | Safari |
|----------------------------------|:--:|:----:|:-------:|:------:|:------:|
| {{site.konnect_saas}} |  <i class="fa fa-times"></i> | <i class="fa fa-check"></i> |  <i class="fa fa-check"></i> |  <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |

### Runtime Compatibility

{:.note}
> **Note:** Currently, the only supported runtime type in
{{site.konnect_saas}} is a [{{site.base_gateway}}](/gateway/)
data plane.

|                                | {{site.konnect_saas}} | First supported patch version
|--------------------------------|:---------------------:|-----------------------------
| {{site.ee_product_name}} 2.7.x | <i class="fa fa-check"></i>    | 2.7.0.0
| {{site.ee_product_name}} 2.6.x | <i class="fa fa-check"></i>    | 2.6.0.0
| {{site.ee_product_name}} 2.5.x | <i class="fa fa-check"></i>    | 2.5.0.1
| {{site.ee_product_name}} 2.4.x | <i class="fa fa-check"></i>    | 2.4.1.1
| {{site.ee_product_name}} 2.3.x | <i class="fa fa-check"></i>    | 2.3.0.0
| {{site.ee_product_name}} 2.2.x or earlier | <i class="fa fa-times"></i> | --
