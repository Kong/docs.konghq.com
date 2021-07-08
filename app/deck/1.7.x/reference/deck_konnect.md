---
title: deck konnect
---

Configuration tool for Konnect (in alpha).

### Synopsis

Konnect command contains sub-commands that can be used to declarativley
configure Konnect.

WARNING: This command is currently in alpha state. This command
might have breaking changes in future releases.

### Options

```
  -h, --help   help for konnect
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
* [deck konnect diff](/deck/{{page.kong_version}}/reference/deck_konnect_diff)	 - Diff the current entities in Konnect with the one on disks (in alpha)
* [deck konnect dump](/deck/{{page.kong_version}}/reference/deck_konnect_dump)	 - Export configuration from Konnect (in alpha)
* [deck konnect ping](/deck/{{page.kong_version}}/reference/deck_konnect_ping)	 - Verify connectivity with Konnect (in alpha)
* [deck konnect sync](/deck/{{page.kong_version}}/reference/deck_konnect_sync)	 - Sync performs operations to get Konnect's configuration to match the state file (in alpha)
