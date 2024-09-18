---
title: deck file kong2tf
content_type: reference
---


The `kong2tf` subcommand transforms Kong's configuration files, written in the decK format, into Terraform resources. This tool serves as a bridge for deploying API configurations from decK files directly to {{site.konnect_product_name}}, facilitating integration into the final stages of an APIOps pipeline. Essentially, `kong2tf` translates the desired API configurations into a format that Terraform can deploy, ensuring that the API's intended state is accurately reflected in the {{site.konnect_short_name}} environment.


Let's see an example of how the following decK state file is converted to Ingress API Kubernetes 
manifests and Gateway API Kubernetes manifests. 

{% navtabs %}
{% navtab decK state file %}

```yaml
_format_version: "3.0"
_konnect:
  control_plane_name: CP With Everything
ca_certificates:
  - cert: |-
      -----BEGIN CERTIFICATE-----
      MIIBwDCCAUagAwIBAgIUMDCK/a+EH6a9PvQeyFwHDALYrx0wCgYIKoZIzj0EAwIw
      FzEVMBMGA1UEAwwMa29uZ190ZXN0X2NhMB4XDTI0MDkwODE3NDUxMFoXDTI3MDkw
      ODE3NDUxMFowFzEVMBMGA1UEAwwMa29uZ190ZXN0X2NhMHYwEAYHKoZIzj0CAQYF
      K4EEACIDYgAEYEP63cMf47Xf6QcH9QT8ehjxBAbfF68PdCXOPgKZdSFvRYs+JZ+Y
      dIhWV4M06WiEP8Exn352xuzgZc4mVT9B6SpAsp+hsyJ9ZkuQkyb0lC1XodP5+ZlF
      yP0dZHkPYQ5Po1MwUTAdBgNVHQ4EFgQUYS5tJ4WfzVaNsB2oYrJOEf2WJ/UwHwYD
      VR0jBBgwFoAUYS5tJ4WfzVaNsB2oYrJOEf2WJ/UwDwYDVR0TAQH/BAUwAwEB/zAK
      BggqhkjOPQQDAgNoADBlAjBCIF9CB1CuRkdRpdjHq/x2G1TJkj622L80+Emvkctw
      IdyXs8Vp2gHrLjpbBAKoWAgCMQD0E/fjMNr0FAce66MlpKSxdKbeUGt7Zv3Gauld
      3jeXOUCitQiKp60wg0IhAslBoEM=
      -----END CERTIFICATE-----
    cert_digest: ef407ce6a2f2c0b68c24a31cf7c75dfd6fd850d631775545f17b6d67b4b93c64
    id: c878251f-35b1-403d-987f-89554e98f8bb
certificates:
  - cert: |-
      -----BEGIN CERTIFICATE-----
      MIIBxzCCAUygAwIBAgIUfCAyT/813MlPQFqasFetYcAdPVYwCgYIKoZIzj0EAwIw
      GjEYMBYGA1UEAwwPa29uZ19jbHVzdGVyaW5nMB4XDTI0MDkwODE3NDQzNloXDTI3
      MDkwODE3NDQzNlowGjEYMBYGA1UEAwwPa29uZ19jbHVzdGVyaW5nMHYwEAYHKoZI
      zj0CAQYFK4EEACIDYgAEygTwKjbWvTvj0AlmNfxXFaPFbOctV0LA9D4aUzdG8dPg
      3bZEco1wWKNY1ucs7sFO51T6oPuI77nHv+owCMLbS7Cx2m7Tdkdibp63ejggiogZ
      U6er9tNWI7kF3NJos8mdo1MwUTAdBgNVHQ4EFgQUrpk2dywGsqDcrr1lNPhEQT7n
      3OMwHwYDVR0jBBgwFoAUrpk2dywGsqDcrr1lNPhEQT7n3OMwDwYDVR0TAQH/BAUw
      AwEB/zAKBggqhkjOPQQDAgNpADBmAjEAuotEtPBtrU1loNBwxpWWbeJ3cH8yJVb7
      jtAqcs3KC2nZa+gDbzCQgePjL1nQ7M2yAjEAootOUs9SiFh89TbjEpjYX0JTV1sX
      3aHopOi30aG8yuGRkC8NAn85+YpjVvvk+dJC
      -----END CERTIFICATE-----
    id: f9a53112-2e73-4fc4-bb5f-4be86071e881
    key: |-
      -----BEGIN PRIVATE KEY-----
      MIG2AgEAMBAGByqGSM49AgEGBSuBBAAiBIGeMIGbAgEBBDCjxfLtYRbO+4501Zx4
      bwN2BK/yDugQ/p1uA+yz6Z02oOPbPq0eWl5iZTp7LsxpHP+hZANiAATKBPAqNta9
      O+PQCWY1/FcVo8Vs5y1XQsD0PhpTN0bx0+DdtkRyjXBYo1jW5yzuwU7nVPqg+4jv
      uce/6jAIwttLsLHabtN2R2Junrd6OCCKiBlTp6v201YjuQXc0mizyZ0=
      -----END PRIVATE KEY-----
    snis:
      - id: 68bd0d63-6ec7-4e6e-aa03-e7093e272c5b
        name: foo.example.com
    tags:
      - kong-clustering
consumer_groups:
  - id: 56d3cf4b-defc-4f55-a0d9-078b083bfe63
    name: gold
    plugins:
      - config:
          day: null
          error_code: 429
          error_message: API rate limit exceeded
          fault_tolerant: true
          header_name: null
          hide_client_headers: false
          hour: 10000
          limit_by: consumer
          minute: null
          month: null
          path: null
          policy: local
          redis:
            database: 0
            host: null
            password: null
            port: 6379
            server_name: null
            ssl: false
            ssl_verify: false
            timeout: 2000
            username: null
          redis_database: 0
          redis_host: null
          redis_password: null
          redis_port: 6379
          redis_server_name: null
          redis_ssl: false
          redis_ssl_verify: false
          redis_timeout: 2000
          redis_username: null
          second: null
          sync_rate: -1
          year: null
        id: 793f5bd6-8ec4-4fff-afeb-9787be181b49
        name: rate-limiting
    tags:
      - gold
      - alice
consumers:
  - acls:
      - group: group-a
        id: b482b4f7-069a-4ca8-876c-4e9dadbdcecc
        tags:
          - alice
          - group-a
    basicauth_credentials:
      - id: 43d95734-64cd-4c11-929d-c26d9e7f305a
        password: 60cf54018b3a0264fb19517f8214dddaa4d83ab7
        username: alice
    custom_id: alice123
    groups:
      - id: 56d3cf4b-defc-4f55-a0d9-078b083bfe63
        name: gold
        tags:
          - gold
          - alice
    hmacauth_credentials:
      - id: c85a1ce8-37f6-4114-a314-fcedae367b38
        secret: alicesecret
        username: aliceuser
    id: bdd14928-4c9c-4572-a266-29a6e1602663
    jwt_secrets:
      - algorithm: HS256
        id: ce19c10f-4a06-4016-b22f-07216c9a56b2
        key: alicejwtkey
        secret: alicejwtsecret
    keyauth_credentials:
      - id: faf3581a-d131-42d9-a0de-7c6dee9a072a
        key: alicekey
        tags:
          - alice
    plugins:
      - config:
          day: null
          error_code: 429
          error_message: API rate limit exceeded
          fault_tolerant: true
          header_name: null
          hide_client_headers: false
          hour: 10
          limit_by: consumer
          minute: null
          month: null
          path: null
          policy: local
          redis:
            database: 0
            host: null
            password: null
            port: 6379
            server_name: null
            ssl: false
            ssl_verify: false
            timeout: 2000
            username: null
          redis_database: 0
          redis_host: null
          redis_password: null
          redis_port: 6379
          redis_server_name: null
          redis_ssl: false
          redis_ssl_verify: false
          redis_timeout: 2000
          redis_username: null
          second: null
          sync_rate: -1
          year: null
        enabled: true
        id: bf7626c4-8383-4cda-b3f3-80fa75bd2121
        name: rate-limiting
        protocols:
          - grpc
          - grpcs
          - http
          - https
    username: alice
  - custom_id: bob456
    id: b2e8673d-8ed5-49cf-be9c-b3c93640c7a6
    tags:
      - bob
    username: bob
plugins:
  - config:
      anonymous: null
      hide_credentials: false
      key_in_body: false
      key_in_header: true
      key_in_query: true
      key_names:
        - apikey-global
      realm: null
      run_on_preflight: true
    enabled: true
    id: 600c38c5-da4b-4ec5-b3b8-70fc279a6503
    name: key-auth
    protocols:
      - grpc
      - grpcs
      - http
      - https
      - ws
      - wss
  - config:
      anonymous: null
      hide_credentials: false
      key_in_body: false
      key_in_header: true
      key_in_query: true
      key_names:
        - apikey-in-route
      realm: null
      run_on_preflight: true
    enabled: true
    id: efa261d5-7978-4c8f-84e5-c6b0387ba37c
    name: key-auth
    protocols:
      - grpc
      - grpcs
      - http
      - https
      - ws
      - wss
    route: route-in-service
    service: httpbin
routes:
  - https_redirect_status_code: 426
    id: 7a8141cc-aade-49b2-a6c0-a95b624c1b6f
    name: route-standalone
    path_handling: v0
    paths:
      - /
    preserve_host: false
    protocols:
      - http
      - https
    regex_priority: 0
    request_buffering: true
    response_buffering: true
    strip_path: true
services:
  - connect_timeout: 60000
    enabled: true
    host: httpbin.org
    id: 0cc39546-f5c9-4aae-898c-c63ef5b4a33b
    name: httpbin
    plugins:
      - config:
          anonymous: null
          hide_credentials: false
          key_in_body: false
          key_in_header: true
          key_in_query: true
          key_names:
            - apikey-service
          realm: null
          run_on_preflight: true
        enabled: true
        id: 44a6f30a-23d6-4522-9ce8-f56243a054e3
        name: key-auth
        protocols:
          - grpc
          - grpcs
          - http
          - https
          - ws
          - wss
    port: 443
    protocol: https
    read_timeout: 60000
    retries: 5
    routes:
      - https_redirect_status_code: 426
        id: 9ac61ee8-4de7-4d75-82af-b7624ec5fb33
        name: route-in-service
        path_handling: v0
        paths:
          - /
        preserve_host: false
        protocols:
          - http
          - https
        regex_priority: 0
        request_buffering: true
        response_buffering: true
        strip_path: true
    write_timeout: 60000
upstreams:
  - algorithm: round-robin
    hash_fallback: none
    hash_on: none
    hash_on_cookie_path: /
    healthchecks:
      active:
        concurrency: 10
        healthy:
          http_statuses:
            - 200
            - 302
          interval: 0
          successes: 0
        http_path: /
        https_verify_certificate: true
        timeout: 1
        type: http
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
          interval: 0
          tcp_failures: 0
          timeouts: 0
      passive:
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
        type: http
        unhealthy:
          http_failures: 0
          http_statuses:
            - 429
            - 500
            - 503
          tcp_failures: 0
          timeouts: 0
      threshold: 0
    id: d8432ca0-b6c5-4c82-bad8-924c56fb2d04
    name: my-upstream
    slots: 10000
    targets:
      - id: eca40df5-a499-4611-86e8-b377d1b3acdb
        target: a.example.com:443
        weight: 100
      - id: 69f683b9-796f-4117-8461-7bc0a21e5d53
        target: b.example.com:443
        weight: 100
    use_srv_name: false
vaults:
  - config:
      prefix: none
    id: 5370372e-9bab-47c9-a8de-b6af35cfb170
    name: env
    prefix: my-env-vault
```

