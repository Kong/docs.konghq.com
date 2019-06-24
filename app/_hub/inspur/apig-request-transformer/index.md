--- 
 
name: Inspur Request Transformer 
 
publisher: Inspur 
 
categories: 
  - transformations 
 
type: plugin 
 
desc: Kong plugin to transform diversiform requests 
description: | 
 
  Transform the request sent by a client on the fly on Kong, before hitting the upstream server. 
   
  The plugin implements parameter transformations and additions of various positions. 
 
support_url: https://github.com/cheriL/apig-request-transformer/issues 
 
source_url: https://github.com/cheriL/apig-request-transformer 
 
license_type: Apache-2.0 
 
kong_version_compatibility: 
  community_edition: 
    compatible: 
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
 
params: 
  name: apig-request-transformer 
  api_id: false 
  service_id: true 
  consumer_id: false 
  route_id: true 
  protocols: ["http", "https"] 
  dbless_compatible: yes 
  dbless_explanation: It is recommended to use in dbless mode. 
  config: 
    - name: httpMethod 
      required: true 
      default: 
      value_in_examples: POST 
      description: Changes the HTTP method for the upstream request.
    - name: backendContentType 
      required: false 
      default: 
      value_in_examples: application/json 
      description: Changes Content-Type for the upstream request.
    - name: requestPath 
      required: false 
      default: 
      value_in_examples: /requestPath/[pageId]/[userId] 
      description: It is used with [config.pathParams] to extract values from the request URI.
    - name: backendPath 
      required: false 
      default: 
      value_in_examples: /servicePath/[pageId]/[userId] 
      description: Updates the the path part of the upstream request URI with values.
    - name: pathParams 
      required: semi 
      default: 
      value_in_examples: ["pageId", "userId"] 
      description: List of parameters' names of the request URI.
    - name: replace 
      required: false 
      default: 
      value_in_examples: ["head:h1;query:param1", "path:pageId;query:param2"] 
      description: List of parameter mappings. Replace its old value with the new one at different locations.
    - name: add 
      required: false 
      default: 
      value_in_examples: ["head:h1:v1", "query:param1:value1"] 
      description: List of constant parameters. Set a new header or a new querystring with the given value. 
  extra: 
    # This is for additional remarks about your configuration. 
############################################################################### 
# END YAML DATA 
# Beneath the next --- use Markdown (redcarpet flavor) and HTML formatting only. 
# 
# The remainder of this file is for free-form description, instruction, and 
# reference matter. 
# If you include headers, your headers MUST start at Level 2 (parsing to 
# h2 tag in HTML). Heading Level 2 is represented by ## notation 
# preceding the header text. Subsequent headings, 
# if you choose to use them, must be properly nested (eg. heading level 2 may 
# be followed by another heading level 2, or by heading level 3, but must NOT be 
# followed by heading level 4) 
############################################################################### 
# BEGIN MARKDOWN CONTENT 
--- 
 
### Installation 
Recommended: 
 
```bash 
$ git clone https://github.com/cheriL/apig-request-transformer /opt/kong/plugins 
$ cd /opt/kong/plugins/apig-request-transformer 
$ luarocks make 
``` 
