<!-- used in Konnect and Gateway docs -->

By default, {{site.kong_gateway}} listens on the following ports:

| Port                                                                               | Protocol | Description |
|:-----------------------------------------------------------------------------------|:---------|:--|
| [`:8000`](/enterprise/latest/property-reference/#proxy_listen)      | HTTP     | Takes incoming HTTP traffic from **Consumers**, and forwards it to upstream **Services**. |
| [`:8443`](/enterprise/latest/property-reference/#proxy_listen)      | HTTPS    | Takes incoming HTTPS traffic from **Consumers**, and forwards it to upstream **Services**. |
| [`:8001`](/enterprise/latest/property-reference/#admin_api_uri)     | HTTP     | Admin API. Listens for calls from the command line over HTTP. |
| [`:8444`](/enterprise/latest/property-reference/#admin_api_uri)     | HTTPS    | Admin API. Listens for calls from the command line over HTTPS. |
| [`:8002`](/enterprise/latest/property-reference/#admin_gui_listen)  | HTTP     | Kong Manager (GUI). Listens for HTTP traffic. |
| [`:8445`](/enterprise/latest/property-reference/#admin_gui_listen)  | HTTPS    | Kong Manager (GUI). Listens for HTTPS traffic. |
| [`:8003`](/enterprise/latest/property-reference/#portal_gui_listen) | HTTP     | Dev Portal. Listens for HTTP traffic, assuming Dev Portal is **enabled**. |
| [`:8446`](/enterprise/latest/property-reference/#portal_gui_listen) | HTTPS    | Dev Portal. Listens for HTTPS traffic, assuming Dev Portal is **enabled**. |
| [`:8004`](/enterprise/latest/property-reference/#portal_api_listen) | HTTP     | Dev Portal `/files` traffic over HTTP, assuming the Dev Portal is **enabled**. |
| [`:8447`](/enterprise/latest/property-reference/#portal_api_listen) | HTTPS    | Dev Portal `/files` traffic over HTTPS, assuming the Dev Portal is **enabled**. |
| [`:8005`](/enterprise/latest/deployment/hybrid-mode-setup/)         | HTTP     | Hybrid mode only. Control Plane listens for traffic from Data Planes. |
| [`:8006`](/enterprise/latest/deployment/hybrid-mode-setup/)         | HTTP     | Hybrid mode only. Control Plane listens for Vitals telemetry data from Data Planes. |


Self-hosted ports can be fully customized. Set them in `kong.conf`.

For Kubernetes or Docker deployments, map ports as needed. For example, if you
want to expose the Admin API through port `3001`, map `3001:8001`.
