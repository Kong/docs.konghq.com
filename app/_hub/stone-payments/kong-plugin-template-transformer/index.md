---
name: kong-plugin-template-transformer
publisher: stone-payments
categories:
  - transformations
type: plugin
desc: Kong middleware to transform requests / responses, using pre-configured templates.
description: |
    This is Kong plugins that accepts requests and response templates to completely transform requests and responses with Lua templates.
support_url: https://github.com/stone-payments/kong-plugin-template-transformer/issues
source_url:  https://github.com/stone-payments/kong-plugin-template-transformer
license_type: Apache-2.0
license_url: https://github.com/stone-payments/kong-plugin-template-transformer/blob/master/LICENSE

kong_version_compatibility:
  community_edition:
    compatible:
     - 0.13.x
     - 0.14.x
    incompatible:

params:
  name: kong-plugin-template-transformer
  api_id: False
  service_id: False
  consumer_id: False
  route_id: True
  config:
    - name: request_template
      required: 'no'
      default: nil
      value_in_examples: '{ "email": "{{body.user}}", "password": "{{body.password}}" }'
      description: |
        Describes the template to be used for the transformation. 
        Available nginx variables: headers, body, custom_data, route_groups, query_string.
    - name: response_template
      required: 'no'
      default: nil
      value_in_examples: '{ "status": "{{status}}", "message": "{{body.message}}" }'
      description: |
        Describes the template to be used for the transformation. 
        Available nginx variables: headers, body, status.
    - name: hidden_fields
      required: 'no'
      default: nil
      value_in_examples: ["password"]
      description: |
        Fields to hide in the nginx logs.
---

### Kong Plugin Template Transformer

For questions, details or contributions, please reach us at https://github.com/stone-payments/kong-plugin-template-transformer
