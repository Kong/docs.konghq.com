---
title: Install Kong Enterprise on Amazon Linux 2
---

## Introduction

This guide walks through downloading, installing, and starting **Kong Enterprise** on **Amazon Linux 2**.

The configuration shown in this guide is intended as an example. Depending on your
environment, you may need to make modifications and take measures to properly conclude
the installation and configuration.

Kong supports both PostgreSQL 9.5+ and Cassandra 3.11.* as its datastore. This guide provides
steps to configure PostgreSQL. For assistance in setting up Cassandra, please contact your Sales or Support representative.

## Prerequisites

To complete this installation you will need:

* A supported Amazon Linux 2 system with root equivalent access.
{% include /md/enterprise/license.md license='prereq' %}

## Step 1. Prepare to Install Kong Enterprise and Download the License File

There are two options to install Kong Enterprise on Amazon Linux 2.

Log in to [Bintray](http://bintray.com). Your Kong Sales or Support contact will assign credentials to you.

### Option 1: Download RPM File

1. Go to: [https://bintray.com/kong/kong-enterprise-edition-aws](https://bintray.com/kong/kong-enterprise-edition-aws).
2. Select the `aws` folder. Kong Enterprise versions are listed in reverse chronological order.
3. Select the latest Kong version from the list.
4. From the Kong version detail page, select the **Files** tab and click the distribution folder.
5. Save the RPM file available. For example, `kong-enterprise-edition-1.3.0.1.aws.rpm`.
6. Copy the RPM file to your home directory on the Amazon Linux 2 system. You may use a command like:

    ```bash
    $ scp kong-enterprise-edition-1.3.0.1.aws.rpm <amazon user>@<server>:~
    ```
*Optional:* The following steps are for verifying the integrity of the package. They are not necessary to move on to [installation](#option-1-if-installing-using-a-downloaded-rpm-package).
7. Download Kong's official public key to ensure the integrity of the RPM package:

    ```bash
    $ curl -o kong.key https://bintray.com/user/downloadSubjectPublicKey?username=kong
    $ sudo rpm --import kong.key
    $ sudo rpm -K kong-enterprise-edition-1.3.0.1.aws.rpm
    ```

8. Verify you get an OK check. You should have an output similar to this:

    ```
    kong-enterprise-edition-1.3.0.1.el7.noarch.rpm: sha1 md5 OK
    ```

### Option 2: Download the Kong Repo File and Add to Yum Repo

1. Click this URL to download the Kong Enterprise RPM repo file: [https://bintray.com/kong/kong-enterprise-edition-aws/rpm](https://bintray.com/kong/kong-enterprise-edition-aws/rpm).

2. Edit the repo file using your preferred editor and alter the baseurl line as follows::

    ```
    baseurl=https://USERNAME:API_KEY@kong.bintray.com/kong-enterprise-edition-aws
    ```

    Replace `USERNAME` with your Bintray account user name.
    Replace `API_KEY` with your Bintray API key. You can find your key on your Bintray profile page at [https://bintray.com/profile/edit](https://bintray.com/profile/edit) and selecting the API Key menu item.

    The result should look something like this:

    ```
    baseurl=https://john-company:12234e314356291a2b11058591bba195830@kong.bintray.com/kong-enterprise-edition-aws
    ```

3. Securely copy the changed repo file to your home directory on the Amazon Linux 2 system. You may use a command such as:

    ```bash
    $ scp bintray--kong-kong-enterprise-edition-aws.repo <amazon user>@<server>:~
    ```

### Download your Kong Enterprise License

1. Download your license file from your account files in Bintray:

    ```
    https://bintray.com/kong/<YOUR_REPO_NAME>/license#files`
    ```

2. Securely copy the license file to your home directory on the Amazon Linux system. You may use a command like:

    ```bash
    $ scp license.json <amazon username>@<server>:~
    ```

### Result

You should now have two files in your home directory on the target Amazon system:

- Either the Kong RPM or Kong Yum repo file.
- The license file `license.json`

## Step 2. Install Kong Enterprise

### Option 1: If installing using a downloaded RPM package

Execute a command similar to the following, using the appropriate RPM file name you downloaded.

```bash
$ sudo yum install kong-enterprise-edition-1.3.0.1.aws.rpm
```

### Option 2: If installing using the Yum repository

1. Move the repo file in your home directory to the /etc/yum.repos.d/ directory.

    ```bash
    $ sudo mv bintray--kong-kong-enterprise-edition-aws.repo /etc/yum.repos.d/
    ```

2. Begin the installation using the Yum repository:

    ```bash
    $ sudo yum update -y
    $ sudo yum install kong-enterprise-edition -y
    ```    

### Copy the License File

Copy the license file from your home directory to the `/etc/kong` directory:

```bash
$ sudo cp license.json /etc/kong/license.json
```

## Step 3. Setup PostgreSQL

1. Install PostgreSQL.

    Follow the instructions avaialble at [https://www.postgresql.org/download/linux/redhat/](https://www.postgresql.org/download/linux/redhat/) to install a supported version of PostgreSQL. Kong supports version 9.5 and higher. As an example, you can run a command set similar to:

    ```bash
    $ sudo amazon-linux-extras install postgresql9.6
    $ sudo yum install postgresql postgresql-server
    ```

2. Initialize the PostgreSQL database and enable automatic start.

    ```bash
    $ sudo /usr/bin/postgresql-setup --initdb
    $ sudo systemctl enable postgresql.service
    $ sudo systemctl start postgresql
    ```

3. Switch to PostgreSQL user and launch PostgreSQL.

    ```bash
    $ sudo -i -u postgres
    $ psql
    ```

4. Create a Kong database with a username and password.

    ```bash
    $ psql> CREATE USER kong; CREATE DATABASE kong OWNER kong; ALTER USER kong WITH password 'kong';
    ```
> ⚠️**Note**: Make sure the username and password for the Kong Database are
> kept safe. This example uses a simple username and password for illustration purposes only. Note the database name, username and password for later.

5. Exit from PostgreSQL and return to your terminal account.

    ```bash
    $ psql> \q
    $ exit
    ```

6. Edit the the PostgreSQL configuration file `/var/lib/pgsql/data/pg_hba.conf` using your preferred editor.

    Under IPv4 local connections replace `ident` with `md5`:

    | Protocol   	| Type 	| Database 	| User 	| Address      	| Method 	|
    |------------	|------	|----------	|------	|--------------	|--------	|
    | IPv4 local 	| host 	| all      	| all  	| 127.0.0.1/32 	| md5    	|
    | IPv6 local 	| host 	| all      	| all  	| 1/128        	| ident  	|

    PostgreSQL uses `ident` authentication by default. To allow the `kong` user to communicate with the database locally, change the authentication method to `md5` by modifying the PostgreSQL configuration file.

7. Restart PostgreSQL.

    ```bash
    $ sudo systemctl restart postgresql
    ```

## Step 4. Modify Kong's configuration file to work with PostgreSQL

1. Make a copy of Kong's default configuration file.

    ```bash
    $ sudo cp /etc/kong/kong.conf.default /etc/kong/kong.conf
    ```

2. Uncomment and update the PostgreSQL database properties in `/etc/kong/kong.conf` using your preferred text editor. Replace `pg_user`, `pg_password` and `pg_database` with the correct values.

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

### Enable the Kong Developer Portal

1. Kong Enterprise's Developer Portal can be enabled by setting the `portal` property to `on` and setting the `portal_gui_host` property to the DNS, or IP address, of the Amazon Linux system. For example:

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

If you did not receive an `HTTP/1.1 200 OK` message or need assistance completing
your setup, reach out to your Kong Support contact or go to the
[Support Portal](https://support.konghq.com/support/s/).

## Next Steps

Check out Kong Enterprise's series of
[Getting Started](/enterprise/latest/getting-started) guides to get the most
out of Kong Enterprise.
