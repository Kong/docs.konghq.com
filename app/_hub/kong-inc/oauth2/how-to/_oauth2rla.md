---
nav_title: Set rate limit for Oauth2 tokens
title: Set rate limit for Oauth2 tokens 
---

You can limit the tokens created in the OAuth2 plugin by using the Rate Limiting Advanced (RLA) plugin.

{:.note}
> **Note**: You can't configure a limit on the number of tokens that are created in the OAuth2 plugin.

## Prerequisites

* The JSON responses shown in this guide are formatted using [jq](https://stedolan.github.io/jq/) to make them easier to read. While useful, this tool is 
not necessary to complete the tasks of this tutorial. If you want to use jq to format your responses, add `| jq` to the end of each command.
* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced) <span class="badge enterprise"></span> 
plugin. The advanced version provides additional features like support for the sliding window algorithm
and advanced Redis support for greater performance. Ensure that you have installed {{site.ee_product_name}}.

## Configure rate limit for Oauth2 tokens

1. Create a workspace named `teamA`:

   ```bash
   curl --request POST \
  --url http://localhost:8001/workspaces \
  --header 'Content-Type: multipart/form-data' \
  --header 'kong-admin-token: <token>' \
  --form name=teamA | jq
   ```
   The results should look like this:
   ```txt
   {
     "meta": {
       "color": null,
       "thumbnail": null
     },
     "name": "teamA",
     "comment": null,
     "config": {
       "portal_access_request_email": null,
       "portal_invite_email": null,
       "portal_token_exp": null,
       "portal_auto_approve": null,
       "portal_auth_conf": null,
       "portal_auth": null,
       "portal_session_conf": null,
       "portal_smtp_admin_emails": null,
       "portal_emails_reply_to": null,
       "portal_emails_from": null,
       "portal_cors_origins": null,
       "portal_reset_success_email": null,
       "portal_application_request_email": null,
       "portal_application_status_email": null,
       "meta": null,
       "portal_reset_email": null,
       "portal_is_legacy": null,
       "portal_developer_meta_fields": "[{\"label\":\"Full Name\",\"title\":\"full_name\",\"validator\":{\"required\":true,\"type\":\"string\"}}]",
       "portal_approved_email": null,
       "portal": false
     },
     "updated_at": 1699524963,
     "created_at": 1699524963,
     "id": "9e829c45-f478-4d7e-8c81-e5c9072548f3"
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
   ```txt
   {
     "updated_at": 1699525785,
     "tags": null,
     "ca_certificates": null,
     "id": "741903b5-d952-47fb-97d6-de48156b6603",
     "port": 80,
     "tls_verify": null,
     "name": "mockbin",
     "tls_verify_depth": null,
     "client_certificate": null,
     "protocol": "http",
     "enabled": true,
     "created_at": 1699525785,
     "host": "httpbin.org",
     "connect_timeout": 60000,
     "path": "/anything",
     "read_timeout": 60000,
     "retries": 5,
     "write_timeout": 60000
   }
   ```
1. Create a route for the service:
   ```bash
   curl --request POST \
    --url http://localhost:8001/teamA/services/httpbin/routes \
    --data "name=httpbin" \
    --data "paths=/httpbin"
   ```
  The results should look like this:
  ```txt
   {
     "updated_at": 1699526004,
     "tags": null,
     "sources": null,
     "destinations": null,
     "path_handling": "v0",
     "id": "ce5a18dc-e0e2-474a-b622-5352e3689770",
     "preserve_host": false,
     "hosts": null,
     "name": "httpbin",
     "regex_priority": 0,
     "service": {
       "id": "741903b5-d952-47fb-97d6-de48156b6603"
     },
     "methods": null,
     "request_buffering": true,
     "response_buffering": true,
     "created_at": 1699526004,
     "paths": [
       "/httpbin"
     ],
     "strip_path": true,
     "https_redirect_status_code": 426,
     "headers": null,
     "protocols": [
       "http",
       "https"
     ],
     "snis": null
   }  
  ```
1. Enable the OAuth2 plugin:
   ```bash
   curl --request POST \
  --url http://localhost:8001/teamA/services/mockbin/plugins \
  --data "name=oauth2" \
  --data "config.scopes=email" \
  --data "config.enable_authorization_code=true" \
  --data "config.enable_client_credentials=true"
   ```
   The results should look like this:
   ```txt
   {
     "updated_at": 1699526484,
     "tags": null,
     "enabled": true,
     "route": null,
     "created_at": 1699526484,
     "consumer_group": null,
     "id": "82749d6e-44d7-47d3-a8f6-a182a0ac16bd",
     "instance_name": null,
     "name": "oauth2",
     "protocols": [
       "grpc",
       "grpcs",
       "http",
       "https",
       "ws",
       "wss"
     ],
     "service": {
       "id": "741903b5-d952-47fb-97d6-de48156b6603"
     },
     "consumer": null,
     "config": {
       "mandatory_scope": false,
       "accept_http_if_already_terminated": false,
       "auth_header_name": "authorization",
       "anonymous": null,
       "pkce": "lax",
       "reuse_refresh_token": false,
       "enable_password_grant": false,
       "enable_client_credentials": true,
       "provision_key": "1zusPwfUozzk9ADpcuXDYTivSWondujz",
       "scopes": [
         "email"
       ],
       "enable_implicit_grant": false,
       "enable_authorization_code": true,
       "hide_credentials": false,
       "persistent_refresh_token": false,
       "global_credentials": false,
       "refresh_token_ttl": 1209600,
       "token_expiration": 7200
     },
     "ordering": null
   }
   ```
1. Create a consumer named `user1`:
   ```bash
   curl --request POST \
  --url http://localhost:8001/teamA/consumers \
  --data "username=user1"
   ```
   The results should look like this:
  ```txt
   {
     "username": "user1",
     "updated_at": 1699526969,
     "tags": null,
     "created_at": 1699526969,
     "custom_id": null,
     "username_lower": "user1",
     "type": 0,
     "id": "691d8afc-b098-4374-937b-b1c36c8ef084"
   }  
  ```
1. Create a key with the value `123` for the consumer `user1`:
   ```bash
   curl -i -X POST localhost:8001/teamA/consumers/user1/key-auth \
     --data "key=123"
   ```
   The results should look like this:
   ```txt
   {
      "consumer":{
         "id":"691d8afc-b098-4374-937b-b1c36c8ef084"
      },
      "ttl":null,
      "created_at":1699527247,
      "key":"123",
      "id":"233005b4-3d03-4618-9de9-e05887dd2055",
      "tags":null
   }
   ```
1. Provision new OAuth 2.0 credentials with `client_id` set to `456` and `client_secret` set to `789`:
   ```bash
   curl -i -X POST http://localhost:8001/teamA/consumers/user1/oauth2 \
     --data "name=demo" \
     --data "client_id=456" \
     --data "client_secret=789" \
