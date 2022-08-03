---
title: "Run Kong Gateway in minutes"
description: "A how-to guide for quickly starting a Kong Gateway"
---

In order to explore the capabilities of [{{site.base_gateway}}](/gateway), 
you'll need one to experiment with. This guide helps you quickly deploy Kong 
using [Docker](https://docs.docker.com/get-started/overview/). This guide's purpose is not to provide a production-like deployment or an explanation of deployment steps but rather to quickly get you a running {{site.base_gateway}} instance and an example [service](/gateway/admin-api/#service-object) as quickly as possible.

### Prerequisites

This guide assumes each of the following tools are installed locally. 
* [Docker](https://docs.docker.com/get-docker/) is used to run Kong and the supporting database locally. 
* [curl](https://curl.se/) is used to send requests to the gateway. Most systems come with `curl` pre-installed.

### Steps 

In order to get started, you'll download and execute a shell script that automatically installs Kong, its supporting database, and an example service.
Then you'll interact with the gateway using `curl` to ensure it has been started properly.

Run the following command to start {{site.base_gateway}} using Docker:

```sh
curl -Ls get.konghq.com/quickstart | sh -s
```

{:.note}
> **Note:** The script creates a log file in the current directory named `kong-quickstart.log`

Docker will download and run {{site.base_gateway}} and the supporting database. Additionally,
the script bootstraps the database and installs a [mock service](https://mockbin.org/).

Once Kong is available, you will see:

```text
✔ Kong is ready!
```

Importantly, the script outputs connectivity details for your new gateway, which should look similar to the following:

```text
Kong Data Plane endpoint = localhost:55248
Kong Admin API endpoint  = localhost:55247
```

Docker assigns available network ports on the host machine to {{site.base_gateway}} services and forwards 
network traffic to {{site.base_gateway}}. You can see all the ports that {{site.base_gateway}} is listening on and the related host ports 
using this Docker command:

```sh
docker port kong-quickstart-gateway
```

The script will create a file with connection values you can source into your environment
that you can use throughout the rest of the guide. Load the values into your current environment: 

```sh
source kong.env
```

After you have sourced the `kong.env` environment variable file, 
test the [Kong Admin API](/gateway/admin-api/) with the following:

```sh
curl $KONG_ADMIN_API
```

You will see a large JSON response from the gateway.

Test that {{site.base_gateway}} is proxying data by making a mock request to the gateway's data plane endpoint:

```sh
curl $KONG_PROXY/mock/requests
```

If everything is working correctly, you will see a JSON response from the mock service with various 
information about the request made, including headers, timestamps, and IP addresses.

### Cleanup

Once you are done working with {{site.base_gateway}}, you can use the shell script to stop and 
remove the gateway and database containers with the following command:

```sh
curl -Ls get.konghq.com/quickstart | sh -s -- -d
```

### What's next?

You now have a {{site.base_gateway}} instance running locally. Kong offers a tremendous amount of capabilities
to help you manage, configure and route requests to your APIs.

* To follow a more detailed step-by-step guide to starting Kong, see the 
[Kong Getting Started guide](/gateway/get-started/quickstart/).
* The [Admin API documentation](/gateway/admin-api/) 
provides more details on managing a {{site.base_gateway}}.
* Learn about modifying incoming JSON requests with no code by using the 
[request-transformer plugin](/how-to/request-transformations).

