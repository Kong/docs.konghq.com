---
title: deck
source_url: https://github.com/Kong/deck/tree/main/cmd
---

The deck tool helps you manage Kong clusters with a declarative
configuration file.

It can be used to export, import, or sync entities to Kong.

## Flags

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
  -h, --help                           help for deck
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
* [deck completion](/deck/{{page.kong_version}}/reference/deck_completion)	 - Generate completion script
* [deck convert](/deck/{{page.kong_version}}/reference/deck_convert)	 - Convert files from one format into another format
* [deck diff](/deck/{{page.kong_version}}/reference/deck_diff)	 - Diff the current entities in Kong with the one on disks
* [deck dump](/deck/{{page.kong_version}}/reference/deck_dump)	 - Export Kong configuration to a file
* [deck konnect](/deck/{{page.kong_version}}/reference/deck_konnect)	 - Configuration tool for Konnect (in alpha)
* [deck ping](/deck/{{page.kong_version}}/reference/deck_ping)	 - Verify connectivity with Kong
* [deck reset](/deck/{{page.kong_version}}/reference/deck_reset)	 - Reset deletes all entities in Kong
* [deck sync](/deck/{{page.kong_version}}/reference/deck_sync)	 - Sync performs operations to get Kong's configuration to match the state file
* [deck validate](/deck/{{page.kong_version}}/reference/deck_validate)	 - Validate the state file
* [deck version](/deck/{{page.kong_version}}/reference/deck_version)	 - Print the decK version
