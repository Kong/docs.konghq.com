## Changelog

### {{site.base_gateway}} 3.8.x
* Added support for `json_body` renaming.
[#13131](https://github.com/Kong/kong/issues/13131)
* Fixed an issue where renamed query parameters, url-encoded body parameters, 
  and JSON body parameters were not handled properly when the target name was the same as the source name in the request.
  [#13358](https://github.com/Kong/kong/issues/13358)

### {{site.base_gateway}} 3.5.x
* Resolved warning logs related to flooded JSON decoding issues.

### {{site.base_gateway}} 3.4.x
* Fixed an issue where the plugin wouldn't transform the response body when the upstream returned a 
  `Content-Type` with a `+json` suffix as the subtype.
