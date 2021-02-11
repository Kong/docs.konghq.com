---
title: Install Kong Gateway on Docker
---

## Introduction

This guide walks through downloading, installing, and starting **{{site.ee_product_name}}** on **Docker**.

The configuration shown in this guide is intended as an example. Depending on your
environment, you may need to make modifications and take measures to properly conclude
the installation and configuration.

{{site.base_gateway}} supports both PostgreSQL 9.5+ and Cassandra 3.11.* as its datastore. This guide provides
steps to configure PostgreSQL.

This software is governed by the
[Kong Software License Agreement](https://konghq.com/enterprisesoftwarelicense/).

### Deployment options

{% include /md/{{page.kong_version}}/deployment-options.md %}

## Prerequisites

To complete this installation you will need a Docker-enabled system with proper
 Docker access.

## Step 1. Pull the Kong Gateway Docker image {#pull-image}

Using Docker, pull the following Docker image:

```bash
$ docker pull kong-docker-kong-gateway-docker.bintray.io/kong-enterprise-edition:{{page.kong_versions[10].version}}-alpine
```

You should now have your {{site.base_gateway}} image locally.

Verify that it worked, and find the image ID matching your repository:

```bash
$ docker images
```

Tag the image ID for easier use:

```bash
$ docker tag <IMAGE_ID> kong-ee
```

**Note:** Replace `<IMAGE_ID>` with the one matching your repository.

## Step 2. Create a Docker network {#create-network}

Create a custom network to allow the containers to discover and communicate with each other.

```bash
$ docker network create kong-ee-net
```

## Step 3. Start a database

Start a PostgreSQL container:

```bash
$ docker run -d --name kong-ee-database \
  --network=kong-ee-net \
  -p 5432:5432 \
  -e "POSTGRES_USER=kong" \
  -e "POSTGRES_DB=kong" \
  -e "POSTGRES_PASSWORD=kong" \
  postgres:9.6
```

## Step 4. Prepare the Kong database

```bash
$ docker run --rm --network=kong-ee-net \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-ee-database" \
  -e "KONG_PG_PASSWORD=kong" \
  -e "KONG_PASSWORD=<SOMETHING-YOU-KNOW>" \
  kong-ee kong migrations bootstrap
```

**Note**: For `KONG_PASSWORD`, replace `<SOMETHING-YOU-KNOW>` with a valid password that only you know.

## Step 5. Start the gateway with Kong Manager

```bash
$ docker run -d --name kong-ee --network=kong-ee-net \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-ee-database" \
  -e "KONG_PG_PASSWORD=kong" \
  -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
  -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
  -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
  -e "KONG_PORTAL_GUI_HOST=<DNSorIP>:8003" \
  -e "KONG_ADMIN_GUI_URL=http://<DNSorIP>:8002" \
  -p 8000:8000 \
  -p 8443:8443 \
  -p 8001:8001 \
  -p 8444:8444 \
  -p 8002:8002 \
  -p 8445:8445 \
  -p 8003:8003 \
  -p 8004:8004 \
  kong-ee
```

**Notes**
- For `KONG_PORTAL_GUI_HOST` and `KONG_ADMIN_GUI_URL`, replace `<DNSorIP>` with with the DNS name or IP of the Docker host.
  * The DNS or IP address for `KONG_PORTAL_GUI_HOST` should _not_ be preceded with a protocol, e.g. `http://`.
  * `KONG_ADMIN_GUI_URL` _should_ have a protocol, e.g., `http://`.

## Step 6. Verify your installation

```bash
$ curl -i -X GET --url http://<DNSorIP>:8001/services
```

You should receive an `HTTP/1.1 200 OK` message.

Verify that Kong Manager is running by accessing it using the URL specified in `KONG_ADMIN_GUI_URL` in [Step 6](#step-6-start-kong-enterprise-with-kong-manager-and-kong-developer-portal-enabled).

## Step 7. (Optional) Enable the Dev Portal

<div class="alert alert-ee">
<img class="no-image-expand" src="/assets/images/icons/documentation/icn-enterprise-blue.svg" alt="Enterprise" />
This feature is only available with a {{site.konnect_product_name}} Enterprise subscription.
</div>

In your container, set `KONG_PORTAL` to `on`:

```sh
$ echo "KONG_PORTAL=on \
  kong reload exit" | docker exec -i <kong-container-id> /bin/sh \
```

Execute the following command. Change `<DNSorIP>` to the IP or valid DNS of your Docker host:

  ```bash
  $ curl -X PATCH http://<DNSorIP>:8001/workspaces/default --data "config.portal=true"
  ```

Verify the Developer Portal is running by accessing it at the URL specified in the `KONG_PORTAL_GUI_HOST` variable in [Step 6](#step-6-start-kong-enterprise-with-kong-manager-and-kong-developer-portal-enabled).

## Troubleshooting

If you did not receive an `HTTP/1.1 200 OK` message or need assistance completing
setup, reach out to your **Support contact** or head over to the
[Support Portal](https://support.konghq.com/support/s/).


## Next Steps

Check out {{site.base_gateway}}'s series of
[Getting Started](/getting-started-guide/latest/overview) guides to get the most
out of {{site.base_gateway}}.

If you have an Enterprise subscription, add the license using the
[`/licenses` Admin API endpoint](/enterprise/{{page.kong_version}}/deployment/licenses/deploy-license).
