---
title: Default Ports
---
By default, {{site.base_gateway}} listens on the following ports:

| Port                                                                               | Protocol | Description | Gateway tier |
|:-----------------------------------------------------------------------------------|:---------|:------------|:----------------------|
| [`:8000`](/gateway/{{page.kong_version}}/reference/configuration/#proxy_listen)      | HTTP     | Takes incoming HTTP traffic from **Consumers**, and forwards it to upstream  **Services**. | All tiers and modes |
| [`:8443`](/gateway/{{page.kong_version}}/reference/configuration/#proxy_listen)      | HTTPS    | Takes incoming HTTPS traffic from **Consumers**, and forwards it to upstream **Services**. | All tiers and modes |
| [`:8001`](/gateway/{{page.kong_version}}/reference/configuration/#admin_api_uri)     | HTTP     | Admin API. Listens for calls from the command line over HTTP. | All tiers and modes |
| [`:8444`](/gateway/{{page.kong_version}}/reference/configuration/#admin_api_uri)     | HTTPS    | Admin API. Listens for calls from the command line over HTTPS. | All tiers and modes |
| [`:8005`](/gateway/{{page.kong_version}}/production/deployment-topologies/hybrid-mode/setup/)         | TCP     | Hybrid mode only. Control Plane listens for traffic from Data Planes. | All tiers and modes |
| [`:8006`](/gateway/{{page.kong_version}}/production/deployment-topologies/hybrid-mode/setup/)         | TCP     | Hybrid mode only. Control Plane listens for Vitals telemetry data from Data Planes. | {{site.ee_product_name}} tier |
{% if_version lte:3.3.x %}

| [`:8002`](/gateway/{{page.kong_version}}/reference/configuration/#admin_gui_listen)  | HTTP     | Kong Manager (GUI). Listens for HTTP traffic. | {{site.base_gateway}} free mode |
| [`:8445`](/gateway/{{page.kong_version}}/reference/configuration/#admin_gui_listen)  | HTTPS    | Kong Manager (GUI). Listens for HTTPS traffic. | {{site.base_gateway}} free mode |
{% endif_version %}
{% if_version gte:3.4.x %}

| [`:8002`](/gateway/{{page.kong_version}}/reference/configuration/#admin_gui_listen)  | HTTP     | Kong Manager (GUI). Listens for HTTP traffic. | All tiers and modes |
| [`:8445`](/gateway/{{page.kong_version}}/reference/configuration/#admin_gui_listen)  | HTTPS    | Kong Manager (GUI). Listens for HTTPS traffic. | All tiers and modes |
{% endif_version %}
| [`:8003`](/gateway/{{page.kong_version}}/reference/configuration/#portal_gui_listen) | HTTP     | Dev Portal. Listens for HTTP traffic, assuming Dev Portal is **enabled**. | {{site.ee_product_name}} tier |
| [`:8446`](/gateway/{{page.kong_version}}/reference/configuration/#portal_gui_listen) | HTTPS    | Dev Portal. Listens for HTTPS traffic, assuming Dev Portal is **enabled**.  | {{site.ee_product_name}} tier |
| [`:8004`](/gateway/{{page.kong_version}}/reference/configuration/#portal_api_listen) | HTTP     | Dev Portal `/files` traffic over HTTP, assuming the Dev Portal is **enabled**. | {{site.ee_product_name}} tier |
| [`:8447`](/gateway/{{page.kong_version}}/reference/configuration/#portal_api_listen) | HTTPS    | Dev Portal `/files` traffic over HTTPS, assuming the Dev Portal is **enabled**. | {{site.ee_product_name}} tier |

{:.note}
> **Note:** {{site.base_gateway}} free mode and Enterprise tier are not available for
open-source Gateway packages.
