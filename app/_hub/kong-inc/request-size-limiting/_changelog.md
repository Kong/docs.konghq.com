## Changelog

### {{site.base_gateway}} 3.8.x
* Fixed an issue where the body size didn't get checked when the request body was buffered to a temporary file.
   [#13303](https://github.com/Kong/kong/issues/13303)

### {{site.base_gateway}} 2.3.x
* Added the `require_content_length` configuration option.
