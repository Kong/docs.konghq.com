---
name: Kong on AWS with Terraform
publisher: Kong Inc.

categories:
  - deployment

type: integration

desc: Terraform module to provision Kong and Kong Enterprise clusters on Amazon Web Services.

description: |
  Terraform module to provision Kong clusters in Amazon Web Service (AWS) using AWS best practices for architecture and security. Both Kong and Kong Enterprise are supported. Available under the Apache License 2.0 license.

support_url: https://github.com/Kong/kong-terraform-aws/issues

source_url: https://github.com/kong/kong-terraform-aws

license_type: Apache-2.0

kong_version_compatibility:
    community_edition:
      compatible:
        - 1.4.x
        - 1.3.x
        - 1.2.x
        - 1.1.x
        - 1.0.x
        - 0.14.x
        - 0.13.x
#      incompatible:
#        - 0.13.x
#        - 0.12.x
#        - 0.11.x
#        - 0.10.x
#        - 0.9.x
#        - 0.8.x
#        - 0.7.x
#        - 0.6.x
#        - 0.5.x
#        - 0.4.x
#        - 0.3.x
#        - 0.2.x
    enterprise_edition:
      compatible:
        - 1.5.x
        - 1.3-x
        - 0.36-x
        - 0.35-x
        - 0.34-x
        - 0.33-x
        - 0.32-x
#      incompatible:
#        - 0.32-x
#        - 0.31-x
#        - 0.30-x
#        - 0.29-x

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

### Documentation

Details, prerequisites, and usage examples are provided at https://github.com/kong/kong-terraform-aws
