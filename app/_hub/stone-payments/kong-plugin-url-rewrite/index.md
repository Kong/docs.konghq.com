---
name:  URL Rewrite
publisher: stone-payments
categories:
  - transformations
type: plugin
desc: Kong middleware to completely rewrite the URL of a route.
description: |
    When using Kong, you can create routes that proxy to an upstream. The problem lies when the upstream has an url that is not very friendly to your clients, or restful, or even pretty. When you add a Route in Kong, you have a somewhat limited url rewrite capability. This plugin simply throws away the url set in Kong route and uses the url set in it's configuration to proxy to the upstream. This gives you full freedom as to how to write your url's in Kong and inner services as well.
support_url: https://github.com/stone-payments/kong-plugin-url-rewrite/issues
source_url:  https://github.com/stone-payments/kong-plugin-url-rewrite
license_type: Apache-2.0
license_url: https://github.com/stone-payments/kong-plugin-url-rewrite/blob/master/LICENSE

kong_version_compatibility:
  community_edition:
    compatible:
     - 0.13.x
     - 0.14.x
    incompatible:
  enterprise_edition:
    compatible:
      - 0.32-x
      - 0.33-x
    incompatible:

params:
  name: kong-plugin-url-rewrite
  api_id: True
  service_id: True
  consumer_id: False
  route_id: True
  config:
    - name: url
      required: 'yes'
      default: ''
      value_in_examples: 'http://new-url.com'
      description: |
        The url that you want to execute the request against. Completely overrides the upstream_uri property.
---

## Kong Plugin URL Rewrite

For questions, details or contributions, please reach us at https://github.com/stone-payments/kong-plugin-url-rewrite
