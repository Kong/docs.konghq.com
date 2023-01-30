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

source_code: https://github.com/Optum/kong-response-size-limiting/

license_type: Apache-2.0

kong_version_compatibility:
  community_edition:
    compatible:
      - 0.14.x

  enterprise_edition:
    compatible:
      - 0.34-x
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

```bash
$ luarocks install kong-response-size-limiting
```

Other:

```bash
$ git clone https://github.com/Optum/kong-response-size-limiting.git /path/to/kong/plugins/kong-response-size-limiting
$ cd /path/to/kong/plugins/kong-response-size-limiting
$ luarocks make *.rockspec
```

### Maintainers
[jeremyjpj0916](https://github.com/jeremyjpj0916){:target="_blank"}{:rel="noopener noreferrer"}  
[rsbrisci](https://github.com/rsbrisci){:target="_blank"}{:rel="noopener noreferrer"}

Feel free to [open issues](https://github.com/Optum/kong-response-size-limiting/issues){:target="_blank"}{:rel="noopener noreferrer"}, or refer to our [Contribution Guidelines](https://github.com/Optum/kong-response-size-limiting/blob/master/CONTRIBUTING.md){:target="_blank"}{:rel="noopener noreferrer"} if you have any questions.
