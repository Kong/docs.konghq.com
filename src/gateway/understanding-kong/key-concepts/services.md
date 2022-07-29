---
title: Services
content_type: explanation
---

In {{site.base_gateway}}, a service is an entity representing an external upstream API or microservice. For example, a data transformation microservice, a billing API, and so on. In conjunction with routes, services let you expose your services to clients with {{site.base_gateway}}.

The main attribute of a service is its URL, where Kong should proxy traffic to. You can specify the URL with a single string, or by specifying its protocol, host, port, and path individually.

When configuring access to your API, you start by specifying a service. 

## Next steps

Next, go on to learn about [routes](/gateway/latest/understanding-kong/key-concepts/routes/).