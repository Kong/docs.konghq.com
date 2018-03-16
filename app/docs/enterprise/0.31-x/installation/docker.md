---
title: Installing Kong EE Docker Image
class: page-install-method
---

# Installing Kong EE from Docker Image

<img src="/assets/images/distributions/docker.svg"/>

A guide to installing locally Kong Enterprise Edition (and its new license file) as a Docker Container

1. Login to bintray.com (your credentials will have been emailed to you by your Sales or Support contact)

2. In the upper right corner, choose edit profile so you can retrieve your API key which you will use in step 3 (or click this link: https://bintray.com/profile/edit)

3. Now, open a Terminal window because we need to run some commands:

        docker login -u <your_username_from_bintray> -p <your_apikey_from_bintray> kong-docker-kong-enterprise-edition-docker.bintray.io
        docker pull kong-docker-kong-enterprise-edition-docker.bintray.io/kong-enterprise-edition

    Now you have the docker image for EE locally this way
    Run `docker images` to find the image

4. Tag it (for easier use in the commands below) as follows (replace w/ your image’s IMAGE ID):
        
        docker tag 92aa781a99db kong-ee

5. Generally, we'll be following the instructions here: https://getkong.org/install/docker/ with some slight (but important) differences

6. For convenience, the commands will look something like this (PostgreSQL 9.5 is required):

        docker run -d --name kong-ee-database -p 5432:5432 -e "POSTGRES_USER=kong" -e "POSTGRES_DB=kong" postgres:9.5

7. To make the license data easier to handle, export it as a shell variable. Please note that your `KONG_LICENSE_DATA` will differ! Get yours from: Bintray [https://bintray.com/kong/&lt;YOUR_REPO_NAME&gt;/license#files](https://bintray.com/kong/<YOUR_REPO_NAME>/license#files)

        export KONG_LICENSE_DATA='{"license":{"signature":"LS0tLS1CRUdJTiBQR1AgTUVTU0FHRS0tLS0tClZlcnNpb246IEdudVBHIHYyCgpvd0did012TXdDSFdzMTVuUWw3dHhLK01wOTJTR0tLWVc3UU16WTBTVTVNc2toSVREWk1OTFEzVExJek1MY3dTCjA0ek1UVk1OREEwc2pRM04wOHpNalZKVHpOTE1EWk9TVTFLTXpRMVRVNHpTRXMzTjA0d056VXdUTytKWUdNUTQKR05oWW1VQ21NWEJ4Q3NDc3lMQmorTVBmOFhyWmZkNkNqVnJidmkyLzZ6THhzcitBclZtcFZWdnN1K1NiKzFhbgozcjNCeUxCZzdZOVdFL2FYQXJ0NG5lcmVpa2tZS1ozMlNlbGQvMm5iYkRzcmdlWFQzek1BQUE9PQo9b1VnSgotLS0tLUVORCBQR1AgTUVTU0FHRS0tLS0tCg=","payload":{"customer":"Test Company Inc","license_creation_date":"2017-11-08","product_subscription":"Kong Enterprise Edition","admin_seats":"5","support_plan":"None","license_expiration_date":"2017-11-10","license_key":"00141000017ODj3AAG_a1V41000004wT0OEAU"},"version":1}}'

8. Run Kong migrations

        docker run --rm --link kong-ee-database:kong-ee-database \
          -e "KONG_DATABASE=postgres" -e "KONG_PG_HOST=kong-ee-database" \
          -e "KONG_CASSANDRA_CONTACT_POINTS=kong-ee-database" \
          -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" \
          kong-ee kong migrations up

9. Start Kong

        docker run -d --name kong-ee --link kong-ee-database:kong-ee-database \
          -e "KONG_DATABASE=postgres" \
          -e "KONG_PG_HOST=kong-ee-database" \
          -e "KONG_CASSANDRA_CONTACT_POINTS=kong-ee-database" \
          -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
          -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
          -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
          -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
          -e "KONG_VITALS=on" \
          -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
          -e "KONG_PORTAL=on" \
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

10. Congratulations! You now have Kong Enterprise installed and running. Test it by visiting: http://localhost:8002 (Admin GUI). If you load the Dev Portal (http://localhost:8003) expect a blank page until you follow these instructions: https://getkong.org/docs/enterprise/0.31-x/developer-portal/introduction/

## FAQs

- Starting with Kong `0.30`, the Admin API only listens on the local interface by default. This was done as a security enhancement. Note that here, we are overriding that in the above example with `KONG_ADMIN_LISTEN=0.0.0.0:8001` because Docker container networking benefits from more open settings and enables the Admin GUI & Dev Portal to talk more easily with the Kong Proxy.

- Starting with 0.29, without a license properly referenced, you’ll get errors running migrations. Also, without a license, you'll do a “docker start <name>” and not see an error attempting to start the container. But when you check the process, it won’t be running. Doing a “docker logs <container_name>” will show you:

        nginx: [alert] Error validating Kong license: license path environment variable not set

- As awareness, another error that can occur due to the vagaries of the interactions between text editors and copy & paste changing straight quotes (" or ') into curly ones (“ or ” or ’ or ‘) is:

        nginx: [alert] Error validating Kong license: could not decode license json

    Your license data must contain only straight quotes to be considered valid JSON.

## Enable RBAC and Vitals

Finally, two of the key features of 0.29+ are RBAC and Vitals. To enable them:

1. Start a bash session on the container
        
        docker exec -it kong-ee /bin/sh

2. KONG_ENFORCE_RBAC=on kong reload
3. export KONG_VITALS=on kong reload (note: included in the env vars above)
 
    > Note: with RBAC enabled, to make calls from the command line set the HTTP Header ‘Kong-Admin-Token’ (you don’t need the username, just the token):

4. Example using HTTPie: 
        
        http :8001/rbac/users kong-admin-token:secret
