---
name: Kong Spec Expose
publisher: Optum

categories:
  - security

type: plugin

desc: Expose OAS/Swagger/etc. specifications of auth protected APIs proxied by Kong
description: |
  This plugin will expose the OpenAPI Spec (OAS), Swagger, or other specification of auth protected API services fronted by the Kong gateway.

  API providers need a means of exposing the specifications of their services while maintaining authentication on the service itself - this plugin solves this problem by:

  1. Plugin enables Kong Admin to specify the endpoint of their API specification.

  2. Plugin will validate the Proxy request is GET method, and will validate the proxy request ends with "/specz". If these two requirements are met, the endpoint will return the specification of the API Service with Content-Type header identical to what the API Service exposes.

support_url: https://github.com/Optum/kong-spec-expose/issues

source_url: https://github.com/Optum/kong-spec-expose/

license_type: Apache-2.0

kong_version_compatibility:
  community_edition:
    compatible:
      - 0.14.x
      - 0.13.x
      - 0.12.x
    incompatible:
      - 0.11.x
      - 0.10.x
      - 0.9.x
      - 0.8.x
      - 0.7.x
      - 0.6.x
      - 0.5.x
      - 0.3.x
      - 0.2.x
  enterprise_edition:
    compatible:
      - 0.34-x
      - 0.33-x
      - 0.32-x
      - 0.31-x
      - 0.30-x
    incompatible:
      - 0.29-x


params:
  name: kong-spec-expose
  api_id: true
  service_id: true
  consumer_id: false
  route_id: true

  config:
    - name: spec_url
      required: true
      value_in_examples: https://github.com/OAI/OpenAPI-Specification/blob/master/examples/v2.0/json/petstore.json
      urlencode_in_examples: false
      default:
      description: The full path to the specification/documentation of your service.

###############################################################################
# END YAML DATA
# Beneath the next --- use Markdown (redcarpet flavor) and HTML formatting only.
#
# The remainder of this file is for free-form description, instruction, and
# reference matter.
# Your headers must be Level 3 or 4 (parsing to h3 or h4 tags in HTML).
# This is represented by ### or #### notation preceding the header text.
###############################################################################
# BEGIN MARKDOWN CONTENT
---

### Installation

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

### Maintainers

[jeremyjpj0916](https://github.com/jeremyjpj0916)  
[rsbrisci](https://github.com/rsbrisci)  

Feel free to [open issues](https://github.com/Optum/kong-spec-expose/issues), or refer to our [Contribution Guidelines](https://github.com/Optum/kong-spec-expose/blob/master/CONTRIBUTING.md) if you have any questions.
