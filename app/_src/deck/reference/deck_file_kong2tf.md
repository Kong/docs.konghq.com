---
title: deck file kong2tf
source_url: https://github.com/Kong/deck/tree/main/cmd/file_kong2tf.go
content_type: reference
---


The `kong2tf` subcommand transforms Kong's configuration files, written in the decK format, into Terraform resources. This tool serves as a bridge for deploying API configurations from decK files directly to {{site.konnect_product_name}}, facilitating integration into the final stages of an APIOps pipeline. Essentially, `kong2tf` translates the desired API configurations into a format that Terraform can deploy, ensuring that the API's intended state is accurately reflected in the {{site.konnect_short_name}} environment.


Let's see an example of how the following decK state file is converted to Ingress API Kubernetes 
manifests and Gateway API Kubernetes manifests. 

{% navtabs %}
{% navtab decK state file %}

```yaml
vaults:
- config:
    prefix: MY_SECRET_
  description: ENV vault for secrets
  name: env
  prefix: my-env-vault
  tags:
    - env-vault
plugins:
- name: openid-connect
  config:
    auth_methods:
    - authorization_code
    - session
    issuer: http://example.org
    client_id:
    - "<client-id>"
    client_secret:
    - "<client-secret>"
    session_secret: "<session-secret>"
    response_mode: form_post
services:
  - name: example-service
    url: http://example-api.com
    protocol: http
    host: example-api.com
    port: 80
    path: /v1
    retries: 5
    connect_timeout: 5000
    write_timeout: 60000
    read_timeout: 60000
    enabled: true
    client_certificate: 4e3ad2e4-0bc4-4638-8e34-c84a417ba39b
    plugins:
      - name: rate-limiting-advanced
        config:
          limit:
          - 5
          window_size:
          - 30
          identifier: consumer
          sync_rate: -1
          namespace: example_namespace
          strategy: local
          hide_client_headers: false
        ordering:
          before:
            access: 
              - another-plugin
          after:
            access: 
              - yet-another-plugin
    tags:
      - example
      - api
    routes:
      - name: example-route
        methods:
          - GET
          - POST
        hosts:
          - example.com
          - another-example.com
          - yet-another-example.com
        paths:
          - ~/v1/example/?$
          - /v1/another-example
          - /v1/yet-another-example
        protocols:
          - http
          - https
        headers:
          x-my-header:
            - ~*foos?bar$
          x-another-header:
            - first-header-value
            - second-header-value
        regex_priority: 1
        strip_path: false
        preserve_host: true
        tags:
          - version:v1
        https_redirect_status_code: 302
        snis:
          - example.com
        plugins:
          - name: aws-lambda
            config:
              aws_key: my_key
              aws_secret: my_secret
              function_name: my_function
              aws_region: us-west-2
          - name: cors
            config:
              origins:
                - example.com
              methods:
                - GET
                - POST
              headers:
                - Authorization
              exposed_headers:
                - X-My-Header
              max_age: 3600
              credentials: true
          - name: file-log
            config:
              path: /var/log/kong/kong.log
              reopen: true
          - name: ip-restriction
            config:
              allow:
                - 192.168.0.1/24
              deny:
                - 192.168.0.2/32
          - name: rate-limiting-advanced
            config:
              limit:
              - 5
              window_size:
              - 30
              identifier: consumer
              sync_rate: -1
              namespace: example_namespace
              strategy: local
              hide_client_headers: false
          - name: request-termination
            config:
              status_code: 403
              message: Forbidden
          - name: basic-auth
            config:
              hide_credentials: false
          - name: jwt
            config:
              uri_param_names:
                - token
              claims_to_verify:
                - exp
                - nbf
              key_claim_name: kid
              secret_is_base64: false
              anonymous: null
              run_on_preflight: true
              maximum_expiration: 3600
              header_names:
                - Authorization
          - name: key-auth
            config:
              hide_credentials: false
              key_names:
                - apikey
              key_in_body: false
              run_on_preflight: true
          - name: acl
            config:
              allow: 
                - admin
upstreams:
  - name: example-api.com
    algorithm: round-robin
    hash_on: none
    hash_fallback: none
    hash_on_cookie_path: "/"
    slots: 10000
    healthchecks:
      passive:
        type: http
        healthy:
          http_statuses:
          - 200
          - 201
          - 202
          - 203
          - 204
          - 205
          - 206
          - 207
          - 208
          - 226
          - 300
          - 301
          - 302
          - 303
          - 304
          - 305
          - 306
          - 307
          - 308
          successes: 0
        unhealthy:
          http_statuses:
          - 429
          - 500
          - 503
          timeouts: 0
          http_failures: 0
          tcp_failures: 0
      active:
        https_verify_certificate: true
        healthy:
          http_statuses:
          - 200
          - 302
          successes: 0
          interval: 0
        unhealthy:
          http_failures: 0
          http_statuses:
          - 429
          - 404
          - 500
          - 501
          - 502
          - 503
          - 504
          - 505
          timeouts: 0
          tcp_failures: 0
          interval: 0
        type: http
        concurrency: 10
        headers:
          x-my-header:
            - foo
            - bar
          x-another-header:
            - bla
        timeout: 1
        http_path: "/"
        https_sni: example.com
      threshold: 0
    tags:
    - user-level
    - low-priority
    host_header: example.com
    use_srv_name: false
    targets:
    - target: 10.10.10.10:8000
      weight: 100
    - target: 10.10.10.11:8000
      weight: 100
consumers:
  - username: example-user
    custom_id: "1234567890"
    tags:
      - internal
    acls:
      - group: acl_group
        tags:
          - internal
    basicauth_credentials:
      - username: my_basic_user
        password: my_basic_password
        tags:
          - internal
    jwt_secrets:
      - key: my_jwt_secret
        algorithm: HS256
        secret: my_secret_key
        tags:
          - internal
    keyauth_credentials:
      - key: my_api_key
        tags:
          - internal
    mtls_auth_credentials:
      - id: cce8c384-721f-4f58-85dd-50834e3e733a
        subject_name: example-user@example.com
    plugins:
      - name: rate-limiting-advanced
        config:
          limit:
          - 5
          window_size:
          - 30
          identifier: consumer
          sync_rate: -1
          namespace: example_namespace
          strategy: local
          hide_client_headers: false
consumer_groups:
  - name: example-consumer-group
    consumers:
      - username: example-user
    plugins:
      - name: rate-limiting-advanced
        config:
          limit:
          - 5
          window_size:
          - 30
          identifier: consumer
          sync_rate: -1
          namespace: example_namespace
          strategy: local
          hide_client_headers: false
          window_type: sliding
          retry_after_jitter_max: 0
```

