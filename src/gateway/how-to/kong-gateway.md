---
title: "Run Kong Gateway in minutes"
description: "A how-to guide for quickly starting a Kong Gateway"
---

In order to explore the capabilities of [{{site.base_gateway}}](/gateway), 
you'll need one to experiment with. This guide helps you quickly deploy Kong 
using [Docker](https://docs.docker.com/get-started/overview/) which is the 
easiest way to get started. This guide's purpose is not to provide a production like deployment
or explanation of deployment steps, rather to quickly get you a running gateway and an 
example [service](/gateway/admin-api/#service-object) as quickly as possible.

### Prerequisites

This guide assumes each of the following tools are installed locally. 
* [Docker](https://docs.docker.com/get-docker/) is used to run Kong and the supporting database locally. This guide has been tested with version `20.10.17`.
* [curl](https://curl.se/) is used to send requests to the gateway. Most systems come with `curl` pre-installed.

### Steps 

In order to get started quickly, you'll download and run a bash script which contains 
commands to run Kong, it's supporting database, and an example service to work with.
Then you'll interact with the gateway using `curl` to ensure it has been started properly.

Run the following command to start {{site.base_gateway}} using Docker:

```sh
curl -Ls spurgeon.dev/how-to-kong | sh -s
```

{:.note}
> **Note:** The script creates a log file in the current directory named `how-to-kong.log`

Docker is now downloading and running the {{site.base_gateway}} and supporting database. Additionally,
the script bootstraps the database and installs a [mock service](https://mockbin.org/) to experiment with.
Depending on your internet download speeds, this command should complete relatively quickly, and once you have the images cached locally, subsequent usage of this guide will complete much faster.

Once Kong is available, you will see:

```text
✔ Kong is ready!
```

Importantly, the script outputs connectivity details for your new gateway, which should look similar to the following:

```text
Kong Data Plane endpoint = localhost:55248
Kong Admin API endpoint  = localhost:55247
```

Docker is assigning available network ports on the host machine, assigning them to the gateway services, and forwarding 
network traffic to the gateway. You can see all the ports the gateway is listening on and the related host ports 
with this docker command:

```sh
docker port how-to-kong-gateway
```

To make things easier you can export the Kong connection values to environment variables
for use in future commands:

```sh
export KONG_ADMIN=$(docker port how-to-kong-gateway 8001/tcp)
export KONG_PROXY=$(docker port how-to-kong-gateway 8000/tcp)
```

Test the [Kong Admin API](/gateway/admin-api/) with the following:

```sh
curl $KONG_ADMIN
```

You should see a large JSON response from the gateway.

Test that the gateway is proxying data by making a mock request on the gateway's data plane endpoint:

```sh
curl $KONG_PROXY/mock/requests
```

You should see a JSON response from the mock service with various information.
 
### What's next?

You now have a {{site.base_gateway}} running locally. Kong has a tremendous amount of capabilities
to help you manage, configure and route requests to your APIs.

* To follow a more detailed step-by-step guide to starting Kong, see the 
[Kong Getting Started guide](/gateway/get-started/quickstart/).
* The [Admin API documentation](/gateway/admin-api/) 
provides more details on managing a {{site.base_gateway}}.
* Learn about modifying incoming JSON requests with no code by using the 
[request-transformer plugin](/how-to/request-transformations).
