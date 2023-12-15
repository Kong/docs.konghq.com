---
nav_title: Adding attributes to HTTP requests with Kong Gateway
title: Adding attributes to HTTP requests with Kong Gateway
---

It's very common to have an HTTP service which accepts requests expecting a JSON document in the body.
Let's assume that the development team of your service plans to change the request API in the near future, 
and will eventually begin to require a new field in the JSON body of the requests. 
Eventually your client applications will need to upgrade their requests to support this new value, 
but how could you provide a default value for your services in the meantime?

This guide will show you how to configure the Request Transformer plugin using 
the [Kong Admin API](/gateway/latest/admin-api/) to modify incoming 
requests with a static constant value. Then you will test the feature with a mock 
request to verify the transformation process.

## Prerequisites

* This document is best used after following the companion 
[{{site.base_gateway}} in minutes](/gateway/latest/get-started/) guide, which
walks you through running a local {{site.base_gateway}} in Docker, setting up
a mock [service](/gateway/latest/admin-api/#service-object), and the necessary connection details. 
If you'd like to use an existing {{site.base_gateway}} or a different service, you will need to adjust the 
commands in this guide as necessary.
* You have [`curl`](https://curl.se/) installed on your system, which is used to send 
requests to the gateway. Most systems come with `curl` pre-installed.
* This guide uses the [`jq`](https://stedolan.github.io/jq/) command line JSON processing tool. While
this tool is not necessary to complete the tasks, it's helpful for processing JSON responses from
the gateway. If you do not have `jq` or do not wish to install it, you can modify the commands to remove
`jq` processing.

## Set up the Request Transformer plugin

Assign a new instance of the Request Transformer plugin to
the mock service by sending a `POST` request to the Admin API.
In this command, the `config.add.body` value instructs the plugin to add a new
field to the body of incoming requests before forwarding them to the `mock` service.
In this example, we are instructing the plugin to add a field named `new-field` and 
give it a static value of `defaultValue`. 

```sh
curl -i -X POST $KONG_ADMIN_API/services/mock/plugins \
  --data "name=request-transformer" \
  --data "config.add.body=new-field:defaultValue"
```

If successful the API will return a `201 Created` HTTP response code with a 
JSON body including information about the new plugin instance.

Next, use the `mock` service's `/anything` endpoint to test the behavior of the plugin.
The `/anything` API will echo back helpful information from the request we send it, including
headers and the request body.

```sh
curl -s -XPOST $KONG_PROXY/mock/anything \
	-H 'Content-Type: application/json' \
	-d '{"existing-field": "abc123"}'
```

The JSON response will contain the `postData` field which includes the 
JSON body sent to the service. You can use `jq` to fully extract the request body 
returned from the `mock` service, as follows:

```sh
curl -s -XPOST $KONG_PROXY/mock/anything \
	-H 'Content-Type: application/json' \
	-d '{"existing-field": "Kong FTW!"}' | \
	jq -r '.postData.text'
```

This will output the following text indicating `new-field` has been added to the request body.

```txt
{"existing-field":"Kong FTW!","new-field":"defaultValue"}
```

### What's next?

* More advanced transformations can be accomplished with the 
[Request Transformer Advanced](/hub/kong-inc/request-transformer-advanced/) 
plugin.
* If no standard plugin is available to satisfy your use case, the 
[Plugin Development Guide](/gateway/latest/plugin-development/) 
can help you with developing your own plugin.
