---
title: How to Install Kong Enterprise on Docker
---

## Introduction

This guide walks through downloading, installing, and starting **Kong Enterprise** on **Docker**.

The configuration shown in this guide is intended only as an example. Depending on your
environment, you may need to make modifications, and take measures to properly conclude
the installation and configuration.

Kong supports both PostgreSQL 9.5+ and Cassandra 3.11.* as its datastore.  In this guide, we
show steps to configure PostgreSQL.


## Prerequisites

To complete this guide you will need:

* A valid *Bintray* account. You will need your *username*, account *password* and account *API KEY*.
    * Example:
        * Bintray Access key = `john-company`
        * Bintray username = `john-company@kong`
        * Bintray password = `12345678`
        * Bintray API KEY = `12234e314356291a2b11058591bba195830`
            *Can be obtained by visiting https://bintray.com/profile/edit and selecting "API Key"
* A Docker enabled system with proper Docker access.
* A valid **Kong Enterprise License** JSON file, this can be found in your Bintray account. See [Accessing Your License](/enterprise/latest/deployment/access-license)

## Step 1. Add the Kong Docker Repository and Pull the Kong Enterprise Docker Image
   
   ```
   $ docker login -u <your_username_from_bintray> -p <your_apikey_from_bintray> kong-docker-kong-enterprise-edition-docker.bintray.io
 $ docker pull kong-docker-kong-enterprise-edition-docker.bintray.io/kong-enterprise-edition
   ```
You should now have your Kong Enterprise image locally. Run `docker images` to verify and find the image ID matching your repository.
   
1a. Tag the image ID for easier use:
   ```
   docker tag <IMAGE ID> kong-ee
   ```
   (Replace "IMAGE ID" with the one matching your repository, seen in step 4)
   
## Step 2. Create a docker network

Create a custom network to allow the containers to discover and communicate with each other. 

   ```bash
   $ docker network create kong-ee-net
   ```

## Step 3. Start a Database

If using a Cassandra container:

   ```bash
   $ docker run -d --name kong-ee-database \
                 --network=kong-ee-net \
                 -p 9042:9042 \
                 cassandra:3
   ```

   If using a PostgreSQL container:

   ```bash
   $ docker run -d --name kong-ee-database \
                 --network=kong-ee-net \
                 -p 5432:5432 \
                 -e "POSTGRES_USER=kong" \
                 -e "POSTGRES_DB=kong" \
                 postgres:9.6
   ```

## Step 4. Export the license key to a variable

   ```sh
   export KONG_LICENSE_DATA='{"license":{"signature":"LS0tLS1CRUdJTiBQR1AgTUVTU0FHRS0tLS0tClZlcnNpb246IEdudVBHIHYyCgpvd0did012TXdDSFdzMTVuUWw3dHhLK01wOTJTR0tLWVc3UU16WTBTVTVNc2toSVREWk1OTFEzVExJek1MY3dTCjA0ek1UVk1OREEwc2pRM04wOHpNalZKVHpOTE1EWk9TVTFLTXpRMVRVNHpTRXMzTjA0d056VXdUTytKWUdNUTQKR05oWW1VQ21NWEJ4Q3NDc3lMQmorTVBmOFhyWmZkNkNqVnJidmkyLzZ6THhzcitBclZtcFZWdnN1K1NiKzFhbgozcjNCeUxCZzdZOVdFL2FYQXJ0NG5lcmVpa2tZS1ozMlNlbGQvMm5iYkRzcmdlWFQzek1BQUE9PQo9b1VnSgotLS0tLUVORCBQR1AgTUVTU0FHRS0tLS0tCg=","payload":{"customer":"Test Company Inc","license_creation_date":"2017-11-08","product_subscription":"Kong Enterprise","admin_seats":"5","support_plan":"None","license_expiration_date":"2017-11-10","license_key":"00141000017ODj3AAG_a1V41000004wT0OEAU"},"version":1}}'
   ```

The license data must contain only straight quotes to be considered valid JSON.

## Step 5. Prepare the Kong Database

   ```
   docker run --rm --network=kong-ee-net \
     -e "KONG_DATABASE=postgres" \
     -e "KONG_PG_HOST=kong-ee-database" \
     -e "KONG_CASSANDRA_CONTACT_POINTS=kong-ee-database" \
     -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" \
     kong-ee kong migrations bootstrap
   ```

## Step 6. Start Kong and enable Kong Manager and Kong Developer Portal

   ```
   docker run -d --name kong-ee --network=kong-ee-net \
     -e "KONG_DATABASE=postgres" \
     -e "KONG_PG_HOST=kong-ee-database" \
     -e "KONG_CASSANDRA_CONTACT_POINTS=kong-ee-database" \
     -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
     -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
     -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
     -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
     -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
     -e "KONG_PORTAL=on" \
     -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" \
     -e "KONG_PASSWORD=<password-only-you-know> \
     -e "KONG_ADMIN_GUI_AUTH=basic-auth" \
     -e 'KONG_ADMIN_GUI_SESSION_CONF={"secret":"secret","storage":"kong","cookie_secure":false}' \
     -e "KONG_PORTAL_GUI_HOST=DNSorIP:8003" \
     -e "KONG_ADMIN_GUI_URL=http://DNSorIP:8002" \
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
  
   **Docker on Windows users:** Instead of the `KONG_LICENSE_DATA` environment variable, use the [volume bind](https://docs.docker.com/engine/reference/commandline/run/#options) option. For example, assuming you've saved your `license.json` file into `C:\temp`, use `--volume /c/temp/license.json:/etc/kong/license.json` to specify the license file.
   
   **Replace DNSorIP with the DNS name or IP of the Docker host**

## Step 7. Verify Kong was successfully installed
   
   ```
   curl -i -X GET --url http://localhost:8001/services
   ```
   You should receive an HTTP/1.1 200 OK message.
   
   You may now access Kong Manager via the URL specified in KONG_ADMIN_GUI_URL and Kong Developer Portal via the URL specified in KONG_PORTAL_GUI_HOST in Step 6.
   

## Troubleshooting

If you did not receive an HTTP/1.1 200 OK message, or need assistance completing
setup reach out to your **Support contact** or head over to the
[Support Portal](https://support.konghq.com/support/s/).


## Next Steps

Work through Kong Enterprise's series of 
[Getting Started](/enterprise/latest/getting-started) guides to get the most
out of Kong Enterprise.
   
