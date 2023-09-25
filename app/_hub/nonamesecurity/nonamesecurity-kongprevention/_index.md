---
nav_title: Overview
---

Noname Security prevention integration for Kong uses a noname provided custom lua rocks plugin to [identify and block attackers](https://docs.nonamesecurity.com/docs/kong-prevention) that were found using Nonames' anomaly detection module.

The Noname Security prevention integration for Kong Open Source or Kong Enteprise instructs the Kong API Gateway to block API requests that are associated with anomalous IP addresses, headers, cookies, query strings, or JWT tokens. Kong Konnect data-plane integration for this noname machine learning powered prevention integration is currently in BETA. 


## How it works

Prevention integrations enable Noname to automatically block, or you to manually block, suspicious or dangerous runtime traffic to your APIs. The integration enables Noname to perform the blocking operation in an external system, such as an AWS API Gateway or an Azure API Manager at the same time it noname also informs Kong to block the ip address or OAuth JWT token associated with a known anomalous actor be it a bot-net or a hacker tool or a QA test tool. When blocking, you can specify a time period for the block; the external system manages the block and the removal of the block.

All integrations require you to create an integration profile in Noname. Nearly all integrations require you to have administration access to the systems with which you want to integrate. The simplest integrations require you to record some kind of credentials and/or access key from the remote system to enter into Noname while creating the profile. This enables Noname to receive information from, or perform actions on, the remote system. For example, to fetch a log file, or to initiate a block based on an incident created in Noname.



### Not an Inline Solution

Noname's prevention feature is not an inline solution. It takes between a few seconds and a minute for traffic packets to reach Noname, depending on the traffic source integration. It then takes between a few seconds and a few minutes for Noname to generate an incident after receiving a packet. When an incident triggers a blocking request, it takes a few seconds for Noname to send the request using a prevention integration. The above procedure is for a user who is not already blocked in the external system. If the user was already blocked, then the block is handled by the Kong API Gateway. 

### Performance Benchmarks 
[Kong Enterprise 2.8.1.1 with Noname 3.1](https://docs.nonamesecurity.com/v320/docs/kong-performance-results)


## How to install

###The Noname traffic source plugin for Kong 

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

###The Noname blocking and prevention plugin for Kong 

[Noname Security Kong Prevention install and configuration Documentation](https://docs.nonamesecurity.com/docs/kong-prevention)

Step 1 - Create the Integration Profile
In the Noname UI, navigate to Settings > Integrations > Prevention.
Select Add Integration and select the Kong tile to create an integration profile.
Download the Zip file, and copy it to your Kong machine.
Select Next.
Enter the Kong Admin API URL.
Enter key-value sets for the Authentication headers to enable noname to authenticate with Kong.
Select Next.
Provide an alias for the integration.
Select Finish to save the integration.

Step 2 - Upload Policy
Upload and activate the noname prevention plugin to kong using the following steps:
In your Kong machine CLI shell:
Navigate to the location of the copied Zip file and unzip the file.
Run the following command to install the plugin:

### Install the Noname prevention plugin for Kong Open Source or Kong Enterprise

```shell
luarocks make

```

### Install via a Dockerfile to create a custom kong docker image with noname preinstalled


```yaml
FROM kong/kong-gateway:3.4USER rootRUN \apt-get update && \apt-get install unzip -y  
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


### Update the Kong plugins configuration environment variable 

Add the noname-prevention plugin to the kong configuration file (usually /etc/kong/kong.conf).

    Open the file, find the plugins, and add noname-prevention. For example:


```yaml
plugins = bundled,nonamesecurity,noname-prevention
   
```

### Restart Kong

After LuaRocks is installed, restart Kong before enabling the plugin

```shell
kong restart
```

### Enable the Noname Security Kong Prevention plugin
Make sure the plugin is active: (replace KONG_HOST with the Kong API hostname).

```shell
curl -s http://KONG_HOST:8001
```
Under the "available_on_server" section in the response, make sure you find the plugin "noname-prevention".


Enable the noname-prevention plugin: (replace KONG_HOST with the Kong API hostname).

```shell
curl -X POST 'http://KONG_HOST:8001/plugins' -d 'name=noname-prevention'
```

Alternatively, enable the plugin for a single service using:
```shell
curl -X POST 'http://localhost:8001/services/<SERVICE>/plugins' -d 'name=noname-prevention'
```

Or enable the plugin for a single route using:
```shell
curl -X POST 'http://localhost:8001/routes/<ROUTE>/plugins' -d 'name=noname-prevention'
```