---
title: deck dump
source_url: https://github.com/Kong/deck/tree/main/cmd
---

The dump command reads all entities present in Kong
and writes them to a local file.

The file can then be read using the sync command or diff command to
configure Kong.

```
deck dump [flags]
```

## Flags

```
      --all-workspaces        dump configuration of all Workspaces (Kong Enterprise only).
      --format string         output file format: json or yaml. (default "yaml")
  -h, --help                  help for dump
  -o, --output-file string    file to which to write Kong's configuration.Use '-' to write to stdout. (default "kong")
      --rbac-resources-only   export only the RBAC resources (Kong Enterprise only).
      --select-tag strings    only entities matching tags specified with this flag are exported.
                              When this setting has multiple tag values, entities must match every tag.
      --skip-consumers        skip exporting consumers and any plugins associated with consumers.
      --with-id               write ID of all entities in the output
  -w, --workspace string      dump configuration of a specific Workspace(Kong Enterprise only).
      --yes                   assume 'yes' to prompts and run non-interactively.
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
