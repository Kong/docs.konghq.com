---
nav_title: Overview
---

The traffic source plugin has customizable configuration parameters to tune how the noname machine learning engine receives the Kong API traffic data to inspect.

## How it works


All integrations require you to create an integration profile in Noname. Nearly all integrations require you to have administration access to the systems with which you want to integrate. The simplest integrations require you to record some kind of credentials and/or access key from the remote system to enter into Noname while creating the profile. This enables Noname to receive information from, or perform actions on, the remote system. For example, to fetch a log file, or to initiate a block based on an incident created in Noname.


The Noname Security Kong plugin is available as a LuaRocks module.
The [Noname Security install and configuration Documentation](https://docs.nonamesecurity.com/docs/kong-plugin) explains how to logon to the Noname admin user interface to go to the Integrations section of the platform, begin the Kong integration wizard and to download the plugin that is used in the Dockerfile to create a custom docker image with the plugins preinstalled. 

### Performance Benchmarks

Please find the performance benchmarks for the Noname Security Kong prevention integration here:

[Kong Enterprise 2.8.1.1 with Noname 3.1](https://docs.nonamesecurity.com/v320/docs/kong-performance-results)

## How to install

### The Noname traffic source plugin for Kong

The Noname Security Kong plugin is available as a LuaRocks module.
The [Noname Security install and configuration Documentation](https://docs.nonamesecurity.com/docs/kong-plugin) explains how to logon to the Noname admin user interface to go to the Integrations section of the platform, begin the Kong integration wizard and to download the plugin that is used in the Dockerfile to create a custom docker image with the plugins preinstalled. 

How you install the Noname Kong plugin depends on how you installed the Kong Gateway. For example, installing the Kong Gateway using docker vs installing RHEL Kong Gateway. The luarocks command may require root permissions. Use sudo for the installation environments that support it. If luarocks is not available in the $PATH, use the absolute path of luarocks which is installation specific. It is usually located in /usr/local/bin.

Step 1: Configure the Integration Profile in Noname and Download the Plugin
Step 2: Configure Your Environment in Kong
Step 3: Install the Plugin
Step 4: Enable the Plugin
Step 5: Configure the Plugin

You can modify the kong.conf file and append the nonamesecurity plugin to the plugins entry.

```yaml
plugins = bundled,nonamesecurity
```

Configure the plugin
```shell
$ curl -X POST http://<kong-domain>:<kong-port>/services/<your-kong service-id>/plugins/ \
--data "name=nonamesecurity"
```


1. Copy the LuaRocks module to the Kong server.

2. Install the LuaRocks module.

    ```shell
    luarocks install nonamesecurity.rockspec
    ```

3. Update your loaded plugins list in {{site.base_gateway}}.

    In your `kong.conf`, append `nonamesecurity` to the `plugins` field. Make sure the field is not commented out.

    ```yaml
    plugins = bundled,nonamesecurity    # Comma-separated list of plugins this node
                                            # should load. By default, only plugins
                                            # bundled in official distributions are
                                            # loaded via the `bundled` keyword.

4. Restart {{site.base_gateway}}:

    ```sh
    kong restart
    ```

### Dockerfile Example

If you have a docker based system, below is an example Dockerfile installing the noname security plugin:

```yaml
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

## Using the Plugin

Configure the plugin on a gateway service by making the following request:

```shell
$ curl -X POST http://<kong-domain>:<kong-port>/services/<your-kong service-id>/plugins/ \
--data "name=nonamesecurity"
```

The plugin is now configured on the service.

The plugin supports global, gateway service, and route level configurations.