---
title: Running the plugin in different phases
nav_title: Running in different phases
---

To run the Pre-function plugin in a specific phase, choose a `config.<phase_name>` parameter.
For example, to run in the `header_filter` phase, the parameter should be `config.header_filter`. 

It is possible to run the Pre-function plugin in multiple phases by configuring those phases in the plugin. 
For example, if you want to run code in the `access` and `header_filter` phases, configure the plugin like this,
pointing each parameter to your Lua code snippets:
 
```sh
curl -i -X POST https://localhost:8001/routes/<route_name>/plugins \
  --form "name=pre-function" \
  --form "config.access=@/tmp/access-serverless.lua" \
  --form "config.header_filter=@/tmp/header_filter-serverless.lua"
```