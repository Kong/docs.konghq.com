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
description: This Kong Plugin can be used to route requests by JWT claim. It does this by converting JWT claims to headers during rewrite phase so that Kong's route by header functionality can be used to route the request appropriately. Alternatively, the plugin can be used to simply convert JWT claims to headers so those claims can be consumed by the upstream service as headers. Since this plugin has elements that must run in the Rewrite execution phase, this plugin can only be configured to run globally in a Kong workspace or cluster. Can be used in conjunction with other JWT validation/authentication plugins.

support_url: https://github.com/yesinteractive/kong-jwt2header/issues

source_url: https://github.com/yesinteractive/kong-jwt2header

license_type: MIT

kong_version_compatibility:
  community_edition:
    compatible:
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
  service_id: fa;se
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
  dbless_compatible: true
    # Degree of compatibility with DB-less mode. Three values allowed:
    # 'yes', 'no' or 'partially'
  dbless_explanation: Fully compatible with DB and DB-less (K8s, Declarative) Kong implementations.
    # Optional free-text explanation, usually containing details about the degree of
    # compatibility with DB-less.
    
  config:
    - name: strip_claims
      required: yes
      default: false
      value_in_examples: false
      description: If enabled, claims will be removed from headers before being sent to the upstream.	Default behavior is to pass each claims upstream in a header prefixed with X-Kong-JWT-Claim
    - name: token_required
      required: yes
      default: true
      value_in_examples: true
      description: If enabled, an error will be returned if a valid JWT token is not present in the request. Set to false if you want this plugin to fail open and proceed execution of request regardless if a valid JWT is present.

# BEGIN MARKDOWN CONTENT
---

## Installation & Usage

A tutorial, installation steps, and further information can be found at [https://github.com/yesinteractive/jwt2header](https://github.com/yesinteractive/jwt2header).
