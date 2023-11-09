## Changelog

**{{site.base_gateway}} 3.4.x**
* Optimized the response message for invalid requests.

**{{site.base_gateway}} 3.1.x**

* Breaking changes
    * `allowed_content_types`: The parameter is strictly validated, which means a request with a parameter (e.g. `application/json; charset=UTF-8`) is **NOT** considered valid for one without the same parameter (e.g. `application/json`).
