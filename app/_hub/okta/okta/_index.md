---
name: Okta
publisher: Okta

categories:
  - authentication

type: integration

enterprise: true

desc: Integrate Okta's API Access Management (OAuth as a Service) with Kong API Gateway.

description: |
  [This integration guide](https://github.com/tom-smith-okta/okta-api-center/tree/master/gateways/kong){:target="_blank"}{:rel="noopener noreferrer"} describes how to integrate Okta's API Access Management (OAuth as a Service) with Kong API Gateway.

  The integration described here is an authorization-tier integration; authentication will be happening outside of Kong. A web application will handle authentication vs. Okta, acquiring an access token, and sending that access token to Kong on behalf of the end-user.

support_url: https://github.com/tom-smith-okta/okta-api-center/issues

source_code: https://github.com/tom-smith-okta/okta-api-center/tree/master/gateways/kong

kong_version_compatibility:
    community_edition:
      compatible:

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
