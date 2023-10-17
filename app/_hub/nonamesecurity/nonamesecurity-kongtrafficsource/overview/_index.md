---
nav_title: Overview
---

The Noname Traffic Source plugin (also known as `nonamesecurity`) lets you tune
how the Noname machine learning engine receives the Kong API traffic data to inspect.

## How it works

All integrations require you to create an integration profile in Noname. 
Nearly all integrations require you to have administration access to the systems with which you want to integrate. 
The simplest integrations require you to record some kind of credentials or access key from the remote system to enter into Noname while creating the profile. 
This enables Noname to receive information from, or perform actions on, the remote system. 
For example, an action could be fetching a log file, or to initiating a block based on an incident created in Noname.

The Noname Security Kong plugin is available as a LuaRocks module.
The [Noname Security install and configuration documentation](https://docs.nonamesecurity.com/docs/kong-plugin) explains how to log on to the Noname admin user interface, go to the Integrations section of the platform, begin the Kong integration wizard, and download the plugin that is used in the Dockerfile to create a custom docker image with the plugins preinstalled. 

### Performance benchmarks

You can find the performance benchmarks for Kong with Noname here:

[{{site.ee_product_name}} 2.8.1.1 with Noname 3.1](https://docs.nonamesecurity.com/v320/docs/kong-performance-results)

## How to install

### The Noname Traffic Source plugin for Kong

The Noname Security Kong plugin is available as a LuaRocks module.

The [Noname Security install and configuration documentation](https://docs.nonamesecurity.com/docs/kong-plugin) explains how set up a custom Docker image with the both plugins preinstalled, using the Noname admin user interface.

#### Create the integration profile

Configure the integration profile in Noname and download the plugin:

1. In the Noname UI, navigate to **Settings** > **Integrations** > **Traffic Sources**. 
2. Select **Add Integration** and select the Kong tile to create an integration profile. 
3. Download the Zip file, and copy it to your Kong machine, then select **Next**. 
4. Provide an alias for the integration.
5. Select **Finish** to save the integration.

#### Install the LuaRocks module and set up Kong

1. In your Kong machine CLI shell, navigate to the location of the copied zip file and unzip the file.
2. Run the following command to install the plugin:

    ```sh
    luarocks install nonamesecurity.rockspec
    ```

3. Update the Kong `plugins` configuration, either through `kong.conf` ( `/etc/kong/kong.conf` by default) or via an environment variable.

    Open the file, find the `plugins` parameter, and add `nonamesecurity`. 
    For example:

    ```yaml
    plugins = bundled,nonamesecurity    

    # Comma-separated list of plugins this node
    # should load. By default, only plugins
    # bundled in official distributions are
    # loaded via the `bundled` keyword.
    ```

4. After the Lua module is installed, restart Kong:

    ```shell
    kong restart
    ```

### Install via a Dockerfile

If you have a Docker-based system, see the following example Dockerfile for 
installing the Noname Security plugin:

```docker
FROM kong/kong-gateway:3.4

USER root

RUN \apt-get update && \apt-get install unzip -y

WORKDIR /usr/kong/noname

RUN apt update && apt-get install -y build-essential git curl unzip

RUN bash -c 'mkdir -pv {nonamesecurity}'

COPY ./noname-security-kong-policy.zip nonamesecurity/noname-security-kong-policy.zip

RUN unzip nonamesecurity/noname-security-kong-policy.zip -d nonamesecurity && rm nonamesecurity/noname-security-kong-policy.zip

RUN cd nonamesecurity && luarocks make

USER kong
```

## Enable the plugin

You can enable the `nonamesecurity` plugin globally, on a service, or on a route.

{% navtabs %}
{% navtab Enable globally %}
Enable the `nonamesecurity` plugin globally: 

```shell
curl -X POST http://localhost:8001/plugins \
  --data "name=nonamesecurity"
```
{% endnavtab %}
{% navtab Enable on a service %}

Enable the plugin for a single service using:
```shell
curl -X POST http://localhost:8001/services/{serviceNameorId}/plugins \ 
  --data "name=nonamesecurity"
```

{% endnavtab %}
{% navtab Enable on a route %}

Enable the plugin for a single route using:
```shell
curl -X POST http://localhost:8001/routes/{routeNameorId}/plugins \
  --data "name=nonamesecurity"
```

{% endnavtab %}
{% endnavtabs %}

You can check that the plugin was installed with the following request:

```shell
curl -s http://localhost:8001
```

Under the `available_on_server` section in the response, look for the plugin `nonamesecurity`.
