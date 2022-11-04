---
title: Install Kong Gateway on Amazon Linux 1
---

## Introduction

This guide walks through downloading, installing, and starting **{{site.ee_product_name}}** on **Amazon Linux 1**.

The configuration shown in this guide is intended as an example. Depending on your
environment, you may need to make modifications and take measures to properly conclude
the installation and configuration.

{{site.base_gateway}} supports both PostgreSQL 9.5+ and Cassandra 3.11.* as its datastore. This guide provides
steps to configure PostgreSQL. For assistance in setting up Cassandra, please contact your Sales or Support representative.

This software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense).

### Deployment options

{% include /md/{{page.kong_version}}/deployment-options.md kong_version=page.kong_version %}

## Prerequisites

To complete this installation guide you will need a supported Amazon Linux 1
system with root-equivalent access.

## Step 1. Prepare to install Kong Gateway {#step-1}

{% navtabs %}
{% navtab Download RPM file %}

1. Go to: [{{ site.links.download }}/gateway-2.x-amazonlinux-1/Packages/k/]({{ site.links.download }}/gateway-2.x-amazonlinux-1/Packages/k/).
2. Click the RPM file to download it.
    For example: `kong-enterprise-edition-{{page.kong_versions[10].version}}.aws.amd64.rpm`.
3. Copy the RPM file to your home directory on the Amazon Linux 1 system:

    ```bash
    $ scp kong-enterprise-edition-{{page.kong_versions[10].version}}.aws.amd64.rpm <amazon user>@<server>:~
    ```

{% endnavtab %}
{% navtab Download Kong repo file and add to Yum repo %}

1. Download and save the {{site.base_gateway}} RPM repo file as `config.repo`:

    [{{ site.links.download }}/gateway-2.x-amazonlinux-1/config.repo]({{ site.links.download }}/gateway-2.x-amazonlinux-1/config.repo)

2. Securely copy the repo file to your home directory on the Amazon
Linux 1 system. For example:

    ```bash
    $ scp config.repo <amazon user>@<server>:~
    ```

{% endnavtab %}
{% endnavtabs %}

<!-- ### (Optional) Verify the package integrity

1. Download Kong's official public key to ensure the integrity of the RPM package:

    ```bash
    $ curl -o kong.key {{ site.links.download }}/user/downloadSubjectPublicKey?username=kong
    $ sudo rpm --import kong.key
    $ sudo rpm -K kong-enterprise-edition-{{page.kong_versions[10].version}}.amzn2.noarch.rpm
    ```

2. Verify you get an OK check. Output should be similar to this:

      ```
      kong-enterprise-edition-{{page.kong_versions[10].version}}.amzn2.noarch.rpm: sha1 md5 OK
      ``` -->

## Step 2. Install Kong Gateway

{% include /md/enterprise/install-2.x.md %}

## Step 3. Set up PostgreSQL

