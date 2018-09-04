---
# This file is for profiling an individual Kong extension.
# Duplicate this file in your own *publisher path* on your own branch.
# Your publisher path is relative to _app/_catalog/.
# The path must consist only of alphanumeric characters and hyphens (-).
#
# The following YAML data must be filled out as prescribed by the comments
# on individual parameters. Also see documentation at:
# https://github.com/Kong/docs.konghq.com
# Remove inapplicable entries and superfluous comments as needed

name: Okta

categories: # (required) Uncomment all that apply.
  - authentication
  #- security
  #- traffic-control
  #- serverless
  #- analytics-monitoring
  #- transformations
  #- logging
# Array format only; uncomment one or more applicable categories.
# If you would like to add a category, you may do so here.

type:  # (required) String, one of:
  # plugin          | extensions of the core platform
  # integration     | extensions of the Kong Admin API
  # dev-mod         | enhancements of the Kong dev portal

desc: Integrate Okta's API Access Management (OAuth as a Service) with Kong API Gateway. # (required) 1-liner description; max 80 chars
description: |
  [This integration guide](https://github.com/tom-smith-okta/okta-api-center/tree/master/gateways/kong) describes how to integrate Okta's API Access Management (OAuth as a Service) with Kong API Gateway.

  The integration described here is an authorization-tier integration; authentication will be happening outside of Kong. A web application will handle authentication vs. Okta, acquiring an access token, and sending that access token to Kong on behalf of the end-user.

support_url: https://github.com/tom-smith-okta/okta-api-center/issues
  # (Optional) A specific URL of your own for this extension.
  # Defaults to the url setting in your publisher profile.

source_url: https://github.com/tom-smith-okta/okta-api-center/tree/master/gateways/kong
  # (Optional) If your extension is open source, provide a link to your code.

#license_type:
  # (Optional) For open source, use the abbreviations in parentheses at:
  # https://opensource.org/licenses/alphabetical

#license_url:
  # (Optional) Link to your custom license.

#privacy_policy:
  # (Optional) If you have a custom privacy policy, place it here

#privacy_policy_url:
  # (Optional) Link to a remote privacy policy

#terms_of_service:
  # (Optional) Text describing your terms of service.

#terms_of_service_url:
  # (Optional) Link to your online TOS.

kong_version_compatibility:
    community_edition:
      compatible:
      incompatible:
        - 0.14.x
        - 0.13.x
        - 0.12.x
        - 0.11.x
        - 0.10.x
        - 0.9.x
        - 0.8.x
        - 0.7.x
        - 0.6.x
        - 0.5.x
        - 0.4.x
        - 0.3.x
        - 0.2.x
    enterprise_edition:
      compatible:
        - 0.34-x
        - 0.33-x
        - 0.32-x
      incompatible:
        - 0.31-x
        - 0.30-x
        - 0.29-x

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
