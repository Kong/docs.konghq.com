<!-- Shared between the Docker install page and the setting up Vitals with
InfluxDB page -->

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

<div class="alert alert-ee blue"><strong>Note:</strong> For <code>KONG_PASSWORD</code>, replace
 <code><SOMETHING-YOU-KNOW></code> with a valid password that only you know.</div>
