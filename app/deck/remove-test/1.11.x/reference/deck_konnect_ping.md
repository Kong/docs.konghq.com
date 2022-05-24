---
title: deck konnect ping
source_url: https://github.com/Kong/deck/tree/main/cmd
---

The konnect ping command can be used to verify if decK
can connect to Konnect's API endpoint. It also validates the supplied
credentials.

WARNING: This command is currently in alpha state. This command
might have breaking changes in future releases.

```
deck konnect ping [flags]
```

## Flags

```
-h, --help   help for ping
```

## Flags inherited from parent commands

```
--analytics                      Share anonymized data to help improve decK.
                                 Use --analytics=false to disable this. (default true)
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
--tls-client-cert string         PEM-encoded TLS client certificate to use for authentication with Kong's Admin API.
                                 This value can also be set using DECK_TLS_CLIENT_CERT environment variable. Must be used in conjunction with tls-client-key
--tls-client-cert-file string    Path to the file containing TLS client certificate to use for authentication with Kong's Admin API.
                                 This value can also be set using DECK_TLS_CLIENT_CERT_FILE environment variable. Must be used in conjunction with tls-client-key-file
--tls-client-key string          PEM-encoded private key for the corresponding client certificate .
                                 This value can also be set using DECK_TLS_CLIENT_KEY environment variable. Must be used in conjunction with tls-client-cert
--tls-client-key-file string     Path to file containing the private key for the corresponding client certificate.
                                 This value can also be set using DECK_TLS_CLIENT_KEY_FILE environment variable. Must be used in conjunction with tls-client-cert-file
--tls-server-name string         Name to use to verify the hostname in Kong's Admin TLS certificate.
                                 This value can also be set using DECK_TLS_SERVER_NAME environment variable.
--tls-skip-verify                Disable verification of Kong's Admin TLS certificate.
                                 This value can also be set using DECK_TLS_SKIP_VERIFY environment variable.
--verbose int                    Enable verbose logging levels
                                 Setting this value to 2 outputs all HTTP requests/responses
                                 between decK and Kong.
```


## See also

* [deck konnect](/deck/{{page.kong_version}}/reference/deck_konnect)	 - Configuration tool for Konnect (in alpha)
