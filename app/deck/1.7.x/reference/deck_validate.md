---
title: deck validate
---

Validate the state file.

### Synopsis

Validate reads the state file and ensures the validity.

It will read all the state files that are passed in. If there are YAML/JSON
parsing issues, they will be reported. It also checks for foreign relationships
and alerts if there are broken relationships, missing links present.
No communication takes places between decK and Kong during the execution of
this command.


```
deck validate [flags]
```

### Options

```
  -h, --help                  help for validate
      --rbac-resources-only   indicate that the state file(s) contain RBAC resources only (Kong Enterprise only)
  -s, --state strings         file(s) containing Kong's configuration.
                              This flag can be specified multiple times for multiple files.
                              Use '-' to read from stdin. (default [kong.yaml])
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
