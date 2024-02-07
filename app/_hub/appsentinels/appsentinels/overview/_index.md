---
nav_title: Overview
---
The AppSentinels API Security Platform is purpose-built for keeping the security needs of next-generation applications in mind.
At the platform's core is an AI/ML engine, AI Sentinels, which combines multiple intelligence inputs to completely understand and baseline unique application business logic, user contexts, and intents, as well as data flow within the application, to provide the complete protection your application needs.

## How it works

The AppSentinels plugin performs logging and enforcement (blocking) of API transactions. The plugin seamlessly integrates with {{site.base-gateway}} to provide visibility and protection.

The AppSentinels plugin works in the following two modes:
1. **Logging or transparent mode**: A copy of the request and response transactions is made and asynchronously shared with AppSentinels Edge Controller to provide visibility and security. Integrations can help provide enforcement, such as blocking of bad IPs and threat actors.

2. **Enforcement mode**: This mode provides transaction level blocking. Incoming requests are held until the AppSentinels Edge Controller provides a verdict. If the Controller provides a negative enforcement response of enforcement, the request is dropped from further processing. In case of higher latency of a verdict, the plugin performs a fail open to ensure business continuity.

The same plugin supports both modes.

## How to install

The AppSentinels plugin is provided as a set of lua scripts.

1. Obtain the plugin directly from AppSentinels or a distributor.

2. Mount/copy the Lua files or create a Kong container image with Lua files (usually at `/usr/local/share/lua/5.1/kong/plugins/appsentinels`).

3. Update your loaded plugins list in {{site.base_gateway}}.

    In your `kong.conf`, append `appsentinels` to the `plugins` field. Make sure the field is not commented out.

    ```yaml
    plugins = bundled,appsentinels          # Comma-separated list of plugins this node
                                            # should load. By default, only plugins
                                            # bundled in official distributions are
                                            # loaded via the `bundled` keyword.
    ```

4. Restart {{site.base_gateway}}:

    ```sh
    kong restart
    ```

## Using the plugin

You can use this plugin in one of the following modes: logging/transparent mode (default), or authz/enforcement mode.

Replace `localhost:8001` in the following examples with your own Kong admin URL. 

Enable logging/transparent mode:
```sh
curl -X POST http://localhost:8001/plugins \
  --data name=appsentinels \
  --data config.http_endpoint=http://onprem-controller:9004
```

Enable authz/enforcement mode:
```sh
curl -X POST http://localhost:8001/plugins \
  --data name=appsentinels \
  --data config.http_endpoint=http://onprem-controller:9004 \
  --data config.authz=true
```
