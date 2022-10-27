---
title: Using environment variables with decK
content_type: how-to
---

When you use decK to apply configurations to {{site.base_gateway}},
decK reads data in plain text from a state file by default. To improve security, you
can also store sensitive information, for example `apiKey` or `client_secret`, in
environment variables. decK can then read data directly from the environment
variables and apply it.

Create environment variables with the `DECK_` prefix and reference them as
`{%raw%}${{ env "DECK_*" }}{%endraw%}` in your state file.

{:.note}
> For storing {{site.base_gateway}} secrets in environment variables, see [Secrets Management with decK](/deck/latest/guides/vaults/).
The reference format for secrets is _not_ the same as references for environment variables used by decK.

The following example demonstrates how to apply an API key stored in an environment variable.
You can use this method for any sensitive content.

1. Create an environment variable:

    ```sh
    export DECK_API_KEY={YOUR_API_KEY}
    ```

2. Save the following snippet into a `env-demo.yaml` file:

    ```yaml
    _format_version: "3.0"
    consumers:
    - keyauth_credentials:
      - key: {%raw%}${{ env "DECK_API_KEY" }}{%endraw%}
      username: demo
      id: 36718320-e67d-4162-8b50-aa685e06c64c
    plugins:
    - config:
        anonymous: null
        hide_credentials: false
        key_in_body: false
        key_in_header: true
        key_in_query: true
        key_names:
        - apikey
        run_on_preflight: true
      enabled: true
      name: key-auth
      protocols:
      - grpc
      - grpcs
      - http
      - https
    ```
    This snippet enables the [key authentication][key-auth] plugin globally and creates
     a consumer named `demo` with an API key.
3. Run `deck sync -s env-demo.yaml` to sync this file.

    The output should look something like this, where `abc` is the API key stored
    in the environment variable:

    ```plaintext
    creating consumer demo
    creating key-auth abc for consumer 36718320-e67d-4162-8b50-aa685e06c64c
    creating plugin key-auth (global)
    Summary:
      Created: 3
      Updated: 0
      Deleted: 0
    ```

[key-auth]: /hub/kong-inc/key-auth/
