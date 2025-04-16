---
title: Compatibility
---

## Supported browsers

|                                  | IE | Edge | Firefox | Chrome | Safari |
|----------------------------------|:--:|:----:|:-------:|:------:|:------:|
| {{site.konnect_saas}} |  <i class="fa fa-times"></i> | <i class="fa fa-check"></i> |  <i class="fa fa-check"></i> |  <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |

## {{site.base_gateway}} version compatibility


|                                | {{site.konnect_saas}} | Beginning with version | End of support |
|--------------------------------|:---------------------:|-------------------------------|----------------|
| {{site.ee_product_name}} 3.10.x (LTS) | <i class="fa fa-check"></i>    | 3.10.0.0 | March 2028
| {{site.ee_product_name}} 3.9.x | <i class="fa fa-check"></i>    | 3.9.0.0 | Dec 2025
| {{site.ee_product_name}} 3.8.x | <i class="fa fa-check"></i>    | 3.8.0.0 | Oct 2025
| {{site.ee_product_name}} 3.7.x | <i class="fa fa-check"></i>    | 3.7.0.0 | Jun 2025
| {{site.ee_product_name}} 3.6.x | <i class="fa fa-check"></i>    | 3.6.0.0 | Feb 2025
| {{site.ee_product_name}} 3.5.x | <i class="fa fa-check"></i>    | 3.5.0.0 | Nov 2024
| {{site.ee_product_name}} 3.4.x (LTS)| <i class="fa fa-check"></i>    | 3.4.0.0 | Aug 2026
| {{site.ee_product_name}} 3.3.x | <i class="fa fa-check"></i>    | 3.3.0.0 | May 2024
| {{site.ee_product_name}} 3.2.x | <i class="fa fa-check"></i>    | 3.2.1.0 | Feb 2024
| {{site.ee_product_name}} 3.1.x | <i class="fa fa-check"></i>    | 3.1.0.0 | Dec 2023
| {{site.ee_product_name}} 3.0.x | <i class="fa fa-check"></i>    | 3.0.0.0 | Sep 2023
| {{site.ee_product_name}} 2.8.x (LTS)| <i class="fa fa-check"></i>    | 2.8.0.0 | Mar 2025
| {{site.ee_product_name}} 2.7.x | <i class="fa fa-check"></i>    | 2.7.0.0 | Feb 2023
| {{site.ee_product_name}} 2.6.x | <i class="fa fa-check"></i>    | 2.6.0.0 | Feb 2023
| {{site.ee_product_name}} 2.5.x | <i class="fa fa-check"></i>    | 2.5.0.1 | Aug 2022
| {{site.ee_product_name}} 2.4.x or earlier | <i class="fa fa-times"></i>    | -- | --



## {{site.mesh_product_name}} compatibility

To use [Mesh Manager](/konnect/mesh-manager/), you must also use a compatible version of {{site.mesh_product_name}}.

|                                  | {{site.konnect_saas}} | First supported patch version
|--------------------------------|:---------------------:|-----------------------------
| {{site.mesh_product_name}} 2.4.x | <i class="fa fa-check"></i> | 2.4.1
| {{site.mesh_product_name}} 2.3.x or earlier | <i class="fa fa-times"></i> | -

## decK version compatibility

{{site.konnect_short_name}} requires decK v1.40.0 or above. 
Versions below this will see inconsistent `deck gateway diff` results and other potential issues.

## Plugin compatibility

Most {{site.base_gateway}} plugins are compatible with {{site.konnect_short_name}}.
See the [Kong Plugin Hub](/hub/?compatibility=konnect) for all compatible plugins.

### Considerations for Dedicated Cloud Gateways

There are some limitations for plugins with Dedicated Cloud Gateways:

* Any plugins that depend on a local agent will not work with Dedicated Cloud Gateways.
* Any plugins that depend on the Status API or on Admin API endpoints will not work.
* Any plugins or functionality that depend on AWS IAM `AssumeRole` need to be configured differently.
This includes [Data Plane Resilience](/gateway/latest/kong-enterprise/cp-outage-handling/).

