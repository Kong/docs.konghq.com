## Changelog

### {{site.base_gateway}} 3.8.x
* Added the Redis `cluster_max_redirections` configuration option.

### {{site.base_gateway}} 3.7.x

* Added Redis strategy support.
* Added the ability to resolve unhandled errors with bypass, with the request going upstream. Enable it using the [`bypass_on_err`](/hub/kong-inc/graphql-proxy-cache-advanced/configuration/#config-bypass_on_err) configuration option.