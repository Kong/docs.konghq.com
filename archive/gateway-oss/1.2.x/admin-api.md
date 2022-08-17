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
    `tags`<br>*optional* |  An optional set of strings associated with the Service, for grouping and filtering.
    `url`<br>*shorthand-attribute* |  Shorthand attribute to set `protocol`, `host`, `port` and `path` at once. This attribute is write-only (the Admin API never "returns" the url).

service_json: |
    {
        "id": "9748f662-7711-4a90-8186-dc02f10eb0f5",
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
        "read_timeout": 60000,
        "tags": ["user-level", "low-priority"]
    }

service_data: |
    "data": [{
        "id": "4e3ad2e4-0bc4-4638-8e34-c84a417ba39b",
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
        "read_timeout": 60000,
        "tags": ["user-level", "low-priority"]
    }, {
        "id": "a5fb8d9b-a99d-40e9-9d35-72d42a62d83a",
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
        "read_timeout": 60000,
        "tags": ["admin", "high-priority", "critical"]
    }],

route_body: |
    Attributes | Description
    ---:| ---
    `name`<br>*optional* | The name of the Route.
    `protocols` |  A list of the protocols this Route should allow. When set to `["https"]`, HTTP requests are answered with a request to upgrade to HTTPS.  Defaults to `["http", "https"]`.
    `methods`<br>*semi-optional* |  A list of HTTP methods that match this Route. When using `http` or `https` protocols, at least one of `hosts`, `paths`, or `methods` must be set.
    `hosts`<br>*semi-optional* |  A list of domain names that match this Route. When using `http` or `https` protocols, at least one of `hosts`, `paths`, or `methods` must be set.  With form-encoded, the notation is `hosts[]=example.com&hosts[]=foo.test`. With JSON, use an Array.
    `paths`<br>*semi-optional* |  A list of paths that match this Route. When using `http` or `https` protocols, at least one of `hosts`, `paths`, or `methods` must be set.  With form-encoded, the notation is `paths[]=/foo&paths[]=/bar`. With JSON, use an Array.
    `https_redirect_status_code` |  The status code Kong responds with when all properties of a Route match except the protocol i.e. if the protocol of the request is `HTTP` instead of `HTTPS`. `Location` header is injected by Kong if the field is set to 301, 302, 307 or 308.  Defaults to `426`.
    `regex_priority`<br>*optional* |  A number used to choose which route resolves a given request when several routes match it using regexes simultaneously. When two routes match the path and have the same `regex_priority`, the older one (lowest `created_at`) is used. Note that the priority for non-regex routes is different (longer non-regex routes are matched before shorter ones).  Defaults to `0`.
    `strip_path`<br>*optional* |  When matching a Route via one of the `paths`, strip the matching prefix from the upstream request URL.  Defaults to `true`.
    `preserve_host`<br>*optional* |  When matching a Route via one of the `hosts` domain names, use the request `Host` header in the upstream request headers. If set to `false`, the upstream `Host` header will be that of the Service's `host`.
    `snis`<br>*semi-optional* |  A list of SNIs that match this Route when using stream routing. When using `tcp` or `tls` protocols, at least one of `snis`, `sources`, or `destinations` must be set.
    `sources`<br>*semi-optional* |  A list of IP sources of incoming connections that match this Route when using stream routing. Each entry is an object with fields "ip" (optionally in CIDR range notation) and/or "port". When using `tcp` or `tls` protocols, at least one of `snis`, `sources`, or `destinations` must be set.
    `destinations`<br>*semi-optional* |  A list of IP destinations of incoming connections that match this Route when using stream routing. Each entry is an object with fields "ip" (optionally in CIDR range notation) and/or "port". When using `tcp` or `tls` protocols, at least one of `snis`, `sources`, or `destinations` must be set.
    `tags`<br>*optional* |  An optional set of strings associated with the Route, for grouping and filtering.
    `service`<br>*optional* |  The Service this Route is associated to. This is where the Route proxies traffic to.  With form-encoded, the notation is `service.id=<service_id>`. With JSON, use `"service":{"id":"<service_id>"}`.

route_json: |
    {
        "id": "51e77dc2-8f3e-4afa-9d0e-0e3bbbcfd515",
        "created_at": 1422386534,
        "updated_at": 1422386534,
        "name": "my-route",
        "protocols": ["http", "https"],
        "methods": ["GET", "POST"],
        "hosts": ["example.com", "foo.test"],
        "paths": ["/foo", "/bar"],
        "https_redirect_status_code": 426,
        "regex_priority": 0,
        "strip_path": true,
        "preserve_host": false,
        "tags": ["user-level", "low-priority"],
        "service": {"id":"fc73f2af-890d-4f9b-8363-af8945001f7f"}
    }

