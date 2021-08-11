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

{% include /md/{{page.kong_version}}/docker-install-steps.md heading="## Step 1. " heading1="## Step 2. " heading2="## Step 3. " heading3="## Step 4. " %}

## Step 5. Start the gateway with Kong Manager {#start-gateway}

<pre><code>docker run -d --name kong-ee --network=kong-ee-net \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-ee-database" \
  -e "KONG_PG_PASSWORD=kong" \
  -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
  -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
  -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
  -e "KONG_ADMIN_GUI_URL=http://<div contenteditable="true">{HOSTNAME}</div>:8002" \
    -p 8000:8000 \
    -p 8443:8443 \
    -p 8001:8001 \
    -p 8444:8444 \
    -p 8002:8002 \
    -p 8445:8445 \
    -p 8003:8003 \
    -p 8004:8004 \
    kong-ee</code></pre>

{:.note}
> The `HOSTNAME` for `KONG_PORTAL_GUI_HOST` should be preceded by a protocol, for example, `http://`.

## Step 6. Verify your installation

1. Access the `/services` endpoint using the Admin API:

    <pre><code>curl -i -X GET --url http://<div contenteditable="true">{HOSTNAME}</div>:8001/services</code></pre>

    You should receive a `200` status code.

2. Verify that Kong Manager is running by accessing it using the URL specified
in `KONG_ADMIN_GUI_URL` in [Step 5](#start-gateway):

    <pre><code>http://<div contenteditable="true">{HOSTNAME}</div>:8002</code></pre>

## Step 7. (Optional) Enable the Dev Portal

{:.note}
> This feature is only available with a [{{site.konnect_product_name}} Enterprise](/enterprise/{{page.kong_version}}/deployment/licensing) subscription.

1. [Deploy a license](/enterprise/{{page.kong_version}}/deployment/licenses/deploy-license).

2. In your container, set the Portal URL and set `KONG_PORTAL` to `on`:

    ```plaintext
    echo "KONG_PORTAL_GUI_HOST=localhost:8003 KONG_PORTAL=on kong reload exit" \
      | docker exec -i kong-ee /bin/sh
    ```

    {:.note}
    > The `HOSTNAME` for `KONG_PORTAL_GUI_HOST` should not be preceded by a protocol, for example, `http://`.

3. Execute the following command. 

    <pre><code>curl -X PATCH --url http://<div contenteditable="true">{HOSTNAME}</div>:8001/workspaces/default \
        --data "config.portal=true"</code></pre>

4. Access the Dev Portal for the default workspace using the URL specified
in the `KONG_PORTAL_GUI_HOST` variable:

    <pre><code>http://<div contenteditable="true">{HOSTNAME}</div>:8003/default</code></pre>

## Troubleshooting

If you did not receive a `200 OK` status code or need assistance completing
setup, reach out to your **Support contact** or head over to the
[Support Portal](https://support.konghq.com/support/s/).

## Next Steps

Check out {{site.base_gateway}}'s series of
[Getting Started](/getting-started-guide/latest/overview) guides to get the most
out of {{site.base_gateway}}.

If you have an Enterprise subscription, add the license using the
[`/licenses` Admin API endpoint](/enterprise/{{page.kong_version}}/deployment/licenses/deploy-license).

