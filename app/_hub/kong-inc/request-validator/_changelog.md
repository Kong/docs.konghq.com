## Changelog

### {{site.base_gateway}} 3.9.x
* Fixed an issue where requests would get rejected when defining an object parameter in exploded form style.

### {{site.base_gateway}} 3.8.x
* Fixed an issue where the plugin could fail to handle requests when `param_schema` was `$ref schema`.
* Added a new configuration field `content_type_parameter_validation` to determine whether to enable Content-Type parameter validation.

### {{site.base_gateway}} 3.7.x
#### 3.7.1.0
* Added the new configuration field `content_type_parameter_validation` to determine whether to enable Content-Type parameter validation.

### {{site.base_gateway}} 3.6.x
* The plugin now validates the request body schema when `json` is the suffix value in the request content type's subtype (for example, `application/merge-patch+json`).

### {{site.base_gateway}} 3.4.x
* Optimized the response message for invalid requests.

### {{site.base_gateway}} 3.1.x
* Breaking changes
    * `allowed_content_types`: The parameter is strictly validated, which means a request with a parameter (e.g. `application/json; charset=UTF-8`) is **NOT** considered valid for one without the same parameter (e.g. `application/json`).
