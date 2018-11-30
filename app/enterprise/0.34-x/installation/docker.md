---
title: Installing Kong Enterprise Docker Image
---

<img src="/assets/images/distributions/docker.svg"/>

## Installation Steps

A guide to installing Kong Enterprise—and its license file—using
Docker. **Trial users should skip directly to step 4**.

1. Log in to [bintray.com](https://bintray.com). Your credentials will have 
been emailed to you by your Sales or Support contact.

2. In the upper right corner, click "Edit Profile' to retrieve your API
key, which will be used in step 3. Alternatively, to retrieve it from
Bintray, click [here](https://bintray.com/profile/edit).

3. For **users with existing contracts**, add the Kong Docker repository and
pull the image:

    ```
    $ docker login -u <your_username_from_bintray> -p <your_apikey_from_bintray> kong-docker-kong-enterprise-edition-docker.bintray.io
    $ docker pull kong-docker-kong-enterprise-edition-docker.bintray.io/kong-enterprise-edition
    ```

4. For **trial users**, run the following, replacing `<your trial image URL>`
with the URL you received in your welcome email:

    ```
    curl -Lsv "<your trial image URL>" -o /tmp/kong-docker-ee.tar.gz
    docker load -i /tmp/kong-docker-ee.tar.gz
    ```

You should now have your Kong Enterprise Free Trial image locally. Run
`docker images` to find it.

5. Tag it—for easier use in the commands below—as follows:

    ```
    docker tag <IMAGE ID> kong-ee
    ```

    Replace "IMAGE ID" with `7fc852f88079` if the Free Trial image is for Kong
    Enterprise 0.31-1 or `78ffc3bce991` if it is for 0.32. Recent Kong Enterprise
    Free Trial images (>= 0.34) come with a more intuitive name.

6. Generally, we'll be following the instructions [here](/install/docker/) with
some slight, but important, differences

7. For convenience, the commands will look something like this—**PostgreSQL 9.5
is required**:

    ```
    docker run -d --name kong-ee-database \
      -p 5432:5432 \
      -e "POSTGRES_USER=kong" \
      -e "POSTGRES_DB=kong" \
      postgres:9.5
    ```

8. To make the license data easier to handle, export it as a shell variable.
Please note that **your license contents will differ**! Users with Bintray
accounts should visit [https://bintray.com/kong/&lt;YOUR_REPO_NAME&gt;/license#files](https://bintray.com/kong/<YOUR_REPO_NAME>/license#files)
to retrieve their license. Trial users should download their license from their
welcome email. Once you have your license, you can set it in an environment variable:

    ```sh
    export KONG_LICENSE_DATA='{"license":{"signature":"LS0tLS1CRUdJTiBQR1AgTUVTU0FHRS0tLS0tClZlcnNpb246IEdudVBHIHYyCgpvd0did012TXdDSFdzMTVuUWw3dHhLK01wOTJTR0tLWVc3UU16WTBTVTVNc2toSVREWk1OTFEzVExJek1MY3dTCjA0ek1UVk1OREEwc2pRM04wOHpNalZKVHpOTE1EWk9TVTFLTXpRMVRVNHpTRXMzTjA0d056VXdUTytKWUdNUTQKR05oWW1VQ21NWEJ4Q3NDc3lMQmorTVBmOFhyWmZkNkNqVnJidmkyLzZ6THhzcitBclZtcFZWdnN1K1NiKzFhbgozcjNCeUxCZzdZOVdFL2FYQXJ0NG5lcmVpa2tZS1ozMlNlbGQvMm5iYkRzcmdlWFQzek1BQUE9PQo9b1VnSgotLS0tLUVORCBQR1AgTUVTU0FHRS0tLS0tCg=","payload":{"customer":"Test Company Inc","license_creation_date":"2017-11-08","product_subscription":"Kong Enterprise","admin_seats":"5","support_plan":"None","license_expiration_date":"2017-11-10","license_key":"00141000017ODj3AAG_a1V41000004wT0OEAU"},"version":1}}'
    ```

9. Run Kong migrations:

    ```
    docker run --rm --link kong-ee-database:kong-ee-database \
      -e "KONG_DATABASE=postgres" -e "KONG_PG_HOST=kong-ee-database" \
      -e "KONG_CASSANDRA_CONTACT_POINTS=kong-ee-database" \
      -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" \
      kong-ee kong migrations up
    ```
    **Docker on Windows users:** Instead of the `KONG_LICENSE_DATA` environment 
    variable, use the [volume bind](https://docs.docker.com/engine/reference/commandline/run/#options) option. 
    For example, assuming you've saved your `license.json` file into `C:\temp`, 
    use `--volume /c/temp/license.json:/etc/kong/license.json` to specify the 
    license file.

10. Start Kong:

    ```
    docker run -d --name kong-ee --link kong-ee-database:kong-ee-database \
      -e "KONG_DATABASE=postgres" \
      -e "KONG_PG_HOST=kong-ee-database" \
      -e "KONG_CASSANDRA_CONTACT_POINTS=kong-ee-database" \
      -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
      -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
      -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
      -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
      -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
      -e "KONG_PORTAL=on" \
      -e "KONG_PORTAL_GUI_PROTOCOL=http" \
      -e "KONG_PORTAL_GUI_HOST=127.0.0.1:8003" \
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
    ```
    **Docker on Windows users:** Instead of the `KONG_LICENSE_DATA` environment 
    variable, use the [volume bind](https://docs.docker.com/engine/reference/commandline/run/#options) option. 
    For example, assuming you've saved your `license.json` file into `C:\temp`, 
    use `--volume /c/temp/license.json:/etc/kong/license.json` to specify the 
    license file.

11. Kong Enterprise should now be installed and running. Test 
it by visiting Kong Manager at [http://localhost:8002](http://localhost:8002)
(replace `localhost` with your server IP or hostname when running Kong on a 
remote system), or by visiting the Default Dev Portal at 
[http://127.0.0.1:8003/default](http://127.0.0.1:8003/default)

## Enable RBAC

[Role-Based Access Control (RBAC)](/enterprise/{{page.kong_version}}/rbac/overview)
allows you to create multiple profiles of Kong users—e.g., `super-admin`,
`admin`, `read-only`—and permit the resources to which they have access. 
To enable it:

1. Create an initial RBAC admin:

    ```
    curl -X POST http://localhost:8001/rbac/users/ -d name=admin -d user_token=12345
    curl -X POST http://localhost:8001/rbac/users/admin/roles -d roles=super-admin
    ```

2. Start a bash session on the container:

    ```
    docker exec -it kong-ee /bin/sh
    ```

3. Reload Kong with RBAC enabled:

    ```
    KONG_ENFORCE_RBAC=on kong reload
    ```

4. Confirm that your user token is working by passing the `Kong-Admin-Token`
header in requests:

    ```
    curl -X GET http://localhost:8001/status -H "Kong-Admin-Token: 12345"
    ```

    If you are able to access Kong without issues, you can add `KONG_ENFORCE_RBAC=on`
    to your initial container environment variables.

5. When RBAC is enabled, the Kong Manager requires the use of an 
authentication plugin. Follow the 
[Authenticating Kong Manager](/enterprise/{{page.kong_version}}/kong-manager/configuration/authentication) Guide to complete this set up.

## FAQs

The Admin API only listens on the local interface by default. This was done as a
security enhancement. Note that we are overriding that in the above example with
`KONG_ADMIN_LISTEN=0.0.0.0:8001` because Docker container networking benefits from
more open settings and enables Kong Manager and Dev Portal to talk with the Kong
Admin API.

Without a license properly referenced, you’ll get errors running migrations:

    $ docker run -ti --rm ... kong migrations up
    nginx: [alert] Error validating Kong license: license path environment variable not set

Also, without a license, you will get no output if you do a `docker run` in
"daemon mode"—the `-d` flag to `docker run`:

    
    $ docker run -d ... kong start
    26a995171e23e37f89a4263a10bb084120ab0dbed1aa11a71c888c8e0d74a0b6
    

When you check the container, it won’t be running. Doing a `docker logs` will
show you:


    $ docker logs <container name>
    nginx: [alert] Error validating Kong license: license path environment variable not set


As awareness, another error that can occur due to the vagaries of the interactions
between text editors and copy & paste changing straight quotes (" or ') into curly
ones (“ or ” or ’ or ‘) is:

​```
nginx: [alert] Error validating Kong license: could not decode license json
​```

Your license data must contain only straight quotes to be considered valid JSON.