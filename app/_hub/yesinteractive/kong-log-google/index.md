---
name: Google Analytics Log
publisher: Yes Interactive

categories: # (required) Uncomment all that apply.
  #- authentication
  #- security
  #- traffic-control
  #- serverless
  #- analytics-monitoring
  #- transformations
  - logging
  #- deployment

type: plugin

desc: Log API transactions to Google Analytics
description: This plugin logs your Kong gateway transactions to Google Analytics. This plugin is a modification of the [Kong HTTP Log plugin](/hub/kong-inc/http-log/).

support_url: https://github.com/yesinteractive/kong-log-google/issues

source_url: https://github.com/yesinteractive/kong-log-google

license_type: MIT

kong_version_compatibility:
  community_edition:
    compatible:
      - 2.1.x
      - 2.0.x
      - 1.5.x
      - 1.4.x
      - 1.3.x
  enterprise_edition:
    compatible:
      - 1.5.x
      - 1.3-x

params: 
  name: kong-log-google
  api_id: false
    # boolean - whether this plugin can be applied to an API [[this needs more]]
  service_id: true
    # boolean - whether this plugin can be applied to a Service.
    # Affects generation of examples and config table.
  consumer_id: false
    # boolean - whether this plugin can be applied to a Consumer.
    # Affects generation of examples and config table.
  route_id: true
    # whether this plugin can be applied to a Route.
    # Affects generation of examples and config table.
  protocols: ["http", "https"]
    # List of protocols this plugin is compatible with.
    # Valid values: "http", "https", "tcp", "tls"
    # Example: ["http", "https"]
  dbless_compatible: yes
    # Degree of compatibility with DB-less mode. Three values allowed:
    # 'yes', 'no' or 'partially'
  dbless_explanation: Fully compatible with DB and DB-less (K8s, Declarative) Kong implementations.
    # Optional free-text explanation, usually containing details about the degree of
    # compatibility with DB-less.
    
  config:
    - name: tid
      required: yes
      default: UA-XXXX-Y
      value_in_examples: UA-XXXX-Y
      description: The tracking ID / property ID. The format is UA-XXXX-Y. All collected data is associated by this ID.
    - name: cid
      required: yes
      default: 555
      value_in_examples: 555
      description: Client ID. This allows you to set and identify metrics in Google Analytics by a custom client ID.

# BEGIN MARKDOWN CONTENT
---

## Installation & Usage

A tutorial, installation steps, and further information can be found at [https://github.com/yesinteractive/kong-log-google](https://github.com/yesinteractive/kong-log-google){:target="_blank"}{:rel="noopener noreferrer"}.
