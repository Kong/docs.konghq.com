---

name: Inspur Monitoring
publisher: Inspur
categories: # (required) Uncomment ONE that applies.
  - logging

type: # (required) String, one of:
   plugin          | extensions of the core platform

desc: kong plugin to record metric of an api and send by http request
description: |
    This plugin record the metrics of an api,such as the request count, the number of response code with 2xx,4xx and 5xx,the number of error request,the ingress and egress traffic data and the time of response.Then use a post http request whose request body is the json format of the metrics, to send to the destination address.

support_url: https://github.com/kakascx/apig-monitoring/issues

source_url: https://github.com/kakascx/apig-monitoring

license_type: Apache-2.0

license_url: https://github.com/kakascx/apig-monitoring/blob/main/LICENSE


kong_version_compatibility:
  community_edition:
    compatible:
     - 2.2.x
     - 2.1.x
     - 2.0.x
     - 1.5.x
     - 1.4.x
     - 1.3.x 
     - 1.2.x
     - 1.1.x
    incompatible:
     - 1.0.x
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
params: # Metadata about your plugin
  name: # Name of the plugin in Kong (may differ from name: above)
  service_id: True
  consumer_id: False
  route_id: True
  protocols: ["http", "https"]
  dbless_compatible: yes
  dbless_explanation: It is recommended to use in dbless mode.
  yaml_examples:
  k8s_examples:
  examples:
  config: # Configuration settings for your plugin
    - name: httpEndpoint
      required: yes
      default: # any type - the default value (non-required settings only)
      datatype: string # specify the type of the value: e.g., string, array, boolean, etc.
      description: the destination address sent the metric data

  extra:
---

