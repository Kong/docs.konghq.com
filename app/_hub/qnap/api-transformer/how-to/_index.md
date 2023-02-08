## Kong Plugin API Transformer

For questions, details or contributions, please reach us via the [API Transformer GitHub repo](https://github.com/qnap-dev/kong-plugin-api-transformer){:target="_blank"}{:rel="noopener noreferrer"}.


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

In the transformer, we need to return a Lua tuple: `(f_status, body_or_err)`, please check the detail via [test case](https://github.com/qnap-dev/kong-plugin-api-transformer/tree/master/spec){:target="_blank"}{:rel="noopener noreferrer"}.

```
if f_status == true then
  body_or_err = transformed_body
else
  body_or_err = error message
end
```
