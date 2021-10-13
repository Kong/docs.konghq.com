---
title: Using environment variables with decK
toc: false
---

By default decK loads and stores data in plain text on a state file. To add more security, you can also store sensitive information, for example `apiKey`, `client_secret` in environment variables. 

What you need to do is to create environment variable with `DECK_` prefix and reference it as `{%raw%}${{ env "DECK_*" }}{%endraw%}` on your state file.

Below example demonstrates how to use apiKey stored in environment variable. It enables [key authentication][key-auth] plugin globally, create a consumer `demo` with an apiKey.

1. Create Environment variable
    <div class="copy-code-snippet"><pre><code>export DECK_API_KEY=<div contenteditable="true">{API_KEY}</div></code></pre></div>

2. Save below to `env-demo.yaml` 

    ```yaml
    _format_version: "1.1"
    consumers:
    - keyauth_credentials:
      - key: {%raw%}${{ env "DECK_API_KEY" }}{%endraw%}
      username: demo
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

[key-auth]: http://localhost:3000/hub/kong-inc/key-auth/