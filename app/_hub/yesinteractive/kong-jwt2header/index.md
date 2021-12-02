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

source_url: https://github.com/yesinteractive/kong-jwt2header

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

params: 
  name: kong-jwt2header
  api_id: false
    # boolean - whether this plugin can be applied to an API [[this needs more]]
  service_id: false
    # boolean - whether this plugin can be applied to a Service.
    # Affects generation of examples and config table.
  consumer_id: false
    # boolean - whether this plugin can be applied to a Consumer.
    # Affects generation of examples and config table.
  route_id: false
    # whether this plugin can be applied to a Route.
    # Affects generation of examples and config table.
  protocols: ["http", "https"]
    # List of protocols this plugin is compatible with.
    # Valid values: "http", "https", "tcp", "tls"
    # Example: ["http", "https"]
  dbless_compatible: 'yes'
    # Degree of compatibility with DB-less mode. Three values allowed:
    # 'yes', 'no' or 'partially'
  dbless_explanation: Fully compatible with DB and DB-less (K8s, Declarative) Kong implementations.
    # Optional free-text explanation, usually containing details about the degree of
    # compatibility with DB-less.
    
  config:
    - name: strip_claims
      required: yes
      default: "`false`"
      value_in_examples: false
      description: If enabled, claims will be removed from headers before being sent to the upstream. By default, each claim is passed upstream in a header prefixed with `X-Kong-JWT-Claim`.
    - name: token_required
      required: yes
      default: "`true`"
      value_in_examples: true
      description: By default, `token_required` is set to `true`, and an error will be returned if a valid JWT is not present in the request. Set it to `false` if you want this plugin to fail open and proceed with executing the request, regardless of whether a valid JWT is present or not.

# BEGIN MARKDOWN CONTENT
---

## Installation & Usage

A tutorial, installation steps, and further information can be found at [https://github.com/yesinteractive/kong-jwt2header](https://github.com/yesinteractive/kong-jwt2header){:target="_blank"}{:rel="noopener noreferrer"}.