route_data: |
    "data": [{
        "id": "4506673d-c825-444c-a25b-602e3c2ec16e",
        "created_at": 1422386534,
        "updated_at": 1422386534,
        "name": "my-route",
        "protocols": ["http", "https"],
        "methods": ["GET", "POST"],
        "hosts": ["example.com", "foo.test"],
        "paths": ["/foo", "/bar"],
        "https_redirect_status_code": 426,
        "regex_priority": 0,
        "strip_path": true,
        "preserve_host": false,
        "tags": ["user-level", "low-priority"],
        "service": {"id":"d35165e2-d03e-461a-bdeb-dad0a112abfe"}
    }, {
        "id": "af8330d3-dbdc-48bd-b1be-55b98608834b",
        "created_at": 1422386534,
        "updated_at": 1422386534,
        "name": "my-route",
        "protocols": ["tcp", "tls"],
        "https_redirect_status_code": 426,
        "regex_priority": 0,
        "strip_path": true,
        "preserve_host": false,
        "snis": ["foo.test", "example.com"],
        "sources": [{"ip":"10.1.0.0/16", "port":1234}, {"ip":"10.2.2.2"}, {"port":9123}],
        "destinations": [{"ip":"10.1.0.0/16", "port":1234}, {"ip":"10.2.2.2"}, {"port":9123}],
        "tags": ["admin", "high-priority", "critical"],
        "service": {"id":"a9daa3ba-8186-4a0d-96e8-00d80ce7240b"}
    }],

consumer_body: |
    Attributes | Description
    ---:| ---
    `username`<br>*semi-optional* |  The unique username of the consumer. You must send either this field or `custom_id` with the request.
    `custom_id`<br>*semi-optional* |  Field for storing an existing unique ID for the consumer - useful for mapping Kong with users in your existing database. You must send either this field or `username` with the request.
    `tags`<br>*optional* |  An optional set of strings associated with the Consumer, for grouping and filtering.

consumer_json: |
    {
        "id": "127dfc88-ed57-45bf-b77a-a9d3a152ad31",
        "created_at": 1422386534,
        "username": "my-username",
        "custom_id": "my-custom-id",
        "tags": ["user-level", "low-priority"]
    }