1. Install PostgreSQL.

    Follow the instructions avaialble at [https://www.postgresql.org/download/linux/redhat/](https://www.postgresql.org/download/linux/redhat/) to install a supported version of PostgreSQL. Kong supports version 9.5 and higher. As an example, you can run a command set similar to:

    ```bash
    $ sudo yum install postgresql96 postgresql96-server
    ```

2. Initialize the PostgreSQL database and enable automatic start.

    ```bash
    $ sudo service postgresql96 initdb
    $ sudo service postgresql96 start
    ```

3. Switch to PostgreSQL user and launch PostgreSQL.

    ```bash
    $ sudo -i -u postgres
    $ psql
    ```

4. Create a Kong database with a username and password.

    > ⚠️**Note**: Make sure the username and password for the Kong Database are
    > kept safe. This example uses a simple username and password for illustration purposes only. Note the database name, username and password for later.

    ```sql
    $ psql> CREATE USER kong; CREATE DATABASE kong OWNER kong; ALTER USER kong WITH password 'kong';
    ```

5. Exit from PostgreSQL and return to your terminal account.

    ```bash
    $ psql> \q
    $ exit
    ```

6. Edit the the PostgreSQL configuration file `/var/lib/pgsql96/data/pg_hba.conf` using your preferred editor.

    Under IPv4 local connections replace `ident` with `md5`:

    | Protocol   	| Type 	| Database 	| User 	| Address      	| Method 	|
    |------------	|------	|----------	|------	|--------------	|--------	|
    | IPv4 local 	| host 	| all      	| all  	| 127.0.0.1/32 	| md5    	|
    | IPv6 local 	| host 	| all      	| all  	| 1/128        	| ident  	|

    PostgreSQL uses `ident` authentication by default. To allow the `kong` user to communicate with the database locally, change the authentication method to `md5` by modifying the PostgreSQL configuration file.

7. Save and exit the file and restart PostgreSQL.

    ```bash
    $ sudo service postgresql96 restart
    ```

## Step 4. Modify Kong Gateway's configuration file to work with PostgreSQL

1. Make a copy of {{site.base_gateway}}'s default configuration file.

    ```bash
    $ sudo cp /etc/kong/kong.conf.default /etc/kong/kong.conf
    ```

2. Uncomment and update the PostgreSQL database properties in `/etc/kong/kong.conf` using your preferred text editor. Replace pg_user, pg_password and pg_database with the values:

    ```
    pg_user = kong
    pg_password = kong
    pg_database = kong
    ```

    > Note: If you used different values for the user and database name, use those values for the user and database name.

## Step 5. Seed the Super Admin password and bootstrap Kong Gateway

{% include /md/{{page.kong_version}}/ee-kong-user.md kong_version=page.kong_version %}

Setting a password for the **Super Admin** before initial start-up is strongly recommended. This will permit the use of RBAC (Role Based Access Control) at a later time, if needed.


1. Create an environment variable with the desired **Super Admin** password and store the password in a safe place. Run migrations to prepare the Kong database:

    ```bash
    $ sudo KONG_PASSWORD=<password-only-you-know> /usr/local/bin/kong migrations bootstrap -c /etc/kong/kong.conf
    ```

3. Start {{site.base_gateway}}:

    ```bash
    $ sudo /usr/local/bin/kong start -c /etc/kong/kong.conf
    ```

4. Verify {{site.base_gateway}} is working:

    ```bash
    $ curl -i -X GET --url http://localhost:8001/services
    ```

5. You should receive a `HTTP/1.1 200 OK` message.

## Step 6. Finalize configuration and verify installation

### Enable and configure Kong Manager

1. To access the gateway's Graphical User Interface, Kong Manager, update the `admin_gui_url` property in `/etc/kong/kong.conf` file to the DNS, or IP address, of the Amazon Linux system. For example:

    ```
    admin_gui_url = http://<DNSorIP>:8002
    ```

    This setting needs to resolve to a network path that will reach the Amazon Linux host.

2. It is necessary to update the administration API setting to listen on the needed network interfaces on the Amazon Linux host. A setting of `0.0.0.0:8001` will listen on port `8001` on all available network interfaces.

    ```
    admin_listen = 0.0.0.0:8001, 0.0.0.0:8444 ssl
    ```

3. You may also list network interfaces separately as in this example:

    ```
    admin_listen = 0.0.0.0:8001, 0.0.0.0:8444 ssl, 127.0.0.1:8001, 127.0.0.1:8444 ssl
    ```

4. Restart Kong for the setting to take effect:

    ```bash
    $ sudo /usr/local/bin/kong restart
    ```

5. You may now access Kong Manager on port `8002`.

### (Optional) Enable the Dev Portal

<div class="alert alert-ee">
<img class="no-image-expand" src="/assets/images/icons/documentation/icn-enterprise-blue.svg" alt="Enterprise" />
This feature is only available with a
<a href="/enterprise/{{page.kong_version}}/deployment/licensing">
{{site.konnect_product_name}} Enterprise subscription</a>.
</div>

1. [Deploy a license](/enterprise/{{page.kong_version}}/deployment/licenses/deploy-license).

2. Enable the Dev Portal by setting the `portal` property to `on` and
the `portal_gui_host` property to the EC2 instance's `IPv4` address:

    ```
    portal = on
    portal_gui_host = <DNSorIP>:8003
    ```

3. Restart {{site.base_gateway}} for the setting to take effect:

    ```bash
    $ sudo /usr/local/bin/kong restart
    ```

4. Enable the Dev Portal for a workspace. Execute the following command,
updating `DNSorIP` to reflect the IP or valid DNS for the Amazon Linux system:

    ```bash
    $ curl -X PATCH http://<DNSorIP>:8001/workspaces/default \
      --data "config.portal=true"
    ```

5. Access the Dev Portal for the default workspace using the following URL,
substituting your own DNS or IP:

    ```
    http://<DNSorIP>:8003/default
    ```

## Troubleshooting

If you did not receive an `HTTP/1.1 200 OK` message, or need assistance completing
your setup, reach out to your Kong Support contact or go to the
[Support Portal](https://support.konghq.com/support/s/).

## Next Steps

Check out {{site.base_gateway}}'s series of
[Getting Started](/getting-started-guide/{{ page.kong_version}}/overview/) guides to get the most
out of {{site.base_gateway}}.

If you have an Enterprise subscription, add the license using the
[`/licenses` Admin API endpoint](/enterprise/{{page.kong_version}}/deployment/licenses/deploy-license).
