---
nav_title: Overview
title: Overview
---
AppSentinels API Security Platform is purpose built keeping security needs of next generation applications in mind. At its core it's AI/ML engine, Al Sentinels, that combines multiple intelligence inputs to completely understand and baseline unique application business logic, user contexts and intents as well as dataflow within the application, to provide complete protection your application needs.

## How it works

Appsentinels plugin performs logging as well as enforcement (blocking) of API transactions

## How to install

* Download the kong plugin code provided by Appsentinels
* Mount or create an image using the lua files (usually mounted at /usr/local/share/lua/5.1/kong/plugins/appsentinels)
* Configure the plugin to enable it

## Using the plugin

* To enable logging/transparent mode
```
curl -X POST http://<kong-admin-endpoint>/plugins/ --data name=appsentinels-plugin --data config.http_endpoint=http://onprem-controller:9004
```

* To enable authz/enforcement mode
```
curl -X POST http://<kong-admin-endpoint>/plugins/ --data name=appsentinels-plugin --data config.http_endpoint=http://onprem-controller:9004 --data config.authz=true
```
