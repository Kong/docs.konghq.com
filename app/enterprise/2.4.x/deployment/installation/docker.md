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

{% include /md/{{page.kong_version}}/deployment-options.md %}

## Prerequisites

To complete this installation you will need a Docker-enabled system with proper
 Docker access.

{% include /md/2.4.x/docker-install-steps.md heading="## Step 1. " heading1="## Step 2. " heading2="## Step 3. " heading3="## Step 4. " %}

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
[Getting Started](/getting-started-guide/latest/overview) guides to get the most
out of {{site.base_gateway}}.

If you have an Enterprise subscription, add the license using the
[`/licenses` Admin API endpoint](/enterprise/{{page.kong_version}}/deployment/licenses/deploy-license).