consumer_data: |
    "data": [{
        "id": "9aa116fd-ef4a-4efa-89bf-a0b17c4be982",
        "created_at": 1422386534,
        "username": "my-username",
        "custom_id": "my-custom-id",
        "tags": ["user-level", "low-priority"]
    }, {
        "id": "ba641b07-e74a-430a-ab46-94b61e5ea66b",
        "created_at": 1422386534,
        "username": "my-username",
        "custom_id": "my-custom-id",
        "tags": ["admin", "high-priority", "critical"]
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
    `protocols` |  A list of the request protocols that will trigger this plugin. Possible values are `"http"`, `"https"`, `"tcp"`, and `"tls"`. The default value, as well as the possible values allowed on this field, may change depending on the plugin type. For example, plugins that only work in stream mode will may only support `"tcp"` and `"tls"`.  Defaults to `["http", "https"]`.
    `enabled`<br>*optional* | Whether the plugin is applied. Defaults to `true`.
    `tags`<br>*optional* |  An optional set of strings associated with the Plugin, for grouping and filtering.

plugin_json: |
    {
        "id": "ec1a1f6f-2aa4-4e58-93ff-b56368f19b27",
        "name": "rate-limiting",
        "created_at": 1422386534,
        "route": null,
        "service": null,
        "consumer": null,
        "config": {"hour":500, "minute":20},
        "run_on": "first",
        "protocols": ["http", "https"],
        "enabled": true,
        "tags": ["user-level", "low-priority"]
    }

plugin_data: |
    "data": [{
        "id": "a4407883-c166-43fd-80ca-3ca035b0cdb7",
        "name": "rate-limiting",
        "created_at": 1422386534,
        "route": null,
        "service": null,
        "consumer": null,
        "config": {"hour":500, "minute":20},
        "run_on": "first",
        "protocols": ["http", "https"],
        "enabled": true,
        "tags": ["user-level", "low-priority"]
    }, {
        "id": "01c23299-839c-49a5-a6d5-8864c09184af",
        "name": "rate-limiting",
        "created_at": 1422386534,
        "route": null,
        "service": null,
        "consumer": null,
        "config": {"hour":500, "minute":20},
        "run_on": "first",
        "protocols": ["tcp", "tls"],
        "enabled": true,
        "tags": ["admin", "high-priority", "critical"]
    }],

certificate_body: |
    Attributes | Description
    ---:| ---
    `cert` | PEM-encoded public certificate of the SSL key pair.
    `key` | PEM-encoded private key of the SSL key pair.
    `tags`<br>*optional* |  An optional set of strings associated with the Certificate, for grouping and filtering.
    `snis`<br>*shorthand-attribute* |  An array of zero or more hostnames to associate with this certificate as SNIs. This is a sugar parameter that will, under the hood, create an SNI object and associate it with this certificate for your convenience. To set this attribute this certificate must have a valid private key associated with it.

certificate_json: |
    {
        "id": "ce44eef5-41ed-47f6-baab-f725cecf98c7",
        "created_at": 1422386534,
        "cert": "-----BEGIN CERTIFICATE-----...",
        "key": "-----BEGIN RSA PRIVATE KEY-----...",
        "tags": ["user-level", "low-priority"]
    }

certificate_data: |
    "data": [{
        "id": "02621eee-8309-4bf6-b36b-a82017a5393e",
        "created_at": 1422386534,
        "cert": "-----BEGIN CERTIFICATE-----...",
        "key": "-----BEGIN RSA PRIVATE KEY-----...",
        "tags": ["user-level", "low-priority"]
    }, {
        "id": "66c7b5c4-4aaf-4119-af1e-ee3ad75d0af4",
        "created_at": 1422386534,
        "cert": "-----BEGIN CERTIFICATE-----...",
        "key": "-----BEGIN RSA PRIVATE KEY-----...",
        "tags": ["admin", "high-priority", "critical"]
    }],

sni_body: |
    Attributes | Description
    ---:| ---
    `name` | The SNI name to associate with the given certificate. May contain a single wildcard in the leftmost (suffix) or rightmost (prefix) position. This can be helpful when maintaining multiple subdomains, as a single SNI configured with a wildcard name can be used to match multiple subdomains, instead of creating an SNI entity for each. Valid wildcard positions are `mydomain.*`, `*.mydomain.com`, and `*.www.mydomain.com`. Plain SNI names (no wildcard) take priority when matching, followed by prefix and then suffix.
    `tags`<br>*optional* |  An optional set of strings associated with the SNIs, for grouping and filtering.
    `certificate` |  The id (a UUID) of the certificate with which to associate the SNI hostname. The Certificate must have a valid private key associated with it to be used by the SNI object.  With form-encoded, the notation is `certificate.id=<certificate_id>`. With JSON, use `"certificate":{"id":"<certificate_id>"}`.

sni_json: |
    {
        "id": "7fca84d6-7d37-4a74-a7b0-93e576089a41",
        "name": "my-sni",
        "created_at": 1422386534,
        "tags": ["user-level", "low-priority"],
        "certificate": {"id":"d044b7d4-3dc2-4bbc-8e9f-6b7a69416df6"}
    }

sni_data: |
    "data": [{
        "id": "a9b2107f-a214-47b3-add4-46b942187924",
        "name": "my-sni",
        "created_at": 1422386534,
        "tags": ["user-level", "low-priority"],
        "certificate": {"id":"04fbeacf-a9f1-4a5d-ae4a-b0407445db3f"}
    }, {
        "id": "43429efd-b3a5-4048-94cb-5cc4029909bb",
        "name": "my-sni",
        "created_at": 1422386534,
        "tags": ["admin", "high-priority", "critical"],
        "certificate": {"id":"d26761d5-83a4-4f24-ac6c-cff276f2b79c"}
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
    `tags`<br>*optional* |  An optional set of strings associated with the Upstream, for grouping and filtering.

upstream_json: |
    {
        "id": "91020192-062d-416f-a275-9addeeaffaf2",
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
        },
        "tags": ["user-level", "low-priority"]
    }

upstream_data: |
    "data": [{
        "id": "a2e013e8-7623-4494-a347-6d29108ff68b",
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
        },
        "tags": ["user-level", "low-priority"]
    }, {
        "id": "147f5ef0-1ed6-4711-b77f-489262f8bff7",
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
        },
        "tags": ["admin", "high-priority", "critical"]
    }],

target_body: |
    Attributes | Description
    ---:| ---
    `target` |  The target address (ip or hostname) and port. If the hostname resolves to an SRV record, the `port` value will be overridden by the value from the DNS record.
    `weight`<br>*optional* |  The weight this target gets within the upstream loadbalancer (`0`-`1000`). If the hostname resolves to an SRV record, the `weight` value will be overridden by the value from the DNS record.  Defaults to `100`.
    `tags`<br>*optional* |  An optional set of strings associated with the Target, for grouping and filtering.

target_json: |
    {
        "id": "a3ad71a8-6685-4b03-a101-980a953544f6",
        "created_at": 1422386534,
        "upstream": {"id":"b87eb55d-69a1-41d2-8653-8d706eecefc0"},
        "target": "example.com:8000",
        "weight": 100,
        "tags": ["user-level", "low-priority"]
    }

target_data: |
    "data": [{
        "id": "4e8d95d4-40f2-4818-adcb-30e00c349618",
        "created_at": 1422386534,
        "upstream": {"id":"58c8ccbb-eafb-4566-991f-2ed4f678fa70"},
        "target": "example.com:8000",
        "weight": 100,
        "tags": ["user-level", "low-priority"]
    }, {
        "id": "ea29aaa3-3b2d-488c-b90c-56df8e0dd8c6",
        "created_at": 1422386534,
        "upstream": {"id":"4fe14415-73d5-4f00-9fbc-c72a0fccfcb2"},
        "target": "example.com:8000",
        "weight": 100,
        "tags": ["admin", "high-priority", "critical"]
    }],


---

<div class="alert alert-info.blue" role="alert">
  This page refers to the Admin API for running Kong configured with a
  database (Postgres or Cassandra). For using the Admin API for Kong
  in DB-less mode, please refer to the
  <a href="/{{page.kong_version}}/db-less-admin-api">Admin API for DB-less Mode</a>
  page.
</div>

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

Arrays and sets can be specified in various ways:

1. Sending same parameter multiple times:
    ```
    hosts=example.com&hosts=example.org
    ```
2. Using array notation:
    ```
    hosts[1]=example.com&hosts[2]=example.org
    ```
    or
    ```
    hosts[]=example.com&hosts[]=example.org
    ```
    Array and object notation can also be mixed:

    ```
    config.hosts[1]=example.com&config.hosts[2]=example.org
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

JSON arrays can be specified as well:

```json
{
    "config": {
        "limit": 10,
        "period": "seconds",
        "hosts": [ "example.com", "example.org" ]
    }
}
```

---

## Information Routes



### Retrieve Node Information

Retrieve generic details about a node.

<div class="endpoint get">/</div>

*Response*

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

### Retrieve Node Status

Retrieve usage information about a node, with some basic information
about the connections being processed by the underlying nginx process,
the status of the database connection, and node's memory usage.

If you want to monitor the Kong process, since Kong is built on top
of nginx, every existing nginx monitoring tool or agent can be used.


<div class="endpoint get">/status</div>

*Response*

```
HTTP 200 OK
```

```json
{
    "database": {
      "reachable": true
    },
    "memory": {
        "workers_lua_vms": [{
            "http_allocated_gc": "0.02 MiB",
            "pid": 18477
          }, {
            "http_allocated_gc": "0.02 MiB",
            "pid": 18478
        }],
        "lua_shared_dicts": {
            "kong": {
                "allocated_slabs": "0.04 MiB",
                "capacity": "5.00 MiB"
            },
            "kong_db_cache": {
                "allocated_slabs": "0.80 MiB",
                "capacity": "128.00 MiB"
            },
        }
    },
    "server": {
        "total_requests": 3,
        "connections_active": 1,
        "connections_accepted": 1,
        "connections_handled": 1,
        "connections_reading": 0,
        "connections_writing": 1,
        "connections_waiting": 0
    }
}
```

* `memory`: Metrics about the memory usage.
    * `workers_lua_vms`: An array with all workers of the Kong node, where each
      entry contains:
    * `http_allocated_gc`: HTTP submodule's Lua virtual machine's memory
      usage information, as reported by `collectgarbage("count")`, for every
      active worker, i.e. a worker that received a proxy call in the last 10
      seconds.
    * `pid`: worker's process identification number.
    * `lua_shared_dicts`: An array of information about dictionaries that are
      shared with all workers in a Kong node, where each array node contains how
      much memory is dedicated for the specific shared dictionary (`capacity`)
      and how much of said memory is in use (`allocated_slabs`).
      These shared dictionaries have least recent used (LRU) eviction
      capabilities, so a full dictionary, where `allocated_slabs == capacity`,
      will work properly. However for some dictionaries, e.g. cache HIT/MISS
      shared dictionaries, increasing their size can be beneficial for the
      overall performance of a Kong node.
  * The memory usage unit and precision can be changed using the querystring
    arguments `unit` and `scale`:
      * `unit`: one of `b/B`, `k/K`, `m/M`, `g/G`, which will return results
        in bytes, kibibytes, mebibytes, or gibibytes, respectively. When
        "bytes" are requested, the memory values in the response will have a
        number type instead of string. Defaults to `m`.
      * `scale`: the number of digits to the right of the decimal points when
        values are given in human-readable memory strings (unit other than
        "bytes"). Defaults to `2`.
      You can get the shared dictionaries memory usage in kibibytes with 4
      digits of precision by doing: `GET /status?unit=k&scale=4`
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

## Tags

Tags are strings associated to entities in Kong. Each tag must be composed of one or more
alphanumeric characters, `_`, `-`, `.` or `~`.

Most core entities can be *tagged* via their `tags` attribute, upon creation or edition.

Tags can be used to filter core entities as well, via the `?tags` querystring parameter.

For example: if you normally get a list of all the Services by doing:

```
GET /services
```

You can get the list of all the Services tagged `example` by doing:

```
GET /services?tags=example
```

Similarly, if you want to filter Services so that you only get the ones tagged `example` *and*
`admin`, you can do that like so:

```
GET /services?tags=example,admin
```

Finally, if you wanted to filter the Services tagged `example` *or* `admin`, you could use:

```
GET /services?tags=example/admin
```

Some notes:

* A maximum of 5 tags can be queried simultaneously in a single request with `,` or `/`
* Mixing operators is not supported: if you try to mix `,` with `/` in the same querystring,
  you will receive an error.
* You may need to quote and/or escape some characters when using them from the
  command line.
* Filtering by `tags` is not supported in foreign key relationship endpoints. For example,
  the `tags` parameter will be ignored in a request such as `GET /services/foo/routes?tags=a,b`
* `offset` parameters are not guaranteed to work if the `tags` parameter is altered or removed


### List All Tags

Returns a paginated list of all the tags in the system.

The list of entities will not be restricted to a single entity type: all the
entities tagged with tags will be present on this list.

If an entity is tagged with more than one tag, the `entity_id` for that entity
will appear more than once in the resulting list. Similarly, if several entities
have been tagged with the same tag, the tag will appear in several items of this list.


<div class="endpoint get">/tags</div>

*Response*

```
HTTP 200 OK
```

``` json
{
    {
      "data": [
        { "entity_name": "services",
          "entity_id": "acf60b10-125c-4c1a-bffe-6ed55daefba4",
          "tag": "s1",
        },
        { "entity_name": "services",
          "entity_id": "acf60b10-125c-4c1a-bffe-6ed55daefba4",
          "tag": "s2",
        },
        { "entity_name": "routes",
          "entity_id": "60631e85-ba6d-4c59-bd28-e36dd90f6000",
          "tag": "s1",
        },
        ...
      ],
      "offset" = "c47139f3-d780-483d-8a97-17e9adc5a7ab",
      "next" = "/tags?offset=c47139f3-d780-483d-8a97-17e9adc5a7ab",
    }
}
```


---

### List Entity Ids by Tag

Returns the entities that have been tagged with the specified tag.

The list of entities will not be restricted to a single entity type: all the
entities tagged with tags will be present on this list.


<div class="endpoint get">/tags/:tags</div>

*Response*

```
HTTP 200 OK
```

``` json
{
    {
      "data": [
        { "entity_name": "services",
          "entity_id": "c87440e1-0496-420b-b06f-dac59544bb6c",
          "tag": "example",
        },
        { "entity_name": "routes",
          "entity_id": "8a99e4b1-d268-446b-ab8b-cd25cff129b1",
          "tag": "example",
        },
        ...
      ],
      "offset" = "1fb491c4-f4a7-4bca-aeba-7f3bcee4d2f9",
      "next" = "/tags/example?offset=1fb491c4-f4a7-4bca-aeba-7f3bcee4d2f9",
    }
}
```


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

Services can be both [tagged and filtered by tags](#tags).


```json
{{ page.service_json }}
```

### Add Service

##### Create Service

<div class="endpoint post">/services</div>


*Request Body*

{{ page.service_body }}


*Response*

```
HTTP 201 Created
```

```json
{{ page.service_json }}
```


---

### List Services

##### List All Services

<div class="endpoint get">/services</div>


*Response*

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


##### Retrieve Service Associated to a Specific Route

<div class="endpoint get">/routes/{route name or id}/service</div>

Attributes | Description
---:| ---
`route name or id`<br>**required** | The unique identifier **or** the name of the Route associated to the Service to be retrieved.


##### Retrieve Service Associated to a Specific Plugin

<div class="endpoint get">/plugins/{plugin id}/service</div>

Attributes | Description
---:| ---
`plugin id`<br>**required** | The unique identifier of the Plugin associated to the Service to be retrieved.


*Response*

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


##### Update Service Associated to a Specific Route

<div class="endpoint patch">/routes/{route name or id}/service</div>

Attributes | Description
---:| ---
`route name or id`<br>**required** | The unique identifier **or** the name of the Route associated to the Service to be updated.


##### Update Service Associated to a Specific Plugin

<div class="endpoint patch">/plugins/{plugin id}/service</div>

Attributes | Description
---:| ---
`plugin id`<br>**required** | The unique identifier of the Plugin associated to the Service to be updated.


*Request Body*

{{ page.service_body }}


*Response*

```
HTTP 200 OK
```

```json
{{ page.service_json }}
```


---

### Update Or Create Service

##### Create Or Update Service

<div class="endpoint put">/services/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the Service to create or update.


##### Create Or Update Service Associated to a Specific Route

<div class="endpoint put">/routes/{route name or id}/service</div>

Attributes | Description
---:| ---
`route name or id`<br>**required** | The unique identifier **or** the name of the Route associated to the Service to be created or updated.


##### Create Or Update Service Associated to a Specific Plugin

<div class="endpoint put">/plugins/{plugin id}/service</div>

Attributes | Description
---:| ---
`plugin id`<br>**required** | The unique identifier of the Plugin associated to the Service to be created or updated.


*Request Body*

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


*Response*

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


##### Delete Service Associated to a Specific Route

<div class="endpoint delete">/routes/{route name or id}/service</div>

Attributes | Description
---:| ---
`route name or id`<br>**required** | The unique identifier **or** the name of the Route associated to the Service to be deleted.


*Response*

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

Routes can be both [tagged and filtered by tags](#tags).


```json
{{ page.route_json }}
```

### Add Route

##### Create Route

<div class="endpoint post">/routes</div>


##### Create Route Associated to a Specific Service

<div class="endpoint post">/services/{service name or id}/routes</div>

Attributes | Description
---:| ---
`service name or id`<br>**required** | The unique identifier or the `name` attribute of the Service that should be associated to the newly-created Route.


*Request Body*

{{ page.route_body }}


*Response*

```
HTTP 201 Created
```

```json
{{ page.route_json }}
```


---

### List Routes

##### List All Routes

<div class="endpoint get">/routes</div>


##### List Routes Associated to a Specific Service

<div class="endpoint get">/services/{service name or id}/routes</div>

Attributes | Description
---:| ---
`service name or id`<br>**required** | The unique identifier or the `name` attribute of the Service whose Routes are to be retrieved. When using this endpoint, only Routes associated to the specified Service will be listed.


*Response*

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


##### Retrieve Route Associated to a Specific Plugin

<div class="endpoint get">/plugins/{plugin id}/route</div>

Attributes | Description
---:| ---
`plugin id`<br>**required** | The unique identifier of the Plugin associated to the Route to be retrieved.


*Response*

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


##### Update Route Associated to a Specific Plugin

<div class="endpoint patch">/plugins/{plugin id}/route</div>

Attributes | Description
---:| ---
`plugin id`<br>**required** | The unique identifier of the Plugin associated to the Route to be updated.


*Request Body*

{{ page.route_body }}


*Response*

```
HTTP 200 OK
```

```json
{{ page.route_json }}
```


---

### Update Or Create Route

##### Create Or Update Route

<div class="endpoint put">/routes/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the Route to create or update.


##### Create Or Update Route Associated to a Specific Plugin

<div class="endpoint put">/plugins/{plugin id}/route</div>

Attributes | Description
---:| ---
`plugin id`<br>**required** | The unique identifier of the Plugin associated to the Route to be created or updated.


*Request Body*

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


*Response*

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


*Response*

```
HTTP 204 No Content
```


---

## Consumer Object

The Consumer object represents a consumer - or a user - of a Service. You can
either rely on Kong as the primary datastore, or you can map the consumer list
with your database to keep consistency between Kong and your existing primary
datastore.

Consumers can be both [tagged and filtered by tags](#tags).


```json
{{ page.consumer_json }}
```

### Add Consumer

##### Create Consumer

<div class="endpoint post">/consumers</div>


*Request Body*

{{ page.consumer_body }}


*Response*

```
HTTP 201 Created
```

```json
{{ page.consumer_json }}
```


---

### List Consumers

##### List All Consumers

<div class="endpoint get">/consumers</div>


*Response*

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


##### Retrieve Consumer Associated to a Specific Plugin

<div class="endpoint get">/plugins/{plugin id}/consumer</div>

Attributes | Description
---:| ---
`plugin id`<br>**required** | The unique identifier of the Plugin associated to the Consumer to be retrieved.


*Response*

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


##### Update Consumer Associated to a Specific Plugin

<div class="endpoint patch">/plugins/{plugin id}/consumer</div>

Attributes | Description
---:| ---
`plugin id`<br>**required** | The unique identifier of the Plugin associated to the Consumer to be updated.


*Request Body*

{{ page.consumer_body }}


*Response*

```
HTTP 200 OK
```

```json
{{ page.consumer_json }}
```


---

### Update Or Create Consumer

##### Create Or Update Consumer

<div class="endpoint put">/consumers/{username or id}</div>

Attributes | Description
---:| ---
`username or id`<br>**required** | The unique identifier **or** the username of the Consumer to create or update.


##### Create Or Update Consumer Associated to a Specific Plugin

<div class="endpoint put">/plugins/{plugin id}/consumer</div>

Attributes | Description
---:| ---
`plugin id`<br>**required** | The unique identifier of the Plugin associated to the Consumer to be created or updated.


*Request Body*

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


*Response*

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


*Response*

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
values for some specific Consumers, you can do so by creating a separate
plugin instance that specifies both the Service and the Consumer, through the
`service` and `consumer` fields.

Plugins can be both [tagged and filtered by tags](#tags).


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


##### Create Plugin Associated to a Specific Route

<div class="endpoint post">/routes/{route id}/plugins</div>

Attributes | Description
---:| ---
`route id`<br>**required** | The unique identifier of the Route that should be associated to the newly-created Plugin.


##### Create Plugin Associated to a Specific Service

<div class="endpoint post">/services/{service id}/plugins</div>

Attributes | Description
---:| ---
`service id`<br>**required** | The unique identifier of the Service that should be associated to the newly-created Plugin.


##### Create Plugin Associated to a Specific Consumer

<div class="endpoint post">/consumers/{consumer id}/plugins</div>

Attributes | Description
---:| ---
`consumer id`<br>**required** | The unique identifier of the Consumer that should be associated to the newly-created Plugin.


*Request Body*

{{ page.plugin_body }}


*Response*

```
HTTP 201 Created
```

```json
{{ page.plugin_json }}
```


---

### List Plugins

##### List All Plugins

<div class="endpoint get">/plugins</div>


##### List Plugins Associated to a Specific Route

<div class="endpoint get">/routes/{route id}/plugins</div>

Attributes | Description
---:| ---
`route id`<br>**required** | The unique identifier of the Route whose Plugins are to be retrieved. When using this endpoint, only Plugins associated to the specified Route will be listed.


##### List Plugins Associated to a Specific Service

<div class="endpoint get">/services/{service id}/plugins</div>

Attributes | Description
---:| ---
`service id`<br>**required** | The unique identifier of the Service whose Plugins are to be retrieved. When using this endpoint, only Plugins associated to the specified Service will be listed.


##### List Plugins Associated to a Specific Consumer

<div class="endpoint get">/consumers/{consumer id}/plugins</div>

Attributes | Description
---:| ---
`consumer id`<br>**required** | The unique identifier of the Consumer whose Plugins are to be retrieved. When using this endpoint, only Plugins associated to the specified Consumer will be listed.


*Response*

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


*Response*

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


*Request Body*

{{ page.plugin_body }}


*Response*

```
HTTP 200 OK
```

```json
{{ page.plugin_json }}
```


---

### Update Or Create Plugin

##### Create Or Update Plugin

<div class="endpoint put">/plugins/{plugin id}</div>

Attributes | Description
---:| ---
`plugin id`<br>**required** | The unique identifier of the Plugin to create or update.


*Request Body*

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


*Response*

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


*Response*

```
HTTP 204 No Content
```


---

### Retrieve Enabled Plugins

Retrieve a list of all installed plugins on the Kong node.

<div class="endpoint get">/plugins/enabled</div>

*Response*

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

*Response*

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

A certificate object represents a public certificate, and can be optionally paired with the
corresponding private key. These objects are used by Kong to handle SSL/TLS termination for
encrypted requests, or for use as a trusted CA store when validating peer certificate of
client/service. Certificates are optionally associated with SNI objects to
tie a cert/key pair to one or more hostnames.

Certificates can be both [tagged and filtered by tags](#tags).


```json
{{ page.certificate_json }}
```

### Add Certificate

##### Create Certificate

<div class="endpoint post">/certificates</div>


*Request Body*

{{ page.certificate_body }}


*Response*

```
HTTP 201 Created
```

```json
{{ page.certificate_json }}
```


---

### List Certificates

##### List All Certificates

<div class="endpoint get">/certificates</div>


*Response*

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


*Response*

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


*Request Body*

{{ page.certificate_body }}


*Response*

```
HTTP 200 OK
```

```json
{{ page.certificate_json }}
```


---

### Update Or Create Certificate

##### Create Or Update Certificate

<div class="endpoint put">/certificates/{certificate id}</div>

Attributes | Description
---:| ---
`certificate id`<br>**required** | The unique identifier of the Certificate to create or update.


*Request Body*

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


*Response*

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


*Response*

```
HTTP 204 No Content
```


---

## SNI Object

An SNI object represents a many-to-one mapping of hostnames to a certificate.
That is, a certificate object can have many hostnames associated with it; when
Kong receives an SSL request, it uses the SNI field in the Client Hello to
lookup the certificate object based on the SNI associated with the certificate.

SNIs can be both [tagged and filtered by tags](#tags).


```json
{{ page.sni_json }}
```

### Add SNI

##### Create SNI

<div class="endpoint post">/snis</div>


##### Create SNI Associated to a Specific Certificate

<div class="endpoint post">/certificates/{certificate name or id}/snis</div>

Attributes | Description
---:| ---
`certificate name or id`<br>**required** | The unique identifier or the `name` attribute of the Certificate that should be associated to the newly-created SNI.


*Request Body*

{{ page.sni_body }}


*Response*

```
HTTP 201 Created
```

```json
{{ page.sni_json }}
```


---

### List SNIs

##### List All SNIs

<div class="endpoint get">/snis</div>


##### List SNIs Associated to a Specific Certificate

<div class="endpoint get">/certificates/{certificate name or id}/snis</div>

Attributes | Description
---:| ---
`certificate name or id`<br>**required** | The unique identifier or the `name` attribute of the Certificate whose SNIs are to be retrieved. When using this endpoint, only SNIs associated to the specified Certificate will be listed.


*Response*

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


*Response*

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


*Request Body*

{{ page.sni_body }}


*Response*

```
HTTP 200 OK
```

```json
{{ page.sni_json }}
```


---

### Update Or Create SNI

##### Create Or Update SNI

<div class="endpoint put">/snis/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the SNI to create or update.


*Request Body*

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


*Response*

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


*Response*

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

Upstreams can be both [tagged and filtered by tags](#tags).


```json
{{ page.upstream_json }}
```

### Add Upstream

##### Create Upstream

<div class="endpoint post">/upstreams</div>


*Request Body*

{{ page.upstream_body }}


*Response*

```
HTTP 201 Created
```

```json
{{ page.upstream_json }}
```


---

### List Upstreams

##### List All Upstreams

<div class="endpoint get">/upstreams</div>


*Response*

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


##### Retrieve Upstream Associated to a Specific Target

<div class="endpoint get">/targets/{target host:port or id}/upstream</div>

Attributes | Description
---:| ---
`target host:port or id`<br>**required** | The unique identifier **or** the host:port of the Target associated to the Upstream to be retrieved.


*Response*

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


##### Update Upstream Associated to a Specific Target

<div class="endpoint patch">/targets/{target host:port or id}/upstream</div>

Attributes | Description
---:| ---
`target host:port or id`<br>**required** | The unique identifier **or** the host:port of the Target associated to the Upstream to be updated.


*Request Body*

{{ page.upstream_body }}


*Response*

```
HTTP 200 OK
```

```json
{{ page.upstream_json }}
```


---

### Update Or Create Upstream

##### Create Or Update Upstream

<div class="endpoint put">/upstreams/{name or id}</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the Upstream to create or update.


##### Create Or Update Upstream Associated to a Specific Target

<div class="endpoint put">/targets/{target host:port or id}/upstream</div>

Attributes | Description
---:| ---
`target host:port or id`<br>**required** | The unique identifier **or** the host:port of the Target associated to the Upstream to be created or updated.


*Request Body*

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


*Response*

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


##### Delete Upstream Associated to a Specific Target

<div class="endpoint delete">/targets/{target host:port or id}/upstream</div>

Attributes | Description
---:| ---
`target host:port or id`<br>**required** | The unique identifier **or** the host:port of the Target associated to the Upstream to be deleted.


*Response*

```
HTTP 204 No Content
```


---

### Show Upstream Health for Node

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


*Response*

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

Targets can be both [tagged and filtered by tags](#tags).


```json
{{ page.target_json }}
```

### Add Target

##### Create Target Associated to a Specific Upstream

<div class="endpoint post">/upstreams/{upstream host:port or id}/targets</div>

Attributes | Description
---:| ---
`upstream host:port or id`<br>**required** | The unique identifier or the `host:port` attribute of the Upstream that should be associated to the newly-created Target.


*Request Body*

{{ page.target_body }}


*Response*

```
HTTP 201 Created
```

```json
{{ page.target_json }}
```


---

### List Targets

##### List Targets Associated to a Specific Upstream

<div class="endpoint get">/upstreams/{upstream host:port or id}/targets</div>

Attributes | Description
---:| ---
`upstream host:port or id`<br>**required** | The unique identifier or the `host:port` attribute of the Upstream whose Targets are to be retrieved. When using this endpoint, only Targets associated to the specified Upstream will be listed.


*Response*

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


*Response*

```
HTTP 204 No Content
```


---

### Set Target As Healthy

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


*Response*

```
HTTP 204 No Content
```


---

### Set Target As Unhealthy

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


*Response*

```
HTTP 204 No Content
```


---

### List All Targets

Lists all targets of the upstream. Multiple target objects for the same
target may be returned, showing the history of changes for a specific target.
The target object with the latest `created_at` is the current definition.


<div class="endpoint get">/upstreams/{name or id}/targets/all/</div>

Attributes | Description
---:| ---
`name or id`<br>**required** | The unique identifier **or** the name of the upstream for which to list the targets.


*Response*

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
[db-less-admin-api]: /{{page.kong_version}}/db-less-admin-api
