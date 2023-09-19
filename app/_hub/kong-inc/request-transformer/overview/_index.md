---
nav_title: Overview
---

The Request Transformer plugin for Kong allows simple transformation of requests
before they reach the upstream server. These transformations can be simple substitutions
or complex ones matching portions of incoming requests using regular expressions, saving
those matched strings into variables, and substituting those strings into transformed requests using flexible templates.

For additional request transformation features, check out the
[Request Transformer Advanced plugin](/hub/kong-inc/request-transformer-advanced/).
With the advanced plugin, you can also limit the list of allowed parameters in the request body.

{:.note}
> **Notes**:
* If a value contains a `,` (comma), then the comma-separated format for lists cannot be used. The array
notation must be used instead.
* The `X-Forwarded-*` fields are non-standard header fields written by Nginx to inform the upstream about
client details and can't be overwritten by this plugin. If you need to overwrite these header fields, see the
[Post-function plugin](/hub/kong-inc/post-function/how-to/).


## Order of execution

This plugin performs the response transformation in the following order:

remove → rename → replace → add → append

## Get started with the Request Transformer plugin

* [Configuration reference](/hub/kong-inc/request-transformer/configuration/)
* [Basic configuration example](/hub/kong-inc/request-transformer/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/request-transformer/how-to/)
* [Adding attributes to HTTP requests with Kong Gateway](/hub/kong-inc/request-transformer/how-to/add-body-value/)
* [Using templates as values](/hub/kong-inc/request-transformer/how-to/templates/)
