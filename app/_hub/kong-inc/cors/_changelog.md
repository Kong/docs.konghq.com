## Changelog

### {{site.base_gateway}} 3.10.x
* Added an option to skip returning the `Access-Control-Allow-Origin` response header when requests don't have the `Origin` header.

### {{site.base_gateway}} 3.8.x
* Fixed an issue where the `Access-Control-Allow-Origin` header was not sent when `conf.origins` had multiple entries but included `*`.
   [#13334](https://github.com/Kong/kong/issues/13334)

### {{site.base_gateway}} 3.5.x

* Added support for the `Access-Control-Request-Private-Network` header in 
  cross-origin pre-flight requests. [#11523](https://github.com/kong/kong/pull/11523)