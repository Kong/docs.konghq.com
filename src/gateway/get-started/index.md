---
title: Get Kong
content-type: tutorial
book: get-started
chapter: 1
---

[{{site.base_gateway}}](/gateway/latest/) is a lightweight, fast, and flexible cloud-native API gateway. 
{{site.base_gateway}} sits in front of your service applications, dynamically controlling, analyzing, and 
routing requests and responses. {{site.base_gateway}} implements your API traffic policies 
by using a flexible, low-code, plug-in based approach. 

This tutorial will help you get started with {{site.base_gateway}} by setting up a local installation
and walking through some common API management tasks. 

This page will walk you through running {{site.base_gateway}} and verifying it with the
[Admin API](/gateway/latest/admin-api). Once complete, the following tasks 
can be performed to complete the tutorial:

* [Understanding and configuring Services and Routes](/gateway/{{ page.kong_version }}/get-started/services-and-routes)
* [Configuring Rate Limiting to protect upstream Services](/gateway/{{ page.kong_version }}/get-started/rate-limiting)
* [Increase system performance with Proxy Caching](/gateway/{{ page.kong_version }}/get-started/proxy-caching)
* [Load Balancing for horizontal Service scaling](/gateway/{{ page.kong_version }}/get-started/load-balancing)
* [Protecting Services with Key Authentication](/gateway/{{ page.kong_version }}/get-started/key-authentication)

### Prerequisites

* [Docker](https://docs.docker.com/get-docker/) is used to run {{site.base_gateway}} and supporting database locally
* [curl](https://curl.se/) is used to send requests to {{site.base_gateway}}. `curl` is pre-installed on most systems
* [jq](https://stedolan.github.io/jq/) is used to process JSON responses on the command line. While useful, this tool is 
not necessary to complete the tasks of this tutorial. If you wish to proceed without `jq`, modify the commands to
remove `jq` processing.

### Get Kong

For the purposes of this tutorial, a `quickstart` script is provided to quickly run {{site.base_gateway}} and its supporting database.
This script uses Docker to run {{site.base_gateway}} and a [PostgreSQL](https://www.postgresql.org/) database as the backing database.

1. Run {{site.base_gateway}} with the `quickstart` script:

   ```sh
   curl -Ls https://get.konghq.com/quickstart | bash -s
   ```

   This script runs Docker containers for {{site.base_gateway}} and the supporting PostgreSQL database.
   The script also creates a Docker network for those containers to communicate over. Finally, the database is 
   initialized with the appropriate [migration](/gateway/latest/reference/cli/#kong-migrations) steps, 
   and once the {{site.base_gateway}} is ready, you will see the following message:

   ```text
   ✔ Kong is ready!
   ```

1. Verify that {{site.base_gateway}} is running:

   {{site.base_gateway}} serves an Admin API on the default port `8001`. The Admin API can be used for
   both querying and controlling the state of {{site.base_gateway}}. The following command
   will query the Admin API, fetching the headers only:

   ```sh
   curl --head localhost:8001
   ```

   If {{site.base_gateway}} is running properly, it will respond with a `200` HTTP code, similar to the following: 

   ```text
   HTTP/1.1 200 OK
   Date: Mon, 22 Aug 2022 19:25:49 GMT
   Content-Type: application/json; charset=utf-8
   Connection: keep-alive
   Access-Control-Allow-Origin: *
   Content-Length: 11063
   X-Kong-Admin-Latency: 6
   Server: kong/{{page.kong_version}}
   ```

1. Evaluate the {{site.base_gateway}} configuration:

   The root route of the Admin API provides important information about the running 
   {{site.base_gateway}} including networking, security, and plugin information. The full 
   configuration is provided in the `.configuration` key of the returned JSON document.

   ```sh
   curl -s localhost:8001 | jq '.configuration'
   ```

   You should receive a large JSON response with {{site.base_gateway}} configuration information.


Every step in this tutorial requires a running {{site.base_gateway}}, so leave
everything running and proceed to the next steps in this tutorial.

