project='Public Lua API Reference'
title='For plugins developers and core contributors'
format='markdown'
template='.'
dir='lua-reference'
sort=true
sort_modules=true
not_luadoc=true
all=false

local lua_nginx_module_url = "https://github.com/openresty/lua-nginx-module"
custom_see_handler('^ngx%.(%w*)$', function (section)
  return "ngx."..section, lua_nginx_module_url.."#ngx"..section
end)

--custom_see_handler('([%w_]*)', function (thing)
--  return thing, "#"..thing
--end)
