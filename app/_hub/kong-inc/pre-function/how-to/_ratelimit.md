---
nav_title: Set rate limit based on peak or non-peak time
title: Set rate limit based on peak or non-peak time 
---

You can set the rate limit based on peak or non-peak time using the pre-function plugin. The plugin can be applied to individual services, routes, or globally.

## Prerequisites

* The JSON responses shown in this guide are formatted using [jq](https://stedolan.github.io/jq/) to make them easier to read. While useful, this tool is 
not necessary to complete the tasks of this tutorial. If you want to use jq to format your responses, add `| jq` to the end of each command.
* [Pre-function plugin](/hub/kong-inc/pre-function) 
plugin also known as Kong Functions, Pre-Plugin lets you dynamically run Lua code from Kong, before other plugins in each phase.

## Configure rate limit for peak or non-peak time

1. Create a workspace named `teamA`:
   ```bash
   curl --request POST \
    --url http://localhost:8001/workspaces \
    --data "name=teamA"
   ```
   The results should look like this:
   ```json
   {
  "id": "dc6018c2-4c47-4c16-aa63-bf85babfc346",
  "config": {
    "portal_reset_email": null,
    "portal_approved_email": null,
    "portal_access_request_email": null,
    "portal_cors_origins": null,
    "portal_invite_email": null,
    "portal_auto_approve": null,
    "portal_token_exp": null,
    "portal_developer_meta_fields": "[{\"label\":\"Full Name\",\"title\":\"full_name\",\"validator\":{\"required\":true,\"type\":\"string\"}}]",
    "portal_auth_conf": null,
    "portal_is_legacy": null,
    "portal_auth": null,
    "portal_session_conf": null,
    "portal_smtp_admin_emails": null,
    "portal_emails_reply_to": null,
    "portal_emails_from": null,
    "portal_reset_success_email": null,
    "portal_application_status_email": null,
    "portal": false,
    "portal_application_request_email": null,
    "meta": null
  },
  "name": "teamA",
  "meta": {
    "color": null,
    "thumbnail": null
  },
  "updated_at": 1702026459,
  "created_at": 1702026459,
  "comment": null
  }
  ```
1. Create a service named `httpbin`:
   ```bash
   curl --request POST \
    --url http://localhost:8001/teamA/services \
    --data "name=httpbin" \
    --data "url=http://httpbin.org/anything"
   ```
   The results should look like this:
   ```json
   {
   "path": "/anything",
   "connect_timeout": 60000,
   "read_timeout": 60000,
   "host": "httpbin.org",
   "protocol": "http",
   "write_timeout": 60000,
   "created_at": 1702026553,
   "retries": 5,
   "tls_verify": null,
   "updated_at": 1702026553,
   "tls_verify_depth": null,
   "id": "0ce0d7f9-8b60-409f-b576-6361661adee4",
   "port": 80,
   "enabled": true,
   "tags": null,
   "ca_certificates": null,
   "client_certificate": null,
   "name": "httpbin"
   }
  ```
1. Create a route named `route1` for the service `httpbin` and then set the value of `Headers` field to `X-Peak` with header value as `true`:
   ```bash
   curl --request POST \
    --url http://localhost:8001/teamA/services/httpbin/routes \
    --data "name=route1" \
    --data "paths=/httpbin"
   ```
  The results should look like this:
  ```json
  {
  "methods": null,
  "sources": null,
  "destinations": null,
  "headers": {
    "X-Peak": [
      "true"
    ]
  },
  "name": "route1",
  "request_buffering": true,
  "response_buffering": true,
  "created_at": 1702028666,
  "regex_priority": 0,
  "https_redirect_status_code": 426,
  "service": {
    "id": "0ce0d7f9-8b60-409f-b576-6361661adee4"
  },
  "hosts": null,
  "tags": [],
  "id": "3411c826-bd1e-48eb-83b2-23a3246623aa",
  "path_handling": "v0",
  "snis": null,
  "strip_path": true,
  "protocols": [
    "http",
    "https"
  ],
  "paths": [
    "/httpbin"
  ],
  "preserve_host": false,
  "updated_at": 1702028851
  }
  ```
1. Create a route named `route2` for the service `httpbin` and then set the value of `Headers` field to `X-Off-Peak` with header value as `true`:
   ```bash
   curl --request POST \
    --url http://localhost:8001/teamA/services/httpbin/routes \
    --data "name=route2" \
    --data "paths=/httpbin"
   ```
  The results should look like this:
  ```json
   {
  "methods": null,
  "sources": null,
  "destinations": null,
  "headers": {
    "X-Off-Peak": [
      "true"
    ]
  },
  "name": "route2",
  "request_buffering": true,
  "response_buffering": true,
  "created_at": 1701860733,
  "regex_priority": 0,
  "https_redirect_status_code": 426,
  "service": {
    "id": "d361ea74-6aa8-4107-85cb-384ab69011af"
  },
  "hosts": null,
  "tags": [],
  "id": "41176310-e980-4b4a-974d-9b1321f89b49",
  "path_handling": "v0",
  "snis": null,
  "strip_path": true,
  "protocols": [
    "http",
    "https"
  ],
  "paths": [
    "/httpbin"
  ],
  "preserve_host": false,
  "updated_at": 1701860808
   }  
  ```  
1. Enable the pre-function plugin:
   ```bash
   curl --request POST \
  --url http://localhost:8001/teamA/services/httpbin/plugins \
   --data "name=pre-function"  \
   --data "config.access=kong.log.err(\"foo\")
   kong.response.exit(418)"
   ```
   The results should look like this:
   ```json
   {
  "ordering": null,
  "consumer_group": null,
  "instance_name": null,
  "tags": null,
  "config": {
    "header_filter": [],
    "ws_close": [],
    "body_filter": [],
    "ws_handshake": [],
    "certificate": [],
    "ws_client_frame": [],
    "rewrite": [],
    "log": [],
    "access": [
      "kong.log.err(\"foo\")\nkong.response.exit(418)\n"
    ],
    "ws_upstream_frame": []
  },
  "name": "pre-function",
  "id": "4a6dbb09-28dc-4d00-902e-8a6632e4a9b0",
  "consumer": null,
  "route": null,
  "updated_at": 1702029037,
  "protocols": [
    "grpc",
    "grpcs",
    "http",
    "https"
  ],
  "enabled": true,
  "created_at": 1702029037,
  "service": {
    "id": "0ce0d7f9-8b60-409f-b576-6361661adee4"
  }
  }
   ```
1. Create a file named `test.lua` with the following code:
   ```
   local hour = os.date("*t").hour if hour >= 8 and hour <= 17 then kong.service.request.set_header("X-Peak","true") else kong.service.request.set_header("X-Off-Peak","true") end
   ```
1. Run the plugin in rewrite phase:
   ```bash
   curl -i -X POST https://localhost:8001/teamA/routes/route1/plugins \
    --form "name=pre-function" \   
    --form "config.rewrite=test.lua" \           
    --form "config.header_filter=test.lua"
   ``` 
   The response should look like this:
   ```txt
   curl: (35) OpenSSL/3.1.3: error:0A00010B:SSL routines::wrong version number
   ```         
