---
title: How to Install Kong Enterprise on Ubuntu
---

## Introduction

This guide walks through downloading, installing, and starting Kong Enterprise
using Ubuntu and PostgreSQL 9.5. The configuration shown in this guide is
intended only as an example -- you will want to modify and take additional
measures to secure your Kong Enterprise system before moving to a production
environment.


## Prerequisites

To complete this guide you will need:

- An Ubuntu system with root equivalent access.
- The ability to SSH to the system.


## Step 1. Download Kong Enterprise

1. Download the .deb package

    Log in to [Bintray](http://bintray.com) to download the latest Kong
    Enterprise .deb for the desired version of Ubuntu. Your **Sales** or
    **Support** contact will email this credential to you.

    Copy the file to your home directory:

    ```
    $ scp kong-enterprise-edition-0.35.xxx.xxx.deb <ubuntu user>@<serverip:~
    ```

2. Obtain your Kong Enterprise license

    If you do not already have your license file, you can download it from your
    account files in Bintray 
    `https://bintray.com/kong/<YOUR_REPO_NAME>/license#files`

    Ensure your license file is in proper `JSON`:

    ```json
      {"license":{"signature":"91e6dd9716d12ffsn4a5ckkb16a556dbebdbc4d0a66d9b2c53f8c8d717eb93dd2bdbe2cb3ef51c20806f14345128907da35","payload":{"customer":"Kong Inc","license_creation_date":"2019-05-07","product_subscription":"Kong Enterprise Edition","admin_seats":"5","support_plan":"None","license_expiration_date":"2021-04-01","license_key":"00Q1K00000zuUAwUAM_a1V1K000005kRhuUAE"},"version":1}}
   ```

3. Securely copy the license file to the Ubuntu system

    ```
    $ scp license.json <ubuntu username>@<serverip>:~
    ```


## Step 2. Install Kong Enterprise

1. Install Kong Enterprise

    ```
    $ sudo apt-get update
    $ sudo apt-get install openssl libpcre3 procps perl
    $ sudo dpkg -i kong-enterprise-edition-0.35.xxx.xxx.deb
    ```
  >Note: Your version may be different based on when you obtained the package

2. Copy the license file to the `/etc/kong` directory

    ```
    $ sudo cp license.json /etc/kong/license.json
    ```
    Kong will look for a valid license in this location.


## Step 3. Install PostgreSQL

1. Install PostgreSQL

    ```
    $ sudo apt-get install postgresql-9.5 postgresql-contrib
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


## Step 5. Modify Kong's configuration file

To use the newly provisioned PostgreSQL database, Kong's configuration file
must be modified to accept the correct PostgreSQL user and password.

1. Make a copy of the default configuration file

    ```
    $ sudo cp /etc/kong/kong.conf.default /etc/kong/kong.conf
    ```

2. Uncomment and update the PostgreSQL database properties inside the Kong conf:

    ```
    $ sudo vi /etc/kong/kong.conf
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
