## Changelog

### {{site.base_gateway}} 3.6.x
* The plugin now bypasses schema validation when the content type is not `application/json`.
* Fixed a bug where the plugin throws a runtime error caused by the ref parameter schema not being dereferenced.
[#7259](https://github.com/Kong/kong/issues/7259)
* Exposed metrics for serviceless routes.
[#7055](https://github.com/Kong/kong/issues/7055)
* Fixed an issue where the plugin threw a runtime error while validating parameters with the AnyType schema and style keyword defined.
* Fixed an issue where the cookie parameters weren't being validated.
* Fixed an issue where the `nullable` keyword didn't take effect.
* Fixed an issue where the request path couldn't matched when containing regex escape characters.
The URI component escaped characters were incorrectly unescaped.

### {{site.base_gateway}} 3.5.x
* Added a new property `include_base_path` for path match evaluation. 
Path parameters can now correctly match non-ASCII characters.
* Fixed an issue where non `application/json` content-types were being rejected, 
even when the request body was not required.
* Fixed an issue where a null pointer exception could occur in certain scenarios
when `notify_only_request_validation_failure` was set to true.
* Fixed an issue where valid recursive schemas were always rejected.

### {{site.base_gateway}} 3.4.x
* Fixed an issue where the plugin was unable to pass the 
validation even if path parameter was valid.
* Fixed an issue where the plugin always validated the request body even 
if the method spec had no `requestBody` defined.
* Fixed an issue where the comparison between large absolute value numbers could be incorrect 
due to the number being converted to exponential notation.