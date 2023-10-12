---
nav_title: Overview
---

The Noname Security prevention integration for Kong Open Source or Kong Enteprise instructs the Kong API Gateway to block API requests that are associated with anomalous IP addresses, headers, cookies, query strings, or JWT tokens. Kong Konnect data-plane integration for this noname machine learning powered prevention integration is currently in BETA. 

## How it works

Prevention integrations enable Noname to automatically block, or you to manually block, suspicious or dangerous runtime traffic to your APIs. The integration enables Noname to perform the blocking operation in an external system, such as an AWS API Gateway or an Azure API Manager at the same time it noname also informs Kong to block the ip address or OAuth JWT token associated with a known anomalous actor be it a bot-net or a hacker tool or a QA test tool. When blocking, you can specify a time period for the block; the external system manages the block and the removal of the block.  

The nonamesecurity plugin is a prerequisite when using the noname-prevention plugin.

The Noname Security Kong plugin is available as a lua rocks module via the noname integrations admin console.  Noname Security prevention integration for Kong uses a noname provided custom lua rocks plugin to [identify and block attackers](https://docs.nonamesecurity.com/docs/kong-prevention) that were found using the Noname anomaly detection plugin called nonamesecurity. 

### Performance Benchmarks 
[Kong Enterprise 2.8.1.1 with Noname 3.1](https://docs.nonamesecurity.com/v320/docs/kong-performance-results)


## How to install

### The Noname blocking and prevention plugin for Kong 

[Noname Security Kong Prevention install and configuration Documentation](https://docs.nonamesecurity.com/docs/kong-prevention)

1. Create the Integration Profile

In the Noname UI, navigate to Settings > Integrations > Prevention.
Select Add Integration and select the Kong tile to create an integration profile.
Download the Zip file, and copy it to your Kong machine.
Select Next.
Enter the Kong Admin API URL.
Enter key-value sets for the Authentication headers to enable noname to authenticate with Kong.
Select Next.
Provide an alias for the integration.
Select Finish to save the integration.

2. Install the LuaRocks module

Upload and activate the noname prevention plugin to kong using the following steps: In your Kong machine CLI shell Navigate to the location of the copied Zip file and unzip the file.
Run the following command to install the plugin:


```shell
luarocks make

```

3. Update the Kong plugins configuration environment variable 

Add the noname-prevention plugin to the kong configuration file (usually /etc/kong/kong.conf).

    Open the file, find the plugins, and add noname-prevention. For example:
    
```yaml
plugins = bundled,noname-prevention
```

4. Restart Kong

After LuaRocks is installed, restart Kong before enabling the plugin

```shell
kong restart
```

### Install via a Dockerfile to create a custom kong docker image with both of the noname kong plugins preinstalled

```yaml
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

Note the above Dockerfile installs both the noname traffic source for machine learning plugin and the noname prevention plugin for automated blocking. 

## Using the Noname Security Kong Prevention plugin

Configure the plugin
```shell
$ curl -X POST http://KONG_HOST:8001/services/<your-kong service-id>/plugins/ \
--data "name=noname-prevention"
```

```shell
curl -s http://KONG_HOST:8001
```
Under the "available_on_server" section in the response, make sure you find the plugin "noname-prevention".

Enable the noname-prevention plugin: 

```shell
curl -X POST 'http://KONG_HOST:8001/plugins' -d 'name=noname-prevention'
```

Alternatively, enable the plugin for a single service using:
```shell
curl -X POST 'http://KONG_HOST:8001/services/<SERVICE>/plugins' -d 'name=noname-prevention'
```

Or enable the plugin for a single route using:
```shell
curl -X POST 'http://KONG_HOST:8001/routes/<ROUTE>/plugins' -d 'name=noname-prevention'
```
