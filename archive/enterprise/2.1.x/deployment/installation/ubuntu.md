---
title: Install Kong Enterprise on Ubuntu
---

## Introduction

This guide walks through downloading, installing, and starting **Kong Enterprise** on **Ubuntu**.

The configuration shown in this guide is intended as an example. Depending on your
environment, you may need to make modifications and take measures to properly conclude
the installation and configuration.

Kong supports both PostgreSQL 9.5+ and Cassandra 3.11.* as its datastore. This guide provides
steps to configure PostgreSQL. For assistance in setting up Cassandra, please contact your Kong Sales or Support representative.

### Deployment Options

The following instructions assume that you are deploying {{site.ee_product_name}} in [classic embedded mode](/enterprise/{{page.kong_version}}/deployment/deployment-options).

If you want to run {{site.ee_product_name}} in Hybrid mode, the instructions in this topic will walk you though setting up a Control Plane instance. Afterward, you will need to bring up additional Kong instances for the Data Planes, and perform further configuration steps. See [Hybrid Mode Setup](/enterprise/{{page.kong_version}}/deployment/hybrid-mode-setup) for details.

## Prerequisites

To complete this installation you will need:

{% include /md/enterprise/license.md license='prereq' %}
* A supported Ubuntu system with root-equivalent access.

## Step 1. Prepare to Install Kong Enterprise and Download the License File

### Download the Debian package

1. Choose your Ubuntu version:
    * [Xenial]({{ site.links.download }}/gateway-2.x-ubuntu-xenial/pool/all/k/kong-enterprise-edition/)
    * [Focal]({{ site.links.download }}/gateway-2.x-ubuntu-focal/pool/all/k/kong-enterprise-edition/)
    * [Bionic]({{ site.links.download }}/gateway-2.x-ubuntu-bionic/pool/all/k/kong-enterprise-edition/)
2. Select a {{site.base_gateway}} version from the list to download it.

    Versions are listed in chronological order.

    For example: `kong-enterprise-edition_{{page.kong_versions[8].version}}_all.deb`

6. Copy the `.deb` file to your home directory on the Ubuntu system. For example:

    ```bash
    $ scp kong-enterprise-edition_{{page.kong_versions[8].version}}_all.deb <ubuntu_user>@<server>:~
    ```


### Prepare your license

Securely copy the license file to your home directory on the Ubuntu system:

```bash
$ scp license.json <ubuntu_username>@<server>:~
```

## Step 2. Install Kong Enterprise

1. Update APT

    ```bash
    $ sudo apt-get update
    ```

2. Install Kong Enterprise

    ```bash
    $ sudo apt-get install /absolute/path/to/package.deb
    ```

    > Note: Your version may be different based on when you obtained the package

3. Copy the license file to the `/etc/kong` directory

    ```bash
    $ sudo cp license.json /etc/kong/license.json
    ```

4. Kong will look for a valid license in this location.

## Step 3. Set up PostgreSQL

PostgreSQL is available in all Ubuntu versions by default. However, Ubuntu
snapshots a specific version of PostgreSQL that is then supported throughout the
lifetime of that Ubuntu version. Other versions of PostgreSQL are available
through the PostgreSQL apt repository.

Kong supports versions 9.5 and higher. Ensure the distribution of PostgreSQL
for your version of Ubuntu is a supported version for Kong. For more
information about PostgreSQL on Ubuntu, see [https://www.postgresql.org/download/linux/ubuntu/](https://www.postgresql.org/download/linux/ubuntu/).

1. Install PostgreSQL. This command may not work on all versions of Ubuntu.

    ```bash
    $ sudo apt-get install postgresql postgresql-contrib
    ```

2. Switch to PostgreSQL user and launch PostgreSQL

    ```bash
    $ sudo -i -u postgres
    $ psql
    ```

3. Create a Kong database with a username and password.

    ```bash
    $ psql> CREATE USER kong; CREATE DATABASE kong OWNER kong; ALTER USER kong WITH password 'kong';
    ```

    > ⚠️ **Note**: Make sure the username and password for the Kong Database are
    > kept safe. This example uses a simple username and password for illustrative purposes only. Note the database name, username and password for later.

4. Exit from PostgreSQL and return to your terminal account.

    ```bash
    $ psql> \q
    $ exit
    ```

## Step 4. Modify Kong's Configuration File

1. Make a copy of Kong's default configuration file.

    ```bash
    $ sudo cp /etc/kong/kong.conf.default /etc/kong/kong.conf
    ```

2. Uncomment and update the PostgreSQL database properties in `/etc/kong/kong.conf` using your preferred text editor. Replace `pg_user`, `pg_password`, and `pg_database` with the values:

    ```
    pg_user = kong
    pg_password = kong
    pg_database = kong
    ```

## Step 5. Seed the Super Admin's Password and bootstrap Kong

Setting a password for the **Super Admin** before initial start-up is strongly recommended. This will permit the use of RBAC (Role Based Access Control) at a later time, if needed.

1. Create an environment variable with the desired **Super Admin** password and store the password in a safe place. Run migrations to prepare the Kong database:

    ```bash
    $ sudo KONG_PASSWORD=<password-only-you-know> /usr/local/bin/kong migrations bootstrap -c /etc/kong/kong.conf
    ```

2. Start Kong Enterprise:

    ```bash
    $ sudo /usr/local/bin/kong start -c /etc/kong/kong.conf
    ```

3. Verify Kong Enterprise is working:

    ```bash
    $ curl -i -X GET --url http://localhost:8001/services
    ```

4. You should receive a `HTTP/1.1 200 OK` message.

## Step 6. Finalize your Configuration and Verify Kong was Successfully installed:

### Enable and Configure Kong Manager

1. To access Kong Enterprise's Graphical User Interface, Kong Manager, update the `admin_gui_url` property in `/etc/kong/kong.conf` file the to the DNS or IP address of the system. For example:

    ```
    admin_gui_url = http://<DNSorIP>:8002
    ```

    This setting needs to resolve to a network path that will reach the host.

2. It is necessary to update the administration API setting to listen on the needed network interfaces on the host. A setting of `0.0.0.0:8001` will listen on port `8001` on all available network interfaces.

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

1. Enable Kong Enterprise's Developer Portal by updating `/etc/kong/kong.conf` to set the `portal` property to `on` and the `portal_gui_host` property to the DNS or IP address of the system. For example:

    ```
    portal = on
    portal_gui_host = <DNSorIP>:8003
    ```

2. Restart Kong for the setting to take effect:

    ```bash
    $ sudo /usr/local/bin/kong restart
    ```

3. The final step is to enable the Developer Portal. To do this, execute the following command, updating `DNSorIP` to reflect the IP or valid DNS for the system.

    ```bash
    $ curl -X PATCH http://<DNSorIP>:8001/workspaces/default --data "config.portal=true"
    ```

4. You can now access the Developer Portal on the default workspace with a URL like:

    ```
    http://<DNSorIP>:8003/default
    ```

## Troubleshooting

If you did not receive an `HTTP/1.1 200 OK` message or need assistance completing
your setup, reach out to your Kong Support contact or go to the
[Support Portal](https://support.konghq.com/support/s/).


## Next Steps

Check out Kong Enterprise's series of
[Getting Started](/enterprise/latest/getting-started) guides to get the most
out of Kong Enterprise.
