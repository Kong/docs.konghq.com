---
title: Admin API

toc: false

service_body: |
    Attributes | Description
    ---:| ---
    `name`<br>*optional* | The Service name.
    `retries`<br>*optional* | The number of retries to execute upon failure to proxy. Defaults to `5`.
    `protocol` |  The protocol used to communicate with the upstream. It can be one of `http` or `https`.  Defaults to `"http"`.
    `host` | The host of the upstream server.
    `port` | The upstream server port. Defaults to `80`.
    `path`<br>*optional* | The path to be used in requests to the upstream server.
    `connect_timeout`<br>*optional* |  The timeout in milliseconds for establishing a connection to the upstream server.  Defaults to `60000`.
    `write_timeout`<br>*optional* |  The timeout in milliseconds between two successive write operations for transmitting a request to the upstream server.  Defaults to `60000`.
    `read_timeout`<br>*optional* |  The timeout in milliseconds between two successive read operations for transmitting a request to the upstream server.  Defaults to `60000`.
    `url`<br>*shorthand-attribute* |  Shorthand attribute to set `protocol`, `host`, `port` and `path` at once. This attribute is write-only (the Admin API never "returns" the url). 

service_json: |
    {
        "id": "0c61e164-6171-4837-8836-8f5298726d53",
        "created_at": 1422386534,
        "updated_at": 1422386534,
        "name": "my-service",
        "retries": 5,
        "protocol": "http",
        "host": "example.com",
        "port": 80,
        "path": "/some_api",
        "connect_timeout": 60000,
        "write_timeout": 60000,
        "read_timeout": 60000
    }

service_data: |
    "data": [{
        "id": "f00c6da4-3679-4b44-b9fb-36a19bd3ae83",
        "created_at": 1422386534,
        "updated_at": 1422386534,
        "name": "my-service",
        "retries": 5,
        "protocol": "http",
        "host": "example.com",
        "port": 80,
        "path": "/some_api",
        "connect_timeout": 60000,
        "write_timeout": 60000,
        "read_timeout": 60000
    }, {
        "id": "bdab0e47-4e37-4f0b-8fd0-87d95cc4addc",
        "created_at": 1422386534,
        "updated_at": 1422386534,
        "name": "my-service",
        "retries": 5,
        "protocol": "http",
        "host": "example.com",
        "port": 80,
        "path": "/another_api",
        "connect_timeout": 60000,
        "write_timeout": 60000,
        "read_timeout": 60000
    }],

route_body: |
    Attributes | Description
    ---:| ---
    `name`<br>*optional* | The name of the Route.
    `protocols` |  A list of the protocols this Route should allow. When set to `["https"]`, HTTP requests are answered with a request to upgrade to HTTPS.  Defaults to `["http", "https"]`.
    `methods`<br>*semi-optional* |  A list of HTTP methods that match this Route. When using `http` or `https` protocols, at least one of `hosts`, `paths`, or `methods` must be set. 
    `hosts`<br>*semi-optional* |  A list of domain names that match this Route. When using `http` or `https` protocols, at least one of `hosts`, `paths`, or `methods` must be set.  With form-encoded, the notation is `hosts[]=example.com&hosts[]=foo.test`. With JSON, use an Array.
    `paths`<br>*semi-optional* |  A list of paths that match this Route. When using `http` or `https` protocols, at least one of `hosts`, `paths`, or `methods` must be set.  With form-encoded, the notation is `paths[]=/foo&paths[]=/bar`. With JSON, use an Array.
    `regex_priority`<br>*optional* |  A number used to choose which route resolves a given request when several routes match it using regexes simultaneously. When two routes match the path and have the same `regex_priority`, the older one (lowest `created_at`) is used. Note that the priority for non-regex routes is different (longer non-regex routes are matched before shorter ones).  Defaults to `0`.
    `strip_path`<br>*optional* |  When matching a Route via one of the `paths`, strip the matching prefix from the upstream request URL.  Defaults to `true`.
    `preserve_host`<br>*optional* |  When matching a Route via one of the `hosts` domain names, use the request `Host` header in the upstream request headers. If set to `false`, the upstream `Host` header will be that of the Service's `host`. 
    `snis`<br>*semi-optional* |  A list of SNIs that match this Route when using stream routing. When using `tcp` or `tls` protocols, at least one of `snis`, `sources`, or `destinations` must be set. 
    `sources`<br>*semi-optional* |  A list of IP sources of incoming connections that match this Route when using stream routing. Each entry is an object with fields "ip" (optionally in CIDR range notation) and/or "port". When using `tcp` or `tls` protocols, at least one of `snis`, `sources`, or `destinations` must be set. 
    `destinations`<br>*semi-optional* |  A list of IP destinations of incoming connections that match this Route when using stream routing. Each entry is an object with fields "ip" (optionally in CIDR range notation) and/or "port". When using `tcp` or `tls` protocols, at least one of `snis`, `sources`, or `destinations` must be set. 
    `service` |  The Service this Route is associated to. This is where the Route proxies traffic to.  With form-encoded, the notation is `service.id=<service_id>`. With JSON, use `"service":{"id":"<service_id>"}`.

route_json: |
    {
        "id": "173a6cee-90d1-40a7-89cf-0329eca780a6",
        "created_at": 1422386534,
        "updated_at": 1422386534,
        "name": "my-route",
        "protocols": ["http", "https"],
        "methods": ["GET", "POST"],
        "hosts": ["example.com", "foo.test"],
        "paths": ["/foo", "/bar"],
        "regex_priority": 0,
        "strip_path": true,
        "preserve_host": false,
        "service": {"id":"f5a9c0ca-bdbb-490f-8928-2ca95836239a"}
    }

route_data: |
    "data": [{
        "id": "885a0392-ef1b-4de3-aacf-af3f1697ce2c",
        "created_at": 1422386534,
        "updated_at": 1422386534,
        "name": "my-route",
        "protocols": ["http", "https"],
        "methods": ["GET", "POST"],
        "hosts": ["example.com", "foo.test"],
        "paths": ["/foo", "/bar"],
        "regex_priority": 0,
        "strip_path": true,
        "preserve_host": false,
        "service": {"id":"a3395f66-2af6-4c79-bea2-1b6933764f80"}
    }, {
        "id": "4fe14415-73d5-4f00-9fbc-c72a0fccfcb2",
        "created_at": 1422386534,
        "updated_at": 1422386534,
        "name": "my-route",
        "protocols": ["tcp", "tls"],
        "regex_priority": 0,
        "strip_path": true,
        "preserve_host": false,
        "snis": ["foo.test", "example.com"],
        "sources": [{"ip":"10.1.0.0/16", "port":1234}, {"ip":"10.2.2.2"}, {"port":9123}],
        "destinations": [{"ip":"10.1.0.0/16", "port":1234}, {"ip":"10.2.2.2"}, {"port":9123}],
        "service": {"id":"ea29aaa3-3b2d-488c-b90c-56df8e0dd8c6"}
    }],

consumer_body: |
    Attributes | Description
    ---:| ---
    `username`<br>*semi-optional* |  The unique username of the consumer. You must send either this field or `custom_id` with the request. 
    `custom_id`<br>*semi-optional* |  Field for storing an existing unique ID for the consumer - useful for mapping Kong with users in your existing database. You must send either this field or `username` with the request. 

consumer_json: |
    {
        "id": "58c8ccbb-eafb-4566-991f-2ed4f678fa70",
        "created_at": 1422386534,
        "username": "my-username",
        "custom_id": "my-custom-id"
    }

consumer_data: |
    "data": [{
        "id": "4e8d95d4-40f2-4818-adcb-30e00c349618",
        "created_at": 1422386534,
        "username": "my-username",
        "custom_id": "my-custom-id"
    }, {
        "id": "b87eb55d-69a1-41d2-8653-8d706eecefc0",
        "created_at": 1422386534,
        "username": "my-username",
        "custom_id": "my-custom-id"
    }],

