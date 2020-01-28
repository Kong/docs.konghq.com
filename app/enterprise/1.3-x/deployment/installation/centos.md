---
title: How to Install Kong Enterprise on CentOS
---

## Introduction

This guide walks through downloading, installing, and starting **Kong Enterprise** on **CentOS**.

The configuration shown in this guide is intended only as an example. Depending on your
environment, you may need to make modifications, and take measures to properly conclude
the installation and configuration.

Kong supports both PostgreSQL 9.5+ and Cassandra 3.11.* as its datastore.  In this guide, we
show steps to configure PostgreSQL.

Due to the nature of setting up a Kong cluster with Cassandra, this documentation only covers Postgres.
For assistance in setting up Cassandra, please contact your Sales or Support representative.

## Prerequisites

To complete this guide you will need:

* A valid *Bintray* account. You will need your *username*, account *password* and account *API KEY*.
    * Example:
        * Bintray Access key = `john-company`
        * Bintray username = `john-company@kong`
        * Bintray password = `12345678`
        * Bintray API KEY = `12234e314356291a2b11058591bba195830`
            *Can be obtained by visiting https://bintray.com/profile/edit and selecting "API Key"
* A supported CentOS system with root equivalent access.
* A valid **Kong Enterprise License** JSON file, this can be found in your Bintray account. See [Accessing Your License](/enterprise/latest/deployment/access-license)

## Step 1. Prepare to install Kong Enterprise and your download your license file

