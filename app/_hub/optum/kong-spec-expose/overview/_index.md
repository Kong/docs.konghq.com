---
nav_title: Overview
---

This plugin will expose the OpenAPI Spec (OAS), Swagger, or other specification of auth protected API services fronted by the {{site.base_gateway}}.

API providers need a means of exposing the specifications of their services while maintaining authentication on the service itself - this plugin solves this problem by:

1. Plugin enables Kong Admin to specify the endpoint of their API specification.

2. Plugin will validate the Proxy request is GET method, and will validate the proxy request ends with "/specz". If these two requirements are met, the endpoint will return the specification of the API Service with Content-Type header identical to what the API Service exposes.

## Installation

Recommended:

```bash
$ luarocks install kong-spec-expose
```

Other:

```bash
$ git clone https://github.com/Optum/kong-spec-expose.git /path/to/kong/plugins/kong-spec-expose
$ cd /path/to/kong/plugins/kong-spec-expose
$ luarocks make *.rockspec
```

## Maintainers

<!--vale off-->

[jeremyjpj0916](https://github.com/jeremyjpj0916){:target="_blank"}{:rel="noopener noreferrer"}  
[rsbrisci](https://github.com/rsbrisci){:target="_blank"}{:rel="noopener noreferrer"}  

Feel free to [open issues](https://github.com/Optum/kong-spec-expose/issues){:target="_blank"}{:rel="noopener noreferrer"}, or refer to our [Contribution Guidelines](https://github.com/Optum/kong-spec-expose/blob/master/CONTRIBUTING.md){:target="_blank"}{:rel="noopener noreferrer"} if you have any questions.
