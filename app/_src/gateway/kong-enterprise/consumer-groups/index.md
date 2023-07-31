---
title: Consumer Groups
badge: enterprise
---

Consumer groups are a core {{site.base_gateway}} entity that run allow you to segment consumers (users or applications) into categories that can be associated with configuration parameters across plugins. 
Consumer groups eliminate the need to manage consumers individually, providing a scalable approach to managing configurations. 

{% if_version gte:3.4.x %}

The ability to scope plugins to consumer groups is available for: 

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/)
* [Request Transformer Advanced](/hub/kong-inc/request-transformer-advanced/)
* [Response transformer Advanced](/hub/kong-inc/request-transformer-advanced/)
* [Request Transformer](/hub/kong-inc/request-transformer)
* [Response Transformer](/hub/kong-inc/response-transformer)

{% endif_version %}

With consumer groups, you can use the [Rate Limiting Advanced plugin](/hub/kong-inc/rate-limiting-advanced/) to define rate limiting tiers and apply them across the subsets of consumers of your application. 

You can define consumer groups as tiers: 

* A "gold tier" consumer group with 1000 requests per minute
* A "silver tier" consumer group with 10 requests per second
* A "bronze tier" consumer group with 6 requests per second

Consumers that are not in a consumer group default to the Rate Limiting advanced
plugin’s configuration, so you can define tier groups for some users and
have a default behavior for consumers without groups.

To learn how this works, follow the [rate-limiting guide](/hub/kong-inc/rate-limiting-advanced/how-to/)