---

name: EE Request Transformer

desc: Use powerful regular expressions, variables and templates to transform API requests
description: |
  The Request Transformer plugin for Kong Enterprise Edition builds on the Community Edition version of this plugin with enhanced capabilities to match portions of incoming requests using regular expressions, save those matched strings into variables, and substitute those strings into transformed requests via flexible templates.

  * [Detailed documentation for the EE Request Transformer Plugin](/enterprise/latest/plugins/request-transformer)

enterprise: true
type: plugin
categories:
  - transformations

kong_version_compatibility:
    community_edition:
      compatible:
    enterprise_edition:
      compatible:
        - 0.34-x
        - 0.33-x
        - 0.32-x

---
