---
nav_title: Overview
title: Overview
---

Inigo offers complete visibility, control and security over your production GraphQL APIs, enabling you to confidently adopt and scale GraphQL with the Inigo Kong plugin. Designed specifically for GraphQL APIs, this plugin provides:
- Deep API analytics
- Schema-based role-based access control (RBAC)
- Performance and error monitoring
- Dynamic rate-limiting
- Prevention of breaking schema changes
Inigo’s plugin gives you unique, in-depth insights into GraphQL usage, from granular field-level details to full query paths, along with overall server health and performance metrics. It enforces security policies, modifies or blocks malicious queries before they reach your GraphQL servers, and alerts you to any API issues.

## How it works

The Inigo plugin can be enabled on any GraphQL API route. It syncs with a service configured in Inigo using the service token provided. The plugin enforces access control, rate limits, and other security policies configured in your Inigo service. Requests are batched and sent asynchronously to Inigo, ensuring no added latency to your API. The data is then analyzed in the cloud, matched against your GraphQL schema, and presented with full observability and insights into your API’s performance.

## How to install

Custom plugins can be installed via LuaRocks. A Lua plugin is distributed in `.rock` format, which is 
a self-contained package that can be installed locally or from a remote server.

If you used one of the official {{site.base_gateway}} installation packages, the LuaRocks utility 
should already be installed in your system.
Install the `.rock` in your LuaRocks tree, that is, the directory in which LuaRocks 
installs Lua modules. 

1. Install the Inigo plugin:

    ```sh
    luarocks install inigo-kong-plugin
    ```

2. Download the Inigo library:

    Find the [library](https://github.com/inigolabs/artifacts/releases/latest) for your architecture. Library file names start with *inigo-*.
    Download and copy the library into your kong run directory. 


3. Update your loaded plugins list in {{site.base_gateway}}.

    In your `kong.conf`, append `inigo` to the `plugins` field. Make sure the field is not commented out.

    ```yaml
    plugins = bundled,inigo    # Comma-separated list of plugins this node
                                            # should load. By default, only plugins
                                            # bundled in official distributions are
                                            # loaded via the `bundled` keyword.
    ```

4. Obtain and set Inigo Service Token

    Create and service and token in [Inigo](https://app.inigo.io]
    Set the INIGO_SERVICE_TOKEN env variable with the token's value.

4. Restart {{site.base_gateway}}:

    ```sh
    kong restart
    ```

## Using the plugin

- Go to [Inigo App](https://app.inigo.io) to monitor your API observability.
- Refer to the [Inigo Docs](https://docs.inigo.io) for detailed information on feature usage and policy configurations.


