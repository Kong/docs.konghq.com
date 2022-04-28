---
title: Install Kong Enterprise on CentOS
---

## Introduction

This guide walks through downloading, installing, and starting Kong Enterprise
using CentOS and PostgreSQL 9.5. The configuration shown in this guide is
intended only as an example -- you will want to modify and take additional
measures to secure your Kong Enterprise system before moving to a production
environment.


## Prerequisites

To complete this guide you will need:

- A CentOS 6 or 7 system with root equivalent access.
- The ability to SSH to the system.


## Step 1. Download Kong Enterprise

{% include /md/enterprise/install.md install='OS' %}

### Download your Kong Enterprise License

{% include /md/enterprise/license.md license='<1.3' %}

{% include /md/enterprise/license.md license='json-example' %}

3. Securely copy the license file to the CentOS system

    ```
    $ scp license.json <centos username>@<serverip>:~
    ```


## Step 2. Install Kong Enterprise

1. Install Kong Enterprise

    ```
    $ sudo yum install kong-enterprise-edition-0.35-1.el7.noarch.rpm
    ```
  >Note: Your version may be different based on when you obtained the rpm

2. Copy the license file to the `/etc/kong` directory

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
[Getting Started](/enterprise/{{page.kong_version}}/getting-started) guides to get the most
out of Kong Enterprise.