{% endnavtab %}
{% navtab Convert to Terraform %}

```tf
variable "control_plane_id" {
  type = "string"
  default = "YOUR_CONTROL_PLANE_ID"
}

resource "konnect_gateway_plugin_key_auth" "key_auth" {
  enabled = true
  config = {
    hide_credentials = false
    key_in_body = false
    key_in_header = true
    key_in_query = true
    key_names = ["apikey-global"]
    run_on_preflight = true
  }
  protocols = ["grpc", "grpcs", "http", "https", "ws", "wss"]

  control_plane_id = var.control_plane_id
}

resource "konnect_gateway_plugin_key_auth" "route_in_service_httpbin_key_auth" {
  enabled = true
  config = {
    hide_credentials = false
    key_in_body = false
    key_in_header = true
    key_in_query = true
    key_names = ["apikey-in-route"]
    run_on_preflight = true
  }
  protocols = ["grpc", "grpcs", "http", "https", "ws", "wss"]

  service = {
    id = konnect_gateway_service.httpbin.id
  }

  route = {
    id = konnect_gateway_route.route_in_service.id
  }

  control_plane_id = var.control_plane_id
}

resource "konnect_gateway_service" "httpbin" {
  enabled = true
  name = "httpbin"
  connect_timeout = 60000
  host = "httpbin.org"
  port = 443
  protocol = "https"
  read_timeout = 60000
  retries = 5
  write_timeout = 60000

  control_plane_id = var.control_plane_id
}

resource "konnect_gateway_route" "route_in_service" {
  name = "route-in-service"
  https_redirect_status_code = 426
  path_handling = "v0"
  paths = ["/"]
  preserve_host = false
  protocols = ["http", "https"]
  regex_priority = 0
  request_buffering = true
  response_buffering = true
  strip_path = true

  service = {
    id = konnect_gateway_service.httpbin.id
  }

  control_plane_id = var.control_plane_id
}

resource "konnect_gateway_plugin_key_auth" "httpbin_key_auth" {
  enabled = true
  config = {
    hide_credentials = false
    key_in_body = false
    key_in_header = true
    key_in_query = true
    key_names = ["apikey-service"]
    run_on_preflight = true
  }
  protocols = ["grpc", "grpcs", "http", "https", "ws", "wss"]

  service = {
    id = konnect_gateway_service.httpbin.id
  }

  control_plane_id = var.control_plane_id
}

resource "konnect_gateway_upstream" "upstream_my_upstream" {
  name = "my-upstream"
  algorithm = "round-robin"
  hash_fallback = "none"
  hash_on = "none"
  hash_on_cookie_path = "/"
  healthchecks = {
    active = {
      concurrency = 10
      healthy = {
        http_statuses = [200, 302]
        interval = 0
        successes = 0
      }
      http_path = "/"
      https_verify_certificate = true
      timeout = 1
      type = "http"
      unhealthy = {
        http_failures = 0
        http_statuses = [429, 404, 500, 501, 502, 503, 504, 505]
        interval = 0
        tcp_failures = 0
        timeouts = 0
      }
    }
    passive = {
      healthy = {
        http_statuses = [200, 201, 202, 203, 204, 205, 206, 207, 208, 226, 300, 301, 302, 303, 304, 305, 306, 307, 308]
        successes = 0
      }
      type = "http"
      unhealthy = {
        http_failures = 0
        http_statuses = [429, 500, 503]
        tcp_failures = 0
        timeouts = 0
      }
    }
    threshold = 0
  }
  slots = 10000
  use_srv_name = false

  control_plane_id = var.control_plane_id
}

resource "konnect_gateway_target" "upstream_my_upstream_target_a_example_com_443" {
  target = "a.example.com:443"
  weight = 100

  upstream_id = konnect_gateway_upstream.upstream_my_upstream.id

  control_plane_id = var.control_plane_id
}

resource "konnect_gateway_target" "upstream_my_upstream_target_b_example_com_443" {
  target = "b.example.com:443"
  weight = 100

  upstream_id = konnect_gateway_upstream.upstream_my_upstream.id

  control_plane_id = var.control_plane_id
}

resource "konnect_gateway_route" "route_standalone" {
  name = "route-standalone"
  https_redirect_status_code = 426
  path_handling = "v0"
  paths = ["/"]
  preserve_host = false
  protocols = ["http", "https"]
  regex_priority = 0
  request_buffering = true
  response_buffering = true
  strip_path = true

  control_plane_id = var.control_plane_id
}

resource "konnect_gateway_consumer" "alice" {
  username = "alice"
  custom_id = "alice123"

  control_plane_id = var.control_plane_id
}

resource "konnect_gateway_consumer_group_member" "gold_alice" {
  consumer_id = konnect_gateway_consumer.alice.id
  consumer_group_id = konnect_gateway_consumer_group.gold.id
  control_plane_id = var.control_plane_id
}

resource "konnect_gateway_acl" "alice_acl_group_a" {
  group = "group-a"
  tags = ["alice", "group-a"]

  consumer_id = konnect_gateway_consumer.alice.id

  control_plane_id = var.control_plane_id
}

resource "konnect_gateway_basic_auth" "alice_basic_auth_alice" {
  username = "alice"
  password = "60cf54018b3a0264fb19517f8214dddaa4d83ab7"

  consumer_id = konnect_gateway_consumer.alice.id

  control_plane_id = var.control_plane_id
}

resource "konnect_gateway_key_auth" "alice_key_auth_alicekey" {
  key = "alicekey"
  tags = ["alice"]

  consumer_id = konnect_gateway_consumer.alice.id

  control_plane_id = var.control_plane_id
}

resource "konnect_gateway_jwt" "alice_jwt_alicejwtkey" {
  algorithm = "HS256"
  key = "alicejwtkey"
  secret = "alicejwtsecret"

  consumer_id = konnect_gateway_consumer.alice.id

  control_plane_id = var.control_plane_id
}

resource "konnect_gateway_hmac_auth" "alice_hmac_auth_aliceuser" {
  username = "aliceuser"
  secret = "alicesecret"

  consumer_id = konnect_gateway_consumer.alice.id

  control_plane_id = var.control_plane_id
}

resource "konnect_gateway_plugin_rate_limiting" "alice_rate_limiting" {
  enabled = true
  config = {
    error_code = 429
    error_message = "API rate limit exceeded"
    fault_tolerant = true
    hide_client_headers = false
    hour = 10
    limit_by = "consumer"
    policy = "local"
    redis = {
      database = 0
      port = 6379
      ssl = false
      ssl_verify = false
      timeout = 2000
    }
    redis_database = 0
    redis_port = 6379
    redis_ssl = false
    redis_ssl_verify = false
    redis_timeout = 2000
    sync_rate = -1
  }
  protocols = ["grpc", "grpcs", "http", "https"]

  consumer = {
    id = konnect_gateway_consumer.alice.id
  }

  control_plane_id = var.control_plane_id
}

resource "konnect_gateway_consumer" "bob" {
  username = "bob"
  custom_id = "bob456"
  tags = ["bob"]

  control_plane_id = var.control_plane_id
}

resource "konnect_gateway_consumer_group" "gold" {
  name = "gold"
  tags = ["gold", "alice"]

  control_plane_id = var.control_plane_id
}

resource "konnect_gateway_plugin_rate_limiting" "gold_rate_limiting" {
  config = {
    error_code = 429
    error_message = "API rate limit exceeded"
    fault_tolerant = true
    hide_client_headers = false
    hour = 10000
    limit_by = "consumer"
    policy = "local"
    redis = {
      database = 0
      port = 6379
      ssl = false
      ssl_verify = false
      timeout = 2000
    }
    redis_database = 0
    redis_port = 6379
    redis_ssl = false
    redis_ssl_verify = false
    redis_timeout = 2000
    sync_rate = -1
  }

  consumer_group = {
    id = konnect_gateway_consumer_group.gold.id
  }

  control_plane_id = var.control_plane_id
}

resource "konnect_gateway_ca_certificate" "ca_cert_cb3de215987a2a50e5fc5a567e5837ad" {
  cert = <<EOF
-----BEGIN CERTIFICATE-----
MIIBwDCCAUagAwIBAgIUMDCK/a+EH6a9PvQeyFwHDALYrx0wCgYIKoZIzj0EAwIw
FzEVMBMGA1UEAwwMa29uZ190ZXN0X2NhMB4XDTI0MDkwODE3NDUxMFoXDTI3MDkw
ODE3NDUxMFowFzEVMBMGA1UEAwwMa29uZ190ZXN0X2NhMHYwEAYHKoZIzj0CAQYF
K4EEACIDYgAEYEP63cMf47Xf6QcH9QT8ehjxBAbfF68PdCXOPgKZdSFvRYs+JZ+Y
dIhWV4M06WiEP8Exn352xuzgZc4mVT9B6SpAsp+hsyJ9ZkuQkyb0lC1XodP5+ZlF
yP0dZHkPYQ5Po1MwUTAdBgNVHQ4EFgQUYS5tJ4WfzVaNsB2oYrJOEf2WJ/UwHwYD
VR0jBBgwFoAUYS5tJ4WfzVaNsB2oYrJOEf2WJ/UwDwYDVR0TAQH/BAUwAwEB/zAK
BggqhkjOPQQDAgNoADBlAjBCIF9CB1CuRkdRpdjHq/x2G1TJkj622L80+Emvkctw
IdyXs8Vp2gHrLjpbBAKoWAgCMQD0E/fjMNr0FAce66MlpKSxdKbeUGt7Zv3Gauld
3jeXOUCitQiKp60wg0IhAslBoEM=
-----END CERTIFICATE-----
EOF
  cert_digest = "ef407ce6a2f2c0b68c24a31cf7c75dfd6fd850d631775545f17b6d67b4b93c64"

  control_plane_id = var.control_plane_id
}

resource "konnect_gateway_certificate" "cert_da6db9d072d2cce9a9e1003f2d28dca3" {
  cert = <<EOF
-----BEGIN CERTIFICATE-----
MIIBxzCCAUygAwIBAgIUfCAyT/813MlPQFqasFetYcAdPVYwCgYIKoZIzj0EAwIw
GjEYMBYGA1UEAwwPa29uZ19jbHVzdGVyaW5nMB4XDTI0MDkwODE3NDQzNloXDTI3
MDkwODE3NDQzNlowGjEYMBYGA1UEAwwPa29uZ19jbHVzdGVyaW5nMHYwEAYHKoZI
zj0CAQYFK4EEACIDYgAEygTwKjbWvTvj0AlmNfxXFaPFbOctV0LA9D4aUzdG8dPg
3bZEco1wWKNY1ucs7sFO51T6oPuI77nHv+owCMLbS7Cx2m7Tdkdibp63ejggiogZ
U6er9tNWI7kF3NJos8mdo1MwUTAdBgNVHQ4EFgQUrpk2dywGsqDcrr1lNPhEQT7n
3OMwHwYDVR0jBBgwFoAUrpk2dywGsqDcrr1lNPhEQT7n3OMwDwYDVR0TAQH/BAUw
AwEB/zAKBggqhkjOPQQDAgNpADBmAjEAuotEtPBtrU1loNBwxpWWbeJ3cH8yJVb7
jtAqcs3KC2nZa+gDbzCQgePjL1nQ7M2yAjEAootOUs9SiFh89TbjEpjYX0JTV1sX
3aHopOi30aG8yuGRkC8NAn85+YpjVvvk+dJC
-----END CERTIFICATE-----
EOF
  key = <<EOF
-----BEGIN PRIVATE KEY-----
MIG2AgEAMBAGByqGSM49AgEGBSuBBAAiBIGeMIGbAgEBBDCjxfLtYRbO+4501Zx4
bwN2BK/yDugQ/p1uA+yz6Z02oOPbPq0eWl5iZTp7LsxpHP+hZANiAATKBPAqNta9
O+PQCWY1/FcVo8Vs5y1XQsD0PhpTN0bx0+DdtkRyjXBYo1jW5yzuwU7nVPqg+4jv
uce/6jAIwttLsLHabtN2R2Junrd6OCCKiBlTp6v201YjuQXc0mizyZ0=
-----END PRIVATE KEY-----
EOF
  tags = ["kong-clustering"]

  control_plane_id = var.control_plane_id
}

resource "konnect_gateway_sni" "sni_foo_example_com" {
  name = "foo.example.com"

  certificate = {
    id = konnect_gateway_certificate.cert_da6db9d072d2cce9a9e1003f2d28dca3.id
  }

  control_plane_id = var.control_plane_id
}

resource "konnect_gateway_vault" "env" {
  name = "env"
  config = jsonencode({
    prefix = "none"
  })
  prefix = "my-env-vault"

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
deck file kong2tf -s ./kong.yaml --generate-imports-for-control-plane-id "0dea9abf-074a-4988-bdd6-c9ea1ea25d4b" --ignore-credential-changes

```

## Flags

`-g`, `--generate-imports-for-control-plane-id`
: `import` blocks will be added to Terraform to adopt existing resources.

`--ignore-credential-changes`
: credentials will be ignored until they are destroyed and recreated.

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


