---
title: Routes
concept_type: explanation
---

Routes determine how (and if) requests are sent to their services after they reach {{site.base_gateway}}. Where a service represents the backend API, a route defines what is exposed to clients. 

A single service can have many routes.  Once a route is matched, {{site.base_gateway}} proxies the request to its associated service.

## See next

Next, go on to learn about [upstreams](/gateway/latest/understanding-kong/key-concepts/upstreams/).
