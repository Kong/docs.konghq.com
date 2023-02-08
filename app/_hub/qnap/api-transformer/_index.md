---
name: API Transformer
publisher: QNAP Inc.
categories:
  - transformations
type: plugin
desc: Kong middleware to transform requests / responses, using Lua script.
description: |
    This is a Kong Plugin that transforms requests and responses depending on your own business requirements.
support_url: https://github.com/qnap-dev/kong-plugin-api-transformer/issues
source_code:  https://github.com/qnap-dev/kong-plugin-api-transformer
license_type: Apache-2.0
license_url: https://github.com/qnap-dev/kong-plugin-api-transformer/blob/master/LICENSE

kong_version_compatibility:
  community_edition:
    compatible:
      - 1.0.x
      - 1.1.x
      - 1.2.x

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
