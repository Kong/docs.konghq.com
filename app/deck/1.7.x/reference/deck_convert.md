---
title: deck convert
---

Convert files in one format to another format.

### Synopsis

Convert command converts files representing configuration in one format
to another compatible format. For example: a configuration for 'kong-gateway'
can be converted into 'konnect' configuration file.

```
deck convert [flags]
```

### Options

```
      --from string          format of the source file, allowed formats:[kong-gateway konnect]
  -h, --help                 help for convert
      --input-file string    file containing configuration that needs to be converted. Use '-' to read from stdin.
      --output-file string   file to which to write configuration after conversion. Use '-' to write to stdout.
      --to string            desired format of the output, allowed formats:[kong-gateway konnect]
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
