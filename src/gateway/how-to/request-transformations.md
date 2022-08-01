---
title: "Adding attributes to HTTP requests with Kong Gateway"
description: "A no-code solution to modifying requests for your APIs"
---

It's very common to have an HTTP service which accepts requests expecting a JSON document in the body.
Let's assume that the development team of your service plans to change the request API in the near future, 
and will eventually begin to require a new field in the JSON body of the requests. 
Eventually your client applications will need to upgrade their requests to support this new value, 
but how could you provide a default value for your services in the meantime?

[{{site.base_gateway}}](/gateway/{{page.kong_version}}/) supports a [Plugin](/hub/) 
architecture including a [Request Transformer Plugin](/hub/kong-inc/request-transformer/) 
that can modify incoming requests before proxying them to your upstream service. 
This can all be accomplished using a no-code solution and managed with no downtime using 
Kong's dynamic administrative capabilities.

This guide will show you how to configure the Request Transformer plugin using 
the [Kong Admin API](/gateway/{{page.kong_version}}/admin-api/) to modify incoming 
requests with a static constant value. Then you will test the feature with a mock 
request to verify the transformation process.

### Prerequisites

The guide assumes the following:

* You have a {{site.base_gateway}} instance available for testing that is reachable on `localhost`. 
If you would like help running a local gateway using Docker, see this companion 
[{{site.base_gateway}} in minutes](/gateway/{{page.kong_version}}/how-to/kong-gateway/) guide. If your gateway is available on 
a different host, adjust the commands in this guide appropriately.
* You have a service named `mock` installed on your gateway. You can adjust the 
commands to use a different service or use the [{{site.base_gateway}} in minutes](/gateway/{{page.kong_version}}/how-to/kong-gateway) guide to 
run a gateway with a `mock` service.
* You have [`curl`](https://curl.se/) installed on your system, which is used to send 
requests to the gateway. Most systems come with `curl` pre-installed.
* This guide uses the [`jq`](https://stedolan.github.io/jq/) command line JSON processing tool. While
this tool is not necessary to complete the tasks, it's helpful for processing JSON responses from
the gateway. If you do not have `jq` or do not wish to install it, you can modify the commands to remove
`jq` processing.

### Steps

There are a large number of Kong plugins, many of which need to 
be [custom installed](/gateway/{{page.kong_version}}/plugin-development/distribution/) 
prior to utilization. Kong ships prepackaged with a number of useful plugins including
the Request Transformer.

First verify the Request Transformer plugin is available on your gateway by querying the Admin API and using `jq` to filter the response looking at the plugins available on the server.

```sh
curl -s http://localhost:8001 | \
  jq -r '.plugins.available_on_server."request-transformer"'
```

The command output should be:
```
true
```

Now, assign a new instance of the Request Transformer plugin to
the mock service by sending a `POST` request to the Admin API.
In this command, the `config.add.body` value instructs the plugin to add a new
field to the body of incoming requests before forwarding them to the `mock` service.
In this example, we are instructing the plugin to add a field named `new-field` and 
give it a static value of `defaultValue`. 

```sh
curl -i -X POST http://localhost:8001/services/mock/plugins \
  --data "name=request-transformer" \
  --data "config.add.body=new-field:defaultValue"
```

The result of that command should be a successful `201 Created` HTTP response code with a 
JSON body including information about the new plugin instance.

The Request Transformer provides the ability to perform much more complex
transformations, see the 
[full documentation](/hub/kong-inc/request-transformer/) for more detail.

Next, we can use the `mock` service's `/requests` endpoint to test the behavior of the plugin.
The `/requests` API will echo back valuable information from the request we make to it including
headers and the request body we send.

```sh
curl -s -XPOST http://localhost:8000/mock/requests \
	-H 'Content-Type: application/json' \
	-d '{"existing-field": "abc123"}'
```

What you should notice in the JSON response is the `postData` value which includes the 
JSON body sent to the service. 

Here is a command to use `jq` to fully extract just the request body echoed back from the `mock` service.

```sh
curl -s -XPOST http://localhost:8000/mock/requests \
	-H 'Content-Type: application/json' \
	-d '{"existing-field": "Kong FTW!"}' | \
	jq -r '.postData.text'
```

Which should return the following, indicating `new-field` has been added to the sent request body.

```txt
{"existing-field":"Kong FTW!","new-field":"defaultValue"}
```

### What's next?

* More advanced transformations can be accomplished with the 
[Request Transformer Advanced](/hub/kong-inc/request-transformer-advanced/) 
plugin.
* If no standard plugin is available to satisfy your use case, the 
[Plugin Development Guide](/gateway/{{page.kong_version}}/plugin-development/) 
can help you with developing your own plugin.
