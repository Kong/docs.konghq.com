---
title: How to Install Kong Enterprise on CentOS
---

## Introduction

This guide walks through downloading, installing, and starting Kong Enterprise
using CentOS and PostgreSQL 9.5. The configuration shown in this guide is
intended only as an example -- you will want to modify and take additional
measures to secure your Kong Enterprise system before moving to a production
environment.


## Prerequisites

To complete this guide you will need:

* A CentOS 6 or 7 system with root equivalent access.
* The ability to SSH to the system.
* A valid *Bintray* account. You will need your *username*, account *password* and account *API KEY*.
    * Example:
        * Bintray Access key = `john-company`
        * Bintray username = `john-company@kong`
        * Bintray password = `12345678`
        * Bintray API KEY = `12234e314356291a2b11058591bba195830`
* A valid **Kong Enterprise License** JSON file, this can be found in your Bintray account. See [Accessing Your License](/enterprise/latest/deployment/access-license)

## Step 1. Download Kong Enterprise

1. Option 1. Download RPM Package via **Bintray**

    Log in to [Bintray](http://bintray.com) to download the latest Kong 
    Enterprise RPM for CentOS. Your **Sales** or **Support** contact will
    email this credential to you.
    
    Once logged in:
    - go to: https://bintray.com/beta/#/kong/kong-enterprise-edition-rpm/centos?tab=overview
    - The available Kong Enterprise versions are listed in reverse chronological order.
    - Select the Kong version you wish to install from the list.
    - From the Kong version detail page, select the files tab
    - Select the centos version appropriate for your environment.  E.g. centos -> 7
    - Save the rpm available: E.g. kong-enterprise-edition-1.3.0.1.el7.noarch.rpm

    Securely copy the rpm file to your home directory on the CentOS system

    ```
    $ scp kong-enterprise-edition-1.3.0.1.el7.noarch.rpm <centos user>@<server>:~
    ```

2. Option 2. Download via **YUM**

    Log in to [Bintray](http://bintray.com) to download the latest Kong 
    Enterprise RPM for CentOS. Your **Sales** or **Support** contact will
    email this credential to you.

    Once logged in, save the repo file (bintray--kong-kong-enterprise-edition-rpm.repo) available from this URL: https://bintray.com/kong/kong-enterprise-edition-rpm/rpm to your local file system.

    Edit the repo file using your preferred editor and alter the baseurl line as follows
    
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
    
    Securely copy the changed repo file to your home directory on the CentOS system

    ```
    $ scp bintray--kong-kong-enterprise-edition-rpm.repo <centos user>@<server>:~
    ```
    
3. Obtain your Kong Enterprise license

   If you do not already have your license file, you can download it from your
   account files in Bintray 
   `https://bintray.com/kong/<YOUR_REPO_NAME>/license#files`

   Ensure your license file is in proper `JSON`:

   ```json
    {"license":{"signature":"91e6dd9716d12ffsn4a5ckkb16a556dbebdbc4d0a66d9b2c53f8c8d717eb93dd2bdbe2cb3ef51c20806f14345128907da35","payload":{"customer":"Kong Inc","license_creation_date":"2019-05-07","product_subscription":"Kong Enterprise Edition","admin_seats":"5","support_plan":"None","license_expiration_date":"2021-04-01","license_key":"00Q1K00000zuUAwUAM_a1V1K000005kRhuUAE"},"version":1}}
   ```
4. Securely copy the license file to your home directory on the CentOS system

    ```
    $ scp license.json <centos username>@<server>:~
    ```

## Step 2. Install Kong Enterprise

1. If installing via a downloaded RPM package, please verify the Kong Enterprise Signature.

    Kong's official Key ID is 2cac36c51d5f3726. Verify it by querying the RPM package:
    
    ```
    $ rpm -qpi kong-enterprise-edition-1.3.el7.noarch.rpm | grep Signature
    ```
    >Note: Your version may be different based on when you obtained the RPM
  
    Verify the Signature line contains the correct Key ID.

    Download Kong's official public key and ensure the RPM package's integrity:

    ```
    $ curl -o kong.key https://bintray.com/user/downloadSubjectPublicKey?username=kong
    $ rpm --import kong.key
    $ rpm -K kong-enterprise-edition-1.3.el7.noarch.rpm
    ```
    
    Verify you get an OK check.  You should have an output similar to this:
    kong-enterprise-edition-1.3.0.1.el7.noarch.rpm: rsa sha1 (md5) pgp md5 OK
      
2. Install Kong Enterprise
    
    If you are installing via a downloaded rpm, execute a command similar to the following.
    
    ```
    $ sudo yum install kong-enterprise-edition-1.3.el7.noarch.rpm
    ```

    If you are installing via the yum repository, then move the repo file to the /etc/yum.repos.d/ directory

    ```
    $ sudo mv bintray--kong-kong-enterprise-edition-rpm.repo /etc/yum.repos.d/
    $ sudo yum install kong-enterprise-edition
    ```

3. Copy the license file to the `/etc/kong` directory

    ```
    $ sudo cp kong-se-license.json /etc/kong/license.json
    ```
    Kong will look for a valid license in this location.


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
