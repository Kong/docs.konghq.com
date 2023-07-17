---
title: deck file patch
source_url: https://github.com/Kong/deck/tree/main/cmd
content_type: reference
---

Apply patches on top of a decK file.

The input file will be read, the patches will be applied, and if successful, written
to the output file. The patches can be specified by a '--selector' and one or more
'--value' tags, or via patch-files.

When using '--selector' and '--values', the items will be selected by the 'selector' which is
a JSONpath query. From the array of nodes found, only the objects will be updated.
The 'values' will be applied on each of the JSONobjects returned by the 'selector'.

The value part must be a valid JSON snippet, so make sure to use single/double quotes
appropriately. If the value is empty, the field will be removed from the object.
Examples:
  --selector="$..services[*]" --value="read_timeout:10000"
  --selector="$..services[*]" --value='_comment:"comment injected by patching"'
  --selector="$..services[*]" --value='_ignore:["ignore1","ignore2"]'
  --selector="$..services[*]" --value='_ignore:' --value='_comment:'

The patch-files have the following format (JSON or Yaml) and can contain multiple
patches that will be applied in order;

  { "_format_version": "1.0",
    "patches": [
      { "selectors": [
					"$..services[*]"
				],
        "values": {
          "read_timeout": 10000,
          "_comment": "comment injected by patching"
        },
        "remove": [ "_ignore" ]
      }
    ]
  }


## Syntax

```
deck file patch [command-specific flags] [global flags]
```

## Flags

`--format`
:  output format: yaml or json (Default: `"yaml"`)

`-h`, `--help`
:  help for patch (Default: `false`)

`-o`, `--output-file`
:  output file to write. Use - to write to stdout (Default: `"-"`)

`--selector`
:  json-pointer identifying element to patch (can be specified more than once)

`-s`, `--state`
:  decK file to process. Use - to read from stdin (Default: `"-"`)

`--value`
:  a value to set in the selected entry in format <key:value> (can be specified more than once)



## Global flags

`--analytics`
:  Share anonymized data to help improve decK.
Use `--analytics=false` to disable this. (Default: `true`)

`--ca-cert`
:  Custom CA certificate (raw contents) to use to verify Kong's Admin TLS certificate.
This value can also be set using DECK_CA_CERT environment variable.
This takes precedence over `--ca-cert-file` flag.

`--ca-cert-file`
:  Path to a custom CA certificate to use to verify Kong's Admin TLS certificate.
This value can also be set using DECK_CA_CERT_FILE environment variable.

`--config`
:  Config file (default is $HOME/.deck.yaml).

`--headers`
:  HTTP headers (key:value) to inject in all requests to Kong's Admin API.
This flag can be specified multiple times to inject multiple headers.

`--kong-addr`
:  HTTP address of Kong's Admin API.
This value can also be set using the environment variable DECK_KONG_ADDR
 environment variable. (Default: `"http://localhost:8001"`)

`--kong-cookie-jar-path`
:  Absolute path to a cookie-jar file in the Netscape cookie format for auth with Admin Server.
You may also need to pass in as header the User-Agent that was used to create the cookie-jar.

`--konnect-addr`
:  Address of the Konnect endpoint. (Default: `"https://us.api.konghq.com"`)

`--konnect-email`
:  Email address associated with your Konnect account.

`--konnect-password`
:  Password associated with your Konnect account, this takes precedence over `--konnect-password-file` flag.

`--konnect-password-file`
:  File containing the password to your Konnect account.

`--konnect-runtime-group-name`
:  Konnect Runtime group name.

`--konnect-token`
:  Personal Access Token associated with your Konnect account, this takes precedence over `--konnect-token-file` flag.

`--konnect-token-file`
:  File containing the Peronsal Access Token to your Konnect account.

`--no-color`
:  Disable colorized output (Default: `false`)

`--skip-workspace-crud`
:  Skip API calls related to Workspaces (Kong Enterprise only). (Default: `false`)

`--timeout`
:  Set a request timeout for the client to connect with Kong (in seconds). (Default: `10`)

`--tls-client-cert`
:  PEM-encoded TLS client certificate to use for authentication with Kong's Admin API.
This value can also be set using DECK_TLS_CLIENT_CERT environment variable. Must be used in conjunction with tls-client-key

`--tls-client-cert-file`
:  Path to the file containing TLS client certificate to use for authentication with Kong's Admin API.
This value can also be set using DECK_TLS_CLIENT_CERT_FILE environment variable. Must be used in conjunction with tls-client-key-file

`--tls-client-key`
:  PEM-encoded private key for the corresponding client certificate .
This value can also be set using DECK_TLS_CLIENT_KEY environment variable. Must be used in conjunction with tls-client-cert

`--tls-client-key-file`
:  Path to file containing the private key for the corresponding client certificate.
This value can also be set using DECK_TLS_CLIENT_KEY_FILE environment variable. Must be used in conjunction with tls-client-cert-file

`--tls-server-name`
:  Name to use to verify the hostname in Kong's Admin TLS certificate.
This value can also be set using DECK_TLS_SERVER_NAME environment variable.

`--tls-skip-verify`
:  Disable verification of Kong's Admin TLS certificate.
This value can also be set using DECK_TLS_SKIP_VERIFY environment variable. (Default: `false`)

`--verbose`
:  Enable verbose logging levels
Sets the verbosity level of log output (higher is more verbose). (Default: `0`)



## See also

* [deck file](/deck/{{page.kong_version}}/reference/deck_file)	 - Sub-command to host the decK file manipulation operations

