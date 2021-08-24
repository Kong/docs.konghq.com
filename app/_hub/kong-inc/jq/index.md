---
name: Kong jq
publisher: Kong Inc.
versions: 0.1.x
beta: true

desc: Provides arbitrary jq transformations to a JSON object.
description: |
    Provides arbitrary jq transformations to a JSON object. The source of the object can either be the request or response body, and the transformed result can either replace the body or be used to set HTTP headers.

    Multiple filters can be specified in the configuration. You can use these filters to set request headers from values present in the request body, and then rewrite the response body with a separate jq program.

enterprise: true
type: plugin
categories:
 - transformations

kong_version_compatibility:
    enterprise_edition:
      compatible: 
        - 2.6.x

params:
  name: jq
  service_id: 
  route_id:
  consumer_id:
  protocols: ["http","https"]
  dbless_compatible:
  config:
    - name: filters
      required: true
      datatype: array of records
      default:
      description: |


---