--data "redirect_uris=http://mockbin.org/"
   ```
   The results should look like this:
   ```txt
   {
      "tags":null,
      "created_at":1699527585,
      "redirect_uris":[
         "http://mockbin.org/"
      ],
      "consumer":{
         "id":"691d8afc-b098-4374-937b-b1c36c8ef084"
      },
      "hash_secret":false,
      "name":"demo",
      "client_type":"confidential",
      "id":"77dec565-8b1b-4e60-8ad1-59fa1a6f280e",
      "client_id":"456",
      "client_secret":"789"
   }   
   ```
1. Get a token for the client credentials:
   ```bash
   curl --request POST -k \
  --url 'https://localhost:8443/mockbin/oauth2/token' \
  --header 'Content-Type: multipart/form-data' \
  --header 'kong-admin-token: admin' \
  --form client_id=456 \
  --form client_secret=789 \
  --form grant_type=client_credentials | jq
   ```
   The results should look like this:
   ```txt
   {
  "token_type": "bearer",
  "expires_in": 7200,
  "access_token": "k55RovztGnAHwl8xC07gfbuC345TEDRY"
   }
   ```
   Make a note of this `access_token` to send proxy requests to the service.

1. Create a service named `Oauth` with `oauth2/token` endpoint.
   ```bash
  curl --request POST \
    --url http://localhost:8001/teamA/services \
    --data "name=Oauth" \
    --data "retries=0" \
    --data "host=localhost" \
    --data "path=/mockbin/oauth2/token" \
    --data "port=8443" \
    --data "protocol=https"
   ```
   The results should look like this:
   ```txt
   {
     "updated_at": 1699528090,
     "tags": null,
     "ca_certificates": null,
     "id": "6cba3d64-0676-4e68-9644-54f6bb1ec103",
     "port": 8443,
     "tls_verify": null,
     "name": "Oauth",
     "tls_verify_depth": null,
     "client_certificate": null,
     "protocol": "https",
     "enabled": true,
     "created_at": 1699528090,
     "host": "localhost",
     "connect_timeout": 60000,
     "path": "/mockbin/oauth2/token",
     "read_timeout": 60000,
     "retries": 0,
     "write_timeout": 60000
   }   
   ```
1. Create a route named `oauthRoute` for the service name `Oauth`.
   ```bash
   curl --request POST \
  --url http://localhost:8001/teamA/services/Oauth/routes \
  --header 'Content-Type: multipart/form-data' \
  --header 'kong-admin-token: admin' \
  --form name=oauthRoute \
  --form paths=/oauth | jq
   ```
   The results should look like this:

   ```txt
   {
     "updated_at": 1699528555,
     "tags": null,
     "sources": null,
     "destinations": null,
     "path_handling": "v0",
     "id": "34fe2dda-9c8d-4525-93a0-e139212ff9dd",
     "preserve_host": false,
     "hosts": null,
     "name": "oauthRoute",
     "regex_priority": 0,
     "service": {
       "id": "6cba3d64-0676-4e68-9644-54f6bb1ec103"
     },
     "methods": null,
     "request_buffering": true,
     "response_buffering": true,
     "created_at": 1699528555,
     "paths": [
       "/oauth"
     ],
     "strip_path": true,
     "https_redirect_status_code": 426,
     "headers": null,
     "protocols": [
       "http",
       "https"
     ],
     "snis": null
   }   
   ```
1. Enable the Rate Limiting Advanced plugin with a limit of generating three tokens in span of 30 seconds.
   ```bash
   curl --request POST \
     --url http://localhost:8001/teamA/services/mockbin/plugins \
     --header 'Content-Type: application/json' \
     --header 'kong-admin-token: admin' \
     --data "name=rate-limiting-advanced" \
     --data "config.limit=3" \
     --data "config.window_size=30" \
     --data "config.sync_rate=-1" \
     --data "config.strategy=local"
   ```
   The results should look like this:
   ```txt
   {
     "updated_at": 1699528815,
     "tags": null,
     "enabled": true,
     "route": null,
     "id": "8e475f2b-6acd-42b4-b96f-7cdd3084a3e8",
     "consumer_group": null,
     "ordering": null,
     "instance_name": null,
     "name": "rate-limiting-advanced",
     "protocols": [
       "grpc",
       "grpcs",
       "http",
       "https"
     ],
     "service": {
       "id": "741903b5-d952-47fb-97d6-de48156b6603"
     },
     "consumer": null,
     "config": {
       "identifier": "consumer",
       "error_code": 429,
       "hide_client_headers": false,
       "retry_after_jitter_max": 0,
       "path": null,
       "error_message": "API rate limit exceeded",
       "strategy": "local",
       "dictionary_name": "kong_rate_limiting_counters",
       "redis": {
         "username": null,
         "sentinel_role": null,
         "sentinel_master": null,
         "port": null,
         "database": 0,
         "timeout": 2000,
         "cluster_addresses": null,
         "sentinel_username": null,
         "ssl": false,
         "keepalive_pool_size": 30,
         "sentinel_addresses": null,
         "keepalive_backlog": null,
         "host": null,
         "connect_timeout": null,
         "send_timeout": null,
         "read_timeout": null,
         "sentinel_password": null,
         "server_name": null,
         "ssl_verify": false,
         "password": null
       },
       "enforce_consumer_groups": false,
       "consumer_groups": null,
       "limit": [
         3
       ],
       "header_name": null,
       "window_size": [
         30
       ],
       "sync_rate": -1,
       "disable_penalty": false,
       "namespace": "DO3rmnwLJFq4ju7tCZtd6HkKAf9rGEDQ",
       "window_type": "sliding"
     },
     "created_at": 1699528815
   }   
   ```
1. Send a proxy request to the `Oauth/token` endpoint three times within a span of 30 seconds. Ensure that you replace `<accesstoken>` with the access token that you made a note of:
   ```bash
   curl -i -X POST 'http://localhost:8000/mockbin?apikey=123' \
   --header "authorization: Bearer <accesstoken>" \
   ```

   When you send a request for the fourth time, you should get a 429 response code, showing you that the last request was rate limited:
   ```txt
   HTTP/1.1 429 Too Many Requests
   Date: Thu, 09 Nov 2023 12:41:01 GMT
   Content-Type: application/json; charset=utf-8
   Connection: keep-alive
   Retry-After: 38
   RateLimit-Reset: 38
   RateLimit-Remaining: 0
   X-RateLimit-Limit-30: 3
   X-RateLimit-Remaining-30: 0
   RateLimit-Limit: 3
   Content-Length: 37
   X-Kong-Response-Latency: 5
   Server: kong/3.4.1.1-enterprise-edition
   
   {"message":"API rate limit exceeded"}
   ```
