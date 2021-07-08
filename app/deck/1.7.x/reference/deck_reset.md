---
title: deck reset
---

Reset deletes all entities in Kong.

### Synopsis

Reset command will delete all entities in Kong's database.string

Use this command with extreme care as it is equivalent to running
"kong migrations reset" on your Kong instance.

By default, this command will ask for a confirmation prompt.

```
deck reset [flags]
```

### Options

```
      --all-workspaces        reset configuration of all workspaces (Kong Enterprise only).
  -f, --force                 Skip interactive confirmation prompt before reset
  -h, --help                  help for reset
      --rbac-resources-only   reset only the RBAC resources (Kong Enterprise only)
      --select-tag strings    only entities matching tags specified via this flag are deleted.
                              Multiple tags are ANDed together.
      --skip-consumers        do not reset consumers or any plugins associated with consumers
  -w, --workspace string      reset configuration of a specific workspace(Kong Enterprise only).
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
