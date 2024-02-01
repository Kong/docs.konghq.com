---
nav_title: Overview
title: Overview
---
The AppSentinels API Security Platform is purpose-built for keeping the security needs of next-generation applications in mind.
At the platform's core is an AI/ML engine, AI Sentinels, which combines multiple intelligence inputs to completely understand and baseline unique application business logic, user contexts, and intents, as well as data flow within the application, to provide the complete protection your application needs.

## How it works

AppSentinels plugin performs logging as well as enforcement (blocking) of API transactions

## How to install

* Download the kong plugin code provided by AppSentinels
* Mount or create an image using the lua files (usually mounted at /usr/local/share/lua/5.1/kong/plugins/)
* Configure the plugin to enable it

## Using the plugin

* To enable logging/transparent mode
```
curl -X POST http://<kong-admin-endpoint>/plugins/ --data name=appsentinels --data config.http_endpoint=http://onprem-controller:9004
```

* To enable authz/enforcement mode
```
curl -X POST http://<kong-admin-endpoint>/plugins/ --data name=appsentinels --data config.http_endpoint=http://onprem-controller:9004 --data config.authz=true
```
