---
name: JWT to Header (Route by JWT Claim)
publisher: Yes Interactive

categories: # (required) Uncomment all that apply.
  #- authentication
  #- security
  - traffic-control
  #- serverless
  #- analytics-monitoring
  #- transformations
  #- logging
  #- deployment

type: plugin

desc: Convert JWT Claims to Headers for upstream consumption or to route by JWT Claims
description: |
  This plugin converts JWT claims into headers during the rewrite phase. This is useful for:
    * Routing requests by JWT claim, so that Kong's route by header functionality can route the request appropriately.
    * Allowing the upstream service to consume claims as headers.
  Since this plugin has elements that must run in the Rewrite execution phase, it can only be configured to run globally in a Kong workspace or cluster.
  This plugin can be used in conjunction with other JWT validation/authentication plugins.

support_url: https://github.com/yesinteractive/kong-jwt2header/issues

source_code: https://github.com/yesinteractive/kong-jwt2header

license_type: MIT

kong_version_compatibility:
  community_edition:
    compatible:
      - 2.1.x
      - 2.0.x
      - 1.5.x
  enterprise_edition:
    compatible:
      - 1.5.x
      - 1.3-x

# BEGIN MARKDOWN CONTENT
---
