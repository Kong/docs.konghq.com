## Changelog

**{{site.base_gateway}} 3.5.x**
* Resolved warning logs related to flooded JSON decoding issues.

**{{site.base_gateway}} 3.4.x**
* Fixed an issue where the plugin wouldn't transform the response body when the upstream returned a 
  `Content-Type` with a `+json` suffix as the subtype.