{% endnavtab %}
{% navtab Convert to Terraform %}

```tf
resource "konnect_gateway_plugin_openid_connect" "openid-connect" {
  config = {"auth_methods":["authorization_code","session"],"client_id":["\u003cclient-id\u003e"],"client_secret":["\u003cclient-secret\u003e"],"issuer":"http://example.org","response_mode":"form_post","session_secret":"\u003csession-secret\u003e"}
  control_plane_id = var.control_plane_id
}
resource "konnect_gateway_service" "example-service" {
  name             = "example-service"
  protocol         = "http"
  host             = "example-api.com"
  port             = 80
  path             = "/v1"
  connect_timeout  = 5000
  read_timeout     = 60000
  write_timeout    = 60000
  retries          = 5
  tags             = ["example", "api"]
  control_plane_id = var.control_plane_id
}
resource "konnect_gateway_plugin_rate_limiting_advanced" "example-service_rate-limiting-advanced" {
  config = {"hide_client_headers":false,"identifier":"consumer","limit":[5],"namespace":"example_namespace","strategy":"local","sync_rate":-1,"window_size":[30]}
  service = {
    id = konnect_gateway_service.example-service.id
  }
  control_plane_id = var.control_plane_id
}
resource "konnect_gateway_upstream" "example-apicom" {
  name             = "example-api.com"
  slots            = 10000
  host_header      = "example.com"
  algorithm        = "round-robin"
  hash_on          = "none"
  hash_fallback    = "none"
  hash_on_cookie_path = "/"
  use_srv_name     = false
  tags             = ["user-level", "low-priority"]
  healthchecks = {
    active = {
        concurrency = 10
        http_path = "/"
        https_sni = "example.com"
        https_verify_certificate = true
        timeout = 1
        type = "http"
        headers = {
          "x-another-header" = jsonencode(["bla"])
          "x-my-header" = jsonencode(["foo","bar"])
        }
      healthy = {
        http_statuses = [200, 302]
        interval = 0
        successes = 0
      }
      unhealthy = {
        http_failures = 0
        http_statuses = [429, 404, 500, 501, 502, 503, 504, 505]
        tcp_failures = 0
        timeouts = 0
        interval = 0
      }
    }
    passive = {
        healthy = {
            http_statuses = [200, 201, 202, 203, 204, 205, 206, 207, 208, 226, 300, 301, 302, 303, 304, 305, 306, 307, 308]
            successes = 0
        }
        unhealthy = {
            http_failures = 0
            http_statuses = [429, 500, 503]
            tcp_failures = 0
            timeouts = 0
        }
        type = "http"
    }
  }
  control_plane_id = var.control_plane_id
}
resource "konnect_gateway_target" "example-apicom_101010108000" {
  target           = "10.10.10.10:8000"
  weight           = 100
  upstream_id      = konnect_gateway_upstream.example-apicom.id
  control_plane_id = var.control_plane_id
}
resource "konnect_gateway_target" "example-apicom_101010118000" {
  target           = "10.10.10.11:8000"
  weight           = 100
  upstream_id      = konnect_gateway_upstream.example-apicom.id
  control_plane_id = var.control_plane_id
}

  
resource "konnect_gateway_route" "example-route" {
  name = "example-route"
  hosts = ["example.com", "another-example.com", "yet-another-example.com"]
  headers = {
    "x-another-header" = jsonencode(["first-header-value","second-header-value"])
    "x-my-header" = jsonencode(["~*foos?bar$"])
  }
  methods = ["GET", "POST"]
  paths = ["~/v1/example/?$", "/v1/another-example", "/v1/yet-another-example"]
  preserve_host = true
  protocols = ["http", "https"]
  regex_priority = 1
  strip_path = false
  snis = ["example.com"]
  tags = ["version:v1"]
  https_redirect_status_code = 302
  service = {
    id = konnect_gateway_service.example-service.id
  }  
  control_plane_id = var.control_plane_id
}
resource "konnect_gateway_plugin_aws_lambda" "example-service_example-route_aws-lambda" {
  config = {"aws_key":"my_key","aws_region":"us-west-2","aws_secret":"my_secret","function_name":"my_function"}
  route = {
    id = konnect_gateway_route.example-route.id
  }
  control_plane_id = var.control_plane_id
}
resource "konnect_gateway_plugin_cors" "example-service_example-route_cors" {
  config = {"credentials":true,"exposed_headers":["X-My-Header"],"headers":["Authorization"],"max_age":3600,"methods":["GET","POST"],"origins":["example.com"]}
  route = {
    id = konnect_gateway_route.example-route.id
  }
  control_plane_id = var.control_plane_id
}
resource "konnect_gateway_plugin_file_log" "example-service_example-route_file-log" {
  config = {"path":"/var/log/kong/kong.log","reopen":true}
  route = {
    id = konnect_gateway_route.example-route.id
  }
  control_plane_id = var.control_plane_id
}
resource "konnect_gateway_plugin_ip_restriction" "example-service_example-route_ip-restriction" {
  config = {"allow":["192.168.0.1/24"],"deny":["192.168.0.2/32"]}
  route = {
    id = konnect_gateway_route.example-route.id
  }
  control_plane_id = var.control_plane_id
}
resource "konnect_gateway_plugin_rate_limiting_advanced" "example-service_example-route_rate-limiting-advanced" {
  config = {"hide_client_headers":false,"identifier":"consumer","limit":[5],"namespace":"example_namespace","strategy":"local","sync_rate":-1,"window_size":[30]}
  route = {
    id = konnect_gateway_route.example-route.id
  }
  control_plane_id = var.control_plane_id
}
resource "konnect_gateway_plugin_request_termination" "example-service_example-route_request-termination" {
  config = {"message":"Forbidden","status_code":403}
  route = {
    id = konnect_gateway_route.example-route.id
  }
  control_plane_id = var.control_plane_id
}
resource "konnect_gateway_plugin_basic_auth" "example-service_example-route_basic-auth" {
  config = {"hide_credentials":false}
  route = {
    id = konnect_gateway_route.example-route.id
  }
  control_plane_id = var.control_plane_id
}
resource "konnect_gateway_plugin_jwt" "example-service_example-route_jwt" {
  config = {"anonymous":null,"claims_to_verify":["exp","nbf"],"header_names":["Authorization"],"key_claim_name":"kid","maximum_expiration":3600,"run_on_preflight":true,"secret_is_base64":false,"uri_param_names":["token"]}
  route = {
    id = konnect_gateway_route.example-route.id
  }
  control_plane_id = var.control_plane_id
}
resource "konnect_gateway_plugin_key_auth" "example-service_example-route_key-auth" {
  config = {"hide_credentials":false,"key_in_body":false,"key_names":["apikey"],"run_on_preflight":true}
  route = {
    id = konnect_gateway_route.example-route.id
  }
  control_plane_id = var.control_plane_id
}
resource "konnect_gateway_plugin_acl" "example-service_example-route_acl" {
  config = {"allow":["admin"]}
  route = {
    id = konnect_gateway_route.example-route.id
  }
  control_plane_id = var.control_plane_id
}
resource "konnect_gateway_consumer" "example-user" {
  username         = "example-user"
  custom_id        = "1234567890"
  tags             = ["internal"]
  control_plane_id = var.control_plane_id
}
resource "konnect_gateway_key_auth" "example-user_my_api_key" {
  key              = "my_api_key"
  tags             = ["internal"]
  consumer_id      = konnect_gateway_consumer.example-user.id
  control_plane_id = var.control_plane_id
}
resource "konnect_gateway_jwt" "example-user_my_jwt_secret" {
  key              = "my_jwt_secret"
  algorithm        = "HS256"
  secret           = "my_secret_key"
  tags             = ["internal"]
  consumer_id      = konnect_gateway_consumer.example-user.id
  control_plane_id = var.control_plane_id
}
resource "konnect_gateway_basic_auth" "example-user_my_basic_user" {
  username         = "my_basic_user"
  password         = "my_basic_password"
  tags             = ["internal"]
  consumer_id      = konnect_gateway_consumer.example-user.id
  control_plane_id = var.control_plane_id
}
resource "konnect_gateway_acl" "example-user_acl_group" {
  group            = "acl_group"
  tags             = ["internal"]
  consumer_id      = konnect_gateway_consumer.example-user.id
  control_plane_id = var.control_plane_id
}
resource "konnect_gateway_plugin_rate_limiting_advanced" "example-user_rate-limiting-advanced" {
  config = {"hide_client_headers":false,"identifier":"consumer","limit":[5],"namespace":"example_namespace","strategy":"local","sync_rate":-1,"window_size":[30]}
  consumer = {
    id = konnect_gateway_consumer.example-user.id
  }
  control_plane_id = var.control_plane_id
}
resource "konnect_gateway_consumer_group" "example-consumer-group" {
  name             = "example-consumer-group"
  control_plane_id = var.control_plane_id
}
resource "konnect_gateway_consumer_group_member" "example-user" {
  consumer_id       = konnect_gateway_consumer.example-user.id
  consumer_group_id = konnect_gateway_consumer_group.example-consumer-group.id
  control_plane_id  = var.control_plane_id
}
resource "konnect_gateway_plugin_rate_limiting_advanced" "example-consumer-group_rate-limiting-advanced" {
  config = {"hide_client_headers":false,"identifier":"consumer","limit":[5],"namespace":"example_namespace","retry_after_jitter_max":0,"strategy":"local","sync_rate":-1,"window_size":[30],"window_type":"sliding"}
  consumer_group = {
    id = konnect_gateway_consumer_group.example-consumer-group.id
  }
  control_plane_id = var.control_plane_id
}
resource "konnect_gateway_vault" "env" {
  name   = "env"
  prefix = "my-env-vault"
  config = jsonencode({"prefix":"MY_SECRET_"})
  control_plane_id = var.control_plane_id
}

```

{% endnavtab %}
{% endnavtabs %}

## Syntax

```
deck file kong2tf [command-specific flags] [global flags]
```

## Examples

```
deck file kong2tf -s kong-config.yaml -o kong-config.tf

```

## Flags

`-o`, `--output-file`
:  Output file to write to. Use `-` to write to stdout. (Default: `"-"`)

`-s`, `--state`
:  decK state file to process. Use `-` to read from stdin. (Default: `"-"`)

`-h`, `--help`
:  Help for kong2tf.

## Global flags

{% include_cached /md/deck-global-flags.md release=page.release %}

## See also

{% include /md/deck-reference-links.md file_links='true' %}


