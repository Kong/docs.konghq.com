---
nav_title: Overview
---

The Noname Security Prevention integration for {{site.base_gateway}} instructs the Gateway to block API requests that are associated with anomalous IP addresses, headers, cookies, query strings, or JWT tokens.

{:.note}
 > {{site.konnect_product_name}} data plane integration for this integration is currently in BETA. 

## How it works

Prevention integrations enable Noname to automatically block, or you to manually block, suspicious or dangerous runtime traffic to your APIs. 

This integration enables Noname to perform the blocking operation in an external system, such as an AWS API Gateway or an Azure API Manager. 
At the same time, Noname also informs Kong to block the IP address or OAuth JWT token associated with a known anomalous actor, such as a bot-net, hacker tool, or a QA test tool. 

When blocking, you can specify a time period for the block. The external system manages the lifecycle of the block, including its removal.

The [`nonamesecurity`](/hub/nonamesecurity/nonamesecurity-kongtrafficsource/) plugin is a prerequisite when using the `noname-prevention` plugin.

The Noname Security Kong plugin is available as a LuaRocks module via the Noname integrations admin console. 
Noname Security Prevention integration for Kong uses a Noname-provided custom Lua plugin (`nonamesecurity`) to [identify and block attackers](https://docs.nonamesecurity.com/docs/kong-prevention) that were found using the Noname anomaly detection plugin.

### Performance benchmarks 

You can find the performance benchmarks for the Noname Security Kong prevention integration here:

[Kong Enterprise 2.8.1.1 with Noname 3.1](https://docs.nonamesecurity.com/v320/docs/kong-performance-results)

## How to install

### Prerequisites 

* Install the [`nonamesecurity`](/hub/nonamesecurity/nonamesecurity-kongtrafficsource/) plugin

### The Noname blocking and prevention plugin for Kong 

[Noname Security Kong Prevention install and configuration documentation](https://docs.nonamesecurity.com/docs/kong-prevention)

#### Create the integration profile

Configure the integration profile in Noname and download the plugin:

1. In the Noname UI, navigate to **Settings** > **Integrations** > **Prevention**.
2. Select **Add Integration**, then select the Kong tile to create an integration profile.
3. Download the zip file and copy it to your Kong machine, then select **Next**.
4. Enter the Kong Admin API URL.
5. Enter key-value sets for the Authentication headers to enable Noname to authenticate with Kong, then select **Next**.
6. Provide an alias for the integration.
7. Select Finish to save the integration.

#### Install the LuaRocks module and set up Kong

Upload and activate the Noname prevention plugin to Kong using the following steps: 

1. In your Kong machine CLI shell, navigate to the location of the copied zip file and unzip the file.
2. Run the following command to install the plugin:

    ```shell
    luarocks make
    ```

3. Update the Kong `plugins` configuration, either through `kong.conf` ( `/etc/kong/kong.conf` by default) or via an environment variable: 

    Open the file, find the `plugins` parameter, and add `noname-prevention`. 
    For example:
    
    ```yaml
    plugins = bundled,noname-prevention
    ```

4. After the Lua module is installed, restart Kong:

    ```shell
    kong restart
    ```

### Install via a Dockerfile

Instead of manually installing with `kong.conf`, you can also use a Dockerfile to create a custom kong docker image with both of the Noname Kong plugins preinstalled:

```docker
FROM kong/kong-gateway:3.4

USER root

RUN \apt-get update && \apt-get install unzip -y  

WORKDIR /usr/kong/noname

RUN apt update && apt-get install -y build-essential git curl unzip

RUN bash -c 'mkdir -pv {nonamesecurity,prevention}'

COPY ./noname-security-kong-policy.zip nonamesecurity/noname-security-kong-policy.zip

RUN unzip nonamesecurity/noname-security-kong-policy.zip -d nonamesecurity && rm nonamesecurity/noname-security-kong-policy.zip

COPY ./noname-security-kong-prevention.zip prevention/noname-security-kong-prevention.zip

RUN unzip prevention/noname-security-kong-prevention.zip -d prevention && rm prevention/noname-security-kong-prevention.zip

RUN cd nonamesecurity && luarocks make

RUN cd prevention && luarocks make

USER kong
```

Note the above Dockerfile installs both the Noname Traffic Source for Machine Learning plugin (`nonamesecurity`) and the Noname Prevention plugin for automated blocking (`noname-prevention`). 

## Enable the plugin

You can enable the `noname-prevention` plugin globally, on a service, or on a route.

{% navtabs %}
{% navtab Enable globally %}
Enable the `noname-prevention` plugin globally: 

```shell
curl -X POST http://localhost:8001/plugins \
  --data "name=noname-prevention"
```
{% endnavtab %}
{% navtab Enable on a service %}

Enable the plugin for a single service using:
```shell
curl -X POST http://localhost:8001/services/{serviceNameorId}/plugins \ 
  --data "name=noname-prevention"
```

{% endnavtab %}
{% navtab Enable on a route %}

Enable the plugin for a single route using:
```shell
curl -X POST http://localhost:8001/routes/{routeNameorId}/plugins \
  --data "name=noname-prevention"
```

{% endnavtab %}
{% endnavtabs %}

You can check that the plugin was installed with the following request:

```shell
curl -s http://localhost:8001
```

Under the `available_on_server` section in the response, look for the plugin `noname-prevention`.

