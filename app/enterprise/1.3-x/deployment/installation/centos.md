---
title: How to Install Kong Enterprise on CentOS
---

## Introduction

This guide walks through downloading, installing, and starting Kong Enterprise
using CentOS and PostgreSQL. The configuration shown in this guide is
intended only as an example.  Depending on your environment, you may need to
make some modifications, and take measures to properly conclude the
installation and configuration.


## Prerequisites

To complete this guide you will need:

* A supported CentOS system with root equivalent access.
* A valid *Bintray* account. You will need your *username*, account *password* and account *API KEY*.
    * Example:
        * Bintray Access key = `john-company`
        * Bintray username = `john-company@kong`
        * Bintray password = `12345678`
        * Bintray API KEY = `12234e314356291a2b11058591bba195830`
* A valid **Kong Enterprise License** JSON file, this can be found in your Bintray account. See [Accessing Your License](/enterprise/latest/deployment/access-license)

## Step 1. Prepare to install Kong Enterprise and your download your license file

1a. There are two options to install Kong Enterprise on CentOS.  Both will require a login to **Bintray**.

   Log in to [Bintray](http://bintray.com) to download the latest Kong 
   Enterprise RPM for CentOS. Your **Sales** or **Support** contact will
   email this credential to you.

1b. Option 1. Download RPM Package from **Bintray**

   In the **Bintray** UI:
   
    - go to: https://bintray.com/beta/#/kong/kong-enterprise-edition-rpm/centos?tab=overview
    - Kong Enterprise versions are listed in reverse chronological order.
    - Select the Kong version you wish to install from the list.
    - From the Kong version detail page, select the 'Files' tab
    - Select the CentOS version appropriate for your environment.  E.g. centos -> 7
    - Save the rpm file available: E.g. kong-enterprise-edition-1.3.0.1.el7.noarch.rpm
    - Kong's official Key ID is 2cac36c51d5f3726. Verify it by querying the RPM package:
    
    ```
    $ rpm -qpi kong-enterprise-edition-1.3.el7.noarch.rpm | grep Signature
    ```
    >Note: Update the command to examin the file you downloaded.
  
    - Verify the Signature line contains the correct Key ID: 2cac36c51d5f3726.
    - Download Kong's official public key to ensure the RPM package's integrity:

    ```
    $ curl -o kong.key https://bintray.com/user/downloadSubjectPublicKey?username=kong
    $ rpm --import kong.key
    $ rpm -K kong-enterprise-edition-1.3.el7.noarch.rpm
    ```
    
    - Verify you get an OK check.  You should have an output similar to this:
    kong-enterprise-edition-1.3.0.1.el7.noarch.rpm: rsa sha1 (md5) pgp md5 OK
    
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

    The result should look something like this:
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

   You now should have two files in your home directory on the target CentOS system.
   - Either the Kong RPM or Kong **YUM** repo file.
   - The license file 'license.json'

## Step 2. Install Kong Enterprise

2a. Option 1.  If installing via a downloaded rpm package

    - Go to your home directory on the target CentOS system
    - Execute a command similar to the following, using the appropriate rpm file name.
    
    ```
    $ sudo yum install kong-enterprise-edition-1.3.el7.noarch.rpm
    ```

2b. Option 2. Install Kong Enterprise via the **YUM** repository
   
   Move the repo file in your home directory to the /etc/yum.repos.d/ directory.

   ```
   $ sudo mv bintray--kong-kong-enterprise-edition-rpm.repo /etc/yum.repos.d/
   ```
    
   Then begin the installation via the **YUM** repository:
    
   ```
   $ sudo yum install kong-enterprise-edition
   ```    

2c. Copy the license file from your home directory to the `/etc/kong` directory

    ```
    $ sudo cp kong-se-license.json /etc/kong/license.json
    ```

## Step 3. Setup PostgreSQL

1. Install PostgreSQL

    ```
    $ sudo yum install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

    $ sudo yum install postgresql95 postgresql95-server
    ```

2. Initialize the PostgreSQL Database

    ```
    $ sudo /usr/pgsql-9.5/bin/postgresql95-setup initdb
    ```

3. Start PostgreSQL and Enable Automatic Start

    ```
    $ sudo systemctl enable postgresql-9.5
    $ sudo systemctl start postgresql-9.5
    ```


## Step 4. Create a Kong database and user

1. Switch to PostgreSQL user

    ```
    $ sudo -i -u postgres
    ```

2. Launch PostgreSQL

    ```
    $ psql
    ```

3. Run the following command to:

    -- Create a Kong user and database

    --  Make Kong the owner of the database

    --  Set the password of the Kong user to 'kong'

    ```
    $ CREATE USER kong; CREATE DATABASE kong OWNER kong; ALTER USER kong WITH password 'kong';
    ```

    >⚠️**Note**: Make sure the username and password for the Kong Database are
    >kept safe. We have used a simple example for illustration purposes only.

4. Exit from PostgreSQL

    ```
    $ \q
    ```

5. Return to terminal

    ```
    $ exit
    ```

6. Run the following command to access the PostgreSQL configuration file.

    ```
    $ sudo vi /var/lib/pgsql/9.5/data/pg_hba.conf
    ```

7. Under IPv4 local connections replace `ident` with `md5`

    | TYPE | DATABASE | USER | ADDRESS      | METHOD |
    | # IPv4 local connections:                      |
    | host | all      | all  | 127.0.0.1/32 | **md5**|
    | # IPv6 local connections:                      |
    | host | all      | all  | ::1/128      | ident  |

8. Restart PostgreSQL

    ```
    $ sudo systemctl restart postgresql-9.5
    ```


## Step 5. Modify Kong's configuration file

To use the newly provisioned PostgreSQL database, Kong's configuration file
must be modified to accept the correct PostgreSQL user and password.

1. Make a copy of the default configuration file

    ```
    $ cp /etc/kong/kong.conf.default /etc/kong/kong.conf
    ```

2. Uncomment and update the PostgreSQL database properties inside the Kong conf:

    ```
    $ sudo vi etc/kong/kong.conf
    ```
    ```
    pg_user = kong
    pg_password = kong
    pg_database = kong
    ```


## Step 6. Seed the Super Admin _(optional)_

For the added security of Role-Based Access Control (RBAC), it is best to seed 
the **Super Admin** before initial start-up.

Create an environment variable with the desired **Super Admin** password:


    $ export KONG_PASSWORD=<password-only-you-know>


This will be used during migrations to seed the initial **Super Admin** 
password within Kong.


## Step 7. Start Kong

1. Run migrations to prepare the Kong database

    ```
    $ kong migrations bootstrap -c /etc/kong/kong.conf
    ```

2. Start Kong

    ```
    $ sudo /usr/local/bin/kong start -c /etc/kong/kong.conf
    ```

3. Verify Kong is working

    ```
    curl -i -X GET --url http://localhost:8001/services
    ```
    
    You should receive an HTTP/1.1 200 OK message.

## Troubleshooting

If you did not receive an HTTP/1.1 200 OK message, or need assistance completing
setup reach out to your **Support contact** or head over to the
[Support Portal](https://support.konghq.com/support/s/).


## Next Steps

Work through Kong Enterprise's series of 
[Getting Started](/enterprise/latest/getting-started) guides to get the most
out of Kong Enterprise.
