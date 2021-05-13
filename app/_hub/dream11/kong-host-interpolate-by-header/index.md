---
name:  Host Interpolate by Header
publisher: Dream11
categories:
  - transformations
type: plugin
desc: Kong middleware to transform host of upstream service based on incoming request headers.
description: |
    When using Kong, host of upstream service is hardcoded and cannot be modified dynamically. This plugin updates the host dynamically by interpolating incoming request's headers based on specified operation.
support_url: https://github.com/dream11/kong-host-interpolate-by-header/issues
source_url:  https://github.com/dream11/kong-host-interpolate-by-header
license_type: MIT
license_url: https://github.com/dream11/kong-host-interpolate-by-header/blob/master/LICENSE

kong_version_compatibility:
  community_edition:
    compatible:
     - 2.1.x
     - 2.2.x
    incompatible:
kong_version_compatibility:
 community_edition:
   compatible:
     - 2.1.x
     - 2.2.x
     - 2.3.x
 enterprise_edition:
   compatible:
     - 2.1.x
     - 2.2.x
     - 2.3.x

params:
  name: host-interpolate-by-header
  service_id: true
  consumer_id: false
  route_id: true
  config:
    - name: host
      required: true
      datatype: string
      description: Hostname of upstream service
    - name: headers
      required: true
      datatype: array
      description: Array of request headers to read for interpolation
    - name: operation
      required: false
      datatype: string
      description: Operation to apply on header value (none/modulo)
    - name: modulo_by
      required: false
      datatype: integer
      default: 1
      description: Number to do modulo by, when operation = modulo
    - name: fallback_host
      required: false
      datatype: string
      description: Route request to fallback_host if any of the headers is missing in request else error is returned with status code 422
        

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

For questions, details or contributions, please reach us at https://github.com/dream11/kong-host-interpolate-by-header

### Installation
Recommended:

```bash
$ luarocks install host-interpolate-by-header
```