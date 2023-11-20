## Changelog

**{{site.base_gateway}} 3.5.x**
* Added a new property `include_base_path` for path match evaluation. 
Path parameters can now correctly match non-ASCII characters.
* Fixed an issue where non `application/json` content-types were being rejected, 
even when the request body was not required.
* Fixed an issue where a null pointer exception could occur in certain scenarios
when `notify_only_request_validation_failure` was set to true.
* Fixed an issue where valid recursive schemas were always rejected.

**{{site.base_gateway}} 3.4.x**
* Fixed an issue where the plugin was unable to pass the 
validation even if path parameter was valid.
* Fixed an issue where the plugin always validated the request body even 
if the method spec had no `requestBody` defined.
* Fixed an issue where the comparison between large absolute value numbers could be incorrect 
due to the number being converted to exponential notation.