1a. There are two options to install Kong Enterprise on CentOS.  Both will require a login to **Bintray**.

   Log in to [Bintray](http://bintray.com). Your **Sales** or **Support** contact will assign credentials to you.

1b. Option 1. Download RPM file

   In the **Bintray** UI:
   
   - go to: https://bintray.com/kong/kong-enterprise-edition-rpm
   - Select the CentOS folder.
   - Kong Enterprise versions are listed in reverse chronological order.
   - Select the Kong version you wish to install from the list.
   - From the Kong version detail page, select the 'Files' tab.
   - Select the CentOS version appropriate for your environment.  E.g. centos -> 7.
   - Save the rpm file available: E.g. kong-enterprise-edition-1.3.0.1.el7.noarch.rpm
   - Kong's official Key ID is 2cac36c51d5f3726. Verify it by querying the RPM package:
   
   ```
   $ rpm -qpi kong-enterprise-edition-1.3.el7.noarch.rpm | grep Signature
   ```
   
   - Verify the Signature line contains the correct Key ID: 2cac36c51d5f3726.
   - Download Kong's official public key to ensure the RPM package's integrity:

   ```
   $ curl -o kong.key https://bintray.com/user/downloadSubjectPublicKey?username=kong
   $ rpm --import kong.key
   $ rpm -K kong-enterprise-edition-1.3.el7.noarch.rpm
   ```
    
   - Verify you get an OK check.  You should have an output similar to this:
 
   ```
   kong-enterprise-edition-1.3.0.1.el7.noarch.rpm: rsa sha1 (md5) pgp md5 OK
   ```  
   
   - Copy the rpm file to your home directory on the CentOS system, you may use a command like:

   ```
   $ scp kong-enterprise-edition-1.3.0.1.el7.noarch.rpm <centos user>@<server>:~
   ```

1c. Option 2. Download the Kong repo file and add it to your **YUM** repository

   In the **Bintray** UI:
   
   - Save the repo file (bintray--kong-kong-enterprise-edition-rpm.repo) available from this URL: https://bintray.com/kong/kong-enterprise-edition-rpm/rpm to your local file system.
   - Edit the repo file using your preferred editor and alter the baseurl line as follows
    
   ```
   baseurl=https://USERNAME:API_KEY@kong.bintray.com/kong-enterprise-edition-rpm/centos/RELEASEVER
   ```
   - Replace USERNAME with your Bintray account user name.
   - Replace API_KEY with your Bintray API key.  You may find your key on your Bintray profile page a at https://bintray.com/profile/edit and selecting the API Key menu item.
    - Replace RELEASEVER with the major CentOS version number on your target system.  For example, for version 7.7.1908, the appropriate RELEASEVER replacement is 7.

   - The result should look something like this:
   ```
   baseurl=https://john-company:12234e314356291a2b11058591bba195830@kong.bintray.com/kong-enterprise-edition-rpm/centos/7
   ```
    
   - Securely copy the changed repo file to your home directory on the CentOS system

   ```
   $ scp bintray--kong-kong-enterprise-edition-rpm.repo <centos user>@<server>:~
   ```
    
1d. Download your Kong Enterprise license
   
   - Download your license file from your account files in Bintray:
   `https://bintray.com/kong/<YOUR_REPO_NAME>/license#files`

   - Securely copy the license file to your home directory on the CentOS system

   ```
   $ scp license.json <centos username>@<server>:~
   ```

1e. Result

   You now should have two files in your home directory on the target CentOS system.
   - Either the Kong RPM or Kong **YUM** repo file.
   - The license file 'license.json'

## Step 2. Install Kong Enterprise

2a. Option 1.  If installing via a downloaded rpm package
 
   - Install EPEL (Extra Packages for Enterprise Linux), if not already installed
   
   ```
   $ sudo yum install epel-release
   ```
   
   - Execute a command similar to the following, using the appropriate rpm file name you downloaded
   
   ```
   $ sudo yum install kong-enterprise-edition-1.3.el7.noarch.rpm
   ```

2b. Option 2. If installing via the **YUM** repository
   
   - Move the repo file in your home directory to the /etc/yum.repos.d/ directory.

   ```
   $ sudo mv bintray--kong-kong-enterprise-edition-rpm.repo /etc/yum.repos.d/
   ```
    
   - Then begin the installation via the **YUM** repository:
    
   ```
   $ sudo yum update - y
   $ sudo yum install kong-enterprise-edition
   ```    

2c. Copy the license file from your home directory to the `/etc/kong` directory

    ```
    $ sudo cp kong-se-license.json /etc/kong/license.json
    ```

## Step 3. Setup PostgreSQL

3a. Install PostgreSQL

   Follow the instructions avaialble at: https://www.postgresql.org/download/linux/redhat/ to install a supported version of PostgreSQL.  Kong support version 9.5 and higher.  As an example, you may run a command set similat to:

    ```
    $ sudo yum install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
    $ sudo yum install postgresql95
    $ sudo yum install postgresql95-server
    ```
   You now have installed the PostgreSQL client and server packages.

3b. Initialize the PostgreSQL Database and enable Automatic Start

    ```
    $ sudo /usr/pgsql-9.5/bin/postgresql95-setup initdb
    $ sudo systemctl enable postgresql-9.5
    $ sudo systemctl start postgresql-9.5
    ```

3c. Switch to PostgreSQL user and launch PostgreSQL

    ```
    $ sudo -i -u postgres
    $ psql
    ```

3d. Create a kong database with a username and password

    >⚠️**Note**: Make sure the username and password for the Kong Database are
    >kept safe. We have used a simple example for illustration purposes only.

    -- Create a Kong user and database

    --  Make Kong the owner of the database

    --  Set the password of the Kong user to 'kong'

    ```
    $ psql> CREATE USER kong; CREATE DATABASE kong OWNER kong; ALTER USER kong WITH password 'kong';
    ```

3e. Exit from PostgreSQL and return to your terminal account

    ```
    $ psql> \q
    $ exit
    ```

3f. Edit the the PostgreSQL configuration file using your prefered editor.

   The file location is:
    ```
    /var/lib/pgsql/9.5/data/pg_hba.conf
    ```

Under IPv4 local connections replace `ident` with `md5`

    | TYPE | DATABASE | USER | ADDRESS      | METHOD |
    | # IPv4 local connections:                      |
    | host | all      | all  | 127.0.0.1/32 | **md5**|
    | # IPv6 local connections:                      |
    | host | all      | all  | ::1/128      | ident  |

Postgres uses `ident` authentication by default, to allow the `kong` user to communicate with the database locally we must change the authentication method to `md5` by modifying the Postgres configuration file. 

3g. Restart PostgreSQL

    ```
    $ sudo systemctl restart postgresql-9.5
    ```

## Step 4. Modify Kong's configuration file to work with PostgreSQL

1. Make a copy of Kong's default configuration file

    ```
    $ sudo cp /etc/kong/kong.conf.default /etc/kong/kong.conf
    ```

2. Uncomment and update the PostgreSQL database properties in `/etc/kong/kong.conf` using your preferred text editor.

    ```
    pg_user = kong
    pg_password = kong
    pg_database = kong
    ```

## Step 5. Seed the Super Admin password and boostrap Kong

Setting a password for the **Super Admin** before initial start-up is strongly recommended.  This will permit the use of RBAC(Role Based Access Control) at a later time, if needed.

1. Create an environment variable with the desired **Super Admin** password:

    $ export KONG_PASSWORD=<password-only-you-know>

2. Run migrations to prepare the Kong database

    ```
    $ kong migrations bootstrap -c /etc/kong/kong.conf
    ```

3. Start Kong

    ```
    $ sudo /usr/local/bin/kong start -c /etc/kong/kong.conf
    ```

4. Verify Kong is working

    ```
    curl -i -X GET --url http://localhost:8001/services
    ```
    
    You should receive an HTTP/1.1 200 OK message.
    
## Step 6. Finalize your configuration - enable Kong Manager and Developer Portal

### Enable and Configure Kong Manager

  To access Kong Enterprise's Graphical User Interface, **Kong Manager**, update the `admin_gui_url` property in `/etc/kong/kong.conf` file the to the DNS, or IP address, of the CentOS system.  For example:

  ```
  admin_gui_url = http://DNSorIP:8002
  ```
  
  This setting needs to resolve to a network path that will reach the CentOS host.
  
  It is necessary to update the administration API setting to listen on the needed network interfaces on the CentOS host.  A setting of 0.0.0.0:8001 will listen on port 8001 on all available network interfaces.
  
  ```
  admin_listen = 0.0.0.0:8001, 0.0.0.1:8444 ssl
  ```
  
  You may also list network interfaces separatley as in this example:
  
  ```
  admin_listen = 0.0.0.0:8001, 0.0.0.1:8444 ssl, 127.0.0.1:8001, 127.0.0.1:8444 ssl
  ```
  
  Restart Kong for the setting to take effect; note that the default port is **8002**:

  ```
  $ sudo /usr/local/bin/kong restart
  ```
  
  You may now access Kong Manager via the URL specified.

### Enable the Dev Portal

  Kong Enterprise's **Developer Portal** can be enabled by setting the `portal` property to `on` and setting the `portal_gui_host` property to the DNS, or IP address, of the CentOS system.  For example:

  ```
  portal = on
  portal_gui_host = http://DNSorIP:8003
  ```

  Restart Kong for the setting to take effect; note that the default port is **8003**:

  ```
  $ sudo /usr/local/bin/kong restart
  ```
  
  You may now access the Developer Portal via the URL specified.


## Troubleshooting

If you did not receive an HTTP/1.1 200 OK message, or need assistance completing
setup reach out to your **Support contact** or head over to the
[Support Portal](https://support.konghq.com/support/s/).


## Next Steps

Work through Kong Enterprise's series of 
[Getting Started](/enterprise/latest/getting-started) guides to get the most
out of Kong Enterprise.
