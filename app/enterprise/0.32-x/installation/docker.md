---
title: Installing Kong EE Docker Image
---

## Introduction

<img src="/assets/images/distributions/docker.svg"/>

A guide to installing Kong Enterprise Edition (and its license file) as a Docker Container.

{% include /md/enterprise/license.md license='<1.3' %}

## Download and Install Kong Gateway

{% include /md/enterprise/install.md install='docker' %}

5. Generally, we'll be following the instructions [here](/install/docker/) with some slight (but important) differences

6. For convenience, the commands will look something like this (PostgreSQL 9.5 is required):

        docker run -d --name kong-ee-database \
        -p 5432:5432 \
        -e "POSTGRES_USER=kong" \
        -e "POSTGRES_DB=kong" \
        -e "POSTGRES_PASSWORD=kong" \
        -e "POSTGRES_HOST_AUTH_METHOD=trust" \
        postgres:9.6

7. To make the license data easier to handle, export it as a shell variable. Please note that your `KONG_LICENSE_DATA` will differ!

        export KONG_LICENSE_DATA='{"license":{"signature":"LS0tLS1CRUdJTiBQR1AgTUVTU0FHRS0tLS0tClZlcnNpb246IEdudVBHIHYyCgpvd0did012TXdDSFdzMTVuUWw3dHhLK01wOTJTR0tLWVc3UU16WTBTVTVNc2toSVREWk1OTFEzVExJek1MY3dTCjA0ek1UVk1OREEwc2pRM04wOHpNalZKVHpOTE1EWk9TVTFLTXpRMVRVNHpTRXMzTjA0d056VXdUTytKWUdNUTQKR05oWW1VQ21NWEJ4Q3NDc3lMQmorTVBmOFhyWmZkNkNqVnJidmkyLzZ6THhzcitBclZtcFZWdnN1K1NiKzFhbgozcjNCeUxCZzdZOVdFL2FYQXJ0NG5lcmVpa2tZS1ozMlNlbGQvMm5iYkRzcmdlWFQzek1BQUE9PQo9b1VnSgotLS0tLUVORCBQR1AgTUVTU0FHRS0tLS0tCg=","payload":{"customer":"Test Company Inc","license_creation_date":"2017-11-08","product_subscription":"Kong Enterprise Edition","admin_seats":"5","support_plan":"None","license_expiration_date":"2017-11-10","license_key":"00141000017ODj3AAG_a1V41000004wT0OEAU"},"version":1}}'

8. Run Kong migrations:

        docker run --rm --link kong-ee-database:kong-ee-database \
          -e "KONG_DATABASE=postgres" -e "KONG_PG_HOST=kong-ee-database" \
          -e "KONG_CASSANDRA_CONTACT_POINTS=kong-ee-database" \
          -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" \
          kong-ee kong migrations up

9. Start Kong:

        docker run -d --name kong-ee --link kong-ee-database:kong-ee-database \
          -e "KONG_DATABASE=postgres" \
          -e "KONG_PG_HOST=kong-ee-database" \
          -e "KONG_CASSANDRA_CONTACT_POINTS=kong-ee-database" \
          -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
          -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
          -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
          -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
          -e "KONG_VITALS=on" \
          -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" \
          -e "KONG_PORTAL=on" \
          -e "KONG_PORTAL_GUI_URI=localhost:8003" \
          -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" \
          -p 8000:8000 \
          -p 8443:8443 \
          -p 8001:8001 \
          -p 8444:8444 \
          -p 8002:8002 \
          -p 8445:8445 \
          -p 8003:8003 \
          -p 8004:8004 \
          kong-ee

10. Congratulations! You now have Kong Enterprise installed and running. You can use Kong Enterprise's web interfaces by visiting http://localhost:8002 (Admin GUI) and http://localhost:8003 (Developer Portal).

## Enable RBAC

[Role-based Access Control (RBAC)](/enterprise/{{page.kong_version}}/setting-up-admin-api-rbac/) allows you to create multiple Kong administrators and control which resources they have access to. To enable it:

1. Create an initial RBAC administrator:

        curl -X POST http://localhost:8001/rbac/users/ -d name=admin -d user_token=12345
        curl -X POST http://localhost:8001/rbac/users/admin/roles -d roles=super-admin

2. Start a bash session on the container:

        docker exec -it kong-ee /bin/sh

3. Reload Kong with RBAC enabled:

        KONG_ENFORCE_RBAC=on kong reload

4. Confirm that your user token is working by passing the `Kong-Admin-Token` header in requests:

        curl -X GET http://localhost:8001/status -H "Kong-Admin-Token: 12345"

If you are able to access Kong without issues, you can add `KONG_ENFORCE_RBAC=on` to your initial container environment variables.

## FAQs

The Admin API only listens on the local interface by default. This was done as a security enhancement. Note that here, we are overriding that in the above example with `KONG_ADMIN_LISTEN=0.0.0.0:8001` because Docker container networking benefits from more open settings and enables the Admin GUI & Dev Portal to talk with the Kong Proxy.

Without a license properly referenced, you’ll get errors running migrations. Also, without a license, you'll do a `docker start <name>` and not see an error attempting to start the container. But when you check the process, it won’t be running. Doing a `docker logs <container_name>` will show you:

        nginx: [alert] Error validating Kong license: license path environment variable not set

As awareness, another error that can occur due to the vagaries of the interactions between text editors and copy & paste changing straight quotes (" or ') into curly ones (“ or ” or ’ or ‘) is:

        nginx: [alert] Error validating Kong license: could not decode license json

Your license data must contain only straight quotes to be considered valid JSON.
