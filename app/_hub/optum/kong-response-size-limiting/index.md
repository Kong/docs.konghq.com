---
name: Kong Response Size Limiting
publisher: Optum

desc: Block responses with bodies greater than a specified size
description: |

  Block upstream responses whose body is greater than a specific size in megabytes.

  Proxy consumers will receive an HTTP Status of 413 and message body "Response size limit exceeded" in the event the body is greater than configured size.

type: plugin
categories:
  - traffic-control

support_url: https://github.com/Optum/kong-response-size-limiting/issues

source_url: https://github.com/Optum/kong-response-size-limiting/

license_type: Apache-2.0

kong_version_compatibility:
  community_edition:
    compatible:
      - 0.14.x
    incompatible:
      - 0.13.x
      - 0.12.x
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
    incompatible:
      - 0.33-x
      - 0.32-x
      - 0.31-x
      - 0.30-x
      - 0.29-x

params:
  name: kong-response-size-limiting
  api_id: false
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: allowed_payload_size
      required: true
      default: "`128`"
      value_in_examples: 128
      description: Allowed upstream response payload size in megabytes, default is `128` (128000000 Bytes)

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

### Caveat
This plugin currently accomplishes response limiting by validating the Content-Length header on upstream responses.
If the upstream lacks the response header, then this plugin will allow the response to pass.

### Installation
Recommended:

```
$ luarocks install kong-response-size-limiting
```

Other:

```
$ git clone https://github.com/Optum/kong-response-size-limiting.git /path/to/kong/plugins/kong-response-size-limiting
$ cd /path/to/kong/plugins/kong-response-size-limiting
$ luarocks make *.rockspec
```

### Maintainers
[jeremyjpj0916](https://github.com/jeremyjpj0916)  
[rsbrisci](https://github.com/rsbrisci)  

Feel free to [open issues](https://github.com/Optum/kong-response-size-limiting/issues), or refer to our [Contribution Guidelines](https://github.com/Optum/kong-response-size-limiting/blob/master/CONTRIBUTING.md) if you have any questions.
