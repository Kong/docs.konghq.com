---
nav_title: Overview
---

Transform client requests before they reach the upstream server. The plugin lets you match portions of incoming requests using regular expressions, save those matched strings into variables, and substitute the strings into transformed requests via flexible templates.

In addition to the basic functionality available in the open-source [Request Transformer plugin](/hub/kong-inc/request-transformer/), 
the advanced version of the plugin also lets you limit the list of allowed parameters in the request body.
Set this up with the [`allow.body`](/hub/kong-inc/request-transformer-advanced/configuration/#config-allow-body) configuration parameter.

{:.note}
> **Notes**:
* If a value contains a `,` (comma), then the comma-separated format for lists cannot be used. The array
notation must be used instead.
* The `X-Forwarded-*` fields are non-standard header fields written by Nginx to inform the upstream about client details and can't be overwritten by this plugin. 
If you need to overwrite these header fields, see the [Post-function plugin](/hub/kong-inc/post-function/how-to/).

## Order of execution

This plugin performs the response transformation in the following order:

remove → rename → replace → add → append

## Get started with the Request Transformer Advanced plugin

* [Configuration reference](/hub/kong-inc/request-transformer-advanced/configuration/)
* [Basic configuration example](/hub/kong-inc/request-transformer-advanced/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/request-transformer-advanced/how-to/)
* [Using templates as values](/hub/kong-inc/request-transformer-advanced/how-to/templates/)
