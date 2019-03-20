return {

--------------------------------------------------------------------------------
-- Known files and entities, to compare what's coded to what's documented
--
-- We avoid automagic detection based on traversal of filesystem and modules,
-- so that adding new info to the documentation becomes a conscious process.
-- We traverse the filesystem and modules to cross-check that everything that
-- is present in the code is either documented or consciously omitted from
-- the docs (e.g. in the last stage of deprecation).
--------------------------------------------------------------------------------

  known = {
    general_files = {
      "kong/api/routes/kong.lua",
    },
    nodoc_files = {
      "kong/api/routes/cache.lua", -- FIXME should we document this?
    },
    entities = {
      "services",
      "routes",
      "consumers",
      "plugins",
      "certificates",
      "snis",
      "upstreams",
      "targets",
    },
    nodoc_entities = {
    },
  },

--------------------------------------------------------------------------------
-- General (non-entity) Admin API route files
--------------------------------------------------------------------------------

  intro = [[

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

  ]],

  footer = [[
    [clustering]: /{{page.kong_version}}/clustering
    [cli]: /{{page.kong_version}}/cli
    [active]: /{{page.kong_version}}/health-checks-circuit-breakers/#active-health-checks
    [healthchecks]: /{{page.kong_version}}/health-checks-circuit-breakers
    [secure-admin-api]: /{{page.kong_version}}/secure-admin-api
    [proxy-reference]: /{{page.kong_version}}/proxy
  ]],

  general = {
    kong = {
      title = [[Information routes]],
      description = "",
      ["/"] = {
        GET = {
          title = [[Retrieve node information]],
          endpoint = [[<div class="endpoint get">/</div>]],
          description = [[Retrieve generic details about a node.]],
          response =[[
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
          ]],
        },
      },
      ["/status"] = {
        GET = {
          title = [[Retrieve node status]],
          endpoint = [[<div class="endpoint get">/status</div>]],
          description = [[
            Retrieve usage information about a node, with some basic information
            about the connections being processed by the underlying nginx process,
            and the status of the database connection.

            If you want to monitor the Kong process, since Kong is built on top
            of nginx, every existing nginx monitoring tool or agent can be used.
          ]],
          response = [[
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
          ]],
        },
      }
    }
  },

--------------------------------------------------------------------------------
-- Entities
--------------------------------------------------------------------------------

  entities = {

    services = {
      description = [[
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
      ]],
      fields = {
        id = { skip = true },
        created_at = { skip = true },
        updated_at = { skip = true },
        name = {
          description = [[The Service name.]]
        },
        protocol = {
          description = [[
            The protocol used to communicate with the upstream.
            It can be one of `http` or `https`.
          ]]
        },
        host = {
          description = [[The host of the upstream server.]],
          example = "example.com",
        },
        port = {
          description = [[The upstream server port.]]
        },
        path = {
          description = [[The path to be used in requests to the upstream server.]],
          examples = {
            "/some_api",
            "/another_api",
          }
        },
        retries = {
          description = [[The number of retries to execute upon failure to proxy.]]
        },
        connect_timeout = {
          description = [[
            The timeout in milliseconds for establishing a connection to the
            upstream server.
          ]]
        },
        write_timeout = {
          description = [[
            The timeout in milliseconds between two successive write operations
            for transmitting a request to the upstream server.
          ]]
        },
        read_timeout = {
          description = [[
            The timeout in milliseconds between two successive read operations
            for transmitting a request to the upstream server.
          ]]
        },
      },
      extra_fields = {
        { url = {
          kind = "shorthand-attribute",
          description = [[
            Shorthand attribute to set `protocol`, `host`, `port` and `path`
            at once. This attribute is write-only (the Admin API never
            "returns" the url).
          ]]
        } },
      }
    },

    routes = {
      description = [[
        Route entities define rules to match client requests. Each Route is
        associated with a Service, and a Service may have multiple Routes associated to
        it. Every request matching a given Route will be proxied to its associated
        Service.

        The combination of Routes and Services (and the separation of concerns between
        them) offers a powerful routing mechanism with which it is possible to define
        fine-grained entry-points in Kong leading to different upstream services of
        your infrastructure.
      ]],
      fields = {
        id = { skip = true },
        created_at = { skip = true },
        updated_at = { skip = true },
        name = {
          description = [[The name of the Route.]]
        },
        regex_priority = {
          description = [[
            A number used to choose which route resolves a given request when several
            routes match it using regexes simultaneously. When two routes match the path
            and have the same `regex_priority`, the older one (lowest `created_at`)
            is used. Note that the priority for non-regex routes is different (longer
            non-regex routes are matched before shorter ones).
          ]]
        },
        protocols = {
          description = [[
            A list of the protocols this Route should allow. When set to `["https"]`,
            HTTP requests are answered with a request to upgrade to HTTPS.
          ]],
          examples = {
            {"http", "https"},
            {"tcp", "tls"},
          }
        },
        methods = {
          kind = "semi-optional",
          description = [[
            A list of HTTP methods that match this Route.
            When using `http` or `https` protocols, at least one of `hosts`, `paths`, or `methods` must be set.
          ]],
          examples = { {"GET", "POST"}, nil },
          skip_in_example = true, -- hack so we get HTTP fields in the first example and Stream fields in the second
        },
        hosts = {
          kind = "semi-optional",
          description = [[
            A list of domain names that match this Route.
            When using `http` or `https` protocols, at least one of `hosts`, `paths`, or `methods` must be set.
          ]],
          examples = { {"example.com", "foo.test"}, nil },
          skip_in_example = true, -- hack so we get HTTP fields in the first example and Stream fields in the second
        },
        paths = {
          kind = "semi-optional",
          description = [[
            A list of paths that match this Route.
            When using `http` or `https` protocols, at least one of `hosts`, `paths`, or `methods` must be set.
          ]],
          examples = { {"/foo", "/bar"}, nil },
          skip_in_example = true, -- hack so we get HTTP fields in the first example and Stream fields in the second
        },
        snis = {
          kind = "semi-optional",
          description = [[
            A list of SNIs that match this Route when using stream routing.
            When using `tcp` or `tls` protocols, at least one of `snis`, `sources`, or `destinations` must be set.
          ]],
          examples = { nil, {"foo.test", "example.com"} },
          skip_in_example = true, -- hack so we get HTTP fields in the first example and Stream fields in the second
        },
        sources = {
          kind = "semi-optional",
          description = [[
            A list of IP sources of incoming connections that match this Route when using stream routing.
            Each entry is an object with fields "ip" (optionally in CIDR range notation) and/or "port".
            When using `tcp` or `tls` protocols, at least one of `snis`, `sources`, or `destinations` must be set.
          ]],
          examples = { nil, {{ip = "10.1.0.0/16", port = 1234}, {ip = "10.2.2.2"}, {port = 9123}} },
          skip_in_example = true, -- hack so we get HTTP fields in the first example and Stream fields in the second
        },
        destinations = {
          kind = "semi-optional",
          description = [[
            A list of IP destinations of incoming connections that match this Route when using stream routing.
            Each entry is an object with fields "ip" (optionally in CIDR range notation) and/or "port".
            When using `tcp` or `tls` protocols, at least one of `snis`, `sources`, or `destinations` must be set.
          ]],
          examples = { nil, {{ip = "10.1.0.0/16", port = 1234}, {ip = "10.2.2.2"}, {port = 9123}} },
          skip_in_example = true, -- hack so we get HTTP fields in the first example and Stream fields in the second
        },
        strip_path = {
          description = [[
            When matching a Route via one of the `paths`,
            strip the matching prefix from the upstream request URL.
          ]]
        },
        preserve_host = {
          description = [[
            When matching a Route via one of the `hosts` domain names,
            use the request `Host` header in the upstream request headers.
            If set to `false`, the upstream `Host` header will be that of
            the Service's `host`.
          ]]
        },
        service = {
          description = [[
            The Service this Route is associated to.
            This is where the Route proxies traffic to.
          ]]
        },
      }
    },

    consumers = {
      description = [[
        The Consumer object represents a consumer - or a user - of a Service. You can
        either rely on Kong as the primary datastore, or you can map the consumer list
        with your database to keep consistency between Kong and your existing primary
        datastore.
      ]],
      fields = {
        id = { skip = true },
        created_at = { skip = true },
        updated_at = { skip = true },
        username = {
          kind = "semi-optional",
          description = [[
            The unique username of the consumer. You must send either
            this field or `custom_id` with the request.
          ]],
          example = "my-username",
        },
        custom_id = {
          kind = "semi-optional",
          description = [[
            Field for storing an existing unique ID for the consumer -
            useful for mapping Kong with users in your existing database.
            You must send either this field or `username` with the request.
          ]],
          example = "my-custom-id",
        },
      }
    },

    plugins = {
      description = [[
        A Plugin entity represents a plugin configuration that will be executed during
        the HTTP request/response lifecycle. It is how you can add functionalities
        to Services that run behind Kong, like Authentication or Rate Limiting for
        example. You can find more information about how to install and what values
        each plugin takes by visiting the [Kong Hub](https://docs.konghq.com/hub/).

        When adding a Plugin Configuration to a Service, every request made by a client to
        that Service will run said Plugin. If a Plugin needs to be tuned to different
        values for some specific Consumers, you can do so by specifying the
        `consumer_id` value:
      ]],
      details = [[
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
      ]],

      ["/plugins/schema/:name"] = {
        GET = {
          title = [[Retrieve Plugin Schema]],
          endpoint = [[<div class="endpoint get">/plugins/schema/{plugin name}</div>]],
          description = [[
            Retrieve the schema of a plugin's configuration. This is useful to
            understand what fields a plugin accepts, and can be used for building
            third-party integrations to the Kong's plugin system.
          ]],
          response = [[
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
          ]],
        }
      },

      ["/plugins/enabled"] = {
        GET = {
          title = [[Retrieve Enabled Plugins]],
          description = [[Retrieve a list of all installed plugins on the Kong node.]],
          endpoint = [[<div class="endpoint get">/plugins/enabled</div>]],
          response = [[
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
          ]]
        }
      },

      -- While these endpoints actually support DELETE (deleting the entity and
      -- cascade-deleting the plugin), we do not document them, as this operation
      -- is somewhat odd.
      ["/plugins/:plugins/route"] = {
        DELETE = {
          endpoint = false,
        }
      },
      ["/plugins/:plugins/service"] = {
        DELETE = {
          endpoint = false,
        }
      },
      ["/plugins/:plugins/consumer"] = {
        DELETE = {
          endpoint = false,
        }
      },
      -- Skip deprecated endpoints
      ["/routes/:routes/plugins/:id"] = {
        skip = true,
      },
      ["/services/:services/plugins/:id"] = {
        skip = true,
      },
      ["/consumers/:consumers/plugins/:id"] = {
        skip = true,
      },

      fields = {
        id = { skip = true },
        created_at = { skip = true },
        updated_at = { skip = true },
        name = {
          description = [[
            The name of the Plugin that's going to be added. Currently the
            Plugin must be installed in every Kong instance separately.
          ]],
          example = "rate-limiting",
        },
        config = {
          description = [[
            The configuration properties for the Plugin which can be found on
            the plugins documentation page in the
            [Kong Hub](https://docs.konghq.com/hub/).
          ]],
          example = { minute = 20, hour = 500 },
        },
        enabled = { description = [[Whether the plugin is applied.]] },
        route = { description = [[
          If set, the plugin will only activate when receiving requests via the specified route. Leave
          unset for the plugin to activate regardless of the Route being used.
        ]] },
        service = { description = [[
          If set, the plugin will only activate when receiving requests via one of the routes belonging to the
          specified Service. Leave unset for the plugin to activate regardless of the Service being
          matched.
        ]] },
        consumer = { description = [[
          If set, the plugin will activate only for requests where the specified has been authenticated.
          (Note that some plugins can not be restricted to consumers this way.). Leave unset for the plugin
          to activate regardless of the authenticated consumer.
        ]] },
        run_on = { description = [[
          Control on which Kong nodes this plugin will run, given a Service Mesh scenario.
          Accepted values are:
          * `first`, meaning "run on the first Kong node that is encountered by the request".
            On an API Getaway scenario, this is the usual operation, since there is only
            one Kong node in between source and destination. In a sidecar-to-sidecar Service
            Mesh scenario, this means running the plugin only on the
            Kong sidecar of the outbound connection.
          * `second`, meaning "run on the second node that is encountered by the request".
            This option is only relevant for sidecar-to-sidecar Service
            Mesh scenarios: this means running the plugin only on the
            Kong sidecar of the inbound connection.
          * `all` means "run on all nodes", meaning both sidecars in a sidecar-to-sidecar
            scenario. This is useful for tracing/logging plugins.
        ]] },
      }
    },

    certificates = {
      description = [[
        A certificate object represents a public certificate/private key pair for an SSL
        certificate. These objects are used by Kong to handle SSL/TLS termination for
        encrypted requests. Certificates are optionally associated with SNI objects to
        tie a cert/key pair to one or more hostnames.
      ]],
      fields = {
        id = { skip = true },
        created_at = { skip = true },
        cert = {
          description = [[PEM-encoded public certificate of the SSL key pair.]],
          example = "-----BEGIN CERTIFICATE-----...",
        },
        key = {
          description = [[PEM-encoded private key of the SSL key pair.]],
          example = "-----BEGIN RSA PRIVATE KEY-----..."
        },
      },
      extra_fields = {
        { snis = {
          kind = "shorthand-attribute",
          description = [[
            An array of zero or more hostnames to associate with this
            certificate as SNIs. This is a sugar parameter that will, under the
            hood, create an SNI object and associate it with this certificate
            for your convenience.
          ]]
        } },
      }
    },

    snis = {
      entity_title = "SNI",
      entity_title_plural = "SNIs",
      description = [[
        An SNI object represents a many-to-one mapping of hostnames to a certificate.
        That is, a certificate object can have many hostnames associated with it; when
        Kong receives an SSL request, it uses the SNI field in the Client Hello to
        lookup the certificate object based on the SNI associated with the certificate.
      ]],
      ["/snis/:snis/certificate"] = {
        endpoint = false,
      },
      fields = {
        id = { skip = true },
        created_at = { skip = true },
        name = { description = [[The SNI name to associate with the given certificate.]] },
        certificate = {
          description = [[
            The id (a UUID) of the certificate with which to associate the SNI hostname
          ]]
        },
      },
    },

    upstreams = {
      description = [[
        The upstream object represents a virtual hostname and can be used to loadbalance
        incoming requests over multiple services (targets). So for example an upstream
        named `service.v1.xyz` for a Service object whose `host` is `service.v1.xyz`.
        Requests for this Service would be proxied to the targets defined within the upstream.

        An upstream also includes a [health checker][healthchecks], which is able to
        enable and disable targets based on their ability or inability to serve
        requests. The configuration for the health checker is stored in the upstream
        object, and applies to all of its targets.
      ]],
      ["/upstreams/:upstreams/health"] = {
        GET = {
          title = [[Show Upstream health for node]],
          description = [[
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
          ]],
          endpoint = [[
            <div class="endpoint get">/upstreams/{name or id}/health/</div>

            Attributes | Description
            ---:| ---
            `name or id`<br>**required** | The unique identifier **or** the name of the Upstream for which to display Target health.
          ]],
          response = [[
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
          ]],
        }
      },
      fields = {
        id = { skip = true },
        created_at = { skip = true },
        ["name"] = { description = [[This is a hostname, which must be equal to the `host` of a Service.]] },
        ["slots"] = { description = [[The number of slots in the loadbalancer algorithm (`10`-`65536`).]] },
        ["hash_on"] = { description = [[What to use as hashing input: `none` (resulting in a weighted-round-robin scheme with no hashing), `consumer`, `ip`, `header`, or `cookie`.]] },
        ["hash_fallback"] = { description = [[What to use as hashing input if the primary `hash_on` does not return a hash (eg. header is missing, or no consumer identified). One of: `none`, `consumer`, `ip`, `header`, or `cookie`. Not available if `hash_on` is set to `cookie`.]] },
        ["hash_on_header"] = { kind = "semi-optional", skip_in_example = true, description = [[The header name to take the value from as hash input. Only required when `hash_on` is set to `header`.]] },
        ["hash_fallback_header"] = { kind = "semi-optional", skip_in_example = true, description = [[The header name to take the value from as hash input. Only required when `hash_fallback` is set to `header`.]] },
        ["hash_on_cookie"] = { kind = "semi-optional", skip_in_example = true, description = [[The cookie name to take the value from as hash input. Only required when `hash_on` or `hash_fallback` is set to `cookie`. If the specified cookie is not in the request, Kong will generate a value and set the cookie in the response.]] },
        ["hash_on_cookie_path"] = { kind = "semi-optional", skip_in_example = true, description = [[The cookie path to set in the response headers. Only required when `hash_on` or `hash_fallback` is set to `cookie`.]] },
        ["healthchecks.active.timeout"] = { description = [[Socket timeout for active health checks (in seconds).]] },
        ["healthchecks.active.concurrency"] = { description = [[Number of targets to check concurrently in active health checks.]] },
        ["healthchecks.active.type"] = { description = [[Whether to perform active health checks using HTTP or HTTPS, or just attempt a TCP connection. Possible values are `tcp`, `http` or `https`.]] },
        ["healthchecks.active.http_path"] = { description = [[Path to use in GET HTTP request to run as a probe on active health checks.]] },
        ["healthchecks.active.https_verify_certificate"] = { description = [[Whether to check the validity of the SSL certificate of the remote host when performing active health checks using HTTPS.]] },
        ["healthchecks.active.https_sni"] = { description = [[The hostname to use as an SNI (Server Name Identification) when performing active health checks using HTTPS. This is particularly useful when Targets are configured using IPs, so that the target host's certificate can be verified with the proper SNI.]], example = "example.com", },
        ["healthchecks.active.healthy.interval"] = { description = [[Interval between active health checks for healthy targets (in seconds). A value of zero indicates that active probes for healthy targets should not be performed.]] },
        ["healthchecks.active.healthy.http_statuses"] = { description = [[An array of HTTP statuses to consider a success, indicating healthiness, when returned by a probe in active health checks.]] },
        ["healthchecks.active.healthy.successes"] = { description = [[Number of successes in active probes (as defined by `healthchecks.active.healthy.http_statuses`) to consider a target healthy.]] },
        ["healthchecks.active.unhealthy.interval"] = { description = [[Interval between active health checks for unhealthy targets (in seconds). A value of zero indicates that active probes for unhealthy targets should not be performed.]] },
        ["healthchecks.active.unhealthy.http_statuses"] = { description = [[An array of HTTP statuses to consider a failure, indicating unhealthiness, when returned by a probe in active health checks.]] },
        ["healthchecks.active.unhealthy.tcp_failures"] = { description = [[Number of TCP failures in active probes to consider a target unhealthy.]] },
        ["healthchecks.active.unhealthy.timeouts"] = { description = [[Number of timeouts in active probes to consider a target unhealthy.]] },
        ["healthchecks.active.unhealthy.http_failures"] = { description = [[Number of HTTP failures in active probes (as defined by `healthchecks.active.unhealthy.http_statuses`) to consider a target unhealthy.]] },
        ["healthchecks.passive.type"] = { description = [[Whether to perform passive health checks interpreting HTTP/HTTPS statuses, or just check for TCP connection success. Possible values are `tcp`, `http` or `https` (in passive checks, `http` and `https` options are equivalent.).]] },
        ["healthchecks.passive.healthy.http_statuses"] = { description = [[An array of HTTP statuses which represent healthiness when produced by proxied traffic, as observed by passive health checks.]] },
        ["healthchecks.passive.healthy.successes"] = { description = [[Number of successes in proxied traffic (as defined by `healthchecks.passive.healthy.http_statuses`) to consider a target healthy, as observed by passive health checks.]] },
        ["healthchecks.passive.unhealthy.http_statuses"] = { description = [[An array of HTTP statuses which represent unhealthiness when produced by proxied traffic, as observed by passive health checks.]] },
        ["healthchecks.passive.unhealthy.tcp_failures"] = { description = [[Number of TCP failures in proxied traffic to consider a target unhealthy, as observed by passive health checks.]] },
        ["healthchecks.passive.unhealthy.timeouts"] = { description = [[Number of timeouts in proxied traffic to consider a target unhealthy, as observed by passive health checks.]] },
        ["healthchecks.passive.unhealthy.http_failures"] = { description = [[Number of HTTP failures in proxied traffic (as defined by `healthchecks.passive.unhealthy.http_statuses`) to consider a target unhealthy, as observed by passive health checks.]] },
      }
    },

    targets = {
      entity_endpoint_key = "host:port",
      description = [[
        A target is an ip address/hostname with a port that identifies an instance of a backend
        service. Every upstream can have many targets, and the targets can be
        dynamically added. Changes are effectuated on the fly.

        Because the upstream maintains a history of target changes, the targets cannot
        be deleted or modified. To disable a target, post a new one with `weight=0`;
        alternatively, use the `DELETE` convenience method to accomplish the same.

        The current target object definition is the one with the latest `created_at`.
      ]],
      ["/targets"] = {
        -- This is not using `skip = true` because
        -- we want the sections for GETting targets and POSTing targets to appear,
        -- but we don't want them to appear using `GET /targets` and `POST /targets`.
        -- Instead, we want the section itself to appear, but only the endpoints
        -- generated via foreign keys (`GET /upstreams/:upstreams/targets` and
        -- `POST /upstreams/:upstream/targets`)
        endpoint = false,
      },
      ["/targets/:targets"] = {
        skip = true,
      },
      ["/targets/:targets/upstreams"] = {
        skip = true,
      },
      ["/upstreams/:upstreams/targets/:targets"] = {
        DELETE = {
          title = [[Delete Target]],
          description = [[
            Disable a target in the load balancer. Under the hood, this method creates
            a new entry for the given target definition with a `weight` of 0.
          ]],
          endpoint = [[
            <div class="endpoint delete">/upstreams/{upstream name or id}/targets/{host:port or id}</div>

            Attributes | Description
            ---:| ---
            `upstream name or id`<br>**required** | The unique identifier **or** the name of the upstream for which to delete the target.
            `host:port or id`<br>**required** | The host:port combination element of the target to remove, or the `id` of an existing target entry.
          ]],
          response = [[
            ```
            HTTP 204 No Content
            ```
          ]]
        }
      },

      ["/upstreams/:upstreams/targets/all"] = {
        GET = {
          title = [[List all Targets]],
          description = [[
            Lists all targets of the upstream. Multiple target objects for the same
            target may be returned, showing the history of changes for a specific target.
            The target object with the latest `created_at` is the current definition.
          ]],
          endpoint = [[
            <div class="endpoint get">/upstreams/{name or id}/targets/all/</div>

            Attributes | Description
            ---:| ---
            `name or id`<br>**required** | The unique identifier **or** the name of the upstream for which to list the targets.
          ]],
          response = [[
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
          ]],
        }
      },
      ["/upstreams/:upstreams/targets/:targets/healthy"] = {
        POST = {
          title = [[Set target as healthy]],
          description = [[
            Set the current health status of a target in the load balancer to "healthy"
            in the entire Kong cluster.

            This endpoint can be used to manually re-enable a target that was previously
            disabled by the upstream's [health checker][healthchecks]. Upstreams only
            forward requests to healthy nodes, so this call tells Kong to start using this
            target again.

            This resets the health counters of the health checkers running in all workers
            of the Kong node, and broadcasts a cluster-wide message so that the "healthy"
            status is propagated to the whole Kong cluster.
          ]],
          endpoint = [[
            <div class="endpoint post">/upstreams/{upstream name or id}/targets/{target or id}/healthy</div>

            Attributes | Description
            ---:| ---
            `upstream name or id`<br>**required** | The unique identifier **or** the name of the upstream.
            `target or id`<br>**required** | The host/port combination element of the target to set as healthy, or the `id` of an existing target entry.
          ]],
          response = [[
            ```
            HTTP 204 No Content
            ```
          ]],
        }
      },
      ["/upstreams/:upstreams/targets/:targets/unhealthy"] = {
        POST = {
          title = [[Set target as unhealthy]],
          description = [[
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
          ]],
          endpoint = [[
            <div class="endpoint post">/upstreams/{upstream name or id}/targets/{target or id}/unhealthy</div>

            Attributes | Description
            ---:| ---
            `upstream name or id`<br>**required** | The unique identifier **or** the name of the upstream.
            `target or id`<br>**required** | The host/port combination element of the target to set as unhealthy, or the `id` of an existing target entry.
          ]],
          response = [[
            ```
            HTTP 204 No Content
            ```
          ]],
        }
      },
      fields = {
        id = { skip = true },
        created_at = { skip = true },
        upstream = { skip = true },
        target = {
          description = [[
            The target address (ip or hostname) and port.
            If the hostname resolves to an SRV record, the `port` value will
            be overridden by the value from the DNS record.
          ]],
          example = "example.com:8000",
        },
        weight = {
          description = [[
            The weight this target gets within the upstream loadbalancer (`0`-`1000`).
            If the hostname resolves to an SRV record, the `weight` value will be
            overridden by the value from the DNS record.
          ]]
        },
      },
    }
  },

--------------------------------------------------------------------------------
-- Templates for auto-generated endpoints
--------------------------------------------------------------------------------

  collection_templates = {
    GET = {
      title = [[List ${Entities}]],
      endpoint_w_ek = [[
        ##### List all ${Entities}

        <div class="endpoint ${method}">/${entities_url}</div>
      ]],
      endpoint = [[
        ##### List all ${Entities}

        <div class="endpoint ${method}">/${entities_url}</div>
      ]],
      fk_endpoint = [[
        ##### List ${Entities} associated to a specific ${ForeignEntity}

        <div class="endpoint ${method}">/${foreign_entities_url}/{${foreign_entity} id}/${entities_url}</div>

        Attributes | Description
        ---:| ---
        `${foreign_entity} id`<br>**required** | The unique identifier of the ${ForeignEntity} whose ${Entities} are to be retrieved. When using this endpoint, only ${Entities} associated to the specified ${ForeignEntity} will be listed.
      ]],
      fk_endpoint_w_ek = [[
        ##### List ${Entities} associated to a specific ${ForeignEntity}

        <div class="endpoint ${method}">/${foreign_entities_url}/{${foreign_entity} ${endpoint_key} or id}/${entities_url}</div>

        Attributes | Description
        ---:| ---
        `${foreign_entity} ${endpoint_key} or id`<br>**required** | The unique identifier or the `${endpoint_key}` attribute of the ${ForeignEntity} whose ${Entities} are to be retrieved. When using this endpoint, only ${Entities} associated to the specified ${ForeignEntity} will be listed.
      ]],
      request_query = [[
        Attributes | Description
        ---:| ---
        `offset`<br>*optional* | A cursor used for pagination. `offset` is an object identifier that defines a place in the list.
        `size`<br>*optional, default is __100__ max is __1000__* | A limit on the number of objects to be returned per page.
      ]],
      response = [[
        ```
        HTTP 200 OK
        ```

        ```json
        {
        {{ page.${entity}_data }}
            "next": "http://localhost:8001/${entities_url}?offset=6378122c-a0a1-438d-a5c6-efabae9fb969"
        }
        ```
      ]],
    },
    POST = {
      title = [[Add ${Entity}]],
      endpoint_w_ek = [[
        ##### Create ${Entity}

        <div class="endpoint ${method}">/${entities_url}</div>
      ]],
      endpoint = [[
        ##### Create ${Entity}

        <div class="endpoint ${method}">/${entities_url}</div>
      ]],
      fk_endpoint = [[
        ##### Create ${Entity} associated to a specific ${ForeignEntity}

        <div class="endpoint ${method}">/${foreign_entities_url}/{${foreign_entity} id}/${entities_url}</div>

        Attributes | Description
        ---:| ---
        `${foreign_entity} id`<br>**required** | The unique identifier of the ${ForeignEntity} that should be associated to the newly-created ${Entity}.
      ]],
      fk_endpoint_w_ek = [[
        ##### Create ${Entity} associated to a specific ${ForeignEntity}

        <div class="endpoint ${method}">/${foreign_entities_url}/{${foreign_entity} ${endpoint_key} or id}/${entities_url}</div>

        Attributes | Description
        ---:| ---
        `${foreign_entity} ${endpoint_key} or id`<br>**required** | The unique identifier or the `${endpoint_key}` attribute of the ${ForeignEntity} that should be associated to the newly-created ${Entity}.
      ]],
      request_body = [[
        {{ page.${entity}_body }}
      ]],
      response = [[
        ```
        HTTP 201 Created
        ```

        ```json
        {{ page.${entity}_json }}
        ```
      ]],
    },
  },
  entity_templates = {
    endpoint_w_ek = [[
      ##### ${Active_verb} ${Entity}

      <div class="endpoint ${method}">/${entities_url}/{${endpoint_key} or id}</div>

      Attributes | Description
      ---:| ---
      `${endpoint_key} or id`<br>**required** | The unique identifier **or** the ${endpoint_key} of the ${Entity} to ${active_verb}.
    ]],
    fk_endpoint_w_ek = [[
      ##### ${Active_verb} ${ForeignEntity} associated to a specific ${Entity}

      <div class="endpoint ${method}">/${entities_url}/{${entity} ${endpoint_key} or id}/${foreign_entity_url}</div>

      Attributes | Description
      ---:| ---
      `${entity} ${endpoint_key} or id`<br>**required** | The unique identifier **or** the ${endpoint_key} of the ${Entity} associated to the ${ForeignEntity} to be ${passive_verb}.
    ]],
    endpoint = [[
      ##### ${Active_verb} ${Entity}

      <div class="endpoint ${method}">/${entities_url}/{${entity} id}</div>

      Attributes | Description
      ---:| ---
      `${entity} id`<br>**required** | The unique identifier of the ${Entity} to ${active_verb}.
    ]],
    fk_endpoint = [[
      ##### ${Active_verb} ${ForeignEntity} associated to a specific ${Entity}

      <div class="endpoint ${method}">/${entities_url}/{${entity} id}/${foreign_entity_url}</div>

      Attributes | Description
      ---:| ---
      `${entity} id`<br>**required** | The unique identifier of the ${Entity} associated to the ${ForeignEntity} to be ${passive_verb}.
    ]],
    GET = {
      title = [[Retrieve ${Entity}]],
      response = [[
        ```
        HTTP 200 OK
        ```

        ```json
        {{ page.${entity}_json }}
        ```
      ]],
    },
    PATCH = {
      title = [[Update ${Entity}]],
      request_body = [[
        {{ page.${entity}_body }}
      ]],
      response = [[
        ```
        HTTP 200 OK
        ```

        ```json
        {{ page.${entity}_json }}
        ```
      ]],
    },
    PUT = {
      title = [[Update or create ${Entity}]],
      request_body = [[
        {{ page.${entity}_body }}
      ]],
      details = [[
        Inserts (or replaces) the ${Entity} under the requested resource with the
        definition specified in the body. The ${Entity} will be identified via the `${endpoint_key}
        or id` attribute.

        When the `${endpoint_key} or id` attribute has the structure of a UUID, the ${Entity} being
        inserted/replaced will be identified by its `id`. Otherwise it will be
        identified by its `${endpoint_key}`.

        When creating a new ${Entity} without specifying `id` (neither in the URL nor in
        the body), then it will be auto-generated.

        Notice that specifying a `${endpoint_key}` in the URL and a different one in the request
        body is not allowed.
      ]],
      response = [[
        ```
        HTTP 201 Created or HTTP 200 OK
        ```

        See POST and PATCH responses.
      ]],
    },
    DELETE = {
      title = [[Delete ${Entity}]],
      response = [[
        ```
        HTTP 204 No Content
        ```
      ]],
    }
  },

}
