## Changelog

### {{site.base_gateway}} 3.6.x
* Fixed an issue where valid recursive schemas were always rejected.
* Fixed an issue where the plugin failed to return the mock response when `responses` contained `default` or wildcard codes like `2XX`.
* The plugin now prints a `notice` log entry if a revocation check fails with `revocation_check_mode = IGNORE_CA_ERROR`.

### {{site.base_gateway}} 3.5.x
* Added the new property `include_base_path` for path match evaluation.
Path parameters can now correctly match non-ASCII characters.

### {{site.base_gateway}} 3.4.x
* Fixed an issue where the plugin threw an error when the arbitrary elements were defined in the path node.

### {{site.base_gateway}} 3.1.x

* Added `config.included_status_codes`, `config.random_status_codes` configuration parameters for status code selection.
* Added behavioral headers feature.
* $ref and schema support.
* Added MIME types priority match support.

### {{site.base_gateway}} 2.7.x

* Added the `random_examples` parameter.
Use this setting to randomly select one example from a set of mocked responses.
