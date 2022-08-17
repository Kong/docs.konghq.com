---
title: Install Kong Enterprise on Docker
---

## Introduction

This guide walks through downloading, installing, and starting **Kong Enterprise** on **Docker**.

The configuration shown in this guide is intended as an example. Depending on your
environment, you may need to make modifications and take measures to properly conclude
the installation and configuration.

Kong supports both PostgreSQL 9.5+ and Cassandra 3.11.* as its datastore. This guide provides
steps to configure PostgreSQL.


## Prerequisites

To complete this installation you will need:
- Docker
{% include /md/enterprise/license.md license='prereq' %}

## Step 1. Add the Kong Docker Repository and Pull the Kong Enterprise Docker Image

{% include /md/enterprise/install.md install='docker' %}

**Note:** Replace `<IMAGE_ID>` with the one matching your repository.

## Step 2. Create a Docker Network

Create a custom network to allow the containers to discover and communicate with each other.

```bash
$ docker network create kong-ee-net
```

## Step 3. Start a Database

Start a PostgreSQL container:

```bash
$ docker run -d --name kong-ee-database \
  --network=kong-ee-net \
  -e "POSTGRES_USER=kong" \
  -e "POSTGRES_DB=kong" \
  -e "POSTGRES_PASSWORD=kong" \
  postgres:9.6
```

## Step 4. Export the License Key to a Variable

{% include /md/enterprise/license.md license='<1.3' %}

Run the following command, substituting your own license key (see
[Prerequisites](#prerequisites)).

The license data must contain straight quotes to be considered valid JSON
(`'` and `"`, not `’` or `“`).

<div class="alert alert-ee blue">
<b>Note:</b>
The following license is only an example. You must use the following format,
but provide your own content.
</div>

```bash
$ export KONG_LICENSE_DATA='{"license":{"signature":"LS0tLS1CRUdJTiBQR1AgTUVTU0FHRS0tLS0tClZlcnNpb246IEdudVBHIHYyCgpvd0did012TXdDSFdzMTVuUWw3dHhLK01wOTJTR0tLWVc3UU16WTBTVTVNc2toSVREWk1OTFEzVExJek1MY3dTCjA0ek1UVk1OREEwc2pRM04wOHpNalZKVHpOTE1EWk9TVTFLTXpRMVRVNHpTRXMzTjA0d056VXdUTytKWUdNUTQKR05oWW1VQ21NWEJ4Q3NDc3lMQmorTVBmOFhyWmZkNkNqVnJidmkyLzZ6THhzcitBclZtcFZWdnN1K1NiKzFhbgozcjNCeUxCZzdZOVdFL2FYQXJ0NG5lcmVpa2tZS1ozMlNlbGQvMm5iYkRzcmdlWFQzek1BQUE9PQo9b1VnSgotLS0tLUVORCBQR1AgTUVTU0FHRS0tLS0tCg=","payload":{"customer":"Test Company Inc","license_creation_date":"2017-11-08","product_subscription":"Kong Enterprise","admin_seats":"5","support_plan":"None","license_expiration_date":"2017-11-10","license_key":"00141000017ODj3AAG_a1V41000004wT0OEAU"},"version":1}}'
```

## Step 5. Prepare the Kong Database

```bash
$ docker run --rm --network=kong-ee-net \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-ee-database" \
  -e "KONG_PG_PASSWORD=kong" \
  -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" \
  -e "KONG_PASSWORD=<SOMETHING-YOU-KNOW>" \
  kong-ee kong migrations bootstrap
```
**Note**: For `KONG_PASSWORD`, replace `<SOMETHING-YOU-KNOW>` with a valid password that only you know.

## Step 6. Start Kong Enterprise with Kong Manager and Kong Developer Portal Enabled

```bash
$ docker run -d --name kong-ee --network=kong-ee-net \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-ee-database" \
  -e "KONG_PG_PASSWORD=kong" \
  -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
  -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
  -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_LISTEN=<DNSorIP>:8001" \
  -e "KONG_PORTAL=on" \
  -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" \
  -e "KONG_PORTAL_GUI_HOST=<DNSorIP>:8003" \
  -e "KONG_ADMIN_GUI_URL=http://<DNSorIP>:8002" \
  -p 8000:8000 \
  -p 8443:8443 \
  -p 127.0.0.1:8001:8001 \
  -p 127.0.0.1:8444:8444 \
  -p 8002:8002 \
  -p 8445:8445 \
  -p 8003:8003 \
  -p 8004:8004 \
  kong-ee
```

**Notes**
- For `KONG_ADMIN_LISTEN`, `KONG_PORTAL_GUI_HOST` and `KONG_ADMIN_GUI_URL`, replace `<DNSorIP>` with with the DNS name or IP of the Docker host.
  * The DNS or IP address for `KONG_PORTAL_GUI_HOST` should _not_ be preceded with a protocol, e.g. `http://`.
  * `KONG_ADMIN_GUI_URL` _should_ have a protocol, e.g., `http://`.


**Docker on Windows users:** Instead of the `KONG_LICENSE_DATA` environment variable, use the [volume bind](https://docs.docker.com/engine/reference/commandline/run/#options) option. For example, assuming you've saved your `license.json` file into `C:\temp`, use `--volume /c/temp/license.json:/etc/kong/license.json` to specify the license file.

## Step 7. Finalize Configuration and Verify Success of Kong Installation

```bash
$ curl -i -X GET --url http://localhost:8001/services
```

You should receive an `HTTP/1.1 200 OK` message.

Verify that Kong Manager is running by accessing it using the URL specified in `KONG_ADMIN_GUI_URL` in [Step 6](#step-6-start-kong-enterprise-with-kong-manager-and-kong-developer-portal-enabled).

## Step 8. Enable the Developer Portal

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

Work through Kong Enterprise's series of
[Getting Started](/enterprise/latest/getting-started) guides to get the most
out of Kong Enterprise.
