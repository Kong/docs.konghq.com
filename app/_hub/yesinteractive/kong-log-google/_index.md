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

source_code: https://github.com/yesinteractive/kong-log-google

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

# BEGIN MARKDOWN CONTENT
---

## Installation & Usage

A tutorial, installation steps, and further information can be found at [https://github.com/yesinteractive/kong-log-google](https://github.com/yesinteractive/kong-log-google){:target="_blank"}{:rel="noopener noreferrer"}.
