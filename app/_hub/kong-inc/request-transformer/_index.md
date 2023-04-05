---
name: Request Transformer
publisher: Kong Inc.
desc: Use regular expressions, variables, and templates to transform requests
description: |
  The Request Transformer plugin for Kong allows simple transformation of requests
  before they reach the upstream server. These transformations can be simple substitutions
  or complex ones matching portions of incoming requests using regular expressions, saving
  those matched strings into variables, and substituting those strings into transformed requests using flexible templates.

  For additional request transformation features, check out the
  [Request Transformer Advanced plugin](/hub/kong-inc/request-transformer-advanced/).
  With the advanced plugin, you can also limit the list of allowed parameters in the request body.

type: plugin
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
---
