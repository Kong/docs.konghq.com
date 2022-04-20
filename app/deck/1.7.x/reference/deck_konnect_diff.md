---
title: deck konnect diff
source_url: https://github.com/Kong/deck/tree/main/cmd
---

The konnect diff command is similar to a dry run of the 'deck konnect sync' command.

	It loads entities from Konnect and performs a diff with
	the entities in local files. This allows you to see the entities
	that will be created, updated, or deleted.

WARNING: This command is currently in alpha state. This command
might have breaking changes in future releases.

```
deck konnect diff [flags]
```

### Options

```
  -h, --help                 help for diff
      --include-consumers    export consumers, associated credentials and any plugins associated with consumers.
      --non-zero-exit-code   return exit code 2 if there is a diff present,
                             exit code 0 if no diff is found,
                             and exit code 1 if an error occurs.
      --parallelism int      Maximum number of concurrent operations. (default 100)
  -s, --state strings        file(s) containing Konnect's configuration.
                             This flag can be specified multiple times for multiple files. (default [konnect.yaml])
```

### Options inherited from parent commands

```
      --analytics                      Share anonymized data to help improve decK. (default true)
      --ca-cert string                 Custom CA certificate to use to verify Kong's Admin TLS certificate.
                                       This value can also be set using DECK_CA_CERT environment variable.
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
      --tls-server-name string         Name to use to verify the hostname in Kong's Admin TLS certificate.
                                       This value can also be set using DECK_TLS_SERVER_NAME environment variable.
      --tls-skip-verify                Disable verification of Kong's Admin TLS certificate.
                                       This value can also be set using DECK_TLS_SKIP_VERIFY environment variable.
      --verbose int                    Enable verbose logging levels
                                       Setting this value to 2 outputs all HTTP requests/responses
                                       between decK and Kong.
```

### See also

* [deck konnect](/deck/{{page.kong_version}}/reference/deck_konnect)	 - Configuration tool for Konnect (in alpha)
