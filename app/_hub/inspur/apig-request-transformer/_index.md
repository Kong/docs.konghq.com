---

name: Inspur Request Transformer

publisher: Inspur

categories:
  - transformations

type: plugin

desc: Kong plugin to transform diversiform requests
description: |

  Transform the request sent by a client on the fly on Kong, before hitting the upstream server.

  The plugin implements parameter transformations and additions of various positions.

support_url: https://github.com/cheriL/apig-request-transformer/issues

source_code: https://github.com/cheriL/apig-request-transformer

license_type: Apache-2.0

kong_version_compatibility:
  community_edition:
    compatible:
      - 1.2.x
      - 1.1.x
###############################################################################
# END YAML DATA
# Beneath the next --- use Markdown (redcarpet flavor) and HTML formatting only.
#
# The remainder of this file is for free-form description, instruction, and
# reference matter.
# If you include headers, your headers MUST start at Level 2 (parsing to
# h2 tag in HTML). Heading Level 2 is represented by ## notation
# preceding the header text. Subsequent headings,
# if you choose to use them, must be properly nested (eg. heading level 2 may
# be followed by another heading level 2, or by heading level 3, but must NOT be
# followed by heading level 4)
###############################################################################
# BEGIN MARKDOWN CONTENT
---

### Installation
Recommended:

```bash
$ git clone https://github.com/cheriL/apig-request-transformer /opt/kong/plugins
$ cd /opt/kong/plugins/apig-request-transformer
$ luarocks make
```
