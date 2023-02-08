---
name: Kong Splunk Log
publisher: Optum

categories:
  - logging

type: plugin

desc: Log API transactions to Splunk using the Splunk HTTP collector

description: |
  Kong provides many great logging tools out of the box - this is a modified version of the Kong HTTP logging plugin that has been refactored and tailored to work with Splunk.

support_url: https://github.com/Optum/kong-splunk-log/issues

source_code: https://github.com/Optum/kong-splunk-log

license_type: Apache-2.0

kong_version_compatibility:
  community_edition:
    compatible:
      - 0.14.x
      - 0.13.x

  enterprise_edition:
    compatible:
      - 0.34-x
      - 0.33-x
      - 0.32-x

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
