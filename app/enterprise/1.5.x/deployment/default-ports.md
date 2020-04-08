---
title: Default Ports
toc: false
---
By default, Kong Enterprise Gateway listens on the following ports:

| Port                                                                               | Protocol | Description |
|------------------------------------------------------------------------------------|----------|-------------|
| [`:8000`](/enterprise/{{page.kong_version}}/property-reference/#proxy_listen)      | HTTP     | Takes incoming HTTP traffic from **Consumers**, and forwards it to upstream **Services**. |
| [`:8443`](/enterprise/{{page.kong_version}}/property-reference/#proxy_listen)      | HTTPS    | Takes incoming HTTPS traffic from **Consumers**, and forwards it to upstream **Services**. |
| [`:8001`](/enterprise/{{page.kong_version}}/property-reference/#admin_api_uri)     | HTTP     | Admin API. Listens for calls from the command line over HTTP. |
| [`:8444`](/enterprise/{{page.kong_version}}/property-reference/#admin_api_uri)     | HTTPS    | Admin API. Listens for calls from the command line over HTTPS. |
| [`:8002`](/enterprise/{{page.kong_version}}/property-reference/#admin_gui_listen)  | HTTP     | Kong Manager (GUI). Listens for HTTP traffic. |
| [`:8445`](/enterprise/{{page.kong_version}}/property-reference/#admin_gui_listen)  | HTTPS    | Kong Manager (GUI). Listens for HTTPS traffic. |
| [`:8003`](/enterprise/{{page.kong_version}}/property-reference/#portal_gui_listen) | HTTP     | Dev Portal. Listens for HTTP traffic, assuming Dev Portal is **enabled**. |
| [`:8446`](/enterprise/{{page.kong_version}}/property-reference/#portal_gui_listen) | HTTPS    | Dev Portal. Listens for HTTPS traffic, assuming Dev Portal is **enabled**.
| [`:8004`](/enterprise/{{page.kong_version}}/property-reference/#portal_api_listen) | HTTP     | Dev Portal `/files` traffic over HTTP, assuming the Dev Portal is **enabled**.
| [`:8447`](/enterprise/{{page.kong_version}}/property-reference/#portal_api_listen) | HTTPS    | Dev Portal `/files` traffic over HTTPS, assuming the Dev Portal is **enabled**. |
