---
title: deck sync
---

The sync command reads the state file and performs operation on Kong
to get Kong's state in sync with the input state.

```
deck sync [flags]
```

## Flags

```
      --db-update-propagation-delay int   artificial delay (in seconds) that is injected between insert operations
                                          for related entities (usually for Cassandra deployments).
                                          See 'db_update_propagation' in kong.conf.
  -h, --help                              help for sync
      --parallelism int                   Maximum number of concurrent operations. (default 10)
      --rbac-resources-only               diff only the RBAC resources (Kong Enterprise only).
      --select-tag strings                only entities matching tags specified via this flag are synced.
                                          When this setting has multiple tag values, entities must match every tag.
      --silence-events                    disable printing events to stdout
      --skip-consumers                    do not diff consumers or any plugins associated with consumers.
  -s, --state strings                     file(s) containing Kong's configuration.
                                          This flag can be specified multiple times for multiple files.
                                          Use '-' to read from stdin. (default [kong.yaml])
      --workspace string                  Sync configuration to a specific workspace (Kong Enterprise only).
                                          This takes precedence over _workspace fields in state files.
```

## Flags inherited from parent commands

```
      --analytics                      Share anonymized data to help improve decK. (default true)
      --ca-cert string                 Custom CA certificate (raw contents) to use to verify Kong's Admin TLS certificate.
                                       This value can also be set using DECK_CA_CERT environment variable.
                                       This takes precedence over --ca-cert-file flag.
      --ca-cert-file string            Path to a custom CA certificate to use to verify Kong's Admin TLS certificate.
                                       This value can also be set using DECK_CA_CERT_FILE environment variable.
      --config string                  Config file (default is $HOME/.deck.yaml).
      --headers strings                HTTP headers (key:value) to inject in all requests to Kong's Admin API.
                                       This flag can be specified multiple times to inject multiple headers.
      --kong-addr string               HTTP address of Kong's Admin API.
                                       This value can also be set using the environment variable DECK_KONG_ADDR
                                        environment variable. (default "http://localhost:8001")
      --kong-cookie-jar-path string    Absolute path to a cookie-jar file in the Netscape cookie format for auth with Admin Server.
                                       You may also need to pass in as header the User-Agent that was used to create the cookie-jar.
      --konnect-addr string            Address of the Konnect endpoint. (default "https://konnect.konghq.com")
      --konnect-email string           Email address associated with your Konnect account.
      --konnect-password string        Password associated with your Konnect account, this takes precedence over --konnect-password-file flag.
      --konnect-password-file string   File containing the password to your Konnect account.
      --no-color                       Disable colorized output
      --skip-workspace-crud            Skip API calls related to Workspaces (Kong Enterprise only).
      --timeout int                    Set a request timeout for the client to connect with Kong (in seconds). (default 10)
      --tls-server-name string         Name to use to verify the hostname in Kong's Admin TLS certificate.
                                       This value can also be set using DECK_TLS_SERVER_NAME environment variable.
      --tls-skip-verify                Disable verification of Kong's Admin TLS certificate.
                                       This value can also be set using DECK_TLS_SKIP_VERIFY environment variable.
      --verbose int                    Enable verbose logging levels
                                       Setting this value to 2 outputs all HTTP requests/responses
                                       between decK and Kong.
```


## See also

* [deck](/deck/{{page.kong_version}}/reference/deck)	 - Administer your Kong clusters declaratively
