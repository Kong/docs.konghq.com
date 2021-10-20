---
title: Using environment variables with decK
toc: false
---

When you use decK to apply configurations to {{site.base_gateway}},
decK reads data in plain text from a state file by default. To improve security, you 
can also store sensitive information, for example `apiKey` or `client_secret`, in 
environment variables. decK can then read data directly from the environment
variables and apply it.

What you need to do is to create environment variables with `DECK_` prefix and reference them as `{%raw%}${{ env "DECK_*" }}{%endraw%}` on your state file.

Below example demonstrates how to apply apiKey stored in environment variable. It enables [key authentication][key-auth] plugin globally, create a consumer `demo` with an apiKey.

1. Create Environment variable
    <div class="copy-code-snippet"><pre><code>export DECK_API_KEY=<div contenteditable="true">{API_KEY}</div></code></pre></div>

2. Save below to `env-demo.yaml` 

    ```yaml
    _format_version: "1.1"
    consumers:
    - keyauth_credentials:
      - key: ${{ env "DECK_API_KEY" }}
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

3. Run `deck sync -s env-demo.yaml` to sync this file.

4. You will see below output. In this example, `abc` is the apiKey I stored in environment variable.

    ```plaintext
    creating consumer demo
    creating key-auth abc for consumer 36718320-e67d-4162-8b50-aa685e06c64c
    creating plugin key-auth (global)
    Summary:
      Created: 3
      Updated: 0
      Deleted: 0
    ```

[key-auth]: http://localhost:3000/hub/kong-inc/key-auth/