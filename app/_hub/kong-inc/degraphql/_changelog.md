## Changelog

### {{site.base_gateway}} 3.9.x
* Fixed an issue where the DeGraphQL routes were updated from the control plane but not updated in the DeGraphQL router on the data plane.

### {{site.base_gateway}} 3.8.x
* Fixed an issue where multiple parameter types were not handled correctly when converting query parameters.

### {{site.base_gateway}} 3.7.x
* Fixed an issue where GraphQL variables were not being correctly parsed and coerced into their defined types.
* This plugin now uses a new configuration handler to update the GraphQL router with better error handling.

### {{site.base_gateway}} 3.0.x

* Added the `graphql_server_path` configuration parameter.
