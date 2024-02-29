---
nav_title: Overview
title: Overview
---

Traceable's Kong plugin lets traceable capture a copy of the API traffic that is flowing through Kong's API Gateway. Using this data Traceable is able to create a security posture profile of  APIs hosted on Kong. Traceable plugin is also capable of blocking traffic coming from malicious actors and IPs into Kong API Gateway.

## How it works

The Traceable Kong Plugin captures request and response data to forward to a locally running Traceable Module Extension(TME).

## Prerequisites
The Traceable Kong Plugin requires a Traceable Platform Agent to be deployed in your environment. 
For complete deployment instructions of the Traceable Platform Agent please visit the [traceable.ai docs site](https://docs.traceable.ai/docs/k8s).

## How to install

Once you have deployed a Traceable Platform Agent you are ready to install the plugin using the LuaRocks package manager:

1. Install the traceable plugin:

    ```sh
    luarocks install kong-plugin-traceable
    ```

2. Update your loaded plugins list in {{site.base_gateway}}.

    In your `kong.conf`, append `traceable` to the `plugins` field. Make sure the field is not commented out.

    ```yaml
    plugins = bundled,traceable
    ```

3. Restart {{site.base_gateway}}:

    ```sh
    kong restart
    ```

## Using the plugin

Register the Traceable plugin:

```shell
$ curl -X POST http://<kong-domain>:<kong-port>/services/<your-kong-service-id>/plugins/ \
  --data "name=traceable" \
  --data "config.ext_cap_endpoint=<ext_cap_endpoint>" \
  --data "config.service_name=<name_of_service>" \
  --data "config.allow_on_failure=<true/false>"
```

