---
title: deck diff
---

Diff the current entities in Kong with the one on disks.

### Synopsis

Diff is like a dry run of 'decK sync' command.

It will load entities form Kong and then perform a diff on those with
the entities present in files locally. This allows you to see the entities
that will be created or updated or deleted.


```
deck diff [flags]
```

### Options

```
  -h, --help                  help for diff
      --non-zero-exit-code    return exit code 2 if there is a diff present,
                              exit code 0 if no diff is found,
                              and exit code 1 if an error occurs.
      --parallelism int       Maximum number of concurrent operations (default 10)
      --rbac-resources-only   sync only the RBAC resources (Kong Enterprise only)
      --select-tag strings    only entities matching tags specified via this flag are diffed.
                              Multiple tags are ANDed together.
      --skip-consumers        do not diff consumers or any plugins associated with consumers
  -s, --state strings         file(s) containing Kong's configuration.
                              This flag can be specified multiple times for multiple files.
                              Use '-' to read from stdin. (default [kong.yaml])
  -w, --workspace string      Diff configuration with a specific workspace (Kong Enterprise only).
                              This takes precedence over _workspace fields in state files.
```

### Options inherited from parent commands

```
      --analytics                      share anonymized data to help improve decK (default true)
      --ca-cert string                 Custom CA certificate to use to verify Kong's Admin TLS certificate.
                                       This value can also be set using DECK_CA_CERT environment variable.
      --config string                  config file (default is $HOME/.deck.yaml)
      --headers strings                HTTP Headers(key:value) to inject in all requests to Kong's Admin API.
                                       This flag can be specified multiple times to inject multiple headers.
      --kong-addr string               HTTP Address of Kong's Admin API.
                                       This value can also be set using DECK_KONG_ADDR
                                        environment variable. (default "http://localhost:8001")
      --konnect-email string           Email address associated with your Konnect account
      --konnect-password string        Password associated with your Konnect account, this takes precedence over --konnect-password-file flag
      --konnect-password-file string   File containing password to your Konnect account
      --no-color                       disable colorized output
      --skip-workspace-crud            Skip API calls related to Workspaces (Kong Enterprise only)
      --tls-server-name string         Name to use to verify the hostname in Kong's Admin TLS certificate.
                                       This value can also be set using DECK_TLS_SERVER_NAME environment variable.
      --tls-skip-verify                Disable verification of Kong's Admin TLS certificate.
                                       This value can also be set using DECK_TLS_SKIP_VERIFY environment variable.
      --verbose int                    Enable verbose verbose logging levels
                                       Setting this value to 2 outputs all HTTP requests/responses
                                       between decK and Kong.
```

### SEE ALSO

* [deck](/deck/{{page.kong_version}}/reference/deck)	 - Administer your Kong declaratively
