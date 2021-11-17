---
name: Kong on AWS with Terraform
publisher: Kong Inc.

categories:
  - deployment

type: integration

desc: Terraform module to provision Kong and Kong Gateway clusters on Amazon Web Services.

description: |
  Terraform module to provision Kong clusters in Amazon Web Service (AWS) using AWS best practices for architecture and security. Both Kong and Kong Gateway are supported. Available under the Apache License 2.0 license.

support_url: https://github.com/Kong/kong-terraform-aws/issues

source_url: https://github.com/kong/kong-terraform-aws

license_type: Apache-2.0

kong_version_compatibility:
    community_edition:
      compatible:
        - 2.4.x
        - 2.3.x
        - 2.2.x
        - 2.1.x
        - 2.0.x
        - 1.5.x
        - 1.4.x
        - 1.3.x
        - 1.2.x
        - 1.1.x
        - 1.0.x
        - 0.14.x
        - 0.13.x

    enterprise_edition:
      compatible:
        - 2.4.x
        - 2.3.x
        - 2.2.x
        - 2.1.x
        - 1.5.x
        - 1.3-x
        - 0.36-x


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

Details, prerequisites, and usage examples are provided on GitHub at
[https://github.com/kong/kong-terraform-aws](https://github.com/kong/kong-terraform-aws).
