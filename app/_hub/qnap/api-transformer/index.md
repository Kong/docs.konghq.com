---
name: API Transformer
publisher: QNAP Inc.
categories:
  - transformations
type: plugin
desc: Kong middleware to transform requests / responses, using Lua script.
description: |
    This is a Kong Plugin that transforms requests and responses depending on your own business requirements.
support_url: https://github.com/qnap-dev/kong-plugin-api-transformer/issues
source_url:  https://github.com/qnap-dev/kong-plugin-api-transformer
license_type: Apache-2.0
license_url: https://github.com/qnap-dev/kong-plugin-api-transformer/blob/master/LICENSE

kong_version_compatibility:
  community_edition:
    compatible:
      - 1.0.x
      - 1.1.x
      - 1.2.x
    incompatible:
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
  name: api-transformer
  service_id: True
  consumer_id: False
  route_id: True
  protocols: ["http", "https"] 
  dbless_compatible: yes 
  config:
    - name: request_transformer
      required: 'yes'
      default:
      value_in_examples: /home/foo/api_xxx/req_transformer.lua
      description: |
        The .lua script to be used for the transformation. 
        Available OpenResty variables and utils: [Check readme](https://github.com/qnap-dev/kong-plugin-api-transformer#for-developer)
    - name: response_transformer
      required: 'yes'
      default:
      value_in_examples: /home/foo/api_xxx/resp_transformer.lua
      description: |
        The .lua script to be used for the transformation. 
        Available OpenResty variables and utils: [Check readme](https://github.com/qnap-dev/kong-plugin-api-transformer#for-developer)
    - name: http_200_always
      required: 'no'
      default: true
      value_in_examples: true
      description: |
        We may need to use HTTP 200 approach in API error handling in some business cases.


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

## Kong Plugin API Transformer

For questions, details or contributions, please reach us at https://github.com/qnap-dev/kong-plugin-api-transformer


### request transformer example
```lua
local _req_uri = ngx.var.uri
local _req_method = ngx.req.get_method()
local _req_json_body = ngx.ctx.req_json_body

if _req_uri == string.match(_req_uri, ".-/folders") then
  -- modified body will pass to upstream
  if _req_method == "GET" then
    return true, '{"key": "GET /folders: body modified"}'
  elseif _req_method == "POST" then
    return true, '{"key": "POST /folders: body modified"}'
  end
else
  return false, "invalid request uri: " .. _req_uri
end
```

### response transformer example
```lua
local _req_uri = ngx.ctx.req_uri
local _req_method = ngx.ctx.req_method
local _req_json_body = ngx.ctx.req_json_body
local _resp_json_body = ngx.ctx.resp_json_body

if _req_uri == string.match(_req_uri, ".-/folders") then
  -- modified body will return to client
  if _req_method == "GET" then
    return true, '{"key": "GET /folders: body modified"}'
  elseif _req_method == "POST" then
    return true, '{"key": "POST /folders: body modified"}'
  end
else
  return false, "invalid request uri: " .. _req_uri
end
```

### Allowed Lua symbols in the transformer
```lua
  print
  assert
  error
  ipairs
  next
  pairs
  pcall
  select
  tonumber
  tostring
  type
  unpack
  xpcall
  string.byte
  string.char
  string.find
  string.format
  string.gmatch
  string.gsub
  string.len
  string.match
  string.rep
  string.reverse
  string.sub
  string.upper
  table.insert
  table.maxn
  table.remove
  table.sort
  table.insert
  table.concate
```

### Available OpenResty symbols in the transformer
```
ngx.ctx
ngx.var
ngx.req.get_headers
ngx.req.set_header
ngx.req.get_method
ngx.req.get_body_data
ngx.req.set_body_data
ngx.req.get_uri_args
ngx.req.set_uri_args
ngx.resp.get_headers
```


### Symbols which cached in ngx.ctx for the response transformer
This table `ngx.ctx` can be used to store per-request Lua context data and has a life time identical to the current request, so we use this table to store the necessary data for body_filter()

| Cached Symbols           | Coreresponding                             | Lua type |
|--------------------------|--------------------------------------------|----------|
| `ngx.ctx.req_uri`        | `ngx.var.uri`                              | string   |
| `ngx.ctx.req_method`     | `ngx.req.get_method()`                     | string   |
| `ngx.ctx.req_json_body`  | `_cjson_decode_(ngx.req.get_body_data())`  | table    |
| `ngx.ctx.resp_json_body` | `ngx.arg[1]`                               | talbe    |


### Convensions in writing the transformer

In the transformer, we need to return a Lua tuple: `(f_status, body_or_err)`, please check the detail via [test case](https://github.com/qnap-dev/kong-plugin-api-transformer/tree/master/spechttps://github.com/qnap-dev/kong-plugin-api-transformer/tree/master/spec).

```
if f_status == true then
  body_or_err = transformed_body
else
  body_or_err = error message
end
```
