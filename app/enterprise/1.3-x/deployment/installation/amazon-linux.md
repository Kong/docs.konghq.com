---
title: Install Kong Enterprise on Amazon Linux 1
---

## Introduction

This guide walks through downloading, installing, and starting **Kong Enterprise** on **Amazon Linux 1**.

The configuration shown in this guide is intended as an example. Depending on your
environment, you may need to make modifications and take measures to properly conclude
the installation and configuration.

Kong supports both PostgreSQL 9.5+ and Cassandra 3.11.* as its datastore. This guide provides
steps to configure PostgreSQL. For assistance in setting up Cassandra, please contact your Sales or Support representative.

## Prerequisites

To complete this installation guide you will need:

* A supported Amazon Linux 1 system with root equivalent access.
{% include /md/enterprise/license.md license='prereq' %}

## Step 1. Prepare to Install Kong Enterprise and Download the License File

### Download RPM file

{% include /md/enterprise/install.md install='OS' %}

3. Copy the RPM file to your home directory on the Amazon Linux 1 system.

### Download your Kong Enterprise License

{% include /md/enterprise/license.md license='<1.3' %}

{% include /md/enterprise/license.md license='json-example' %}

2. Securely copy the license file to your home directory on the Amazon Linux system. You may use a command like:

    ```bash
    $ scp license.json <amazon username>@<server>:~
    ```

### Result

You should now have two files in your home directory on the target Amazon system:
- Either the Kong RPM or Kong Yum repo file.
- The license file `license.json`

## Step 2. Install Kong Enterprise

- Execute a command similar to the following, using the appropriate RPM file name you downloaded.

```bash
$ sudo yum install kong-enterprise-edition-1.3.0.1.aws.rpm
```
>Note: Your version may be different based on when you obtained the rpm

### Copy the License File

Copy the license file from your home directory to the `/etc/kong` directory:

```bash
$ sudo cp license.json /etc/kong/license.json
```

## Step 3. Setup PostgreSQL

1. Install PostgreSQL.

    Follow the instructions avaialble at https://www.postgresql.org/download/linux/redhat/ to install a supported version of PostgreSQL. Kong supports version 9.5 and higher. As an example, you can run a command set similar to:

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

    ```bash
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

## Step 4. Modify Kong's configuration file to work with PostgreSQL

1. Make a copy of Kong's default configuration file.

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

## Step 5. Seed the Super Admin password and bootstrap Kong

Setting a password for the **Super Admin** before initial start-up is strongly recommended. This will permit the use of RBAC (Role Based Access Control) at a later time, if needed.


1. Create an environment variable with the desired **Super Admin** password and store the password in a safe place. Run migrations to prepare the Kong database:

    ```bash
    $ sudo KONG_PASSWORD=<password-only-you-know> /usr/local/bin/kong migrations bootstrap -c /etc/kong/kong.conf
    ```

3. Start Kong Enterprise:

    ```bash
    $ sudo /usr/local/bin/kong start -c /etc/kong/kong.conf
    ```

4. Verify Kong Enterprise is working:

    ```bash
    $ curl -i -X GET --url http://localhost:8001/services
    ```

5. You should receive a `HTTP/1.1 200 OK` message.

## Step 6. Finalize Configuration and Verify Installation

### Enable and Configure Kong Manager

1. To access Kong Enterprise's Graphical User Interface, Kong Manager, update the `admin_gui_url` property in `/etc/kong/kong.conf` file to the DNS, or IP address, of the Amazon Linux system. For example:

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

### Enable the Developer Portal

1. Kong Enterprise's **Developer Portal** can be connected by setting the `portal` property to `on` and setting the `portal_gui_host` property to the EC2 instance's `IPv4` address

    ```
    portal = on
    portal_gui_host = <DNSorIP>:8003
    ```

2. Restart Kong for the setting to take effect:

    ```bash
    $ sudo /usr/local/bin/kong restart
    ```

3. The final step is to enable the Developer Portal. To do this, execute the following command, updating `DNSorIP` to reflect the IP or valid DNS for the Amazon Linux system.

    ```bash
    $ curl -X PATCH http://<DNSorIP>:8001/workspaces/default   --data "config.portal=true"
    ```

4. You can now access the Developer Portal on the default workspace with a URL like:

    ```
    http://<DNSorIP>:8003/default
    ```

## Troubleshooting

If you did not receive an `HTTP/1.1 200 OK` message, or need assistance completing
your setup, reach out to your Kong Support contact or go to the
[Support Portal](https://support.konghq.com/support/s/).

## Next Steps

Check out Kong Enterprise's series of
[Getting Started](/enterprise/latest/getting-started) guides to get the most
out of Kong Enterprise.
