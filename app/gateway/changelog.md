---
title: Kong Gateway Enterprise Changelog
no_version: true
---

<!-- vale off -->

Changelog for supported Kong Gateway Enterprise versions.

For Kong Gateway OSS, view the [OSS changelog on GitHub](https://github.com/Kong/kong/tree/master/changelog).

For product versions that have reached the end of sunset support, see the [changelog archives](https://legacy-gateway--kongdocs.netlify.app/enterprise/changelog/).

## 3.10.0.0
**Release Date** 2025/03/27

### Breaking changes and deprecations

#### AI plugins
* Changed the serialized log key of AI metrics from `ai.ai-proxy` to `ai.proxy` to avoid conflicts with metrics generated from plugins other than AI Proxy and AI Proxy Advanced.
  If you are using logging plugins (for example, File Log, HTTP Log, etc.), you will have to update metrics pipeline configurations to reflect this change.
* Deprecated `config.model.options.upstream_path` in favor of `config.model.options.upstream_url`.
* Deprecated `preserve` mode in `config.route_type`. Use `config.llm_format` instead. The `preserve` mode setting will be removed in a future release.
* **AI Rate Limiting Advanced**: `window_size` and `limit` now require an array of numbers instead of a single number.
  If you configured the plugin before 3.10 and use `kong migrations` to upgrade to 3.10, it will be automatically migrated to use the array.

#### PDK
* `kong.service.request.clear_query_arg`: Changed the encoding of spaces in query arguments from `+`
to `%20` as a short-term solution to an issue that some users are reporting. While the `+` character is the correct
encoding of space in querystrings, Kong uses `%20` in many other APIs (inherited from Nginx / OpenResty).

#### OpenID Connect
* Fixed an issue where forbidden requests were redirected to `unauthorized_redirect_uri` if configured. After the fix, forbidden requests will be redirected to `forbidden_redirect_uri` if configured.

#### Free mode
* Free mode is no longer available. Running Kong Gateway without a license will now behave the same as running it with an expired license.

### Performance

* Reduced the LMDB storage space by optimizing the key format.
* Improved performance of trace ID size lookup.
* Refined PDK usage for better performance.

### Features

#### Admin API
* Added the new field `x5t` to the entity `keys`, letting you use a X.509 Certificate Thumbprint to identify the key.
* Updated the `/license/report` endpoint to include counts for Kafka consumption, Confluent Kafka consumption, and Confluent production.

#### Clustering
* Added support for [incremental config sync](/gateway/3.10.x/production/deployment-topologies/hybrid-mode/incremental-config-sync/) for hybrid mode deployments. 
Instead of sending the entire entity config to data planes on each config update, incremental config sync lets you send only the changed configuration to data planes.
* Added a feature to store the last sync time on the Data Plane side.

#### Core
* Added the new configuration parameter `admin_gui_csp_header` to Gateway, which controls the Content-Security-Policy (CSP) header served with Kong Manager. This defaults to `off`, and you can opt in by setting it to `on`. 
You can use this setting to [strengthen security in Kong Manager](/gateway/3.10.x/kong-manager/strengthen-security/).
* The upstream URI variable is now refreshed when the proxy pass balancer is recreated.
* Added centralized consumer support for Konnect.
* Added a new core entity to Kong Gateway: [partials](/gateway/3.10.x/kong-enterprise/partials/). Partials enable users to define shared configuration for Redis.

#### Kong Manager
* Added a new feature to invalidate the admin's or the developer's related session while changing the password.
* Add Redis shared configuration support in Plugins.
* Kong Manager now shows the scope option in gray when it can't be changed.
* Kong Manager now returns to the previous page upon canceling plugin editing.

#### PDK
* Backported the `balancer.set_upstream_tls` feature from the OpenResty upstream, letting you dynamically control upstream TLS when `kong.service.request.set_scheme` is called.
* JWE now supports the following encryption algorithms: A128GCM, A192GCM, A128CBC-HS256, A192CBC-HS384, A256CBC-HS512.

#### Plugins

**New plugins**:

* [**AI RAG Injector**](/hub/kong-inc/ai-rag-injector/) (`ai-rag-injector`) Added the AI Rag Injector plugin, which allows automatically injecting documents to simplify building RAG pipelines.
* [**AI Sanitizer**](/hub/kong-inc/ai-sanitizer/) (`ai-sanitizer`) Added the AI Sanitizer plugin, which can sanitize the PII information in requests before the requests are proxied by the AI Proxy or AI Proxy Advanced plugins.
* [**Confluent Consume**](/hub/kong-inc/confluent-consume/) (`confluent-consume`): Introduced the Confluent Consume plugin, which adds Confluent Cloud consumption capabilities to Kong Gateway.
* [**Kafka Consume**](/hub/kong-inc/kafka-consume/) (`kafka-consume`): Introduced the Kafka Consume plugin, which adds Kafka consumption capabilities to Kong Gateway.
* [**Request Callout**](/hub/kong-inc/request-callout/) (`request-callout`): Added the `request-callout` plugin, which provides complex request augmentation and internal authentication.

**Existing plugins**:

* [**All AI plugins**](/hub/?category=ai):
  * Added support for the `pgvector` database.
  * Added support for the new Ollama streaming content type in the AI driver.
  * Added support for boto3 SDKs for Bedrock provider, and for Google GenAI SDKs for Gemini provider.
  * Allow authentication to Bedrock services with assume roles in AWS.
  * Added the `huggingface`, `azure`, `vertex`, and `bedrock` providers to embeddings. They can be used by the AI Proxy Advanced, AI Semantic Cache, AI Semantic Prompt Guard, and AI RAG Injector plugins.

* [**AI Proxy Advanced**](/hub/kong-inc/ai-proxy-advanced/) (`ai-proxy-advanced`)
  * Added the new `priority` balancer algorithm, which allows setting a priority group for each upstream model.
  * Added the `failover_criteria` configuration option, which allows retrying requests to the next upstream server in case of failure.
  * Added cost to `tokens_count_strategy` when using the lowest-usage load balancing strategy.
  * Added the ability to set a catch-all target in semantic routing.

* [**AI Rate Limiting Advanced**](/hub/kong-inc/ai-rate-limiting-advanced/) (`ai-rate-limiting-advanced`)  
  * Added support for allowing multiple rate limits for the same providers.

* [**Prometheus**](/hub/kong-inc/prometheus/) (`prometheus`) 
  * Added gauge to expose connectivity state to the control plane.
  * Added the capability to enable or disable exporting of Proxy-Wasm metrics.

* [**CORS**](/hub/kong-inc/cors/) (`cors`)
  * Added an option to skip returning the `Access-Control-Allow-Origin` response header when requests don't have the `Origin` header.

* [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`)
  * This plugin now supports variable resource attributes.
  * This plugin now supports instana headers in propagation.

* [**Session**](/hub/kong-inc/session/) (`session`) 
  * Added two boolean configuration fields, `hash_subject` (default `false`) and `store_metadata` (default `false`), to store the session's metadata in the database.

* [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`)
  * Improved performance on OpenAPI 3.0.
  * Added support for the `discriminator` keyword in OpenAPI specs.
  * Added support for the `oneOf`, `anyOf`, `allOf`, and `not` keywords.

* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Removed issuer discovery from schema to improve performance upon plugin initialization or updating. 
  The issuer discovery will only be triggered by client requests.

* [**Confluent**](/hub/kong-inc/confluent/) (`confluent`): 
  * Added support for message manipulation with the new configuration field `message_by_lua_functions`.
  * Added support for sending messages to multiple topics with `topics_query_arg`, and enabled topic allowlisting with `allowed_topics`.

* [**Kafka Upstream**](/hub/kong-inc/kafka-upstream/) (`kafka-upstream`)
  * Added support for sending messages to multiple topics with `topics_query_arg`, and enabled topic allowlisting with `allowed_topics`.
  * Added support for message manipulation with the new configuration field `message_by_lua_functions`.

* [**JSON Threat Protection**](/hub/kong-inc/json-threat-protection/) (`json-threat-protection`)
  * Added the schema field `allow_duplicate_object_entry_name` to allow or disallow duplicate object keys in JSON payloads. 
  When set to `false`, the plugin will reject JSON payloads with duplicate object keys. 
  The default value is `true`, which is same as the previous behavior.

### Fixes

#### Admin API
* Fixed an issue where a GET request to the Admin API root `/` path would return a 500 server error.
* Fixed an issue where a false error log was generated when a DELETE request with `Content-Type: application/json` and no body was made.
* Fixed an issue where `POST /config?flatten_errors=1` could not return a proper response if the input contained duplicate consumer credentials.
* Fixed an issue where `POST /config?flatten_errors=1` could return a JSON object instead of an empty array.
* Fixed an issue where targets couldn't be removed from the DNS query if they were deleted or updated via the Admin API.
* Fixed error caused by duplicate `Content-Type`.
* Fixed an issue where Admin API Enterprise-only entities were not writable when a license expired but was still in the grace period.

#### Configuration

* Fixed an issue where the `db_resurrect_ttl` configuration didn't take effect.

#### Core

* Added an optional configuration parameter `admin_gui_csp_header_value` to Gateway, which controls the value of the Content-Security-Policy (CSP) header served with Admin GUI (Kong Manager).
* Fixed an issue where a certificate entity configured with a vault reference occasionally didn't get refreshed on time when initialized with an invalid string.
* Fixed an issue where a mismatch between If-Match headers in requests and ETag in responses would result in a bad case in the response phase.
* Fixed an issue where DNS answers with `TTL=0` were incorrectly cached indefinitely in the new DNS client.
* Fixed an issue where Kong Gateway could have connection leaks when failing to connect to an upstream by websocket.
* Fixed an issue where a newly spawned worker couldn't use RDS IAM authentication when an old worker was decommissioned.
* **Analytics**:
  * Fixed an issue where `trace_id` did not honor the value extracted during tracing headers propagation.
  * Fixed an issue where Konnect analytics were missing for Kong AI Gateway.
* Updated the AWS Vault supported regions list to the latest available.
* Fixed an issue where event hooks sometimes ignored events, caused by the normalized table not including values of type number or boolean.
* Fixed an issue where the PEM-formatted private keys in the keys entity were not encrypted when keyring was enabled.
* Added a patch for `kong.resty.set_next_upstream()` to control the next upstream retry logic on the Lua side.
* Fixed an issue where consistent hashing did not correctly handle hyphenated-Pascal-case headers, leading to uneven distribution of requests across upstream targets.
* Fixed an issue where a valid declarative config with certificate or SNI entities couldn't be loaded in DB-less mode.
* Fixed an issue where an error wasn't thrown when parsing the certificate from a vault failed.
* Fixed an issue where the new DNS client did not correctly handle the timeout option in `resolv.conf`.
* Fixed an issue where the schema library would error with a nil reference if an entity checker referred to a nonexistent field.
* Fixed potential connection leaks which could occur when the data plane failed to connect to the control plane.
* Fixed an issue where `socket_path` permissions were not correctly set to `755` when the umask setting did not give enough permissions.
* Fixed an issue where the `tls_verify`, `tls_verify_depth`, and `ca_certificates` properties of a service were not included in the upstream keepalive pool name.
* Created connection pools for each `host`, `port`, `username`, `ssl` combination to fix the following issues:
  * Fixed a 401 error where multiple plugins (for example, Rate Limiting Advanced and OpenID Connect) were configured to use different Redis databases.
  * Prevented malicious clients from gaining access to shared authenticated connections, thus protecting Redis servers.
  * Restricted clients with limited ACL control to their granted scope.

#### Kong Manager

* Fixed an issue where the lists in the UI would flicker under some circumstances.
* Fixed an issue where the license expiration date was calculated incorrectly.

#### PDK

* You can now use a backslash to escape dots in logging plugins' `custom_fields_by_lua` key strings, preventing dots from creating nested tables.

#### Plugins

* [**All AI plugins**](/hub/?category=ai):
  * Fixed an issue where AI upstream URL trailing would be empty.
  * Fixed an issue where templates weren't being resolved correctly.
  * The plugins now support nested fields.

* [**All authentication plugins**](/hub/?category=authentication):
  * Improved the error message which occurred when an anonymous consumer was configured but didn't exist.

* [**AI Proxy**](/hub/kong-inc/ai-proxy/) (`ai-proxy`)
  * Fixed a bug in the Azure provider where `model.options.upstream_path` overrides would always return a 404 response.
  * Fixed a bug where Azure streaming responses would be missing individual tokens.
  * Fixed a bug where response streaming in Gemini and Bedrock providers was returning whole chat responses in one chunk.
  * Fixed a bug with the Gemini provider, where multimodal requests (in OpenAI format) would not transform properly.
  * Fixed an issue where Gemini streaming responses were getting truncated and/or missing tokens.
  * Fixed an incorrect error thrown when trying to log streaming responses.
  * Fixed `preserve` mode.

* [**AI Proxy Advanced**](/hub/kong-inc/ai-proxy-advanced/) (`ai-proxy-advanced`)
  * Fixed an issue where the plugin failed to fail over between providers of different formats.
  * Fixed an issue where the plugin's identity running failed in retry scenarios.

* [**AI Semantic Cache**](/hub/kong-inc/ai-semantic-cache/) (`ai-semantic-cache`)  
  * Fixed an issue where the Refresh header wasn't properly sent to the client.
  * Fixed an issue where the SSE body could have extra trailing characters.

* [**AI Semantic Prompt Guard**](/hub/kong-inc/ai-semantic-prompt-guard/) (`ai-semantic-prompt-guard`)
  * Fixed an issue where Kong Gateway was not able to reconfigure the plugin when using DB-less mode.

* [**AWS Lambda**](/hub/kong-inc/aws-lambda) (`aws-lambda`)
  * Fixed an issue that occurred when `is_proxy_integration` was enabled, where Kong Gateway's response could behave incorrectly when the response was changed after the execution of the AWS Lambda plugin. 
  The `Content-Length` header in the lambda function response is now ignored by the AWS Lambda plugin.

* [**gRPC-Web**](/hub/kong-inc/grpc-web/) (`grpc-web`) and [**gRPC-Gateway**](/hub/kong-inc/grpc-gateway/) (`grpc-gateway`)
  * Fixed a bug where the `TE` (transfer-encoding) header would not be sent to the upstream gRPC servers when `grpc-web` or `grpc-gateway` were in use.

* [**Response Rate Limiting**](/hub/kong-inc/response-ratelimiting/) (`response-ratelimiting`)
  * Fixed an issue where usage headers that were supposed to be sent to the upstream were lost instead.

* [**File Log**](/hub/kong-inc/file-log/) (`file-log`) 
  * Fixed an issue where an error would occur when there were spaces at the beginning or end of a path.
 
* [**AppDynamics**](/hub/kong-inc/app-dynamics/) (`app-dynamics`)
  * Fixed a segmentation fault caused by a missing destructor call on process exit.

* [**Forward Proxy**](/hub/kong-inc/forward-proxy/) (`forward-proxy`)
  * Fixed an issue where the `upstream_status` field was empty in logs when using the `forward-proxy` plugin.

* [**jq**](/hub/kong-inc/jq/) (`jq`)
  * Fixed an issue where jq did not work properly with the Proxy Cache Advanced plugin.

* [**JWT Signer**](/hub/kong-inc/jwt-signer/) (`jwt-signer`)
  * Fixed an issue where the plugin failed to upsert JWKS if the JWKS contained extra custom fields.

* [**LDAP Authentication Advanced**](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * Fixed an issue where binary string was truncated at the first null character.

* [**Mocking**](/hub/kong-inc/mocking/) (`mocking`)  
  * Fixed an issue where random delays were out of range.

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed an issue where the runtime failed due to `sync_rate` not being set if the `strategy` was `local`.

* [**Service Protection**](/hub/kong-inc/service-protection/) (`service-protection`)
  * Fixed an issue where the runtime failed due to `sync_rate` not being set if the `strategy` was `local`.
  * Enhanced robustness for user misconfigurations. The following use cases are now handled:
    * Rate Limiting Advanced and Service Protection are configured on the same service.
    * There is no service but the Service Protection plugin is enabled with global scope.

* [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`)
  * Fixed an issue where query params without values caused an assertion failure.

* [**Pre-function**](/hub/kong-inc/pre-function/) (`pre-function`)
  * Fixed an issue where a duplicate `protocols` field was accidentally added to the `pre-function` schema.

* [**JSON Threat Protection**](/hub/kong-inc/json-threat-protection/) (`json-threat-protection`)
  * This plugin now accurately supports proxying for non-`POST/PUT/PATCH` requests.

### Dependencies
#### Core

* Bumped `atc-router` from v1.6.2 to v1.7.1. 
This release contains upgraded dependencies and a new interface for validating expressions.
* Bumped Kong Nginx Module from 0.15.0 to 0.15.1.
* Bumped `libexpat` from 2.6.2 to 2.6.4 to fix a crash in the `XML_ResumeParser` function caused by `XML_StopParser` stopping an uninitialized parser.
* Bumped `lua-kong-nginx-module` from 0.13.0 to 0.14.0.
* Bumped `lua-resty-simdjson` from 1.1.0 to 1.2.0.
* Bumped OpenResty from 1.25.3.2 to 1.27.1.1.
* Bumped PCRE2 from 10.44 to 10.45.
* Bumped Snappy Library from 1.2.0 to 1.2.1.
* Bumped OpenSSL to 3.4.1 in core dependencies.
* Bumped `ngx_wasm_module` to `a376e67ce02c916304cc9b9ef25a540865ee6740`.
* Updated bundled debug tools: 
  * Bumped `curl` to 8.12.1
  * Bumped Mozilla CA Certificate Store to 2025-02-25
  * Bumped `nghttp2` to 1.65.0.
* Bumped `libxml2` from 2.12.9 to 2.12.10.

### Known issues

* **Vault Auth plugin:** 
  * The Vault Auth plugin doesn't clear its cache when incremental sync is turned on. 
  This means that deleted secrets will remain in the cache, and can still be accessed by the plugin.
* **Confluent Consume and Kafka Consume plugins:**
  * An error message appears in the logs about a missing cluster name, even when the name is specified.
* **Kafka Consume plugin:**
  * Kong Gateway allows you to configure the Kafka Consume plugin without authentication settings, 
  but authentication must be configured for the plugin to work. 
  
    If authentication is not configured, or if the authentication strategy is missing, 
    the plugin will fail with a generic authentication error.
* **AI Proxy plugin:**
  * Some active tracing latency values are incorrectly reported as having zero length when using the AI Proxy plugin.

## 3.9.1.1
**Release Date** 2025/03/20

### Fixes
#### Core

* Fixed an issue where modifying the X-Forwarded header before the access phase didn't take effect.
* Fixed an issue where DNS answers with `ttl=0` were incorrectly cached indefinitely in the new DNS client.
* Fixed an issue where Konnect analytics were missing for Kong AI Gateway.

#### Plugins

* [**AI Plugins**](/hub/?category=ai): 
  * Fixed an issue where templates weren't being resolved correctly.
  * Added nested field support.

* [**AI Semantic Cache**](/hub/kong-inc/ai-semantic-cache/) (`ai-semantic-cache`)  
  * Fixed an issue where the SSE body could have extra trailing, in some cases.

* [**AI Proxy**](/hub/kong-inc/ai-proxy/) (`ai-proxy`)
  * Fixed preserve mode.
  * Fixed an issue where the SSE body could have extra trailing, in some cases.

* [**AppDynamics**](/hub/kong-inc/app-dynamics/) (`app-dynamics`)
  * Fixed segmentation fault caused by missing destructor call on process exit.

## 3.9.1.0
**Release Date** 2025/03/11

### Fixes
#### Core

* Fixed an issue where a mismatch between If-Match in the request and ETag in the response would result in a bad case in the response phase.
* Updated the AWS Vault supported regions list to the latest available.
* Added support for the new Ollama streaming content type in the AI driver.

#### Plugins

* [**AI Proxy**](/hub/kong-inc/ai-proxy/) (`ai-proxy`)
  * Fixed an issue with Gemini streaming responses getting truncated and/or missing tokens.
  * Fixed an incorrect error thrown when trying to log streaming responses.
  * Fixed an issue where tool calls weren't working in streaming mode for Bedrock and Gemini providers.

* [**AI Semantic Prompt Guard**](/hub/kong-inc/ai-semantic-prompt-guard/) (`ai-semantic-prompt-guard`)
  *  Fixed an issue where Kong Gateway couldn't reconfigure the plugin when using DB-less mode.

* [**Session**](/hub/kong-inc/session/) (`session`) 
  * Fixed an issue where two boolean configuration fields `hash_subject` (default `false`) and `store_metadata` (default `false`) stored the session's metadata in the database.

## 3.9.0.1
**Release Date** 2025/01/28

### Fixes

#### Core

* Fixed an issue where consistent hashing did not correctly handle hyphenated-Pascal-case headers, leading to uneven distribution of requests across upstream targets.
* Fixed an issue where a certificate entity configured with a vault reference occasionally didn't get refreshed on time when initialized with an invalid string.

#### Plugins

* **AI Plugins**: Reverted the analytics container key from `proxy` to `ai-proxy` to align with previous versions.

* [**AI Proxy**](/hub/kong-inc/ai-proxy/) (`ai-proxy`)
  * Fixed an issue in the Azure provider where `model.options.upstream_path` overrides would always return a 404 error code.
  * Fixed an issue where Azure streaming responses would be missing individual tokens.
  * Fixed an issue where response streaming in Gemini and Bedrock providers was returning whole chat responses in one chunk.
  * Fixed an issue where multimodal requests (in OpenAI format) would not transform properly when using the Gemini provider.

* [**gRPC-Web**](/hub/kong-inc/grpc-web/) (`grpc-web`) and [**gRPC-Gateway**](/hub/kong-inc/grpc-gateway/) (`grpc-gateway`)
  * Fixed an issue where the `TE` (transfer-encoding) header would not be sent to the upstream gRPC servers when `grpc-web` or `grpc-gateweay` were in use.

### Dependencies

* Bumped `lua-kong-nginx-module` from 0.13.1 to 0.13.2.
* Bumped `libexpat` from 2.6.2 to 2.6.4 to fix a crash in the `XML_ResumeParser` function caused by `XML_StopParser` stopping an uninitialized parser.

## 3.9.0.0
**Release Date** 2024/12/12

### Breaking changes and deprecations

* Manually specifying a `node_id` via Kong configuration is deprecated. 
The `node_id` parameter is planned to be removed in 4.x.
 [#13687](https://github.com/Kong/kong/issues/13687)

### Features

#### Admin API

* Added support for the YAML media-type (`application/yaml`) to the `/config` endpoint.
 [#13713](https://github.com/Kong/kong/issues/13713)
* Added the ability to remove the consumer list from the return value for 
consumer groups Admin API `/consumer_groups/:consumer_groups` when `list_consumers=false`.
* The following endpoints can now retrieve entity counts in DB-less mode:
  * `/license/report` 
  * `/workspaces?counter`
  * `/workspace/<workspace>/meta`
* The `belong_workspace` field of an admin can now be updated via the Admin API and Kong Manager.
* Wasm filters can now be configured via the `/plugins` Admin API endpoint.

#### CLI

* Added the `kong drain` CLI command to make the `/status/ready` endpoint return a `503 Service Unavailable` response.
 [#13838](https://github.com/Kong/kong/issues/13838)

#### Clustering

* Added a remote procedure call (RPC) framework for hybrid mode deployments.
 [#12320](https://github.com/Kong/kong/issues/12320)

#### Core

* Added the configuration parameter `admin_gui_auth_login_attempts_ttl` (default to `604800`) to 
allow users to specify a custom duration to wait before they can try log in again if they have 
exceeded the maximum login attempts. 
This is only meaningful when `admin_gui_auth_login_attempts` is a positive number.
* Added an ADA dependency: WHATWG-compliant and fast URL parser.
[#13120](https://github.com/Kong/kong/issues/13120)
* Added a new LLM driver for interfacing with the Hugging Face inference API.
The driver supports both serverless and dedicated LLM instances hosted by
Hugging Face for conversational and text generation tasks.
[#13484](https://github.com/Kong/kong/issues/13484)
* Added a `tls.disable_http2_alpn()` function patch for disabling HTTP/2 ALPN when 
performing a TLS handshake.
[#13709](https://github.com/Kong/kong/issues/13709)
* Improved the output of the request debugger:
  * The resolution of field `total_time` is now in microseconds.
  * A new field, `total_time_without_upstream`,  shows the latency only introduced by Kong.
[#13460](https://github.com/Kong/kong/issues/13460)
* The embeddings driver can now cache the embeddings for a given model in the current request.
* Added an option for GitHub Actions to build nginx/OpenResty with debug symbols.

#### Deployment

* Kong Gateway now supports Ubuntu 24.04 (Noble Numbat) with both open-source and Enterprise packages.
[#13626](https://github.com/Kong/kong/issues/13626)

#### Kong Manager

* Added a new feature for Kong Manager that supports multiple domains, 
enabling dynamic cross-origin access for Admin API requests.
[#13664](https://github.com/Kong/kong/issues/13664)
* Kong Manager will now show a more friendly error message when failing to delete a service.

#### PDK

* Added `kong.service.request.clear_query_arg(name)` to the PDK.
 [#13619](https://github.com/Kong/kong/issues/13619)
* Array and Map type span attributes are now supported by the tracing PDK.
 [#13818](https://github.com/Kong/kong/issues/13818)

#### Plugins

**New plugins:**
* [**Redirect**](/hub/kong-inc/redirect/) (`redirect`): Introduced the Redirect plugin, which lets you redirect requests to another location.
 [#13900](https://github.com/Kong/kong/issues/13900)
* [**Injection Protection**](/hub/kong-inc/injection-protection/) (`injection-protection`): Added the Injection Protection plugin, which supports blocking requests based on regex patterns.
* [**Service Protection**](/hub/kong-inc/service-protection/) (`service-protection`): 
Implemented a new plugin to protect services using request rate limiting.

**Updates to existing plugins:**

* [**AI Proxy**](/hub/kong-inc/ai-proxy/) (`ai-proxy`)
  * Disabled the HTTP/2 ALPN handshake for connections on routes configured with AI Proxy.
 [#13735](https://github.com/Kong/kong/issues/13735)

* [**AI Proxy Advanced**](/hub/kong-inc/ai-proxy-advanced/) (`ai-proxy-advanced`)
  * Added support for streaming responses to the AI Proxy Advanced plugin.

* [**AI Rate Limiting Advanced**](/hub/kong-inc/ai-rate-limiting-advanced/) (`ai-rate-limiting-advanced`)  
  * Added support for the Hugging Face provider to the AI Rate Limiting Advanced plugin.

* [**AI Semantic Cache**](/hub/kong-inc/ai-semantic-cache/) (`ai-semantic-cache`)  
  * Added the `ignore_tool` configuration option to discard tool role prompts from the input text.
  * This plugin can now be enabled on consumer groups.

* [**AI Semantic Cache**](/hub/kong-inc/ai-semantic-cache/) (`ai-semantic-cache`), [**AI Semantic Prompt Guard**](/hub/kong-inc/ai-semantic-prompt-guard/) (`ai-semantic-prompt-guard`), [**AI Proxy Advanced**](/hub/kong-inc/ai-proxy-advanced/) (`ai-proxy-advanced`)
  * Made the `embeddings.model.name` config field a free text entry, enabling use of a
self-hosted (or otherwise compatible) model.

* [**Correlation ID**](/hub/kong-inc/correlation-id/) (`correlation-id`)
  * Increased the priority order of the plugin to from 1 to 100001 so that the plugin can be used with other plugins, especially custom auth plugins.
 [#13581](https://github.com/Kong/kong/issues/13581)
 
* [**JWT Signer**](/hub/kong-inc/jwt-signer/) (`jwt-signer`)
  * The `/jwt-signer/jwks` endpoint is now supported in DB-less mode.

* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * The `http_proxy_authorization` and `https_proxy_authorization` fields are now referenceable.
  * Added the `introspection_post_args_client_headers` config option, 
allowing you to pass client headers as introspection POST body arguments.

* [**Prometheus**](/hub/kong-inc/prometheus/) (`prometheus`) 
  * Increased the upper limit of `KONG_LATENCY_BUCKETS` to 6000 to enhance latency tracking precision.
  [#13588](https://github.com/Kong/kong/issues/13588)
  * Added support for Proxy-Wasm metrics.
  [#13681](https://github.com/Kong/kong/issues/13681)

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Added the new configuration field `lock_dictionary_name` to support specifying an independent shared memory for storing locks.
  * Added support for authentication from Kong Gateway to Envoy Proxy.
  * Added support for combining multiple identifier items with the new configuration field `compound_identifier`.

### Fixes 

#### Admin API

* Fixed an issue with querying Admin API entities with empty tags.
[#13723](https://github.com/Kong/kong/issues/13723)
* Fixed an issue where nested parameters couldn't be parsed correctly when using `form-urlencoded` requests.
[#13668](https://github.com/Kong/kong/issues/13668)
* Fixed an issue where the entities counter wasn't displayed in certain cases when they were empty.
* Fixed an issue where entity counts in `/license/report` were retrieved with `select count` instead of `workspace_entity_counters` table in DB-backed (traditional) mode.
* Fixed an issue where entity counts in `/workspaces?counter` and `/workspace/<workspace>/meta` were retrieved with `select count` instead of `workspace_entity_counters` table in DB-backed (traditional) mode.
 
#### Clustering

* Adjusted error log levels for control plane connections.
[#13863](https://github.com/Kong/kong/issues/13863)
* Fixed an issue where event hooks were not working in data planes.
* Fixed the clustering compatibility logic for the RDS assume role and custom STS endpoint features backport.
* Fixed a connection leak issue where the websocket connection was not closed promptly during reconnection.

#### Core

* Introduced a fix to always pass `ngx.ctx` to `log_init_worker_errors`, as otherwise it may runtime crash.
 [#13731](https://github.com/Kong/kong/issues/13731)
* Fixed an issue where the `ngx.balancer.recreate_request` API did not refresh the body buffer when `ngx.req.set_body_data` was used in the balancer phase.
 [#13882](https://github.com/Kong/kong/issues/13882)
* Fixed an issue where the workspace ID was not included in the plugin config in the plugins iterator.
 [#13377](https://github.com/Kong/kong/issues/13377)
* Fixed a 500 error triggered by unhandled `nil` fields during schema validation.
[#13861](https://github.com/Kong/kong/issues/13861)
* Vault fixes: 
  * Fixed an issue where array-like configuration fields couldn't contain vault references. [#13953](https://github.com/Kong/kong/issues/13953)
  * Fixed an issue where updating a vault entity in a non-default workspace wouldn't take effect.
   [#13610](https://github.com/Kong/kong/issues/13610)
  * Fixed an issue where vault references in kong configuration couldn't be dereferenced when both the HTTP and stream subsystems were enabled.
   [#13953](https://github.com/Kong/kong/issues/13953)
  * Fixed an issue where using Hashicorp Vault AppRole authentication with a secret ID file would fail to read the secret ID.
* Added a check that prevents Kong from starting when the
database contains invalid Wasm filters.
[#13764](https://github.com/Kong/kong/issues/13764)
* Fixed an issue where the `kong.request.enable_buffering` couldn't be used when the downstream used HTTP/2.
[#13614](https://github.com/Kong/kong/issues/13614)
* Fixed an issue where running the `kong migration` command would fail when upgrading to 3.8, which was caused by an incomplete Redis configuration-related SQL.
* Fixed an issue where the health checker could fail to initialize in rare cases.
* Fixed an issue where paginated results of `audit_requests` fetched via the `next` field were incorrect when `before` and `after` filters were applied.
* Fixed an issue where `event_hooks` added during runtime didn't function until restart.
* Fixed an issue where RBAC authorization could be enabled via `enforce_rbac` in DB-less mode. RBAC authorization should be disabled in DB-less mode.
* Fixed an issue where massive route insertion caused crashing and 500 errors.

#### Kong Manager

* Fixed an issue where text was not centered in custom banners.
* Fixed an issue where a workspace named "portal", but with different case letters, didn't render the correct overview page.
* Fixed an issue where Kong Manager was not redirecting users to the previous page after cancelling plugin creation.
* Fixed an issue where an RBAC user's username didn't allow special characters.

#### PDK

* Fixed the `kong.log.inspect` function to log at the `notice` level instead of `debug`. 
[#13642](https://github.com/Kong/kong/issues/13642)
* Fixed an issue where the `retries` error message incorrectly referred to the port.
 [#13605](https://github.com/Kong/kong/issues/13605)

#### Plugins

* [**AI Proxy**](/hub/kong-inc/ai-proxy/) (`ai-proxy`)
  * Fixed an issue where tools (function) calls to Anthropic would return empty results.
  [#13760](https://github.com/Kong/kong/issues/13760)
  * Fixed an issue where tools (function) calls to Bedrock would return empty results.
  [#13760](https://github.com/Kong/kong/issues/13760)
  * Fixed an issue where Bedrock Guardrail config was ignored.
  [#13760](https://github.com/Kong/kong/issues/13760)
  * Fixed an issue where tools (function) calls to Cohere would return empty results.
  [#13760](https://github.com/Kong/kong/issues/13760)
  * Fixed an issue where the Gemini provider would return an error if content safety failed in AI Proxy.
  [#13760](https://github.com/Kong/kong/issues/13760)
  * Fixed an issue where tools (function) calls to Gemini (or via Vertex) would return empty results.
  [#13760](https://github.com/Kong/kong/issues/13760)
  * Fixed an issue where multi-modal requests were blocked on the Azure AI provider.
  [#13702](https://github.com/Kong/kong/issues/13702)

* [**AI Prompt Guard**](/hub/kong-inc/ai-prompt-guard/) (`ai-prompt-guard`)
  * Fixed an issue where the plugin could fail when handling requests with multiple models.

* [**AI Proxy Advanced**](/hub/kong-inc/ai-proxy-advanced/) (`ai-proxy-advanced`)
  * Fixed an issue where lowest-usage and lowest-latency strategies did not update data points correctly.
  * Fixed an issue where stale plugin config was not updated in DB-less and hybrid modes.

* [**AI Rate Limiting Advanced**](/hub/kong-inc/ai-rate-limiting-advanced/) (`ai-rate-limiting-advanced`) 
  * Updated the error message for exceeding the rate limit to include AI-related information.
  * Fixed an issue where the plugin yielded an error when incrementing the rate limit counters in non-yieldable phases.
  * Fixed an issue where the plugin could fail to authenticate to Redis correctly with vault-referenced Redis configuration.

* [**AI Request Transformer**](/hub/kong-inc/ai-request-transformer/) (`ai-request-transformer`) and 
[**AI Response Transformer**](/hub/kong-inc/ai-response-transformer/) (`ai-response-transformer`)
  * Fixed an issue where Azure Managed Identity did not work for the AI Transformer plugins.
  * Fixed an issue where AI Transformer plugins always returned a 404 error when using Google One Gemini subscriptions.
  [#13703](https://github.com/Kong/kong/issues/13703)
  * Fixed an issue where the correct LLM error message was not propagated to the caller.
  [#13703](https://github.com/Kong/kong/issues/13703)

* [**AI Semantic Cache**](/hub/kong-inc/ai-semantic-cache/)
  * Fixed an issue where the plugin couldn't use the request-provided models.
   [#13627](https://github.com/Kong/kong/issues/13627)
  * Fixed the exact matching to catch everything, including embeddings.
  * Fixed an issue where the AI Semantic Cache plugin would abort in stream mode when another plugin enabled the buffering proxy mode.
  * Fixed an issue where the AI Semantic Cache plugin put the wrong type value in the metrics when using the Prometheus plugin.
  * Fixed an issue where the plugin failed when handling requests with multiple models.

* [**AI Semantic Prompt Guard**](/hub/kong-inc/ai-semantic-cache/) (`ai-semantic-prompt-guard`)
  * Fixed an issue where the plugin could fail when handling requests with multiple models.
  * Fixed an issue where stale plugin config was not updated in DB-less and hybrid modes.

* [**AppDynamics**](/hub/kong-inc/app-dynamics/) (`app-dynamics`)
  * Fixed an issue where the `snapshot` of the fields `upstream`, `service`, `route`, and `consumer` was missing in the AppDynamics plugin.

* [**AWS Lambda**](/hub/kong-inc/aws-lambda) (`aws-lambda`)
  * Fixed an issue in proxy integration mode that caused an internal server error when the `multiValueHeaders` was null.
   [#13533](https://github.com/Kong/kong/issues/13533)

* [**DeGraphQL**](/hub/kong-inc/degraphql/) (`degraphql`)
  * Fixed an issue where the DeGraphQL routes were updated from the control plane but not updated in the DeGraphQL router on the data plane.

* [**Exit Transformer**](/hub/kong-inc/exit-transformer/) (`exit-transformer`)
  * Fixed an issue where the plugin couldn't take effect on invalid non-admin requests.

* [**GraphQL Rate Limiting Advanced**](/hub/kong-inc/graphql-rate-limiting-advanced/) (`graphql-rate-limiting-advanced`)
  * Fixed an issue where the plugin could fail to authenticate to Redis correctly with vault-referenced Redis configuration.

* [**JSON Threat Protection**](/hub/kong-inc/json-threat-protection/) (`json-threat-protection`)
  * Fixed an issue where the length counting of escape sequences, non-ASCII characters, and object entry names in JSON strings was incorrect. The plugin now uses UTF-8 character count instead of bytes.
  * Fixed an issue where certain default parameter values were incorrectly interpreted as 0 in some environments (for example, ARM64-based):
    * `max_container_depth`
    * `max_object_entry_count`
    * `max_object_entry_name_length`
    * `max_array_element_count`
    * `max_string_value_length`

* [**JWE Decrypt**](/hub/kong-inc/jwe-decrypt/) (`jwe-decrypt`)
  * Fixed an issue where an unnecessary warn log was printed.

* [**JWT**](/hub/kong-inc/jwt/) (`jwt`)
  * Ensured that `rsa_public_key` isn't base64-decoded.
  [#13717](https://github.com/Kong/kong/issues/13717)

* [**Kafka Log**](/hub/kong-inc/kafka-log/) (`kafka-log`)
  * Fixed an issue where the plugin couldn't function correctly when configured in a non-default workspace with `certificate_id`.
  * Reduced noisy logs from the plugin and counters.

* [**Key Authentication**](/hub/kong-inc/key-auth/) (`key-auth`)
  * Fixed an issue with the order of query arguments, ensuring that arguments retain order when hiding the credentials.
  [#13619](https://github.com/Kong/kong/issues/13619)

* [**Loggly**](/hub/kong-inc/loggly/) (`loggly`)
  * Fixed an issue where a missing `/bin/hostname` caused an error warning on startup.
  [#13788](https://github.com/Kong/kong/issues/13788)

* [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`)
  * Fixed an issue where the error message was omitted if `notify_only_request_body_validation_failure` or `notify_only_response_body_validation_failure` was set to `false`.
  * Fixed an issue where the `include_base_path` did not work when multiple servers were provided.
  * Fixed an issue where the spec could not be located if the `Content-Type` in the request/response body included parameters (for example, `application/json; charset=utf8`) while the OpenAPI specification defined in `api_spec` did not include parameters.

* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Fixed an `500` error caused by JSON `null` from the request body when parsing bearer tokens or client IDs.
  * Fixed an issue where the configured Redis database was ignored.
  * Fixed an issue where the `token_cache_key_include_scope` feature was not considering scopes defined via `config.scopes` to generate the cache key.

* [**Rate Limiting**](/hub/kong-inc/rate-limiting/) (`rate-limiting`)
  * Fixed an issue where the returned values from `get_redis_connection()` were incorrect.
  [#13613](https://github.com/Kong/kong/issues/13613)
  * Fixed an issue that caused an HTTP 500 error when `hide_client_headers` was set to `true` and the request exceeded the rate limit.
  [#13722](https://github.com/Kong/kong/issues/13722)

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) 
  * Fixed an issue where counters of the overriding consumer groups weren't fetched when the `window_size` was different and the workspace was non-default.
  * Fixed an issue where a warn log was printed when `event_hooks` was disabled.
  * Fixed an issue where, if multiple plugin instances sharing the same namespace enforced consumer groups and different `window_size`s were used in the consumer group overriding configs, then the rate limiting of some consumer groups would fall back to the `local` strategy. Now, every plugin instance sharing the same namespace can set a different `window_size`.
  * Fixed an issue where the plugin could fail to authenticate to Redis correctly with vault-referenced Redis configuration.
  * Fixed an issue where plugin-stored items with a long expiration time caused `no memory` errors.

* [**Request Validator**](/hub/kong-inc/request-validator/) (`request-validator`)
  * Fixed an issue where requests would get rejected when defining an object parameter in exploded form style.

### Dependencies

* Bumped `lua-kong-nginx-module` from 0.11.0 to 0.13.1 to 
fix the upstream certificate chain issue and enable the new API for retrieving the SSL pointer.
* Bumped `lua-resty-events` to 0.3.1. Optimized the memory usage.
 [#13097](https://github.com/Kong/kong/issues/13097)
* Bumped `lua-resty-lmdb` to 1.6.0, allowing `page_size` to be 1.
 [#13908](https://github.com/Kong/kong/issues/13908)
* Bumped lua-resty-lmdb to 1.5.0. Added the `page_size` parameter to allow overriding page size from the caller side.
 [#12786](https://github.com/Kong/kong/issues/12786)
* Added Ubuntu 24.04 (Noble Numbat) FIPS packages and image.
* Bumped the bundled `datakit` Wasm filter to `0.3.1`.
 [#13922](https://github.com/Kong/kong/issues/13922)
* Updated the default base for RPM Dockerfile from UBI 8 to UBI 9.
 [#13574](https://github.com/Kong/kong/issues/13574)
* Bumped `lua-resty-aws` to 1.5.4 to fix a bug inside region prefix generation.
 [#12846](https://github.com/Kong/kong/issues/12846)
* Bumped lua-resty-ljsonschema to 1.2.0. Fixed UTF-8 string length calculation 
and added support for `null` as a valid option in `enum` types.
 [#13783](https://github.com/Kong/kong/issues/13783)
* Bumped `ngx_wasm_module` to `9136e463a6f1d80755ce66c88c3ddecd0eb5e25d`.
 [#12011](https://github.com/Kong/kong/issues/12011)
* Bumped `Wasmtime` version to `26.0.0`.
 [#12011](https://github.com/Kong/kong/issues/12011)
* Bumped OpenSSL to 3.2.3 to fix unbounded memory growth with session handling in TLSv1.3 and other CVEs. 
[#13448](https://github.com/Kong/kong/issues/13448)
* Bumped `kong-redis-cluster` to `1.5.5`:
  * The timeout for acquiring a lock was fixed to `5s`.
    Added the new option `lock_timeout` to make it configurable.
  * The lock timeout parameter was incorrectly set to `time_out = 0`.
    Fixed the parameter to `timeout = 0`. This improves performance as there is no
    need for each instance to refresh the slots.
  * `kong-redis-cluster` now returns detailed error messages to downstream
    components (e.g. Kong Gateway) for better debuggability.
* Bumped lua-resty-azure to 1.6.1 to fix a `GET` request build issue,
 which was causing problems with Azure secret references.


## 3.8.1.1
**Release Date** 2025/04/10

### Dependencies

* Bumped `libexpat` from 2.6.2 to 2.6.4 to fix a crash in the `XML_ResumeParser` function caused by `XML_StopParser` stopping an uninitialized parser.
* Bumped `lua-kong-nginx-module` from 0.11.1 to 0.11.2.

### Fixes

#### CLI

* Fix an issue where running the `kong migration` command would fail when upgrading to 3.8, which was caused by incomplete Redis configuration-related SQL.

#### Core

* Fixed an issue where consistent hashing did not correctly handle hyphenated-Pascal-case headers, leading to uneven distribution of requests across upstream targets.
* Fixed an issue where a certificate entity configured with a vault reference was occasionally not refreshed on time when initialized with an invalid string.
* Updated the AWS Vault supported regions list to the latest available.

#### Plugins

* [**AppDynamics**](/hub/kong-inc/app-dynamics/) (`app-dynamics`)
  * Fixed segmentation fault on Kong exit caused by missing destructor call.

* [**LDAP Authentication Advanced**](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * Fixed an issue where a binary string was truncated at the first null character.

* [**Session**](/hub/kong-inc/session/) (`session`)
  * Fixed an issue where boolean configuration fields `hash_subject` (default `false`) and `store_metadata` (default `false`) stored the session's metadata in the database. This also resolves an issue with Dev Portal, where adding these fields to `portal_session_conf` wasn't working as expected.

* [**Proxy Cache Advanced**](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cache-advanced`)
  * Fixed an issue where the `kong.plugins.proxy-cache-advanced.migrations` module was not being loaded when upgrading to `3.8.x.y`.
    This issue was introduced in `3.8.0.0` and Kong refuses to start if `redis.timeout` and `redis.connect_timeout` are set to different values.

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed an issue where the `kong.plugins.rate-limiting-advanced.migrations` module was not being loaded when upgrading to `3.8.x.y`.
    This issue was introduced in `3.8.0.0` and Kong refuses to start if `redis.timeout` and `redis.connect_timeout` are set to different values.

## 3.8.1.0
**Release Date** 2024/11/04

### Features
#### Plugins

* [**Prometheus**](/hub/kong-inc/prometheus/) (`prometheus`) 
  * Increased the upper limit of `KONG_LATENCY_BUCKETS` to 6000 to enhance latency tracking precision.

### Fixes

#### Clustering

* Fixed the clustering compatibility logic for the RDS assume role and custom STS endpoint features.

#### Core

* **Vault**: Fixed an issue where updating a vault entity in a non-default workspace wouldn't take effect.

#### Admin API

* **Admin API** Fixed an issue where sending `tags=` as an empty parameter resulted in a 500 error. Now, Kong returns a 400 error because empty explicit tags are not allowed.

#### Kong Manager

* Fixed an issue where text was not centered in custom banners.
* Fixed an issue where a workspace named "portal", but with different case letters, didn't render the correct overview page.

#### Plugins

* [**AI Proxy**](/hub/kong-inc/ai-proxy/) (`ai-proxy`)
  * Fixed an issue where multi-modal requests were blocked on the Azure AI provider.
  * Fixed an issue where AI Transformer plugins always returned a 404 error when using 'Google One' Gemini subscription.

* [**AI Proxy Advanced**](/hub/kong-inc/ai-proxy-advanced/) (`ai-proxy-advanced`)
  * Fixed an issue where the lowest-usage and lowest-latency strategies did not update data points correctly.
  * Fixed an issue where stale plugin config was not updated in DB-less or hybrid mode.

* [**AI Rate Limiting Advanced**](/hub/kong-inc/ai-rate-limiting-advanced/) (`ai-rate-limiting-advanced`)
  * Fixed an issue where the plugin yielded an error when incrementing the rate limit counters in non-yieldable phases.

* [**AI Request Transformer**](/hub/kong-inc/ai-request-transformer/) (`ai-request-transformer`) and 
[**AI Response Transformer**](/hub/kong-inc/ai-response-transformer/) (`ai-response-transformer`)
  * Fixed an issue where the correct LLM error message was not propagated to the caller.
  * Fixed an issue where AI Transformer plugins always returned a 404 error when using Google One Gemini subscriptions.

* [**AI Semantic Cache**](/hub/kong-inc/ai-semantic-cache/)
  * Fixed an issue where the plugin couldn't use the request-provided models.
  * Fixed an issue where the plugin put the wrong type value in the metrics when using the Prometheus plugin.
  * Fixed an issue where the plugin would abort in stream mode when another plugin enabled buffering proxy mode.

* [**AI Semantic Prompt Guard**](/hub/kong-inc/ai-semantic-prompt-guard/)
  * Fixed an issue where stale plugin config was not updated in DB-less or hybrid mode.

* [**DeGraphQL**](/hub/kong-inc/degraphql/) (`degraphql`)
  * Fixed an issue where the degraphql routes were updated from the control plane but not updated in the degraphql router on the data plane.

* [**JSON Threat Protection**](/hub/kong-inc/json-threat-protection/)
  * Fixed an issue where the length counting of escape sequences, non-ASCII characters, and object entry names in JSON strings was incorrect. The plugin now uses UTF-8 character count instead of bytes.
  * Fixed an issue where certain default parameter values were incorrectly interpreted as 0 in some environments (e.g., ARM64-based):
    * `max_container_depth`
    * `max_object_entry_count`
    * `max_object_entry_name_length`
    * `max_array_element_count`
    * `max_string_value_length`

* [**Rate Limiting**](/hub/kong-inc/rate-limiting/) (`rate-limiting`)
  * Fixed an issue that caused an HTTP 500 error when `hide_client_headers` was set to `true` and the request exceeded the rate limit.

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed an issue where a warn log was printed when `event_hooks` was disabled.

### Dependencies

* Bumped `lua-kong-nginx-module` from 0.11.0 to 0.11.1 to fix an issue where the upstream cert chain wasn't properly set.
* Bumped `lua-resty-aws` to 1.5.4 to fix a bug inside region prefix generation.
* Bumped `lua-resty-azure` to 1.6.1 to fix a `GET` request build issue, which was causing problems with Azure secret references.

## 3.8.0.0
**Release Date** 2024/09/11

### Breaking changes and deprecations

**Deployments**
* Debian 10 and RHEL 7 reached their End of Life (EOL) dates on June 30, 2024. 
As of version 3.8.0.0 onward, Kong is not building installation packages or Docker images for these operating systems. 
Kong is no longer providing official support for any Kong version running on these systems.
 [#13468](https://github.com/Kong/kong/issues/13468)

**Redis standardization changes**
* Standardized Redis configuration across plugins. The Redis configuration now follows a common schema shared with other plugins. This change affects:
  * SAML
  * OpenID Connect
* PDK: The shared configuration for Redis `kong/enterprise_edition/redis/init.lua` was deprecated in favor of `kong/enterprise_edition/tools/redis/v2/init.lua`
* The following parameters have been deprecated:
  * `cluster_address` has been deprecated and replaced by `cluster_nodes`.
  * `sentinel_cluster` has been deprecated and replaced by `sentinel_nodes`.
  * The `timeout` config field in Redis configuration has been deprecated and replaced with `connect_timeout`, `send_timeout`, and `read_timeout`. 
  The deprecated `timeout` field will be removed in an upcoming major version.

  These deprecations affect the following plugins:
    * AI Rate Limiting Advanced
    * GraphQL Proxy Cache Advanced
    * GraphQL Rate Limiting Advanced
    * Proxy Cache Advanced
    * Rate limiting Advanced
    
  For more information about the Redis standardization changes, see the [3.8 Breaking Changes](/gateway/3.8.x/breaking-changes/).

### Features

#### Admin API

* Added support for brackets syntax for map fields configuration via the Admin API.
 [#13313](https://github.com/Kong/kong/issues/13313)

#### CLI

* Added the new sub-command `status` to the `kong debug` CLI tool.

#### Configuration

* You can now configure the Wasmtime module cache when Wasm is enabled.
 [#12930](https://github.com/Kong/kong/issues/12930)
* Added two configuration options, `admin_gui_auth_change_password_attempts` (default value `0`) and 
`admin_gui_auth_change_password_ttl` (default value `86400`), to limit the number of password change attempts in Kong Manager.

#### Core

* Added the new queue configuration parameter `concurrency_limit` (integer, defaults to 1), which lets you specify the number of delivery timers in the queue.
  Note that setting `concurrency_limit` to `-1` means no limit at all, and each HTTP log entry would create an individual timer for sending.
 [#13332](https://github.com/Kong/kong/issues/13332)
* Kong Gateway now appends gateway info to the upstream `Via` header in the format `1.1 kong/3.8.0`, and optionally to the
response `Via` header if it is present in the [`headers`](/gateway/3.8.x/reference/configuration/#headers) config of `kong.conf`, in the format `2 kong/3.8.0`.
This follows standards defined in [RFC7230](https://datatracker.ietf.org/doc/html/rfc7230) and [RFC9110](https://datatracker.ietf.org/doc/html/rfc9110).
 [#12733](https://github.com/Kong/kong/issues/12733)
* Kong Gateway 3.8.x adds a new DNS client library. 
  This library is disabled by default, and can be enabled by setting the [`new_dns_client`](/gateway/3.8.x/reference/configuration/#new_dns_client) parameter to `on`.
  The new DNS client library provides the following:
  * Global caching for DNS records across workers, significantly reducing the query load on DNS servers.
  * Observable statistics for the new DNS client, and a new Status API `/status/dns` to retrieve them.
  * Simplified and standardized logic.
  Learn more about enabling and using the new DNS client library in the [DNS migration guide](/gateway/3.8.x/migrate-to-new-dns-client/).
   [#12305](https://github.com/Kong/kong/issues/12305)
* **Analytics**:
  * Added support for sending AI analytics about latency and caching to Konnect.
  * Added support for sending cache data of AI analytics to Konnect.
* Added connection support via Redis Proxy (for example, Envoy Redis proxy or twemproxy) via the configuration field [`connection_is_proxied`](/gateway/3.8.x/reference/configuration/#connection_is_proxied).
* Added support for assuming an AWS IAM role in AWS IAM Database Authentication, with the following new configuration fields: `pg_iam_auth_assume_role_arn`, `pg_iam_auth_role_session_name`, `pg_ro_iam_auth_assume_role_arn`, and `pg_ro_iam_auth_role_session_name`. 
See the [PostgreSQL settings section](/gateway/3.8.x/reference/configuration/#postgres-settings) in the Kong configuration reference for details.
* Added keyring encryption support to [license database entity payloads](/gateway/3.8.x/kong-enterprise/db-encryption/#configure-license-payload-encryption).
* Added support for a configurable STS endpoint for RDS IAM Authentication with the following new configuration fields: `pg_iam_auth_sts_endpoint_url` and `pg_ro_iam_auth_sts_endpoint_url`.
See the [PostgreSQL settings section](/gateway/3.8.x/reference/configuration/#postgres-settings) in the Kong configuration reference for details.
* Added support for a configurable STS endpoint for AWS Vault. This can either be configured by [`vault_aws_sts_endpoint_url`](/gateway/3.8.x/reference/configuration/#vault_aws_sts_endpoint_url) as a global configuration, or [`sts_endpoint_url`](/gateway/3.8.x/kong-enterprise/secrets-management/backends/aws-sm/) on a custom AWS vault entity.

#### Kong Manager

* Improved accessibility in Kong Manager.
* Enhanced entity lists so that you can resize or hide list columns.
* Added an SNIs field to the certificate form.
* **Kong Manager Enterprise**: 
  * While deleting a workspace, Kong Manager now lists admins that prevent the operation.
  * Kong Manager now shows scoping entities as links in the plugin detail page.
  * Added UI components for building the vault reference while configuring referenceable fields for plugins.
* Kong Manager now shows input boxes that allow optionally creating SNIs while creating a certificate.

#### PDK

- Added `0` to support unlimited body size. 
When the parameter `max_allowed_file_size` is `0`, `get_raw_body` returns the entire body, 
but the size of this body is still limited by Nginx's `client_max_body_size`.
 [#13431](https://github.com/Kong/kong/issues/13431)
- Extended `kong.request.get_body` and `kong.request.get_raw_body` to read from buffered files.
 [#13158](https://github.com/Kong/kong/issues/13158)
- Added the new PDK module `kong.telemetry` and the function `kong.telemetry.log`
to generate log entries to be reported via the OpenTelemetry plugin.
 [#13329](https://github.com/Kong/kong/issues/13329)

#### Plugins

**New plugins**:
* [**AI Proxy Advanced**](/hub/kong-inc/ai-proxy-advanced/): An advanced AI Proxy which supports load balancing between LLM services.
* [**AI Semantic Cache**](/hub/kong-inc/ai-semantic-cache/): Configure an embeddings-based caching system for LLM responses.
* [**AI Semantic Prompt Guard**](/hub/kong-inc/ai-semantic-prompt-guard/): Use semantic similarity-based prompt guarding with the AI Proxy.
* [**Upstream OAuth**](/hub/kong-inc/upstream-oauth/): A plugin that enables Kong to obtain OAuth2 tokens to consume upstream APIs.
* [**Confluent**](/hub/kong-inc/confluent/): Transform requests into Kafka messages in a Confluent topic.
* [**Standard Webhooks**](/hub/kong-inc/standard-webhooks/): Validate that incoming webhooks adhere to the [Standard Webhooks](https://github.com/standard-webhooks/standard-webhooks)
 specification.
* [**Header Cert Authentication**](/hub/kong-inc/header-cert-auth/): Authenticate clients with mTLS certificates passed in headers by a WAF or load balancer.
* [**JSON Threat Protection**](/hub/kong-inc/json-threat-protection/): Validate JSON nesting depth, array elements, object entries, 
key length, and string length, then log or terminate violating requests.

**Existing plugins**:

* [**ACL**](/hub/kong-inc/acl/) (`acl`)
  * Added the new configuration parameter `always_use_authenticated_groups` to support using authenticated groups even 
  when an authenticated consumer already exists.
  [#13184](https://github.com/Kong/kong/issues/13184)

* [**All AI plugins**](/hub/?category=ai):
  * Latency data is now pushed to logs and metrics.
   [#13428](https://github.com/Kong/kong/issues/13428)
  * Kong AI Gateway now supports all AWS Bedrock Converse API models.
   [#12948](https://github.com/Kong/kong/issues/12948)
   * Kong AI Gateway now supports the Google Gemini chat (`generateContent`) interface.
   [#12948](https://github.com/Kong/kong/issues/12948)

* [**AI Proxy**](/hub/kong-inc/ai-proxy/) (`ai-proxy`)
  * Added the `allow_override` option to allow overriding the upstream model auth parameter or header from the caller's request.
  [#13158](https://github.com/Kong/kong/issues/13158)
  * Replaced the library and use `cycle_aware_deep_copy` for the `request_table` object.
  [#13582](https://github.com/Kong/kong/issues/13582)
  * The Mistral provider can now use mistral.ai-managed services by omitting the `upstream_url`.
  [#13481](https://github.com/Kong/kong/issues/13481)
  * Added the new response header `X-Kong-LLM-Model`, which displays the name of the language model used in the AI Proxy plugin.
  [#13472](https://github.com/Kong/kong/issues/13472)

* [**AI Rate Limiting Advanced**](/hub/kong-inc/ai-rate-limiting-advanced/) (`ai-rate-limiting-advanced`)
  * Added the Redis `cluster_max_redirections` configuration option.
  * Added stats for reaching the limit and exiting the AI Rate Limiting plugin.
  * Add the cost strategy to the AI Rate Limiting plugin.
  * Added the `bedrock` and `gemini` providers to the supported providers list.

* [**AI Prompt Guard**](/hub/kong-inc/ai-prompt-guard/) (`ai-prompt-guard`)
  * Added the `match_all_roles` option to allow matching all roles in addition to `user`.
   [#13183](https://github.com/Kong/kong/issues/13183)

* [**AppDynamics**](/hub/kong-inc/app-dynamics/) (`app-dynamics`)
  * Added a new `ANALYTICS_ENABLE` flag. This plugin now also collects more snapshot user data in runtime.

* [**AWS Lambda**](/hub/kong-inc/aws-lambda) (`aws-lambda`)
  * Added support for a configurable STS endpoint with the new configuration field `aws_sts_endpoint_url`.
  [#13388](https://github.com/Kong/kong/issues/13388)
  * Added the configuration field `empty_arrays_mode` to control whether Kong should send `[]` empty arrays 
  (returned by Lambda function) as `[]` empty arrays or `{}` empty objects in JSON responses.
  [#13084](https://github.com/Kong/kong/issues/13084)

* [**JWT Signer**](/hub/kong-inc/jwt-signer/) (`jwt-signer`)
  * This plugin now supports using the `/jwt-signer/jwks/:jwt_signer_jwks` endpoint in DB-less mode.

* [**LDAP Authentication Advanced**](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * This plugin now supports decoding an empty sequence or set represented in long form length.

* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Added support for Redis caching introspection results with the new fields `cluster_cache_strategy` and `cluster_cache_redis`. 
  When configured, the plugin will share the token introspection response cache across nodes configured to use the same Redis database.
  * Added the `claims_forbidden` property to restrict access.

* [**Prometheus**](/hub/kong-inc/prometheus/) (`prometheus`) 
  * Added `ai_requests_total`, `ai_cost_total`, and `ai_tokens_total` metrics to 
  the Prometheus plugin to start counting AI usage.
  [#13148](https://github.com/Kong/kong/issues/13148)

* [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`)
  * Added support for OpenTelemetry-formatted logs.
   [#13291](https://github.com/Kong/kong/issues/13291)

* [**GraphQL Proxy Cache Advanced**](/hub/kong-inc/graphql-proxy-cache-advanced/) (`graphql-proxy-cache-advanced`),
[**GraphQL Rate Limiting Advanced**](/hub/kong-inc/graphql-rate-limiting-advanced/) (`graphql-rate-limiting-advanced`), 
[**Proxy Cache Advanced**](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cache-advanced`), and 
[**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Added the Redis `cluster_max_redirections` configuration option.

* [**Response Transformer**](/hub/kong-inc/response-transformer/) (`response-transformer`)
  * Added support for `json_body` renaming.
    [#13131](https://github.com/Kong/kong/issues/13131)

### Fixes

#### Admin API

* Fixed an issue where validation of the certificate schema failed if the `snis` field was present in the request body.
 [#13357](https://github.com/Kong/kong/issues/13357)
* Fixed an issue where resetting the token was allowed while disabling `rbac_token_enabled`.
* Fixed an issue where the field `is_default` should be immutable when updating the `rbac_roles`.
* Fixed an issue where the license report returned a 500 error code when non-required fields weren't specified in the Lambda and Kafka plugins.
* Kong Gateway now returns a detailed error message when failing to cascade delete a workspace caused by associated admins.

#### CLI

* Fixed an issue where some debug level error logs were not being displayed by the CLI.
 [#13143](https://github.com/Kong/kong/issues/13143)

#### Clustering

* Fixed an issue where hybrid mode wouldn't work if the forward proxy password contained the special character `#`.
  Note that the `proxy_server` configuration parameter still needs to be url-encoded.
  [#13457](https://github.com/Kong/kong/issues/13457)

#### Configuration

* Re-enabled the Lua DNS resolver from `proxy-wasm` by default.
 [#13424](https://github.com/Kong/kong/issues/13424)
* The behavior of the configuration option `analytics_flush_interval` has changed to save memory 
resources by flushing analytics messages more frequently. 
It now controls the maximum time interval between two flushes of analytics messages to the configured backend, 
which means that if enough (less than `analytics_buffer_size_limit`) messages have already been buffered, 
the flush will happen before the configured interval. 
Previously, Kong always tried to flush messages after the configured interval, regardless of the number of 
messages in the buffer.
* Fixed an issue where `debug_listen` incorrectly used the SSL-related configuration of `status_listen`.

#### Core

* Fixed an issue where `luarocks-admin` was not available in `/usr/local/bin`.
 [#13372](https://github.com/Kong/kong/issues/13372)
* Fixed an issue where `read` was not always passed to PostgreSQL read-only database operations.
 [#13530](https://github.com/Kong/kong/issues/13530)
* Fixed the behavior of shorthand fields, which are used to describe deprecated fields:
  * Fixed an issue with deprecated shorthand fields so that they don't take precedence over replacement fields when both are specified.
  [#13486](https://github.com/Kong/kong/issues/13486)
  * Changed the way deprecated shorthand fields are used with new fields.
  If the new field contains `null`, the deprecated field will overwrite it if both are present in the request.
  [#13592](https://github.com/Kong/kong/issues/13592)
  * If both fields are sent in the request and their values mismatch, the request will be rejected.
   [#13594](https://github.com/Kong/kong/issues/13594)
* Fixed an issue where `lua-nginx-module` context was cleared when `ngx.send_header()` triggered `filter_finalize`. 
[openresty/lua-nginx-module#2323](https://github.com/openresty/lua-nginx-module/pull/2323).
 [#13316](https://github.com/Kong/kong/issues/13316)
*  Fixed an issue where an unnecessary uninitialized variable error log was reported when 400 bad requests were received.
 [#13201](https://github.com/Kong/kong/issues/13201)
* Fixed an issue where the URI captures were unavailable when the first capture group was absent.
 [#13024](https://github.com/Kong/kong/issues/13024)
* Fixed an issue where the priority field could be set in a traditional mode route when `router_flavor` was configured as `expressions`.
 [#13142](https://github.com/Kong/kong/issues/13142)
* Fixed an issue where setting `tls_verify` to `false` didn't override the global level `proxy_ssl_verify`.
 [#13470](https://github.com/Kong/kong/issues/13470)
* Fixed an issue where the SNI cache wasn't invalidated when an SNI was updated.
 [#13165](https://github.com/Kong/kong/issues/13165)
* The `kong.logrotate` configuration file is no longer overwritten during upgrade.

  This change presents an additional prompt for Debian users upgrading via `apt` and `deb` packages.
  To accept the defaults provided by Kong in the package, use the following command, adjusting it to 
  your architecture and the version you're upgrading to: 

  ```sh
  DEBIAN_FRONTEND=noninteractive apt upgrade kong-enterprise-edition_3.8.0.0_arm64.deb
  ```
 [#13348](https://github.com/Kong/kong/issues/13348)
* Fixed an issue where the Vault secret cache got refreshed during `resurrect_ttl` time and could not be fetched by other workers.
 [#13561](https://github.com/Kong/kong/issues/13561)
* Error logs produced during Vault secret rotation are now logged at the `notice` level instead of `warn`.
 [#13540](https://github.com/Kong/kong/issues/13540)
* Fixed an issue where the `host_header` attribute of the upstream entity wouldn't be set correctly as a Host header 
in requests to the upstream during connection retries.
 [#13135](https://github.com/Kong/kong/issues/13135)
* Moved internal Unix sockets to a subdirectory (`sockets`) of the Kong prefix.
 [#13409](https://github.com/Kong/kong/issues/13409)
* Reverted the DNS client to the original behavior of ignoring the `ADDITIONAL SECTION` in DNS responses.
 [#13278](https://github.com/Kong/kong/issues/13278)
* Shortened names of internal Unix sockets to avoid exceeding the socket name limit.
 [#13571](https://github.com/Kong/kong/issues/13571)
* Built-in RBAC roles for admins (`admin` under the default workspace and `workspace-admin` under non-default workspaces) 
now disallow CRUD actions to `/groups` and `/groups/*` endpoints.
* Fixed an issue where luarocks-admin was not available in `/usr/local/bin`.
* Fixed an issue where running Kong CLI commands with database configurations containing HashiCorp Vault references would fail to execute.
* Fixed an issue where the CPs wouldn't trigger a configuration push after a keyring recovery.
* Fixed an issue where Azure Managed Identity tokens would never rotate in the case of a network failure when authenticating.
* Fixed an issue where the stale license expiry warning continued to be logged even if the license was updated.
* License expiry warnings are no longer logged and license info is removed from `/metrics` in Konnect.

#### Kong Manager
* Improved the user experience in Kong Manager by fixing various UI-related issues.
 [#232](https://github.com/Kong/kong-manager/issues/232) [#233](https://github.com/Kong/kong-manager/issues/233) [#234](https://github.com/Kong/kong-manager/issues/234) [#237](https://github.com/Kong/kong-manager/issues/237) [#238](https://github.com/Kong/kong-manager/issues/238) [#240](https://github.com/Kong/kong-manager/issues/240) [#244](https://github.com/Kong/kong-manager/issues/244) [#250](https://github.com/Kong/kong-manager/issues/250) [#252](https://github.com/Kong/kong-manager/issues/252) [#255](https://github.com/Kong/kong-manager/issues/255) [#257](https://github.com/Kong/kong-manager/issues/257) [#263](https://github.com/Kong/kong-manager/issues/263) [#264](https://github.com/Kong/kong-manager/issues/264) [#267](https://github.com/Kong/kong-manager/issues/267) [#272](https://github.com/Kong/kong-manager/issues/272)
* Fixed an issue where dynamic ordering was configurable for plugins scoped by consumers and/or consumer groups. 
  These plugins do not support dynamic ordering.
* Removed redundant data previously saved in browser's local storage.
* Fixed issues with `cluster_addresses` and `sentinel_addresses` fields for plugins that support Redis clusters.
* Fixed an issue where the overview page for Dev Portal was not correctly rendered.
* Fixed an issue where user info was not refreshed after the active admin was updated.

#### PDK

* **PDK**: Fixed an issue where the log serializer logged `upstream_status` as nil in the requests that contained subrequests.
 [#12953](https://github.com/Kong/kong/issues/12953)
* **Vault**: References ending with a slash, when parsed, will no longer return a key.
 [#13538](https://github.com/Kong/kong/issues/13538)
* Fixed an issue where `pdk.log.serialize()` threw an error when the JSON entity set by `serialize_value` contained `json.null`.
 [#13376](https://github.com/Kong/kong/issues/13376)

#### Plugins

* **Plugins with a shared Redis schema**: Fixed a Redis schema issue where `connect_timeout`, `read_timeout`, `send_timeout` 
were reset to `null` if the deprecated `timeout` was `null`.

* [**AI Proxy**](/hub/kong-inc/ai-proxy/) (`ai-proxy`)
  * Fixed an issue where certain Azure models would return partial tokens/words when in response-streaming mode.
  * Fixed an issue where Cohere and Anthropic providers didn't read the `model` parameter properly from the caller's request body.
  * Fixed an issue where using OpenAI Function inference requests would log a request error, and then hang until timeout.
  * Fixed an issue where AI Proxy would still allow callers to specify their own model, ignoring the plugin-configured model name.
  * Fixed an issue where AI Proxy would not take precedence of the plugin's configured model tuning options over those in the user's LLM request.
  * Fixed an issue where setting OpenAI SDK model parameter `null` caused analytics to not be written to the logging plugin(s).
 
  [#13000](https://github.com/Kong/kong/issues/13000)

  * Fixed an issue when response was gzipped even if the client didn't accept the format.
    [#13155](https://github.com/Kong/kong/issues/13155)
  * Fixed an issue where the object constructor would set data on the class instead of the instance.
    [#13028](https://github.com/Kong/kong/issues/13028)
  * Added a configuration validation to prevent `log_statistics` from being enabled on providers that don't support statistics.
    Accordingly, the default of `log_statistics` has changed from `true` to `false`, and a database migration has been added for 
    disabling `log_statistics` if it has already been enabled upon unsupported providers.
    [#12860](https://github.com/Kong/kong/issues/12860)

* [**AI plugins**](/hub/?category=ai)
  * Fixed an issue where certain AI plugins couldn't be applied per consumer or per service.
  [#13209](https://github.com/Kong/kong/issues/13209)
  * Fixed an issue where multi-modal inputs weren't properly validated and calculated.
  [#13445](https://github.com/Kong/kong/issues/13445)

* [**AI Prompt Guard**](/hub/kong-inc/ai-prompt-guard/) (`ai-prompt-guard`)
  * Fixed an issue which occurred when `allow_all_conversation_history` was set to false, and caused the first 
  user request to be selected instead of the last one.
   [#13183](https://github.com/Kong/kong/issues/13183)

* [**AI Request Transformer**](/hub/kong-inc/ai-request-transformer/) (`ai-request-transformer`) and 
[**AI Response Transformer**](/hub/kong-inc/ai-response-transformer/) (`ai-response-transformer`)
  * Fixed an issue where Cloud Identity authentication was not used in `ai-request-transformer` and `ai-response-transformer` plugins.

* [**Prometheus**](/hub/kong-inc/prometheus/) (`prometheus`) 
  * Improved error logging when having an inconsistent label count.
   [#13020](https://github.com/Kong/kong/issues/13020)
  * Fixed an issue where the CP/DP compatibility check was missing for the new configuration field `ai_metrics`.
   [#13417](https://github.com/Kong/kong/issues/13417)

* [**ACME**](/hub/kong-inc/acme/) (`acme`) 
  * Fixed an issue where the DP would report that deprecated config fields were used when configuration was pushed from the CP.
   [#13069](https://github.com/Kong/kong/issues/13069)
  * Fixed an issue where username and password were not accepted as valid authentication methods.
   [#13496](https://github.com/Kong/kong/issues/13496)

* [**AWS Lambda**](/hub/kong-inc/aws-lambda) (`aws-lambda`)
  * Fixed an issue where the plugin didn't work with `multiValueHeaders` defined in proxy integration and legacy `empty_arrays_mode`.
   [#13381](https://github.com/Kong/kong/issues/13381)
  * Fixed an issue where the `version` field wasn't set in the request payload when `awsgateway_compatible` was enabled.
   [#13018](https://github.com/Kong/kong/issues/13018)

* [**CORS**](/hub/kong-inc/cors/) (`cors`)
  * Fixed an issue where the `Access-Control-Allow-Origin` header was not sent when `conf.origins` had multiple entries but included `*`.
   [#13334](https://github.com/Kong/kong/issues/13334)

* [**Correlation ID**](/hub/kong-inc/correlation-id/) (`correlation-id`)
  * Fixed an issue where the plugin would not work if you explicitly set the `generator` to `null`.
   [#13439](https://github.com/Kong/kong/issues/13439)

* [**gRPC-Gateway**](/hub/kong-inc/grpc-gateway/) (`grpc-gateway`)
  * When there is a JSON decoding error, the plugin now responds with status 400 and error information in the body instead of status 500.
   [#12971](https://github.com/Kong/kong/issues/12971)

* [**HMAC Authentication**](/hub/kong-inc/hmac-auth/) (`hmac-auth`), [**JWT**](/hub/kong-inc/jwt/) (`jwt`), [**LDAP Authentication**](/hub/kong-inc/ldap-auth/) (`ldap-auth`), and [**OAuth2**](/hub/kong-inc/oauth2/) (`oauth2`)
  * Added WWW-Authenticate headers to 401 responses.
   [#11791](https://github.com/Kong/kong/issues/11791)
   [#11792](https://github.com/Kong/kong/issues/11792)
   [#11820](https://github.com/Kong/kong/issues/11820)
   [#11833](https://github.com/Kong/kong/issues/11833)

* [**HTTP Log**](/hub/kong-inc/http-log/) (`http-log`)
  * Fixed an issue where the plugin didn't include port information in the HTTP host header when sending requests to the log server.
   [#13116](https://github.com/Kong/kong/issues/13116)

* [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`)
  * Fixed an issue where the plugin couldn't obtain the value when the path parameter name contained hyphen characters.
  * Fixed an issue where parameter serialization didn't behave the same as in the OpenAPI specification.
  * Fixed an issue where the non-string primitive types passed via URL query were unexpectedly cast to string when the OpenAPI spec version was v3.1.0.

* [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`)
  * Fixed an issue where migration failed when upgrading from versions earlier than 3.3.x to 3.7.x.
   [#13391](https://github.com/Kong/kong/issues/13391)
  * Removed redundant deprecation warnings.
   [#13220](https://github.com/Kong/kong/issues/13220)
  * Improved the accuracy of sampling decisions.
   [#13275](https://github.com/Kong/kong/issues/13275)

* [**Zipkin**](/hub/kong-inc/zipkin/) (`zipkin`)
  * Removed redundant deprecation warnings.
   [#13220](https://github.com/Kong/kong/issues/13220)
  * Improved the accuracy of sampling decisions.
   [#13275](https://github.com/Kong/kong/issues/13275)

* [**Request Transformer**](/hub/kong-inc/request-transformer/) (`request-transformer`)
  * Fixed an issue where renamed query parameters, url-encoded body parameters, 
  and JSON body parameters were not handled properly when the target name was the same as the source name in the request.
  [#13358](https://github.com/Kong/kong/issues/13358)

* [**Basic Auth**](/hub/kong-inc/basic-auth/) (`basic-auth`)
  * Fixed an issue where the realm field wasn't recognized for older Kong Gateway versions (earlier than 3.6.x).
   [#13042](https://github.com/Kong/kong/issues/13042)
  * Added WWW-Authenticate headers to all 401 responses and realm option.
   [#11833](https://github.com/Kong/kong/issues/11833)

* [**Key Auth**](/hub/kong-inc/key-auth/) (`key-auth`)
  * Fixed an issue where the realm field wasn't recognized for older Kong Gateway versions (earlier than 3.7).
   [#13042](https://github.com/Kong/kong/issues/13042)

* [**Request Size Limiting**](/hub/kong-inc/request-size-limiting/) (`request-size-limiting`)
  * Fixed an issue where the body size didn't get checked when the request body was buffered to a temporary file.
   [#13303](https://github.com/Kong/kong/issues/13303)

* [**Response Rate Limiting**](/hub/kong-inc/response-ratelimiting/) (`response-ratelimiting`)
  * Fixed an issue where the DP would report that deprecated config fields were used when configuration was pushed from the CP.
   [#13069](https://github.com/Kong/kong/issues/13069)

* [**Rate Limiting**](/hub/kong-inc/rate-limiting/) (`rate-limiting`)
  * Fixed an issue where the DP would report that deprecated config fields were used when configuration was pushed from the CP.
   [#13069](https://github.com/Kong/kong/issues/13069)

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Timer spikes no longer occur when there is network instability with the central data store.
  * Fixed an issue where, if the `window_size` in the consumer group overriding config was different 
    from the `window_size` in the default config, the rate limiting of that consumer group would fall back to local strategy.
  * Fixed an issue where the sync timer could stop working due to a race condition.

* [**Proxy Cache**](/hub/kong-inc/proxy-cache/) (`proxy-cache`)
  * Fixed an issue where the Age header was not being updated correctly when serving cached responses.
   [#13387](https://github.com/Kong/kong/issues/13387)

* [**OAuth 2.0 Introspection**](/hub/kong-inc/oauth2-introspection/) (`oauth2-introspection`)
  * Fixed an issue where the consumer's cache couldn't be invalidated when the OAuth2 Introspection plugin used `client_id` as `consumer_by`.

* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Fixed an issue where anonymous consumers could be cached as nil under a certain condition.
  * Updated the rediscovery to use a short lifetime (5s) if the last discovery failed.
  * Fixed an issue where `using_pseudo_issuer` didn't work when sending `PATCH` requests.

* [**AI Rate Limiting Advanced**](/hub/kong-inc/ai-rate-limiting-advanced/) (`ai-rate-limiting-advanced`)
  * Edited the logic for the window adjustment and fixed missing passing window to shared memory.

* [**TLS Metadata Headers**](/hub/kong-inc/tls-metadata-headers/) (`tls-metadata-headers`)
  * Fixed an issue where the intermediate certificate's details were not added to request headers.

* [**Key Authentication Encrypted**](/hub/kong-inc/key-auth-enc/) (`key-auth-enc`)
  * Added WWW-Authenticate headers to all 401 responses.

* [**LDAP Authentication Advanced**](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * Added WWW-Authenticate headers to all 401 responses.

* [**DeGraphQL**](/hub/kong-inc/degraphql/) (`degraphql`)
  * Fixed an issue where multiple parameter types were not handled correctly when converting query parameters.

* [**Proxy Cache Advanced**](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cache-advanced`)
  * Fixed an issue where the Age header was not being updated correctly when serving cached requests.

* [**Request Validator**](/hub/kong-inc/request-validator/) (`request-validator`)
  * Fixed an issue where the plugin could fail to handle requests when `param_schema` was `$ref schema`.
  * Added a new configuration field `content_type_parameter_validation` to determine whether to enable Content-Type parameter validation.

* [**StatsD**](/hub/kong-inc/statsd/) (`statsd`)
  * Fixed an issue where the exported workspace was always `default` when the workspace identifier was set to the workspace name.

### Performance

* Fixed an inefficiency issue in the Luajit hashing algorithm.
 [#13240](https://github.com/Kong/kong/issues/13240)
* Removed unnecessary DNS client initialization.
 [#13479](https://github.com/Kong/kong/issues/13479)
* Improved latency performance when gzipping/gunzipping large data (such as CP/DP config data).
 [#13338](https://github.com/Kong/kong/issues/13338)
* Improved the performance of Konnect Analytics by fetching the Rate Limiting context more efficiently.
* Improved the performance of Konnect Analytics by optimizing the buffering mechanism.

### Dependencies

- Bumped `lua-resty-acme` to 0.15.0 to support username/password auth with Redis.
 [#12909](https://github.com/Kong/kong/issues/12909)
- Bumped `lua-resty-aws` to 1.5.3 to fix a bug related to the STS regional endpoint.
 [#12846](https://github.com/Kong/kong/issues/12846)
- Bumped `lua-resty-events` to 0.3.0.
 [#13097](https://github.com/Kong/kong/issues/13097)
- Bumped `lua-resty-healthcheck` from 3.0.1 to 3.1.0 to reduce active healthcheck timer usage.
 [#13038](https://github.com/Kong/kong/issues/13038)
- Bumped `lua-resty-lmdb` to 1.4.3 (lmdb 0.9.33)
 [#12786](https://github.com/Kong/kong/issues/12786)
- Bumped `lua-resty-openssl` to 1.5.1.
 [#12665](https://github.com/Kong/kong/issues/12665)
- Bumped OpenResty to 1.25.3.2
 [#12327](https://github.com/Kong/kong/issues/12327)
- Bumped PCRE2 to 10.44 to fix some bugs and organize the release.
 [#12366](https://github.com/Kong/kong/issues/12366)
- Introduced a yieldable JSON library `lua-resty-simdjson`,
which significantly improves latency.
 [#13421](https://github.com/Kong/kong/issues/13421)
- Bumped `lua-protobuf` to 0.5.2
 [#12834](https://github.com/Kong/kong/issues/12834)
- Bumped LuaRocks from 3.11.0 to 3.11.1
 [#12662](https://github.com/Kong/kong/issues/12662)
- Bumped `ngx_wasm_module` to `96b4e27e10c63b07ed40ea88a91c22f23981db35`
 [#12011](https://github.com/Kong/kong/issues/12011)
- Bumped `Wasmtime` version to 23.0.2
 [#12011](https://github.com/Kong/kong/issues/12011)
- Made the RPM package relocatable with the default prefix set to `/`.
 [#13468](https://github.com/Kong/kong/issues/13468)
* Bumped `libxml2` to 2.12.9.
* Bumped `libxslt` to 1.1.42.
* Bumped `msgpack-c` to 6.1.0.
* Bumped `kong-lua-resty-kafka` to 0.20 to support TCP socket keepalive and allow `client_id` 
to be set for the Kafka client.
* Bumped `lua-resty-jsonschema-rs` to 0.1.5
* Bumped `lua-resty-cookie` to 0.3.0
* Bumped `lua-resty-azure` to 1.6.0 to support more Azure authentication methods.
* Bumped `luaexpat` to 1.5.2.
* Bumped `kong-redis-cluster` to 1.5.4, fixing the following issues:
  * Fixed an issue where Kong Gateway couldn't recover if partial or all pods were restared with new IPs in Kubernetes environment.
  * Fixed a memory leak issue where the master nodes cache expanded infinitely upon refresh.
  * Fixed an issue where multiple cluster instances were accidentally flushed.

### Known issues

* In the [JSON Threat Protection plugin](/hub/kong-inc/json-threat-protection/configuration/), the default value of `-1`
for any of the `max_*` parameters indicates unlimited.
In some environments (such as ARM64-based environments), the default value is interpreted incorrectly.
The plugin can erroneously block valid requests if any of the parameters continue with the default values.
To mitigate this issue, configure the JSON Threat Protection plugin with limits for all of the `max_*` parameters.


## 3.7.1.5
**Release Date** 2025/04/10

### Fixes

#### Core

* Updated the AWS Vault supported regions list to the latest available.

#### Plugins

* [**AppDynamics**](/hub/kong-inc/app-dynamics/) (`app-dynamics`)
  * Fixed segmentation fault on Kong exit caused by missing destructor call.

* [**LDAP Authentication Advanced**](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * Fixed an issue where a binary string was truncated at the first null character.

* [**Session**](/hub/kong-inc/session/) (`session`)
  * Fixed an issue where boolean configuration fields `hash_subject` (default `false`) and `store_metadata` (default `false`) stored the session's metadata in the database. This also resolves an issue with Dev Portal, where adding these fields to `portal_session_conf` wasn't working as expected.

## 3.7.1.4
**Release Date** 2025/02/25

### Fixes
#### Core

* Fixed an issue where a certificate entity configured with a vault reference was occasionally not refreshed on time when initialized with an invalid string.

### Dependencies

* Bumped `libexpat` from 2.6.2 to 2.6.4 to fix a crash in the XML_ResumeParser function caused by XML_StopParser stopping an uninitialized parser.
* Bumped `lua-kong-nginx-module` from 0.11.0 to 0.11.2.
* Bumped `libxml2` to 2.12.9 to address [CVE-2024-40896](https://nvd.nist.gov/vuln/detail/CVE-2024-40896).

## 3.7.1.3
**Release Date** 2024/11/26

### Fixes
#### Core

* The `kong.logrotate` configuration file is no longer overwritten during upgrade.

  This change presents an additional prompt for Debian users upgrading via `apt` and `deb` packages.
  To accept the defaults provided by Kong in the package, use the following command, adjusting it to 
  your architecture and the version you're upgrading to: 

  ```sh
  DEBIAN_FRONTEND=noninteractive apt upgrade kong-enterprise-edition_3.4.3.11_arm64.deb
  ```
* **Vault**: 
  * Fixed an issue where updating a vault entity in a non-default workspace didn't take effect.
  * Fixed an issue where the Vault secret cache got refreshed during `resurrect_ttl` time and could not be fetched by other workers.
* Moved internal Unix sockets to a subdirectory (`sockets`) of the Kong prefix.
* Shortened names of internal Unix sockets to avoid exceeding the socket name limit.
* Fixed an issue where `luarocks-admin` was not available in `/usr/local/bin`.
* Fixed an issue where AWS IAM assume role could not be used in AWS IAM Database Authentication, by using the following fields: `pg_iam_auth_assume_role_arn`, `pg_iam_auth_role_session_name`, `pg_ro_iam_auth_assume_role_arn`, and `pg_ro_iam_auth_role_session_name`.
* Fixed an issue where the STS endpoint could not be configured manually in RDS IAM Authentication, AWS Vault, and AWS Lambda plugin. For RDS IAM Authentication,
it can be configured by `pg_iam_auth_sts_endpoint_url` and `pg_ro_iam_auth_sts_endpoint_url`; for AWS Vault, it can be configured by `vault_aws_sts_endpoint_url` as a global configuration, or `sts_endpoint_url` on a custom AWS vault entity; for the AWS Lambda plugin, it can be configured by `aws_sts_endpoint_url`.

#### Plugins

* [**AI Proxy**](/hub/kong-inc/ai-proxy/) (`ai-proxy`)
  * Fixed an issue where certain Azure models would return partial tokens/words when in response-streaming mode.
  * Fixed an issue where Cohere and Anthropic providers didn't read the `model` parameter properly from the caller's request body.
  * Fixed an issue where using OpenAI Function inference requests would log a request error, and then hang until timeout.
  * Fixed an issue where AI Proxy would still allow callers to specify their own model, ignoring the plugin-configured model name.
  * Fixed an issue where the AI Proxy plugin's configured model tuning options would not take precedence over those in the user's LLM request.
  * Fixed an issue where setting OpenAI SDK model parameter `null` caused analytics to not be written to the logging plugin(s).
 
  [#13000](https://github.com/Kong/kong/issues/13000)

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed an issue where, if the `window_size` in the consumer group overriding config was different 
    from the `window_size` in the default config, the rate limiting of that consumer group would fall back to local strategy.
  * Fixed an issue where the sync timer could stop working due to a race condition.

### Dependencies

* Bumped `lua-resty-aws` to 1.5.3 to fix a bug related to STS regional endpoint.
* Bumped `lua-resty-azure` to 1.6.1 to fix a `GET` request build issue, which was causing problems with Azure secret references.
* Made the RPM package relocatable with the default prefix set to `/`.

## 3.7.1.2
**Release Date** 2024/07/09

### Deprecations

* Debian 10, CentOS 7, and RHEL 7 reached their End of Life (EOL) dates on June 30, 2024. 
As of this patch, Kong is not building Kong Gateway 3.7.x installation packages or Docker images for these operating systems.
Kong is no longer providing official support for any Kong version running on these systems.

### Features

#### Plugins

* [**AWS Lambda**](/hub/kong-inc/aws-lambda) (`aws-lambda`)
  * Added the new configuration parameter `empty_arrays_mode`, which lets you control whether Kong Gateway should send 
  empty arrays (`[]`) returned by the Lambda function as empty arrays (`[]`), or as empty objects (`{}`) in JSON responses.

### Fixed

* Fixed an issue where the Dev Portal documentation link was unavailable because the official documentation was removed after 3.4.x.

### Dependencies

* Bumped `lua-resty-events` to 0.3.0 to fix race condition issues in event delivery at startup.
* Bumped `lua-resty-healthcheck` to 3.1.0 to remove version checks of the `lua-resty-events` lib.

## 3.7.1.1
**Release Date** 2024/06/22

### Fixes

* Fixed an issue where the DNS client was incorrectly using the content of the `ADDITIONAL SECTION` in DNS responses.

## 3.7.1.0
**Release Date** 2024/06/18

### Known issues
* There is an issue with the DNS client fix, where the DNS client incorrectly uses the content `ADDITIONAL SECTION` in DNS responses.
To avoid this issue, install 3.7.1.1 instead of this patch.

### Features
#### Plugins

* [**Request Validator**](/hub/kong-inc/request-validator/) (`request-validator`)
  * Added the new configuration field `content_type_parameter_validation` to determine whether to enable Content-Type parameter validation.

### Fixes
#### Core

* **DNS Client**: Fixed an issue where the Kong DNS client stored records with non-matching domain and type when parsing answers.
It now ignores records when the RR type differs from that of the query when parsing answers.
* Fixed an issue where the `host_header` attribute of the upstream entity wouldn't be set correctly as a Host header in requests to the upstream during connection retries.
* Built-in RBAC roles for admins (`admin` under the default workspace and `workspace-admin` under non-default workspaces) now disallow CRUD actions to `/groups` and `/groups/*` endpoints.
* Fixed an issue where the priority field could be set in a traditional mode route when `router_flavor` was configured as `expressions`. 

#### Plugins

* [**AI Proxy**](/hub/kong-inc/ai-proxy/) (`ai-proxy`)
  * Resolved an issue where the object constructor would set data on the class instead of the instance.

* [**Basic Authentication**](/hub/kong-inc/basic-auth/) (`basic-auth`)
  * Fixed an issue where the `realm` field wasn't recognized for Kong Gateway versions before 3.6.

* [**Key Authentication**](/hub/kong-inc/key-auth/) (`key-auth`)
  * Fixed an issue where the `realm` field wasn't recognized for Kong Gateway versions before 3.7.

* [**AI Rate Limiting Advanced**](/hub/kong-inc/ai-rate-limiting-advanced/) (`ai-rate-limiting-advanced`)
  * Fixed the logic for the window adjustment when using a sliding window.

* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Fixed an issue where anonymous consumers were being cached as `nil` under a certain condition.

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Timer spikes no longer occur when there is network instability with the central data store.

* [**Request Validator**](/hub/kong-inc/request-validator/) (`request-validator`)
  * Fixed an issue where the plugin could fail to handle requests when `param_schema` was `$ref schema`.

### Dependencies

* Bumped `lua-resty-events` to 0.2.1.
* Bumped `lua-resty-healthcheck` from 3.0.1 to 3.0.2 to fix memory leak issues by reusing a timer for the same active healthcheck target instead of running many timers.
* Bumped `lua-resty-jsonschema-rs` to 0.1.5.

## 3.7.0.0
**Release Date** 2024/05/28

### Breaking changes and deprecations

* [**AI Proxy**](/hub/kong-inc/ai-proxy/) (`ai-proxy`): To support the new messages API of Anthropic,
the upstream path of the `Anthropic` for `llm/v1/chat` route type has changed from `/v1/complete` to `/v1/messages`.
 [#12699](https://github.com/Kong/kong/issues/12699)
* **HashiCorp Vault**: 
  * Starting from this version, a string entirely made of spaces can't be specified as the `role_id` or `secret_id`
 value in the HashiCorp Vault entity when using the AppRole authentication method.
  * Starting from this version, you must specify at least one of `secret_id` or `secret_id_file` in the HashiCorp Vault 
  entity when using the AppRole authentication method.

* The **Granular Tracing** feature has been deprecated and removed.
  As part of your upgrade to 3.7, remove the following tracing-related parameters from your `kong.conf` file:

  * `tracing`
  * `tracing_write_strategy`
  * `tracing_write_endpoint`
  * `tracing_time_threshold`
  * `tracing_types`
  * `tracing_debug_header`
  * `generate_trace_details`

  We recommend transitioning to [OpenTelemetry Instrumentation](/gateway/latest/production/tracing/) instead.

### Features

#### Admin API

* Added LHS bracket filtering to search fields.
* **Audit logs:**
  * Added `request_timestamp` to `audit_objects`.
  * Added before and after aliases for LHS Brackets filters.
  * `audit_requests` and `audit_objects` can now be filtered by `request_timestamp`.
  * Changed the default ordering of `audit_requests` to be sorted by `request_timestamp` in descending order.

#### Configuration

* TLSv1.1 and lower versions are now disabled by default in OpenSSL 3.x.
 [#12420](https://github.com/Kong/kong/issues/12420)
* Introduced the [`nginx_wasm_main_shm_kv`](/gateway/latest/reference/configuration/#nginx_wasm_main_shm_kv) configuration parameter, 
which enables Wasm filters to use the Proxy-Wasm operations `get_shared_data` and
`set_shared_data` without namespaced keys.
 [#12663](https://github.com/Kong/kong/issues/12663)
* Added a deprecation field attribute to schemas to identify deprecated fields.
 [#12686](https://github.com/Kong/kong/issues/12686)
* Added the [`wasm_filters`](/gateway/latest/reference/configuration/#wasm_filters) configuration parameter for enabling individual filters.
 [#12843](https://github.com/Kong/kong/issues/12843)

#### Core

* Added `events:ai:response_tokens`, `events:ai:prompt_tokens`, and `events:ai:requests` to the anonymous report to start counting AI usage.
 [#12924](https://github.com/Kong/kong/issues/12924)
* Improved config handling when the control plane (CP) runs with the router set to the `expressions` flavor [#12967](https://github.com/Kong/kong/issues/12967):
  * If mixed config is detected and a lower data plane (DP) is attached to the CP, no config will be sent at all.
  * If the expression is invalid on the CP, no config will be sent at all.
  * If the expression is invalid on a lower DP, it will be sent to the DP. DP validation will catch the invalid config and communicate back to the CP. 
  This could result in partial config application.
 
* The route entity now supports the following fields when the 
[`router_flavor`](/gateway/latest/reference/configuration/#router_flavor) is 
`expressions`: `methods`, `hosts`, `paths`, `headers`,
`snis`, `sources`, `destinations`, and `regex_priority`.
The meaning of these fields are consistent with the [traditional route entity](/gateway/api/admin-ee/latest/#/Routes).
 [#12667](https://github.com/Kong/kong/issues/12667)
* Added support for debugging with EmmyLuaDebugger. This feature is in
tech preview and is not officially supported by Kong Inc.
 [#12899](https://github.com/Kong/kong/issues/12899)
* **Analytics**: 
  * Added the `latencies.receive_ms` and `websocket` fields.
  * Removed received time and latency from `latencies.kong_gateway_ms`.
  * Added the `sse` boolean field to the payload, which is set to `true` for Server-Sent Event requests and responses.

#### Kong Manager
* Kong Manager now supports creating and editing expressions routes using interactive in-browser editor with syntax highlighting and 
autocompletion features for Kong's Expressions language.
 [#217](https://github.com/Kong/kong-manager/issues/217)
* Kong Manager now groups parameters to provide a better user experience while configuring plugins.
* When authenticating Kong Manager with IDPs (for example, OIDC or LDAP), the source of an RBAC role is now stored in its `role_source` field. This enables the existing roles with a source of `idp` to be removed upon new logins after IDP role mapping has changed. This also allows users to switch a role's source between `local` and `idp`.

#### PDK
* Added the `latencies.receive` property to the log serializer.
 [#12730](https://github.com/Kong/kong/issues/12730)

#### Plugins

**New plugins**:
* [**AI Rate Limiting Advanced**](/hub/kong-inc/ai-rate-limiting-advanced/) (`ai-rate-limiting-advanced`): 
This plugin lets you implement a rate limit by an AI provider.
* [**AI Azure Content Safety**](/hub/kong-inc/ai-azure-content-safety/) (`ai-azure-content-safety`): 
Lets you enforce introspection of all AI Proxy requests with the Azure Content Safety service.
The plugin enables configurable thresholds for the different moderation categories, 
and reports audit results into the Kong log serializer for reporting purposes.

**Updates to existing plugins:**

* [**AI Proxy**](/hub/kong-inc/ai-proxy/) (`ai-proxy`)
  * AI Proxy now reads most prompt tuning parameters from the client, 
  while the plugin config parameters under `model_options` are now just defaults.
  This fixes support for using the respective provider's native SDK.
 [#12903](https://github.com/Kong/kong/issues/12903)
  * AI Proxy now has a [`preserve` option for `route_type`](/hub/kong-inc/ai-proxy/configuration/#config-route_type), 
  where the requests and responses are passed directly to the upstream LLM. This enables compatibility with any
  models and SDKs that may be used when calling the AI services.
 [#12903](https://github.com/Kong/kong/issues/12903)
  * Added support for [streaming event-by-event responses](/hub/kong-inc/ai-proxy/how-to/streaming/) back to the client on supported providers.
 [#12792](https://github.com/Kong/kong/issues/12792)
  * **Enterprise-only feature**: Added support for [Managed Identity authentication](/hub/kong-inc/ai-proxy/how-to/cloud-provider-authentication/) 
  when using the Azure provider with AI Proxy.

* [**Prometheus**](/hub/kong-inc/prometheus/) (`prometheus`) 
  * Added a workspace label to Prometheus plugin metrics.
 [#12836](https://github.com/Kong/kong/issues/12836)

* [**AI Prompt Guard**](/hub/kong-inc/ai-prompt-guard/) (`ai-prompt-guard`)
  * Increased the maximum length of regex expressions to 500 for the `allow` and `deny` parameters.
 [#12731](https://github.com/Kong/kong/issues/12731)

* [**JWT**](/hub/kong-inc/jwt/) (`jwt`)
  * Added support for EdDSA algorithms.
 [#12726](https://github.com/Kong/kong/issues/12726)
  * Added support for ES512, PS256, PS384, and PS512 algorithms.
 [#12638](https://github.com/Kong/kong/issues/12638)

* [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`) and [**Zipkin**](/hub/kong-inc/zipkin/) (`zipkin`)
  * The propagation module has been reworked. The new
options allow better control over the configuration of tracing header propagation.
 [#12670](https://github.com/Kong/kong/issues/12670)

* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Added support for [DPoP (Demonstrating Proof-of-Possession) token validation](/hub/kong-inc/openid-connect/how-to/demonstrating-proof-of-possession/). 
  You can enable it using the configuration parameter [`proof_of_possession_dpop`](/hub/kong-inc/openid-connect/configuration/#config-proof_of_possession_dpop).
  * Added support for JWT Secured Authorization Requests (JAR) on Authorization and Pushed Authorization (PAR) endpoints. 
  See the configuration parameter [`require_signed_request_object`](/hub/kong-inc/openid-connect/configuration/#config-require_signed_request_object).
  * Added support for JARM response modes: `query.jwt`, `form_post.jwt`, `fragment.jwt`, and `jwt`.

* [**GraphQL Proxy Cache Advanced**](/hub/kong-inc/graphql-proxy-cache-advanced/)
  * Added Redis strategy support.
  * Added the ability to resolve unhandled errors with bypass, with the request going upstream. Enable it using the [`bypass_on_err`](/hub/kong-inc/graphql-proxy-cache-advanced/configuration/#config-bypass_on_err) configuration option.

* [**JWT Signer**](/hub/kong-inc/jwt-signer/) (`jwt-signer`)
  * Added support for basic authentication and mTLS authentication to external JWKS services.
  * The plugin now supports periodically rotating the JWKS. For example, to automatically rotate `access_token_jwks_uri`, you can set the configuration option [`access_token_jwks_uri_rotate_period`](/hub/kong-inc/jwt-signer/configuration/#config-access_token_jwks_uri_rotate_period).
  * The plugin now supports adding the original JWT(s) to the upstream request header by specifying the names of the upstream request header with [`original_access_token_upstream_header`](/hub/kong-inc/jwt-signer/configuration/#config-original_access_token_upstream_header) and [`original_channel_token_upstream_header`](/hub/kong-inc/jwt-signer/configuration/#config-original_channel_token_upstream_header).
  * [`access_token_upstream_header`](/hub/kong-inc/jwt-signer/configuration/#config-access_token_upstream_header), [`channel_token_upstream_header`](/hub/kong-inc/jwt-signer/configuration/#config-channel_token_upstream_header), [`original_access_token_upstream_header`](/hub/kong-inc/jwt-signer/configuration/#config-original_access_token_upstream_header), and [`original_channel_token_upstream_header`](/hub/kong-inc/jwt-signer/configuration/#config-original_channel_token_upstream_header) should not have the same value.
  * The plugin now supports pseudo JSON values in [`add_claims`](/hub/kong-inc/jwt-signer/configuration/#config-add_claims) and [`set_claims`](/hub/kong-inc/jwt-signer/configuration/#config-set_claims). We can achieve the goal of passing multiple values to a key by passing a JSON string as the value. 
  * Added [`add_access_token_claims`](/hub/kong-inc/jwt-signer/configuration/#config-add_access_token_claims), [`set_access_token_claims`](/hub/kong-inc/jwt-signer/configuration/#config-set_access_token_claims), [`add_channel_token_claims`](/hub/kong-inc/jwt-signer/configuration/#config-add_channel_token_claims), [`set_channel_token_claims`](/hub/kong-inc/jwt-signer/configuration/#config-set_channel_token_claims) for individually adding claims to access tokens and channel tokens.
  * Added [`remove_access_token_claims`](/hub/kong-inc/jwt-signer/configuration/#config-remove_access_token_claims) and [`remove_channel_token_claims`](/hub/kong-inc/jwt-signer/configuration/#config-remove_channel_token_claims) to support the removal of claims.

* [**Mocking**](/hub/kong-inc/mocking/) (`mocking`)  
  * Added the [`custom_base_path`](/hub/kong-inc/mocking/configuration/#config-custom_base_path) field to specify a custom base path.
  Use it with the [`deck file namespace`](/deck/latest/reference/deck_file_namespace/) command.

* [**Mutual TLS Authentication**](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
  * Added the [`default_consumer`](/hub/kong-inc/mtls-auth/configuration/#config-default_consumer) option, 
  which lets you use a default consumer when the client certificate is valid 
  but doesn't match any existing consumers.

* [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`)
  * Added the new field [`api_spec_encoded`](/hub/kong-inc/oas-validation/configuration/#config-api_spec_encoded) to indicate whether the `api_spec` is URI-Encoded.
  * Add the [`custom_base_path`](/hub/kong-inc/oas-validation/configuration/#config-custom_base_path) field to specifiy a custom base path.
  Use it with the [`deck file namespace`](/deck/latest/reference/deck_file_namespace/) command.
  * The plugin now supports OpenAPI Specification v3.1.0. The plugin now switches to a new JSONSchema validator when the specification version is v3.1.0.

### Performance

* Improved proxy performance by refactoring the internal hooking mechanism.
 [#12784](https://github.com/Kong/kong/issues/12784)
* Sped up the router matching when the `router_flavor` is `traditional_compatible` or `expressions`.
 [#12467](https://github.com/Kong/kong/issues/12467)
* **OpenTelemetry**: Increased queue max batch size to 200.
 [#12488](https://github.com/Kong/kong/issues/12488)
* Sped up the tracing mechanism.

### Fixes

#### Admin API

* Fixed an issue where calling the endpoint `POST /schemas/vaults/validate` was conflicting with the endpoint 
`/schemas/vaults/:name` which only has GET implemented, 
resulting in a 405.
 [#12607](https://github.com/Kong/kong/issues/12607)
* Fixed an issue where `POST /config?flatten_errors=1` could not return a proper response if the input included duplicate upstream targets.
 [#12797](https://github.com/Kong/kong/issues/12797)
* The `/<workspace>/admins` endpoint was incorrectly used to return admins associated with a workspace based 
on their assigned RBAC roles. It has been fixed to return admins according to the workspace they belong to.

#### CLI

* Fixed an issue where the `pg_timeout` was overridden to `60s` even if `--db-timeout`
was not explicitly passed in CLI arguments.
* Fixed an issue which caused the `kong` command line tool to ignore the `lua_ssl_trusted_certificate` configuration option.

#### Clustering

* Adjusted the clustering compatibility check related to AWS Secrets Manager
to use `AK-SK` environment variables to grant IAM role permissions.
* Adjusted a clustering compatibility check related to HCV Kubernetes authentication paths.
* Adjusted a clustering compatibility check related to HashiCorp Vault Approle authentication.
* Fixed an issue where event hooks were prematurely validated in hybrid mode. 
The fix delays the validation of event hooks to the point where event hooks are emitted.

#### Configuration

* Fixed the default value for `upstream_keepalive_max_requests` in `kong.conf.default` from 1000 to 10000.
 [#12643](https://github.com/Kong/kong/issues/12643)
* Fixed an issue where an external plugin (Go, Javascript, or Python) would fail to
apply a change to the plugin config via the Admin API.
 [#12718](https://github.com/Kong/kong/issues/12718)
* Disabled the usage of the Lua DNS resolver from `proxy-wasm` by default.
 [#12825](https://github.com/Kong/kong/issues/12825)
* Set the security level of gRPC's TLS to `0` when `ssl_cipher_suite` is set to `old`.
 [#12613](https://github.com/Kong/kong/issues/12613)

#### Core

* **DNS Client**: Kong now ignores non-positive values on `resolv.conf` for options timeout, a
nd uses a default value of 2 seconds instead.
 [#12640](https://github.com/Kong/kong/issues/12640)
* Updated the file permission of `kong.logrotate` to 644
 [#12629](https://github.com/Kong/kong/issues/12629)
* Fixed an issue with data planes in hybrid mode, where a certificate entity configured with a vault 
reference was occasionally not refreshed on time.
 [#12868](https://github.com/Kong/kong/issues/12868)
* Fixed the missing router section for the output of request debugging.
 [#12234](https://github.com/Kong/kong/issues/12234)
* Fixed an issue in the internal caching logic where mutexes could get never unlocked.
 [#12743](https://github.com/Kong/kong/issues/12743)
* Fixed an issue where the router didn't work correctly
when the route's configuration changed.
 [#12654](https://github.com/Kong/kong/issues/12654)
* Fixed an issue where SNI-based routing didn't work when
using `tls_passthrough` with the `traditional_compatible` router flavor.
 [#12681](https://github.com/Kong/kong/issues/12681)
* Fixed an issue where `X-Kong-Upstream-Status` didn't appear in the response headers when the response 
was hit and returned by the Proxy Cache plugin,
 even if it was set in the `headers` parameter in the `kong.conf` file.
 [#12744](https://github.com/Kong/kong/issues/12744)
* **Vaults**:
  * Fixed vault initialization by postponing vault reference resolution to a timer in the `init_worker` phase.
  [#12554](https://github.com/Kong/kong/issues/12554)
  * Fixed an issue that allowed vault secrets to refresh even when they had no TTL set.
   [#12877](https://github.com/Kong/kong/issues/12877)
  * Fixed an issue where the vault used the wrong (default) workspace identifier when retrieving a vault entity by prefix.
  [#12572](https://github.com/Kong/kong/issues/12572)
* Fixed an unexpected table nil panic in the balancer's `stop_healthchecks` function.
 [#12865](https://github.com/Kong/kong/issues/12865)
* Kong Gateway now uses `-1` as the worker ID of the privileged agent to avoid access issues.
 [#12385](https://github.com/Kong/kong/issues/12385)
* Fixed an issue where Kong Gateway failed to properly restart MessagePack-based pluginservers (used in Python and Javascript plugins, for example).
 [#12582](https://github.com/Kong/kong/issues/12582)
* Reverted the hard-coded limitation of the `ngx.read_body()` API in OpenResty upstreams' new versions when downstream connections are in HTTP/2 or HTTP/3 stream modes.
 [#12658](https://github.com/Kong/kong/issues/12658)
* Each Kong cache instance now uses its own cluster event channel. 
This approach isolates cache invalidation events and reduces the generation of unnecessary worker events.
 [#12321](https://github.com/Kong/kong/issues/12321)
* Updated telemetry collection for AI Plugins to allow multiple plugins' data to be set for the same request.
 [#12583](https://github.com/Kong/kong/issues/12583)
* Fixed an issue where a low ulimit setting (open files) caused Kong to fail to start, 
as the `lua-resty-timer-ng` exhausted the available `worker_connections`. 
Decreased the concurrency range of the `lua-resty-timer-ng` library from `[512, 2048]` to `[256, 1024]` to fix this bug.
 [#12606](https://github.com/Kong/kong/issues/12606)
* Fixed an issue where external plugins using the protobuf-based protocol would fail to call the `kong.Service.SetUpstream` method 
with the error `bad argument #2 to 'encode' (table expected, got boolean)`.
 [#12727](https://github.com/Kong/kong/issues/12727)
* Disabled analytics in the stream module to avoid unnecessary error logs.
* Fixed an issue where a new data plane couldn't resolve a Vault reference after the first configuration push. 
This was happening due to issues with license pre-loading.
* Fixed an issue where DP couldn't resolve license-required Vault references when loading an existing lmdb.
* Fixed an issue where users were not allowed to start Kong Gateway if `admin_gui_auth_conf.scope` was missing `"openid"`, or if `"offline_access"` was missing when `admin_gui_auth` was set to `openid-connect`. Kong Gateway will now print warning logs only if `"openid"` is missing from `admin_gui_auth_conf.scope`.

#### Kong Manager

* Improved the user experience in Kong Manager by fixing various UI-related issues.

  [#185](https://github.com/Kong/kong-manager/issues/185) [#188](https://github.com/Kong/kong-manager/issues/188) [#190](https://github.com/Kong/kong-manager/issues/190) [#195](https://github.com/Kong/kong-manager/issues/195) [#199](https://github.com/Kong/kong-manager/issues/199) [#201](https://github.com/Kong/kong-manager/issues/201) [#202](https://github.com/Kong/kong-manager/issues/202) [#207](https://github.com/Kong/kong-manager/issues/207) [#208](https://github.com/Kong/kong-manager/issues/208) [#209](https://github.com/Kong/kong-manager/issues/209) [#213](https://github.com/Kong/kong-manager/issues/213) [#216](https://github.com/Kong/kong-manager/issues/216)

* Fixed an issue where the **Add Role** button was visible when authenticating with an IDP. It is now hidden when Kong Manager is set to authenticate with an IDP.
* Fixed the documentation link shown on the RBAC user form page.

#### PDK

* Fixed an issue where `kong.request.get_forwarded_port` incorrectly returned a string from `ngx.ctx.host_port`. 
It now correctly returns a number.
 [#12806](https://github.com/Kong/kong/issues/12806)

* The value of `latencies.kong` in the log serializer payload no longer includes
the response receive time, so it now has the same value as the
`X-Kong-Proxy-Latency` response header. Response receive time is recorded in
the new `latencies.receive` metric, so if desired, the old value can be
calculated as `latencies.kong + latencies.receive`.
  [#12795](https://github.com/Kong/kong/issues/12795)

  {:.note}
  > **Note:** This also affects payloads from all logging plugins that use the log serializer:
  `file-log`, `tcp-log`, `udp-log`,`http-log`, `syslog`, and `loggly`.

* **Tracing**: Enhanced the robustness of trace ID parsing.
 [#12848](https://github.com/Kong/kong/issues/12848)

#### Plugins

* Cleaned and improved error handling for AI plugins.

* [**AI Proxy**](/hub/kong-inc/ai-proxy/) (`ai-proxy`)
  * Fixed an issue where the `/llm/v1/chat` route type didn't include analytics in the responses.
 [#12781](https://github.com/Kong/kong/issues/12781)

* [**ACME**](/hub/kong-inc/acme/) (`acme`) 
  * Fixed an issue where the certificate was not successfully renewed during ACME renewal.
   [#12773](https://github.com/Kong/kong/issues/12773)
  * Fixed migration of Redis configuration.
  * Fixed an issue where the wrong error log was printed regarding private keys.

* [**AWS Lambda**](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * Fixed an issue where the latency attributed to AWS Lambda API requests was counted as part of the latency in Kong Gateway.
 [#12835](https://github.com/Kong/kong/issues/12835)

* [**JWT**](/hub/kong-inc/jwt/) (`jwt`)
  * Fixed an issue where the plugin would fail when using invalid public keys for ES384 and ES512 algorithms.
 [#12724](https://github.com/Kong/kong/issues/12724)

* [**Key Authentication**](/hub/kong-inc/key-auth/) (`key-auth`)
  * Added missing `WWW-Authenticate` headers to all 401 responses.
 [#11794](https://github.com/Kong/kong/issues/11794)

* [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`)
  * Fixed an OTEL sampling mode Lua panic bug, which happened 
when the `http_response_header_for_traceid` option was enabled.
 [#12544](https://github.com/Kong/kong/issues/12544)

* [**Rate Limiting**](/hub/kong-inc/rate-limiting/) (`rate-limiting`)
  * Fixed migration of Redis configuration.

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Refactored `kong/tools/public/rate-limiting`, adding the new interface `new_instance` to provide isolation between different plugins. 
    The original interfaces remain unchanged for backward compatibility. 
  
    If you are using custom Rate Limiting plugins based on this library, update the initialization code to the new format. For example: 
    `'local ratelimiting = require("kong.tools.public.rate-limiting").new_instance("custom-plugin-name")'`.
    The old interface will be removed in the upcoming major release.

  * Fixed an issue where any plugins using the `rate-limiting` library, when used together, 
    would interfere with each other and fail to synchronize counter data to the central data store.
  * Fixed an issue with `sync_rate` setting being used with the `redis` strategy. 
    If the Redis connection is interrupted while `sync_rate = 0`, the plugin now accurately falls back to the `local` strategy.
  * Fixed an issue where, if `sync_rate` was changed from a value greater than `0` to `0`, the namespace was cleared unexpectedly.
  * Fixed some timer-related issues where the counter syncing timer couldn't be created or destroyed properly.
  * The plugin now creates counter syncing timers during plugin execution instead of plugin creation to reduce some meaningless error logs.
  * Fixed an issue where {{site.base_gateway}} produced a log of error log entries when multiple Rate Limiting Advanced plugins shared the same namespace.

* [**Response Rate Limiting**](/hub/kong-inc/response-ratelimiting/) (`response-ratelimiting`)
  * Fixed migration of Redis configuration.

* [**DeGraphQL**](/hub/kong-inc/degraphql/) (`degraphql`)
  * Fixed an issue where GraphQL variables were not being correctly parsed and coerced into their defined types.
  * This plugin now uses a new configuration handler to update the GraphQL router with better error handling.

* [**LDAP Authentication Advanced**](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * Fixed an issue where, if the credential was encoded with no username, Kong Gateway threw an error and returned a 500 code.
  * Fixed an issue where an exception would be thrown when LDAP search failed.

* [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`), 
[**WebSocket Size Limit**](/hub/kong-inc/websocket-size-limit/) (`websocket-size-limit`), 
[**WebSocket Validator**](/hub/kong-inc/websocket-validator/) (`websocket-validator`),
 [**XML Threat Protection**](/hub/kong-inc/xml-threat-protection/) (`xml-threat-protection`)
  * The [priorities](/gateway/latest/plugin-development/custom-logic/#plugins-execution-order) of these plugins have been updated to prevent collisions between plugins.
    The relative priority (and the order of execution) of bundled plugins remains unchanged.


### Dependencies

* Bumped `atc-router` from v1.6.0 to v1.6.2
 [#12231](https://github.com/Kong/kong/issues/12231)
* Bumped `libexpat` to 2.6.2
 [#12910](https://github.com/Kong/kong/issues/12910)
* Bumped `lua-kong-nginx-module` from 0.8.0 to 0.11.0
 [#12752](https://github.com/Kong/kong/issues/12752)
* Bumped `lua-protobuf` to 0.5.1
 [#12834](https://github.com/Kong/kong/issues/12834)
* Bumped `lua-resty-acme` to 0.13.0
 [#12909](https://github.com/Kong/kong/issues/12909)
* Bumped `lua-resty-aws` from 1.3.6 to 1.4.1
 [#12846](https://github.com/Kong/kong/issues/12846)
* Bumped `lua-resty-lmdb` from 1.4.1 to 1.4.2
 [#12786](https://github.com/Kong/kong/issues/12786)
* Bumped `lua-resty-openssl` from 1.2.0 to 1.3.1
 [#12665](https://github.com/Kong/kong/issues/12665)
* Bumped `lua-resty-timer-ng` to 0.2.7
 [#12756](https://github.com/Kong/kong/issues/12756)
* Bumped PCRE from the legacy `libpcre` 8.45 to `libpcre2` 10.43
 [#12366](https://github.com/Kong/kong/issues/12366)
* Bumped `penlight` to 1.14.0
 [#12862](https://github.com/Kong/kong/issues/12862)
* Added the package `tzdata` to the DEB Docker image for convenient timezone setting
 [#12609](https://github.com/Kong/kong/issues/12609)
* Bumped `lua-resty-http` to 0.17.2.
 [#12908](https://github.com/Kong/kong/issues/12908)
* Bumped LuaRocks from 3.9.2 to 3.11.0
 [#12662](https://github.com/Kong/kong/issues/12662)
* Bumped `ngx_wasm_module` to `91d447ffd0e9bb08f11cc69d1aa9128ec36b4526`
 [#12011](https://github.com/Kong/kong/issues/12011)
* Bumped `V8` to 12.0.267.17
 [#12704](https://github.com/Kong/kong/issues/12704)
* Bumped `Wasmtime` to 19.0.0
 [#12011](https://github.com/Kong/kong/issues/12011)
* Improved the robustness of `lua-cjson` when handling unexpected input
 [#12904](https://github.com/Kong/kong/issues/12904)
* Bumped submodule `kong-openid-connect` to 2.7.1
* Bumped `kong-lua-resty-kafka` to 0.18
* Bumped `lua-resty-luasocket` to 1.1.2 to fix [luasocket#427](https://github.com/lunarmodules/luasocket/issues/427)
* Bumped `lua-resty-mail` to 1.1.0
* Bumped OpenSSL FIPS-provider to 3.0.9 to address
 [CVE-2023](https://konghq.atlassian.net/browse/CVE-2023) and [CVE-2022](https://konghq.atlassian.net/browse/CVE-2022)
* Bumped `libpasswdqc` to 2.0.3
* Bumped `lua-resty-cookie` to 0.2.0
* Bumped `lua-resty-passwdqc` to 2.0
* Bumped `xmlua` to 1.2.1
* Bumped `libxml2` to 2.12.6
* Bumped `libxslt` to 1.1.39
* Bumped `msgpack-c` to 6.0.1
* Removed the `lua-resty-openssl-aux-module` dependency

## 3.6.1.8
**Release Date** 2024/10/11

### Features
* Added support for AWS IAM role assuming in AWS IAM Database Authentication with the following new configuration fields: 
`pg_iam_auth_assume_role_arn`, `pg_iam_auth_role_session_name`, `pg_ro_iam_auth_assume_role_arn`, and `pg_ro_iam_auth_role_session_name`.
* Added support for a configurable STS endpoint for RDS IAM Authentication with the following new configuration fields:
 `pg_iam_auth_sts_endpoint_url` and `pg_ro_iam_auth_sts_endpoint_url`.
* Added support for a configurable STS endpoint for AWS Vault.
This can either be configured by `vault_aws_sts_endpoint_url` as a global configuration, or `sts_endpoint_url` on a custom AWS vault entity.

#### Plugins
* [**AWS Lambda**](/hub/kong-inc/aws-lambda) (`aws-lambda`)
  * Added support for a configurable STS endpoint with the new configuration field `aws_sts_endpoint_url`.
  [#13388](https://github.com/Kong/kong/issues/13388)

### Fixes
#### Core

* The `kong.logrotate` configuration file is no longer overwritten during upgrade.

  This change presents an additional prompt for Debian users upgrading via `apt` and `deb` packages.
  To accept the defaults provided by Kong in the package, use the following command, adjusting it to 
  your architecture and the version you're upgrading to: 

  ```sh
  DEBIAN_FRONTEND=noninteractive apt upgrade kong-enterprise-edition_3.4.3.11_arm64.deb
  ```
* **Vault**: 
  * Fixed an issue where updating a vault entity in a non-default workspace didn't take effect.
  * Fixed an issue where the Vault secret cache got refreshed during `resurrect_ttl` time and could not be fetched by other workers.
* Moved internal Unix sockets to a subdirectory (`sockets`) of the Kong prefix.
* Shortened names of internal Unix sockets to avoid exceeding the socket name limit.
* Fixed an issue where `luarocks-admin` was not available in `/usr/local/bin`.
 
#### Plugins

* [**OpenTelemetry**](/hub/kong-inc/opentelemetry) (`opentelemetry`)
  * Fixed an issue where `header_type` being `nil` caused a log message concatenation error.

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`) 
  * Fixed an issue where the sync timer could stop working due to a race condition.
  * Fixed an issue where, if the `window_size` in the consumer group overriding config was different 
    from the `window_size` in the default config, the rate limiting of that consumer group would fall back to local strategy.

* [LDAP Auth Advanced](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * Fixed an issue where an exception would be thrown when LDAP search failed.

### Dependencies

* Bumped `lua-resty-aws` to 1.5.3 to fix a bug related to the STS regional endpoint.
* Made the RPM package relocatable with the default prefix set to `/`.

## 3.6.1.7
**Release Date** 2024/07/09

### Features

### Deprecations

* Debian 10, CentOS 7, and RHEL 7 reached their End of Life (EOL) dates on June 30, 2024. 
As of this patch, Kong is not building Kong Gateway 3.6.x installation packages or Docker images for these operating systems.
Kong is no longer providing official support for any Kong version running on these systems.

#### Plugins

* [**AWS Lambda**](/hub/kong-inc/aws-lambda) (`aws-lambda`)
  * Added the new configuration parameter `empty_arrays_mode`, which lets you control whether Kong Gateway should send 
  empty arrays (`[]`) returned by the Lambda function as empty arrays (`[]`), or as empty objects (`{}`) in JSON responses.

### Dependencies

* Bumped `lua-resty-events` to 0.3.0 to fix race condition issues in event delivery at startup.
* Bumped `lua-resty-healthcheck` to 3.1.0 to remove version checks of the `lua-resty-events` lib.

## 3.6.1.6
**Release Date** 2024/06/22

### Fixes

* Fixed an issue where the DNS client was incorrectly using the content of the `ADDITIONAL SECTION` in DNS responses.

## 3.6.1.5
**Release Date** 2024/06/18

### Known issues

* There is an issue with the DNS client fix, where the DNS client incorrectly uses the content `ADDITIONAL SECTION` in DNS responses.
To avoid this issue, install 3.6.1.6 instead of this patch.

### Features
#### Admin API

* Added LHS bracket filtering to search fields.
* **Audit logs:**
  * Added `request_timestamp` to `audit_objects`.
  * Added before and after aliases for LHS Brackets filters.
  * `audit_requests` and `audit_objects` can now be filtered by `request_timestamp`.
  * Changed the default ordering of `audit_requests` to be sorted by `request_timestamp` in descending order.

#### Plugins
* [**Request Validator**](/hub/kong-inc/request-validator/) (`request-validator`)
  * Added the new configuration field `content_type_parameter_validation` to determine whether to enable Content-Type parameter validation.

### Fixes
#### Admin API

* The `/<workspace>/admins` endpoint was incorrectly used to return admins associated with a workspace based 
on their assigned RBAC roles. This has been fixed and now accurately returns admins according to their specific workspace associations.

#### CLI

* Fixed an issue where the `pg_timeout` was overridden to `60s` even if `--db-timeout`
was not explicitly passed in CLI arguments.

#### Core

* Built-in RBAC roles for admins (`admin` under the default workspace and `workspace-admin` 
under non-default workspaces) now disallow CRUD actions to `/groups` and `/groups/*` endpoints.
* **DNS Client**: Fixed an issue where the Kong DNS client stored records with non-matching domain and type when parsing answers.
It now ignores records when the RR type differs from that of the query when parsing answers.
* Fixed an issue where the `host_header` attribute of the upstream entity wouldn't be set correctly as a Host header in requests to the upstream during connection retries.

#### Plugins

* [**Basic Authentication**](/hub/kong-inc/basic-auth/) (`basic-auth`)
  * Fixed an issue where the `realm` field wasn't recognized for Kong Gateway versions before 3.6.

* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Fixed an issue where anonymous consumers were being cached as `nil` under a certain condition.

* [**Request Validator**](/hub/kong-inc/request-validator/) (`request-validator`)
  * Fixed an issue where the plugin could fail to handle requests when `param_schema` was `$ref schema`.

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Timer spikes no longer occur when there is network instability with the central data store.

* [**ACME**](/hub/kong-inc/acme/) (`acme`), [**Rate Limiting**](/hub/kong-inc/rate-limiting/) (`rate-limiting`), and 
[**Response Rate Limiting**](/hub/kong-inc/response-ratelimiting/) (`response-ratelimiting`)
  * Fixed migration of Redis configuration.

### Dependencies

* Bumped `lua-resty-azure` from 1.4.1 to 1.5.0 to refine some error logging.
* Bumped `lua-resty-events` to 0.2.1.
* Bumped `lua-resty-healthcheck` from 3.0.1 to 3.0.2 to fix memory leak issues by reusing a timer for the same active healthcheck target instead of running many timers.
* Improved the robustness of `lua-cjson` when handling unexpected input.

## 3.6.1.4
**Release Date** 2024/05/14

### Features
#### Plugins

* [**Portal Application Registration**](/hub/kong-inc/application-registration/) (`application-registration`)
  * Added support for accessing the service using consumer credential authentication. 
  To use this functionality, enable `enable_proxy_with_consumer_credential` (default is `false`).

* [**Mutual TLS Authentication**](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
  * Added the `default_consumer` option, which lets you use a default consumer when the client certificate is valid 
  but doesn't match any existing consumers.

### Fixes

#### Clustering
* Fixed an issue where event hooks were prematurely validated in hybrid mode. 
The fix delays the validation of event hooks to the point where event hooks are emitted.

#### Core

* Fixed an issue with data planes in hybrid mode, where a certificate entity configured with a vault 
reference was occasionally not refreshed on time.

* Fixed vault initialization by postponing vault reference resolution to a timer in the `init_worker` phase.

#### PDK

* Fixed an issue where `kong.request.get_forwarded_port` incorrectly returned a string from `ngx.ctx.host_port`. 
It now correctly returns a number.

#### Plugins

* [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`), 
[**WebSocket Size Limit**](/hub/kong-inc/websocket-size-limit/) (`websocket-size-limit`), 
[**WebSocket Validator**](/hub/kong-inc/websocket-validator/) (`websocket-validator`),
 [**XML Threat Protection**](/hub/kong-inc/xml-threat-protection/) (`xml-threat-protection`)
  * The priorities of these plugins have been updated to prevent collisions between plugins.
    The relative priority (and the order of execution) of bundled plugins remains unchanged.

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Refactored `kong/tools/public/rate-limiting`, adding the new interface `new_instance` to provide isolation between different plugins. 
  The original interfaces remain unchanged for backward compatibility. 
  
    If you are using custom Rate Limiting plugins based on this library, update the initialization code to the new format. For example: 
    `'local ratelimiting = require("kong.tools.public.rate-limiting").new_instance("custom-plugin-name")'`.
    The old interface will be removed in the upcoming major release.

### Dependencies

* Bumped `lua-protobuf` to 0.5.1.

## 3.6.1.3
**Release Date** 2024/04/16

### Fixes

#### Kong Manager
* Fixed an issue where the admin account profile page returned a 404 error if the `admin_gui_path` was not a slash.

#### Plugins
* [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`)
  * Improved robustness of parsing for short trace IDs.

## 3.6.1.2
**Release Date** 2024/04/08

### Features

#### Plugins

* [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`)
  * Added the new field `api_spec_encoded` to indicate whether the `api_spec` is URI-encoded.

### Fixes

#### Clustering

* Adjusted the clustering compatible check related to AWS Secrets Manager
to use `AK-SK` environment variables to grant IAM role permissions.

#### Configuration

* Fixed an issue where an external plugin (Go, Javascript, or Python) would fail to
apply a change to the plugin config via the Admin API.

#### Core

* Updated the file permission of `kong.logrotate` to 644.
* Vaults: 
  * Fixed an issue where the vault used the wrong (default) workspace identifier when retrieving a vault entity by prefix.
  * Fixed an issue where a new data plane couldn't resolve a Vault reference after the first configuration push. 
    This was happening due to issues with license pre-loading.
* Fixed an issue where users were not allowed to start Kong Gateway if `admin_gui_auth_conf.scope` was missing `"openid"`, 
or if `"offline_access"` when `admin_gui_auth` was set to `openid-connect`. 
Kong Gateway will now only print warning logs if `"openid"` is missing from `admin_gui_auth_conf.scope`.

#### Kong Manager Enterprise

* Fixed the display of the remaining days for the license expiration date.
* Updated the type of RBAC token for the RBAC user to `password`.

#### Plugins

* [**ACME**](/hub/kong-inc/acme/) (`acme`)
  * Fixed an issue where the certificate was not successfully renewed during ACME renewal.

* [**DeGraphQL**](/hub/kong-inc/degraphql/) (`degraphql`)
  * Fixed an issue where GraphQL variables were not being correctly parsed and coerced into their defined types.

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed an issue where any plugins using the `rate-limiting` library, when used together, 
  would interfere with each other and fail to synchronize counter data to the central data store.

#### Dependencies

* Bumped `lua-resty-openssl` to 1.2.1
* Bumped PCRE from the legacy `libpcre` 8.45 to `libpcre2` 10.43
* Bumped `lua-kong-nginx-module` to 0.8.1
* Bumped `kong-lua-resty-kafka` to 0.18
* Bumped `lua-resty-luasocket` to 1.1.2 to fix [luasocket#427](https://github.com/lunarmodules/luasocket/issues/427)


## 3.6.1.1
**Release Date** 2024/03/05

### Fixes

#### Clustering

* Adjusted a clustering compatibility check related to HashiCorp Vault Approle authentication.

#### Core

* Fixed the missing router section for the output of request debugging.
* Reverted the hard-coded limitation of the `ngx.read_body()` API in OpenResty upstreams' new versions when downstream connections are in HTTP/2 or HTTP/3 stream modes.

#### Kong Manager and Konnect
* Fixed an issue where custom plugins were missing from the plugin selection page.
* Fixed an issue where the service was not prefilled in the route form while using the expressions router.

#### Plugins
* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed an issue with `sync_rate` setting being used with the `redis` strategy. 
  If the Redis connection is interrupted while `sync_rate = 0`, the plugin now accurately falls back to the `local` strategy.
  * Fixed an issue where, if `sync_rate` was changed from a value greater than `0` to `0`, the namespace was cleared unexpectedly.
  * Fixed some timer-related issues where the counter syncing timer couldn't be created or destroyed properly.
  * The plugin now creates counter syncing timers during plugin execution instead of plugin creation to reduce some meaningless error logs.

## 3.6.1.0
**Release Date** 2024/02/26

### Features

#### Configuration

* TLSv1.1 and lower is now disabled by default in OpenSSL 3.x.

#### Plugins

* [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`)
  * Increased queue max batch size to 200.

### Fixes

#### General 

* Fixed a bug where a low ulimit setting (open files) caused Kong to fail to start, 
as the `lua-resty-timer-ng` exhausted the available `worker_connections`. 
Decreased the concurrency range of the `lua-resty-timer-ng` library from `[512, 2048]` to `[256, 1024]` to fix this bug.

#### Configuration

* Set the security level of gRPC's TLS to `0` when `ssl_cipher_suite` is set to `old`.

#### Clustering

* Adjusted a clustering compatibility check related to HCV Kubernetes authentication paths.

#### Plugins

* [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`)
  * Fixed an OTEL sampling mode Lua panic bug that occurred when the `http_response_header_for_traceid` option was enabled.

* [**LDAP Authentication Advanced**](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * Fixed an issue where, if the credential was encoded with no username, Kong Gateway threw an error and returned a 500 code.

## 3.6.0.0
**Release Date** 2024/02/12

### Breaking changes and deprecations


* Kong Gateway 3.6.0.0 requires a higher limit on the number of file descriptions than 1024 to function properly. This requirement will be removed in a subsequent version. We recommend setting the `ulimit -n` to at least 4096 when running Kong Gateway 3.6.0.0.
* To avoid ambiguity with other Wasm-related `nginx.conf` directives, the prefix for Wasm `shm_kv` nginx.conf directives was changed from `nginx_wasm_shm_` to `nginx_wasm_shm_kv_`.
 [#11919](https://github.com/Kong/kong/issues/11919)

* The listing endpoints for consumer groups (`/consumer_groups`) and consumers (`/consumers`) now respond
  with paginated results. The JSON key for the list has been changed to `data` instead of `consumer_groups`
  or `consumers`.

* In OpenSSL 3.2, the default SSL/TLS security level has been changed from 1 to 2.
  This means the security level is set to 112 bits of security. 
  As a result, the following are prohibited:
    * RSA, DSA, and DH keys shorter than 2048 bits
    * ECC keys shorter than 224 bits
    * Any cipher suite using RC4
    * SSL version 3
  Additionally, compression is disabled.

* The recent OpenResty bump includes TLS 1.3 and deprecates TLS 1.1. 
If you still need to support TLS 1.1, set the [`ssl_cipher_suite`](/gateway/latest/reference/configuration/#ssl_cipher_suite) setting to `old`.

* If you are using `ngx.var.http_*` in custom code to access HTTP headers, the behavior of that variable changes slightly when the same header is used multiple times in a single request. 
Previously, it would return the first value only; now it returns all of the values, separated by commas. Kong Gateway's PDK header getters and setters work as before.

* Kong Manager now uses the session management mechanism in the OpenID Connect plugin.
`admin_gui_session_conf` is no longer required when authenticating with OIDC. Instead, session-related
configuration parameters are set in `admin_gui_auth_conf` (like `session_secret`).

   See the [migration guide](/gateway/3.6.x/kong-manager/auth/oidc/migrate/) for more information.

#### Plugins

* [**ACME**](/hub/kong-inc/acme/) (`acme`), [**Rate Limiting**](/hub/kong-inc/rate-limiting/) (`rate-limiting`), and [**Response Rate Limiting**](/hub/kong-inc/response-ratelimiting/) (`response-ratelimiting`)
  * Standardized Redis configuration across plugins. The Redis configuration now follows a common schema that is shared across other plugins.
  [#12300](https://github.com/Kong/kong/issues/12300)  [#12301](https://github.com/Kong/kong/issues/12301)

* [**Azure Functions**](/hub/kong-inc/azure-functions/) (`azure-functions`): 
  * The Azure Functions plugin now eliminates the upstream/request URI and only uses the [`routeprefix`](/hub/kong-inc/azure-functions/configuration/#config-routeprefix) 
configuration field to construct the request path when requesting the Azure API.

* [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`) 
  * The plugin now bypasses schema validation when the content type is not `application/json`.

* [**Proxy Cache Advanced**](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cache-advanced`)
  * Removed the undesired `proxy-cache-advanced/migrations/001_035_to_050.lua` file, which blocked migration from OSS to Enterprise. 
    This is a breaking change only if you are upgrading from a Kong Gateway version between `0.3.5` and `0.5.0`.

* [**SAML**](/hub/kong-inc/saml) (`saml`)
  * Adjusted the priority of the SAML plugin to 1010 to correct the integration between the SAML plugin and other consumer-based plugins.

### Features

#### Admin API

* Added the Kong Gateway edition to the root endpoint (`/`) of the Admin API.
 [#12097](https://github.com/Kong/kong/issues/12097)
* Enabled `status_listen` on `127.0.0.1:8007` by default.
 [#12304](https://github.com/Kong/kong/issues/12304)
* FIPS enablement status now responds to license changes. 
Introduced a new endpoint, `/fips-status`, to show its current status.
* Added pagination support for `/consumer_group/consumers` and `/consumer/consumer_groups`.

#### CLI

* Automatically reinitializes the workspace entity counters after executing the CLI change migrations commands.

#### Clustering

* Added the data plane certificate expiry date to the control plane API response (`/clustering/data-planes`).
 [#11921](https://github.com/Kong/kong/issues/11921)
* Added resilience support for homogeneous data plane deployments. Data planes can now act as importers and exporters at the same time, 
and Kong Gateway will try to control the concurrency when exporting the config.
* Data plane nodes running in Konnect will now report config reload failures to the control plane, such as invalid configuration or transient errors.
* Kong Gateway now prints log entries noting possible config options that may be causing a data plane to control plane connection error.

#### Configuration

* Kong Gateway now displays a warning message when Kong Manager is enabled but the Admin API is not enabled.
 [#12071](https://github.com/Kong/kong/issues/12071)
* Added the DHE-RSA-CHACHA20-POLY1305 cipher to the intermediate configuration.
 [#12133](https://github.com/Kong/kong/issues/12133)
* The default value of the `dns_no_sync` configuration option has been changed to `off`.
 [#11869](https://github.com/Kong/kong/issues/11869)
* Added support for injecting Nginx directives into Kong's proxy location block.
 [#11623](https://github.com/Kong/kong/issues/11623)
* The LMDB cache is now validated by Kong's version (major and minor),
wiping the contents if there is a tag mismatch to avoid compatibility issues
during minor version upgrades.
 [#12026](https://github.com/Kong/kong/issues/12026)
* Bumped `dns_stale_ttl` default to 1 hour so the stale DNS record can be used for a longer amount of time in case of resolver downtime.
[#12087](https://github.com/Kong/kong/issues/12087)
* Bumped the default values of `nginx_http_keepalive_requests` and `upstream_keepalive_max_requests` to `10000`. 
These changes are optimized to work better in systems with high throughput. 
In a low-throughput setting, these new settings may have visible effects in load balancing, where it can take more requests to start 
using all the upstreams than before.
 [#12223](https://github.com/Kong/kong/issues/12223)

#### Core

* Added telemetry collection for AI Proxy, AI Request Transformer, and AI Response Transformer plugins, 
pertaining to model and provider usage.
 [#12495](https://github.com/Kong/kong/issues/12495)
* Added the `ngx_brotli` module to kong prebuild nginx.
  See the [documentation](/gateway/latest/production/performance/brotli/) to learn how to enable Brotli compression for Kong Gateway.
 [#12367](https://github.com/Kong/kong/issues/12367)
* You can now pass a primary key as a full entity to DAO functions.
 [#11695](https://github.com/Kong/kong/issues/11695)
* The Debian variant of the Kong Gateway Docker image is now built using Debian 12.
 [#12218](https://github.com/Kong/kong/issues/12218)
* The expressions router now supports the `!` (not) operator, which allows creating routes like
`!(http.path =^ "/a")` and `!(http.path == "/a" || http.path == "/b")`.
 [#12419](https://github.com/Kong/kong/issues/12419)
* Added a `source` property to the log serializer, indicating that the response is generated by `kong` or `upstream`.
 [#12052](https://github.com/Kong/kong/issues/12052)
* Ensure that Kong-owned directories are cleaned up after an uninstall using the system's package manager.
 [#12162](https://github.com/Kong/kong/issues/12162)
* Kong Gateway now supports [`http.path.segments.len` and `http.path.segments.*`](/gateway/latest/key-concepts/routes/expressions/#matching-fields)
 fields in the expressions router, which allows matching incoming (normalized) request paths by individual 
 segments or ranges of segments, and checking the total number of segments.
 [#12283](https://github.com/Kong/kong/issues/12283)
* The `net.src.*` and `net.dst.*` match fields are now accessible in HTTP routes defined using expressions.
 [#11950](https://github.com/Kong/kong/issues/11950)
* Extended support for getting and setting Kong Gateway values via `proxy-wasm` properties in the `kong.*` namespace.
 [#11856](https://github.com/Kong/kong/issues/11856)
* Added an `examples` field to the metaschema.
* Added new `upstream_status` and `source` properties to the analytics pusher.
* Added `consumer_groups` support for analytics.
* The HashiCorp Vault secrets management backend now supports the AppRole authentication method. Added support for namespaced authentication and user-defined authentication paths when using HashiCorp Vault on Kubernetes.
* Kong Gateway now uses the values provided by the Request ID header for all request ID fields, for better consistency.
* Dot keys (for example, `a.b.c`) are now excluded from both audit requests and audit objects, 
and singular keys (for example, `password`) are excluded recursively.
* Kong Gateway Enterprise container images are now produced with build provenance and signed using cosign. 
Signatures and attestations are published to the Docker Hub repository. 
Build provenance can be [verified by cosign/slsa-verifier](/gateway/3.6.x/kong-enterprise/provenance-verification/) 
using the published attestations.

#### Kong Manager Enterprise

* You can now use an RBAC token to authenticate while using 
[group mapping with Kong Manager](/gateway/3.6.x/kong-manager/auth/oidc/mapping/) (for example, with OIDC or LDAP).
* Added support for creating and editing the Route by Header plugin from the UI.
* Added an onboarding flow to make it easier for new users to start using Kong Gateway.
* The workspace and overview summary pages now have a new design.

#### Kong Manager Open Source

* Added a JSON/YAML format preview for all entity forms.
 [#157](https://github.com/Kong/kong-manager/issues/157)
* Adopted resigned basic components for better UI/UX.
 [#131](https://github.com/Kong/kong-manager/issues/131) [#166](https://github.com/Kong/kong-manager/issues/166)
* Kong Manager and Konnect now share the same UI for the plugin selection page and the plugin form page.
 [#143](https://github.com/Kong/kong-manager/issues/143) [#147](https://github.com/Kong/kong-manager/issues/147)

#### PDK

* Increased the precision of JSON number encoding from 14 to 16 decimals.
 [#12019](https://github.com/Kong/kong/issues/12019)

#### Performance 

* Fix incorrect LuaJIT LDP/STP fusion on ARM64 which sometimes caused incorrect logic.
* Bumped the concurrency range of the `lua-resty-timer-ng` library from `[32, 256]` to `[512, 2048]`.
 [#12275](https://github.com/Kong/kong/issues/12275)
* Cooperatively yield when building statistics of routes to reduce the impact to proxy path latency.
 [#12013](https://github.com/Kong/kong/issues/12013)

#### Plugins

**New plugins**:
* [**AI Proxy**](/hub/kong-inc/ai-proxy/) (`ai-proxy`): Enables simplified integration with various AI provider Large Language Models (LLMs).
 [#12323](https://github.com/Kong/kong/issues/12323)
* [**AI Prompt Decorator**](/hub/kong-inc/ai-prompt-decorator/) (`ai-prompt-decorator`): Prepend and append `llm/v1/chat` messages onto consumer LLM requests for prompt tuning.
 [#12336](https://github.com/Kong/kong/issues/12336)
* [**AI Prompt Guard**](/hub/kong-inc/ai-prompt-guard/) (`ai-prompt-guard`): Set up allow or block lists for LLM requests based on pattern matching.
 [#12427](https://github.com/Kong/kong/issues/12427)
* [**AI Prompt Template**](/hub/kong-inc/ai-prompt-template/) (`ai-prompt-template`): Set up an array of LLM prompt templates with variable substitutions.
 [#12340](https://github.com/Kong/kong/issues/12340)
* [**AI Request Transformer**](/hub/kong-inc/ai-request-transformer/) (`ai-request-transformer`): Pass mid-flight client requests to an LLM for transformation or sanitization.
 [#12426](https://github.com/Kong/kong/issues/12426)
* [**AI Response Transformer**](/hub/kong-inc/ai-response-transformer/) (`ai-response-transformer`): Pass mid-flight upstream responses to an LLM for transformation or sanitization.
 [#12426](https://github.com/Kong/kong/issues/12426)

Learn more about these plugins in the [AI Gateway quickstart](/gateway/latest/get-started/ai-gateway/).

**Existing plugins**:

* **Consumer groups support**: The following plugins can now be scoped to consumer groups:
  * IP Restriction
  * Rate Limiting
  * Request Termination
  * Proxy Cache
  * Proxy Cache Advanced

* [**ACL**](/hub/kong-inc/acl/) (`acl`)
  * The plugin now includes the configuration parameter `include_consumer_groups`, which lets you specify whether
    Kong consumer groups can be added to allow and deny lists.

* [**AppDynamics**](/hub/kong-inc/app-dynamics/) (`app-dynamics`)
  * This plugin now supports using self-signed certificates via the `CONTROLLER_CERTIFICATE_FILE`
   and `CONTROLLER_CERTIFICATE_DIR` environment configuration options.

* [**LDAP Authentication Advanced**](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * This plugin now supports decoding non-standard `asn1` integers and enumerated encoding with redundant leading padding.

* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * The configuration parameters `scopes`, `login_redirect_uri`, `logout_redirect_uri`, and `introspection_headers_values` 
  can now be referenced as secrets in the Kong Vault.
  * Extended the `token_post_args_client` configuration parameter to support injection from headers.
  * Added support for explicit proof key for code exchange (PKCE).
  * Added support for pushed authorization requests (PAR).
  * Added support for the `tls_client_auth` and `self_signed_tls_client_auth` authentication methods, allowing 
  [mTLS client authentication](/hub/kong-inc/openid-connect/how-to/client-authentication/mtls/) with the IdP.

* [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`)
  * Tracing sampling rate can now be set via the [`config.sampling_rate`](/hub/kong-inc/opentelemetry/configuration/#configsampling_rate) property of the OpenTelemetry plugin 
  instead of just being a global setting for Kong Gateway.
 [#12054](https://github.com/Kong/kong/issues/12054)

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Enhanced the resolution of the RLA sliding window weight.

### Fixes

#### Admin API

* Enhanced error responses for authentication failures in the Admin API.
 [#12456](https://github.com/Kong/kong/issues/12456)
* Fixed an issue where the `/rbac/roles/:role/endpoints` endpoint did not accept `actions` as an array.
* The workspace listing API now only shows workspaces that the current user has endpoints associated with.
* Fixed an issue where HTTP 500 errors were returned when paginating and sorting by timestamp fields
(for example, `created_at`).
* Fixed an issue where unique violation errors were reported while trying to update the `user_token`
with the same value on the same RBAC user.
* Disallowed admins and RBAC users from updating their own roles.

#### CLI

* The CLI no longer reinitializes workspace entity counters when migrating from CE to EE.

#### Clustering

* Fixed a bug causing data plane status updates to fail when an empty PING frame was received from a data plane.
 [#11917](https://github.com/Kong/kong/issues/11917)
* Fixed an issue where the data plane's log serializer output had a workspace name under hybrid mode.
* Reduced message push error logs when the `cluster_telemetry_endpoint` config is disabled.
* Clustering analytics now shows `-1` as the worker ID for the privileged agent.

#### Configuration

* Fixed a data loss error caused by a weakly-typed `of` function in the `declarative_config_flattened` function.
 [#12167](https://github.com/Kong/kong/issues/12167)
* Kong Gateway now respects custom `proxy_access_log` values.
 [#12073](https://github.com/Kong/kong/issues/12073)

#### Core

* You can no longer delete a CA cert if it's still referenced by other entities. 
The related CA store caches are invalidated when a CA cert is updated.
 [#11789](https://github.com/Kong/kong/issues/11789)
* Cookie names are now validated against RFC 6265, which allows more characters than the previous validation.
 [#11881](https://github.com/Kong/kong/issues/11881)
* Nulls are now removed only if the schema has transformations definitions.
This improves performance, as most schemas don't define transformations.
 [#12284](https://github.com/Kong/kong/issues/12284)
* Fixed a bug where the `error_handler` couldn't provide the meaningful response body when the internal error code 494 is triggered.
 [#12114](https://github.com/Kong/kong/issues/12114)
* Header value matching (`http.headers.*`) in the `expressions` router flavor is now case sensitive.
This change doesn't affect `traditional_compatible` mode
where header value matching is always performed with the case ignored.
 [#11905](https://github.com/Kong/kong/issues/11905)
* Fixed an incorrect error message that appeared when a plugin failed. 
 [#11800](https://github.com/Kong/kong/issues/11800)
* Fixed intermittent ldoc failures caused by a LuaJIT error.
 [#11983](https://github.com/Kong/kong/issues/11983)
* The `NGX_WASM_MODULE_BRANCH` environment variable now sets the `ngx_wasm_module` repository branch when building Kong.
 [#12241](https://github.com/Kong/kong/issues/12241)
* Eliminated an asynchronous timer in `syncQuery()` to prevent hang risk.
 [#11900](https://github.com/Kong/kong/issues/11900)
* Tracing fixes:
  * Fixed an issue where a DNS query failure would cause a tracing failure.
  [#11935](https://github.com/Kong/kong/issues/11935)
  * DNS spans are now correctly generated for upstream DNS queries, in addition to cosocket queries.
  [#11996](https://github.com/Kong/kong/issues/11996)
* Expressions routes in `http` and `stream` subsystems now have stricter validation.
Previously, they shared the same validation schema, so admins could configure expressions
routes using fields like `http.path` even for stream routes. This is no longer allowed.
 [#11914](https://github.com/Kong/kong/issues/11914)
* Kong Gateway now validates private and public keys for the `keys` entity to ensure they match each other.
 [#11923](https://github.com/Kong/kong/issues/11923)
* Fixed the `previous plan already attached` error in `proxy-wasm`, which occurred when a filter triggered re-entrancy of the access handler.
 [#12452](https://github.com/Kong/kong/issues/12452)
* Fixed an RBAC issue which required adding missing endpoints to all workspaces.
* Dismissed a confusing debug log entry from the Redis rate limiting tool.
* Fixed an issue where workload identity didn't work for dataplane resilience.
* Fixed an issue where the GCP backend vault would hide the error message when secrets couldn't be fetched.
* Added the missing `workspace_id` to the output of request debugging when using a filter.
* Fixed an issue where the IAM auth token was not refreshed when the underlying AWS credential expired.
* Redis's `timeout` warning message is only printed if the timeout is set explicitly. If it isn't set, the default timeout value is used.
* Removed inaccurate critical level logs which appeared when starting external plugin servers.
These logs can't be suppressed due to a limitation of OpenResty. We chose to remove the socket availability detection feature.

#### Kong Manager Enterprise

* Fixed issues with Admin GUI authentication using OpenID Connect, including `session`, `response_mode`, and RP-initiated logout.
* Corrected the UI descriptions under Teams when mapping roles from external sources (for example, OIDC or LDAP).
* Kong Manager now supports operating keys scoped to a specific keyset without permissions on the `/keys/*` endpoint.
* Fixed various issues encountered while authenticating the Admin API via OpenID Connect.

#### Kong Manager Open Source

* Standardized notification text format.
 [#140](https://github.com/Kong/kong-manager/issues/140)

#### PDK

* Optimized performance by avoiding unnecessary creations and garbage collections of spans.
 [#12080](https://github.com/Kong/kong/issues/12080)
* `response.set_header` now correctly supports header arguments with a table array of strings.
 [#12164](https://github.com/Kong/kong/issues/12164)
* Fixed an issue where, when using `kong.response.exit`, the Transfer-Encoding header set by the user wasn't removed.
 [#11936](https://github.com/Kong/kong/issues/11936)
* **Plugin Server**: Fixed an issue where every request caused a new plugin instance to be created.
 [#12020](https://github.com/Kong/kong/issues/12020)

#### Plugins

* [**Basic Authentication**](/hub/kong-inc/basic-auth/) (`basic-auth`)
  * Added missing `WWW-Authenticate` headers to 401 responses.
 [#11795](https://github.com/Kong/kong/issues/11795)

* [**Datadog**](/hub/kong-inc/datadog/) (`datadog`)
  * Fixed an issue where the plugin wasn't triggered for serviceless routes. 
  The Datadog plugin is now always triggered, and the value of tag `name`(`service_name`) is set as an empty value.
 [#12068](https://github.com/Kong/kong/issues/12068)

* [**Forward Proxy**](/hub/kong-inc/forward-proxy/) (`forward-proxy`)
  * The plugin now falls back to the non-streaming proxy when the request body has already been read.
  * Fixed an issue where request payload was being discarded when the payload exceeded the `client_body_buffer_size`.

* [**JWE Decrypt**](/hub/kong-inc/jwe-decrypt/) (`jwe-decrypt`)
  * Fixed a typo in an error message.

* [**JWT Signer**](/hub/kong-inc/jwt-signer/) (`jwt-signer`)
  * Added support for consumer group scoping by using the PDK `kong.client.authenticate` function.

* [**LDAP Authentication Advanced**](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * Added support for consumer group scoping by using the PDK `kong.client.authenticate` function.
  * Fixed some cache-related issues which caused `groups_required` to return unexpected codes after a non-200 response.

* [**Mocking**](/hub/kong-inc/mocking/) (`mocking`)  
  * Fixed an issue where valid recursive schemas were always rejected.
  * Fixed an issue where the plugin failed to return the mock response when `responses` contained `default` or wildcard codes like `2XX`.
  * The plugin now prints a `notice` log entry if a revocation check fails with `revocation_check_mode = IGNORE_CA_ERROR`.

* [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`) 
  * Fixed an issue where the plugin throws a runtime error caused by the ref parameter schema not being dereferenced.
  * Exposed metrics for serviceless routes.
  * Fixed an issue where the plugin threw a runtime error while validating parameters with the AnyType schema and style keyword defined.
  * Fixed an issue where the cookie parameters weren't being validated.
  * Fixed an issue where the `nullable` keyword didn't take effect.
  * Fixed an issue where the request path couldn't matched when containing regex escape characters.
  The URI component escaped characters were incorrectly unescaped.

* [**OAuth 2.0 Introspection**](/hub/kong-inc/oauth2-introspection/) (`oauth2-introspection`)
  * Added support for consumer group scoping by using the PDK `kong.client.authenticate` function.
  * The `authorization_value` configuration parameter can now be encrypted.

* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`) 
  * Fixed logout URI suffix detection by using the normalized version of `kong.request.get_forwarded_path()` instead of 
  `ngx.var.request_uri`, especially when passing query strings to logout.
  * The `introspection_headers_values` configuration parameter can now be encrypted.
  * Removed the unwanted argument `ignore_signature.userinfo` from the `userinfo_load` function.
  * Added support for consumer group scoping by using the PDK `kong.client.authenticate` function.
  * Fixed the cache key collision when config `issuer` and `extra_jwks_uris` contain the same URI.
  * The plugin now correctly handled boundary conditions for token expiration time checking.
  * The plugin now updates the time when calculating token expiration.

* [**Prometheus**](/hub/kong-inc/prometheus/) (`prometheus`)
  * Exposed metrics for serviceless routes.
 [#11781](https://github.com/Kong/kong/issues/11781)

* [**Proxy Cache Advanced**](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cache-advanced`)
  * Removed the undesired `proxy-cache-advanced/migrations/001_035_to_050.lua` file, which blocked migration from OSS to Enterprise. 
    This is a breaking change only if you are upgrading from a Kong Gateway version between `0.3.5` and `0.5.0`.

* [**Rate Limiting**](/hub/kong-inc/rate-limiting/) (`rate-limiting`)
  * The plugin now provides better accuracy in counters when `sync_rate` is used with the Redis policy.
 [#11859](https://github.com/Kong/kong/issues/11859)
  * Fixed an issue where all counters were synced to the same database at the same rate.
 [#12003](https://github.com/Kong/kong/issues/12003)

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * The plugin now checks for query errors in the Redis pipeline.
  * The plugin now checks if `sync_rate` is `nil` or `null` when calling the `configure()` phase. 
  If it is `nil` or `null`, the plugin skips the sync with the database or with Redis.

* [**Request Validator**](/hub/kong-inc/request-validator/) (`request-validator`)
  * The plugin now validates the request body schema when `json` is the suffix value in the request content type's subtype (for example, `application/merge-patch+json`).

* [**Route Transformer Advanced**](/hub/kong-inc/route-transformer-advanced/) (`route-transformer-advanced`)
  * Improved error messages.

* [**SAML**](/hub/kong-inc/saml/) (`saml`)
  * Added support for consumer group scoping by using the PDK `kong.client.authenticate` function.

### Dependencies

* Bumped `atc-router` from 1.2.0 to 1.6.0
 [#12231](https://github.com/Kong/kong/issues/12231)
* Bumped `kong-lapis` from 1.14.0.3 to 1.16.0.1
 [#12064](https://github.com/Kong/kong/issues/12064)
* Bumped `LPEG` from 1.0.2 to 1.1.0
 [#11955](https://github.com/Kong/kong/issues/11955)
* Bumped `lua-messagepack` from 0.5.2 to 0.5.3
 [#11956](https://github.com/Kong/kong/issues/11956)
* Bumped `lua-messagepack` from 0.5.3 to 0.5.4
 [#12076](https://github.com/Kong/kong/issues/12076)
* Bumped `lua-resty-aws` from 1.3.5 to 1.3.6
 [#12439](https://github.com/Kong/kong/issues/12439)
* Bumped `lua-resty-healthcheck` from 3.0.0 to 3.0.1
 [#12237](https://github.com/Kong/kong/issues/12237)
* Bumped `lua-resty-lmdb` from 1.3.0 to 1.4.1
 [#12026](https://github.com/Kong/kong/issues/12026)
* Bumped `lua-resty-timer-ng` from 0.2.5 to 0.2.6
 [#12275](https://github.com/Kong/kong/issues/12275)
* Bumped `OpenResty` from 1.21.4.2 to 1.25.3.1
 [#12327](https://github.com/Kong/kong/issues/12327)
* Bumped `OpenSSL` from 3.1.4 to 3.2.1
 [#12264](https://github.com/Kong/kong/issues/12264)
- Bump `resty-openssl` from 0.8.25 to 1.2.0
 [#12265](https://github.com/Kong/kong/issues/12265)
* Bumped `ngx_brotli` to master branch, and disabled it on rhel7, rhel9-arm64, and amazonlinux-2023-arm64 due to toolchain issues
 [#12444](https://github.com/Kong/kong/issues/12444)
* Bumped `lua-resty-healthcheck` from 1.6.3 to 3.0.0
 [#11834](https://github.com/Kong/kong/issues/11834)
* Bumped `ngx_wasm_module` to `a7087a37f0d423707366a694630f1e09f4c21728`
 [#12011](https://github.com/Kong/kong/issues/12011)
* Bumped `Wasmtime` to `14.0.3`
 [#12011](https://github.com/Kong/kong/issues/12011)
* Bumped submodule `kong-openid-connect` to 2.7.0
* Bumped `kong-redis-cluster` to 1.5.3
* Bumped `jq` to 1.7.1
* Bumped `luasec` to 1.3.2

### Known issues

* The recent OpenResty bump includes TLS 1.3 and deprecates TLS 1.1. 
If you still need to still support TLS 1.1, set the [`ssl_cipher_suite`](/gateway/latest/reference/configuration/#ssl_cipher_suite) setting to `old`.
* If you are using `ngx.var.http_*` in custom code in order to access HTTP headers, the behavior of that variable changed slightly when the same header is used multiple times in a single request. Previously it would return the first value only, now it returns all the values, separated by commas. Kong's PDK header getters and setters work as before.


## 3.5.0.7
**Release Date** 2024/07/09

### Deprecations

* Debian 10, CentOS 7, and RHEL 7 reached their End of Life (EOL) dates on June 30, 2024. 
As of this patch, Kong is not building Kong Gateway 3.5.x installation packages or Docker images for these operating systems.
Kong is no longer providing official support for any Kong version running on these systems.

### Features

#### Plugins

* [**AWS Lambda**](/hub/kong-inc/aws-lambda) (`aws-lambda`)
  * Added the new configuration parameter `empty_arrays_mode`, which lets you control whether Kong Gateway should send 
  empty arrays (`[]`) returned by the Lambda function as empty arrays (`[]`), or as empty objects (`{}`) in JSON responses.

## 3.5.0.6
**Release Date** 2024/06/22

### Fixes

* Fixed an issue where the DNS client was incorrectly using the content of the `ADDITIONAL SECTION` in DNS responses.

## 3.5.0.5
**Release Date** 2024/06/18

### Known issues

* There is an issue with the DNS client fix, where the DNS client incorrectly uses the content `ADDITIONAL SECTION` in DNS responses.
To avoid this issue, install 3.5.0.6 instead of this patch.

### Features
#### Admin API

* Added LHS bracket filtering to search fields.
* **Audit logs:**
  * Added `request_timestamp` to `audit_objects`.
  * Added before and after aliases for LHS Brackets filters.
  * `audit_requests` and `audit_objects` can now be filtered by `request_timestamp`.

#### Plugin

* [**Portal Application Registration**](/hub/kong-inc/application-registration/) (`application-registration`)
  * Added support for accessing the service using consumer credential authentication. 
  To use this functionality, enable `enable_proxy_with_consumer_credential` (default is `false`).

### Fixes
#### Core

* **DNS Client**: Fixed an issue where the Kong DNS client stored records with non-matching domain 
and type when parsing answers.
It now ignores records when the RR type differs from that of the query when parsing answers.
* Fixed an issue where the `host_header` attribute of the upstream entity wouldn't be set correctly 
as a Host header in requests to the upstream during connection retries.
* Built-in RBAC roles for admins (`admin` under the default workspace and `workspace-admin` 
under non-default workspaces) now disallow CRUD actions to `/groups` and `/groups/*` endpoints.

#### Plugins

* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Fixed an issue where anonymous consumers were being cached as `nil` under a certain condition.

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Timer spikes no longer occur when there is network instability with the central data store.

#### Admin API

* The `/<workspace>/admins` endpoint was incorrectly used to return admins associated with a workspace based 
on their assigned RBAC roles. This has been fixed and now accurately returns admins according to their specific workspace associations.
* Fixed an issue with the workspace listing API, which showed workspaces that the user didn't have any roles in.
The API now only shows workspaces that a user has access to.

### Dependencies

* Bumped `lua-resty-azure` from 1.4.1 to 1.5.0 to refine some error logging.
* Bumped `lua-resty-events` to 0.2.1.
* Bumped `lua-resty-healthcheck` from 1.6.4 to 1.6.5 to fix memory leak issues by reusing a timer for the same active healthcheck target instead of running many timers.

## 3.5.0.4 
**Release Date** 2024/05/20

### Breaking Changes

* In OpenSSL 3.2, the default SSL/TLS security level has been changed from 1 to 2.
  This means the security level is set to 112 bits of security. 
  As a result, the following are prohibited:
    * RSA, DSA, and DH keys shorter than 2048 bits
    * ECC keys shorter than 224 bits
    * Any cipher suite using RC4
    * SSL version 3
  Additionally, compression is disabled.
* The recent OpenResty bump includes TLS 1.3 and deprecates TLS 1.1. 
If you still need to support TLS 1.1, set the [`ssl_cipher_suite`](/gateway/3.5.x/reference/configuration/#ssl_cipher_suite) setting to `old`.

### Features
#### Configuration

* TLSv1.1 and lower is now disabled by default in OpenSSL 3.x.
* Added resilience support for homogeneous data plane deployments. 
Data planes can now act as importers and exporters at the same time, 
and Kong Gateway will try to control the concurrency when exporting the config.

#### Core

* The HashiCorp Vault secrets management backend now supports the AppRole authentication method.
* You can now use an RBAC token to authenticate while using 
[group mapping with Kong Manager](/gateway/3.5.x/kong-manager/auth/oidc/mapping/) (for example, with OIDC or LDAP).
* Expressions router:
  *  The expressions router now supports the `!` (not) operator, which allows creating routes like
`!(http.path =^ "/a")` and `!(http.path == "/a" || http.path == "/b")`.
  * Kong Gateway now supports [`http.path.segments.len` and `http.path.segments.*`](/gateway/3.5.x/key-concepts/routes/expressions/#matching-fields)
  fields in the expressions router, which allows matching incoming (normalized) request paths by individual 
  segments or ranges of segments, and checking the total number of segments.
  * The [`net.src.*` and `net.dst.*`](/gateway/3.5.x/key-concepts/routes/expressions/#matching-fields) 
  match fields are now accessible in HTTP routes defined using expressions.

#### Admin API

* Changed the default ordering of `audit_requests` to sorted by `request_timestamp` in descending order.
* Added the Kong Gateway edition to the root endpoint of the Admin API.

#### Plugins

* [**mTLS Auth**](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
  * Added a `default_consumer` option, which allows a default consumer to be used when the 
  client certificate is valid but doesn't match any existing consumers.

* [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`)
  * Added the new field `api_spec_encoded` to indicate whether the `api_spec` is URI-encoded.

[**LDAP Authentication Advanced**](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * The plugin now supports decoding non-standard `asn1` integer and enumerated encoded with redundant leading padding.

### Fixes

#### Admin API

* Fixed an issue where HTTP 500 errors were returned when paginating and sorting by timestamp fields
(for example, `created_at`).
* It is no longer possible for admins or RBAC users to update their own roles.

#### Clustering

* Fixed an issue where event hooks were prematurely validated in hybrid mode. 
The fix delays the validation of event hooks to the point where event hooks are emitted.
* Adjusted the clustering compatible check related to AWS Secrets Manager
to use `AK-SK` environment variables to grant IAM role permissions.
* Adjusted a clustering compatibility check related to HCV Kubernetes authentication paths.
* Reduce message push error logs when the `cluster_telemetry_endpoint` config is disabled.

#### Configuration

* Fixed an issue where an external plugin (Go, Javascript, or Python) would fail to
apply a change to the plugin config via the Admin API.
* Set the security level of gRPC's TLS to `0` when `ssl_cipher_suite` is set to `old`.

#### Core

* Fixed an issue with data planes in hybrid mode, where a certificate entity configured with a vault 
reference was occasionally not refreshed on time.
* Fixed an issue where external pluginservers would not start automatically with Kong Gateway.
* Fixed vault initialization by postponing vault reference resolution to a timer in the `init_worker` phase.
* Updated the file permission of `kong.logrotate` to 644.
* Fixed the missing router section for the output of request debugging.
* Vaults:
  * Fixed an issue where the vault used the wrong (default) workspace identifier when retrieving a vault entity by prefix.
  * Fixed an issue where a new data plane couldn't resolve a Vault reference after the first configuration push. 
    This was happening due to issues with license pre-loading.
* Header value matching (`http.headers.*`) in the `expressions` router flavor is now case sensitive.
This change doesn't affect `traditional_compatible` mode
where header value matching is always performed with the case ignored.
* Expressions routes in `http` and `stream` subsystems now have stricter validation.
Previously, they shared the same validation schema, so admins could configure expressions
routes using fields like `http.path` even for stream routes. This is no longer allowed.
* Fixed an RBAC issue which required adding missing endpoints to all workspaces.
* Fixed an issue where workload identity didn't work for dataplane resilience.
* Fixed an issue where the GCP backend vault would hide the error message when secrets couldn't be fetched.

#### Kong Manager Enterprise

* Fixed an issue where the admin account profile page returned a 404 error if the `admin_gui_path` was not a slash.
* Fixed the display of the remaining days for the license expiration date. 
The number of days was inconsistent between the workspaces page and the top banner.
* Updated the type of RBAC token for the RBAC user to `password`.

#### PDK

* Fixed an issue where `kong.request.get_forwarded_port` incorrectly returned a string from `ngx.ctx.host_port`. 
It now correctly returns a number.

#### Plugins

* [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`), 
[**WebSocket Size Limit**](/hub/kong-inc/websocket-size-limit/) (`websocket-size-limit`), 
[**WebSocket Validator**](/hub/kong-inc/websocket-validator/) (`websocket-validator`),
 [**XML Threat Protection**](/hub/kong-inc/xml-threat-protection/) (`xml-threat-protection`)
  * The priorities of these plugins have been updated to prevent collisions between plugins.
    The relative priority (and the order of execution) of bundled plugins remains unchanged.
* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Refactored `kong/tools/public/rate-limiting`, adding the new interface `new_instance` to provide isolation between different plugins. 
  The original interfaces remain unchanged for backward compatibility. 

    If you are using custom Rate Limiting plugins based on this library, update the initialization code to the new format. For example: 
    `'local ratelimiting = require("kong.tools.public.rate-limiting").new_instance("custom-plugin-name")'`.
    The old interface will be removed in the upcoming major release.

* [**OpenTelemetry**](/hub/kong-inc/opentelemetry) (`opentelemetry`)
  * Improved robustness of parsing for short trace IDs.

* [**ACME**](/hub/kong-inc/acme/) (`acme`)
  * Fixed an issue where the certificate was not successfully renewed during ACME renewal.
* [**DeGraphQL**](/hub/kong-inc/degraphql/) (`degraphql`)
  * Fixed an issue where GraphQL variables were not being correctly parsed and coerced into their defined types.
* [**Rate Limiting**](/hub/kong-inc/rate-limiting/) (`rate-limiting`), [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`), [**GraphQL Rate Limiting Advanced**](/hub/kong-inc/graphql-rate-limiting-advanced/) (`graphql-rate-limiting-advanced`), and [**Response Rate Limiting**](/hub/kong-inc/response-ratelimiting/) (`response-ratelimiting`)
  * Fixed an issue where any plugins using the `rate-limiting` library, when used together, 
  would interfere with each other and fail to synchronize counter data to the central data store.

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed an issue with `sync_rate` setting being used with the `redis` strategy. 
  If the Redis connection is interrupted while `sync_rate = 0`, the plugin now accurately falls back to the `local` strategy.
  * Fixed an issue where, if `sync_rate` was changed from a value greater than `0` to `0`, the namespace was cleared unexpectedly.
  * Fixed some timer-related issues where the counter syncing timer couldn't be created or destroyed properly.
  * The plugin now creates counter syncing timers during plugin execution instead of plugin creation to reduce some meaningless error logs.

* [**LDAP Authentication Advanced**](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * Fixed an issue where, if the credential was encoded with no username, Kong Gateway would return a 500 error code.

* [**OpenTelemetry**](/hub/kong-inc/opentelemetry) (`opentelemetry`)
  * Fixed an OTEL sampling mode Lua panic bug that occurred 
  when the `http_response_header_for_traceid` option was enabled.

* [**Forward Proxy**](/hub/kong-inc/forward-proxy/) (`forward-proxy`)
  * The plugin now falls back to the non-streaming proxy when the request body has already been read.
* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Marked the `introspection_headers_values` as an encrypted and referenceable field.
  * Added support for consumer group scoping by using the PDK `kong.client.authenticate` function.
* [**OAuth 2.0 Introspection**](/hub/kong-inc/oauth2-introspection/) (`oauth2-introspection`)
  * Added support for consumer group scoping by using the PDK `kong.client.authenticate` function.
* [**SAML**](/hub/kong-inc/saml) (`saml`)
  * Added support for consumer group scoping by using the PDK `kong.client.authenticate` function.
* [**JWT Signer**](/hub/kong-inc/jwt-signer/) (`jwt-signer`)
  * Added support for consumer group scoping by using the PDK `kong.client.authenticate` function.
* [**LDAP Authentication Advanced**](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * Fixed some cache-related issues which caused `groups_required` to return unexpected codes after a non-200 response.
  * Added support for consumer group scoping by using the PDK `kong.client.authenticate` function.
* [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`) 
  * Fixed an issue where cookie parameters were not being validated.

### Performance
#### Configuration

* Bumped the default values of `nginx_http_keepalive_requests` and `upstream_keepalive_max_requests` to 10000.

#### Core

* Improved the robustness of `lua-cjson` when handling unexpected input.
* Reuse match context between requests to avoid frequent memory allocation or deallocation.

#### Plugins

* [**OpenTelemetry**](/hub/kong-inc/opentelemetry) (`opentelemetry`)
  * Increased queue max batch size to 200. 

### Dependencies

* Bumped `atc-router` from 1.2.0 to 1.6.0.
* Bumped `lua-protobuf` to 0.5.1.
* Bumped `lua-resty-openssl` to 1.2.1.
* Bumped OpenSSL from 3.1.4 to 3.2.0.
* Bumped `resty-openssl` from 0.8.25 to 1.2.0.
* Bumped `lua-kong-nginx-module` to 0.8.1.
* Bumped `kong-lua-resty-kafka` to `0.18`.
* Bumped `lua-resty-luasocket` to `1.1.2` to fix [luasocket#427](https://github.com/lunarmodules/luasocket/issues/427).
* Bumped `lua-resty-healthcheck` to 1.6.4.
* Bumped `lua-resty-aws` to 1.3.6.

## 3.5.0.3
**Release Date** 2024/01/26

### Features

* The Debian variant of the Kong Gateway Docker image is now built using Debian 12.
 [#7673](https://github.com/Kong/kong/issues/7673)

* Added pagination support for nested consumer lists and consumer group lists, 
both in the Admin API and in Kong Manager.

### Fixes
#### Kong Manager

* Fixed an issue where the dynamic ordering dropdown list didn't show custom plugins.
* Fixed an issue where the targets page showed a 404 error in any workspace except `default`.
* Fixed an issue where the role of the current workspace couldn't be created by the `workspace-super-admin`.

### Dependencies

* Bumped `kong-redis-cluster` to 1.5.3.

## 3.5.0.2
**Release Date** 2023/12/21

### Breaking Changes
#### Plugins
* [**SAML**](/hub/kong-inc/saml) (`saml`)
  * Adjusted the priority of the SAML plugin to 1010 to correct the integration between the SAML plugin and other consumer-based plugins.

### Features
#### Configuration
* The default value of the [`dns_no_sync`](/gateway/3.4.x/reference/configuration/#dns_no_sync) option has been changed to `off`.

#### Plugins
* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Configurations `scopes`, `login_redirect_uri`, `logout_redirect_uri` can now be referenced as a secret in the Kong Vault.
  * Extend `token_post_args_client` to support injection from headers.

### Fixes
#### Core
- Dismissed confusing debug log from Redis tool of rate limiting. 
- Fixed the missing `workspace_id` in the output of request debugging when using the filter.
- Eliminated asynchronous timer in syncQuery() to prevent risk of query hanging.
- Fixed ldoc intermittent failure caused by LuaJIT error. [#7494](https://github.com/Kong/kong/issues/7494)

#### PDK
- Fixed an issue in the plugin server where every request caused a new plugin instance to be created.

#### Plugin
* [**OAuth 2.0 Introspection**](/hub/kong-inc/oauth2-introspection/) (`oauth2-introspection`)
  * Marked the `authorization_value` as an encrypted field. 
* [**JWE Decrypt**](/hub/kong-inc/jwe-decrypt/) (`jwe-decrypt`)
  * Fixed typo in `jwe-decrypt` error message.
* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Fixed logout uri suffix detection by using normalized version of `kong.request.get_forwarded_path()` instead of `ngx.var.request_uri`, especially when passing query strings to logout.
  * Updated time when calculating token expiration.
* [**Forward Proxy**](/hub/kong-inc/forward-proxy/) (`forward-proxy`)
  * Fixed the issue where request payload is being discarded when payload exceeded the `client_body_buffer_size`.
* [**Mocking**](/hub/kong-inc/mocking/) (`mocking`)
  * Fixed an issue where valid recursive schemas are always rejected.
* [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`)
  * Fixed an issue that the plugin throws a runtime error while validating parameters with AnyType schema and style keyword defined.
  * Fixed an issue that the nullable keyword did not take effect.
  * Fixed an issue that the URI component escaped characters were incorrectly unescaped.
  * Fixed an issue where the plugin throws a runtime error caused by the ref parameter schema not being de-referenced. [#7544](https://github.com/Kong/kong/issues/7544)
* [**Response Rate Limiting**](/hub/kong-inc/response-ratelimiting/) (`response-ratelimiting`)
  * Fixed an issue where all counters are synced to the same DB at the same rate.[#7315](https://github.com/Kong/kong/issues/7315)

#### Admin API
- Fixed an issue where unique violation errors were reported while trying to update the `user_token` with the same value on the same RBAC user.

#### Clustering
- Fixed an issue where the dataplane's log serializer output has workspace name under Hybrid mode.

#### Default
- Fixed critical level logs when starting external plugin servers. Those logs cannot be suppressed due to the limitation of OpenResty. We choose to remove the socket availability detection feature.

#### Configuration
- Respect custom `proxy_access_log`. [#7435](https://github.com/Kong/kong/issues/7435)

### Performance
#### Configuration
* Bumped `dns_stale_ttl` default to 1 hour so that a stale DNS record can be used for longer time in case of resolver downtime.

### Dependencies
* Bumped `OpenResty` from 1.21.4.2 to 1.21.4.3
 [#7518](https://github.com/Kong/kong/issues/7518)
* Bumped `resty-openssl` from 0.8.25 to 1.0.2
 [#7418](https://github.com/Kong/kong/issues/7418)
* Bumped `luasec` to 1.3.2


## 3.5.0.1
**Release Date** 2023/11/14

### Fixes
#### Kong Manager
* Fixed an issue where some values in the config cards did not display correctly.

## 3.5.0.0
**Release Date** 2023/11/08

### Breaking changes and deprecations

* [**Session**](/hub/kong-inc/session/) plugin: Introduced the new configuration field `read_body_for_logout` with a default value of `false`. 
This change alters the behavior of `logout_post_arg` in such a way that it is no longer considered, 
unless `read_body_for_logout` is explicitly set to `true`. This adjustment prevents the Session plugin from automatically reading request bodies for logout detection, particularly on POST requests.

* As of this release, the product component known as Kong Enterprise Portal (Developer Portal) is no longer included in the Kong Gateway Enterprise (previously known as Kong Enterprise) software package. Existing customers who have purchased Kong Enterprise Portal can continue to use it and be supported via a dedicated mechanism. 
  
  If you have purchased Kong Enterprise Portal in the past and would like to continue to use it with this release or a future release of Kong Gateway Enterprise, contact [Kong Support](https://support.konghq.com/support/s/) for more information.

* As of this release, the product component known as Vitals is no longer included in Kong Gateway Enterprise. 
Existing customers who have purchased Kong Vitals can continue to use it and be supported via a dedicated mechanism. 
Kong Konnect users can take advantage of our [API Analytics](/konnect/analytics/) offering, which provides a superset of Vitals functionality. 

  If you have purchased Vitals in the past and would like to continue to use it with this release or a future release of Kong Gateway Enterprise, contact [Kong Support](https://support.konghq.com/support/s/) for more information.

* The default value of the [`dns_no_sync`](/gateway/3.5.x/reference/configuration/#dns_no_sync) option has been changed to `on`.
[#11871](https://github.com/kong/kong/pull/11871).

* Kong Gateway now requires an Enterprise license to use dynamic plugin ordering.

### Features

#### Enterprise

* Modified the current AWS Vault backend to support `CredentialProviderChain` so that users can
choose not to use `AK-SK` environment variables to grant IAM role permissions.
* Added support for Microsoft Azure's KeyVault Secrets Engine. 
Set it up using the [`vault_azure_*`](/gateway/3.5.x/reference/configuration/#vault_azure_vault_uri).
configuration parameters.
* License management:
  * Implemented a new grace period that lasts 30 days from the Kong Enterprise license expiration date. 
    During the grace period all open source functionality will be available, and
    Enterprise functionality will be set to read-only mode.
  * Added support for counters such as routes, plugins, licenses, and deployment information to the license report.
  * Added a checksum to the output of the license endpoint.
* The Kong Enterprise package is now renamed to Kong Gateway Enterprise. 
This change only affects documentation, and doesn't affect the Kong Gateway code in any way.

##### Kong Manager
* Added the ability to delete workspaces along with all associated resources.
Previously, a workspace couldn't be deleted until all the entities associated with it were manually deleted. 
With forced deletion, you can automatically remove any entities associated with a workspace while you are deleting it. 
For more information, see [Delete a workspace](/gateway/3.5.x/kong-manager/workspaces/#delete-a-workspace).
* Added support for Azure's KeyVault Secrets Engine.
* Enabled plugins to be scoped to consumer groups.
* Implemented the removal of consumer group policies.
* Enhanced the user experience of detail pages for entities with a refined look and feel.
* Improved the user experience with a new design for the **Overview** and **Workspaces** pages.
* The Vault form now supports TTL fields.

#### Core

* Added the [`analytics_debug`](/gateway/3.5.x/reference/configuration/#analytics_debug)
 option to the output of logged requests. 
* Added the [`cluster_fallback_export_s3_config`](/gateway/3.5.x/reference/configuration/#cluster_fallback_export_s3_config) option to allow adding a 
config table to the Kong exporter config S3 `putObject` request.
* Added troubleshooting tools to container images.
* `workspaces.get_workspace()` now tries to get the workspace from the cache 
instead of querying the database directly. 
* Introduced the new endpoint [`/schemas/vaults/:name`](/gateway/api/admin-ee/latest/#/operations/get-schemas-vaults-vault_name) for retrieving the schema of a vault. 
[#11727](https://github.com/Kong/kong/pull/11727)
* Renamed `privileged_agent` to [`dedicated_config_processing`](/gateway/3.5.x/reference/configuration/#dedicated_config_processing) and enabled `dedicated_config_processing` by default.
[#11784](https://github.com/Kong/kong/pull/11784)
* Debugging tools:
  * Added a unique Request ID that is now populated in the error log, access log, error templates, log serializer, and a new `X-Kong-Request-Id` header. 
  This configuration can be customized for upstreams and downstreams using the 
  [`headers`](/gateway/3.5.x/reference/configuration/#headers) and 
  [`headers_upstream`](/gateway/3.5.x/reference/configuration/#headers_upstream) configuration options. 
  [#11663](https://github.com/Kong/kong/pull/11663)
  * Added support for the debug request header `X-Kong-Request-Debug-Output`, 
  which lets you observe the time consumed by specific components in a given request.
  Enable it using the 
  [`request_debug`](/gateway/3.5.x/reference/configuration/#request_debug) configuration parameter.
  This header helps you diagnose the cause of any latency in Kong Gateway.
  See the [Request Debugging](/gateway/3.5.x/production/debug-request/) guide for more information.
  [#11627](https://github.com/Kong/kong/pull/11627)
* Enabled plugins to implement the `Plugin:configure(configs)` function, 
which is called when there is a change in plugin entities. 
It receives an array of current plugin configurations or nil if there are no active configurations.
Learn more about this function in the guide for [Implementing Custom Logic](/gateway/3.5.x/plugin-development/custom-logic/) for plugins.
[#11703](https://github.com/Kong/kong/pull/11703)
* Implemented a request-aware table capable of detecting accesses from different requests.
[#11017](https://github.com/Kong/kong/pull/11017)
* WebAssembly (Wasm):
  * Added support for optional Wasm filter configuration schemas.
  [#11568](https://github.com/Kong/kong/pull/11568)
  * Improved support for JSON in Wasm filter configuration.
  [#11697](https://github.com/Kong/kong/pull/11697)

  See the [Proxy-Wasm filter configuration](/gateway/3.5.x/plugin-development/wasm/filter-configuration/)
  guide to learn more.

#### Kong Manager Open Source

* Added `JSON` and `YAML` formats in entity configuration cards.
[#111](https://github.com/Kong/kong-manager/pull/111)
* Plugin form fields now display descriptions from backend schema.
[#66](https://github.com/kong/kong-manager/pull/66)
* Added the `protocols` field to the plugins form.
[#93](https://github.com/kong/kong-manager/pull/93)
* The upstream target list shows the `Mark Healthy` and `Mark Unhealthy` 
action items when certain conditions are met. 
[#86](https://github.com/kong/kong-manager/pull/86)

#### Plugins

* [**Mocking**](/hub/kong-inc/mocking/) (`mocking`)
  * Added a new property `include_base_path` for path match evaluation. 
* [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`)
  * Added a new property `include_base_path` for path match evaluation. 
* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Added the new field `unauthorized_destroy_session`. 
  When set to `true`, it destroys the session when receiving an 
  unauthorized request by deleting the user's session cookie.
  * Added the new field `using_pseudo_issuer`. 
  When set to `true`, the plugin instance will not discover configuration from the issuer.
  * Added support for public clients for token revocation and introspection.
  * Added support for designating parameter names `introspection_token_param_name` and `revocation_token_param_name`.
  * Added support for mTLS proof of possession. The feature is available by enabling `proof_of_possession_mtls`. 
* [**OpenTelemetry**](/hub/kong-inc/opentelemetry/)
  * Added a new value to the parameter `header_type`, which allows Kong Gateway to inject Datadog headers into the headers of requests forwarding to the upstream.
* [**Response Rate Limiting**](/hub/kong-inc/response-ratelimiting/) (`response-ratelimiting`)
  * Added support for secret rotation with Redis connections.
  [#10570](https://github.com/Kong/kong/pull/10570)
* [**CORS**](/hub/kong-inc/cors) (`cors`)
  * Added support for the `Access-Control-Request-Private-Network` header in 
  cross-origin pre-flight requests.
  [#11523](https://github.com/kong/kong/pull/11523).
* [**ACME**](/hub/kong-inc/acme/) (`acme`) 
  * Exposed the new configuration field `scan_count` for Redis storage, 
  which controls how many keys are returned in a `scan` call. 
  [#11532](https://github.com/kong/kong/pull/11532)
* [**Session**](/hub/kong-inc/session/) (`session`)
  * Introduced the new configuration field `read_body_for_logout` with a default value of `false`. 
  This change alters the behavior of `logout_post_arg` in such a way that it is no longer considered, 
  unless `read_body_for_logout` is explicitly set to `true`. 
  
  This adjustment prevents the Session plugin from automatically reading request bodies for 
  logout detection, particularly on POST requests.

### Fixes

#### Enterprise

* Fixed a keyring issue where Kong nodes failed to send keyring material when using the cluster strategy.
* Enforced Content Security Policy (CSP) headers for serving static resources via Kong Manager.
* Fixed an RBAC issue related to retrieving group roles with a numeric group name type.
* When using `openid-connect` as the `admin_gui_auth` method for Kong Manager, some `admin_gui_auth_conf` required settings are now hardcoded.
* Fixed an issue where the data plane hostname was `nil` in Vitals when running Kong Gateway in hybrid mode.

##### Admin API

* Fixed an issue where `rbac_role_entities` records of cascaded entities were not deleted when the entity was deleted. 
* Fixed an issue that allowed the creation of colliding routes in different workspaces when using `application/x-www-form-urlencoded` as the content type in the Admin API. 
* Optimized the performance of querying plugins when accessing the `application_services` and `application_instances` endpoints.
* Fixed an issue where users were unable to completely delete a developer by its email via the Admin API.
* Added FIPS state and license type checks in `validate_fips`.
* Removed FIPS from free mode.
* Implemented lazy enabling of FIPS mode upon receiving a valid license, emitting warnings instead of blocking Kong Gateway startup. This approach allows normal use of non-FIPS content without a license, and FIPS mode activates only with a valid license. When no license is present, the service can start with a warning log, and FIPS mode remains disabled until a valid license is added. Additionally, deleting a valid license via the Admin API results in a warning without disabling FIPS mode.
* Unified the error responses for failed admin authentication via Admin and Portal APIs.

##### Kong Manager

* Resolved an issue where the admin page remained pending when no admin was added.
* Updated the service name in the application list to be directly returned from the backend.
* Fixed breadcrumbs and RBAC permissions for entities sharing one menu item in the sidebar.
* Corrected the service query endpoint in the route form.
* Fixed an issue where the file upload input in the service document form was not functioning properly.

#### Core

* Removed the chart `Current Database Availability`, which is not a vitals metric with Prometheus.
* Implemented cache invalidation based on both names and IDs for consumer groups.
* Applied Nginx patch to detect HTTP/2 stream reset attacks early, addressing 
[CVE-2023-44487](https://nvd.nist.gov/vuln/detail/CVE-2023-44487).
* Resolved an issue where the TTL of the Key Authentication plugin did not work in DB-less and hybrid modes.
[#11464](https://github.com/kong/kong/pull/11464)
* Addressed a problem where an abnormal socket connection would be reused when querying the PostgreSQL database. [#11480](https://github.com/kong/kong/pull/11480)
* Fixed an issue causing upstream SSL failures when plugins used response handlers.
[#11502](https://github.com/Kong/kong/issues/11502)
* Fixed an issue where the `tls_passthrough` protocol could not work with the expressions flavor router.
[#11538](https://github.com/kong/kong/issues/11538)
* Fixed an issue which caused failures in sending tracing data to Datadog when the value of the `x-datadog-parent-id` header in requests was a short decimal string. 
[#11599](https://github.com/kong/kong/issues/11599)
* Resolved the building failure when applying patches.
[#11696](https://github.com/kong/kong/issues/11696)
* Enabled the use of vault references in DB-less mode in declarative configuration files. 
[#11845](https://github.com/kong/kong/issues/11845)
* Vault caches now properly warm up during initialization.
[#11827](https://github.com/kong/kong/issues/11827)
* The vault resurrect time is now respected if a vault secret is deleted from a vault.
[#11852](https://github.com/kong/kong/issues/11852)
* Restored the `lapis` and `luarocks-admin` bins. 
[#11551](https://github.com/Kong/kong/pull/11551)

#### Kong Manager Open Source

* Resolved an issue that caused incorrect port information to display in the Kong Manager. 
[#103](https://github.com/kong/kong-manager/pull/103).
* Fixed a bug where the Proxy Caching plugin could not be installed in Kong Manager. 
[#104](https://github.com/kong/kong-manager/pull/104)

#### Plugins

* Added a new handler for plugins to implement, where configs will be `nil` if there are no active configurations for the plugin. This change can be seen in the Acme, Prometheus, and Rate Limiting Advanced plugins.
* Kong Gateway now requires a license to use dynamic plugin ordering.
* [**Mutual TLS Authentication**](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
  * Fixed an issue to prevent caching network failures during revocation checks.
* [**Response Transformer**](/hub/kong-inc/response-transformer/) (`response-transformer`)
  * Resolved warning logs related to flooded JSON decoding issues.
* [**Canary**](/hub/kong-inc/canary) (`canary`)
  * Removed the custom validator for `config.start` to allow setting it to a past time.
* [**SAML**](/hub/kong-inc/saml) (`saml`)
  * When the Redis session storage is incorrectly configured, 
  users now receive a 500 error instead of being redirected endlessly.
  * Reduced the severity of `session was not found` messages to `info`.
* [**Mocking**](/hub/kong-inc/mocking) (`mocking`)
  * Path parameters can now correctly match non-ASCII characters.
* [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`)
  * Fixed an issue where non `application/json` content-types were being rejected, 
  even when the request body was not required.
  * Fixed an issue where a null pointer exception could occur in certain scenarios
  when `notify_only_request_validation_failure` was set to true.
  * Fixed the issue where path parameters couldn't match non-ASCII characters.
  * Fixed an issue where valid recursive schemas were always rejected.
* [**OpenTelemetry**](/hub/kong-inc/opentelemetry) (`opentelemetry`)
  * Fixed an issue that resulted in traces with invalid parent IDs when `balancer` instrumentation was enabled. 
  [#11830](https://github.com/Kong/kong/pull/11830)
* [TCP Log](/hub/kong-inc/tcp-log) (`tcp-log`)
  * Resolved an issue related to unnecessary handshakes when reusing TLS connections. 
  [#11848](https://github.com/Kong/kong/pull/11848)
* [**AWS Lambda**](/hub/kong-inc/aws-lambda) (`aws-lambda`)
  * Plugin-level proxy configuration now takes effect when fetching IAM credentials in an EKS environment with IRSA. 
  This improvement allows the EKS IRSA credential provider (`TokenFileWebIdentityCredentials`) to correctly route requests through the plugin-level proxy configuration when obtaining credentials from the AWS STS service. 
  [#11551](https://github.com/Kong/kong/pull/11551)
  * The plugin now caches the AWS Lambda service by lambda service related fields. 
  [#11821](https://github.com/kong/kong/pulls/11821)

#### PDK

* Addressed several issues in Vault and refactored the Vault codebase.
* Fixed an issue where the response body would get repeated when `kong.response.get_raw_body()` 
was called multiple times in a request lifecycle.
[#11424](https://github.com/Kong/kong/pull/11424)
* Tracing: Fixed an issue that resulted in some parent spans to end before their children due to different precision of their timestamps.
[#11484](https://github.com/Kong/kong/pull/11484)
* Fixed a bug related to data interference between requests in the `kong.log.serialize` function.
[#11566](https://github.com/Kong/kong/issues/11566)

### Dependencies

* Bumped `resty.openssl` from 0.8.23 to 0.8.25
 [#11518](https://github.com/Kong/kong/issues/11518)
* Fixed incorrect LuaJIT register allocation for IR_*LOAD on ARM64
 [#11638](https://github.com/Kong/kong/issues/11638)
* Fixed LDP/STP fusing for unaligned accesses on ARM64
 [#11639](https://github.com/Kong/kong/issues/11639)
* Bump lua-kong-nginx-module from 0.6.0 to 0.8.0
 [#11663](https://github.com/Kong/kong/issues/11663)
* Fix incorrect LuaJIT LDP/STP fusion on ARM64
 [#11537](https://github.com/Kong/kong/issues/11537)
* Bumped `lua-resty-healthcheck` from 1.6.2 to 1.6.3
 [#11360](https://github.com/Kong/kong/issues/11360)
* Bumped `openresty` from 1.21.4.1 to 1.21.4.2
 [#11360](https://github.com/Kong/kong/issues/11360)
* Bumped `lua-resty-aws` from 1.3.1 to 1.3.5
 [#11551](https://github.com/Kong/kong/issues/11551)
 [#11613](https://github.com/Kong/kong/issues/11613)
* Bumped `wasmtime` version from 8.0.1 to 12.0.2
 [#11738](https://github.com/Kong/kong/issues/11738)
* Bumped `openssl` from 3.1.2 to 3.1.4
 [#11844](https://github.com/Kong/kong/issues/11844)
* Bumped `kong-lapis` from 1.14.0.2 to 1.14.0.3
 [#11849](https://github.com/Kong/kong/issues/11849)
* Bumped OpenID Connect plugin submodule `kong-openid-connect` from 2.5.5 to 2.5.9 
* Kong CLI dependencies:
  * Bumped `curl` from 8.3.0 to 8.4.0
  * Bumped `nghttp2` from 1.56.0 to 1.57.0

## 3.4.3.17
**Release Date** 2025/03/26

### Fixes
#### Core

* Updated the AWS Vault supported regions list to the latest available.

#### Plugins

* [**AppDynamics**](/hub/kong-inc/app-dynamics/) (`app-dynamics`)
  * Fixed segmentation fault caused by missing destructor call on process exit.
* [**LDAP Authentication Advanced**](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * Fixed an issue where a binary string was truncated at the first null character.
* [**Session**](/hub/kong-inc/session/) (`session`) 
  * Fixed an issue where two boolean configuration fields `hash_subject` (default `false`) and `store_metadata` (default `false`) stored the session's metadata in the database.

### Dependencies

* Bumped `libexpat` from 2.6.2 to 2.6.4 to fix a crash in the `XML_ResumeParser` function caused by `XML_StopParser` stopping an uninitialized parser.
* Bumped `lua-resty-events` to 0.3.0.
* Bumped `lua-resty-healthcheck` to 3.1.0.

## 3.4.3.16
**Release Date** 2025/01/16

### Dependencies

* Bumped `libxml2` to 2.11.9 to address [CVE-2024-40896](https://nvd.nist.gov/vuln/detail/CVE-2024-40896).

## 3.4.3.15
**Release Date** 2025/01/10

### Fixes
#### Core

* Fixed an issue where a certificate entity configured with a vault reference was 
occasionally not refreshed on time when initialized with an invalid string.

### Dependencies

* Bumped `lua-kong-nginx-module` from 0.8.1 to 0.8.2.
* Fixed an issue in the Lua Kong Nginx module, ensuring that the values in the cache remain valid and are updated in time.

## 3.4.3.14
**Release Date** 2024/12/17

### Fixes
#### Core

* Fixed an issue where the workspace ID was not included in the plugin config in the plugins iterator.
* Fixed Vault initialization by postponing Vault reference resolution to a timer in the `init_worker` phase.
* Fixed an issue where using Hashicorp Vault AppRole authentication with a secret ID file would fail to read the secret ID.

#### Plugins

* [**GraphQL Rate Limiting Advanced**](/hub/kong-inc/graphql-rate-limiting-advanced/) (`graphql-rate-limiting-advanced`)
  * Fixed an issue where the plugin could fail to authenticate to Redis correctly with vault-referenced Redis configuration.

* [**mTLS Auth**](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
  * Fixed an issue where a 500 error occurred when Kong configuration changed with the mTLS plugin enabled.

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`) 
  * Fixed an issue where counters of the overriding consumer groups weren't fetched when the `window_size` was different and the workspace was non-default.
  * Fixed an issue where, if multiple plugin instances sharing the same namespace enforced consumer groups and different `window_size`s were used in the consumer group overriding configs, then the rate limiting of some consumer groups would fall back to the `local` strategy. 
  Now, every plugin instance sharing the same namespace can set a different `window_size`.
  * Fixed an issue where the plugin could fail to authenticate to Redis correctly with Vault-referenced Redis configuration.
  * Fixed an issue where plugin-stored items with a long expiration time caused `no memory` errors.

## 3.4.3.13
**Release Date** 2024/11/15

### Features
#### Core

* Added support for AWS IAM role assuming in AWS IAM Database Authentication, with the following new configuration fields: `pg_iam_auth_assume_role_arn`, `pg_iam_auth_role_session_name`, `pg_ro_iam_auth_assume_role_arn`, and `pg_ro_iam_auth_role_session_name`.

* Added support for a configurable STS endpoint for RDS IAM Authentication, with the following new configuration fields: `pg_iam_auth_sts_endpoint_url` and `pg_ro_iam_auth_sts_endpoint_url`.

* Added support for a configurable STS endpoint for AWS Vault. This can either be configured by `vault_aws_sts_endpoint_url` as a global configuration, or `sts_endpoint_url` on a custom AWS Vault entity.

#### Plugins

* [**AWS Lambda**](/hub/kong-inc/aws-lambda) (`aws-lambda`):
  * Added support for a configurable STS endpoint with the new configuration field `aws_sts_endpoint_url`.

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`) 
  * Increased the time resolution of sliding window weight calculation.

### Fixes
#### Core

* Fixed an issue where the Vault secret cache got refreshed during `resurrect_ttl` time and could not be fetched by other workers.
* Moved internal Unix sockets to a subdirectory (`sockets`) of the Kong prefix.
* Shortened the names of internal Unix sockets to avoid exceeding the socket name limit.
* Fixed an issue where AWS IAM assume role could not be used in AWS IAM database authentication by using the following fields: 
  * `pg_iam_auth_assume_role_arn`
  * `pg_iam_auth_role_session_name`
  * `pg_ro_iam_auth_assume_role_arn`
  * `pg_ro_iam_auth_role_session_name`
* Fixed an issue where the STS endpoint could not be configured manually in RDS IAM Authentication, AWS Vault and AWS Lambda plugin. For RDS IAM authentication, it can be configured by `pg_iam_auth_sts_endpoint_url` and `pg_ro_iam_auth_sts_endpoint_url`. For AWS vault, it can be configured using `vault_aws_sts_endpoint_url` as a global configuration, or `sts_endpoint_url` on a custom AWS vault entity. For the AWS Lambda plugin, it can be configured using the `aws_sts_endpoint_url`. 
* Fixed an issue where `luarocks-admin` was not available in `/usr/local/bin`.
* Fixed an issue where analytics could break when the value type of rate limiting-related headers was not `integer`.
* Fixed an issue where the IAM auth token was not refreshed when the underlying AWS credential expired.

#### Plugins

* [**OpenTelemetry**](/hub/kong-inc/opentelemetry) (`opentelemetry`)
  * Fixed an issue where `header_type` being `nil` caused a log message concatenation error.

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`) 
  * Fixed an issue where the sync timer could stop working due to a race condition.
  * Fixed an issue where when the sliding window and `window_size` was very small, the precision of the rate limit wasn't accurate enough.

### Dependencies

* Bumped `LPEG` from 1.0.2 to 1.1.0 to keep the version consistent across all active branches. 
The version bump includes fixes like UTF-8 ranges, a larger limit for rules and matches, accumulator capture, and more.
* Bumped `lua-resty-aws` to 1.5.3 to fix a bug related to the STS regional endpoint.
* Bumped `lua-resty-azure` to 1.6.1 to fix a `GET` request build issue, which was causing problems with Azure secret references.
* Made the RPM package relocatable with the default prefix set to `/`.

## 3.4.3.12
**Release Date** 2024/08/08

### Deprecations

* Debian 10, CentOS 7, and RHEL 7 reached their End of Life (EOL) dates on June 30, 2024. 
As of this patch, Kong is not building Kong Gateway 3.4.x installation packages or Docker images for these operating systems.
Kong is no longer providing official support for any Kong version running on these systems.

### Features
#### Core

* Kong Gateway Enterprise container images are now produced with build provenance and signed using cosign. 
Signatures and attestations are published to the Docker Hub repository. 
Build provenance can be [verified by cosign/slsa-verifier](/gateway/3.4.x/kong-enterprise/provenance-verification/) 
using the published attestations.

### Fixes
#### Core

* The `kong.logrotate` configuration file is no longer overwritten during upgrade.

  This change presents an additional prompt for Debian users upgrading via `apt` and `deb` packages.
  To accept the defaults provided by Kong in the package, use the following command, adjusting it to 
  your architecture and the version you're upgrading to: 

  ```sh
  DEBIAN_FRONTEND=noninteractive apt upgrade kong-enterprise-edition_3.4.3.11_arm64.deb
  ```

* Fixed an issue where a new data plane couldn't resolve a Vault reference after the first configuration push. 
This was happening due to issues with license pre-loading.

#### Plugins

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed an issue where, if the `window_size` in a consumer group's overriding config was different from the 
  `window_size` in the plugin's default config, the rate limiting of that consumer group would fall back to the local strategy.

* [**LDAP Authentication Advanced**](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * Fixed an issue where an exception would be thrown when LDAP search failed.

## 3.4.3.11
**Release Date** 2024/06/22

### Fixes

* Fixed an issue where the DNS client was incorrectly using the content of the `ADDITIONAL SECTION` in DNS responses.

## 3.4.3.10
**Release Date** 2024/06/18

### Known issues

* There is an issue with the DNS client fix, where the DNS client incorrectly uses the content `ADDITIONAL SECTION` in DNS responses.
To avoid this issue, install 3.4.3.11 instead of this patch.

### Fixes
#### Admin API

* The `/<workspace>/admins` endpoint was incorrectly used to return admins associated with a workspace based 
on their assigned RBAC roles. This has been fixed and now accurately returns admins according to their specific workspace associations.

### Dependencies

* Bumped `lua-resty-events` to 0.2.1.


## 3.4.3.9
**Release Date** 2024/06/08

### Features
#### Admin API

* Added LHS bracket filtering to search fields.
* **Audit logs:**
  * Added `request_timestamp` to `audit_objects`.
  * Added before and after aliases for LHS Brackets filters.
  * `audit_requests` and `audit_objects` can now be filtered by `request_timestamp`.

### Fixes
#### Admin API

* Fixed an issue with the workspace listing API, which showed workspaces that the user didn't have any roles in.
The API now only shows workspaces that the user has access to.

#### Core

* Fixed an issue where `cluster_cert` or `cluster_ca_cert` was inserted into `lua_ssl_trusted_certificate` before being base64-decoded.
* **Vitals**: Fixed an issue where each data plane connecting to the control plane would trigger the creation of a redundant 
table rotater timer on the control plane.
* **DNS Client**: Fixed an issue where the Kong DNS client stored records with non-matching domain and type when parsing answers.
It now ignores records when the RR type differs from that of the query when parsing answers.
* Fixed an issue where the `host_header` attribute of the upstream entity wouldn't be set correctly as a Host header in requests to the upstream during connection retries.
* Built-in RBAC roles for admins (`admin` under the default workspace and `workspace-admin` under non-default workspaces) now disallow CRUD actions to `/groups` and `/groups/*` endpoints.

#### Plugins

* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Fixed an issue where anonymous consumers were being cached as `nil` under a certain condition.
* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Timer spikes no longer occur when there is network instability with the central data store.

### Dependencies

* Bumped `lua-resty-azure` from 1.4.1 to 1.5.0 to refine some error logging.
* Bumped `lua-resty-healthcheck` from 1.6.4 to 1.6.5 to fix memory leak issues by reusing a timer for the same active healthcheck target instead of running many timers.
 
## 3.4.3.8
**Release Date** 2024/05/16

### Features
#### Admin API

* Changed the default ordering of `audit_requests` to sort by `request_timestamp` in descending order.

### Fixes
#### Admin API

* Fixed an issue where HTTP 500 errors were returned when paginating and sorting by timestamp fields
(for example, `created_at`).

#### Plugins

* [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`), 
[**WebSocket Size Limit**](/hub/kong-inc/websocket-size-limit/) (`websocket-size-limit`), 
[**WebSocket Validator**](/hub/kong-inc/websocket-validator/) (`websocket-validator`),
 [**XML Threat Protection**](/hub/kong-inc/xml-threat-protection/) (`xml-threat-protection`)
  * The priorities of these plugins have been updated to prevent collisions between plugins.
    The relative priority (and the order of execution) of bundled plugins remains unchanged.

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Refactored `kong/tools/public/rate-limiting`, adding the new interface `new_instance` to provide isolation between different plugins. 
  The original interfaces remain unchanged for backward compatibility. 

    If you are using custom Rate Limiting plugins based on this library, update the initialization code to the new format. For example: 
    `'local ratelimiting = require("kong.tools.public.rate-limiting").new_instance("custom-plugin-name")'`.
    The old interface will be removed in the upcoming major release.

### Dependencies

* Improved the robustness of `lua-cjson` when handling unexpected input.
* Bumped `kong-lua-resty-kafka` to 0.19 to support TCP socket keepalive.

## 3.4.3.7
**Release Date** 2024/04/23

### Features
#### Plugins

* [**Portal Application Registration**](/hub/kong-inc/application-registration/) (`application-registration`)
  * Added support for accessing the service using consumer credential authentication. 
  To use this functionality, enable `enable_proxy_with_consumer_credential` (default is `false`).

### Fixes
#### Clustering

* Fixed an issue where event hooks were prematurely validated in hybrid mode. 
The fix delays the validation of event hooks to the point where event hooks are emitted.

#### Core

* Fixed an issue with data planes in hybrid mode, where a certificate entity configured with a vault 
reference was occasionally not refreshed on time.

#### PDK

* Fixed an issue where `kong.request.get_forwarded_port` incorrectly returned a string from `ngx.ctx.host_port`. 
It now correctly returns a number.

### Dependencies

* Bumped `lua-protobuf` to 0.5.1.

## 3.4.3.6
**Release Date** 2024/04/15

### Features
#### Kong Manager Enterprise

* Added support for Microsoft Azure's KeyVault Secrets Engine. 

#### Plugins

* [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`)
  * Added the new field `api_spec_encoded` to indicate whether the `api_spec` is URI-encoded.

### Fixes
#### Configuration

* Fixed an issue where an external plugin (Go, Javascript, or Python) would fail to
apply a change to the plugin config via the Admin API.

#### Kong Manager Enterprise

* Fixed an issue where logging in failed when fields in the Developer Portal configuration 
**Developer Meta Fields** tab contained characters outside the Latin1 range.
* Fixed an issue where the admin account profile page returned a 404 error if 
the `admin_gui_path` wasn't a slash.

#### Plugins

* [**ACME**](/hub/kong-inc/acme/) (`acme`)
  * Fixed an issue where the certificate was not successfully renewed during ACME renewal.

* [**DeGraphQL**](/hub/kong-inc/degraphql/) (`degraphql`)
  * Fixed an issue where GraphQL variables were not being correctly parsed and coerced into their defined types.

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed an issue where any plugins using the `rate-limiting` library, when used together, 
  would interfere with each other and fail to synchronize counter data to the central data store.

* [**OpenTelemetry**](/hub/kong-inc/opentelemetry) (`opentelemetry`)
  * Improved robustness of parsing for short trace IDs.

#### Plugin

### Dependencies

* Bumped `lua-kong-nginx-module` to 0.8.1
* Bumped `lua-resty-luasocket` to 1.1.2 to fix [luasocket#427](https://github.com/lunarmodules/luasocket/issues/427)


## 3.4.3.5
**Release Date** 2024/03/21

### Breaking changes

* In OpenSSL 3.2, the default SSL/TLS security level has been changed from 1 to 2.
  This means the security level is set to 112 bits of security. 
  As a result, the following are prohibited:
    * RSA, DSA, and DH keys shorter than 2048 bits
    * ECC keys shorter than 224 bits
    * Any cipher suite using RC4
    * SSL version 3
  Additionally, compression is disabled.

* The recent OpenResty bump includes TLS 1.3 and deprecates TLS 1.1. 
If you still need to support TLS 1.1, set the [`ssl_cipher_suite`](/gateway/3.4.x/reference/configuration/#ssl_cipher_suite) setting to `old`.

### Features

#### Configuration

* Added support for Microsoft Azure's KeyVault Secrets Engine. 
Set it up using the [`vault_azure_*`](/gateway/3.4.x/reference/configuration/#vault_azure_vault_uri)
configuration parameters.
* TLSv1.1 and lower is now disabled by default in OpenSSL 3.x.

#### Core
* The expressions router now supports the `! (not)` operator, which allows creating routes like `!(http.path =^ "/a")` and `!(http.path == "/a" || http.path == "/b")`.
* Added support for the debug request header `X-Kong-Request-Debug-Output`, which lets you observe the time consumed by specific components in a given request. Enable it using the [`request_debug`](/gateway/3.4.x/reference/configuration/#request_debug) configuration parameter. This header helps you diagnose the cause of any latency in Kong Gateway. See the [Request Debugging](/gateway/3.4.x/production/debug-request/) guide for more information.
* Kong Gateway now supports [`http.path.segments.len` and `http.path.segments.*`](/gateway/3.4.x/key-concepts/routes/expressions/#matching-fields) fields in the expressions router, which allows matching incoming (normalized) request paths by individual segments or ranges of segments, and checking the total number of segments.
* The [`net.src.*` and `net.dst.*`](/gateway/3.4.x/key-concepts/routes/expressions/#matching-fields) match fields are now accessible in HTTP routes defined using expressions.
* Modified the current AWS Vault backend to support `CredentialProviderChain` so that users can
choose not to use `AK-SK` environment variables to grant IAM role permissions.
* The HashiCorp Vault secrets management backend now supports the AppRole authentication method.
* OSS features will now continue working with an expired license, and configured Kong Enterprise features will continue operating in read-only mode. Kong Gateway now logs a daily critical message when a license is expired and within the 30 days grace period.
* You can now use an RBAC token to authenticate while using 
[group mapping with Kong Manager](/gateway/3.4.x/kong-manager/auth/oidc/mapping/) (for example, with OIDC or LDAP).
* Introduced the new endpoint [`/schemas/vaults/:name`](/gateway/api/admin-ee/latest/#/operations/get-schemas-vaults-vault_name) for retrieving the schema of a vault. 

#### Plugins

* Plugins can now implement the `Plugin:configure(configs)` function, 
which is called when there is a change in plugin entities. 
It receives an array of current plugin configurations, or nil if there are no active configurations.
Learn more about this function in the guide for [Implementing Custom Logic](/gateway/3.4.x/plugin-development/custom-logic/) for plugins.

* [**CORS**](/hub/kong-inc/cors) (`cors`)
  * Added support for the `Access-Control-Request-Private-Network` header in cross-origin pre-flight requests.

* [**mTLS Auth**](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
  * Added a `default_consumer` option, which allows a default consumer to be used when the 
  client certificate is valid but doesn't match any existing consumers.

### Fixes
#### Configuration
* Set the security level of gRPC's TLS to `0` when `ssl_cipher_suite` is set to `old`.
* Added the missing `azure_vault` config options to the `kong.conf` file.

#### Core
* Header value matching (`http.headers.*`) in the `expressions` router flavor is now case sensitive.
This change doesn't affect `traditional_compatible` mode
where header value matching is always performed with the case ignored.
* Updated the file permission of `kong.logrotate` to 644.
* Expressions routes in `http` and `stream` subsystems now have stricter validation.
Previously, they shared the same validation schema, so admins could configure expressions
routes using fields like `http.path` even for stream routes. This is no longer allowed.
* Fixed an issue where `rbac_role_entities` records of cascaded entities were not deleted when the entity was deleted.
* Reduce message push error logs when the `cluster_telemetry_endpoint` config is disabled.
* Vaults: Fixed an issue where the vault used the wrong (default) workspace identifier when retrieving a vault entity by prefix.

#### Kong Manager
* Fixed the display of the remaining days of license expiration date. 
* The user token input field is now concealed while editing an RBAC user. 
* Fixed some issues with group mapping.

#### Plugins
* [**Forward Proxy**](/hub/kong-inc/forward-proxy/) (`forward-proxy`)
  * The plugin now falls back to the non-streaming proxy when the request body has already been read.

* [**OpenTelemetry**](/hub/kong-inc/opentelemetry) (`opentelemetry`)
  * Fixed an OTEL sampling mode Lua panic bug that occurred when the `http_response_header_for_traceid` option was enabled.
  * Increased queue max batch size to 200. 
   
* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Marked the `introspection_headers_values` as an encrypted and referenceable field.

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed an issue with `sync_rate` setting being used with the `redis` strategy. 
  If the Redis connection is interrupted while `sync_rate = 0`, the plugin now accurately falls back to the `local` strategy.
  * Fixed an issue where, if `sync_rate` was changed from a value greater than `0` to `0`, the namespace was cleared unexpectedly.
  * Fixed some timer-related issues where the counter syncing timer couldn't be created or destroyed properly.
  * The plugin now creates counter syncing timers during plugin execution instead of plugin creation to reduce some meaningless error logs.

* [**JWT Signer**](/hub/kong-inc/jwt-signer/) (`jwt-signer`), [**LDAP Authentication Advanced**](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`),
[**OAuth 2.0 Introspection**](/hub/kong-inc/oauth2-introspection/) (`oauth2-introspection`), [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`), and 
[**SAML**](/hub/kong-inc/saml) (`saml`)
  * Added support for consumer group scoping by using the PDK `kong.client.authenticate` function.

### Performance

#### Configuration
* Bumped the default values of `nginx_http_keepalive_requests` and `upstream_keepalive_max_requests` to 10000.
  
#### Core
* Reuse match context between requests to avoid frequent memory allocation/deallocation.

### Dependencies
* Bumped `atc-router` from 1.2.0 to 1.6.0
* Bumped `lua-resty-openssl` from 1.2.0 to 1.2.1
* Bumped `kong-lua-resty-kafka` from 0.17 to 0.18


## 3.4.3.4
**Release Date** 2024/02/10

### Features

#### Core

* Added support for namespaced authentication and user-defined authentication paths when using HashiCorp Vault on Kubernetes.

#### Clustering

* Added resilience support for homogeneous data plane deployments. Data planes can now act as importers and exporters at the same time, 
and Kong Gateway will try to control the concurrency when exporting the config.

### Fixes

#### Core

* Fixed an issue where workload identity didn't work for dataplane resilience.
* Fixed an issue where the GCP backend vault would hide the error message when secrets couldn't be fetched.
* Fixed an issue that caused spans to not be instrumented with `http.status_code` when the request was not proxied to an upstream.

#### Configuration

* Fixed a data loss error caused by a weakly-typed `of` function in the `declarative_config_flattened` function.

#### Plugins

* [**LDAP Authentication Advanced**](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * Fixed some cache-related issues which caused `groups_required` to return unexpected codes after a non-200 response.
  * Fixed an issue where, if the credential was encoded with no username, Kong Gateway would return a 500 error code.

### Dependencies

* Bumped OpenSSL from 3.1.4 to 3.2.1
 [#7762](https://github.com/Kong/kong/issues/7762)
* Bumped `resty-openssl` from 0.8.25 to 1.2.0
 [#7741](https://github.com/Kong/kong/issues/7741)
* Bumped `lua-resty-aws` from 1.3.5 to 1.3.6

## 3.4.3.3 
**Release Date** 2024/01/17

### Features
#### Core

* The Debian variant of Kong Gateway Docker image is now built using Debian 12. [#7672](https://github.com/Kong/kong/issues/7672)

#### Admin API

* Added the Kong Gateway edition to the root endpoint of the Admin API. [#7674](https://github.com/Kong/kong/issues/7674)

#### Plugins
* **[AppDynamics](/hub/kong-inc/app-dynamics/)**: Added `CONTROLLER_CERTIFICATE_FILE` and `CONTROLLER_CERTIFICATE_DIR` environment variable config for the AppDynamics plugin to use a self-signed certificate.

### Fixes
#### Portal
* Implemented relative URLs for portal root path redirection to prevent erroneous redirections to incorrect domains or protocols.

#### Core
* Fixed an RBAC issue that required adding missing endpoints to all workspaces.

#### Plugins
* **[OAS-Validation](/hub/kong-inc/oas-validation/)**: Fixed an issue where cookie parameters were not being validated.

#### Admin API
* It is no longer possible for admins or RBAC users to update their own roles.

#### Kong Manager

* Fixed an issue where the dynamic ordering dropdown list didn't show custom plugins.

* Fixed an issue where the role of the current workspace couldn't be created by the role `workspace-super-admin`'s admin.

### Dependencies
* Bumped `kong-redis-cluster` to 1.5.3

* Bumped `lua-resty-healthcheck` to 1.6.4 to fix a bug where the health check
  module would not work correctly when multiple health check instances were not cleared.

## 3.4.3.2
**Release Date** 2023/12/22

### Features
#### Plugins
* [**LDAP Authentication Advanced**](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * The plugin now supports decoding non-standard `asn1` integer and enumerated encoded with redundant leading padding.

### Fixes
#### Core
- Optimized the performance of querying plugins when accessing the `application_services/application_instances` endpoints. 
  
#### Kong Manager
- Fixed an issue where some services are missing from the Dev Portal's application list in Kong Manager. 
- Fixed an issue where clicking the spec upload input doesn't trigger file selection.

## 3.4.3.1
**Release Date** 2023/12/15

### Breaking Changes
#### Plugins
* [**SAML**](/hub/kong-inc/saml) (`saml`): Adjusted the priority of the SAML plugin to 1010 to correct the integration between the SAML plugin and other consumer-based plugins.

### Features
#### Core
* A unique Request ID is now populated in the error log, access log, error templates, log serializer, and in a new X-Kong-Request-Id header (configurable for upstream/downstream using the `headers` and `headers_upstream` configuration options).
 [#7207](https://github.com/Kong/kong/issues/7207)
* The default value of the [`dns_no_sync`](/gateway/3.4.x/reference/configuration/#dns_no_sync) option has been changed to `off`.

#### Plugins
* [**AWS Lambda**](/hub/kong-inc/aws-lambda) (`aws-lambda`): The AWS-Lambda plugin has been refactored by using `lua-resty-aws` as an underlying AWS library. The refactor simplifies the AWS-Lambda plugin code base and adds support for multiple IAM authenticating scenarios.
 [#7079](https://github.com/Kong/kong/issues/7079)

* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Configurations `scopes`, `login_redirect_uri`, `logout_redirect_uri` can now be referenced as a secret in the Kong Vault.
  * Extend `token_post_args_client` to support injection from headers.

### Fixes
#### Configuration
* Respect custom `proxy_access_log`.
 [#7436](https://github.com/Kong/kong/issues/7436)

#### Core
* Print error message correctly when plugin fails.
 [#7079](https://github.com/Kong/kong/issues/7079)
* Fixed `ldoc` intermittent failure caused by LuaJIT error.
 [#7491](https://github.com/Kong/kong/issues/7491)
* Fixed Vault's try function to avoid using semaphore in non-yieldable phases.
 [#7114](https://github.com/Kong/kong/issues/7114)
* Vault references can be used in DB-less mode in declarative config. 
 [#7483](https://github.com/Kong/kong/issues/7483)
* Correctly invalidate caches based on names and IDs for consumer groups.
* Eliminated the asynchronous timer in syncQuery() to prevent hang risk.
* Fixed critical level logs when starting external plugin servers. Those logs cannot be suppressed due to the limitation of OpenResty. We choose to remove the socket availability detection feature.

#### Admin API

* Fixed an issue where unique violation errors were reported while trying to update the user_token with the same value on the same RBAC user.

#### Kong Manager

* Fixed an issue where the Applications tab was not visible for services under non-default workspaces.

#### Clustering

* Fixed an issue where the dataplane's log serializer output has a workspace name under hybrid mode.
* Fixed an issue where the dataplane hostname is `nil` in Vitals under hybrid mode.

#### PDK
* Fixed a bug related to data interference between requests in the `kong.log.serialize` function.
 [#7327](https://github.com/Kong/kong/issues/7327)
* **Plugin Server**: Fixed an issue where every request causes a new plugin instance to be created.

#### Plugins
* [**AWS Lambda**](/hub/kong-inc/aws-lambda) (`aws-lambda`):
  * Cached the AWS lambda service by those lambda service related fields. [#7079](https://github.com/Kong/kong/issues/7079)

* [**Forward Proxy**](/hub/kong-inc/forward-proxy/) (`forward-proxy`):
  * Fixed the issue where request payload is being discarded when payload exceeded the `client_body_buffer_size`.

* [**JWE Decrypt**](/hub/kong-inc/jwe-decrypt/) (`jwe-decrypt`):
  * Fixed a typo in an error message.

* [**Mocking**](/hub/kong-inc/mocking/) (`mocking`):
  * Fixed an issue where path parameter cannot match non-ascii characters.

* [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`):
  * Fixed an issue where the plugin throws a runtime error when the ref parameter schema isn't dereferenced. [#7543](https://github.com/Kong/kong/issues/7543)
  * Fixed an issue where valid recursive schemas are always rejected.
  * Fixed an issue that the plugin throws a runtime error while validating parameters with AnyType schema and style keyword defined.
  * Fixed an issue where the nullable keyword did not take effect.
  * Fixed an issue where the URI component escaped characters were incorrectly unescaped.
  * Fixed an issue where path parameter cannot match non-ascii characters.

* [**OAuth 2.0 Introspection**](/hub/kong-inc/oauth2-introspection/) (`oauth2-introspection`):
  * Marked the `authorization_value` in the `oauth2-introspection` plugin as an encrypted field.

* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`):
  * Fixed a issue where an 500 error is thrown when the Dev Portal is enabled with OIDC and the administrator logs in successfully and retrieves the session.
  * Fixed the update time when calculating token expiry.

* [**Rate Limiting**](/hub/kong-inc/rate-limiting/) (`rate-limiting`):
  * Fixed an issue where all counters are synced to the same DB at the same rate. [#7314](https://github.com/Kong/kong/issues/7314)

* [**TCP Log**](/hub/kong-inc/tcp-log) (`tcp-log`):
  * Fixed an issue of unnecessary handshakes when reusing TLS connection. [#7114](https://github.com/Kong/kong/issues/7114)

### Performance
#### Configuration
* Bumped `dns_stale_ttl` default to 1 hour so the stale DNS record can be used for a longer amount of time in case of resolver downtime.

### Dependencies
#### Core
* Bumped `openresty` from 1.21.4.1 to 1.21.4.3
 [#7206](https://github.com/Kong/kong/issues/7206)
* Bumped `resty-openssl` from 0.8.25 to 1.0.2
 [#7417](https://github.com/Kong/kong/issues/7417)
* Bumped `lua-resty-healthcheck` from 1.6.2 to 1.6.3
 [#7206](https://github.com/Kong/kong/issues/7206)
* Bumped `lua-kong-nginx-module` from 0.6.0 to 0.8.0
 [#7207](https://github.com/Kong/kong/issues/7207)
* Bumped jq to 1.7
* Bumped luasec to 1.3.2

#### Default
* Bumped `lua-resty-aws` from 1.2.3 to 1.3.0
 [#7079](https://github.com/Kong/kong/issues/7079)
* Bumped `lua-resty-aws` from 1.3.2 to 1.3.5
 [#7318](https://github.com/Kong/kong/issues/7318)

## 3.4.2.0 
**Release date** 2023/11/10

### Features
#### Enterprise

* License management:
  * Implemented a new grace period that lasts 30 days from the Kong Enterprise license expiration date. 
    During the grace period all open source functionality will be available, and
    Enterprise functionality will be set to read-only mode.
  * Added support for counters such as routes, plugins, licenses, and deployment information to the license report.
  * Added a checksum to the output of the license endpoint.

### Fixes
#### Core
* Fixed an issue with the DNS client was not adhering to configured timeouts in a predictable manner. Also fixed a related issue that cause the DNS client to resolve incorrectly during transient network and DNS server failures. [#11386](https://github.com/Kong/kong/pull/11386)
* The default value of the [`dns_no_sync`](/gateway/3.4.x/reference/configuration/#dns_no_sync) option has been changed to `on`.
[#11871](https://github.com/kong/kong/pull/11871).
* Dismiss confusing log entry from Redis regarding rate limiting.

#### Kong Manager 
* Fixed an issue where some services were not showing the exact name or ID while configuring a route. 

#### Plugins
* [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`)
  * Fixed an issue that resulted in traces with invalid parent IDs when balancer instrumentation was enabled. [#11830](https://github.com/Kong/kong/pull/11830)
  * Add hybrid mode compatibility for older DPs that don't support the new `aws` header type. [#11686](https://github.com/Kong/kong/pull/11686)
*  [**Zipkin**](/hub/kong-inc/zipkin/) (`zipkin`)
  * Add hybrid mode compatibility for older DPs that don't support the new `aws` header type. [#11686](https://github.com/Kong/kong/pull/11686)
* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Fixed an issue with `using_pseudo_issuer`, where it was not used after it was propagated.

### Dependencies
#### Enterprise
* Bumped OpenSSL from 3.1.2 to 3.1.4
* Added troubleshooting tools to container images
* Bumped `ngx_wasm_module` version to prerelease-0.1.1 

## 3.4.1.1
**Release Date** 2023/10/12

### Fixes

#### Core

* Applied Nginx patch for early detection of  HTTP/2 stream reset attacks.
This change is in direct response to the identified vulnerability [CVE-2023-44487](https://nvd.nist.gov/vuln/detail/CVE-2023-44487).

  See our [blog post](https://konghq.com/blog/product-releases/novel-http2-rapid-reset-ddos-vulnerability-update) for more details on this vulnerability and Kong's responses to it.

#### Plugins

* [**SAML**](/hub/kong-inc/saml/) (`saml`): Adjusted the severity of `session was not found` messages to `info`.

### Dependencies

* Bumped `libxml2` from 2.10.3 to 2.11.5

## 3.4.1.0
**Release Date** 2023/09/28

### Breaking Changes

*  [**GraphQL Rate Limiting Advanced**](/hub/kong-inc/graphql-rate-limiting-advanced/) (`graphql-rate-limiting-advanced`): The schema validation has been updated so that Redis cluster mode is now supported. This schema change does not impact other implementations of this plugin.
  
### Features
#### Core

* Support HTTP query parameters in expression routes.

#### Plugins

* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`):
  * New field `unauthorized_destroy_session`, which when set to true, destroys the session, by deleting the user's session cookie, when the request is unauthorized. Default to `true`. Set to `false` to preserve the session.
  * New field `using_pseudo_issuer`. When set to true, the plugin instance will not discover the configuration from the issuer.
* [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`): A new value is added to the parameter `header_type`, enabling Kong to seamlessly inject Datadog headers into forwarded requests' headers when communicating with upstream services.


### Fixes
#### Core

* Removed a hardcoded proxy-wasm isolation level setting that was preventing the `nginx_http_proxy_wasm_isolation` configuration value from taking effect.
* Fixed an issue where the TTL of the Key Auth plugin didn't work in DB-less and Hybrid mode.
* Fixed a problem where an abnormal socket connection will be reused when querying the Postgres database.
* Fixed an upstream SSL failure when plugins used a response handler.
* Fixed an issue with the `tls_passthrough` protocol did not work with the router expressions flavor.
* Fixed an issue where plugins would not trigger correctly when the authenticated consumer is part of multiple consumer groups.
* Fixed a keyring issue where a Kong node fails to send keyring material when using cluster strategy.
* Fixed an issue that will cause a failure to send tracing data to Datadog when the value of the `x-datadog-parent-id` header in requests is a short decimal string.
* Fixed the way RBAC retrieves group roles with a group name whose type is a number.
* Fixed critical level logs when starting external plugin servers. Those logs cannot be suppressed due to the limitation of OpenResty. We choose to remove the socket availability detection feature. 



#### PDK

* Fixed several issues in Vault and refactored the Vault code base: 
  * Make DAOs fallback to an empty string when resolving Vault references fail
  * Use node-level mutex when rotating references  
  * Refresh references on config changes 
  * Update plugin referenced values only once per request 
  * Pass only the valid config options to vault implementations
  * Resolve multi-value secrets only once when rotating them 
  * Do not start vault secrets rotation timer on control planes 
  * Re-enable negative caching 
  * Reimplement the `kong.vault.try` function 
  * Remove references from rotation in case their configuration has changed
* Tracing: fixed an issue that resulted in some parent spans to end before their children due to different precision of their timestamps.
 
#### Plugin

* [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`): fix an issue that resulted in invalid parent IDs in the propagated tracing headers
* [**mTLS Authentication**](/hub/kong-inc/mtls-auth/) (`mtls-auth`): should not cache the network failure when performing a revocation check
* [**Canary**](/hub/kong-inc/canary/) (`canary`): allow the `start` field to be a time that occurs in the past.
* [**SAML**](/hub/kong-inc/saml/) (`saml`): When the Redis session storage is incorrectly configured, users now receive a 500 error instead of being redirected endlessly.
* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`): Fix the issue on token revocation on logout where the code was revoking the refresh token when it was supposed to revoke access token when using the discovered revocation endpoint.


### Kong Manager

* Kong Manager now links directly to the [Gateway Admin API - EE (beta)](/gateway/api/admin-ee/3.4.0.x/)

### Dependencies

* Fixed incorrect LuaJIT LDP/STP fusion on ARM64 which may sometimes cause incorrect logic.


## 3.4.0.0
**Release Date** 2023/08/09

### Breaking changes and deprecations

* **Cassandra DB support removed:** Cassandra DB support has been removed. 
It is no longer supported as a data store for Kong Gateway. 
[#10931](https://github.com/Kong/kong/pull/10931).
* **Alpine support removed:** Alpine packages and Docker images based on Alpine are no longer supported.
Starting with Kong Gateway 3.4.0.0, Kong is not building new Alpine images or packages.
[#10926](https://github.com/Kong/kong/pull/10926)
* **Ubuntu 18.04 support removed**: Support for running Kong Gateway on Ubuntu 18.04 ("Bionic") is now deprecated,
as [Standard Support for Ubuntu 18.04 has ended as of June 2023](https://wiki.ubuntu.com/Releases).
Starting with Kong Gateway 3.4.0.0, Kong is not building new Ubuntu 18.04
images or packages, and Kong will not test package installation on Ubuntu 18.04.

    If you need to install Kong Gateway on Ubuntu 18.04, see the documentation for
    [previous versions](/gateway/3.1.x/install/linux/ubuntu/).
* Amazon Linux 2022 artifacts are renamed to Amazon Linux 2023, based on AWS's own renaming.
* LMDB encryption has been disabled. The option `declarative_config_encryption_mode` has been removed from `kong.conf`.
* The `/consumer_groups/:id/overrides` endpoint is deprecated in favor of a more generic plugin scoping mechanism. 
See the new [consumer groups](/gateway/api/admin-ee/3.4.0.x/#/consumer_groups/get-consumer_groups) entity.
* Renamed the configuration property `admin_api_uri` to `admin_gui_api_url`.
  The old `admin_api_uri` property is considered deprecated and will be
  fully removed in a future version of Kong Gateway.
* The RHEL8 Docker image provided by Kong is replaced with the RHEL9 Docker image. The RHEL8 packages are still available [from our package repository](https://cloudsmith.io/~kong/repos/gateway-34/packages/?q=distribution%3Arhel+AND+distribution%3A8). 

### Features 

#### Deployment

* Kong Gateway is now available on [RHEL 9](https://cloudsmith.io/~kong/repos/gateway-34/packages/?q=distribution%3Arhel+AND+distribution%3A9).

#### Enterprise

* Introduced the [`cascade`](/gateway/latest/admin-api/workspaces/reference/#delete-a-workspace) option for 
`/workspaces`, which lets you delete a workspace and all of its entities in one request.
* Consumer groups are now a core entity. With consumer groups, you can apply different configurations to select groups of consumers.
  The following plugins can now be scoped to consumer groups:
  * Rate Limiting Advanced
  * Request Transformer and Request Transformer Advanced
  * Response Transformer and Response Transformer Advanced

   See the documentation for [consumer groups](/gateway/latest/kong-enterprise/consumer-groups/) to learn more.
* Added a new `ttl` option to vault configurations, allowing users to define the interval at which 
references are automatically re-fetched from the configured vault.
  
  See the documentation for [secrets rotation](/gateway/latest/kong-enterprise/secrets-management/secrets-rotation/) to learn more.
* The workspace name now appears in the logging payload.

#### Kong Manager

* Introduced the **Kong Manager Open Source Edition (OSS)**, a 
free and open-source UI for Kong Gateway OSS!
  [#11131](https://github.com/Kong/kong/pull/11131)

  [Kong Manager OSS](/gateway/latest/kong-manager-oss/) allows you to view and edit all Kong Gateway objects using the Admin API. 
  It interacts directly with the Kong Admin API and does not require a separate database.
  This UI provides a great way to see all of your Kong Gateway configuration at glance.

  Starting with 3.4.0.0, Kong Manager OSS is bundled with Kong Gateway OSS.
  Install a new Kong Gateway OSS instance to try it out!

  The quickest way to get started is using the [quickstart script](https://github.com/Kong/kong-manager#getting-started).

  Check out the [Kong Manager OSS repo](https://github.com/Kong/kong-manager)
  to learn more about it.

* Enhanced the user experience of editing pages for entities with a refined look and feel.
* Simplified the user path by removing the configuration pages for nested entities.

#### Core

* **Beta feature:** Introduced the beta of WebAssembly (`proxy-wasm`).
  [#11218](https://github.com/Kong/kong/pull/11218)

  This release integrates [`Kong/ngx-wasm-module`](https://github.com/Kong/ngx_wasm_module)
  into Kong Gateway.

* The `/schemas` endpoint now returns additional information about cross-field validation 
as part of the schema. This should help tools that use the Admin API to perform 
better client-side validation.
* Enabled the `expressions` and `traditional_compatible` router flavors in the stream subsystem.
  [#11071](https://github.com/Kong/kong/pull/11071)
* The upstream `host_header` and router `preserve_host` configuration parameters now work in stream TLS proxy.
  [#11244](https://github.com/Kong/kong/pull/11244)
* In DB-less mode, the declarative schema is now fully initialized at startup
  instead of on-demand in the request path. This is most evident in decreased
  response latency when updating configuration via the `/config` API endpoint.
  [#10932](https://github.com/Kong/kong/pull/10932)
* Tracing: Added the new attribute `http.route` to HTTP request spans.
  [#10981](https://github.com/Kong/kong/pull/10981)
* Tracing: Added the span attribute `net.peer.name`, which records the upstream hostname if it's 
available in `balancer_data.hostname`.
  Thanks [@backjo](https://github.com/backjo) for contributing this change.
  [#10723](https://github.com/Kong/kong/pull/10729)
* The default value of `lmdb_map_size` config has been bumped to `2048m`
  from `128m` to accommodate most commonly deployed config sizes in DB-less
  and hybrid modes.
  [#11047](https://github.com/Kong/kong/pull/11047)
* The default value of `cluster_max_payload` config has been bumped to `16m`
  from `4m` to accommodate most commonly deployed config sizes in hybrid mode.
  [#11090](https://github.com/Kong/kong/pull/11090)
* Removed Kong branding from the kong HTML error template.
  [#11150](https://github.com/Kong/kong/pull/11150)

#### Plugins

* Validation for plugin queue related parameters has been
  improved. [#10840](https://github.com/Kong/kong/pull/10840)
  * `max_batch_size`, `max_entries`, and `max_bytes` are now declared
  as `integer` not `number`. 
  * `initial_retry_delay` and `max_retry_delay` must now be numbers greater 
  than 0.001 (in seconds).

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * The `redis` strategy now catches strategy connection failures.

* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * This plugin now supports the error reason header. 
  This header can be turned off by setting `expose_error_code` to `false`.
  * OpenID Connect now supports adding scope to the token cache key by 
  setting `token_cache_key_include_scope` to `true`.

* [**Kafka Log**](/hub/kong-inc/kafka-log/) (`kafka-log`)
  * The Kafka Log plugin now supports the `custom_fields_by_lua` configuration for 
  dynamic modification of log fields using Lua code.

* [**GraphQL Rate Limiting Advanced**](/hub/kong-inc/graphql-rate-limiting-advanced/) (`graphql-rate-limiting-advanced`)
  * The `host` field of this plugin now accepts Kong upstream targets.

* [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`)
  * Introduced support for the AWS X-Ray propagation header.
  The field `header_type`now accepts the `aws` value to handle this specific
  propagation header.
  [#11075](https://github.com/Kong/kong/pull/11075)
  * The `endpoint` parameter is now referenceable, and can be stored as a secret in a vault.
  [#11220](https://github.com/Kong/kong/pull/11220)

* [**IP Restriction**](/hub/kong-inc/ip-restriction/) (`ip-restriction`)
  * Added support for the `tcp`, `tls`, `grpc`, and `grpcs` protocols.
  
    Thanks [@scrudge](https://github.com/scrudge) for contributing this change.
    [#10245](https://github.com/Kong/kong/pull/10245)

 * [**Prometheus**](/hub/kong-inc/prometheus/) (`prometheus`)
  * The Prometheus plugin has been optimized to reduce proxy latency impacts during scraping.
  [#10949](https://github.com/Kong/kong/pull/10949)
  [#11040](https://github.com/Kong/kong/pull/11040)
  [#11065](https://github.com/Kong/kong/pull/11065)

### Fixes

#### Enterprise

* Fixed a potential memory leak and reconnection problem which could occur when telemetry 
breaks down due to any exceptions in its `send` thread.
* Telemetry: Fixed issues that broke the telemetry websocket:
  * Fixed an issue that caused the telemetry websocket to be blocked by latency while
  flushing Vitals to database. By using a queue as a buffer, the process of
  receiving Vitals data from the data plane is now decoupled from the process of 
  flushing Vitals to the database on the control plane.
  * Fixed an issue that broke the telemetry websocket in Konnect mode due to unexpected 
  payloads when the counter of requests equals zero. 
* Fixed an issue where you could receive an empty `request_id` when generating audit data.
* Fixed an error that occurred when the header `x-datadog-parent-id` wasn't passed to
Kong Gateway.
* Fixed a queueing-related issue that broke event hooks in 3.3.0.0.
* Updated the datafile library to make the SAML plugin work when
  Kong Gateway is controlled by systemd.
* Fixed an issue where a workspace couldn't attach to the cache's consumer well.
* Fixed a LuaJIT crash on Arm64 and enabled LuaJIT on M1.
* Fixed an issue where the license couldn't load when pulling `KONG_LICENSE_DATA` from a vault.

#### Kong Manager

* Fixed an issue where Kong Manager didn't get the latest config when the Enterprise license was posted via the Admin API.
* Fixed incorrect CORS behavior that occurred when Kong Manager was integrated with the Portal GUI.
* Fixed an issue where OIDC in Kong Manager didn't handle `invalid credentials` when providing the wrong username.
* Added an alert message in the `admins tab` page for `workspace access` while the `admin_auth` is set to `openid-connect`.
* Fixed an issue where the custom permission endpoint didn't work for `/services/<service-name-or-id>/application_instances`.

#### Dev Portal

* Fixed an issue on portal documentation pages, where disabling the Application Registration plugin didn't remove the
**Register** button from a service.
* Fixed an issue with viewing OAS docs in the in the Dev Portal, where the UI would
hang when attempting to expand an API.

#### Core

* Declarative config now performs proper uniqueness checks against its inputs.
  Previously, it would silently drop entries with conflicting primary/endpoint
  keys, or accept conflicting unique fields silently.
  [#11199](https://github.com/Kong/kong/pull/11199)
* Fixed a bug where a worker consuming dynamic log level setting events used the wrong reference for notice logging.
  [#10897](https://github.com/Kong/kong/pull/10897)
* Added a `User=` specification to the systemd unit definition so that
  Kong Gateway can be controlled by systemd again.
  [#11066](https://github.com/Kong/kong/pull/11066)
* Fixed a bug that caused the sampling rate to be applied to individual spans, producing split traces.
  [#11135](https://github.com/Kong/kong/pull/11135)
* Fixed a bug that caused the router to fail in `traditional_compatible` mode when a route with multiple paths and no service was created.
  [#11158](https://github.com/Kong/kong/pull/11158)
* Fixed an issue where the `expressions` router couldn't work correctly
  when `route.protocols` is set to `grpc` or `grpcs`.
  [#11082](https://github.com/Kong/kong/pull/11082)
* Fixed an issue where the `expressions` router couldn't configure HTTPS redirection.
  [#11166](https://github.com/Kong/kong/pull/11166)
* Made the `kong vault get` CLI command work in DB-less mode by injecting the necessary
 directives into the Kong CLI `nginx.conf`.
  [#11127](https://github.com/Kong/kong/pull/11127)
  [#11291](https://github.com/Kong/kong/pull/11291)
* Fixed an issue where a crashing Go plugin server process would cause subsequent
  requests proxied through Kong Gateway to execute Go plugins with inconsistent configurations.
  The issue only affects scenarios where the same Go plugin is applied to different route
  or service entities.
  [#11306](https://github.com/Kong/kong/pull/11306)

#### Admin API

* Fixed an issue that caused `POST /config?flatten_errors=1` to throw an exception
  and return a 500 error under certain circumstances.
  [#10896](https://github.com/Kong/kong/pull/10896)
* Fixed an issue where `/schemas/plugins/validate` endpoint failed to validate valid plugin configuration
  when the key of `custom_fields_by_lua` contained dot (`.`) character(s).
  [#11091](https://github.com/Kong/kong/pull/11091)

#### Status API

* Removed the database information from the status API when operating in DB-less
  mode or on the data plane.
  [#10995](https://github.com/Kong/kong/pull/10995)

#### Plugins

* [**OAuth 2.0 Introspection**](/hub/kong-inc/oauth2-introspection/) (`oauth2-introspection`)
  * Fixed an issue where the plugin failed when processing a request with JSON that is not a table.

* [**gRPC Gateway**](/hub/kong-inc/grpc-gateway/) (`grpc-gateway`)
  * Fixed an issue where an array with one element would fail to be encoded.
  * Fixed an issue where empty (all default value) messages couldn't be unframed correctly.
  [#10836](https://github.com/Kong/kong/pull/10836)

* [**Response Transformer**](/hub/kong-inc/response-transformer/) (`response-transformer`) and 
[**Request Transformer Advanced**](/hub/kong-inc/request-transformer-advanced/) (`request-transformer-advanced`)
  * Fixed an issue where the plugin wouldn't transform the response body when the upstream returned a 
  Content-Type with a `+json` suffix as the subtype.

* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Changed some log levels from `notice` to `error` for better visibility.
  * Correctly set the right table key on `log` and `message`.
  * If an invalid opaque token is provided but verification fails, the plugin now prints the correct error.

* [**Mocking**](/hub/kong-inc/mocking/) (`mocking`)
  * Fixed an issue where the plugin threw an error when the arbitrary elements were defined in the path node.

* [**mTLS Authentication**](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
  * Fixed several revocation verification issues:
    * If `revocation_check_mode=IGNORE_CA_ERROR`, then the CRL revocation failure will be ignored.
    * Once a CRL is added into the store, it will always do CRL revocation check with this CRL file.
    * OCSP verification failed with `no issuer certificate in chain` error if the client only sent a leaf certificate.
    * `http_timeout` wasn't correctly set.
  * Optimized CRL revocation verification.
  * Fixed an issue that would cause an unexpected error when `skip_consumer_lookup` is enabled and 
  `authenticated_group_by` is set to `null`.

* [**Kafka Log**](/hub/kong-inc/kafka-log/) (`kafka-log`) and [**Kafka Upstream**](/hub/kong-inc/kafka-upstream/) (`kafka-upstream`)
  * Fixed an issue where the plugin could lose connection to a broker when the broker leadership changed.

* [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`)
  * Fixed an issue where the plugin was unable to pass the 
  validation even if path parameter was valid.
  * Fixed an issue where the plugin always validated the request body even 
  if the method spec had no `requestBody` defined.
  * Fixed an issue where the comparison between large absolute value numbers could be incorrect 
  due to the number being converted to exponential notation.

* [**Request Validator**](/hub/kong-inc/request-validator/) (`request-validator`)
  * Optimized the response message for invalid requests.

* [**ACME**](/hub/kong-inc/acme/) (`acme`)
    * Fixed an issue where the sanity test didn't work with `kong` storage in hybrid mode.
  [#10852](https://github.com/Kong/kong/pull/10852)

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) 
  * Fixed an issue that impacted the accuracy with the `redis` policy.
  Thanks [@giovanibrioni](https://github.com/giovanibrioni) for contributing this change.
  [#10559](https://github.com/Kong/kong/pull/10559)

* [**Zipkin**](/hub/kong-inc/zipkin/) (`zipkin`)
  * Fixed an issue where traces weren't being generated correctly when instrumentations were enabled.
  [#10983](https://github.com/Kong/kong/pull/10983)

### Dependencies

* Bumped `kong-redis-cluster` from 1.5.0 to 1.5.1
* Bumped `lua-resty-ljsonschema` from 1.1.3 to 1.15
* Bumped `lua-resty-kafka` from 0.15 to 0.16
* Bumped `lua-resty-aws` from 1.2.2 to 1.2.3
* Bumped `lua-resty-openssl` from 0.8.20 to 0.8.23
  [#10837](https://github.com/Kong/kong/pull/10837)
  [#11099](https://github.com/Kong/kong/pull/11099)
* Bumped `kong-lapis` from 1.8.3.1 to 1.14.0.2
  [#10841](https://github.com/Kong/kong/pull/10841)
* Bumped `lua-resty-events` from 0.1.4 to 0.2.0
  [#10883](https://github.com/Kong/kong/pull/10883)
  [#11083](https://github.com/Kong/kong/pull/11083)
  [#11214](https://github.com/Kong/kong/pull/11214)
* Bumped `lua-resty-session` from 4.0.3 to 4.0.4
  [#11011](https://github.com/Kong/kong/pull/11011)
* Bumped `OpenSSL` from 1.1.1t to 3.1.1
  [#10180](https://github.com/Kong/kong/pull/10180)
  [#11140](https://github.com/Kong/kong/pull/11140)
* Bumped `pgmoon` from 1.16.0 to 1.16.2 (Kong's fork)
  [#11181](https://github.com/Kong/kong/pull/11181)
  [#11229](https://github.com/Kong/kong/pull/11229)
* Bumped `atc-router` from 1.0.5 to 1.2.0
  [#10100](https://github.com/Kong/kong/pull/10100)
  [#11071](https://github.com/Kong/kong/pull/11071)
* Bumped `lua-resty-lmdb` from 1.1.0 to 1.3.0
  [#11227](https://github.com/Kong/kong/pull/11227)

### Known issues

* Some referenceable configuration fields, such as the `http_endpoint` field
  of the `http-log` plugin and the `endpoint` field of the `opentelemetry` plugin,
  do not accept reference values due to incorrect field validation.

* {% include_cached /md/enterprise/migration-finish-warning.md %}

## 3.3.1.1
**Release Date** 2023/10/12

### Breaking Changes

* **Ubuntu 18.04 support removed**: Support for running Kong Gateway on Ubuntu 18.04 ("Bionic") is now deprecated,
as [Standard Support for Ubuntu 18.04 has ended as of June 2023](https://wiki.ubuntu.com/Releases).
Starting with Kong Gateway 3.2.2.4, Kong is not building new Ubuntu 18.04
images or packages, and Kong will not test package installation on Ubuntu 18.04.

    If you need to install Kong Gateway on Ubuntu 18.04, substitute a previous 3.2.x 
    patch version in the [installation instructions](/gateway/3.2.x/install/linux/ubuntu/).

* Amazon Linux 2022 artifacts are now labeled as Amazon Linux 2023, aligning with AWS's renaming.
* CentOS packages are now removed from the release and are no longer supported in future versions.

### Features

#### Plugins
* [**GraphQL Rate Limiting Advanced**](/hub/kong-inc/graphql-rate-limiting-advanced/) (`graphql-rate-limiting-advanced`) and [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`): The Redis strategy now catches strategy connection failures.

### Fixes

#### Core
* Applied Nginx patch for early detection of HTTP/2 stream reset attacks.
This change is in direct response to the identified vulnerability 
[CVE-2023-44487](https://nvd.nist.gov/vuln/detail/CVE-2023-44487).

  See our [blog post](https://konghq.com/blog/product-releases/novel-http2-rapid-reset-ddos-vulnerability-update) for more details on this vulnerability and Kong's responses to it.
* Fixed an issue where an abnormal socket connection would be incorrectly reused when querying the PostgreSQL database.
* Fixed a keyring issue where Kong Gateway nodes would fail to send keyring 
data when using the cluster strategy.
* Fixed an issue where a crashing Go plugin server process would cause subsequent 
requests proxied through Kong Gateway to execute Go plugins with inconsistent configurations. 
The issue only affects scenarios where the same Go plugin is applied to different route or service entities.
* Fixed an issue that caused the sampling rate to be applied to individual spans, producing split traces.
* Fixed worker queue issues:
  * Worker queues now clear in batches when the worker is in shutdown mode and more data becomes immediately available, without waiting for `max_coalescing_delay`.
  [#11376](https://github.com/Kong/kong/pull/11376)
  * Fixed a race condition in plugin queues that could crash the worker when `max_entries` was set to `max_batch_size`.
  [#11378](https://github.com/Kong/kong/pull/11378)
* Added a `User=` specification to the systemd unit definition, enabling Kong Gateway to be controlled by systemd again.
    [#11066](https://github.com/Kong/kong/pull/11066)

#### Plugins

* [**SAML**](/hub/kong-inc/saml/) (`saml`): Users will now receive a 500 error instead of being endlessly redirected when the Redis session storage is incorrectly configured.

* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`):
  * The plugin now correctly sets the table key on `log` and `message`.
  * When an invalid opaque token is provided and the verification fails, the plugin now prints the correct error message.

* [**Response Transformer Advanced**](/hub/kong-inc/response-transformer-advanced/) (`response-transformer-advanced`): The plugin no longer loads the response body when `if_status` 
doesn't match the provided status.

* [**mTLS Authentication**](/hub/kong-inc/mtls-auth/) (`mtls-auth`): Fixed an issue that caused the plugin to cache network failures when running certificate revocation checks.

### Dependencies

* Bumped `libxml2` from 2.10.2 to 2.11.5
* Bumped `lua-resty-kafka` from 0.15 to 0.16
* Bumped `OpenSSL` from 1.1.1t to 3.1.1


## 3.3.1.0
**Release Date** 2023/07/03

### Fixes

* Fixed a bug that causes `POST /config?flatten_errors=1` to throw an exception and return a 500 error under certain circumstances. 
* Fixed a bug that would cause an error when the header `x-datadog-parent-id` is not passed to Kong. 
* Fixed a queueing-related bug that meant the `event_hooks` did not fire and led to errors in the logs. 
* Updated the datafile library that meant when Kong was started with systemd, the SAML plugin did not load. 
* Fixed a bug that the anonymous report can't be silenced by setting `anonymous_reports=false`.
* Fixed a Jenkins issue where `kong/kong-gateway:3.3.0.0-alpine` was missing `resty.dns.resolver` patch. 
* Fixed an issue addressing occasional issues attaching a workspace with the cache's consumer well.

#### Plugins
* Fixed an issue with the Oauth 2.0 Introspection plugin where a request with JSON that is not a table failed.

### Deprecations
* **Alpine deprecation reminder:** Kong has announced our intent to remove support for Alpine images and packages later this year. These images and packages are available in 3.2 and will continue to be available in 3.3. We will stop building Alpine images and packages in Kong Gateway 3.4.

* **Cassandra deprecation and removal reminder:** Using Cassandra as a backend database for Kong Gateway is deprecated. 
It is planned for removal with {{site.base_gateway}} 3.4.

## 3.3.0.0
**Release Date** 2023/05/19

### Breaking changes and deprecations

* **Alpine deprecation reminder:** Kong has announced our intent to remove support for Alpine images and packages later this year. 
These images and packages are still available in 3.3. We will stop building Alpine images and packages in Kong Gateway 3.4.

* **Cassandra deprecation and removal reminder:** Using Cassandra as a backend database for Kong Gateway is deprecated. 
It is planned for removal with {{site.base_gateway}} 3.4.

#### Core

* The `traditional_compat` router mode has been made more compatible with the
  behavior of `traditional` mode by splitting routes with multiple paths into
  multiple `atc` routes with separate priorities. Since the introduction of the new
  router in Kong Gateway 3.0, `traditional_compat` mode assigned only one priority
  to each route, even if different prefix path lengths and regular expressions
  were mixed in a route. This was not how multiple paths were handled in the
  `traditional` router and the behavior has now been changed so that a separate
  priority value is assigned to each path in a route.
  [#10615](https://github.com/Kong/kong/pull/10615)

* **Tracing**: `tracing_sampling_rate` now defaults to 0.01 (trace one of every 100 requests) 
instead of the previous 1 (trace all requests). 
  Tracing all requests causes unnecessary resource drain for most production systems.
  [#10774](https://github.com/Kong/kong/pull/10774)

#### Plugins

* Plugin batch queuing:
  * [**HTTP Log**](/hub/kong-inc/http-log/) (`http-log`), [**StatsD**](/hub/kong-inc/statsd/) (`statsd`), 
[**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`), and [**Datadog**](/hub/kong-inc/datadog/) (`datadog`)

      The queuing system has been reworked, causing some plugin 
      parameters to not function as expected anymore. 
      If you use queues in these plugins, new parameters must be configured.
      See each plugin's documentation for details.

  * The module `kong.tools.batch_queue` has been renamed to `kong.tools.queue` and 
  the API was changed.  If your custom plugin uses queues, it must 
  be updated to use the new API.
  [#10172](https://github.com/Kong/kong/pull/10172)

* [**AppDynamics**](/hub/kong-inc/app-dynamics/) (`app-dynamics`)
  * The plugin version has been updated to match Kong Gateway's version.

* [**HTTP Log**](/hub/kong-inc/http-log/) (`http-log`)
  * If the log server responds with a 3xx HTTP status code, the
  plugin now considers it to be an error and retries according to the retry
  configuration. Previously, 3xx status codes would be interpreted as a success,
  causing the log entries to be dropped.
  [#10172](https://github.com/Kong/kong/pull/10172)

* **[Pre-function](/hub/kong-inc/pre-function/) (`pre-function`) and [Post-function](/hub/kong-inc/post-function/)** (`post-function`)
  * `kong.cache` now points to a cache instance that is dedicated to the
  Serverless Functions plugins. It does not provide access to the global Kong Gateway cache. 
  Access to certain fields in `kong.conf` has also been restricted.
  [#10417](https://github.com/Kong/kong/pull/10417)

* [**Zipkin**](/hub/kong-inc/zipkin/) (`zipkin`)
  This plugin now uses queues for internal buffering. 
  The standard queue parameter set is available to control queuing behavior.
  [#10753](https://github.com/Kong/kong/pull/10753)

### Features

#### Enterprise

* When using the [data plane resilience feature](/gateway/latest/kong-enterprise/cp-outage-handling-faq/), the server-side certificate of the backend Amazon S3 or GCP Cloud Storage service will now be validated if it goes through HTTPS.
* When [managing secrets](/gateway/latest/kong-enterprise/secrets-management/) with an AWS or GCP backend, the backend server's certificate is now validated if it goes through HTTPS.
* Kong Enterprise now supports [using AWS IAM database authentication to connect to the Amazon RDS](/gateway/latest/kong-enterprise/aws-iam-auth-to-rds-database/) (PostgreSQL) database.
* Kong Manager:
  * Kong Manager and Konnect now share the same UI for the navbar, sidebar, and all entity lists. 
  * Improved display for the routes list when the expressions router is enabled. 
  * **CA Certificates** and **TLS Verify** are now supported in the Kong Gateway service form. 
  * Added a GitHub star in the free mode navbar. 
  * Upgraded the Konnect CTA in free mode.
* SBOM files in SPDX and CycloneDX are now generated for Kong Gateway's Docker images.

#### Kong Gateway with Konnect

* You can now configure [labels for data planes](/konnect/runtime-manager/runtime-instances/custom-dp-labels/)
  to provide metadata information for Konnect.
  [#10471](https://github.com/Kong/kong/pull/10471)
* Sending analytics to Konnect from Kong Gateway DB-less mode is now supported.

#### Core

* `runloop` and `init` error response content types are now compliant with the `Accept` header value.
  [#10366](https://github.com/Kong/kong/pull/10366)
* You can now configure custom error templates.
  [#10374](https://github.com/Kong/kong/pull/10374)
* The maximum number of request headers, response headers, URI arguments, and POST arguments that are
  parsed by default can now be configured with the following new configuration parameters:
  [`lua_max_req_headers`](/gateway/latest/reference/configuration/#lua_max_req_headers), [`lua_max_resp_headers`](/gateway/latest/reference/configuration/#lua_max_resp_headers), [`lua_max_uri_args`](/gateway/latest/reference/configuration/#lua_max_uri_args), and [`lua_max_post_args`](/gateway/latest/reference/configuration/#lua_max_post_args).
  [#10443](https://github.com/Kong/kong/pull/10443)
* Added PostgreSQL triggers on the core entites and entities in bundled plugins to delete
  expired rows in an efficient and timely manner.
  [#10389](https://github.com/Kong/kong/pull/10389)
* Added support for configurable node IDs.
  [#10385](https://github.com/Kong/kong/pull/10385)
* Request and response buffering options are now enabled for incoming HTTP 2.0 requests.
  
    Thanks [@PidgeyBE](https://github.com/PidgeyBE) for contributing this change.
    [#10204](https://github.com/Kong/kong/pull/10204) [#10595](https://github.com/Kong/kong/pull/10595)

* Added `KONG_UPSTREAM_DNS_TIME` to `ngx.ctx` to record the time it takes for DNS
  resolution when Kong proxies to an upstream.
  [#10355](https://github.com/Kong/kong/pull/10355)
* Dynamic log levels now have a default timeout of 60 seconds.
  [#10288](https://github.com/Kong/kong/pull/10288)

#### Admin API

* Added a new `updated_at` field for the following entities: `ca_certificates`, `certificates`, `consumers`, `targets`, `upstreams`, `plugins`, `workspaces`, `clustering_data_planes`, `consumer_group_consumers`, `consumer_group_plugins`, `consumer_groups`, `credentials`, `document_objects`, `event_hooks`, `files`, `group_rbac_roles`, `groups`, `keyring_meta`, `legacy_files`, `login_attempts`, `parameters`, `rbac_role_endpoints`, `rbac_role_entities`, `rbac_roles`, `rbac_users`, and `snis`.
[#10400](https://github.com/Kong/kong/pull/10400)
* The `/upstreams/<upstream>/health?balancer_health=1` endpoint always shows the balancer health
through a new attribute: `balancer_health`. This always returns `HEALTHY` or `UNHEALTHY`, reporting
the true state of the balancer, even if the overall upstream health status is `HEALTHCHECKS_OFF`.
This is useful for debugging.
[#5885](https://github.com/Kong/kong/pull/5885)
* **Beta**: OpenAPI specs are now available for the Kong Gateway Admin API:
  * [Kong Gateway Admin API - OSS spec](/gateway/api/admin-oss/3.3.x/)
  * [Kong Gateway Admin API - Enterprise spec](/gateway/api/admin-ee/3.3.0.x/)

#### Status API

* The `status_listen` server has been enhanced with the addition of the
`/status/ready` API for monitoring Kong Gateway's health.
This endpoint provides a `200` response upon receiving a `GET` request,
but only if a valid, non-empty configuration is loaded and Kong Gateway is
prepared to process user requests.

    Load balancers frequently utilize this functionality to ascertain
    Kong Gateway's availability to distribute incoming requests.
    [#10610](https://github.com/Kong/kong/pull/10610)
    [#10787](https://github.com/Kong/kong/pull/10787)
* **Beta**: An OpenAPI spec is now available for the 
[Kong Gateway Status API](/gateway/api/status/v1/).


#### PDK

* The PDK now supports getting a plugin's ID with `kong.plugin.get_id`.
  [#9903](https://github.com/Kong/kong/pull/9903)
* Tracing module: Renamed spans to simplify filtering on tracing backends.
  See [`kong.tracing`](/gateway/latest/plugin-development/pdk/kong.tracing/) for details. 
  [#10577](https://github.com/Kong/kong/pull/10577)

#### Plugins

* [**ACME**](/hub/kong-inc/acme/) (`acme`)
  * This plugin now supports configuring an `account_key` in `keys` and `key_sets`.
    [#9746](https://github.com/Kong/kong/pull/9746)
  * This plugin now supports configuring a `namespace` for Redis storage,
  which defaults to an empty string for backwards compatibility.
    [#10562](https://github.com/Kong/kong/pull/10562)

* [**Proxy Cache**](/hub/kong-inc/proxy-cache/) (`proxy-cache`)
  * Added the configuration parameter `ignore_uri_case` to allow handling the cache key URI as lowercase.
  [#10453](https://github.com/Kong/kong/pull/10453)

* [**Proxy Cache Advanced**](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cache-advanced`)
  * Added wildcard and parameter match support for `content_type`.
  * Added the configuration parameter `ignore_uri_case` to allow handling the cache key URI as lowercase.
    [#10453](https://github.com/Kong/kong/pull/10453)

* [**HTTP Log**](/hub/kong-inc/http-log/) (`http-log`)
  * Added the `application/json; charset=utf-8` option for the `Content-Type` header
  to support log collectors that require that character set declaration.
  [#10533](https://github.com/Kong/kong/pull/10533)

* [**Datadog**](/hub/kong-inc/datadog/) (`datadog`)
  * The `host` configuration parameter is now referenceable.
    [#10484](https://github.com/Kong/kong/pull/10484)

* [**Zipkin**](/hub/kong-inc/zipkin/) (`zipkin`) and [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`)
  * These plugins now convert `traceid` in HTTP response headers to hex format.
  [#10534](https://github.com/Kong/kong/pull/10534)

* [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`)
  * Spans are now correctly correlated in downstream Datadog traces.
  [10531](https://github.com/Kong/kong/pull/10531)
  * Added the `header_type` field. Previously, the `header_type` was hardcoded to `preserve`.
   Now it can be set to one of the following values: `preserve`, `ignore`, `b3`, `b3-single`,
  `w3c`, `jaeger`, or `ot`.
  [#10620](https://github.com/Kong/kong/pull/10620)
  * Added the new span attribute `http.client_ip` to capture the client IP when behind a proxy.
  [#10723](https://github.com/Kong/kong/pull/10723)
  * Added the `http_response_header_for_traceid` configuration parameter.
  Setting a string value in this field sets a corresponding header in the response.
  [#10379](https://github.com/Kong/kong/pull/10379)

* [**AWS Lambda**](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * Added the configuration parameter `disable_https` to support scheme configuration on the lambda service API endpoint.
  [#9799](https://github.com/Kong/kong/pull/9799)

* [**Request Transformer Advanced**](/hub/kong-inc/request-transformer-advanced/) (`request-transformer-advanced`)
  * The plugin now honors the following Kong Gateway configuration parameters: [`untrusted_lua`](/gateway/latest/reference/configuration/#untrusted_lua), [`untrusted_lua_sandbox_requires`](/gateway/latest/reference/configuration/#untrusted_lua_sandbox_requires), [`untrusted_lua_sandbox_environment`](/gateway/latest/reference/configuration/#untrusted_lua_sandbox_environment). These parameters apply to advanced templates (Lua expressions).

* [**Request Validator**](/hub/kong-inc/request-validator/) (`request-validator`)
  * Errors are now logged for validation failures.

* [**JWT Signer**](/hub/kong-inc/jwt-signer/) (`jwt-signer`)
  * Added the configuration field `add_claims`, which lets you add extra claims to JWT. 

### Fixes

#### Enterprise

* The Kong Enterprise systemd unit was incorrectly renamed to `kong.service` in 3.2.x.x versions. 
It has now been reverted back to `kong-enterprise-edition.service` to keep consistent with previous releases.
* Fixed an issue where Kong Gateway failed to generate a keyring when RBAC was enabled.
* Fixed `lua_ssl_verify_depth` in FIPS mode to match the same depth of normal mode.
* Removed the email field from the developer registration response.
* Websocket requests now generate balancer spans when tracing is enabled.
* Fixed an issue where management of licenses via the `/licenses/` endpoint would fail if the current license is not valid.
* Resolved an issue with the plugin iterator where sorting would become mixed up when dynamic reordering was applied. 
  This fix ensures proper sorting behavior in all scenarios.
* Kong Manager:
  * Fixed an issue where changing the vault name in Kong Manager would throw an error.
  * Fixed an issue with tabs, where vertical tab content became blank when selecting a tab that is currently active. 
  * Fixed an issue where the `/register` route occasionally jumped to `/login` instead.
  * Removed the **Custom Identifier** field from the StatsD plugin.
  This field appeared in Kong Manager under Metrics, but the field doesn't exist in the plugin's schema.

#### Kong Gateway with Konnect

* The standard expired license notification no longer appears in logs for data planes running in Konnect mode (`konnect_mode=on`), as it does not apply to them.
* New license alert behavior for data planes running in Konnect mode:
  * If there are at least 16 days left before expiration, no alerts are issued. 
  * If the license expires within 16 days, a warning level alert is issued every day. 
  * If the license is expired, a critical level alert is issued every day.

#### Core

* Fixed an issue where the upstream keepalive pool had a CRC32 collision.
  [#9856](https://github.com/Kong/kong/pull/9856)
* Hybrid mode:
  * Fixed an issue where the control plane didn't downgrade configuration for the AWS Lambda and Zipkin plugins for older versions of data planes.
    [#10346](https://github.com/Kong/kong/pull/10346)
  * Fixed an issue where the control plane didn't rename fields correctly for the Session plugin for older versions of data planes.
  [#10352](https://github.com/Kong/kong/pull/10352)
* Fixed an issue where validation of regex routes was occasionally skipped when the old-fashioned config style was used for DB-less Kong Gateway.
  [#10348](https://github.com/Kong/kong/pull/10348)
* Fixed an issue where tracing could cause unexpected behavior.
  [#10364](https://github.com/Kong/kong/pull/10364)
*  Fixed an issue where balancer passive healthchecks would use the wrong status code when Kong Gateway changed the status code from the upstream in the `header_filter` phase.
  [#10325](https://github.com/Kong/kong/pull/10325)
  [#10592](https://github.com/Kong/kong/pull/10592)
* Fixed an issue where schema validations failing in a nested record did not propagate the error correctly.
  [#10449](https://github.com/Kong/kong/pull/10449) 
* Fixed an issue where dangling Unix sockets would prevent Kong Gateway from restarting in
  Docker containers if it was not cleanly stopped.
  [#10468](https://github.com/Kong/kong/pull/10468)
* Fixed an issue where the sorting function for traditional router sources or destinations led to 
`invalid order function for sorting` errors.
  [#10514](https://github.com/Kong/kong/pull/10514)
* Fixed the UDP socket leak in `resty.dns.client` caused by frequent DNS queries.
  [#10691](https://github.com/Kong/kong/pull/10691)
* Fixed a typo in the mlcache option `shm_set_tries`.
  [#10712](https://github.com/Kong/kong/pull/10712)
* Fixed an issue where a slow startup of the Go plugin server caused a deadlock.
  [#10561](https://github.com/Kong/kong/pull/10561)
* Tracing: 
  * Fixed an issue that caused the `sampled` flag of incoming propagation
  headers to be handled incorrectly and only affect some spans.
  [#10655](https://github.com/Kong/kong/pull/10655)
  * Fixed an issue that was preventing `http_client` spans from being created for OpenResty HTTP client requests.
  [#10680](https://github.com/Kong/kong/pull/10680)
  * Fixed an approximation issue that resulted in reduced precision of the balancer span start and end times.
  [#10681](https://github.com/Kong/kong/pull/10681)
  * `tracing_sampling_rate` now defaults to 0.01 (trace one of every 100 requests) 
  instead of the previous 1 (trace all requests). 
  Tracing all requests causes unnecessary resource drain for most production systems.
  [#10774](https://github.com/Kong/kong/pull/10774)
* Fixed an issue with vault references, which caused Kong Gateway to error out when trying to stop.
  [#10775](https://github.com/Kong/kong/pull/10775)
* Fixed an issue where vault configuration stayed sticky and cached even when configurations were changed.
  [#10776](https://github.com/Kong/kong/pull/10776)
* Fixed the following PostgreSQL TTL clean-up timer issues: 
  * Timers will now only run on traditional and control plane nodes that have enabled the Admin API.
  [#10405](https://github.com/Kong/kong/pull/10405)
  * Kong Gateway now runs a batch delete loop on each TTL-enabled table with a number of `50.000` rows per batch.
  [#10407](https://github.com/Kong/kong/pull/10407)
  * The cleanup job now runs every 5 minutes instead of every 60 seconds.
  [#10389](https://github.com/Kong/kong/pull/10389)
  * Kong Gateway now deletes expired rows based on the database server-side timestamp to avoid potential
  problems caused by the differences in clock time between Kong Gateway and the database server.
  [#10389](https://github.com/Kong/kong/pull/10389)
* Fixed an issue where an empty value for the URI argument `custom_id` crashed the `/consumer` API.
  [#10475](https://github.com/Kong/kong/pull/10475)

#### PDK

* `request.get_uri_captures` now returns the unnamed part tagged as an array for jsonification.
  [#10390](https://github.com/Kong/kong/pull/10390)
* Fixed an issue for tracing PDK where the sampling rate didn't work.
  [#10485](https://github.com/Kong/kong/pull/10485)

#### Plugins

* [**JWE Decrypt**](/hub/kong-inc/jwe-decrypt/) (`jwe-decrypt`), [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`), and [**Vault Authentication**](/hub/kong-inc/vault-auth/) (`vault-auth`)
  * Added the missing schema field `protocols` for `jwe-decrypt`, `oas-validation`, and `vault-auth`.

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) 
  * The `redis` rate limiting strategy now returns an error when Redis Cluster is down.
  * Fixed an issue where the rate limiting `cluster_events` broadcast the wrong data in traditional cluster mode.
  * The control plane no longer creates namespace or syncs.

* [**StatsD Advanced**](/hub/kong-inc/statsd-advanced/) (`statsd-advanced`)
  * Changed the plugin's name to `statsd-advanced` instead of `statsd`. 

* [**LDAP Authentication Advanced**](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * The plugin now performs authentication before authorization, and returns a 403 HTTP code when a user isn't in the authorized groups.
  * The plugin now supports setting the groups to an empty array when groups are not empty. 

* [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`)
  * Fixed an issue where reconfiguring the plugin didn't take effect.
  * Fixed an issue that caused spans to be propagated incorrectly
  resulting in the wrong hierarchy being rendered on tracing backends.
    [#10663](https://github.com/Kong/kong/pull/10663)

* [**Request Validator**](/hub/kong-inc/request-validator/) (`request-validator`)
  * Fixed an issue where the validation function for the  `allowed_content_types` parameter was too strict, making it impossible to use media types that contained a `-` character.

* [**Forward Proxy**](/hub/kong-inc/forward-proxy/) (`forward-proxy`)
  * Fixed an issue which caused the wrong `latencies.proxy` to be used in the logging plugins. 
  This plugin now evaluates `ctx.WAITING_TIME` in the forward proxy instead of doing it in the subsequent phase. 

* [**Request Termination**](/hub/kong-inc/request-termination/) (`request-termination`)
  * Fixed an issue with the `echo` option, which caused the plugin to not return the `uri-captures`.
  [#10390](https://github.com/Kong/kong/pull/10390)

* [**Request Transformer**](/hub/kong-inc/request-transformer/) (`request-transformer`)
  * Fixed an issue where requests would intermittently
  be proxied with incorrect query parameters.
  [10539](https://github.com/Kong/kong/pull/10539)
  * The plugin now honors the value of the `untrusted_lua` configuration parameter.
  [#10327](https://github.com/Kong/kong/pull/10327)

* [**OAuth2**](/hub/kong-inc/oauth2/) (`oauth2`)
  * Fixed an issue where the OAuth2 token was being cached as `nil` if the wrong service was accessed first.
  [#10522](https://github.com/Kong/kong/pull/10522)
  * This plugin now prevents an authorization code created by one plugin instance from being exchanged for an access token created by a different plugin instance.
  [#10011](https://github.com/Kong/kong/pull/10011)

* [**gRPC Gateway**](/hub/kong-inc/grpc-gateway/) (`grpc-gateway`)
  * Fixed an issue where having a `null` value in the JSON payload caused an uncaught exception to be 
  thrown during `pb.encode`.
  [#10687](https://github.com/Kong/kong/pull/10687)
  * Fixed an issue where empty arrays in JSON were incorrectly encoded as `"{}"`. They are
   now encoded as `"[]"` to comply with standards.
  [#10790](https://github.com/Kong/kong/pull/10790)

### Dependencies

* Updated the datafile library dependency to fix the following issues:
  * Kong Gateway didn't work when installed on a read-only file system.
  * Kong Gateway didn't work when started from systemd.
* Bumped `lua-resty-session` from 4.0.2 to 4.0.3
  [#10338](https://github.com/Kong/kong/pull/10338)
* Bumped `lua-protobuf` from 0.3.3 to 0.5.0
  [#10137](https://github.com/Kong/kong/pull/10413)
  [#10790](https://github.com/Kong/kong/pull/10790)
* Bumped `lua-resty-timer-ng` from 0.2.3 to 0.2.5
  [#10419](https://github.com/Kong/kong/pull/10419)
  [#10664](https://github.com/Kong/kong/pull/10664)
* Bumped `lua-resty-openssl` from 0.8.17 to 0.8.20
  [#10463](https://github.com/Kong/kong/pull/10463)
  [#10476](https://github.com/Kong/kong/pull/10476)
* Bumped `lua-resty-http` from 0.17.0.beta.1 to 0.17.1
  [#10547](https://github.com/Kong/kong/pull/10547)
* Bumped `lua-resty-aws` from 1.1.2 to 1.2.2
* Bumped `lua-resty-gcp` from 0.0.11 to 0.0.12
* Bumped `LuaSec` from 1.2.0 to 1.3.1
  [#10528](https://github.com/Kong/kong/pull/10528)
* Bumped `lua-resty-acme` from 0.10.1 to 0.11.0
  [#10562](https://github.com/Kong/kong/pull/10562)
* Bumped `lua-resty-events` from 0.1.3 to 0.1.4
  [#10634](https://github.com/Kong/kong/pull/10634)
* Bumped `lua-kong-nginx-module` from 0.5.1 to 0.6.0
  [#10288](https://github.com/Kong/kong/pull/10288)
* Bumped `lua-resty-lmdb` from 1.0.0 to 1.1.0
  [#10766](https://github.com/Kong/kong/pull/10766)
* Bumped `kong-openid-connect` from 2.5.4 to 2.5.5

### Known Issues

* Due to known issues, Kong recommends not enabling page-level LMDB encryption in versions 3.0.x-3.3.x. 
  
  Don't set `declarative_config_encryption_mode`; leave it at its default value of `off`. Continue relying on disk-level encryption to encrypt the configuration on disk.

* When sending an invalid configuration to the `/config` endpoint while running in DB-less mode and with `flatten_errors=1` set, Kong Gateway incorrectly returns a 500.
This should be a 400 because the configuration is invalid.

* When the OpenID Connect (OIDC) plugin is configured to reference HashiCorp Vault in the `config.client_secret` field (for example, `{vault://hcv/clientSecret}`),
it does not look up the secret correctly.


## 3.2.2.5
**Release Date** 2023/10/12

### Fixes
#### Core

* Applied Nginx patch for early detection of HTTP/2 stream reset attacks.
This change is in direct response to the identified vulnerability 
[CVE-2023-44487](https://nvd.nist.gov/vuln/detail/CVE-2023-44487). 
  
  See our [blog post](https://konghq.com/blog/product-releases/novel-http2-rapid-reset-ddos-vulnerability-update) for more details on this vulnerability and Kong's responses to it.
* Fixed a keyring issue where Kong Gateway nodes would fail to send keyring 
data when using the cluster strategy.
* Fixed an issue where an abnormal socket connection would be incorrectly reused when querying the PostgreSQL database.
* Added a `User=` specification to the systemd unit definition, enabling Kong Gateway to be controlled by systemd again.
  [#11066](https://github.com/Kong/kong/pull/11066)

#### Plugins
* [**mTLS Authentication**](/hub/kong-inc/mtls-auth/) (`mtls-auth`): Fixed an issue that caused the plugin to cache network failures when running certificate revocation checks.

* [**SAML**](/hub/kong-inc/saml/) (`saml`): Users will now receive a 500 error instead of being endlessly redirected when the Redis session storage is incorrectly configured.

### Dependencies

* Bumped `libxml2` from 2.10.2 to 2.11.5

## 3.2.2.4
**Release Date** 2023/09/15

### Breaking changes and deprecations

* **Ubuntu 18.04 support removed**: Support for running Kong Gateway on Ubuntu 18.04 ("Bionic") is now deprecated,
as [Standard Support for Ubuntu 18.04 has ended as of June 2023](https://wiki.ubuntu.com/Releases).
Starting with Kong Gateway 3.2.2.4, Kong is not building new Ubuntu 18.04
images or packages, and Kong will not test package installation on Ubuntu 18.04.

    If you need to install Kong Gateway on Ubuntu 18.04, substitute a previous 3.2.x 
    patch version in the [installation instructions](/gateway/3.2.x/install/linux/ubuntu/).
- Amazon Linux 2022 artifacts are renamed to Amazon Linux 2023, based on AWS's own renaming.
- CentOS packages are now removed from the release and are no longer supported in future versions.

### Fixes
#### Enterprise

* Updated the datafile library to make the SAML plugin work again when Kong is controlled by systemd.
* Fixed an issue where the anonymous report couldn't be silenced by setting `anonymous_reports=false`.
* Fixed an issue where a crashing Go plugin server process would cause subsequent requests proxied through Kong to execute Go plugins with inconsistent configurations. The issue only affected scenarios where the same Go plugin is applied to different route or service entities. 

#### Plugins

* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Correctly set the right table key on `log` and `message`.
  * If an invalid opaque token is provided but verification fails, print the correct error.
* [**Rate Limiting**](/hub/kong-inc/rate-limiting/) (`rate-limiting`)
  * The redis rate limiting strategy now returns an error when Redis Cluster is down.
* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * The control plane no longer attempts to create namespace or synchronize counters with Redis.
* [**Response Transformer Advanced**](/hub/kong-inc/response-transformer-advanced/) (`response-transformer-advanced`)
  * Does not load response body when `if_status` does not match.
    

#### Kong Manager

* Fixed an issue where the Zipkin plugin prevented users from editing the `static_tags` configuration.
* Fixed an issue where the unavailable Datadog Tracing plugin displayed on the plugin installation page.
* Fixed an issue where some metrics were missing from the StatsD plugin.
* Fixed an issue where locale files were not found when using a non-default `admin_gui_path` configuration.
* Fixed an issue where endpoint permissions for application instances did not work as expected.
* Fixed an issue where some icons were shown as unreadable symbols and characters.
* Fixed an issue where users were redirected to pages under the default workspace when clicking links for services or routes of entities residing in other workspaces.
* Fixed an issue that failed to redirect OpenID Connect in Kong Manager if it was provided with an incorrect username.

### Dependencies

* `lua-resty-kafka` is bumped from 0.15 to 0.16
* Bumped `OpenSSL` from 1.1.1t to 3.1.1


## 3.2.2.3 
**Release Date** 2023/06/07

### Fixes
* Fixed an error with the `/config` endpoint. If `flatten_errors=1` was set and an invalid config was sent to the endpoint, a 500 error was incorrectly returned.

### Deprecations
* **Alpine deprecation reminder:** Kong has announced our intent to remove support for Alpine images and packages later this year. These images and packages are available in 3.2 and will continue to be available in 3.3. We will stop building Alpine images and packages in Kong Gateway 3.4.

## 3.2.2.2
**Release Date** 2023/05/19

### Fixes

#### Core 
* Fixed the OpenResty `ngx.print` chunk encoding duplicate free buffer issue that
  led to the corruption of chunk-encoded response data.
  [#10816](https://github.com/Kong/kong/pull/10816)
  [#10824](https://github.com/Kong/kong/pull/10824)
* Fixed the UDP socket leak in `resty.dns.client` caused by frequent DNS queries.
  [#10691](https://github.com/Kong/kong/pull/10691)

#### Plugins
* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
    * Fixed the log flooding issue caused by low `sync_rate` settings.

## 3.2.2.1
**Release Date** 2023/04/03

### Fixes
* Fixed the Dynatrace implementation. Due to a build system issue, Kong Gateway 3.2.x packages prior to 3.2.2.1 didn't contain the debug symbols that Dynatrace requires.

### Deprecations
* **Alpine deprecation reminder:** Kong has announced our intent to remove support for Alpine images and packages later this year. These images and packages are available in 3.2 and will continue to be available in 3.3. We will stop building Alpine images and packages in Kong Gateway 3.4.


## 3.2.2.0
**Release Date** 2023/03/22

### Fixes 
#### Enterprise
* In Kong 3.2.1.0 and 3.2.1.1, `alpine` and `ubuntu` ARM64 artifacts incorrectly handled HTTP/2 requests, causing the protocol to fail. These artifacts have been removed. 
* Added the default logrotate file `/etc/logrotate.d/kong-enterprise-edition`. This file was missing in all 3.x versions of Kong Gateway prior to this release.

#### Plugins
* [**SAML**](/hub/kong-inc/saml/) (`saml`)
    * The SAML plugin now works on read-only file systems.
    * The SAML plugin can now handle the field `session_auth_ttl` (removed since 3.2.0.0).

* Datadog Tracing plugin: We found some late-breaking issues with the Datadog Tracing plugin and elected to remove it from the 3.2 release. We plan to add the plugin back with the issues fixed in a later release. 

### Known issues
* Due to changes in GPG keys, using yum to install this release triggers a `Public key for kong-enterprise-edition-3.2.1.0.rhel7.amd64.rpm is not installed` error. The package *is* signed, however, it's signed with a different (rotated) key from the metadata service, which triggers the error in yum. To avoid this error, manually download the package from [{{site.links.download}}]({{site.links.download}}) and install it. 

## 3.2.1.0
**Release Date** 2023/02/28

### Deprecations

* Deprecated Alpine Linux images and packages. 
    
    Kong is announcing our intent to remove support for Alpine images and packages later this year. These images and packages are available in 3.2 and will continue to be available in 3.3. We will stop building Alpine images and packages in Kong Gateway 3.4.

### Breaking changes

* The default PostgreSQL SSL version has been bumped to TLS 1.2. In `kong.conf`:
   
    * The default [`pg_ssl_version`](/gateway/latest/reference/configuration/#postgres-settings)
    is now `tlsv1_2`.
    * Constrained the valid values of this configuration option to only accept the following: `tlsv1_1`, `tlsv1_2`, `tlsv1_3` or `any`.

    This mirrors the setting `ssl_min_protocol_version` in PostgreSQL 12.x and onward. 
    See the [PostgreSQL documentation](https://postgresqlco.nf/doc/en/param/ssl_min_protocol_version/)
    for more information about that parameter.

    To use the default setting in `kong.conf`, verify that your Postgres server supports TLS 1.2 or higher versions, or set the TLS version yourself. 
    TLS versions lower than `tlsv1_2` are already deprecated and considered insecure from PostgreSQL 12.x onward.
  
* Added the [`allow_debug_header`](/gateway/latest/reference/configuration/#allow_debug_header) 
configuration property to `kong.conf` to constrain the `Kong-Debug` header for debugging. This option defaults to `off`.

    If you were previously relying on the `Kong-Debug` header to provide debugging information, set `allow_debug_header: on` to continue doing so.

* [**JWT plugin**](/hub/kong-inc/jwt/) (`jwt`)
    
    * The JWT plugin now denies any request that has different tokens in the JWT token search locations.
      [#9946](https://github.com/Kong/kong/pull/9946)

* Sessions library upgrade [#10199](https://github.com/Kong/kong/pull/10199):
    * The [`lua-resty-session`](https://github.com/bungle/lua-resty-session) library has been upgraded to v4.0.0. This version includes a full rewrite of the session library, and is not backwards compatible.
      
      This library is used by the following plugins: [**Session**](/hub/kong-inc/session/), [**OpenID Connect**](/hub/kong-inc/openid-connect/), and [**SAML**](/hub/kong-inc/saml/). This also affects any session configuration that uses the Session or OpenID Connect plugin in the background, including sessions for Kong Manager and Dev Portal.

      All existing sessions are invalidated when upgrading to this version.
      For sessions to work as expected in this version, all nodes must run Kong Gateway 3.2.x or later.
      For that reason, we recommend that during upgrades, proxy nodes with mixed versions run for
      as little time as possible. During that time, the invalid sessions could cause failures and partial downtime.
    
   * Parameters:
      * The new parameter `idling_timeout`, which replaces `cookie_lifetime`, now has a default value of 900. Unless configured differently, sessions expire after 900 seconds (15 minutes) of idling. 
      * The new parameter `absolute_timeout` has a default value of 86400. Unless configured differently, sessions expire after 86400 seconds (24 hours).
      * Many session parameters have been renamed or removed. Although your configuration will continue to work as previously configured, we recommend adjusting your configuration to avoid future unexpected behavior. Refer to the [upgrade guide for 3.2](/gateway/latest/upgrade/#session-library-upgrade) for all session configuration changes and guidance on how to convert your existing session configuration.
      
      
### Features

* Changed the underlying operating system (OS) for our convenience Docker tags (for example, `latest`, `3.2.1.0`, `3.2`) from Debian to Ubuntu.

#### Core

* When `router_flavor` is set to`traditional_compatible`, Kong Gateway verifies routes created 
  using the expression router instead of the traditional router to ensure created routes
  are compatible.
  [#9987](https://github.com/Kong/kong/pull/9987)
* In DB-less mode, the `/config` API endpoint can now flatten all schema validation
  errors into a single array using the optional `flatten_errors` query parameter.
  [#10161](https://github.com/Kong/kong/pull/10161)
* The upstream entity now has a new load balancing algorithm option: [`latency`](/gateway/latest/how-kong-works/load-balancing/#balancing-algorithms).
  This algorithm chooses a target based on the response latency of each target
  from prior requests.
  [#9787](https://github.com/Kong/kong/pull/9787)
* The Nginx `charset` directive can now be configured with Nginx directive injections.
    Set it in Kong Gateway's configuration with [`nginx_http_charset`](/gateway/latest/reference/configuration/#nginx_http_charset)
    [#10111](https://github.com/Kong/kong/pull/10111)
* The services upstream TLS configuration is now extended to the stream subsystem.
  [#9947](https://github.com/Kong/kong/pull/9947)
* Added the new configuration parameter [`ssl_session_cache_size`](/gateway/latest/reference/configuration/#ssl_session_cache_size), 
which lets you set the Nginx directive `ssl_session_cache`.
  This configuration parameter defaults to `10m`.
  Thanks [Michael Kotten](https://github.com/michbeck100) for contributing this change.
  [#10021](https://github.com/Kong/kong/pull/10021)
* [`status_listen`](/gateway/latest/reference/configuration/#status_listen) now supports HTTP2. [#9919](https://github.com/Kong/kong/pull/9919)
* The shared Redis connector now supports username + password authentication for cluster connections, improving on the existing single-node connection support. This automatically applies to all plugins using the shared Redis configuration.


#### Enterprise

* **FIPS Support**:
  * The OpenID Connect, Key Authentication - Encrypted, and JWT Signer plugins are now [FIPS 140-2 compliant](/gateway/latest/kong-enterprise/fips-support/). 

    If you are migrating from {{site.base_gateway}} 3.1 to 3.2 in FIPS mode and are using the `key-auth-enc` plugin, you should send [PATCH or POST requests](/hub/kong-inc/key-auth-enc/#create-a-key) to all existing `key-auth-enc` credentials to re-hash them in SHA256.
  * FIPS-compliant Kong Gateway packages now support PostgreSQL SSL connections. 

##### Kong Manager

* Improved the editor for expression fields. Any fields using the expression router now have syntax highlighting, autocomplete, and route validation.
* Improved audit logs by adding `rbac_user_name` and `request_source`. 
By combining the data in the new `request_source` field with the `path` field, you can now determine login and logout events from the logs. 
See the documentation for more detail on [interpreting audit logs](/gateway/latest/kong-enterprise/audit-log/#kong-manager-authentication).
* License information can now be copied or downloaded into a file from Kong Manager. 
* Kong Manager now supports the `POST` method for OIDC-based authentication.
* Keys and key sets can now be configured in Kong Manager.
* Optimized the color scheme for `http` method badges.

#### Plugins

* **Plugin entity**: Added an optional `instance_name` field, which identifies a
  particular plugin entity.
  [#10077](https://github.com/Kong/kong/pull/10077)

* [**Zipkin**](/hub/kong-inc/zipkin/) (`zipkin`)
  * Added support for setting the durations of Kong phases as span tags
  through the configuration property `phase_duration_flavor`.
  [#9891](https://github.com/Kong/kong/pull/9891)

* [**HTTP Log**](/hub/kong-inc/http-log/) (`http-log`)
  * The `headers` configuration parameter is now referenceable, which means it can be securely stored in a vault.
  [#9948](https://github.com/Kong/kong/pull/9948)

* [**AWS Lambda**](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * Added the configuration parameter `aws_imds_protocol_version`, which
  lets you select the IMDS protocol version.
  This option defaults to `v1` and can be set to `v2` to enable IMDSv2.
  [#9962](https://github.com/Kong/kong/pull/9962)

* [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`)
  * This plugin can now be scoped to individual services, routes, and consumers.
  [#10096](https://github.com/Kong/kong/pull/10096)

* [**StatsD**](/hub/kong-inc/statsd/) (`statsd`)
  * Added the `tag_style` configuration parameter, which allows the plugin 
  to send metrics with [tags](https://github.com/prometheus/statsd_exporter#tagging-extensions).
  The parameter defaults to `nil`, which means that no tags are added to the metrics.
  [#10118](https://github.com/Kong/kong/pull/10118)
  
* [**Session**](/hub/kong-inc/session/) (`session`), [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`), and [**SAML**](/hub/kong-inc/saml/) (`saml`)

  * These plugins now use `lua-resty-session` v4.0.0. 

    This update includes new session functionalities such as configuring audiences to manage multiple 
    sessions in a single cookie, global timeout, and persistent cookies.
  
    Due to this update, there are also a number of deprecated and removed parameters in these plugins. 
    See the invidividual plugin documentation for the full list of changed parameters in each plugin.
    * [Session changelog](/hub/kong-inc/session/#changelog)
    * [OpenID Connect changelog](/hub/kong-inc/openid-connect/#changelog)
    * [SAML changelog](/hub/kong-inc/saml/#changelog)

* [**GraphQL Rate Limiting Advanced**](/hub/kong-inc/graphql-rate-limiting-advanced/) (`graphql-rate-limiting-advanced`) and [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
    * In hybrid and DB-less modes, these plugins now support `sync_rate = -1` with any strategy, including the default `cluster` strategy.

* [**OPA**](/hub/kong-inc/opa/) (`opa`)
    * This plugin can now handle custom messages from the OPA server.

* [**Canary**](/hub/kong-inc/canary/) (`canary`)
    * Added a default value for the `start` field in the canary plugin. 
    If not set, the start time defaults to the current timestamp.
    
* **Improved Plugin Documentation**
    * Split the plugin compatibility table into a [technical compatibility page](/hub/plugins/compatibility/).
    * Updated the plugin compatibility information for more clarity on [supported network protocols](/hub/plugins/compatibility/#protocols) and on [entity scopes](/hub/plugins/compatibility/#scopes). 
    * Revised docs for the following plugins to include examples:
      * [CORS](/hub/kong-inc/cors/)
      * [File Log](/hub/kong-inc/file-log/)
      * [HTTP Log](/hub/kong-inc/http-log/)
      * [JWT Signer](/hub/kong-inc/jwt-signer/)
      * [Key Auth](/hub/kong-inc/key-auth/)
      * [OpenID Connect](/hub/kong-inc/openid-connect/)
      * [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/)
      * [SAML](/hub/kong-inc/saml/)
      * [StatsD](/hub/kong-inc/statsd/)
  

### Fixes

#### Core 

* Added back PostgreSQL `FLOOR` function when calculating `ttl`, so `ttl` is always returned as a whole integer.
  [#9960](https://github.com/Kong/kong/pull/9960)
* Exposed PostreSQL connection pool configuration.
  [#9603](https://github.com/Kong/kong/pull/9603)
* **Nginx template**: The default charset is no longer added to the `Content-Type` response header when the upstream response doesn't contain it.
  [#9905](https://github.com/Kong/kong/pull/9905)
* Fixed an issue where, after a valid declarative configuration was loaded,
  the configuration hash was incorrectly set to the value `00000000000000000000000000000000`.
  [#9911](https://github.com/Kong/kong/pull/9911)
* Updated the batch queues module so that queues no longer grow without bounds if
  their consumers fail to process the entries. Instead, old batches are now dropped
  and an error is logged.
  [#10247](https://github.com/Kong/kong/pull/10247)
* Fixed an issue where `X-Kong-Upstream-Status` couldn't be emitted when a response was buffered.
  [#10056](https://github.com/Kong/kong/pull/10056)
* Improved the error message for invalid JWK entries.
  [#9904](https://github.com/Kong/kong/pull/9904)
* Fixed an issue where the `#` character wasn't parsed correctly from environment variables and vault references.
  [10132](https://github.com/Kong/kong/pull/10132)
* Fixed an issue where control plane didn't downgrade configuration for the AWS Lambda and Zipkin plugins for older versions of data planes.
  [#10346](https://github.com/Kong/kong/pull/10346)
* Fixed an issue in DB-less mode, where validation of regex routes could be skipped when using a configuration format older than `3.0`.
  [#10348](https://github.com/Kong/kong/pull/10348)

#### Enterprise

* Fixed an issue where the forward proxy between the data plane and the control plane didn't support telemetry port 8006.
* Fix the PostgreSQL mTLS error `bad client cert type`. 
* Fixed issues with the Admin API's `/licenses` endpoint:
    * The Enterprise license wasn't being picked up by other nodes in a cluster.
    * Vitals routes weren't accessible.
    * Vitals wasn't showing up in hybrid mode.
* Fixed RBAC issues:
  * Fixed an issue where workspace admins couldn't add rate limiting policies to consumer groups.
  * Fixed an issue where workspace admins in one workspace would have admin rights in other workspaces. 
    Workspace admins are now correctly restricted to their own workspaces.
  * Fixed a role precedence issue with RBAC. RBAC rules involving deny (negative) rules now correctly take precedence over allow (non-negative) roles.

##### Vitals

* Fixed an issue where Vitals wasn't tracking the status codes of service-less routes.
* Fixed the Admin API error `/vitals/reports/:entity_type is not available`.

##### Kong Manager

* Fixed an issue where `404 Not Found` errors were triggered while updating the service, route, or consumer bound to a scoped plugin.
* Moved the `tags` field out of the advanced fields section for certificate, route, and upstream configuration pages. 
The tags field is now visible without needing to expand to see all fields.
* Improved the user interface for Keys and Key Sets entities. 
* You can now add tags for consumer groups in Kong Manager.
* Fixed an issue where the plugin **Copy JSON** button didn't copy the full configuration.
* Fixed an issue where the password reset form didn't check for matching passwords and allowed mismatched passwords to be submitted.
* Added a link to the upgrade prompt for Konnect or Enterprise. 
* Fixed an issue where any IdP user could log into Kong Manager, regardless of their role or group membership. 
These users could see the Workspaces Overview dashboard with the default workspace, but they couldn't do anything else.
Now, if IdP users with no groups or roles attempt to log into Kong Manager, they will be denied access.

#### Plugins

* [**Zipkin**](/hub/kong-inc/zipkin/) (`zipkin`)
  * Fixed an issue where the global plugin's sample ratio overrode the route-specific ratio.
  [#9877](https://github.com/Kong/kong/pull/9877)
  * Fixed an issue where `trace-id` and `parent-id` strings with decimals were not processed correctly.

* [**JWT**](/hub/kong-inc/jwt/) (`jwt`)
  * This plugin now denies requests that have different tokens in the JWT token search locations. 
  
    Thanks Jackson 'Che-Chun' Kuo from Latacora for reporting this issue.
    [#9946](https://github.com/Kong/kong/pull/9946)

* [**Datadog**](/hub/kong-inc/datadog/) (`datadog`),[**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`), and [**StatsD**](/hub/kong-inc/statsd/) (`statsd`)
  * Fixed an issue in these plugins' batch queue processing, where metrics would be published multiple times. 
  This caused a memory leak, where memory usage would grow without limit.
  [#10052](https://github.com/Kong/kong/pull/10052) [#10044](https://github.com/Kong/kong/pull/10044)

* [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`)
  *  Fixed non-compliances to specification:
     * For `http.uri` in spans, the field is now the full HTTP URI.
      [#10036](https://github.com/Kong/kong/pull/10036)
     * `http.status_code` is now present on spans for requests that have a status code.
      [#10160](https://github.com/Kong/kong/pull/10160)
     * `http.flavor` is now a string value, not a double.
      [#10160](https://github.com/Kong/kong/pull/10160)
  * Fixed an issue with getting the traces of other formats, where the trace ID reported and propagated could be of incorrect length.
    This caused traces originating from Kong Gateway to incorrectly connect with the target service, causing Kong Gateway and the target service to submit separate traces.
    [#10332](https://github.com/Kong/kong/pull/10332)
  
* [**OAuth2**](/hub/kong-inc/oauth2/) (`oauth2`)
  * `refresh_token_ttl` is now limited to a range between `0` and `100000000` by the schema validator. 
  Previously, numbers that were too large caused requests to fail.
  [#10068](https://github.com/Kong/kong/pull/10068)

* [**OpenID Connect**](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Fixed an issue where it was not possible to specify an anonymous consumer by name.
  * Fixed an issue where the `authorization_cookie_httponly` and `session_cookie_httponly` parameters would always be set to `true`, even if they were configured as `false`.

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Matched the plugin's behavior to the Rate Limiting plugin.
    When an `HTTP 429` status code was returned, rate limiting related headers were missed from the PDK module `kong.response.exit()`. 
    This made the plugin incompatible with other Kong components like the Exit Transformer plugin.

* [**Response Transformer**](/hub/kong-inc/response-transformer/) (`response-transformer`)
  * Fixed an issue where the `allow.json` configuration parameter couldn't use nested JSON object and array syntax.

* [**Mocking**](/hub/kong-inc/mocking/) (`mocking`)
  * Fixed UUID pattern matching. 

* [**SAML**](/hub/kong-inc/saml/) (`saml`)
  * Fixed an issue where the `session_cookie_httponly` parameter would always be set to `true`, even if it was configured as `false`.

* [**Key Authentication Encrypted**](/hub/kong-inc/key-auth-enc/) (`key-auth-enc`)
  * Fixed the `ttl` parameter. You can now set `ttl` for an encrypted key.
  * Fixed an issue where this plugin didn't accept tags.

### Dependencies

* Bumped`lua-resty-openssl` from 0.8.15 to 0.8.17
* Bumped `libexpat` from 2.4.9 to 2.5.0
* Bumped `kong-openid-connect` from v2.5.0 to v2.5.2
* Bumped `openssl` from 1.1.1q to 1.1.1t
* `libyaml` is no longer built with Kong Gateway. System `libyaml` is used instead.
* Bumped `luarocks` from 3.9.1 to 3.9.2
  [#9942](https://github.com/Kong/kong/pull/9942)
* Bumped `atc-router` from 1.0.1 to 1.0.5
  [#9925](https://github.com/Kong/kong/pull/9925)
  [#10143](https://github.com/Kong/kong/pull/10143)
  [#10208](https://github.com/Kong/kong/pull/10208)
* Bumped `lua-resty-openssl` from 0.8.15 to 0.8.17
  [#9583](https://github.com/Kong/kong/pull/9583)
  [#10144](https://github.com/Kong/kong/pull/10144)
* Bumped `lua-kong-nginx-module` from 0.5.0 to 0.5.1
  [#10181](https://github.com/Kong/kong/pull/10181)
* Bumped `lua-resty-session` from 3.10 to 4.0.0
  [#10199](https://github.com/Kong/kong/pull/10199)
  [#10230](https://github.com/Kong/kong/pull/10230)
* Bumped `libxml` from 2.10.2 to 2.10.3 to resolve [CVE-2022-40303](https://nvd.nist.gov/vuln/detail/cve-2022-40303) and [CVE-2022-40304](https://nvd.nist.gov/vuln/detail/cve-2022-40304)

## 3.1.1.6
**Release Date** 2023/10/12

### Fixes

#### Core
* Applied Nginx patch for early detection of HTTP/2 stream reset attacks.
This change is in direct response to the identified vulnerability 
[CVE-2023-44487](https://nvd.nist.gov/vuln/detail/CVE-2023-44487).

  See our [blog post](https://konghq.com/blog/product-releases/novel-http2-rapid-reset-ddos-vulnerability-update) for more details on this vulnerability and Kong's responses to it.

### Dependencies

* Bumped `libxml2` from 2.10.2 to 2.11.5

## 3.1.1.5 
**Release Date** 2023/08/25

### Features

* The Redis strategy of Rate Limiting now catches connection failures.
* Added the parameter `admin_auto_create` for automatically creating a Kong admin.
* Kong Manager supports the `POST` response method for OIDC based authentication

### Fixes 
#### Enterprise

* Fixed an issue with the plugin iterator where sorting would become mixed up when dynamic reordering was applied. This fix ensures proper sorting behavior in all scenarios.
* Fixed an issue where `resty.dns.client` leaked UDP sockets. 
* Fixed a bug where setting `anonymous_reports=false` would not silence anonymous reports.
* Fixed an issue with hybrid mode where vitals and analytics could not communicate through the cluster telemetry endpoint.
* Fixed the HTTP2 request handle in ARM artifacts.
* Fixed the OpenResty `ngx.print` chunk encoding duplicate free buffer issue that
  led to the corruption of chunk-encoded response data. [#10816](https://github.com/Kong/kong/pull/10816)[#10824](https://github.com/Kong/kong/pull/10824)
* Fixed an issue where a crashing Go plugin server process would cause subsequent requests proxied through Kong to execute Go plugins with inconsistent configurations. The issue only affects scenarios where the same Go plugin is applied to different route or service entities.
* Fixed the Dynatrace implementation.

**Kong Manager**:
* Fixed an issue where configuration links would redirect users to the default workspace.
* Fixed an issue with Kong Manager when using OpenID Connect where passing invalid credentials was not resulting in a redirect. 

#### Plugins 
* Request Transformer Advanced: Fixed an issue that was causing some requests to be proxied with the wrong query parameters.
* Response Transformer Advanced: Fixed an issue where large decimals were rounded when the plugin was being used.
* Rate Limiting Advanced: 
  * Fixed an issue where the control plane was trying to sync the rate-limiting-advanced counters with Redis.
  * Fixed an issue where the `rl cluster_events` broadcasted the wrong data in traditional cluster mode.
* Oauth2: Fixed a bug that `refresh_token` could be shared across instances.

### Dependencies

* Bumped `OpenSSL` from 1.1.1t to 3.1.1
* Bumped`lua-resty-openssl` from 0.8.15 to 0.8.22
* Bumped `lua-resty-kafka` from 0.15 to 0.16



## 3.1.1.4
**Release Date** 2023/05/16

### Features

* Kong Manager with OIDC:
  * Added the configuration option
  [`admin_auto_create`](/gateway/latest/kong-manager/auth/oidc/mapping/) to enable or disable automatic admin creation.
  This option is `true` by default.

### Fixes 

#### Core 
* Fixed the UDP socket leak in `resty.dns.client` caused by frequent DNS queries.
  [#10691](https://github.com/Kong/kong/pull/10691)
* Hybrid mode: Fixed an issue where Vitals/Analytics couldn't communicate through the cluster telemetry endpoint.
* Fixed an issue where `alpine` and `ubuntu` ARM64 artifacts incorrectly handled HTTP/2 requests, causing the protocol to fail.
* Fixed the OpenResty `ngx.print` chunk encoding duplicate free buffer issue that
  led to the corruption of chunk-encoded response data.
  [#10816](https://github.com/Kong/kong/pull/10816)
  [#10824](https://github.com/Kong/kong/pull/10824)
* Fixed the Dynatrace implementation. Due to a build system issue, Kong Gateway 3.1.x packages prior to 3.1.1.4 
didn't contain the debug symbols that Dynatrace requires.

#### Enterprise

**Kong Manager**:
* Fixed configuration fields for the StatsD plugin:
  * Added missing metric fields: `consumer_identifier`, `service_identifier`, and `workspace_identifier`. 
  * Removed the non-existent `custom_identifier` field.
* Fixed an issue where the `Copy JSON` for a plugin didn't copy the full plugin configuration.
* Fixed an issue where the Zipkin plugin didn't allow the addition of `static_tags` through the Kong Manager UI.
* Added missing default values to the Vault configuration page.
* Fixed the broken Konnect link in free mode banners.

* OIDC authentication issues:
  * The `/auth` endpoint, used by Kong Manager for OIDC authentication, now correctly supports the HTTP POST method.
  * Fixed an issue with OIDC authentication in Kong Manager, where the default roles 
(`workspace-super-admin`, `workspace-read-only`, `workspace-portal-admin`, and `workspace-admin`) were missing from any 
newly created workspace.
  * Fixed an issue where users with newly registered Dev Portal accounts created through OIDC were unable to log into 
  Dev Portal until the Kong Gateway container was restarted. 
  This happened when `by_username_ignore_case` was set to `true`, which incorrectly caused consumers to always load from cache.

#### Plugins

* [**Request Transformer Advanced**](/hub/kong-inc/request-transformer-advanced/) (`request-transformer-advanced`)
  * Fixed an issue that was causing some requests to be proxied with the wrong query parameters.

## 3.1.1.3
**Release Date** 2023/01/30

### Fixes

#### Enterprise

* Fixed the accidental removal of the `ca-certificates` dependency from packages and images. 
This prevented SSL connections from using common root certificate authorities.

### Upgrades
You can now directly upgrade to {{site.base_gateway}} 3.1.1.3 from 2.8.x.x. Previously, you had to upgrade to 3.0.x first, then upgrade to the latest 3.x version.


## 3.1.1.2
**Release Date** 2023/01/24

### Features

#### Enterprise

- **Dev Portal**:
  - The Dev Portal API now supports an optional `fields` query parameter on the `/files` endpoint.
  This parameter lets you specify which file object fields should be included in the response.

#### Core 

- When `router_flavor` is `traditional_compatible`, verify routes created using the
  Expression router instead of the traditional router to ensure created routes
  are actually compatible.
  [#10088](https://github.com/Kong/kong/pull/10088)
  
- `kong migrations up` now reports routes that are incompatible with the 3.0 router
  and stops the migration progress so that admins have a chance to adjust them.

  [#10092](https://github.com/Kong/kong/pull/10092)
  [#10101](https://github.com/Kong/kong/pull/10101)

### Fixes

#### Enterprise

- **Kong Manager**:
  - Fixed issues with the plugin list:
      - Added missing icons and categories for the TLS Handshake Modifier and TLS Metadata Headers plugins.
      - Removed entries for the following deprecated plugins: Kubernetes Sidecar Injector, Collector, and Upstream TLS.
      - Removed Apache OpenWhisk plugin from Kong Manager. This plugin must be [installed manually via LuaRocks](/hub/kong-inc/openwhisk/).
      - Removed the internal-only Konnect Application Auth plugin. 
  - Fixed an issue where Kong Manager would occasionally log out while redirecting to other pages or refreshing 
    the page when OpenID Connect was used as the authentication method. 
  - Fixed an issue where `404 Not Found` errors were triggered while updating the service, route, or consumer bound to a scoped plugin.
  - Fixed an issue where admins with the permission `['create'] /services/*/plugins` couldn't create plugins under a service.
  - Fixed an issue where viewing a consumer group in any workspace other than `default` would cause a `404 Not Found` error. 

#### Core

* Fixed an issue where regexes generated in inso would not work in Kong Gateway. 
* Bumped `atc-router` to `1.0.2` to address the potential worker crash issue.
  [#9927](https://github.com/Kong/kong/pull/9927)

#### Hybrid mode

- Fixed an issue where Vitals data was not showing up after a license was deployed using the `/licenses` endpoint.
Kong Gateway now triggers an event that allows the Vitals subsystem to be reinitialized during license preload.
- Fixed an issue where the forward proxy between data planes and the control plane didn't support the telemetry port `8006`.
- Reverted the removal of WebSocket protocol support for configuration sync.
  Backwards compatibility with 2.8.x.x data planes has been restored. 
  [#10067](https://github.com/Kong/kong/pull/10067) 

#### Plugins

- [**Datadog**](/hub/kong-inc/datadog/) (`datadog`),[**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`), and [**StatsD**](/hub/kong-inc/statsd/) (`statsd`)
  - Fixed an issue in these plugins' batch queue processing, where metrics would be published multiple times. 
  This caused a memory leak, where memory usage would grow without limit.

- [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  - Fixed an issue with the `local` strategy, which was not working correctly when `window_size` was set to `fixed`, 
    and the cache would expire while the window was still valid.
  
- [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`)
  - Added the OAS Validation plugin back into the bundled plugins list. The plugin is now available by default
  with no extra configuration necessary through `kong.conf`.
  - Fixed an issue where the plugin returned the wrong error message when failing to get the path schema spec. 
  - Fixed a `500` error that occurred when the response body schema had no content field.

- [**mTLS Authentication**](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
  - Fixed an issue where the plugin used the old route caches after routes were updated. 

### Deprecations

- Support for the `/vitals/reports/:entity_type` endpoint is deprecated. Use one of the following endpoints from the Vitals API instead:
  - For `/vitals/reports/consumer`, use `/{workspace_name}/vitals/status_codes/by_consumer` instead
  - For `/vitals/reports/service`, use `/{workspace_name}/vitals/status_codes/by_service` instead
  - For `/vitals/reports/hostname`, use `/{workspace_name}/vitals/nodes` instead

  See the [Vitals documentation](/gateway/latest/kong-enterprise/analytics/#vitals-api) for more detail.
 
### Known issues
* The `ca-certificates` dependency is missing from packages and images. 
This prevents SSL connections from using common root certificate authorities. 

    Upgrade to 3.1.1.3 to resolve.

## 3.1.0.0
**Release Date** 2022/12/06

### Features

#### Enterprise

- You can now specify the namespaces of HashiCorp Vaults for secrets management.

- Added support for HashiCorp Vault backends to retrieve a vault token from a
Kubernetes service account. See the following configuration parameters:
  - [`keyring_vault_auth_method`](/gateway/latest/reference/configuration/#keyring_vault_auth_method)
  - [`keyring_vault_kube_role`](/gateway/latest/reference/configuration/#keyring_vault_kube_role)
  - [`keyring_vault_kube_api_token_file`](/gateway/latest/reference/configuration/#keyring_vault_kube_api_token_file)

- FIPS 140-2 packages:
  - Kong Gateway Enterprise now provides [FIPS 140-2 compliant packages for Red Hat Enterprise 8 and Ubuntu 22.04](/gateway/latest/kong-enterprise/fips-support/).
  - Kong Gateway FIPS distributions now support TLS connections to the PostgreSQL database.

- You can now [delete consumer group configurations](/gateway/latest/kong-enterprise/consumer-groups/#delete-consumer-group-configurations)
 without deleting the group or the consumers in it.

- **Kong Manager**:
  - You can now configure the base path for Kong Manager, for example: `localhost:8445/manager`. This allows you to proxy all traffic through {{site.base_gateway}}. For example, you can proxy both API and Kong Manager traffic from one port. In addition, using the new Kong Manager base path allows you to add plugins to control access to Kong Manager. For more information, see [Enable Kong Manager](/gateway/latest/kong-manager/enable/).
  - You can now create consumer groups in Kong Manager. This allows you to define any number of rate limiting tiers and apply them to subsets of consumers instead of managing each consumer individually. For more information, see [Create Consumer Groups in Kong Manager](/gateway/latest/kong-manager/consumer-groups/).
  - You can now add `key-auth-enc` credentials to a consumer.
  - OpenID Connect plugin: More authorization variables have been added to the **Authorization** tab.
  - The Kong Manager overview tab has been optimized for performance.
  - You can now configure vaults for managing secrets through Kong Manager.
    Use the new Vaults menu to set up and manage any vaults that Kong Gateway supports.
    See the [Vault Backends references](/gateway/latest/kong-enterprise/secrets-management/backends/)
    for descriptions of all the configuration options.
  - Added support for interfacing with dynamic plugin ordering.
  - Added the ability to view details about certificates.
  - Added tooltips to plugin UI with field descriptions.
  - Added support for persisting the page size of lists across pages and provided
  more options for page sizes.

#### Core
- Allow `kong.conf` SSL properties to be stored in vaults or environment
  variables. Allow such properties to be configured directly as content
  or base64 encoded content.
  [#9253](https://github.com/Kong/kong/pull/9253)
- Added support for full entity transformations in schemas.
  [#9431](https://github.com/Kong/kong/pull/9431)
- The schema `map` type field can now be marked as referenceable.
  [#9611](https://github.com/Kong/kong/pull/9611)
- Added support for [dynamically changing the log level](/gateway/latest/production/logging/update-log-level-dynamically/).
  [#9744](https://github.com/Kong/kong/pull/9744)
- Added support for the `keys` and `key-sets` entities. These are used for
managing asymmetric keys in various formats (JWK, PEM). For more information,
see [Key management](/gateway/latest/reference/key-management/).
[#9737](https://github.com/Kong/kong/pull/9737)

#### Hybrid Mode

- Data plane node IDs will now persist across restarts.
  [#9067](https://github.com/Kong/kong/pull/9067)
- Added HTTP CONNECT forward proxy support for hybrid mode connections. New configuration
  options `cluster_use_proxy`, `proxy_server` and `proxy_server_ssl_verify` are added.
  For more information, see [CP/DP Communication through a Forward Proxy](/gateway/latest/production/networking/cp-dp-proxy/).
  [#9758](https://github.com/Kong/kong/pull/9758)
  [#9773](https://github.com/Kong/kong/pull/9773)

#### Performance

- Increase the default value of `lua_regex_cache_max_entries`. A warning will be thrown
  when there are too many regex routes and `router_flavor` is `traditional`.
  [#9624](https://github.com/Kong/kong/pull/9624)
- Add batch queue into the Datadog and StatsD plugins to reduce timer usage.
  [#9521](https://github.com/Kong/kong/pull/9521)

#### OS support

- Kong Gateway now supports Amazon Linux 2022 with Enterprise packages.
- Kong Gateway now supports Ubuntu 22.04 with both open-source and Enterprise packages.

#### PDK

- Extend `kong.client.tls.request_client_certificate` to support setting
  the Distinguished Name (DN) list hints of the accepted CA certificates.
  [#9768](https://github.com/Kong/kong/pull/9768)

#### Plugins

**New plugins:**
- [**AppDynamics**](/hub/kong-inc/app-dynamics/) (`app-dynamics`)
  - Integrate Kong Gateway with the AppDynamics APM Platform.
- [**JWE Decrypt**](/hub/kong-inc/jwe-decrypt/) (`jwe-decrypt`)
  - Allows you to decrypt an inbound token (JWE) in a request.
- [**OAS Validation**](/hub/kong-inc/oas-validation/) (`oas-validation`)
  - Validate HTTP requests and responses based on an OpenAPI 3.0 or Swagger API Specification.
- [**SAML**](/hub/kong-inc/saml/) (`saml`)
  - Provides SAML v2.0 authentication and authorization between a service provider (Kong Gateway) and an identity provider (IdP).
- [**XML Threat Protection**](/hub/kong-inc/xml-threat-protection/) (`xml-threat-protection`)
  - This new plugin allows you to reduce the risk of XML attacks by checking the structure of XML payloads. This validates maximum complexity (depth of the tree), maximum size of elements and attributes.

**Updates to existing plugins:**

- [**ACME**](/hub/kong-inc/acme/) (`acme`)
  - Added support for Redis SSL, through configuration properties
  `config.storage_config.redis.ssl`, `config.storage_config.redis.ssl_verify`,
  and `config.storage_config.redis.ssl_server_name`.
  [#9626](https://github.com/Kong/kong/pull/9626)

- [**AWS Lambda**](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  - Added `requestContext` field into `awsgateway_compatible` input data
  [#9380](https://github.com/Kong/kong/pull/9380)

- [**Authentication plugins**](/hub/#authentication):
  - The `anonymous` field can now be configured as the username of the consumer.
  This field allows you to configure a string to use as an “anonymous” consumer if authentication fails.

- [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`)
  - Added referenceable attribute to the `headers` field
  that could be stored in vaults.
  [#9611](https://github.com/Kong/kong/pull/9611)

- [**Forward Proxy**](/hub/kong-inc/forward-proxy/) (`forward-proxy`)
  - `x_headers` field added. This field indicates how the plugin handles the headers
  `X-Real-IP`, `X-Forwarded-For`, `X-Forwarded-Proto`, `X-Forwarded-Host`, and `X-Forwarded-Port`.

    The field can take one of the following options:
    - `append`: append information from this hop in the chain to those headers. This is the default setting.
    - `transparent`: leave the headers unchanged, as if the the Kong Gateway was not a proxy.
    - `delete`: remove all the headers, as if the Kong Gateway was the originating client.

    Note that all options respect the trusted IP setting, and will ignore headers from the last hop in the chain if they are not from clients with trusted IPs.

- [**Mocking**](/hub/kong-inc/mocking/) (`mocking`)
  - Added the `included_status_codes` and `random_status_code` fields. These allow you to configure the HTTP status codes for the plugin.
  - The plugin now lets you auto-generate a random response based on the schema definition without defining examples.
  - You can now control behavior or obtain a specific response by sending
   behavioral headers: `X-Kong-Mocking-Delay`, `X-Kong-Mocking-Example-Id`,
   and `X-Kong-Mocking-Status-Code`.
  - This plugin now supports:
    - MIME types priority match
    - All HTTP codes
    - `$ref`

- [**mTLS Authentication**](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
  - Added the `config.send_ca_dn` configuration parameter to support sending CA
   DNs in the `CertificateRequest` message during SSL handshakes.
  - Added the `allow_partial_chain` configuration parameter to allow certificate verification with only an intermediate certificate.

- [**OPA**](/hub/kong-inc/opa/) (`OPA`)
  - Added the `include_uri_captures_in_opa_input` field. When this field is set to true, the [regex capture groups](/gateway/latest/reference/proxy/#using-regex-in-paths) captured on the Kong Gateway route's path field in the current request (if any) are included as input to OPA.

- [**Proxy Cache Advanced**](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cache-advanced`)
  - Added support for integrating with Redis clusters through the `config.redis.cluster_addresses` configuration property.

- [**Rate Limiting**](/hub/kong-inc/rate-limiting/) (`rate-limiting`)
  - The HTTP status code and response body for rate-limited
  requests can now be customized. Thanks, [@utix](https://github.com/utix)!
  [#8930](https://github.com/Kong/kong/pull/8930)

- [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  - Added support for deleting customer groups using the API.
  - Added `config.disable_penalty` to control whether to count `429` or not in
   sliding window mode.

- [**Request Transformer Advanced**](/hub/kong-inc/request-transformer-advanced/) (`request-transformer-advanced`)
  - Added support for navigating nested JSON objects and arrays when transforming a JSON payload.
  - The plugin now supports vault references.

- [**Request Validator**](/hub/kong-inc/request-validator/) (`request-validator`)
  - The plugin now supports the `charset` option for the
  `config.allowed_content_types` parameter.

- [**Response Rate Limiting**](/hub/kong-inc/response-ratelimiting/) (`response-ratelimiting`)
  - Added support for Redis SSL through configuration properties
  `redis_ssl` (can be set to `true` or `false`), `ssl_verify`, and `ssl_server_name`.
   Thanks, [@dominikkukacka](https://github.com/dominikkukacka)!
   [#8595](https://github.com/Kong/kong/pull/8595)

- [**Route Transformer Advanced**](/hub/kong-inc/route-transformer-advanced/) (`route-transformer-advanced`)
  - Added the `config.escape_path` configuration parameter, which lets you
  escape the transformed path.

- [**Session**](/hub/kong-inc/session/) (`session`)
  - Added new config `cookie_persistent`, which allows the browser to persist
  cookies even if the browser is closed. This defaults to `false` which means
  cookies are not persisted across browser restarts.
  Thanks [@tschaume](https://github.com/tschaume)
  for this contribution!
  [#8187](https://github.com/Kong/kong/pull/8187)

- [**Vault Authentication**](/hub/kong-inc/vault-auth/) (`vault-auth`)
  - Added support for KV Secrets Engine v2.

- [**Zipkin**](/hub/kong-inc/zipkin/) (`zipkin`)
  - Added the `response_header_for_traceid` field in Zipkin plugin.
  The plugin sets the corresponding header in the response
  if the field is specified with a string value.
  [#9173](https://github.com/Kong/kong/pull/9173)

- WebSocket service/route support was added for logging plugins:
  - http-log
  - file-log
  - udp-log
  - tcp-log
  - loggly
  - syslog
  - kafka-log

### Known limitations

- With Dynamic log levels, if you set log-level to `alert` you will still see `info` and `error` entries in the logs. 

### Fixes

#### Enterprise

- Fixed an issue where the RBAC token was not re-hashed after an update on the `user_token` field.
- Fixed an issue where `admin_gui_auth_conf` wouldn't accept
a JSON-formatted value, and was therefore unable to use vault references to
secrets.
- Fixed an issue where Admin GUI logs were not stored in the correct log file.
- Fixed an issue where Kong Gateway was unable to start in free Enterprise mode
while using vaults.
- Updated the response body for the `TRACE` method request.
- Targets with a weight of `0` are no longer included in health checks, and checking their status via the `upstreams/<upstream>/health` endpoint results in the status `HEALTHCHECK_OFF`.
Previously, the `upstreams/<upstream>/health` endpoint was incorrectly reporting targets with `weight=0` as `HEALTHY`, and the health check was reporting the same targets as `UNDEFINED`.
- Updated the Admin API response status code from `500` to `200` when the
  database is down.
- Fixed an issue when passing a license from the control plane to the data plane
  using the Admin API `/licenses` endpoint.
- In hybrid mode, fixed a license issue where entity validation would fail when
  the license entity was not processed first.
- Fixed a Websockets issue with redirects. Now, Kong Gateway redirects `ws`
requests to `wss` for `wss`-only routes for parity with HTTP/HTTPS.
- **Kong Manager**:
  - Added logging for all Kong Manager access logs.
  - Fixed an issue where the **New Workspace** button was occasionally unusable.
  - Fixed the name display of plugin configurations in Kong Manager.
  - Fixed an issue where some items were missing from the suggestion list
  when there were many items present.
  - Removed the deprecated Vitals Reports feature from Kong Manager.
  - Fixed an issue where admins with permissions to interact with scoped entities,
  such as routes and services, couldn't perform operations as expected.
  - Fixed an issue where admins with the `/admins` permission were forced to
  log out after signing in.
  - Fixed a performance issue where admins with a large number of workspace
  permissions caused Kong Manager to load slowly.

#### Core

- Fixed an issue where external plugins crashing with unhandled exceptions
  would cause high CPU utilization after the automatic restart.
  [#9384](https://github.com/Kong/kong/pull/9384)
- Added `use_srv_name` options to upstream for balancer.
  [#9430](https://github.com/Kong/kong/pull/9430)
- Fixed an issue in `header_filter` instrumentation where the span was not
  correctly created.
  [#9434](https://github.com/Kong/kong/pull/9434)
- Fixed an issue in router building in `traditional_compatible` mode.
  When the field contained an empty table, the generated expression was invalid.
  [#9451](https://github.com/Kong/kong/pull/9451)
- Fixed an issue in router rebuilding where when the `paths` field is invalid,
  the router's mutex is not released properly.
  [#9480](https://github.com/Kong/kong/pull/9480)
- Fixed an issue where `kong docker-start` would fail if `KONG_PREFIX` was set to
  a relative path.
  [#9337](https://github.com/Kong/kong/pull/9337)
- Fixed an issue with error-handling and process cleanup in `kong start`.
  [#9337](https://github.com/Kong/kong/pull/9337)
- Fixed issue with prefix path normalization.
  [#9760](https://github.com/Kong/kong/pull/9760)
- Increased the maximum request argument number of the Admin API from 100 to 1000.
  The Admin API now returns a `400` error if request parameters reach the
  limitation instead of truncating any parameters over the limit.
  [#9510](https://github.com/Kong/kong/pull/9510)
- Paging size parameter is now propagated to next page if specified
  in current request.
  [#9503](https://github.com/Kong/kong/pull/9503)

#### Hybrid Mode

- Fixed a race condition that could cause configuration push events to be dropped
  when the first data plane connection was established with a control plane
  worker.
  [#9616](https://github.com/Kong/kong/pull/9616)

#### CLI

- Fixed slow CLI performance due to pending timer jobs.
  [#9536](https://github.com/Kong/kong/pull/9536)

#### PDK

- Added support for `kong.request.get_uri_captures`
  (`kong.request.getUriCaptures`)
  [#9512](https://github.com/Kong/kong/pull/9512)
- Fixed parameter type of `kong.service.request.set_raw_body`
  (`kong.service.request.setRawBody`), return type of
  `kong.service.response.get_raw_body`(`kong.service.request.getRawBody`),
  and body parameter type of `kong.response.exit` to bytes. Note that the old
  version of the go PDK is incompatible after this change.
  [#9526](https://github.com/Kong/kong/pull/9526)

#### Plugins

* Added the missing `protocols` field to the following plugin schemas:
  * Azure Functions (`azure-functions`)
  * gRPC Gateway (`grpc-gateway`)
  * gRPC Web (`grpc-web`)
  * Serverless pre-function (`pre-function`)
  * Prometheus (`prometheus`)
  * Proxy Caching (`proxy-cache`)
  * Request Transformer (`request-transformer`)
  * Session (`session`)
  * Zipkin (`zipkin`)

  [#9525](https://github.com/Kong/kong/pull/9525)

- [**AWS Lambda**](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  - Fixed an issue that was causing inability to
  read environment variables in ECS environment.
  [#9460](https://github.com/Kong/kong/pull/9460)
  - Specifying a null value for the `isBase64Encoded` field in lambda output
  now results in a more obvious error log entry with a `502` code.
  [#9598](https://github.com/Kong/kong/pull/9598)

* [**Azure Functions**](/hub/kong-inc/azure-functions/) (`azure-functions`)
  * Fixed an issue where calls made by this plugin would fail in the following situations:
    * The plugin was associated with a route that had no service.
    * The route's associated service had a `path` value.
    [#9177](https://github.com/Kong/kong/pull/9177)

- [**HTTP Log**](/hub/kong-inc/http-log/) (`http-log`)
  - Fixed an issue where queue ID serialization
  did not include `queue_size` and `flush_timeout`.
  [#9789](https://github.com/Kong/kong/pull/9789)

- [**Mocking**](/hub/kong-inc/mocking/) (`mocking`)
  - Fixed an issue with `accept` headers not being split and not working with wildcards. The `;q=` (q-factor weighting) of `accept` headers is now supported.

- [**OPA**](/hub/kong-inc/opa/) (`opa`)
  - Removed redundant deprecated code from the plugin.

- [**OpenTelemetry**](/hub/kong-inc/opentelemetry/) (`opentelemetry`)
  - Fixed an issue that the default propagation header
    was not configured to `w3c` correctly.
    [#9457](https://github.com/Kong/kong/pull/9457)
  - Replaced the worker-level table cache with
    `BatchQueue` to avoid data race.
    [#9504](https://github.com/Kong/kong/pull/9504)
  - Fixed an issue that the `parent_id` was not set
    on the span when propagating w3c traceparent.
    [#9628](https://github.com/Kong/kong/pull/9628)

- [**Proxy Cache Advanced**](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cached-advanced`)
  - The plugin now catches the error when Kong Gateway connects to Redis SSL port `6379` with `config.ssl=false`.

- [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  - The plugin now ensures that shared dict TTL is higher than `config.sync_rate`, otherwise Kong Gateway would lose all request counters in shared dict.

- [**Request Transformer**](/hub/kong-inc/request-transformer/) (`request-transformer`)
  - Fixed a bug when header renaming would override
   the existing header and cause unpredictable results.
  [#9442](https://github.com/Kong/kong/pull/9442)

- [**Request Termination**](/hub/kong-inc/request-termination/) (`request-termination`)
  - The plugin no longer allows setting `status_code` to `null`.
  [#9400](https://github.com/Kong/kong/pull/9400)

- [**Response Transformer**](/hub/kong-inc/response-transformer/) (`response-transformer`)
  - Fixed the bug that the plugin would break when receiving an unexpected body.
  [#9463](https://github.com/Kong/kong/pull/9463)

- [**Zipkin**](/hub/kong-inc/zipkin/) (`zipkin`)
  - Fixed an issue where Zipkin plugin couldn't parse OT baggage headers
    due to an invalid OT baggage pattern.
    [#9280](https://github.com/Kong/kong/pull/9280)

### Breaking changes

#### Hybrid mode

- The legacy hybrid configuration protocol has been removed in favor of the wRPC protocol
introduced in 3.0.0.0. Rolling upgrades from 2.8.x.y to 3.1.0.0 are not supported.
Operators must upgrade to 3.0.x.x before they can perform a rolling upgrade to 3.1.0.0. For more information, see [Upgrade Kong Gateway 3.1.x](/gateway/3.1.x/upgrade/).
  [#9740](https://github.com/Kong/kong/pull/9740)

## 3.0.1.0
**Release Date** 2022/11/02

### Features

#### Plugins

* [Request Transformer Advanced](/hub/kong-inc/request-transformer-advanced/) (`request-transformer-advanced`)
  * Values stored in `key:value` pairs in this plugin's configuration are now referenceable, which means they can be stored as [secrets](/gateway/latest/kong-enterprise/secrets-management/) in a vault.

### Fixes

#### Enterprise

* **Kong Manager**:
  * Removed the endpoint `all_routes` from configurable RBAC endpoint permissions.
  This endpoint was erroneously appearing in the endpoints list, and didn't configure anything.
  * Fixed an issue that allowed unauthorized IDP users to log in to Kong Manager.
  These users had no access to any resources in Kong Manager, but were able to go beyond the login screen.
  * Fixed an issue where, in an environment with a valid Enterprise license, admins with no access to the `default` workspace would see a message prompting them to upgrade to Kong Enterprise.
  * Fixed pagination issues with Kong Manager tables.
  * Fixed broken `Learn more` links.
  * Fixed an issue with group to role mapping, where it didn't support group names with spaces.
  * Fixed the Cross Site Scripting (XSS) security vulnerability in the Kong Manager UI.
  * Fixed an RBAC issue where permissions applied to specific endpoints (for example, an individual service or route) were not reflected in the Kong Manager UI.
  * Removed New Relic from Kong Manager. Previously, `VUE_APP_NEW_RELIC_LICENSE_KEY` and
  `VUE_APP_SEGMENT_WRITE_KEY` were being exposed in Kong Manager with invalid values.
  * Removed the action dropdown menu on service and route pages for read-only users.
  * Fixed the **Edit Configuration** button for Dev Portal applications.
  * Fixed an RBAC issue where the roles page listed deleted roles.
  * Fixed an issue where the orphaned roles would remain after deleting a workspace and cause the **Teams** > **Admins** page to break.
  * Added the missing **Copy JSON** button for plugin configuration.
  * Fixed an issue where the **New Workspace** button on the global workspace dashboard wasn't clickable on the first page load.
  * Removed the ability to add multiple documents per service from the UI.
  Each service only supports one document, so the UI now reflects that.
  * The Upstream Timeout plugin now has an icon and is part of the Traffic Control category.
  * Fixed an error that would occur when attempting to delete ACL credentials
  from the consumer credentials list.
  This happened because the name of the plugin, `acl`, and its endpoint, `/acls`, don't match.
  * Fixed a caching issue with Dev Portal, where enabling or disabling the Dev Portal for a workspace wouldn't change the Kong Manager menu.

* Unpinned the version of `alpine` used in the `kong/kong-gateway` Docker image.
Previously, the version was pinned to 3.10, which was creating outdated `alpine` builds.

#### Core

* Fixed an issue with how Kong initializes `resty.events`. The code was
previously using `ngx.config.prefix()` to determine the listening socket
path to provide to the resty.events module. This caused breakage when
Nginx was started with a relative path prefix.
This meant that you couldn't start 3.0.x with the same default configuration as
2.8.x.

    Instead of using `ngx.config.prefix()`, Kong will now prefer the
    `kong.configuration.prefix` when available, as it is already normalized
    to an absolute path. If `kong.configuration.prefix` is not defined, the
    result of `ngx.config.prefix()` will be used after resolving it to an
    absolute path. [#9337](https://github.com/Kong/kong/pull/9337)

* Fixed an issue with secret management references for HashiCorp Vault. By default, Kong passes secrets to the Nginx using environment variables when using `kong start`. Nginx was being started directly without calling `kong start`, so the secrets were not available at initialization. [#9478](https://github.com/Kong/kong/pull/9478)

* Fixed the Amazon Linux RPM installation instructions.

## 3.0.0.0
**Release Date** 2022/09/09

{:.important}
> **Important**: Kong Gateway 3.0.0.0 is a major release and contains breaking changes.
Review the [breaking changes and deprecations](#breaking-changes-and-deprecations) and the [known limitations](#known-limitations) before attempting to [upgrade](/gateway/latest/upgrade/).

### Features

#### Enterprise

* Kong Gateway now supports [dynamic plugin ordering](/gateway/3.0.x/kong-enterprise/plugin-ordering/).
You can change a plugin's static priority by specifying the order in which plugins run.
This lets you run plugins such as `rate-limiting` before authentication plugins.

* Kong Gateway now offers a FIPS package. The package replaces the primary library, OpenSSL, with [BoringSSL](https://boringssl.googlesource.com/boringssl/), which at its core uses the FIPS 140-2 compliant BoringCrypto for cryptographic operations.

  To enable FIPS mode, set [`fips`](/gateway/3.0.x/reference/configuration/#fips) to `on`.
  FIPS mode is only supported in Ubuntu 20.04.

  {:.note}
  > **Note**: The Kong Gateway FIPS package is not currently compatible with SSL
  > connections to PostgreSQL.

* Kong Gateway now includes WebSocket validation functionality. Websockets are a type of persistent connection that works on top of HTTP.

  Previously, Kong Gateway 2.x supported limited WebSocket connections, where plugins only ran during the initial connection phase instead of for each frame.
  Now, Kong Gateway provides more control over WebSocket traffic by implementing plugins that target WebSocket frames.

  This release includes:
  * [Service](/gateway/3.0.x/admin-api/#service-object) and [route](/gateway/3.0.x/admin-api/#route-object) support for `ws` and `wss` protocols
  * Two new plugins: [WebSocket Size Limit](/hub/kong-inc/websocket-size-limit/) and [WebSocket Validator](/hub/kong-inc/websocket-validator/)
  * WebSocket plugin development capabilities (**Beta feature**)
    * PDK modules: [kong.websocket.client](/gateway/3.0.x/plugin-development/pdk/kong.websocket.client/) and [kong.websocket.upstream](/gateway/3.0.x/plugin-development/pdk/kong.websocket.upstream/)
    * [New plugin handlers](/gateway/3.0.x/plugin-development/custom-logic/#websocket-plugin-development)

  Learn how to develop WebSocket plugins with our [plugin development guide](/gateway/3.0.x/plugin-development/custom-logic/#websocket-plugin-development).

* In this release, Kong Manager ships a with a refactored design and improved user experience.

  Notable changes:
  * Reworked workspace dashboards, both for specific workspaces and at the multi-workspace level.
  * License metrics now appear at the top of overview pages.
  * Restructured the layout and navigation to make workspace selection a secondary concern.
  * Grayed out portal buttons when you don't have permissions.
  * Added license level to phone home metrics.
  * Added more tooltips.

* [Secrets management](/gateway/3.0.x/kong-enterprise/secrets-management/) is now generally available.
  * Added GCP integration support for the secrets manager. GCP is now available as a vault backend.
  * The `/vaults-beta` entity has been deprecated and replaced with the `/vaults` entity.
  [#8871](https://github.com/Kong/kong/pull/8871)
  [#9217](https://github.com/Kong/kong/pull/9217)

* Kong Gateway now provides slim and UBI images.
Slim images are docker containers built with a minimal set of installed packages to run Kong Gateway.
From 3.0 onward, Kong Docker images will only contain software required to run the Gateway.
This ensures that false positive vulnerabilities don't get flagged during security scanning.

    If you want to retain or add other dependencies, you can [build custom Kong Docker images](/gateway/3.0.x/install/docker/build-custom-images/).

* The base OS for our convenience docker tags (for example, `latest`, `3.0.0.0`, `3.0`) has switched from Alpine to Debian.

* Added key recovery for keyring encryption.
This exposes a new endpoint for the Admin API, [`/keyring/recover`](/gateway/3.0.x/admin-api/db-encryption/#recover-keyring-from-database), and requires [`keyring_recovery_public_key`](/gateway/3.0.x/reference/configuration/#keyring_recovery_public_key) to be set in `kong.conf`.

* You can now encrypt declarative configuration files on data planes in DB-less and hybrid modes using [AES-256-GCM](https://www.rfc-editor.org/rfc/rfc5288.html) or [chacha20-poly1305](https://www.rfc-editor.org/rfc/rfc7539.html) encryption algorithms.

    Set your desired encryption mode with the [`declarative_config_encryption_mode`](/gateway/3.0.x/reference/configuration/#declarative_config_encryption_mode) configuration parameter.

#### Core

* This release introduces a new router implementation: `atc-router`.
This router is written in Rust, a powerful routing language that can handle complex routing requirements.
The new router can be used in traditional-compatible mode, or use the new expression-based language.

  With the new router, we have:
  * Reduced router rebuild time when changing Kong’s configuration
  * Increased runtime performance when routing requests
  * Reduced P99 latency from 1.5s to 0.1s with 10,000 routes

  Learn more about the router:
  * [Configure routes using expressions](/gateway/3.0.x/key-concepts/routes/expressions/)
  * [Router Expressions Language reference](/gateway/3.0.x/reference/expressions-language/language-references/)
  * [#8938](https://github.com/Kong/kong/pull/8938)

* Implemented delayed response in stream mode.
  [#6878](https://github.com/Kong/kong/pull/6878)
* Added `cache_key` on target entity for uniqueness detection.
  [#8179](https://github.com/Kong/kong/pull/8179)
* Introduced the tracing API, which is compatible with OpenTelemetry API specs, and
  adds built-in instrumentations.

  The tracing API is intended to be used with a external exporter plugin.
  Built-in instrumentation types and sampling rate are configurable through the
  [`opentelemetry_tracing`](/gateway/3.0.x/reference/configuration/#opentelemetry_tracing) and [`opentelemetry_tracing_sampling_rate`](/gateway/3.0.x/reference/configuration/#opentelemetry_tracing_sampling_rate) options.
  [#8724](https://github.com/Kong/kong/pull/8724)
* Added `path`, `uri_capture`, and `query_arg` options to upstream `hash_on`
  for load balancing.
  [#8701](https://github.com/Kong/kong/pull/8701)
* Introduced Unix domain socket-based `lua-resty-events` to
  replace shared memory-based `lua-resty-worker-events`.
  [#8890](https://github.com/Kong/kong/pull/8890)
* Introduced the `table_name` field for entities.
  This field lets you specify a table name.
  Previously, the name was deduced by the entity `name` attribute.
  [#9182](https://github.com/Kong/kong/pull/9182)
* Added `headers` on active health checks for upstreams.
  [#8255](https://github.com/Kong/kong/pull/8255)
* Target entities using hostnames were resolved when they were not needed. Now
  when a target is removed or updated, the DNS record associated with it is
  removed from the list of hostnames to be resolved.
  [#8497](https://github.com/Kong/kong/pull/8497) [9265](https://github.com/Kong/kong/pull/9265)
* Improved error handling and debugging info in the DNS code.
  [#8902](https://github.com/Kong/kong/pull/8902)
* Kong Gateway will now attempt to recover from an unclean shutdown by detecting and
  removing dangling Unix sockets in the prefix directory.
  [#9254](https://github.com/Kong/kong/pull/9254)
* A new CLI command, `kong migrations status`, generates the migration status in a JSON file.
* Removed the warning for `AAAA` being experimental with `dns_order`.

#### Performance

- Kong Gateway does not register unnecessary event handlers on hybrid mode control plane
  nodes anymore. [#8452](https://github.com/Kong/kong/pull/8452).
- Use the new timer library to improve performance,
  except for the plugin server.
  [#8912](https://github.com/Kong/kong/pull/8912)
- Increased the use of caching for DNS queries by activating `additional_section` by default.
  [#8895](https://github.com/Kong/kong/pull/8895)
- `pdk.request.get_header` has been changed to a faster implementation.
  It doesn't fetch all headers every time it's called.
  [#8716](https://github.com/Kong/kong/pull/8716)
- Conditional rebuilding of the router, plugins iterator, and balancer on data planes.
  [#8519](https://github.com/Kong/kong/pull/8519),
  [#8671](https://github.com/Kong/kong/pull/8671)
- Made configuration loading code more cooperative by yielding.
  [#8888](https://github.com/Kong/kong/pull/8888)
- Use the LuaJIT encoder instead of JSON to serialize values faster in LMDB.
  [#8942](https://github.com/Kong/kong/pull/8942)
- Made inflating and JSON decoding non-concurrent, which avoids blocking and makes data plane reloads faster.
  [#8959](https://github.com/Kong/kong/pull/8959)
- Stopped duplication of some events.
  [#9082](https://github.com/Kong/kong/pull/9082)
- Improved performance of configuration hash calculation by using `string.buffer` and `tablepool`.
  [#9073](https://github.com/Kong/kong/pull/9073)
- Reduced cache usage in DB-less mode by not using the Kong cache for routes and services in LMDB.
  [#8972](https://github.com/Kong/kong/pull/8972)

#### Admin API

- Added a new `/timers` Admin API endpoint to get timer statistics and worker info.
  [#8912](https://github.com/Kong/kong/pull/8912)
  [#8999](https://github.com/Kong/kong/pull/8999)
- The `/` endpoint now includes plugin priority.
  [#8821](https://github.com/Kong/kong/pull/8821)

#### Hybrid Mode

- Added wRPC protocol support. Configuration synchronization now happens over wRPC.
  wRPC is an RPC protocol that encodes with ProtoBuf and transports
  with WebSocket.
  [#8357](https://github.com/Kong/kong/pull/8357)
  - To keep compatibility with earlier versions,
    added support for the control plane to fall back to the previous protocol to
    support older data planes.
    [#8834](https://github.com/Kong/kong/pull/8834)
  - Added support to negotiate services supported with wRPC protocol.
    We will support more services in the future.
    [#8926](https://github.com/Kong/kong/pull/8926)
- Declarative configuration exports now happen inside a transaction in PostgreSQL.
  [#8586](https://github.com/Kong/kong/pull/8586)

#### Plugins

* Starting with version 3.0, all bundled plugin versions are the same as the
Kong Gateway version.
[#8772](https://github.com/Kong/kong/pull/8772)

    [Plugin documentation](/hub/) now refers to the Kong Gateway version instead of
    the individual plugin version.

* **New plugins**:
  * [OpenTelemetry](/hub/kong-inc/opentelemetry/) (`opentelemetry`)

    Export tracing instrumentations to any OTLP/HTTP compatible backend.
    `opentelemetry_tracing` configuration must be enabled to collect
    the core tracing spans of Kong Gateway.
    [#8826](https://github.com/Kong/kong/pull/8826)

  * [TLS Handshake Modifier](/hub/kong-inc/tls-handshake-modifier/) (`tls-handshake-modifier`)

    Make certificates available to other plugins acting on the same request.  

  * [TLS Metadata Headers](/hub/kong-inc/tls-metadata-headers/) (`tls-metadata-headers`)

    Proxy TLS client certificate metadata to upstream services via HTTP headers.

  * [WebSocket Size Limit](/hub/kong-inc/websocket-size-limit/) (`websocket-size-limit`)

    Allows operators to specify a maximum size for incoming WebSocket messages.

  * [WebSocket Validator](/hub/kong-inc/websocket-validator/) (`websocket-validator`)

    Validate individual WebSocket messages against a user-specified schema
    before proxying them.

* [ACME](/hub/kong-inc/acme/) (`acme`)
  * Added the `allow_any_domain` field. It defaults to false and if set to true, the gateway will
  ignore the `domains` field.
  [#9047](https://github.com/Kong/kong/pull/9047)

* [AWS Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * Added support for cross-account invocation through
  the `aws_assume_role_arn` and
  `aws_role_session_name` configuration parameters.
  [#8900](https://github.com/Kong/kong/pull/8900)
  * The plugin now accepts string type `statusCode` as a valid return when
    working in proxy integration mode.
    [#8765](https://github.com/Kong/kong/pull/8765)
  * The plugin now separates AWS credential cache by the IAM role ARN.
    [#8907](https://github.com/Kong/kong/pull/8907)

* Collector (`collector`)
  * The deprecated Collector plugin has been removed.

* [DeGraphQL](/hub/kong-inc/degraphql/) (`degraphql`)
  * The GraphQL server path is now configurable with the `graphql_server_path` configuration parameter.

* [Kafka Upstream](/hub/kong-inc/kafka-upstream/) (`kafka-upstream`) and
[Kafka Log](/hub/kong-inc/kafka-log) (`kafka-log`)
  * Added support for the `SCRAM-SHA-512` authentication mechanism.

* [LDAP Authentication Advanced](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * This plugin now allows authorization based on group membership.
  The new configuration parameter, `groups_required`, is an array of string
  elements that indicates the groups that users must belong to for the request
  to be authorized.
  * The character `.` is now allowed in group attributes.
  * The character `:` is now allowed in the password field.

* [mTLS Authentication](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
  * Introduced certificate revocation list (CRL) and OCSP server support with the
  following parameters: `http_proxy_host`, `http_proxy_port`, `https_proxy_host`,
  and `https_proxy_port`.

* [OPA](/hub/kong-inc/opa/) (`opa`)
  * New configuration parameter `include_body_in_opa_input`: When enabled, include the raw body as a string in the OPA input at `input.request.http.body` and the body size at `input.request.http.body_size`.

  * New configuration parameter `include_parsed_json_body_in_opa_input`: When enabled and content-type is `application/json`, the parsed JSON will be added to the OPA input at `input.request.http.parsed_body`.

* [Prometheus](/hub/kong-inc/prometheus/) (`prometheus`)
  * High cardinality metrics are now disabled by default.
  * Decreased performance penalty to proxy traffic when collecting metrics.
  * The following metric names were adjusted to add units to standardize where possible:
    * `http_status` to `http_requests_total`.
    * `latency` to `kong_request_latency_ms` (HTTP), `kong_upstream_latency_ms`, `kong_kong_latency_ms`, and `session_duration_ms` (stream).

        Kong latency and upstream latency can operate at orders of different magnitudes. Separate these buckets to reduce memory overhead.

    * `kong_bandwidth` to `kong_bandwidth_bytes`.
    * `nginx_http_current_connections` and `nginx_stream_current_connections` were merged into to `nginx_hconnections_total` (or `nginx_current_connections`?)
    *  `request_count` and `consumer_status` were merged into http_requests_total.

        If the `per_consumer` config is set to `false`, the `consumer` label will be empty. If the `per_consumer` config is `true`, the `consumer` label will be filled.
  * Removed the following metric: `http_consumer_status`
  * New metrics:
    * `session_duration_ms`: monitoring stream connections.
    * `node_info`: Single gauge set to 1 that outputs the node's ID and Kong Gateway version.

  * `http_requests_total` has a new label, `source`. It can be set to `exit`, `error`, or `service`.
  * All memory metrics have a new label: `node_id`.
  * Updated the Grafana dashboard that comes packaged with Kong

* [StatsD](/hub/kong-inc/statsd/) (`statsd`)
  * **Newly open-sourced plugin capabilities**: All capabilities of the [StatsD Advanced](/hub/kong-inc/statsd-advanced/) plugin are now bundled in the [StatsD](https://docs.konghq.com/hub/kong-inc/statsd) plugin.
    [#9046](https://github.com/Kong/kong/pull/9046)

* [Zipkin](/hub/kong-inc/zipkin/) (`zipkin`)
  * Added support for including the HTTP path in the span name with the
  `http_span_name` configuration parameter.
  [#8150](https://github.com/Kong/kong/pull/8150)
  * Added support for socket connect and send/read timeouts
    through the `connect_timeout`, `send_timeout`,
    and `read_timeout` configuration parameters. This can help mitigate
    `ngx.timer` saturation when upstream collectors are unavailable or slow.
    [#8735](https://github.com/Kong/kong/pull/8735)

#### Configuration

* You can now configure `openresty_path` to allow
  developers and operators to specify the OpenResty installation to use when
  running Kong Gateway, instead of using the system-installed OpenResty.
  [#8412](https://github.com/Kong/kong/pull/8412)
* Added `ipv6only` to listen options `admin_listen`, `proxy_listen`, and `stream_listen`.
  [#9225](https://github.com/Kong/kong/pull/9225)
* Added `so_keepalive` to listen options `admin_listen`, `proxy_listen`, and `stream_listen`.
  [#9225](https://github.com/Kong/kong/pull/9225)
* Add LMDB DB-less configuration persistence and removed the JSON-based
  configuration cache for faster startup time.
  [#8670](https://github.com/Kong/kong/pull/8670)
* `nginx_events_worker_connections=auto` now has a lower bound of 1024.
  [#9276](https://github.com/Kong/kong/pull/9276)
* `nginx_main_worker_rlimit_nofile=auto` now has a lower bound of 1024.
  [#9276](https://github.com/Kong/kong/pull/9276)

#### PDK

* Added new PDK function: `kong.request.get_start_time()`.
  This function returns the request start time, in Unix epoch milliseconds.
  [#8688](https://github.com/Kong/kong/pull/8688)
* The function `kong.db.*.cache_key()` now falls back to `.id` if nothing from `cache_key` is found.
  [#8553](https://github.com/Kong/kong/pull/8553)

### Known limitations

* Kong Manager does not currently support the following features:
  * Secrets management
  * Plugin ordering
  * Expression-based routing

* Blue-green migration from 2.8.x (and below) to 3.0.x is not supported.
  * This is a known issue planned to be fixed in the next 2.8 release. If this is a requirement for upgrading,
  Kong operators should upgrade to that version before beginning a upgrade to 3.0.0.0.
  * See [Upgrade Kong Gateway](/gateway/latest/upgrade/) for more details.

* OpenTracing: There is an issue with `nginx-opentracing` in this release, so it is not
  recommended to upgrade yet if you are an OpenTracing user. This will be
  rectified in an upcoming patch/minor release.

* The Kong Gateway FIPS package is not currently compatible with SSL connections to PostgreSQL.

### Breaking changes and deprecations

#### Deployment

* Deprecated and stopped producing Amazon Linux 1 containers and packages.
Amazon Linux 1 [reached end-of-life on December 31, 2020](https://aws.amazon.com/blogs/aws/update-on-amazon-linux-ami-end-of-life).
  [Kong/docs.konghq.com #3966](https://github.com/Kong/docs.konghq.com/pull/3966)
* Deprecated and stopped producing Debian 8 (Jessie) containers and packages.
Debian 8 reached end-of-life in June 30, 2020.
  [Kong/kong-build-tools #448](https://github.com/Kong/kong-build-tools/pull/448)

#### Core

* As of 3.0, Kong Gateway's schema library's `process_auto_fields` function will not make deep
  copies of data that is passed to it when the given context is `select`. This was
  done to avoid excessive deep copying of tables where we believe the data most of
  the time comes from a driver like `pgmoon` or `lmdb`.

  If a custom plugin relied on `process_auto_fields` not overriding the given table, it must make its own copy
  before passing it to the function now.
  [#8796](https://github.com/Kong/kong/pull/8796)
* The deprecated `shorthands` field in Kong plugin or DAO schemas was removed in favor
  of the typed `shorthand_fields`. If your custom schemas still use `shorthands`, you
  need to update them to use `shorthand_fields`.
  [#8815](https://github.com/Kong/kong/pull/8815)
* The support for `legacy = true/false` attribute was removed from Kong schemas and
  Kong field schemas.
  [#8958](https://github.com/Kong/kong/pull/8958)
* The deprecated alias of `Kong.serve_admin_api` was removed. If your custom Nginx
  templates still use it, change it to `Kong.admin_content`.
  [#8815](https://github.com/Kong/kong/pull/8815)
* The Kong singletons module `kong.singletons` was removed in favor of the PDK `kong.*`.
  [#8874](https://github.com/Kong/kong/pull/8874)
* The data plane configuration cache was removed.
  Configuration persistence is now done automatically with LMDB.
  [#8704](https://github.com/Kong/kong/pull/8704)
* `ngx.ctx.balancer_address` was removed in favor of `ngx.ctx.balancer_data`.
  [#9043](https://github.com/Kong/kong/pull/9043)
* The normalization rules for `route.path` have changed. Kong Gateway now stores the unnormalized path, but
  the regex path always pattern-matches with the normalized URI. Previously, Kong Gateway replaced percent-encoding
  in the regex path pattern to ensure different forms of URI matches.
  That is no longer supported. Except for the reserved characters defined in
  [rfc3986](https://datatracker.ietf.org/doc/html/rfc3986#section-2.2),
  write all other characters without percent-encoding.
  [#9024](https://github.com/Kong/kong/pull/9024)
* Kong Gateway no longer uses a heuristic to guess whether a `route.path` is a regex pattern. From 3.0 onward,
  all regex paths must start with the `"~"` prefix, and all paths that don't start with `"~"` will be considered plain text.
  The migration process should automatically convert the regex paths when upgrading from 2.x to 3.0.
  [#9027](https://github.com/Kong/kong/pull/9027)
* Bumped the version number (`_format_version`) of declarative configuration to `3.0` for changes on `route.path`.
  Declarative configurations using older versions are upgraded to `3.0` during migrations.

    {:.important}
    > **Do not sync (`deck sync`) declarative configuration files from 2.8 or earlier to 3.0.**
    Old configuration files will overwrite the configuration and create compatibility issues.
    To grab the updated configuration, `deck dump` the 3.0 file after migrations are completed.

  [#9078](https://github.com/Kong/kong/pull/9078)
* Tags may now contain space characters.
  [#9143](https://github.com/Kong/kong/pull/9143)
* Support for the `nginx-opentracing` module is deprecated as of `3.0` and will
  be removed from Kong in `4.0` (see the [Known Limitations](#known-limitations) section for additional
  information).
* We removed regex [look-around](https://www.regular-expressions.info/lookaround.html) and [backreferences](https://www.regular-expressions.info/backref.html) support in the the atc-router. These are rarely used features and removing support for them improves the speed of our regex matching. If your current regexes use look-around or backreferences you will receive an error when attempting to start Kong, showing exactly what regex is incompatible. Users can either switch to the `traditional` router flavor or change the regex to remove look-around / backreferences.

#### Admin API

* The Admin API endpoint `/vitals/reports` has been removed.
* `POST` requests on `/targets` endpoints are no longer able to update
  existing entities. They are only able to create new ones.
  [#8596](https://github.com/Kong/kong/pull/8596),
  [#8798](https://github.com/Kong/kong/pull/8798). If you have scripts that use
  `POST` requests to modify `/targets`, change them to `PUT`
  requests to the appropriate endpoints before updating to {{site.base_gateway}} 3.0.
* Insert and update operations on duplicated targets return a `409` error.
  [#8179](https://github.com/Kong/kong/pull/8179),
  [#8768](https://github.com/Kong/kong/pull/8768)
* The list of reported plugins available on the server now returns a table of
  metadata per plugin instead of a boolean `true`.
  [#8810](https://github.com/Kong/kong/pull/8810)

#### PDK

* The `kong.request.get_path()` PDK function now performs path normalization
  on the string that is returned to the caller. The raw, non-normalized version
  of the request path can be fetched via `kong.request.get_raw_path()`.
  [#8823](https://github.com/Kong/kong/pull/8823)
* `pdk.response.set_header()`, `pdk.response.set_headers()`, `pdk.response.exit()` now ignore and emit warnings for manually set `Transfer-Encoding` headers.
  [#8698](https://github.com/Kong/kong/pull/8698)
* The PDK is no longer versioned.
  [#8585](https://github.com/Kong/kong/pull/8585)
* The JavaScript PDK now returns `Uint8Array` for `kong.request.getRawBody`,
  `kong.response.getRawBody`, and `kong.service.response.getRawBody`.
  The Python PDK returns `bytes` for `kong.request.get_raw_body`,
  `kong.response.get_raw_body`, and `kong.service.response.get_raw_body`.
  Previously, these functions returned strings.
  [#8623](https://github.com/Kong/kong/pull/8623)
* The `go_pluginserver_exe` and `go_plugins_dir` directives are no longer supported.
 [#8552](https://github.com/Kong/kong/pull/8552). If you are using
 [Go plugin server](https://github.com/Kong/go-pluginserver), migrate your plugins to use the
 [Go PDK](https://github.com/Kong/go-pdk) before upgrading.

#### Plugins

* DAOs in plugins must be listed in an array, so that their loading order is explicit. Loading them in a
  hash-like table is no longer supported.
  [#8988](https://github.com/Kong/kong/pull/8988)
* Plugins MUST now have a valid `PRIORITY` (integer) and `VERSION` ("x.y.z" format)
  field in their `handler.lua` file, otherwise the plugin will fail to load.
  [#8836](https://github.com/Kong/kong/pull/8836)
* The old `kong.plugins.log-serializers.basic` library was removed in favor of the PDK
  function `kong.log.serialize`. Upgrade your plugins to use the PDK.
  [#8815](https://github.com/Kong/kong/pull/8815)
* The support for deprecated legacy plugin schemas was removed. If your custom plugins
  still use the old (`0.x era`) schemas, you are now forced to upgrade them.
  [#8815](https://github.com/Kong/kong/pull/8815)
* Updated the priority for some plugins.

    This is important for those who run custom plugins as it may affect the sequence in which your plugins are executed.
    This does not change the order of execution for plugins in a standard Kong Gateway installation.

    Old and new plugin priority values:
    - `acme` changed from `1007` to `1705`
    - `basic-auth` changed from `1001` to `1100`
    - `canary` changed from `13` to `20`
    - `degraphql` changed from `1005` to `1500`
    - `graphql-proxy-cache-advanced` changed from `100` to `99`
    - `hmac-auth` changed from `1000` to `1030`
    - `jwt` changed from `1005` to `1450`
    - `jwt-signer` changed from `999` to `1020`.
    - `key-auth` changed from `1003` to `1250`
    - `key-auth-advanced` changed from `1003` to `1250`
    - `ldap-auth` changed from `1002` to `1200`
    - `ldap-auth-advanced` changed from `1002` to `1200`
    - `mtls-auth` changed from `1006` to `1600`
    - `oauth2` changed from `1004` to `1400`
    - `openid-connect` changed from `1000` to `1050`
    - `rate-limiting` changed from `901` to `910`
    - `rate-limiting-advanced` changed from `902` to `910`
    - `route-by-header` changed from `2000` to `850`
    - `route-transformer-advanced` changed from `800` to `780`
    - `pre-function` changed from `+inf` to `1000000`
    - `vault-auth` changed from `1003` to `1350`

* Kong plugins no longer support `CREDENTIAL_USERNAME` (`X-Credential-Username`).
  Use the constant `CREDENTIAL_IDENTIFIER` (`X-Credential-Identifier`) when
  setting the upstream headers for a credential.
  [#8815](https://github.com/Kong/kong/pull/8815)

* [ACL](/hub/kong-inc/acl/) (`acl`), [Bot Detection](/hub/kong-inc/bot-detection/) (`bot-detection`), and [IP Restriction](/hub/kong-inc/ip-restriction/) (`ip-restriction`)
  * Removed the deprecated `blacklist` and `whitelist` configuration parameters.
   [#8560](https://github.com/Kong/kong/pull/8560)

* [ACME](/hub/kong-inc/acme/) (`acme`)
  * The default value of the `auth_method` configuration parameter is now `token`.

* [AWS Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * The AWS region is now required. You can set it through the plugin configuration with the  `aws_region` field parameter, or with environment variables.
  * The plugin now allows `host` and `aws_region` fields to be set at the same time, and always applies the SigV4 signature.
  [#8082](https://github.com/Kong/kong/pull/8082)

* [HTTP Log](/hub/kong-inc/http-log/) (`http-log`)
  * The `headers` field now only takes a single string per header name,
  where it previously took an array of values.
  [#6992](https://github.com/Kong/kong/pull/6992)

* [JWT](/hub/kong-inc/jwt/) (`jwt`)
  * The authenticated JWT is no longer put into the nginx
    context (`ngx.ctx.authenticated_jwt_token`). Custom plugins which depend on that
    value being set under that name must be updated to use Kong's shared context
    instead (`kong.ctx.shared.authenticated_jwt_token`) before upgrading to 3.0.

* [Prometheus](/hub/kong-inc/prometheus/) (`prometheus`)
  * High cardinality metrics are now disabled by default.
  * Decreased performance penalty to proxy traffic when collecting metrics.
  * The following metric names were adjusted to add units to standardize where possible:
    * `http_status` to `http_requests_total`.
    * `latency` to `kong_request_latency_ms` (HTTP), `kong_upstream_latency_ms`, `kong_kong_latency_ms`, and `session_duration_ms` (stream).

        Kong latency and upstream latency can operate at orders of different magnitudes. Separate these buckets to reduce memory overhead.

    * `kong_bandwidth` to `kong_bandwidth_bytes`.
    * `nginx_http_current_connections` and `nginx_stream_current_connections` were merged into to `nginx_connections_total`.
    *  `request_count` and `consumer_status` were merged into `http_requests_total`.

        If the `per_consumer` config is set to `false`, the `consumer` label will be empty. If the `per_consumer` config is `true`, the `consumer` label will be filled.
  * Removed the following metric: `http_consumer_status`
  * New metrics:
    * `session_duration_ms`: monitoring stream connections.
    * `node_info`: Single gauge set to 1 that outputs the node's ID and Kong Gateway version.

  * `http_requests_total` has a new label, `source`. It can be set to `exit`, `error`, or `service`.
  * All memory metrics have a new label: `node_id`.
  * Updated the Grafana dashboard that comes packaged with Kong
[#8712](https://github.com/Kong/kong/pull/8712)
  * The plugin doesn't export status codes, latencies, bandwidth and upstream
  health check metrics by default. They can still be turned on manually by setting `status_code_metrics`,
  `lantency_metrics`, `bandwidth_metrics` and `upstream_health_metrics` respectively.
  [#9028](https://github.com/Kong/kong/pull/9028)

* **[Pre-function](/hub/kong-inc/pre-function/) (`pre-function`) and [Post-function](/hub/kong-inc/post-function/)** (`post-function`)
  * Removed the deprecated `config.functions` configuration parameter from the Serverless Functions plugins' schemas.
    Use the `config.access` phase instead.
  [#8559](https://github.com/Kong/kong/pull/8559)

* [StatsD](/hub/kong-inc/statsd/) (`statsd`):
  * Any metric name that is related to a service now has a `service.` prefix: `kong.service.<service_identifier>.request.count`.
    * The metric `kong.<service_identifier>.request.status.<status>` has been renamed to `kong.service.<service_identifier>.status.<status>`.
    * The metric `kong.<service_identifier>.user.<consumer_identifier>.request.status.<status>` has been renamed to `kong.service.<service_identifier>.user.<consumer_identifier>.status.<status>`.
  * The metric `*.status.<status>.total` from metrics `status_count` and `status_count_per_user` has been removed.

  [#9046](https://github.com/Kong/kong/pull/9046)

* [Rate Limiting](/hub/kong-inc/rate-limiting/) (`rate-limiting`), [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`), and [Response Rate Limiting](/hub/kong-inc/response-ratelimiting/) (`response-ratelimiting`):
  * The default policy is now local for all deployment modes.
  [#9344](https://github.com/Kong/kong/pull/9344)

* **Deprecated**: [StatsD Advanced](/hub/kong-inc/statsd-advanced/) (`statsd-advanced`):
  * The StatsD Advanced plugin has been deprecated and will be removed in 4.0.
  All capabilities are now available in the [StatsD](/hub/kong-inc/statsd/) plugin.

* [Proxy Cache](/hub/kong-inc/proxy-cache/) (`proxy-cache`), [Proxy Cache Advanced](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cache-advanced`), and [GraphQL Proxy Cache Advanced](/hub/kong-inc/graphql-proxy-cache-advanced/) (`graphql-proxy-cache-advanced`)
  * These plugins don't store response data in `ngx.ctx.proxy_cache_hit` anymore.
    Logging plugins that need the response data must now read it from `kong.ctx.shared.proxy_cache_hit`.
    [#8607](https://github.com/Kong/kong/pull/8607)



#### Configuration

* The Kong constant `CREDENTIAL_USERNAME` with the value of `X-Credential-Username` has been
  removed.
  [#8815](https://github.com/Kong/kong/pull/8815)
* The default value of `lua_ssl_trusted_certificate` has changed to `system`
  [#8602](https://github.com/Kong/kong/pull/8602) to automatically load the trusted CA list from the system CA store.
* It is no longer possible to use a `.lua` format to import a declarative configuration file from the `kong`
  CLI tool. Only JSON and YAML formats are supported. If your update procedure with Kong Gateway involves
  executing `kong config db_import config.lua`, convert the `config.lua` file into a `config.json` or `config.yml` file
  before upgrading.
  [#8898](https://github.com/Kong/kong/pull/8898)
* The data plane config cache mechanism and its related configuration options
(`data_plane_config_cache_mode` and `data_plane_config_cache_path`) have been removed in favor of LMDB.

#### Migrations

* The migration helper library (mostly used for Cassandra migrations) is no longer supplied with Kong Gateway.
  [#8781](https://github.com/Kong/kong/pull/8781)
* PostgreSQL migrations can now have an `up_f` part like Cassandra
  migrations, designating a function to call. The `up_f` part is
  invoked after the `up` part has been executed against the database
  for both PostgreSQL and Cassandra.

### Fixes

#### Enterprise

* Fixed an issue with keyring encryption, where the control plane would crash if any errors occurred
during the initialization of the [keyring module](/gateway/latest/kong-enterprise/db-encryption/).

* Fixed an issue where the keyring module was not decrypting keys after a soft reload.

* Fixed pagination issues:
  * Fixed a consumer pagination issue.
  * Fixed an issue that appeared when loading the second page while iterating over a foreign key field using the DAO.
    [#9255](https://github.com/Kong/kong/pull/9255)

* Fixed service route update failures that occurred after restarting a control plane.

* **Vitals**:
  * Disabled `phone_home` for `anonymous_reports` on the data plane.
  * The Kong Gateway version information is now sent in the telemetry request query parameter.

* **Kong Manager**:
  * Fixed the workspace dashboard's loading state.
    Previously, a dashboard with no request data and an existing service would still prompt users to add a service.
  * Fixed an issue where Kong Manager allowed selection of metrics not supported by the Datadog plugin.
  * Fixed the values accepted for upstream configuration in Kong Manager.
  Previously, fields that were supposed to accept decimals would only accept whole numbers.
  * Fixed an issue where you couldn't save or update `pre-function` plugin configuration when the updated value contained a comma (`,`).
  * The service name field on the Service Contracts page now correctly shows the service display name.
  Previously, it showed the service ID.
  * Fixed an issue where, after updating the CA certificate, the page wouldn't return to the certificate view.
  * Fixed an issue where the port was missing from the service URL on the service overview page.
  * Fixed an issue where switching between workspace dashboard pages would not update the Dev Portal URL.
  * Fixed issues with plugins:
    * The Exit Transformer plugin can now load Lua functions added through Kong Manager.
    * The CORS plugin now treats regexes properly for the `config.origins` field.
    * The Datadog plugin now accepts an array for the `tags` field. Previously, it was incorrectly expecting a string.

  * Fixed an `HTTP 500` error that occurred when sorting routes by the **Hosts** column, then clicking **Next** on a paginated listing.
  * Fixed an issue that prevented developer role assignments from displaying in Kong Manager.
    When viewing a role under the Permissions tab in the Dev Portal section, the list of developers wouldn't update when a new developer was added.
    Kong Manager was constructing the wrong URL when retrieving Dev Portal assignees.
  * Fixed an issue where admins couldn't switch workspaces if they didn't have an roles in the default workspace.
  * Fixed a display issue with Dev Portal settings in Kong Manager.
  * Improved the error that appeared when trying to view admin roles without permissions for the resource.
    Instead of displaying `404 workspace not found`, the error now informs the user that they don't have access to view roles.

* Fixed an issue where the data plane would reload and lose its license after an Nginx reload.
* Fixed issues in dependencies:

  * `kong-gql`: Fixed variable definitions to handle non-nullable/list-type variables correctly.
  * `lua-resty-openssl-aux-module`: Fixed an issue with getting `SSL_CTX` from a request.

#### Core

* The schema validator now correctly converts `null` from declarative
  configurations to `nil`.
  [#8483](https://github.com/Kong/kong/pull/8483)
* Kong now reschedules router and plugin iterator timers only after finishing the previous
  execution, avoiding unnecessary concurrent executions.
  [#8567](https://github.com/Kong/kong/pull/8567)
* External plugins now handle returned JSON with null member correctly.
  [#8611](https://github.com/Kong/kong/pull/8611)
* Fixed an issue where the address of an environment variable could change but the code didn't
  check that it was fixed after init.
  [#8581](https://github.com/Kong/kong/pull/8581)
* Fixed an issue where the Go plugin server instance would not be updated after
  a restart.
  [#8547](https://github.com/Kong/kong/pull/8547)
* Fixed an issue on trying to reschedule the DNS resolving timer when Kong was
  being reloaded.
  [#8702](https://github.com/Kong/kong/pull/8702)
* The private stream API has been rewritten to allow for larger message payloads.
  [#8641](https://github.com/Kong/kong/pull/8641)
* Fixed an issue that the client certificate sent to the upstream was not updated when using the `PATCH` method.
  [#8934](https://github.com/Kong/kong/pull/8934)
* Fixed an issue where the control plane and wRPC module interaction would cause Kong to crash when calling `export_deflated_reconfigure_payload` without a `pcall`.
  [#8668](https://github.com/Kong/kong/pull/8668)
* Moved all `.proto` files to `/usr/local/kong/include` and ordered by priority.
  [#8914](https://github.com/Kong/kong/pull/8914)
* Fixed an issue that caused unexpected 404 errors when creating or updating configs with invalid options.
  [#8831](https://github.com/Kong/kong/pull/8831)
* Fixed an issue that caused crashes when calling some PDK APIs.
  [#8604](https://github.com/Kong/kong/pull/8604)
* Fixed an issue that caused crashes when go PDK calls returned arrays.
  [#8891](https://github.com/Kong/kong/pull/8891)
* Plugin servers now shutdown gracefully when Kong exits.
  [#8923](https://github.com/Kong/kong/pull/8923)
* CLI now prompts with `[y/n]` instead of `[Y/n]`, as it does not take `y` as default.
  [#9114](https://github.com/Kong/kong/pull/9114)
* Improved the error message that appears when Kong can't connect to Cassandra on init.
  [#8847](https://github.com/Kong/kong/pull/8847)
* Fixed an issue where the Vault subschema wasn't loaded in the `off` strategy.
  [#9174](https://github.com/Kong/kong/pull/9174)
* The schema now runs select transformations before `process_auto_fields`.
  [#9049](https://github.com/Kong/kong/pull/9049)
* Fixed an issue where {{site.base_gateway}} would use too many timers to keep track of upstreams when `worker_consistency = eventual`.
  [#8694](https://github.com/Kong/kong/pull/8694),
  [#8858](https://github.com/Kong/kong/pull/8858)
* Fixed an issue where it wasn't possible to set target status using only a hostname for targets set only by their hostname.
  [#8797](https://github.com/Kong/kong/pull/8797)
* Fixed an issue where cache entries of some entities were not being properly invalidated after a cascade delete.
  [#9261](https://github.com/Kong/kong/pull/9261)
* Running `kong start` when {{site.base_gateway}} is already running no longer overwrites
  the existing `.kong_env` file [#9254](https://github.com/Kong/kong/pull/9254)


#### Admin API

* The Admin API now supports `HTTP/2` when requesting `/status`.
  [#8690](https://github.com/Kong/kong/pull/8690)
* Fixed an issue where the Admin API didn't display `Allow` and `Access-Control-Allow-Methods` headers with `OPTIONS` requests.

#### Plugins

* Plugins with colliding priorities have now deterministic sorting based on their name.
  [#8957](https://github.com/Kong/kong/pull/8957)

* External plugins: Kong Gateway now handles logging better when a plugin instance loses the `instances_id` in an event handler.
  [#8652](https://github.com/Kong/kong/pull/8652)

* [ACME](/hub/kong-inc/acme/) (`acme`)
  * The default value of the `auth_method` configuration parameter is now set to `token`.
  [#8565](https://github.com/Kong/kong/pull/8565)
  * Added a cache for `domains_matcher`.
  [#9048](https://github.com/Kong/kong/pull/9048)

* [HTTP Log](/hub/kong-inc/http-log/) (`http-log`)
  * Log output is now restricted to the workspace the plugin is running in. Previously,
  the plugin could log requests from outside of its workspace.

* [AWS Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * Removed the deprecated `proxy_scheme` field from the plugin's schema.
    [#8566](https://github.com/Kong/kong/pull/8566)
  * Changed the path from `request_uri` to `upstream_uri` to fix an issue where the URI could not follow a rule defined by the Request Transformer plugin.
    [#9058](https://github.com/Kong/kong/pull/9058) [#9129](https://github.com/Kong/kong/pull/9129)

* [Forward Proxy](/hub/kong-inc/forward-proxy/) (`forward-proxy`)
  * Fixed a proxy authentication error caused by incorrect base64 encoding.
  * Use lowercase when overwriting the Nginx request host header.
  * The plugin now allows multi-value response headers.

* [gRPC Gateway](/hub/kong-inc/grpc-gateway/) (`grpc-gateway`)
  * Fixed the handling of boolean fields from URI arguments.
    [#9180](https://github.com/Kong/kong/pull/9180)

* [HMAC Authentication](/hub/kong-inc/hmac-auth/) (`hmac-auth`)
  * Removed deprecated signature format using `ngx.var.uri`.
    [#8558](https://github.com/Kong/kong/pull/8558)

* [LDAP Authentication](/hub/kong-inc/ldap-auth/) (`ldap-auth`)
  * Refactored ASN.1 parser using OpenSSL API through FFI.
    [#8663](https://github.com/Kong/kong/pull/8663)

* [LDAP Authentication Advanced](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * Fixed an issue where Kong Manager LDAP authentication failed when `base_dn` was the domain root.

* [Mocking](/hub/kong-inc/mocking/) (`mocking`)
  * Fixed an issue where `204` responses were not handled correctly and you would see the following error:
`"No examples exist in API specification for this resource"`.
  * `204` response specs now support empty content elements.

* [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
openid-connect
  * Fixed an issue with `kong_oauth2` consumer mapping.

* [Rate Limiting](/hub/kong-inc/rate-limiting/) (`rate-limiting`) and [Response Rate Limiting](/hub/kong-inc/response-ratelimiting/) (`response-ratelimiting`)
  * Fixed a PostgreSQL deadlock issue that occurred when the `cluster` policy was used with two or more metrics (for example, `second` and `day`.)
    [#8968](https://github.com/Kong/kong/pull/8968)

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed error handling when calling `get_window` and added more buffer on the window reserve.
  * Fixed error handling for plugin strategy configuration when in hybrid or DB-less mode and strategy is set to `cluster`.

* **[Pre-function](/hub/kong-inc/pre-function/) (`pre-function`) and [Post-function](/hub/kong-inc/post-function/)** (`post-function`)
  * Fixed a problem that could cause a crash.
  [#9269](https://github.com/Kong/kong/pull/9269)

* [Syslog](/hub/kong-inc/syslog/) (`syslog`)
  * The `conf.facility` default value is now set to `user`.
    [#8564](https://github.com/Kong/kong/pull/8564)

* [Zipkin](/hub/kong-inc/zipkin/) (`zipkin`)
  * Fixed the balancer spans' duration to include the connection time
  from Nginx to the upstream.
    [#8848](https://github.com/Kong/kong/pull/8848)
  * Corrected the calculation of the header filter start time.
    [#9230](https://github.com/Kong/kong/pull/9230)
  * Made the plugin compatible with the latest [Jaeger header spec](https://www.jaegertracing.io/docs/1.29/client-libraries/#tracespan-identity), which makes `parent_id` optional.
  [#8352](https://github.com/Kong/kong/pull/8352)

#### Clustering

* The cluster listener now uses the value of `admin_error_log` for its log file
  instead of `proxy_error_log`.
  [#8583](https://github.com/Kong/kong/pull/8583)
* Fixed a typo in some business logic that checks the Kong role before setting a
  value in cache at startup. [#9060](https://github.com/Kong/kong/pull/9060)
* Fixed an issue in hybrid mode where, if a service was set to `enabled: false` and that service had a route with an enabled plugin, any new data planes would receive empty configuration.
  [#8816](https://github.com/Kong/kong/pull/8816)
* Localized `config_version` to avoid a race condition from the new yielding config loading code.
  [#8188](https://github.com/Kong/kong/pull/8818)

#### PDK

* `kong.response.get_source()` now returns an error instead of an exit when plugin throws a
  runtime exception in the access phase.
  [#8599](https://github.com/Kong/kong/pull/8599)
* `kong.tools.uri.normalize()` now escapes reserved and unreserved characters more accurately.
  [#8140](https://github.com/Kong/kong/pull/8140)


* RFC3987 validation on route paths was removed, allowing operators to create a route with an invalid path
  URI like `/something|` which can not match any incoming request. This validation will be added back in a future release.

### Dependencies

* Bumped `openresty` from 1.19.9.1 to 1.21.4.1
  [#8850](https://github.com/Kong/kong/pull/8850)
* Bumped `pgmoon` from 1.13.0 to 1.15.0
  [#8908](https://github.com/Kong/kong/pull/8908)
  [#8429](https://github.com/Kong/kong/pull/8429)
* Bumped `openssl` from 1.1.1n to 1.1.1q
  [#9074](https://github.com/Kong/kong/pull/9074)
  [#8544](https://github.com/Kong/kong/pull/8544)
  [#8752](https://github.com/Kong/kong/pull/8752)
  [#8994](https://github.com/Kong/kong/pull/8994)
* Bumped `resty.openssl` from 0.8.8 to 0.8.10
  [#8592](https://github.com/Kong/kong/pull/8592)
  [#8753](https://github.com/Kong/kong/pull/8753)
  [#9023](https://github.com/Kong/kong/pull/9023)
* Bumped `inspect` from 3.1.2 to 3.1.3
  [#8589](https://github.com/Kong/kong/pull/8589)
* Bumped `resty.acme` from 0.7.2 to 0.8.1
  [#8680](https://github.com/Kong/kong/pull/8680)
  [#9165](https://github.com/Kong/kong/pull/9165)
* Bumped `luarocks` from 3.8.0 to 3.9.1
  [#8700](https://github.com/Kong/kong/pull/8700)
  [#9204](https://github.com/Kong/kong/pull/9204)
* Bumped `luasec` from 1.0.2 to 1.2.0
  [#8754](https://github.com/Kong/kong/pull/8754)
  [#8754](https://github.com/Kong/kong/pull/9205)
* Bumped `resty.healthcheck` from 1.5.0 to 1.6.1
  [#8755](https://github.com/Kong/kong/pull/8755)
  [#9018](https://github.com/Kong/kong/pull/9018)
  [#9150](https://github.com/Kong/kong/pull/9150)
* Bumped `resty.cassandra` from 1.5.1 to 1.5.2
  [#8845](https://github.com/Kong/kong/pull/8845)
* Bumped `penlight` from 1.12.0 to 1.13.1
  [#9206](https://github.com/Kong/kong/pull/9206)
* Bumped `lua-resty-mlcache` from 2.5.0 to 2.6.0
  [#9287](https://github.com/Kong/kong/pull/9287)
* Bumped `lodash` for Dev Portal from 4.17.11 to 4.17.21
* Bumped `lodash` for Kong Manager from 4.17.15 to 4.17.21

## 2.8.4.14
**Release Date** 2025/04/14

### Features

#### CLI

* Added a `--lts_34_compatibility` option to the `check` command to perform a configuration compatibility check for upgrading to version 3.4.x.x.

### Fixes

#### Core

* Requests that contain both the Content-Length and Transfer-Encoding headers are now rejected for improved security.

### Dependencies

* Pinned LPEG to 1.1.0 to keep the version consistent across all active branches. 
This is not a version bump, version 1.1.0 is already in use.

## 2.8.4.13
**Release Date** 2024/09/20

### Breaking Changes

#### Dependencies

* Fixed RPM relocation by setting the default prefix to `/`, and added a symbolic
  link for `resty` to handle missing `/usr/local/bin` in `PATH`.

### Fixes
#### Core

* Fixed an issue where `luarocks-admin` was not available in `/usr/local/bin`.

#### Plugins

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed an issue where the sync timer could stop working due to a race condition.

## 2.8.4.12
**Release Date** 2024/07/29

### Breaking changes and deprecations

* Debian 10 and RHEL 7 reached their End of Life (EOL) dates on June 30, 2024. 
As of this patch, Kong is not building Kong Gateway 2.8.x installation packages or Docker images for these operating systems.
Kong is no longer providing official support for any Kong version running on these systems.

### Fixes

* AWS2 x86_64 is now cross-built.
* Cleaned up build code for deprecated packages.
* Made the RPM package relocatable.

## 2.8.4.11
**Release Date** 2024/06/22

### Fixes

* Fixed an issue where the DNS client was incorrectly using the content of the `ADDITIONAL SECTION` in DNS responses.

## 2.8.4.10
**Release Date** 2024/06/18

### Known issues

* There is an issue with the DNS client fix, where the DNS client incorrectly uses the content `ADDITIONAL SECTION` in DNS responses.
To avoid this issue, install 2.8.4.11 instead of this patch.

### Features

* Added a Docker image for RHEL 8.

### Fixes
#### Core

* **DNS Client**: Fixed an issue where the Kong DNS client stored records with non-matching domain and type when parsing answers.
It now ignores records when the RR type differs from that of the query when parsing answers.
* **Vitals**: Fixed an issue where each data plane connecting to the control plane would trigger the creation of a redundant 
table rotater timer on the control plane.

#### Plugins

* [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Refactored `kong/tools/public/rate-limiting`, adding the new interface `new_instance` to provide isolation between different plugins. 
    The original interfaces remain unchanged for backward compatibility. 
  
    If you are using custom Rate Limiting plugins based on this library, update the initialization code to the new format. For example: 
    `local ratelimiting = require("kong.tools.public.rate-limiting").new_instance("custom-plugin-name")`.
    The old interface will be removed in the upcoming major release.

### Dependencies

* Improved the robustness of `lua-cjson` when handling unexpected input.

## 2.8.4.9
**Release Date** 2024/04/19

### Fixes
#### Core

* Fixed an issue where vault configuration stayed sticky and cached even when configurations were changed.

#### PDK

* Fixed an issue where `kong.request.get_forwarded_port` incorrectly returned a string from `ngx.ctx.host_portand`. It now correctly returns a number.

#### Plugins

* [**DeGraphQL**](/hub/kong-inc/degraphql/) (`degraphql`)
  * Fixed an issue where GraphQL variables were not being correctly parsed and coerced into their defined types.


## 2.8.4.8
**Release Date** 2024/03/26

### Features
#### Configuration

* TLSv1.1 and lower is now disabled by default in OpenSSL 3.x.
* **Performance:** Bumped the default values of `nginx_http_keepalive_requests` and `upstream_keepalive_max_requests` to `10000`. 
These changes are optimized to work better in systems with high throughput. 
In a low-throughput setting, these new settings may have visible effects in load balancing, where it can take more requests to start 
using all the upstreams than before.

### Fixes
#### Configuration

* Fixed an issue where an external plugin (Go, Javascript, or Python) would fail to
apply a change to the plugin config via the Admin API.
* Set the security level of gRPC's TLS to `0` when `ssl_cipher_suite` is set to `old`.
 
#### Core

* Updated the file permission of `kong.logrotate` to 644.
* Fixed the missing router section for the output of request debugging.
* Fixed a issue where the `/metrics` endpoint would throw an error when database was down.
* Fixed the UDP socket leak of the DNS module.

#### Plugins

* [LDAP Auth Advanced](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * Fixed some cache-related issues which caused `groups_required` to return unexpected codes after a non-200 response.

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed an issue where, if `sync_rate` was set to `0` and the `redis` strategy was in use, the plugin did not properly revert to the `local` strategy if the Redis connection was interrupted.

* [Rate Limiting](/hub/kong-inc/rate-limiting/) (`rate-limiting`), [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`), [GraphQL Rate Limiting Advanced](/hub/kong-inc/graphql-rate-limiting-advanced/) (`graphql-rate-limiting-advanced`), and [Response Rate Limiting](/hub/kong-inc/response-ratelimiting/) (`response-ratelimiting`)
  * Fixed an issue where any plugins using the `rate-limiting` library, when used together, 
  would interfere with each other and fail to synchronize counter data to the central data store.

### Dependencies

* Bumped OpenSSL from 3.1.4 to 3.1.5
* Bumped `lua-kong-nginx-module` to 0.2.3
* Bumped `kong-lua-resty-kafka` to 0.18
* Bumped `lua-resty-luasocket` to 1.1.2 to fix [luasocket#427](https://github.com/lunarmodules/luasocket/issues/427)

## 2.8.4.7
**Release Date** 2024/02/08

### Fixes

#### Plugins

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed timer-related issues where the counter syncing timer couldn't be created or destroyed properly.
  * The plugin now creates counter syncing timers when being executed instead of at plugin creation time, which reduces meaningless error logs.
  * The plugin now returns `info` and `log` level messages when Redis connections fail. These error messages were previously missing.
  * The plugin now checks for query errors in the Redis pipeline.
  * Fixed an issue where changing `sync_rate` from a value greater than 0 to 0 would clear the namespace unexpectedly.

## 2.8.4.6
**Release Date** 2024/01/17

### Fixes

#### Core

* Respect custom `proxy_access_log`.
 [#7437](https://github.com/Kong/kong/issues/7437)
* Fixed intermittent ldoc failures caused by a LuaJIT error.
 [#7492](https://github.com/Kong/kong/issues/7492)

#### Enterprise

* Bumped the `dns_stale_ttl` default to 1 hour so that stale DNS records can be used for a longer period of time in case of resolver downtime.
* Fixed a bug where a vault with a GCP backend would hide the error message when secrets couldn't be fetched.
* Fixed an issue where a GCP vault couldn't fetch secrets due to SSL verification failure in CLI mode.
Users who use secrets management based on GCP should also ensure the `system` CA store is included in the `lua_ssl_trusted_certificate` configuration.

#### Plugins

* [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Updated the time used when calculating token expiration.

### Dependencies

#### Core

* Bumped `resty-openssl` from 0.8.25 to 1.0.2.
 [#7414](https://github.com/Kong/kong/issues/7414)
* Bumped the Alpine base image from 3.16 to 3.19.
 [#7732](https://github.com/Kong/kong/issues/7732)

#### Enterprise

* Bumped `lua-resty-healthcheck` to 1.6.4 to fix a bug where the health check
  module wouldn't work correctly when multiple health check instances weren't cleared.

## 2.8.4.5
**Release Date** 2023/11/28

### Features
#### Core
* Added support for observing the time consumed by some components in the given request.
* Added a unique Request ID that is now populated in the error log, access log, error templates, log serializer, and a new `X-Kong-Request-Id` header. 
  This configuration can be customized for upstreams and downstreams using the 
  [`headers`](/gateway/2.8.x/reference/configuration/#headers) and 
  [`headers_upstream`](/gateway/2.8.x/reference/configuration/#headers_upstream) configuration options. 
  [#11663](https://github.com/Kong/kong/pull/11663)

#### Enterprise
* License management:
  * Added support for counters such as routes, plugins, licenses, and deployment information to the license report.
  * Added a checksum to the output of the license endpoint.

#### Plugins
* [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Added the new field `unauthorized_destroy_session`. When set to `true`, it destroys the session when receiving an unauthorized request by deleting the user's session cookie.

### Fixes
#### Core
* Dismissed confusing debug log from the Redis rate limiting tool.
* Removed the asynchronous timer in `syncQuery()` to prevent hang risk.
* Updated the DNS client to follow configured timeouts in a more predictable manner.
* Ensured pluginserver protobuf includes are placed in the correct path in packages.
* Added missing support for consumer group tags.
* Fixed an issue that caused Kong Gateway to fail to start if `proxy_access_log` is `off`.
* Removed asynchronous timer in `syncQuery()` to prevent hang risk.
* Fixed an issue that called `store_connection` without passing `self`.
* Kong Gateway now uses deep copies of route, service, and consumer objects for log serialization.
* Added support for the debug request header `X-Kong-Request-Debug-Output`, 
  which lets you observe the time consumed by specific components in a given request.
  Enable it using the 
  [`request_debug`](/gateway/2.8.x/reference/configuration/#request_debug) configuration parameter.
  This header helps you diagnose the cause of any latency in Kong Gateway.
  See the [Request Debugging](/gateway/latest/production/debug-request/) guide for more information.
  [#11627](https://github.com/Kong/kong/pull/11627)
* Fixed an issue that caused a failure to broadcast keyring material when using the cluster strategy.
* Addressed a problem where an abnormal socket connection would be reused when querying the PostgreSQL database.
* Fixed a plugin server issue that triggered invalidation when the instance was reset.

#### Enterprise
* Fixed an issue with the local variable `pkey` shadowing the package `pkey`. This caused the `attempt to call field 'new' (a nil value)` error message to display when calling `pkey.new`.

#### Plugins
* [mTLS Authentication](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
  * Fixed an issue to prevent caching network failures during revocation checks.
* [AWS-Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * Gradually initializes AWS library on a first use to remove startup delay caused by AWS metadata discovery.
* [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Now allows preserving the session when there's a `401`.
  * Fixed an issue with token revocation on logout, where the code was revoking the refresh token instead of the access token when using the discovered revocation endpoint.
* Collector (`collector`)
  * Fixed an issue where Kong Gateway couldn't start after upgrading to versions greater than or equal to 2.8.4.1 because the deprecated Collector plugin was still being used.
* [Request Validator](/hub/kong-inc/request-validator/) (`request-validator`)  
  * Fixed an issue where the `allowed_content_types` configuration was unable to contain the `-` character.
* [Rate Limiting](/hub/kong-inc/rate-limiting/)(`rate-limiting`)
  * Dismissed confusing log entry from Redis regarding rate limiting.
* [Prometheus](/hub/kong-inc/prometheus/) (`prometheus`) 
  * Reduced upstream health iteration latency spike during scrape.

#### Admin API
* Fixed an issue where unique violation errors were reported while trying to update the `user_token` with the same value on the same RBAC user.
* Unique violations are no longer reported on `user_token` self updates.

### Dependencies
#### Core
* Bumped lua-kong-nginx-module from 0.2.0 to 0.2.2.
* Bumped lua-resty-aws from 1.3.2 to 1.3.5.
* Patched nginx-1.19.9_06-set-ssl-option-ignore-unexpected-eof

#### Enterprise
* Bumped jq to 1.7.
* Bumped OpenSSL to 3.1.4.
* The Postgres socket now closes actively when timeout happens during the query. [#11480](https://github.com/Kong/kong/pull/11480)
* Added Dynatrace testcase.
* Deprecated uses of `mockbin.com`.
* Include `.proto` files in 2.8 packages. 
* Update COPYRIGHT file for 2.8.

#### Kong Manager Enterprise
* Bumped kong_admin to v0.14.26 for GW v2.8.4.5.
* Upgraded moment.js to v2.29.4 to fix a known CVE vulnerability.

## 2.8.4.4
**Release Date** 2023/10/12

### Fixes

#### Core
* Applied Nginx patch for early detection of HTTP/2 stream reset attacks.
This change is in direct response to the identified vulnerability 
[CVE-2023-44487](https://nvd.nist.gov/vuln/detail/CVE-2023-44487).

  See our [blog post](https://konghq.com/blog/product-releases/novel-http2-rapid-reset-ddos-vulnerability-update) for more details on this vulnerability and Kong's responses to it.

## 2.8.4.3 
**Release Date** 2023/09/18

### Breaking changes and deprecations

* **Ubuntu 18.04 support removed**: Support for running Kong Gateway on Ubuntu 18.04 ("Bionic") is now deprecated,
as [Standard Support for Ubuntu 18.04 has ended as of June 2023](https://wiki.ubuntu.com/Releases).
Starting with Kong Gateway 2.8.4.3, Kong is not building new Ubuntu 18.04
images or packages, and Kong will not test package installation on Ubuntu 18.04.

* Amazon Linux 2022 artifacts are renamed to Amazon Linux 2023, based on AWS's own renaming.
 
### Features
#### Plugins
* [AWS-Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * The AWS Lambda plugin has been refactored by using `lua-resty-aws` as an underlying AWS library. The refactor simplifies the AWS Lambda plugin codebase and adds support for multiple IAM authenticating scenarios.

### Fixes 
#### Core
* Fixed an issue that prevented the `dbless-reconfigure` anonymous report type from respecting anonymous reports with the setting `anonymous_reports=false`.
* Fixed an issue where you couldn't create developers using the Admin API in a non-default workspace in {{site.base_gateway}} 2.8.4.2.
* Fixed an issue with Redis catching rate limiting strategy connection failures.

#### Plugins 
* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed an issue that caused the plugin to trigger rate limiting unpredictably.
  * Fixed an issue where {{site.base_gateway}} produced a log of error log entries when multiple Rate Limiting Advanced plugins shared the same namespace.
* [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Fixed an issue that caused the plugin to return logs with `invalid introspection results` when decoding a bearer token.
* [Response Transformer Advanced](/hub/kong-inc/response-transformer-advanced/) (`response-transformer-advanced`)
  * Fixed an issue that caused the response body to load when the `if_status` didn't match.

#### PDK
* Fixed a bug in the exit hook that caused customized headers to be lost.

### Performance
#### Configuration
* Bumped the default value of `upstream_keepalive_pool_size` to 512 and `upstream_keepalive_max_requests` to 1000.

### Dependencies
* Bumped `lua-protobuf` from 0.3.3 to 0.4.2
* Bumped `lua-resty-aws` from 1.0.0 to 1.3.1
* Bumped `lua-resty-gcp` from 0.0.5 to 0.0.13

## 2.8.4.2

**Release Date** 2023/07/07

### Fixes
* Fixed a bug where internal redirects, such as those produced by the `error_page` directive,
  could interfere with worker process handling the request when *buffered proxying* is
  being used.

#### Kong Manager
* Fixed an issue where the Zipkin plugin didn’t allow the addition of `static_tags` through the Kong Manager UI. 
* Fixed an issue where some of the icons were not rendering correctly.

#### Plugins
* Fixed an issue with the Oauth 2.0 Introspection plugin where a request with JSON that is not a table failed.
* Fixed an issue where the slow startup of the Go plugin server caused a deadlock.

### Dependencies
* Bumped `OpenSSL` from 1.1.1t to 3.1.1
* Bumped `lodash` for Dev Portal from 4.17.11 to 4.17.21
* Bumped `lodash` for Kong Manager from 4.17.15 to 4.17.21

## 2.8.4.1

**Release Date** 2023/05/25

### Breaking Changes
#### Plugins
* [Request Validator](/hub/kong-inc/request-validator/) (`request-validator`)
  * The plugin now allows requests carrying a `content-type` with a parameter to match its `content-type` without a parameter.

### Features
* Redis Cluster: Added username and password authentication to Redis Cluster 6 and later versions.

### Fixes
* Fixed an issue where the RBAC token was not re-hashed after an update on the `user_token` field.
* Fixed the Dynatrace implementation. Due to a build system issue, Kong Gateway 2.8.4 packages prior to 2.8.4.1
didn't contain the debug symbols that Dynatrace requires.

#### Plugins
* [Forward Proxy](/hub/kong-inc/forward-proxy/) (`forward-proxy`)
  * Fixed an issue which occurred when receiving an HTTP `408` from the upstream through a forward proxy. 
  Nginx exited the process with this code, which resulted in Nginx ending the request without any contents.

* [Request Validator](/hub/kong-inc/request-validator/) (`request-validator`)
  * The plugin now allows requests carrying a `content-type` with a parameter to match its `content-type` without a parameter.

### Dependencies
* Bumped `pgmoon` from 2.2.0.1 to 2.3.2.0.

## 2.8.4.0
**Release Date** 2023/03/28

### Features

#### Plugins

* [AWS Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * Added the configuration parameter `aws_imds_protocol_version`, which
  lets you select the IMDS protocol version.
  This option defaults to `v1` and can be set to `v2` to enable IMDSv2.
  [#9962](https://github.com/Kong/kong/pull/9962)
 
### Fixes
#### Enterprise

* Fixed an issue where the OpenTracing module was not included in the Amazon Linux 2 package.
* Hybrid mode: Fixed an issue where enabling encryption on a data plane would cause the data plane to stop working after a restart.
* Fixed the systemd unit file, which was incorrectly named `kong.service` in 2.8.1.x and later versions.
It has been renamed back to `kong-enterprise-edition.service` to align with previous versions.

##### Kong Manager

* Fix the character limit error `[postgres] ERROR: value too long for type character(32)` that occurred while enabling the Dev Portal. 
The character limit was shorter than the length of the autogenerated UUID.
* The `/auth` endpoint, used by Kong Manager for OIDC authentication, now correctly supports the HTTP POST method.
* Fixed an issue where users with newly registered Dev Portal accounts created through OIDC were unable to log into Dev Portal 
until the Kong Gateway container was restarted.

#### Core

* Fixed the Ubuntu ARM64 image, which was broken in 2.8.2.x and later versions.
* Router: Fixed an issue where the router used stale data when workers were respawned. 
[#9396](https://github.com/Kong/kong/pull/9396)
[#9485](https://github.com/Kong/kong/pull/9485) 
* Update the batch queues module so that queues no longer grow without bounds if
their consumers fail to process the entries. Instead, old batches are now dropped
and an error is logged.
[#10247](https://github.com/Kong/kong/pull/10247)

#### Plugins

* Added the missing `protocols` field to the following plugin schemas:
  * Azure Functions (`azure-functions`)
  * gRPC Gateway (`grpc-gateway`)
  * gRPC Web (`grpc-web`)
  * Serverless pre-function (`pre-function`)
  * Prometheus (`prometheus`)
  * Proxy Caching (`proxy-cache`)
  * Request Transformer (`request-transformer`)
  * Session (`session`)
  * Zipkin (`zipkin`)

  [#9525](https://github.com/Kong/kong/pull/9525)

* [HTTP Log](/hub/kong-inc/http-log/) (`http-log`)
  * Fixed an issue in this plugin's batch queue processing, where metrics would be published multiple times. 
  This caused a memory leak, where memory usage would grow without limit.
  [#10052](https://github.com/Kong/kong/pull/10052) [#10044](https://github.com/Kong/kong/pull/10044)

* [mTLS Authentication](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
  * Fixed an issue where the plugin used the old route caches after routes were updated. 
 
* [Key Authentication - Encrypted](/hub/kong-inc/key-auth-enc) (`key-auth-enc`)
  * Fixed an issue where using an API key that exists in multiple workspaces caused a 401 error. 
  This occurred because of a caching issue.

## 2.8.2.4
**Release Date** 2023/01/23

### Fixes

* Kong Gateway now statically links the BoringSSL PCRE library. 
This fixes an issue introduced in 2.8.2.3, where the BoringSSL library was dynamically linked, 
causing regex compilation to fail when routing requests with some versions of the library.

## 2.8.2.3
**Release Date** 2023/01/06

### Fixes

#### Enterprise

**Kong Manager:**
* Fixed a role precedence issue with RBAC. 
RBAC rules involving deny (negative) rules now correctly take precedence over allow (non-negative) roles.
* Fixed workspace filtering pagination on the overview page.

#### Core 

* Fixed a router issue where, in an environment with more than 50,000 routes, attempting to update a route caused a `500` error response.
* Fixed a timer leak that occurred whenever the generic messaging protocol connection broke in hybrid mode.
* Fixed a `tlshandshake` method error that occurred when SSL was configured on PostgreSQL, and the Kong Gateway had `stream_listen` configured with a stream proxy. 

#### Plugins

* [HTTP Log](/hub/kong-inc/http-log/) (`http-log`)
  * Fixed the `could not update kong admin` internal error caused by empty headers.
  This error occurred when using this plugin with the Kong Ingress Controller.

* [JWT](/hub/kong-inc/jwt/) (`jwt`)
  * Fixed an issue where the JWT plugin could potentially forward an unverified token to the upstream. 

* [JWT Signer](/hub/kong-inc/jwt-signer/) (`jwt-signer`)
  * Fixed the error `attempt to call local 'err' (a string value)`. 

* [Mocking](/hub/kong-inc/mocking/) (`mocking`)
  * Fixed UUID pattern matching. 

* [Prometheus](/hub/kong-inc/prometheus/) (`prometheus`)
  * Provided options to reduce the plugin's impact on performance.
  Added new `kong.conf` options to switch high cardinality metrics `on` or `off`: 
  [`prometheus_plugin_status_code_metrics`](/gateway/2.8.x/reference/configuration/#prometheus_plugin_status_code_metrics), [`prometheus_plugin_latency_metrics`](/gateway/2.8.x/reference/configuration/#prometheus_plugin_latency_metrics), [`prometheus_plugin_bandwidth_metrics`](/gateway/2.8.x/reference/configuration/#prometheus_plugin_bandwidth_metrics), and [`prometheus_plugin_upstream_health_metrics`](/gateway/2.8.x/reference/configuration/#prometheus_plugin_upstream_health_metrics).

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed a maintenance cycle lock leak in the `kong_locks` dictionary. 
  Kong Gateway now clears old namespaces from the maintenance cycle schedule when a namespace is updated.

* [Request Transformer](/hub/kong-inc/request-transformer/) (`request-transformer`)
  * Fixed an issue where empty arrays were being converted to empty objects.
  Empty arrays are now preserved.

### Known limitations

* A required PCRE library is dynamically linked, where prior versions statically linked the library. Depending on the system PCRE version, this may cause regex compilation to fail when routing requests. Starting in 2.8.2.4 and later, Kong Gateway will return to statically linking the PCRE library.

## 2.8.2.2
**Release Date** 2022/12/01

### Fixes

#### Core

Timer issue fixes:
* Added batch queues for the Datadog and StatsD plugins to reduce timer usage,
fixing a `lua_max_running_timers are not enough` timer error.

    Whenever a request was processed, a new running timer was instantly
    created during the log phase. This was causing a shortage
    of timers under heavy traffic and led to unpredictable consequences, where
    internal timers were killed randomly and couldn't recover automatically.
    This would then trigger a `lua_max_running_timers are not enough` timer
    error and cause data planes to crash.

    [#9521](https://github.com/Kong/kong/pull/9521)

* Fixed a timer leak that occurred whenever the generic messaging protocol
connection would break in hybrid mode.

## 2.8.2.1
**Release Date** 2022/11/21

### Fixes

#### Enterprise

* **Kong Manager:**
  * Fixed an issue where admins needed the specific `rbac/role` permission to edit RBAC roles.
  Now, admins can edit RBAC roles with the `/admins` permission.
  * Fixed an issue where the client certificate ID didn't display properly in the upstream update form.
  * Fixed an issue in the service documents UI which allowed users to upload multiple documents. Since each service
  only supports one document, the documents would not display correctly. Uploading a new document now overrides the previous document.
  * Fixed an issue where the **New Workspace** button on the global workspace dashboard wasn't clickable on the first page load.
  * Fixed an RBAC issue where the roles page listed deleted roles.
  * Removed New Relic from Kong Manager. Previously, `VUE_APP_NEW_RELIC_LICENSE_KEY` and
  `VUE_APP_SEGMENT_WRITE_KEY` were being exposed in Kong Manager with invalid values.
  * Fixed an RBAC issue where permissions applied to specific endpoints (for example, an individual service or route) were not reflected in the Kong Manager UI.
  * Fixed an issue with group to role mapping, where it didn't support group names with spaces.
  * Fixed an issue with individual workspace dashboards, where right-clicking on **View All** and choosing "Open Link in New Tab" or "Copy Link" for services, routes, and plugins redirected to the default workspace and caused an `HTTP 404` error.

* **Dev Portal**: Fixed an issue where Dev Portal response examples weren't rendered when media type was vendor-specific.

#### Core

* Targets with a weight of `0` are no longer included in health checks, and checking their status via the `upstreams/<upstream>/health` endpoint results in the status `HEALTHCHECK_OFF`.
Previously, the `upstreams/<upstream>/health` endpoint was incorrectly reporting targets with `weight=0` as `HEALTHY`, and the health check was reporting the same targets as `UNDEFINED`.

* Fixed the default `logrotate` configuration, which lacked permissions to access logs.

#### Plugins

* [Kafka Upstream](/hub/kong-inc/kafka-upstream/) (`kafka-upstream`)
  * Fixed the `Bad Gateway` error that would occur when using the Kafka Upstream plugin with the configuration `producer_async=false`.

* [Response Transformer](/hub/kong-inc/response-transformer/) (`response-transformer`)
  * Fixed an issue where the plugin couldn't process string responses.

* [mTLS Authentication](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
  * Fixed an issue where the plugin was causing requests to silently fail on Kong Gateway data planes.

* [Request Transformer](/hub/kong-inc/request-transformer/) (`request-transformer`)
  * Fixed an issue where empty arrays were being converted to empty objects.
  Empty arrays are now preserved.

* [Azure Functions](/hub/kong-inc/azure-functions/) (`azure-functions`)
  * Fixed an issue where calls made by this plugin would fail in the following situations:
    * The plugin was associated with a route that had no service.
    * The route's associated service had a `path` value.

* [LDAP Auth Advanced](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * Fixed an issue where operational attributes referenced by `group_member_attribute` weren't returned in search query results.

## 2.8.2.0
**Release Date** 2022/10/12

### Fixes

#### Enterprise

* **Kong Manager**:
  * Fixed an issue where workspaces with zero roles were not correctly sorted by the number of roles.
  * Fixed the Cross Site Scripting (XSS) security vulnerability in the Kong Manager UI.
  * Fixed an issue where registering an admin without `admin_gui_auth` set resulted in a `500` error.
  * Fixed an issue that allowed unauthorized IDP users to log in to Kong Manager.
  These users had no access to any resources in Kong Manager, but were able to go beyond the login screen.

* Fixed OpenSSL vulnerabilities [CVE-2022-2097](https://nvd.nist.gov/vuln/detail/CVE-2022-2097) and [CVE-2022-2068](https://nvd.nist.gov/vuln/detail/CVE-2022-2068).
* Hybrid mode: Fixed an issue with consumer groups, where the control plane wasn't sending the correct number of consumer entries to data planes.
* Hybrid mode: Fixed an issue where sending a `PATCH` request to update a route after restarting a control plane caused a 500 error response.

#### Plugins

* [AWS Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * Fixed an issue where the plugin couldn't read environment variables in the ECS environment, causing permission errors.

* [Forward Proxy](/hub/kong-inc/forward-proxy/) (`forward-proxy`)
  * If the `https_proxy` configuration parameter is not set, it now defaults to `http_proxy` to avoid DNS errors.

* [GraphQL Proxy Cache Advanced](/hub/kong-inc/graphql-proxy-cache-advanced/) (`graphql-proxy-cache-advanced`) and [Proxy Cache Advanced](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cache-advanced`)
  * Fixed the error `function cannot be called in access phase (only in: log)`, which was preventing the plugin from working consistently.

* [GraphQL Rate Limiting Advanced](/hub/kong-inc/graphql-rate-limiting-advanced/) (`graphql-rate-limiting-advanced`)
  * The plugin now returns a `500` error when using the `cluster` strategy in hybrid or DB-less modes instead of crashing.

* [LDAP Authentication Advanced](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * The characters `.` and `:` are now allowed in group attributes.

* [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Fixed issues with OIDC role mapping where admins couldn't be added to more than one workspace, and permissions were not being updated.

* [Request Transformer Advanced](/hub/kong-inc/request-transformer-advanced/) (`request-transformer-advanced`)
  * Fixed an issue where empty arrays were being converted to empty objects.
  Empty arrays are now preserved.

* [Route Transformer Advanced](/hub/kong-inc/route-transformer-advanced/) (`route-transformer-advanced`)
  * Fixed an issue where URIs that included `%20` or a whitespace would return a `400 Bad Request`.


## 2.8.1.4
**Release Date** 2022/08/23

* Fixed vulnerabilities [CVE-2022-37434](https://nvd.nist.gov/vuln/detail/CVE-2022-37434) and [CVE-2022-24975](https://nvd.nist.gov/vuln/detail/CVE-2022-24975).

* When using secrets management in free mode, only the [environment variable](/gateway/2.8.x/plan-and-deploy/security/secrets-management/backends/env/) backend is available. AWS, GCP, and HashiCorp vault backends require an Enterprise license.

* Fixed an issue in Kong Manager where entity detail pages were empty and didn't list existing entities.
The following entities were affected:
  * Route lists on service pages
  * Upstreams
  * Certificates
  * SNIs
  * RBAC roles

* Fixed an issue where the browser hung when creating an upstream with the existing host and port.

#### Plugins

* [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Fixed a caching issue in hybrid mode, where the data plane node would try to retrieve a new JWK from the IdP every time.
  The data plane node now looks for a cached JWK first.

* [Proxy Caching Advanced](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cache-advanced`)
  * Fixed an issue that prevented users from removing the cluster addresses on an existing configuration.

### Dependencies

* Bump `lua-resty-aws` version to 0.5.4 to reduce memory usage when AWS vault is enabled. [#23](https://github.com/Kong/lua-resty-aws/pull/23)
* Bump `lua-resty-gcp` version to 0.0.5 to reduce memory usage when GCP vault is enabled. [#7](https://github.com/Kong/lua-resty-gcp/pull/7)

## 2.8.1.3
**Release Date** 2022/08/05

### Features

#### Enterprise

* Added GCP integration support for the secrets manager. GCP is now available as a vault backend.

#### Plugins

* [AWS Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * Added support for cross-account invocation through
  the `aws_assume_role_arn` and
  `aws_role_session_name` configuration parameters.
  [#8900](https://github.com/Kong/kong/pull/8900)

### Fixes

#### Enterprise
* Fixed an issue with excessive log file disk utilization on control planes.
* Fixed an issue with keyring encryption, where keyring was not decrypting keys after a soft reload.
* The router now detects static route collisions inside the current workspace, as well as with other workspaces.
* When using a custom plugin in a hybrid mode deployment, the control plane now detects compatibility issues and stops sending the plugin configuration to data planes that can't use it. The control plane continues sending the custom plugin configuration to compatible data planes.
* Optimized the Kong PDK function `kong.response.get_source()`.

#### Kong Manager
* Fixed an issue with admin creation.
Previously, when an admin was created with no roles, the admin would have access to the first workspace listed alphabetically.
* Fixed several issues with SNI listing.
Previously, the SNI list was empty after sorting by the SSL certificate ID field. In 2.8.1.1, the SSL certificate ID field in the SNI list was empty.

#### Plugins

* [Mocking](/hub/kong-inc/mocking/) (`mocking`)
  * Fixed an issue where the plugin didn't accept empty values in examples.

* [ACME](/hub/kong-inc/acme/) (`acme`)
  * The `domains` plugin parameter can now be left empty.
  When `domains` is empty, all TLDs are allowed.
  Previously, the parameter was labelled as optional, but leaving it empty meant that the plugin retrieved no certificates at all.

* [Response Transformer Advanced](/hub/kong-inc/response-transformer-advanced/) (`response-transformer-advanced`)
  * Fixed an issue with nested array parsing.

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed an issue with `cluster` strategy timestamp precision in Cassandra.

## 2.8.1.2
**Release Date** 2022/07/15

### Fixes

#### Enterprise

* Fixed an issue in hybrid mode where, if a service was set to `enabled: false` and that service had a route with an enabled plugin, any new data planes would receive empty configuration.
* Fixed a timer leak that occurred when `worker_consistency` was set to `eventual` in `kong.conf`.
This issue caused timers to be exhausted and failed to start any other timers used by Kong Gateway, resulting in a `too many pending timers` error.
* Fixed memory leaks coming from `lua-resty-lock`.
* Fixed global plugins can operate out of the workspace scope

#### Kong Manager and Dev Portal

* Fixed an issue where Kong Manager did not display all Dev Portal developers in the organization.
* Fixed an issue that prevented developer role assignments from displaying in Kong Manager.
When viewing a role under the Permissions tab in the Dev Portal section, the list of developers wouldn't update when a new developer was added.
Kong Manager was constructing the wrong URL when retrieving Dev Portal assignees.
* Fixed empty string handling in Kong Manager. Previously, Kong Manager was handling empty strings as `""` instead of a null value.
* Improved Kong Manager styling by fixing an issue where content didn't fit on object detail pages.
* Fixed an issue that sometimes prevented clicking Kong Manager links and buttons in Safari.
* Fixed an issue where users were being navigated to the object detail page after clicking on the "Copy ID" button from the object list.
* Fixed an issue where the number of requests and error rate were not correctly displaying when Vitals was disabled.

#### Plugins

* [Rate Limiting](/hub/kong-inc/rate-limiting/) (`rate-limiting`) and [Response Rate Limiting](/hub/kong-inc/response-ratelimiting/) (`response-ratelimiting`)
  * Fixed a PostgreSQL deadlock issue that occurred when the `cluster` policy was used with two or more metrics (for example, `second` and `day`.)

* [HTTP Log](/hub/kong-inc/http-log/) (`http-log`)
  * Log output is now restricted to the workspace the plugin is running in. Previously,
  the plugin could log requests from outside of its workspace.

* [Mocking](/hub/kong-inc/mocking/) (`mocking`)
  * Fixed an issue where `204` responses were not handled correctly and you would see the following error:
`"No examples exist in API specification for this resource"`.
  * `204` response specs now support empty content elements.

### Deprecated

* **Amazon Linux 1**: Support for running Kong Gateway on Amazon Linux 1 is now deprecated, as the
[Amazon Linux (1) AMI has ended standard support as of December 31, 2020](https://aws.amazon.com/blogs/aws/update-on-amazon-linux-ami-end-of-life).
Starting with Kong Gateway 3.0.0.0, Kong is not building new Amazon Linux 1
images or packages, and Kong will not test package installation on Amazon Linux 1.

    If you need to install Kong Gateway on Amazon Linux 1, see the documentation for
    [previous versions](/gateway/2.8.x/install-and-run/amazon-linux/).

* **Debian 8**: Support for running Kong Gateway on Debian 8 ("Jessie") is now deprecated, as
Debian 8 ("Jessie") has reached End of Life (EOL).
Starting with Kong Gateway 3.0.0.0, Kong is not building new Debian 8
("Jessie") images or packages, and Kong will not test package installation on
Debian 8 ("Jessie").

    If you need to install Kong Gateway on Debian 8 ("Jessie"), see the documentation for
    [previous versions](/gateway/2.8.x/install-and-run/debian/).

* **Ubuntu 16.04**: Support for running Kong Gateway on Ubuntu 16.04 ("Xenial") is now deprecated,
as [Standard Support for Ubuntu 16.04 has ended as of April, 2021](https://wiki.ubuntu.com/Releases).
Starting with Kong Gateway 3.0.0.0, Kong is not building new Ubuntu 16.04
images or packages, and Kong will not test package installation on Ubuntu 16.04.

    If you need to install Kong Gateway on Ubuntu 16.04, see the documentation for
    [previous versions](/gateway/2.8.x/install-and-run/ubuntu/).

## 2.8.1.1
**Release Date** 2022/05/27

### Features

#### Enterprise

* You can now enable application status and application request emails
for the Developer Portal using the following configuration parameters:
  * [`portal_application_status_email`](/gateway/latest/reference/configuration/#portal_application_status_email): Enable to send application request status update emails to developers.
  * [`portal_application_request_email`](/gateway/latest/reference/configuration/#portal_application_request_email): Enable to send service access request emails to users specified in `smtp_admin_emails`.
  * [`portal_smtp_admin_emails`](/gateway/latest/reference/configuration/#portal_smtp_admin_emails): Specify the email addresses to send portal admin emails to, overriding values set in `smtp_admin_emails`.
* Added the ability to use `email.developer_meta` fields in portal email templates. For example, `{% raw %}{{email.developer_meta.preferred_name}}{% endraw %}`.

#### Plugins

* [AWS Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * When working in proxy integration mode, the `statusCode` field now accepts
  string datatypes.

* [mTLS Authentication](/hub/kong-inc/mtls-auth/) (`mtls-auth`)
  * Introduced certificate revocation list (CRL) and OCSP server support with the
  following parameters: `http_proxy_host`, `http_proxy_port`, `https_proxy_host`,
  and `https_proxy_port`.

* [Kafka Upstream](/hub/kong-inc/kafka-upstream/) (`kafka-upstream`) and [Kafka Log](/hub/kong-inc/kafka-log/) (`kafka-log`)
  * Added support for the `SCRAM-SHA-512` authentication mechanism.

### Fixes

#### Enterprise

* Improved Kong Admin API and Kong Manager performance for organizations with
many entities.

* Fixed an issue with keyring encryption, where the control plane would crash if any errors occurred
during the initialization of the [keyring module](/gateway/latest/plan-and-deploy/security/db-encryption/).

* Fixed an issue where Kong Manager did not display all RBAC users and Consumers
in the organization.

* Fixed an issue where some areas in a row of a list were not clickable.

#### Plugins

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed rate limiting advanced errors that appeared when the Rate Limiting
  Advanced plugin was not in use.
  * Fixed an error where rate limiting counters were not updating response
  headers due to incorrect key expiration tracking.
  Redis key expiration is now tracked properly in `lua_shared_dict kong_rate_limiting_counters`.

* [Forward Proxy](/hub/kong-inc/forward-proxy/) (`forward-proxy`)
  * Fixed an `invalid header value` error for HTTPS requests. The plugin
  now accepts multi-value response headers.
  * Fixed an error where basic authentication headers containing the `=`
  character weren't forwarded.
  * Fixed request errors that occurred when a scheme had no proxy set. The
  `https` proxy now falls back to the `http` proxy if not specified, and the
  `http` proxy falls back to `https`.

* [GraphQL Rate Limiting Advanced](/hub/kong-inc/graphql-rate-limiting-advanced/) (`graphql-rate-limiting-advanced`)
  * Fixed `deserialize_parse_tree` logic when building GraphQL AST with
  non-nullable or list types.

## 2.8.1.0
**Release Date** 2022/04/07

### Fixes

#### Enterprise

* Fixed an issue with RBAC where `endpoint=/kong workspace=*` would not let the `/kong` endpoint be accessed from all workspaces
* Fixed an issue with RBAC where admins without a top level `endpoint=*` permission could not add any RBAC rules, even if they had `endpoint=/rbac` permissions. These admins can now add RBAC rules for their current workspace only.
* Kong Manager
  * Serverless functions can now be saved when there is a comma in the provided value
  * Custom plugins now show an Edit button when viewing the plugin configuration
  * Editing Dev Portal permissions no longer returns a 404 error
  * Fix an issue where admins with access to only non-default workspaces could not see any workspaces
  * Show the workspace name when an admin only has access to non-default workspaces
  * Add support for table filtering and sorting when using Cassandra
  * Support the # character in RBAC tokens on the RBAC edit page
  * Performing an action on an upstream target no longer leads to a 404 error
* Developer Portal
  * Information about the current session is now bound to an nginx worker thread. This prevents data leaks when a worker is handling multiple requests at the same time
* Keys are no longer rotated unexpectedly when a node restarts
* Add cache when performing RBAC token verification
* The log message "plugins iterator was changed while rebuilding it" was incorrectly logged as an `error`. This release converts it to the `info` log level.
* Fixed a 500 error when rate limiting counters are full with the Rate Limiting Advanced plugin
* Improved the performance of the router, plugins iterator and balancer by adding conditional rebuilding

#### Plugins

* [HTTP Log](/hub/kong-inc/http-log/) (`http-log`)
  * Include provided query string parameters when sending logs to the `http_endpoint`
* [Forward Proxy](/hub/kong-inc/forward-proxy/) (`forward-proxy`)
  * Use lowercase when overwriting the `host` header
* [StatsD Advanced](/hub/kong-inc/statsd-advanced/) (`statsd-advanced`)
  * Added support for setting `workspace_identifier` to `workspace_name`
* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Skip namespace creation if the plugin is not enabled. This prevents the error "[rate-limiting-advanced] no shared dictionary was specified" being logged.
* [LDAP Auth Advanced](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)
  * Support passwords that contain a `:` character
* [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)
  * Provide valid upstream headers e.g. `X-Consumer-Id`, `X-Consumer-Username`
* [JWT Signer](/hub/kong-inc/jwt-signer/) (`jwt-signer`)
  * Implement the `enable_hs_signatures` option to enable JWTs signed with HMAC algorithms

### Dependencies

* Bumped `openssl` from 1.1.1k to 1.1.1n to resolve CVE-2022-0778 [#8635](https://github.com/Kong/kong/pull/8635)
* Bumped `openresty` from 1.19.3.2 to 1.19.9.1 [#7727](https://github.com/Kong/kong/pull/7727)

## 2.8.0.0
**Release Date** 2022/03/02

### Features

#### Enterprise

* Improved tables in Kong Manager: (for PostgreSQL-backed instances only)
  * Click on a table row to access the entry instead of using the
  old **View** icon.
  * Search and filter tables through the **Filters** dropdown, which is located
  above the table.
  * Sort any table by clicking on a column title.
  * Tables now have pagination.

* Kong Manager with OIDC:
  * Added the configuration option
  [`admin_auto_create_rbac_token_disabled`](/gateway/latest/configure/auth/kong-manager/oidc-mapping/)
  to enable or disable RBAC tokens when automatically creating admins with OpenID
  Connect.

* If a license is present,`license_key` is now included in the `api` signal for
[`anonymous_reports`](/gateway/latest/reference/configuration/#anonymous_reports).

#### Dev Portal

* The new `/developers/export` endpoint lets you export the list of developers
and their statuses into CSV format.

#### Core

* **Beta feature**: Kong Gateway 2.8.0.0 introduces
[secrets management and vault support](/gateway/latest/kong-enterprise/secrets-management/).
You can now store confidential values such as usernames and passwords
as secrets in secure vaults. Kong Gateway can then reference these secrets,
making your environment more secure.

  The beta includes `get` support for the following vault implementations:
  * [AWS Secrets Manager](/gateway/latest/kong-enterprise/secrets-management/backends/aws-sm/)
  * [HashiCorp Vault](/gateway/latest/kong-enterprise/secrets-management/backends/hashicorp-vault/)
  * [Environment variable](/gateway/latest/kong-enterprise/secrets-management/backends/env/)

  As part of this support, some plugins have certain fields marked as
  *referenceable*. See the plugin section of the Kong Gateway 2.8 changelog for
  details.

  Test out secrets management using the
  [getting started guide](/gateway/latest/kong-enterprise/secrets-management/getting-started/),
  and check out the documentation for the Kong Admin API [`/vaults-beta` entity](/gateway/latest/admin-api/#vaults-beta-entity).

  {:.important}
  > This feature is in beta. It has limited support and implementation details
  may change. This means it is intended for testing in staging environments
  only, and **should not** be deployed in production environments.

* You can customize the transparent dynamic TLS SNI name.

  Thanks, [@Murphy-hub](https://github.com/Murphy-hub)!
  [#8196](https://github.com/Kong/kong/pull/8196)

* Routes now support matching headers with regular expressions.

  Thanks, [@vanhtuan0409](https://github.com/vanhtuan0409)!
  [#6079](https://github.com/Kong/kong/pull/6079)

* You can now configure [`cluster_max_payload`](/gateway/latest/reference/configuration/#cluster_max_payload)
  for hybrid mode deployments. This configuration option sets the maximum payload
  size allowed to be sent across from the control plane to the data plane. If your
  environment has large configurations that generate `payload too big` errors
  and don't get applied to the data planes, use this setting to adjust the limit.

  Thanks, [@andrewgkew](https://github.com/andrewgkew)!
  [#8337](https://github.com/Kong/kong/pull/8337)

#### Performance

* Improved the calculation of declarative configuration hash for big configurations.
  The new method is faster and uses less memory.
  [#8204](https://github.com/Kong/kong/pull/8204)

* Multiple improvements in the Router, including:
  * The router builds twice as fast
  * Failures are cached and discarded faster (negative caching)
  * Routes with header matching are cached

  These changes should be particularly noticeable when rebuilding in DB-less
  environments.
  [#8087](https://github.com/Kong/kong/pull/8087)
  [#8010](https://github.com/Kong/kong/pull/8010)

#### Admin API

* The current declarative configuration hash is now returned by the `status`
  endpoint when Kong node is running in DB-less or data plane mode.
  [#8214](https://github.com/Kong/kong/pull/8214)
  [#8425](https://github.com/Kong/kong/pull/8425)

#### Plugins

* [Canary](/hub/kong-inc/canary/) (`canary`)
  * Added the ability to configure `canary_by_header_name`. This parameter
  accepts a header name that, when present on a request, overrides the configured canary
  functionality.         
    * If the configured header is present with the value `always`, the request will
      always go to the canary upstream.
    * If the header is present with the value `never`, the request will never go to the
    canary upstream.

* [Prometheus](/hub/kong-inc/prometheus/) (`prometheus`)
  * Added three new metrics:
    * `kong_db_entities_total` (gauge): total number of entities in the database.
    * `kong_db_entity_count_errors` (counter): measures the number of errors encountered during the measurement of `kong_db_entities_total`.
    * `kong_nginx_timers` (gauge): total number of Nginx timers, in Running or Pending state. Tracks `ngx.timer.running_count()` and
      `ngx.timer.pending_count()`.
      [#8387](https://github.com/Kong/kong/pull/8387)

* [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)

  * Added Redis ACL support (Redis v6.0.0+) for storing and retrieving a session.
    Use the `session_redis_username` and `session_redis_password` configuration
    parameters to configure it.

    {:.important}
    > These parameters replace the `session_redis_auth` field, which is
    now **deprecated** and planned to be removed in 3.x.x.

  * Added support for distributed claims. Set the `resolve_distributed_claims`
   configuration parameter to `true` to tell OIDC to explicitly resolve
   distributed claims.

      Distributed claims are represented by the `_claim_names` and `_claim_sources`
      members of the JSON object containing the claims.

  * **Beta feature:** The `client_id`, `client_secret`, `session_secret`, `session_redis_username`,
  and `session_redis_password` configuration fields are now marked as
  referenceable, which means they can be securely stored as
  [secrets](/gateway/latest/kong-enterprise/secrets-management/getting-started/)
  in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format/).

* [Forward Proxy Advanced](/hub/kong-inc/forward-proxy/) (`forward-proxy`)

  * Added `http_proxy_host`, `http_proxy_port`, `https_proxy_host`, and
  `https_proxy_port` configuration parameters for mTLS support.

      {:.important}
      > These parameters replace the `proxy_port` and `proxy_host` fields, which
      are now **deprecated** and planned to be removed in 3.x.x.

  * The `auth_password` and `auth_username` configuration fields are now marked as
  referenceable, which means they can be securely stored as
  [secrets](/gateway/latest/kong-enterprise/secrets-management/getting-started/)
  in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format/).

* [Kafka Upstream](/hub/kong-inc/kafka-upstream/) (`kafka-upstream`) and [Kafka Log](/hub/kong-inc/kafka-log/) (`kafka-log`)

  * Added the ability to identify a Kafka cluster using the `cluster_name` configuration parameter.
   By default, this field generates a random string. You can also set your own custom cluster identifier.

  * **Beta feature:** The `authentication.user` and `authentication.password` configuration fields are now marked as
  referenceable, which means they can be securely stored as
  [secrets](/gateway/latest/kong-enterprise/secrets-management/getting-started/)
  in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format/).

* [LDAP Authentication Advanced](/hub/kong-inc/ldap-auth-advanced/) (`ldap-auth-advanced`)

  * **Beta feature:** The `ldap_password` and `bind_dn` configuration fields are now marked as
  referenceable, which means they can be securely stored as
  [secrets](/gateway/latest/kong-enterprise/secrets-management/getting-started/)
  in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format/).

* [Vault Authentication](/hub/kong-inc/vault-auth/) (`vault-auth`)

  * **Beta feature:** The `vaults.vault_token` form field is now marked as
  referenceable, which means it can be securely stored as a
  [secret](/gateway/latest/kong-enterprise/secrets-management/getting-started/)
  in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format/).

* [GraphQL Rate Limiting Advanced](/hub/kong-inc/graphql-rate-limiting-advanced/) (`graphql-rate-limiting-advanced`)

  * Added Redis ACL support (Redis v6.0.0+ and Redis Sentinel v6.2.0+).

  * Added the `redis.username` and `redis.sentinel_username` configuration parameters.

  * **Beta feature:** The `redis.username`, `redis.password`, `redis.sentinel_username`, and `redis.sentinel_password`
  configuration fields are now marked as referenceable, which means they can be securely stored as
  [secrets](/gateway/latest/kong-enterprise/secrets-management/getting-started/)
  in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format/).

* [Rate Limiting](/hub/kong-inc/rate-limiting/) (`rate-limiting`)

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Added Redis ACL support (Redis v6.0.0+ and Redis Sentinel v6.2.0+).

  * Added the `redis.username` and `redis.sentinel_username` configuration parameters.

  * **Beta feature:** The `redis.username`, `redis.password`, `redis.sentinel_username`, and `redis.sentinel_password`
  configuration fields are now marked as referenceable, which means they can be securely stored as
  [secrets](/gateway/latest/kong-enterprise/secrets-management/getting-started/)
  in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format/).

* [Response Rate Limiting](/hub/kong-inc/response-ratelimiting/) (`response-ratelimiting`)
  * Added Redis ACL support (Redis v6.0.0+ and Redis Sentinel v6.2.0+).
  * Added the `redis_username` configuration parameter.

    Thanks, [@27ascii](https://github.com/27ascii) for the original contribution!
    [#8213](https://github.com/Kong/kong/pull/8213)

* [Response Transformer Advanced](/hub/kong-inc/response-transformer-advanced/) (`response-transformer-advanced`)
  * Use response buffering from the PDK.

* [Proxy Cache Advanced](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cache-advanced`)
  * Added Redis ACL support (Redis v6.0.0+ and Redis Sentinel v6.2.0+).

  * Added the `redis.sentinel_username` and `redis.sentinel_password` configuration
  parameters.

  * **Beta feature:**  The `redis.password`, `redis.sentinel_username`, and `redis.sentinel_password`
  configuration fields are now marked as referenceable, which means they can be
  securely stored as [secrets](/gateway/latest/kong-enterprise/secrets-management/getting-started/)
  in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format/).

* [jq](/hub/kong-inc/jq/) (`jq`)
  * Use response buffering from the PDK.

* [ACME](/hub/kong-inc/acme/) (`acme`)
  * Added the `rsa_key_size` configuration parameter.

    Thanks, [lodrantl](https://github.com/lodrantl)!
    [#8114](https://github.com/Kong/kong/pull/8114)

### Fixes

#### Enterprise

* Fixed a timer leak that caused the timers to be exhausted and failed to start
any other timers used by Kong, showing the error `too many pending timers`.

* Fixed an issue where, if `data_plane_config_cache_mode` was set to `off`, the
data plane received no updates from the control plane.

* Fixed `attempt to index local 'workspace'` error, which occurred when
accessing Routes or Services using TLS.

* Fixed an issue where [`cluster_telemetry_server_name`](/gateway/latest/reference/configuration/#cluster_telemetry_server_name)
was not automatically generated and registered if it was not explicitly set.

* Fixed the [`cluster_allowed_common_names`](/gateway/latest/reference/configuration/#cluster_allowed_common_names)
setting. When using PKI for certificate verification in hybrid mode, you can now
configure a list of Common Names allowed to connect to a control plane with the
option. If not set, only data planes with the same parent domain as the control
plane cert are allowed.

#### Kong Manager

* Fixed an issue where OIDC authentication into Kong Manager failed when used
with Azure AD.

* Fixed a performance issue with the Teams page in Kong Manager.

* Fixed an issue with checkboxes in Kong Manager, where the checkbox for
the OAuth2 plugin's `hash_secret` value was labelled as *Required* and users
were not able to uncheck it.

* Fixed an issue where Kong Manager was not updating plugin configuration
 when attempting to clear the `service.id` from a plugin.

* Fixes an issue with Route creation in Kong Manager, where a new route would
default to `http` as the supported protocol. Now, creating a Route picks up
the correct default value, which is `http,https`.

* Kong Manager now accurately lists `udp` as a protocol option for Route and
Service objects on their configuration pages.

* Fixed an issue with Kong Manager OIDC authentication, which caused the error
`“attempt to call method 'select_by_username_ignore_case' (a nil value)”`
and prevented login with OIDC.

* Fixed a latency issue with OAuth2 token creation. These tokens
 are no longer tracked by the workspace entity counter, as the count is not
 needed by the Kong Manager UI.

* Fixed an issue where the plugin list table couldn't be sorted by the
**Applied To** column.

#### Dev Portal

* When the SMTP configuration was broken or unresponsive, the API would respond
with an error message that was a JavaScript Object (`[Object object]`) instead
of a string. This happened when a user was registering on any given portal with
broken SMTP. Now, if there is an error, the API responds with the string
`Error sending email`.

* The `/document_objects` and `/services/:id/document_objects` endpoints no
longer accept multiple documents per service. This was an issue, as each service
can only have one document. Instead, posting a document to one of these endpoints
now overrides the previous document.

#### Core

* When the Router encounters an SNI FQDN with a trailing dot (`.`),
  the dot will be ignored, since according to
  [RFC-3546](https://datatracker.ietf.org/doc/html/rfc3546#section-3.1)
  the dot is not part of the hostname.
  [#8269](https://github.com/Kong/kong/pull/8269)

* Fixed a bug in the Router that would not prioritize the routes with
  both a wildcard and a port (`route.*:80`) over wildcard-only routes (`route.*`),
  which have less specificity.
  [#8233](https://github.com/Kong/kong/pull/8233)

* The internal DNS client isn't confused by the single-dot (`.`) domain,
  which can appear in `/etc/resolv.conf` in special cases like `search .`
  [#8307](https://github.com/Kong/kong/pull/8307)

* The Cassandra connector now records migration consistency level.

  Thanks, [@mpenick](https://github.com/mpenick)!
  [#8226](https://github.com/Kong/kong/pull/8226)

#### Balancer

* Targets now keep their health status when upstreams are updated.
  [#8394](https://github.com/Kong/kong/pull/8394)

* One debug message which was erroneously using the `error` log level
  has been downgraded to the appropriate `debug` log level.
  [#8410](https://github.com/Kong/kong/pull/8410)

#### Clustering

* Replaced a cryptic error message with a more useful one when
  there is a failure on SSL when connecting with the control plane.
  [#8260](https://github.com/Kong/kong/pull/8260)

#### Admin API

* Fixed an incorrect `next` field that appeared when paginating Upstreams.
  [#8249](https://github.com/Kong/kong/pull/8249)

#### PDK

* Phase names are now correctly selected when performing phase checks.
  [#8208](https://github.com/Kong/kong/pull/8208)
* Fixed a bug in the go-PDK where, if `kong.request.getrawbody` was
  big enough to be buffered into a temporary file, it would return an
  an empty string.
  [#8390](https://github.com/Kong/kong/pull/8390)

#### Plugins

* **External Plugins**:
  * Fixed incorrect handling of the Headers Protobuf Structure
    and representation of null values, which provoked an error on init with the go-pdk.
    [#8267](https://github.com/Kong/kong/pull/8267)

  * Unwrap `ConsumerSpec` and `AuthenticateArgs`.

    Thanks, [@raptium](https://github.com/raptium)!
    [#8280](https://github.com/Kong/kong/pull/8280)

  * Fixed a problem in the stream subsystem, where it would attempt to load
    HTTP headers.
    [#8414](https://github.com/Kong/kong/pull/8414)

* [CORS](/hub/kong-inc/cors/) (`cors`)
  * The CORS plugin does not send the `Vary: Origin` header anymore when
    the header `Access-Control-Allow-Origin` is set to `*`.

    Thanks, [@jkla-dr](https://github.com/jkla-dr)!
    [#8401](https://github.com/Kong/kong/pull/8401)

* [AWS Lambda](/hub/kong-inc/aws-lambda/) (`aws-lambda`)
  * Fixed incorrect behavior when configured to use an HTTP proxy
  and deprecated the `proxy_scheme` config attribute for removal in 3.0.
  [#8406](https://github.com/Kong/kong/pull/8406)

* [OAuth2](/hub/kong-inc/oauth2/) (`oauth2`)
  * The plugin clears the `X-Authenticated-UserId` and
  `X-Authenticated-Scope` headers when it is configured in logical OR and
  is used in conjunction with another authentication plugin.
  [#8422](https://github.com/Kong/kong/pull/8422)

* [Datadog](/hub/kong-inc/datadog/) (`datadog`)
  * The plugin schema now lists the default values
  for configuration options in a single place instead of in two
  separate places.
  [#8315](https://github.com/Kong/kong/pull/8315)

* [Rate Limiting](/hub/kong-inc/rate-limiting/) (`rate-limiting`)
  * Fixed a 500 error associated with performing arithmetic functions on a nil
  value by adding a nil value check after performing `ngx.shared.dict` operations.

* [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) (`rate-limiting-advanced`)
  * Fixed a 500 error that occurred when consumer groups were enforced but no
  proper configurations were provided. Now, if no specific consumer group
  configuration exists, the consumer group defaults to the original plugin
  configuration.

  * Fixed a timer leak that caused the timers to be exhausted and failed to
  start any other timers used by Kong, showing the error `too many pending timers`.

    Before, the plugin used one timer for each namespace maintenance process,
    increasing timer usage on instances with a large number of rate limiting
    namespaces. Now, it uses a single timer for all namespace maintenance.

  * Fixed an issue where the `local` strategy was not working with DB-less
  and hybrid deployments. We now allow `sync_rate = null` and `sync_rate = -1`
  when a `local` strategy is defined.

* [Exit Transformer](/hub/kong-inc/exit-transformer/) (`exit-transformer`)
  * Fixed an issue where the Exit Transformer plugin
  would break the plugin iterator, causing later plugins not to run.

* [mTLS Authentication](/hub/kong-inc/mtls-auth/) (`mtls-auth`)

  * Fixed `attempt to index local 'workspace'` error, which occurred when
  accessing Routes or Services using TLS.

* [OAuth2 Introspection](/hub/kong-inc/oauth2-introspection/) (`oauth2-introspection`)

  * Fixed issues with TLS connections when the IDP is behind a reverse proxy.

* [Proxy Cache Advanced](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cache-advanced`)

  * Fixed a `X-Cache-Status:Miss` error that occurred when caching large files.

* [Proxy Cache Advanced](/hub/kong-inc/proxy-cache-advanced/) (`proxy-cache-advanced`)

  * Fixed a `X-Cache-Status:Miss` error that occurred when caching large files.

* [Response Transformer Advanced](/hub/kong-inc/response-transformer-advanced/) (`response-transformer-advanced`)

  * In the `body_filter` phase, the plugin now sets the body to an empty string
  instead of `nil`.

* [jq](/hub/kong-inc/jq/) (`jq`)

  * If plugin has no output, it will now return the raw body instead of attempting
  to restore the original response body.

* [OpenID Connect](/hub/kong-inc/openid-connect/) (`openid-connect`)

  * Fixed negative caching, which was loading wrong a configuration value.

* [JWT Signer](/hub/kong-inc/jwt-signer/) (`jwt-signer`)

  * Fixed an issue where the `enable_hs_signatures` configuration
  parameter did not work. The plugin now defines expiry earlier to avoid
  arithmetic on a nil value.

### Dependencies
* Bumped OpenSSL from 1.1.1l to 1.1.1m
[#8191](https://github.com/Kong/kong/pull/8191)
* Bumped `resty.session` from 3.8 to 3.10
[#8294](https://github.com/Kong/kong/pull/8294)
* Bumped `lua-resty-openssl` to 0.8.5
[#8368](https://github.com/Kong/kong/pull/8368)
* Bumped `lodash` for Dev Portal from 4.17.11 to 4.17.21
* Bumped `lodash` for Kong Manager from 4.17.15 to 4.17.21

### Deprecated

* The external `go-pluginserver` project is considered deprecated in favor of
  the [embedded server approach](/gateway/latest/reference/external-plugins/).

* Starting with Kong Gateway 2.8.0.0, Kong is not building new open-source
CentOS images. Support for running open-source Kong Gateway on CentOS on is now
deprecated, as [CentOS has reached End of Life (OEL)](https://www.centos.org/centos-linux-eol/).

    Running Kong Gateway Enterprise on CentOS is currently supported, but CentOS
    is planned to be fully deprecated in Kong Gateway 3.x.x.

* OpenID Connect plugin: The `session_redis_auth` field is
  now deprecated and planned to be removed in 3.x.x. Use
  `session_redis_username` and `session_redis_password` instead.

* Forward Proxy Advanced plugin: The `proxy_port` and `proxy_host` fields are
now deprecated and planned to be removed in 3.x.x. Use
`http_proxy_host` and `http_proxy_port`, or `https_proxy_host` and
`https_proxy_port` instead.

* AWS Lambda plugin: The `proxy_scheme` field is now deprecated and planned to
be removed in 3.x.x.
