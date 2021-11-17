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
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense/).

### Deployment options

{% include /md/{{page.kong_version}}/deployment-options.md kong_version=page.kong_version %}

## Prerequisites

To complete this installation you will need a Docker-enabled system with proper
 Docker access.

## Step 1. Pull the Kong Gateway Docker image {#pull-image}

Pull the following Docker image:

```bash
$ docker pull kong/kong-gateway:{{page.kong_versions[10].version}}-alpine
```

<div class="alert alert-ee">
<b>Note:</b> Some
<a href="https://support.konghq.com/support/s/article/Downloading-older-Kong-versions">
older {{site.base_gateway}} images</a>
are not publicly accessible. If you need a specific patch version and can't
find it on Kong's public Docker Hub page, contact
<a href="https://support.konghq.com/">Kong Support</a>.
</div>

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

## Step 5. Start the gateway with Kong Manager {#start-gateway}

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

<div class="alert alert-ee">
<b>Note:</b> For <code>KONG_ADMIN_GUI_URL</code>, replace <code>&lt;DNSorIP&gt;</code>
with with the DNS name or IP of the Docker host. <code>KONG_ADMIN_GUI_URL</code>
<i>should</i> have a protocol, for example, <code>http://</code>.
</div>

## Step 6. Verify your installation

1. Access the `/services` endpoint using the Admin API:

    ```bash
    $ curl -i -X GET --url http://<DNSorIP>:8001/services
    ```

    You should receive an `HTTP/1.1 200 OK` message.

2. Verify that Kong Manager is running by accessing it using the URL specified
in `KONG_ADMIN_GUI_URL` in [Step 5](#start-gateway):

    ```
    http://<DNSorIP>:8002
    ```

## Step 7. (Optional) Enable the Dev Portal

<div class="alert alert-ee">
<img class="no-image-expand" src="/assets/images/icons/documentation/icn-enterprise-blue.svg" alt="Enterprise" />
This feature is only available with a
<a href="/enterprise/{{page.kong_version}}/deployment/licensing">
{{site.konnect_product_name}} Enterprise subscription</a>.
</div>

1. [Deploy a license](/enterprise/{{page.kong_version}}/deployment/licenses/deploy-license).

2. In your container, set the Portal URL and set `KONG_PORTAL` to `on`:

    ```sh
    $ echo "KONG_PORTAL_GUI_HOST=localhost:8003 KONG_PORTAL=on kong reload exit" \
      | docker exec -i kong-ee /bin/sh
    ```

    <div class="alert alert-ee">
    <b>Note:</b> For <code>KONG_PORTAL_GUI_HOST</code>, replace
    <code>&lt;DNSorIP&gt;</code> with with the DNS name or IP of the Docker host.
    The DNS or IP address for <code>KONG_PORTAL_GUI_HOST</code> should <i>not</i>
    be preceded by a protocol, for example, <code>http://</code>.
    </div>

3. Execute the following command. Change `<DNSorIP>` to the IP or valid DNS of
your Docker host:

    ```bash
    $ curl -X PATCH http://<DNSorIP>:8001/workspaces/default \
      --data "config.portal=true"
    ```

4. Access the Dev Portal for the default workspace using the URL specified
in the `KONG_PORTAL_GUI_HOST` variable:

    ```
    http://<DNSorIP>:8003/default
    ```

## Troubleshooting

If you did not receive an `HTTP/1.1 200 OK` message or need assistance completing
setup, reach out to your **Support contact** or head over to the
[Support Portal](https://support.konghq.com/support/s/).


## Next Steps

Check out {{site.base_gateway}}'s series of
[Getting Started](/gateway/latest/get-started/comprehensive/) guides to get the most
out of {{site.base_gateway}}.

If you have an Enterprise subscription, add the license using the
[`/licenses` Admin API endpoint](/enterprise/{{page.kong_version}}/deployment/licenses/deploy-license).