plugin_body: |
    Attributes | Description
    ---:| ---
    `name` |  The name of the Plugin that's going to be added. Currently the Plugin must be installed in every Kong instance separately. 
    `route`<br>*optional* |  If set, the plugin will only activate when receiving requests via the specified route. Leave unset for the plugin to activate regardless of the Route being used.  Defaults to `null`. With form-encoded, the notation is `route.id=<route_id>`. With JSON, use `"route":{"id":"<route_id>"}`.
    `service`<br>*optional* |  If set, the plugin will only activate when receiving requests via one of the routes belonging to the specified Service. Leave unset for the plugin to activate regardless of the Service being matched.  Defaults to `null`. With form-encoded, the notation is `service.id=<service_id>`. With JSON, use `"service":{"id":"<service_id>"}`.
    `consumer`<br>*optional* |  If set, the plugin will activate only for requests where the specified has been authenticated. (Note that some plugins can not be restricted to consumers this way.). Leave unset for the plugin to activate regardless of the authenticated consumer.  Defaults to `null`. With form-encoded, the notation is `consumer.id=<consumer_id>`. With JSON, use `"consumer":{"id":"<consumer_id>"}`.
    `config`<br>*optional* |  The configuration properties for the Plugin which can be found on the plugins documentation page in the [Kong Hub](https://docs.konghq.com/hub/). 
    `run_on` |  Control on which Kong nodes this plugin will run, given a Service Mesh scenario. Accepted values are: * `first`, meaning "run on the first Kong node that is encountered by the request". On an API Getaway scenario, this is the usual operation, since there is only one Kong node in between source and destination. In a sidecar-to-sidecar Service Mesh scenario, this means running the plugin only on the Kong sidecar of the outbound connection. * `second`, meaning "run on the second node that is encountered by the request". This option is only relevant for sidecar-to-sidecar Service Mesh scenarios: this means running the plugin only on the Kong sidecar of the inbound connection. * `all` means "run on all nodes", meaning both sidecars in a sidecar-to-sidecar scenario. This is useful for tracing/logging plugins.  Defaults to `"first"`.
    `enabled`<br>*optional* | Whether the plugin is applied. Defaults to `true`.

plugin_json: |
    {
        "id": "a3ad71a8-6685-4b03-a101-980a953544f6",
        "name": "rate-limiting",
        "created_at": 1422386534,
        "route": null,
        "service": null,
        "consumer": null,
        "config": {"hour":500, "minute":20},
        "run_on": "first",
        "enabled": true
    }

plugin_data: |
    "data": [{
        "id": "147f5ef0-1ed6-4711-b77f-489262f8bff7",
        "name": "rate-limiting",
        "created_at": 1422386534,
        "route": null,
        "service": null,
        "consumer": null,
        "config": {"hour":500, "minute":20},
        "run_on": "first",
        "enabled": true
    }, {
        "id": "a2e013e8-7623-4494-a347-6d29108ff68b",
        "name": "rate-limiting",
        "created_at": 1422386534,
        "route": null,
        "service": null,
        "consumer": null,
        "config": {"hour":500, "minute":20},
        "run_on": "first",
        "enabled": true
    }],

certificate_body: |
    Attributes | Description
    ---:| ---
    `cert` | PEM-encoded public certificate of the SSL key pair.
    `key` | PEM-encoded private key of the SSL key pair.
    `snis`<br>*shorthand-attribute* |  An array of zero or more hostnames to associate with this certificate as SNIs. This is a sugar parameter that will, under the hood, create an SNI object and associate it with this certificate for your convenience. 

certificate_json: |
    {
        "id": "91020192-062d-416f-a275-9addeeaffaf2",
        "created_at": 1422386534,
        "cert": "-----BEGIN CERTIFICATE-----...",
        "key": "-----BEGIN RSA PRIVATE KEY-----..."
    }

certificate_data: |
    "data": [{
        "id": "d26761d5-83a4-4f24-ac6c-cff276f2b79c",
        "created_at": 1422386534,
        "cert": "-----BEGIN CERTIFICATE-----...",
        "key": "-----BEGIN RSA PRIVATE KEY-----..."
    }, {
        "id": "43429efd-b3a5-4048-94cb-5cc4029909bb",
        "created_at": 1422386534,
        "cert": "-----BEGIN CERTIFICATE-----...",
        "key": "-----BEGIN RSA PRIVATE KEY-----..."
    }],

sni_body: |
    Attributes | Description
    ---:| ---
    `name` | The SNI name to associate with the given certificate.
    `certificate` |  The id (a UUID) of the certificate with which to associate the SNI hostname  With form-encoded, the notation is `certificate.id=<certificate_id>`. With JSON, use `"certificate":{"id":"<certificate_id>"}`.

sni_json: |
    {
        "id": "04fbeacf-a9f1-4a5d-ae4a-b0407445db3f",
        "name": "my-sni",
        "created_at": 1422386534,
        "certificate": {"id":"a9b2107f-a214-47b3-add4-46b942187924"}
    }

sni_data: |
    "data": [{
        "id": "d044b7d4-3dc2-4bbc-8e9f-6b7a69416df6",
        "name": "my-sni",
        "created_at": 1422386534,
        "certificate": {"id":"7fca84d6-7d37-4a74-a7b0-93e576089a41"}
    }, {
        "id": "66c7b5c4-4aaf-4119-af1e-ee3ad75d0af4",
        "name": "my-sni",
        "created_at": 1422386534,
        "certificate": {"id":"02621eee-8309-4bf6-b36b-a82017a5393e"}
    }],

upstream_body: |
    Attributes | Description
    ---:| ---
    `name` | This is a hostname, which must be equal to the `host` of a Service.
    `hash_on`<br>*optional* | What to use as hashing input: `none` (resulting in a weighted-round-robin scheme with no hashing), `consumer`, `ip`, `header`, or `cookie`. Defaults to `"none"`.
    `hash_fallback`<br>*optional* | What to use as hashing input if the primary `hash_on` does not return a hash (eg. header is missing, or no consumer identified). One of: `none`, `consumer`, `ip`, `header`, or `cookie`. Not available if `hash_on` is set to `cookie`. Defaults to `"none"`.
    `hash_on_header`<br>*semi-optional* | The header name to take the value from as hash input. Only required when `hash_on` is set to `header`.
    `hash_fallback_header`<br>*semi-optional* | The header name to take the value from as hash input. Only required when `hash_fallback` is set to `header`.
    `hash_on_cookie`<br>*semi-optional* | The cookie name to take the value from as hash input. Only required when `hash_on` or `hash_fallback` is set to `cookie`. If the specified cookie is not in the request, Kong will generate a value and set the cookie in the response.
    `hash_on_cookie_path`<br>*semi-optional* | The cookie path to set in the response headers. Only required when `hash_on` or `hash_fallback` is set to `cookie`. Defaults to `"/"`.
    `slots`<br>*optional* | The number of slots in the loadbalancer algorithm (`10`-`65536`). Defaults to `10000`.
    `healthchecks.active.https_verify_certificate`<br>*optional* | Whether to check the validity of the SSL certificate of the remote host when performing active health checks using HTTPS. Defaults to `true`.
    `healthchecks.active.unhealthy.http_statuses`<br>*optional* | An array of HTTP statuses to consider a failure, indicating unhealthiness, when returned by a probe in active health checks. Defaults to `[429, 404, 500, 501, 502, 503, 504, 505]`. With form-encoded, the notation is `http_statuses[]=429&http_statuses[]=404`. With JSON, use an Array.
    `healthchecks.active.unhealthy.tcp_failures`<br>*optional* | Number of TCP failures in active probes to consider a target unhealthy. Defaults to `0`.
    `healthchecks.active.unhealthy.timeouts`<br>*optional* | Number of timeouts in active probes to consider a target unhealthy. Defaults to `0`.
    `healthchecks.active.unhealthy.http_failures`<br>*optional* | Number of HTTP failures in active probes (as defined by `healthchecks.active.unhealthy.http_statuses`) to consider a target unhealthy. Defaults to `0`.
    `healthchecks.active.unhealthy.interval`<br>*optional* | Interval between active health checks for unhealthy targets (in seconds). A value of zero indicates that active probes for unhealthy targets should not be performed. Defaults to `0`.
    `healthchecks.active.http_path`<br>*optional* | Path to use in GET HTTP request to run as a probe on active health checks. Defaults to `"/"`.
    `healthchecks.active.timeout`<br>*optional* | Socket timeout for active health checks (in seconds). Defaults to `1`.
    `healthchecks.active.healthy.http_statuses`<br>*optional* | An array of HTTP statuses to consider a success, indicating healthiness, when returned by a probe in active health checks. Defaults to `[200, 302]`. With form-encoded, the notation is `http_statuses[]=200&http_statuses[]=302`. With JSON, use an Array.
    `healthchecks.active.healthy.interval`<br>*optional* | Interval between active health checks for healthy targets (in seconds). A value of zero indicates that active probes for healthy targets should not be performed. Defaults to `0`.
    `healthchecks.active.healthy.successes`<br>*optional* | Number of successes in active probes (as defined by `healthchecks.active.healthy.http_statuses`) to consider a target healthy. Defaults to `0`.
    `healthchecks.active.https_sni`<br>*optional* | The hostname to use as an SNI (Server Name Identification) when performing active health checks using HTTPS. This is particularly useful when Targets are configured using IPs, so that the target host's certificate can be verified with the proper SNI.
    `healthchecks.active.concurrency`<br>*optional* | Number of targets to check concurrently in active health checks. Defaults to `10`.
    `healthchecks.active.type`<br>*optional* | Whether to perform active health checks using HTTP or HTTPS, or just attempt a TCP connection. Possible values are `tcp`, `http` or `https`. Defaults to `"http"`.
    `healthchecks.passive.unhealthy.http_failures`<br>*optional* | Number of HTTP failures in proxied traffic (as defined by `healthchecks.passive.unhealthy.http_statuses`) to consider a target unhealthy, as observed by passive health checks. Defaults to `0`.
    `healthchecks.passive.unhealthy.http_statuses`<br>*optional* | An array of HTTP statuses which represent unhealthiness when produced by proxied traffic, as observed by passive health checks. Defaults to `[429, 500, 503]`. With form-encoded, the notation is `http_statuses[]=429&http_statuses[]=500`. With JSON, use an Array.
    `healthchecks.passive.unhealthy.tcp_failures`<br>*optional* | Number of TCP failures in proxied traffic to consider a target unhealthy, as observed by passive health checks. Defaults to `0`.
    `healthchecks.passive.unhealthy.timeouts`<br>*optional* | Number of timeouts in proxied traffic to consider a target unhealthy, as observed by passive health checks. Defaults to `0`.
    `healthchecks.passive.type`<br>*optional* | Whether to perform passive health checks interpreting HTTP/HTTPS statuses, or just check for TCP connection success. Possible values are `tcp`, `http` or `https` (in passive checks, `http` and `https` options are equivalent.). Defaults to `"http"`.
    `healthchecks.passive.healthy.successes`<br>*optional* | Number of successes in proxied traffic (as defined by `healthchecks.passive.healthy.http_statuses`) to consider a target healthy, as observed by passive health checks. Defaults to `0`.
    `healthchecks.passive.healthy.http_statuses`<br>*optional* | An array of HTTP statuses which represent healthiness when produced by proxied traffic, as observed by passive health checks. Defaults to `[200, 201, 202, 203, 204, 205, 206, 207, 208, 226, 300, 301, 302, 303, 304, 305, 306, 307, 308]`. With form-encoded, the notation is `http_statuses[]=200&http_statuses[]=201`. With JSON, use an Array.

upstream_json: |
    {
        "id": "ce44eef5-41ed-47f6-baab-f725cecf98c7",
        "created_at": 1422386534,
        "name": "my-upstream",
        "hash_on": "none",
        "hash_fallback": "none",
        "hash_on_cookie_path": "/",
        "slots": 10000,
        "healthchecks": {
            "active": {
                "https_verify_certificate": true,
                "unhealthy": {
                    "http_statuses": [429, 404, 500, 501, 502, 503, 504, 505],
                    "tcp_failures": 0,
                    "timeouts": 0,
                    "http_failures": 0,
                    "interval": 0
                },
                "http_path": "/",
                "timeout": 1,
                "healthy": {
                    "http_statuses": [200, 302],
                    "interval": 0,
                    "successes": 0
                },
                "https_sni": "example.com",
                "concurrency": 10,
                "type": "http"
            },
            "passive": {
                "unhealthy": {
                    "http_failures": 0,
                    "http_statuses": [429, 500, 503],
                    "tcp_failures": 0,
                    "timeouts": 0
                },
                "type": "http",
                "healthy": {
                    "successes": 0,
                    "http_statuses": [200, 201, 202, 203, 204, 205, 206, 207, 208, 226, 300, 301, 302, 303, 304, 305, 306, 307, 308]
                }
            }
        }
    }

upstream_data: |
    "data": [{
        "id": "01c23299-839c-49a5-a6d5-8864c09184af",
        "created_at": 1422386534,
        "name": "my-upstream",
        "hash_on": "none",
        "hash_fallback": "none",
        "hash_on_cookie_path": "/",
        "slots": 10000,
        "healthchecks": {
            "active": {
                "https_verify_certificate": true,
                "unhealthy": {
                    "http_statuses": [429, 404, 500, 501, 502, 503, 504, 505],
                    "tcp_failures": 0,
                    "timeouts": 0,
                    "http_failures": 0,
                    "interval": 0
                },
                "http_path": "/",
                "timeout": 1,
                "healthy": {
                    "http_statuses": [200, 302],
                    "interval": 0,
                    "successes": 0
                },
                "https_sni": "example.com",
                "concurrency": 10,
                "type": "http"
            },
            "passive": {
                "unhealthy": {
                    "http_failures": 0,
                    "http_statuses": [429, 500, 503],
                    "tcp_failures": 0,
                    "timeouts": 0
                },
                "type": "http",
                "healthy": {
                    "successes": 0,
                    "http_statuses": [200, 201, 202, 203, 204, 205, 206, 207, 208, 226, 300, 301, 302, 303, 304, 305, 306, 307, 308]
                }
            }
        }
    }, {
        "id": "a4407883-c166-43fd-80ca-3ca035b0cdb7",
        "created_at": 1422386534,
        "name": "my-upstream",
        "hash_on": "none",
        "hash_fallback": "none",
        "hash_on_cookie_path": "/",
        "slots": 10000,
        "healthchecks": {
            "active": {
                "https_verify_certificate": true,
                "unhealthy": {
                    "http_statuses": [429, 404, 500, 501, 502, 503, 504, 505],
                    "tcp_failures": 0,
                    "timeouts": 0,
                    "http_failures": 0,
                    "interval": 0
                },
                "http_path": "/",
                "timeout": 1,
                "healthy": {
                    "http_statuses": [200, 302],
                    "interval": 0,
                    "successes": 0
                },
                "https_sni": "example.com",
                "concurrency": 10,
                "type": "http"
            },
            "passive": {
                "unhealthy": {
                    "http_failures": 0,
                    "http_statuses": [429, 500, 503],
                    "tcp_failures": 0,
                    "timeouts": 0
                },
                "type": "http",
                "healthy": {
                    "successes": 0,
                    "http_statuses": [200, 201, 202, 203, 204, 205, 206, 207, 208, 226, 300, 301, 302, 303, 304, 305, 306, 307, 308]
                }
            }
        }
    }],

target_body: |
    Attributes | Description
    ---:| ---
    `target` |  The target address (ip or hostname) and port. If the hostname resolves to an SRV record, the `port` value will be overridden by the value from the DNS record. 
    `weight`<br>*optional* |  The weight this target gets within the upstream loadbalancer (`0`-`1000`). If the hostname resolves to an SRV record, the `weight` value will be overridden by the value from the DNS record.  Defaults to `100`.

target_json: |
    {
        "id": "ec1a1f6f-2aa4-4e58-93ff-b56368f19b27",
        "created_at": 1422386534,
        "upstream": {"id":"ba641b07-e74a-430a-ab46-94b61e5ea66b"},
        "target": "example.com:8000",
        "weight": 100
    }

target_data: |
    "data": [{
        "id": "9aa116fd-ef4a-4efa-89bf-a0b17c4be982",
        "created_at": 1422386534,
        "upstream": {"id":"127dfc88-ed57-45bf-b77a-a9d3a152ad31"},
        "target": "example.com:8000",
        "weight": 100
    }, {
        "id": "a9daa3ba-8186-4a0d-96e8-00d80ce7240b",
        "created_at": 1422386534,
        "upstream": {"id":"af8330d3-dbdc-48bd-b1be-55b98608834b"},
        "target": "example.com:8000",
        "weight": 100
    }],


---

Kong comes with an **internal** RESTful Admin API for administration purposes.
Requests to the Admin API can be sent to any node in the cluster, and Kong will
keep the configuration consistent across all nodes.

- `8001` is the default port on which the Admin API listens.
- `8444` is the default port for HTTPS traffic to the Admin API.

This API is designed for internal use and provides full control over Kong, so
care should be taken when setting up Kong environments to avoid undue public
exposure of this API. See [this document][secure-admin-api] for a discussion
of methods to secure the Admin API.

## Supported Content Types

The Admin API accepts 2 content types on every endpoint:

- **application/x-www-form-urlencoded**

Simple enough for basic request bodies, you will probably use it most of the time.
Note that when sending nested values, Kong expects nested objects to be referenced
with dotted keys. Example:

```
config.limit=10&config.period=seconds
```

- **application/json**

Handy for complex bodies (ex: complex plugin configuration), in that case simply send
a JSON representation of the data you want to send. Example:

```json
{
    "config": {
        "limit": 10,
        "period": "seconds"
    }
}
```

---

## Information routes



### Retrieve node information

Retrieve generic details about a node.

<div class="endpoint get">/</div>

#### Response

```
HTTP 200 OK
```

```json
{
    "hostname": "",
    "node_id": "6a72192c-a3a1-4c8d-95c6-efabae9fb969",
    "lua_version": "LuaJIT 2.1.0-beta3",
    "plugins": {
        "available_on_server": [
            ...
        ],
        "enabled_in_cluster": [
            ...
        ]
    },
    "configuration" : {
        ...
    },
    "tagline": "Welcome to Kong",
    "version": "0.14.0"
}
```

* `node_id`: A UUID representing the running Kong node. This UUID
  is randomly generated when Kong starts, so the node will have a
  different `node_id` each time it is restarted.
* `available_on_server`: Names of plugins that are installed on the node.
* `enabled_in_cluster`: Names of plugins that are enabled/configured.
  That is, the plugins configurations currently in the datastore shared
  by all Kong nodes.


---

### Retrieve node status

Retrieve usage information about a node, with some basic information
about the connections being processed by the underlying nginx process,
and the status of the database connection.

If you want to monitor the Kong process, since Kong is built on top
of nginx, every existing nginx monitoring tool or agent can be used.


<div class="endpoint get">/status</div>

#### Response

```
HTTP 200 OK
```

```json
{
    "server": {
        "total_requests": 3,
        "connections_active": 1,
        "connections_accepted": 1,
        "connections_handled": 1,
        "connections_reading": 0,
        "connections_writing": 1,
        "connections_waiting": 0
    },
    "database": {
        "reachable": true
    }
}
```

* `server`: Metrics about the nginx HTTP/S server.
    * `total_requests`: The total number of client requests.
    * `connections_active`: The current number of active client
      connections including Waiting connections.
    * `connections_accepted`: The total number of accepted client
      connections.
    * `connections_handled`: The total number of handled connections.
      Generally, the parameter value is the same as accepts unless
      some resource limits have been reached.
    * `connections_reading`: The current number of connections
      where Kong is reading the request header.
    * `connections_writing`: The current number of connections
      where nginx is writing the response back to the client.
    * `connections_waiting`: The current number of idle client
      connections waiting for a request.
* `database`: Metrics about the database.
    * `reachable`: A boolean value reflecting the state of the
      database connection. Please note that this flag **does not**
      reflect the health of the database itself.


---

## Service Object

Service entities, as the name implies, are abstractions of each of your own
upstream services. Examples of Services would be a data transformation
microservice, a billing API, etc.

The main attribute of a Service is its URL (where Kong should proxy traffic
to), which can be set as a single string or by specifying its `protocol`,
`host`, `port` and `path` individually.

Services are associated to Routes (a Service can have many Routes associated
with it). Routes are entry-points in Kong and define rules to match client
requests. Once a Route is matched, Kong proxies the request to its associated
Service. See the [Proxy Reference][proxy-reference] for a detailed explanation
of how Kong proxies traffic.


```json
{{ page.service_json }}
```

### Add Service

##### Create Service

<div class="endpoint post">/services</div>


#### Request Body

{{ page.service_body }}


#### Response

```
HTTP 201 Created
```

```json
{{ page.service_json }}
```


---

### List Services

##### List all Services

<div class="endpoint get">/services</div>


#### Response

```
HTTP 200 OK
```

```json
{
{{ page.service_data }}
    "next": "http://localhost:8001/services?offset=6378122c-a0a1-438d-a5c6-efabae9fb969"
}
```


---

### Retrieve Service

##### Retrieve Service

<div class="endpoint get">/services/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the Service to retrieve.


##### Retrieve Service associated to a specific Route

<div class="endpoint get">/routes/{route name or id}/service</div>

Attributes | Description
---:| ---
`route name or id`<br>**required** | The unique identifier **or** the name of the Route associated to the Service to be retrieved.


##### Retrieve Service associated to a specific Plugin

<div class="endpoint get">/plugins/{plugin id}/service</div>

Attributes | Description
---:| ---
`plugin id`<br>**required** | The unique identifier of the Plugin associated to the Service to be retrieved.


#### Response

```
HTTP 200 OK
```

```json
{{ page.service_json }}
```


---

### Update Service

##### Update Service

<div class="endpoint patch">/services/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the Service to update.


##### Update Service associated to a specific Route

<div class="endpoint patch">/routes/{route name or id}/service</div>

Attributes | Description
---:| ---
`route name or id`<br>**required** | The unique identifier **or** the name of the Route associated to the Service to be updated.


##### Update Service associated to a specific Plugin

<div class="endpoint patch">/plugins/{plugin id}/service</div>

Attributes | Description
---:| ---
`plugin id`<br>**required** | The unique identifier of the Plugin associated to the Service to be updated.


#### Request Body

{{ page.service_body }}


#### Response

```
HTTP 200 OK
```

```json
{{ page.service_json }}
```


---

### Update or create Service

##### Create or update Service

<div class="endpoint put">/services/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the Service to create or update.


##### Create or update Service associated to a specific Route

<div class="endpoint put">/routes/{route name or id}/service</div>

Attributes | Description
---:| ---
`route name or id`<br>**required** | The unique identifier **or** the name of the Route associated to the Service to be created or updated.


##### Create or update Service associated to a specific Plugin

<div class="endpoint put">/plugins/{plugin id}/service</div>

Attributes | Description
---:| ---
`plugin id`<br>**required** | The unique identifier of the Plugin associated to the Service to be created or updated.


#### Request Body

{{ page.service_body }}


Inserts (or replaces) the Service under the requested resource with the
definition specified in the body. The Service will be identified via the `name
or id` attribute.

When the `name or id` attribute has the structure of a UUID, the Service being
inserted/replaced will be identified by its `id`. Otherwise it will be
identified by its `name`.

When creating a new Service without specifying `id` (neither in the URL nor in
the body), then it will be auto-generated.

Notice that specifying a `name` in the URL and a different one in the request
body is not allowed.


#### Response

```
HTTP 201 Created or HTTP 200 OK
```

See POST and PATCH responses.


---

### Delete Service

##### Delete Service

<div class="endpoint delete">/services/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the Service to delete.


##### Delete Service associated to a specific Route

<div class="endpoint delete">/routes/{route name or id}/service</div>

Attributes | Description
---:| ---
`route name or id`<br>**required** | The unique identifier **or** the name of the Route associated to the Service to be deleted.


#### Response

```
HTTP 204 No Content
```


---

## Route Object

Route entities define rules to match client requests. Each Route is
associated with a Service, and a Service may have multiple Routes associated to
it. Every request matching a given Route will be proxied to its associated
Service.

The combination of Routes and Services (and the separation of concerns between
them) offers a powerful routing mechanism with which it is possible to define
fine-grained entry-points in Kong leading to different upstream services of
your infrastructure.


```json
{{ page.route_json }}
```

### Add Route

##### Create Route

<div class="endpoint post">/routes</div>


##### Create Route associated to a specific Service

<div class="endpoint post">/services/{service name or id}/routes</div>

Attributes | Description
---:| ---
`service name or id`<br>**required** | The unique identifier or the `name` attribute of the Service that should be associated to the newly-created Route.


#### Request Body

{{ page.route_body }}


#### Response

```
HTTP 201 Created
```

```json
{{ page.route_json }}
```


---

### List Routes

##### List all Routes

<div class="endpoint get">/routes</div>


##### List Routes associated to a specific Service

<div class="endpoint get">/services/{service name or id}/routes</div>

Attributes | Description
---:| ---
`service name or id`<br>**required** | The unique identifier or the `name` attribute of the Service whose Routes are to be retrieved. When using this endpoint, only Routes associated to the specified Service will be listed.


#### Response

```
HTTP 200 OK
```

```json
{
{{ page.route_data }}
    "next": "http://localhost:8001/routes?offset=6378122c-a0a1-438d-a5c6-efabae9fb969"
}
```


---

### Retrieve Route

##### Retrieve Route

<div class="endpoint get">/routes/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the Route to retrieve.


##### Retrieve Route associated to a specific Plugin

<div class="endpoint get">/plugins/{plugin id}/route</div>

Attributes | Description
---:| ---
`plugin id`<br>**required** | The unique identifier of the Plugin associated to the Route to be retrieved.


#### Response

```
HTTP 200 OK
```

```json
{{ page.route_json }}
```


---

### Update Route

##### Update Route

<div class="endpoint patch">/routes/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the Route to update.


##### Update Route associated to a specific Plugin

<div class="endpoint patch">/plugins/{plugin id}/route</div>

Attributes | Description
---:| ---
`plugin id`<br>**required** | The unique identifier of the Plugin associated to the Route to be updated.


#### Request Body

{{ page.route_body }}


#### Response

```
HTTP 200 OK
```

```json
{{ page.route_json }}
```


---

### Update or create Route

##### Create or update Route

<div class="endpoint put">/routes/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the Route to create or update.


##### Create or update Route associated to a specific Plugin

<div class="endpoint put">/plugins/{plugin id}/route</div>

Attributes | Description
---:| ---
`plugin id`<br>**required** | The unique identifier of the Plugin associated to the Route to be created or updated.


#### Request Body

{{ page.route_body }}


Inserts (or replaces) the Route under the requested resource with the
definition specified in the body. The Route will be identified via the `name
or id` attribute.

When the `name or id` attribute has the structure of a UUID, the Route being
inserted/replaced will be identified by its `id`. Otherwise it will be
identified by its `name`.

When creating a new Route without specifying `id` (neither in the URL nor in
the body), then it will be auto-generated.

Notice that specifying a `name` in the URL and a different one in the request
body is not allowed.


#### Response

```
HTTP 201 Created or HTTP 200 OK
```

See POST and PATCH responses.


---

### Delete Route

##### Delete Route

<div class="endpoint delete">/routes/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the Route to delete.


#### Response

```
HTTP 204 No Content
```


---

## Consumer Object

The Consumer object represents a consumer - or a user - of a Service. You can
either rely on Kong as the primary datastore, or you can map the consumer list
with your database to keep consistency between Kong and your existing primary
datastore.


```json
{{ page.consumer_json }}
```

### Add Consumer

##### Create Consumer

<div class="endpoint post">/consumers</div>


#### Request Body

{{ page.consumer_body }}


#### Response

```
HTTP 201 Created
```

```json
{{ page.consumer_json }}
```


---

### List Consumers

##### List all Consumers

<div class="endpoint get">/consumers</div>


#### Response

```
HTTP 200 OK
```

```json
{
{{ page.consumer_data }}
    "next": "http://localhost:8001/consumers?offset=6378122c-a0a1-438d-a5c6-efabae9fb969"
}
```


---

### Retrieve Consumer

##### Retrieve Consumer

<div class="endpoint get">/consumers/{username or id}</div>

Attributes | Description
---:| ---
`username or id`<br>**required** | The unique identifier **or** the username of the Consumer to retrieve.


##### Retrieve Consumer associated to a specific Plugin

<div class="endpoint get">/plugins/{plugin id}/consumer</div>

Attributes | Description
---:| ---
`plugin id`<br>**required** | The unique identifier of the Plugin associated to the Consumer to be retrieved.


#### Response

```
HTTP 200 OK
```

```json
{{ page.consumer_json }}
```


---

### Update Consumer

##### Update Consumer

<div class="endpoint patch">/consumers/{username or id}</div>

Attributes | Description
---:| ---
`username or id`<br>**required** | The unique identifier **or** the username of the Consumer to update.


##### Update Consumer associated to a specific Plugin

<div class="endpoint patch">/plugins/{plugin id}/consumer</div>

Attributes | Description
---:| ---
`plugin id`<br>**required** | The unique identifier of the Plugin associated to the Consumer to be updated.


#### Request Body

{{ page.consumer_body }}


#### Response

```
HTTP 200 OK
```

```json
{{ page.consumer_json }}
```


---

### Update or create Consumer

##### Create or update Consumer

<div class="endpoint put">/consumers/{username or id}</div>

Attributes | Description
---:| ---
`username or id`<br>**required** | The unique identifier **or** the username of the Consumer to create or update.


##### Create or update Consumer associated to a specific Plugin

<div class="endpoint put">/plugins/{plugin id}/consumer</div>

Attributes | Description
---:| ---
`plugin id`<br>**required** | The unique identifier of the Plugin associated to the Consumer to be created or updated.


#### Request Body

{{ page.consumer_body }}


Inserts (or replaces) the Consumer under the requested resource with the
definition specified in the body. The Consumer will be identified via the `username
or id` attribute.

When the `username or id` attribute has the structure of a UUID, the Consumer being
inserted/replaced will be identified by its `id`. Otherwise it will be
identified by its `username`.

When creating a new Consumer without specifying `id` (neither in the URL nor in
the body), then it will be auto-generated.

Notice that specifying a `username` in the URL and a different one in the request
body is not allowed.


#### Response

```
HTTP 201 Created or HTTP 200 OK
```

See POST and PATCH responses.


---

### Delete Consumer

##### Delete Consumer

<div class="endpoint delete">/consumers/{username or id}</div>

Attributes | Description
---:| ---
`username or id`<br>**required** | The unique identifier **or** the username of the Consumer to delete.


#### Response

```
HTTP 204 No Content
```


---

## Plugin Object

A Plugin entity represents a plugin configuration that will be executed during
the HTTP request/response lifecycle. It is how you can add functionalities
to Services that run behind Kong, like Authentication or Rate Limiting for
example. You can find more information about how to install and what values
each plugin takes by visiting the [Kong Hub](https://docs.konghq.com/hub/).

When adding a Plugin Configuration to a Service, every request made by a client to
that Service will run said Plugin. If a Plugin needs to be tuned to different
values for some specific Consumers, you can do so by specifying the
`consumer_id` value:


```json
{{ page.plugin_json }}
```

See the [Precedence](#precedence) section below for more details.

#### Precedence

A plugin will always be run once and only once per request. But the
configuration with which it will run depends on the entities it has been
configured for.

Plugins can be configured for various entities, combination of entities, or
even globally. This is useful, for example, when you wish to configure a plugin
a certain way for most requests, but make _authenticated requests_ behave
slightly differently.

Therefore, there exists an order of precedence for running a plugin when it has
been applied to different entities with different configurations. The rule of
thumb is: the more specific a plugin is with regards to how many entities it
has been configured on, the higher its priority.

The complete order of precedence when a plugin has been configured multiple
times is:

1. Plugins configured on a combination of: a Route, a Service, and a Consumer.
    (Consumer means the request must be authenticated).
2. Plugins configured on a combination of a Route and a Consumer.
    (Consumer means the request must be authenticated).
3. Plugins configured on a combination of a Service and a Consumer.
    (Consumer means the request must be authenticated).
4. Plugins configured on a combination of a Route and a Service.
5. Plugins configured on a Consumer.
    (Consumer means the request must be authenticated).
6. Plugins configured on a Route.
7. Plugins configured on a Service.
8. Plugins configured to run globally.

**Example**: if the `rate-limiting` plugin is applied twice (with different
configurations): for a Service (Plugin config A), and for a Consumer (Plugin
config B), then requests authenticating this Consumer will run Plugin config B
and ignore A. However, requests that do not authenticate this Consumer will
fallback to running Plugin config A. Note that if config B is disabled
(its `enabled` flag is set to `false`), config A will apply to requests that
would have otherwise matched config B.


### Add Plugin

##### Create Plugin

<div class="endpoint post">/plugins</div>


##### Create Plugin associated to a specific Route

<div class="endpoint post">/routes/{route id}/plugins</div>

Attributes | Description
---:| ---
`route id`<br>**required** | The unique identifier of the Route that should be associated to the newly-created Plugin.


##### Create Plugin associated to a specific Service

<div class="endpoint post">/services/{service id}/plugins</div>

Attributes | Description
---:| ---
`service id`<br>**required** | The unique identifier of the Service that should be associated to the newly-created Plugin.


##### Create Plugin associated to a specific Consumer

<div class="endpoint post">/consumers/{consumer id}/plugins</div>

Attributes | Description
---:| ---
`consumer id`<br>**required** | The unique identifier of the Consumer that should be associated to the newly-created Plugin.


#### Request Body

{{ page.plugin_body }}


#### Response

```
HTTP 201 Created
```

```json
{{ page.plugin_json }}
```


---

### List Plugins

##### List all Plugins

<div class="endpoint get">/plugins</div>


##### List Plugins associated to a specific Route

<div class="endpoint get">/routes/{route id}/plugins</div>

Attributes | Description
---:| ---
`route id`<br>**required** | The unique identifier of the Route whose Plugins are to be retrieved. When using this endpoint, only Plugins associated to the specified Route will be listed.


##### List Plugins associated to a specific Service

<div class="endpoint get">/services/{service id}/plugins</div>

Attributes | Description
---:| ---
`service id`<br>**required** | The unique identifier of the Service whose Plugins are to be retrieved. When using this endpoint, only Plugins associated to the specified Service will be listed.


##### List Plugins associated to a specific Consumer

<div class="endpoint get">/consumers/{consumer id}/plugins</div>

Attributes | Description
---:| ---
`consumer id`<br>**required** | The unique identifier of the Consumer whose Plugins are to be retrieved. When using this endpoint, only Plugins associated to the specified Consumer will be listed.


#### Response

```
HTTP 200 OK
```

```json
{
{{ page.plugin_data }}
    "next": "http://localhost:8001/plugins?offset=6378122c-a0a1-438d-a5c6-efabae9fb969"
}
```


---

### Retrieve Plugin

##### Retrieve Plugin

<div class="endpoint get">/plugins/{plugin id}</div>

Attributes | Description
---:| ---
`plugin id`<br>**required** | The unique identifier of the Plugin to retrieve.


#### Response

```
HTTP 200 OK
```

```json
{{ page.plugin_json }}
```


---

### Update Plugin

##### Update Plugin

<div class="endpoint patch">/plugins/{plugin id}</div>

Attributes | Description
---:| ---
`plugin id`<br>**required** | The unique identifier of the Plugin to update.


#### Request Body

{{ page.plugin_body }}


#### Response

```
HTTP 200 OK
```

```json
{{ page.plugin_json }}
```


---

### Update or create Plugin

##### Create or update Plugin

<div class="endpoint put">/plugins/{plugin id}</div>

Attributes | Description
---:| ---
`plugin id`<br>**required** | The unique identifier of the Plugin to create or update.


#### Request Body

{{ page.plugin_body }}


Inserts (or replaces) the Plugin under the requested resource with the
definition specified in the body. The Plugin will be identified via the `name
or id` attribute.

When the `name or id` attribute has the structure of a UUID, the Plugin being
inserted/replaced will be identified by its `id`. Otherwise it will be
identified by its `name`.

When creating a new Plugin without specifying `id` (neither in the URL nor in
the body), then it will be auto-generated.

Notice that specifying a `name` in the URL and a different one in the request
body is not allowed.


#### Response

```
HTTP 201 Created or HTTP 200 OK
```

See POST and PATCH responses.


---

### Delete Plugin

##### Delete Plugin

<div class="endpoint delete">/plugins/{plugin id}</div>

Attributes | Description
---:| ---
`plugin id`<br>**required** | The unique identifier of the Plugin to delete.


#### Response

```
HTTP 204 No Content
```


---

### Retrieve Enabled Plugins

Retrieve a list of all installed plugins on the Kong node.

<div class="endpoint get">/plugins/enabled</div>

#### Response

```
HTTP 200 OK
```

```json
{
    "enabled_plugins": [
        "jwt",
        "acl",
        "cors",
        "oauth2",
        "tcp-log",
        "udp-log",
        "file-log",
        "http-log",
        "key-auth",
        "hmac-auth",
        "basic-auth",
        "ip-restriction",
        "request-transformer",
        "response-transformer",
        "request-size-limiting",
        "rate-limiting",
        "response-ratelimiting",
        "aws-lambda",
        "bot-detection",
        "correlation-id",
        "datadog",
        "galileo",
        "ldap-auth",
        "loggly",
        "statsd",
        "syslog"
    ]
}
```


---

### Retrieve Plugin Schema

Retrieve the schema of a plugin's configuration. This is useful to
understand what fields a plugin accepts, and can be used for building
third-party integrations to the Kong's plugin system.


<div class="endpoint get">/plugins/schema/{plugin name}</div>

#### Response

```
HTTP 200 OK
```

```json
{
    "fields": {
        "hide_credentials": {
            "default": false,
            "type": "boolean"
        },
        "key_names": {
            "default": "function",
            "required": true,
            "type": "array"
        }
    }
}
```


---

## Certificate Object

A certificate object represents a public certificate/private key pair for an SSL
certificate. These objects are used by Kong to handle SSL/TLS termination for
encrypted requests. Certificates are optionally associated with SNI objects to
tie a cert/key pair to one or more hostnames.


```json
{{ page.certificate_json }}
```

### Add Certificate

##### Create Certificate

<div class="endpoint post">/certificates</div>


#### Request Body

{{ page.certificate_body }}


#### Response

```
HTTP 201 Created
```

```json
{{ page.certificate_json }}
```


---

### List Certificates

##### List all Certificates

<div class="endpoint get">/certificates</div>


#### Response

```
HTTP 200 OK
```

```json
{
{{ page.certificate_data }}
    "next": "http://localhost:8001/certificates?offset=6378122c-a0a1-438d-a5c6-efabae9fb969"
}
```


---

### Retrieve Certificate

##### Retrieve Certificate

<div class="endpoint get">/certificates/{certificate id}</div>

Attributes | Description
---:| ---
`certificate id`<br>**required** | The unique identifier of the Certificate to retrieve.


#### Response

```
HTTP 200 OK
```

```json
{{ page.certificate_json }}
```


---

### Update Certificate

##### Update Certificate

<div class="endpoint patch">/certificates/{certificate id}</div>

Attributes | Description
---:| ---
`certificate id`<br>**required** | The unique identifier of the Certificate to update.


#### Request Body

{{ page.certificate_body }}


#### Response

```
HTTP 200 OK
```

```json
{{ page.certificate_json }}
```


---

### Update or create Certificate

##### Create or update Certificate

<div class="endpoint put">/certificates/{certificate id}</div>

Attributes | Description
---:| ---
`certificate id`<br>**required** | The unique identifier of the Certificate to create or update.


#### Request Body

{{ page.certificate_body }}


Inserts (or replaces) the Certificate under the requested resource with the
definition specified in the body. The Certificate will be identified via the `name
or id` attribute.

When the `name or id` attribute has the structure of a UUID, the Certificate being
inserted/replaced will be identified by its `id`. Otherwise it will be
identified by its `name`.

When creating a new Certificate without specifying `id` (neither in the URL nor in
the body), then it will be auto-generated.

Notice that specifying a `name` in the URL and a different one in the request
body is not allowed.


#### Response

```
HTTP 201 Created or HTTP 200 OK
```

See POST and PATCH responses.


---

### Delete Certificate

##### Delete Certificate

<div class="endpoint delete">/certificates/{certificate id}</div>

Attributes | Description
---:| ---
`certificate id`<br>**required** | The unique identifier of the Certificate to delete.


#### Response

```
HTTP 204 No Content
```


---

## SNI Object

An SNI object represents a many-to-one mapping of hostnames to a certificate.
That is, a certificate object can have many hostnames associated with it; when
Kong receives an SSL request, it uses the SNI field in the Client Hello to
lookup the certificate object based on the SNI associated with the certificate.


```json
{{ page.sni_json }}
```

### Add SNI

##### Create SNI

<div class="endpoint post">/snis</div>


##### Create SNI associated to a specific Certificate

<div class="endpoint post">/certificates/{certificate name or id}/snis</div>

Attributes | Description
---:| ---
`certificate name or id`<br>**required** | The unique identifier or the `name` attribute of the Certificate that should be associated to the newly-created SNI.


#### Request Body

{{ page.sni_body }}


#### Response

```
HTTP 201 Created
```

```json
{{ page.sni_json }}
```


---

### List SNIs

##### List all SNIs

<div class="endpoint get">/snis</div>


##### List SNIs associated to a specific Certificate

<div class="endpoint get">/certificates/{certificate name or id}/snis</div>

Attributes | Description
---:| ---
`certificate name or id`<br>**required** | The unique identifier or the `name` attribute of the Certificate whose SNIs are to be retrieved. When using this endpoint, only SNIs associated to the specified Certificate will be listed.


#### Response

```
HTTP 200 OK
```

```json
{
{{ page.sni_data }}
    "next": "http://localhost:8001/snis?offset=6378122c-a0a1-438d-a5c6-efabae9fb969"
}
```


---

### Retrieve SNI

##### Retrieve SNI

<div class="endpoint get">/snis/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the SNI to retrieve.


#### Response

```
HTTP 200 OK
```

```json
{{ page.sni_json }}
```


---

### Update SNI

##### Update SNI

<div class="endpoint patch">/snis/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the SNI to update.


#### Request Body

{{ page.sni_body }}


#### Response

```
HTTP 200 OK
```

```json
{{ page.sni_json }}
```


---

### Update or create SNI

##### Create or update SNI

<div class="endpoint put">/snis/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the SNI to create or update.


#### Request Body

{{ page.sni_body }}


Inserts (or replaces) the SNI under the requested resource with the
definition specified in the body. The SNI will be identified via the `name
or id` attribute.

When the `name or id` attribute has the structure of a UUID, the SNI being
inserted/replaced will be identified by its `id`. Otherwise it will be
identified by its `name`.

When creating a new SNI without specifying `id` (neither in the URL nor in
the body), then it will be auto-generated.

Notice that specifying a `name` in the URL and a different one in the request
body is not allowed.


#### Response

```
HTTP 201 Created or HTTP 200 OK
```

See POST and PATCH responses.


---

### Delete SNI

##### Delete SNI

<div class="endpoint delete">/snis/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the SNI to delete.


#### Response

```
HTTP 204 No Content
```


---

## Upstream Object

The upstream object represents a virtual hostname and can be used to loadbalance
incoming requests over multiple services (targets). So for example an upstream
named `service.v1.xyz` for a Service object whose `host` is `service.v1.xyz`.
Requests for this Service would be proxied to the targets defined within the upstream.

An upstream also includes a [health checker][healthchecks], which is able to
enable and disable targets based on their ability or inability to serve
requests. The configuration for the health checker is stored in the upstream
object, and applies to all of its targets.


```json
{{ page.upstream_json }}
```

### Add Upstream

##### Create Upstream

<div class="endpoint post">/upstreams</div>


#### Request Body

{{ page.upstream_body }}


#### Response

```
HTTP 201 Created
```

```json
{{ page.upstream_json }}
```


---

### List Upstreams

##### List all Upstreams

<div class="endpoint get">/upstreams</div>


#### Response

```
HTTP 200 OK
```

```json
{
{{ page.upstream_data }}
    "next": "http://localhost:8001/upstreams?offset=6378122c-a0a1-438d-a5c6-efabae9fb969"
}
```


---

### Retrieve Upstream

##### Retrieve Upstream

<div class="endpoint get">/upstreams/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the Upstream to retrieve.


##### Retrieve Upstream associated to a specific Target

<div class="endpoint get">/targets/{target host:port or id}/upstream</div>

Attributes | Description
---:| ---
`target host:port or id`<br>**required** | The unique identifier **or** the host:port of the Target associated to the Upstream to be retrieved.


#### Response

```
HTTP 200 OK
```

```json
{{ page.upstream_json }}
```


---

### Update Upstream

##### Update Upstream

<div class="endpoint patch">/upstreams/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the Upstream to update.


##### Update Upstream associated to a specific Target

<div class="endpoint patch">/targets/{target host:port or id}/upstream</div>

Attributes | Description
---:| ---
`target host:port or id`<br>**required** | The unique identifier **or** the host:port of the Target associated to the Upstream to be updated.


#### Request Body

{{ page.upstream_body }}


#### Response

```
HTTP 200 OK
```

```json
{{ page.upstream_json }}
```


---

### Update or create Upstream

##### Create or update Upstream

<div class="endpoint put">/upstreams/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the Upstream to create or update.


##### Create or update Upstream associated to a specific Target

<div class="endpoint put">/targets/{target host:port or id}/upstream</div>

Attributes | Description
---:| ---
`target host:port or id`<br>**required** | The unique identifier **or** the host:port of the Target associated to the Upstream to be created or updated.


#### Request Body

{{ page.upstream_body }}


Inserts (or replaces) the Upstream under the requested resource with the
definition specified in the body. The Upstream will be identified via the `name
or id` attribute.

When the `name or id` attribute has the structure of a UUID, the Upstream being
inserted/replaced will be identified by its `id`. Otherwise it will be
identified by its `name`.

When creating a new Upstream without specifying `id` (neither in the URL nor in
the body), then it will be auto-generated.

Notice that specifying a `name` in the URL and a different one in the request
body is not allowed.


#### Response

```
HTTP 201 Created or HTTP 200 OK
```

See POST and PATCH responses.


---

### Delete Upstream

##### Delete Upstream

<div class="endpoint delete">/upstreams/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the Upstream to delete.


##### Delete Upstream associated to a specific Target

<div class="endpoint delete">/targets/{target host:port or id}/upstream</div>

Attributes | Description
---:| ---
`target host:port or id`<br>**required** | The unique identifier **or** the host:port of the Target associated to the Upstream to be deleted.


#### Response

```
HTTP 204 No Content
```


---

### Show Upstream health for node

Displays the health status for all Targets of a given Upstream, according to
the perspective of a specific Kong node. Note that, being node-specific
information, making this same request to different nodes of the Kong cluster
may produce different results. For example, one specific node of the Kong
cluster may be experiencing network issues, causing it to fail to connect to
some Targets: these Targets will be marked as unhealthy by that node
(directing traffic from this node to other Targets that it can successfully
reach), but healthy to all others Kong nodes (which have no problems using that
Target).

The `data` field of the response contains an array of Target objects.
The health for each Target is returned in its `health` field:

* If a Target fails to be activated in the ring balancer due to DNS issues,
  its status displays as `DNS_ERROR`.
* When [health checks][healthchecks] are not enabled in the Upstream
  configuration, the health status for active Targets is displayed as
  `HEALTHCHECKS_OFF`.
* When health checks are enabled and the Target is determined to be healthy,
  either automatically or [manually](#set-target-as-healthy),
  its status is displayed as `HEALTHY`. This means that this Target is
  currently included in this Upstream's load balancer ring.
* When a Target has been disabled by either active or passive health checks
  (circuit breakers) or [manually](#set-target-as-unhealthy),
  its status is displayed as `UNHEALTHY`. The load balancer is not directing
  any traffic to this Target via this Upstream.


<div class="endpoint get">/upstreams/{name or id}/health/</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the Upstream for which to display Target health.


#### Response

```
HTTP 200 OK
```

```json
{
    "total": 2,
    "node_id": "cbb297c0-14a9-46bc-ad91-1d0ef9b42df9",
    "data": [
        {
            "created_at": 1485524883980,
            "id": "18c0ad90-f942-4098-88db-bbee3e43b27f",
            "health": "HEALTHY",
            "target": "127.0.0.1:20000",
            "upstream_id": "07131005-ba30-4204-a29f-0927d53257b4",
            "weight": 100
        },
        {
            "created_at": 1485524914883,
            "id": "6c6f34eb-e6c3-4c1f-ac58-4060e5bca890",
            "health": "UNHEALTHY",
            "target": "127.0.0.1:20002",
            "upstream_id": "07131005-ba30-4204-a29f-0927d53257b4",
            "weight": 200
        }
    ]
}
```


---

## Target Object

A target is an ip address/hostname with a port that identifies an instance of a backend
service. Every upstream can have many targets, and the targets can be
dynamically added. Changes are effectuated on the fly.

Because the upstream maintains a history of target changes, the targets cannot
be deleted or modified. To disable a target, post a new one with `weight=0`;
alternatively, use the `DELETE` convenience method to accomplish the same.

The current target object definition is the one with the latest `created_at`.


```json
{{ page.target_json }}
```

### Add Target

##### Create Target associated to a specific Upstream

<div class="endpoint post">/upstreams/{upstream host:port or id}/targets</div>

Attributes | Description
---:| ---
`upstream host:port or id`<br>**required** | The unique identifier or the `host:port` attribute of the Upstream that should be associated to the newly-created Target.


#### Request Body

{{ page.target_body }}


#### Response

```
HTTP 201 Created
```

```json
{{ page.target_json }}
```


---

### List Targets

##### List Targets associated to a specific Upstream

<div class="endpoint get">/upstreams/{upstream host:port or id}/targets</div>

Attributes | Description
---:| ---
`upstream host:port or id`<br>**required** | The unique identifier or the `host:port` attribute of the Upstream whose Targets are to be retrieved. When using this endpoint, only Targets associated to the specified Upstream will be listed.


#### Response

```
HTTP 200 OK
```

```json
{
{{ page.target_data }}
    "next": "http://localhost:8001/targets?offset=6378122c-a0a1-438d-a5c6-efabae9fb969"
}
```


---

### Delete Target

Disable a target in the load balancer. Under the hood, this method creates
a new entry for the given target definition with a `weight` of 0.


<div class="endpoint delete">/upstreams/{upstream name or id}/targets/{host:port or id}</div>

Attributes | Description
---:| ---
`upstream name or id`<br>**required** | The unique identifier **or** the name of the upstream for which to delete the target.
`host:port or id`<br>**required** | The host:port combination element of the target to remove, or the `id` of an existing target entry.


#### Response

```
HTTP 204 No Content
```


---

### Set target as healthy

Set the current health status of a target in the load balancer to "healthy"
in the entire Kong cluster.

This endpoint can be used to manually re-enable a target that was previously
disabled by the upstream's [health checker][healthchecks]. Upstreams only
forward requests to healthy nodes, so this call tells Kong to start using this
target again.

This resets the health counters of the health checkers running in all workers
of the Kong node, and broadcasts a cluster-wide message so that the "healthy"
status is propagated to the whole Kong cluster.


<div class="endpoint post">/upstreams/{upstream name or id}/targets/{target or id}/healthy</div>

Attributes | Description
---:| ---
`upstream name or id`<br>**required** | The unique identifier **or** the name of the upstream.
`target or id`<br>**required** | The host/port combination element of the target to set as healthy, or the `id` of an existing target entry.


#### Response

```
HTTP 204 No Content
```


---

### Set target as unhealthy

Set the current health status of a target in the load balancer to "unhealthy"
in the entire Kong cluster.

This endpoint can be used to manually disable a target and have it stop
responding to requests. Upstreams only forward requests to healthy nodes, so
this call tells Kong to start skipping this target in the ring-balancer
algorithm.

This call resets the health counters of the health checkers running in all
workers of the Kong node, and broadcasts a cluster-wide message so that the
"unhealthy" status is propagated to the whole Kong cluster.

[Active health checks][active] continue to execute for unhealthy
targets. Note that if active health checks are enabled and the probe detects
that the target is actually healthy, it will automatically re-enable it again.
To permanently remove a target from the ring-balancer, you should [delete a
target](#delete-target) instead.


<div class="endpoint post">/upstreams/{upstream name or id}/targets/{target or id}/unhealthy</div>

Attributes | Description
---:| ---
`upstream name or id`<br>**required** | The unique identifier **or** the name of the upstream.
`target or id`<br>**required** | The host/port combination element of the target to set as unhealthy, or the `id` of an existing target entry.


#### Response

```
HTTP 204 No Content
```


---

### List all Targets

Lists all targets of the upstream. Multiple target objects for the same
target may be returned, showing the history of changes for a specific target.
The target object with the latest `created_at` is the current definition.


<div class="endpoint get">/upstreams/{name or id}/targets/all/</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the upstream for which to list the targets.


#### Response

```
HTTP 200 OK
```

```json
{
    "total": 2,
    "data": [
        {
            "created_at": 1485524883980,
            "id": "18c0ad90-f942-4098-88db-bbee3e43b27f",
            "target": "127.0.0.1:20000",
            "upstream_id": "07131005-ba30-4204-a29f-0927d53257b4",
            "weight": 100
        },
        {
            "created_at": 1485524914883,
            "id": "6c6f34eb-e6c3-4c1f-ac58-4060e5bca890",
            "target": "127.0.0.1:20002",
            "upstream_id": "07131005-ba30-4204-a29f-0927d53257b4",
            "weight": 200
        }
    ]
}
```


---

[clustering]: /{{page.kong_version}}/clustering
[cli]: /{{page.kong_version}}/cli
[active]: /{{page.kong_version}}/health-checks-circuit-breakers/#active-health-checks
[healthchecks]: /{{page.kong_version}}/health-checks-circuit-breakers
[secure-admin-api]: /{{page.kong_version}}/secure-admin-api
[proxy-reference]: /{{page.kong_version}}/proxy
