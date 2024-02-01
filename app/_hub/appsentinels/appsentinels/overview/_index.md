---
nav_title: Overview
title: Overview
---
The AppSentinels API Security Platform is purpose-built for keeping the security needs of next-generation applications in mind.
At the platform's core is an AI/ML engine, AI Sentinels, which combines multiple intelligence inputs to completely understand and baseline unique application business logic, user contexts, and intents, as well as data flow within the application, to provide the complete protection your application needs.

## How it works

The AppSentinels plugin performs logging and enforcement (blocking) of API transactions.

## How to install

* Download the Kong plugin code provided by AppSentinels
* Mount or create an image using the Lua files (usually mounted at `/usr/local/share/lua/5.1/kong/plugins/`)
* Configure the plugin to enable it

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
