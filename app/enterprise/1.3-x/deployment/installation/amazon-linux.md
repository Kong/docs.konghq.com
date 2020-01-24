--- 
title: Install Kong Enterprise with Amazon Linux 1
---

## Introduction

This guide will walk you through installing and running **Kong Enterprise** on an existing **Amazon Linux 1 EC2** instance. Click [HERE](/enterprise/{{page.kong_version}}/deployment/installation/amazon-linux-2) for installing on Amazon Linux **2**.

**Supported Database Options:**

* PostgreSQL 9.5, 9.6
* Cassandra 3

Due to the nature of setting up a Kong cluster with Cassandra, this documentation only covers Postgres. For assistance in setting up Cassandra, please contact your Sales or Support representative.


## Prerequisites

To complete this installation guide you will need:


* A valid *Bintray* account. You will need your *username*, account *password* and account *API KEY*.
    * Example:
        * Bintray Access key = `john-company`
        * Bintray username = `john-company@kong`
        * Bintray password = `12345678`
        * Bintray API KEY = `12234e314356291a2b11058591bba195830`
* SSH access to a running EC2 instance
* A valid **Kong Enterprise License** JSON file, this can be found in your Bintray account. See [Accessing Your License](/enterprise/{{page.kong_version}}/deployment/access-license))
* HTTPIE with Python3 _(optional)_ - this allows for making easier commands to Kong, see [Step 6. Set up HTTPIE](/#step-6-verify-kong-is-receiving-requests) for details.



## Step 1. Download Kong Enterprise

1. Download the RPM package from Bintray
  ```
  $ sudo yum update
  $ wget 'https://<BINTRAY_USERNAME>:<PASSWORD>@bintray.com/kong/kong-enterprise-edition-aws/rpm' -O bintray-kong-kong-enterprise-edition-aws.repo --auth-no-challenge`
  ```
  > Note: this command requires your Bintray account PASSWORD, **not** your API KEY, 
  > If you receive the error “BAD PORT” ensure your password does not contain any shell meta-characters like $,@, or / 

2. Move the package into `/etc/yum.repos.d/`
  ```
  $ sudo mv bintray-kong-kong-enterprise-edition-aws.repo /etc/yum.repos.d/
  ```

3. Open the package to and add your Bintray credentials to the `baseurl` value.
  ```
  $ sudo vi /etc/yum.repos.d/bintray-kong-kong-enterprise-edition-aws.repo
  ```
  ```
  baseurl=https://<BINTRAY_USER>:<BINTRAY_API_KEY>@kong.bintray.com/kong-enterprise-edition-aws
  ```
  > Note: Unlike step 1, this command requires your Bintray account API KEY, **not** your PASSWORD.

4. Obtain your Kong Enterprise license file.
  If you do not already have your license file, you can download it from your account files in Bintray *`https://bintray.com/kong/<YOUR_REPO_NAME>/license#files`*. See [How you Access Your Enterprise License](/enterprise/latest/deployment/access-license) for help.

5. Ensure your license file is in proper *`JSON`*:
  ```
    {"license":{"signature":"91e6dd9716d12ffsn4a5ckkb16a556dbebdbc4d0a66d9b2c53f8c8d717eb93dd2bdbe2cb3ef51c20806f14345128907da35","payload":{"customer":"Kong Inc","license_creation_date":"2019-05-07","product_subscription":"Kong Enterprise Edition","admin_seats":"5","support_plan":"None","license_expiration_date":"2021-04-01","license_key":"00Q1K00000zuUAwUAM_a1V1K000005kRhuUAE"},"version":1}}
  ```

6. Securely copy the license file to the EC2 instance
  ```
    $ scp license.json <ec2-username>@<serverip>:~
  ```


## Step 2. Install Kong Enterprise

1. Install Kong Enterprise
  ```
  $ sudo yum install kong-enterprise-edition
  ```

2. Copy the license file to `/etc/kong/license.json`
  ```
  $ sudo cp kong-se-license.json /etc/kong/license.json
  ```
  Kong will look for a valid license in this location.


## Step 3. Install and Initialize the Database

**Kong Enterprise** on Amazon Linux  supports:

- [PostgreSQL](/#postgresql)
- Cassandra


### PostgreSQL

This configuration supports PostgreSQL 9.5 and 9.6.

**Steps for this section:**

- i. [Install and Start Postgres](/#install-and-start-postgresql)
- ii. [Create a Kong user and database](/#create-a-kong-user-and-database)
- iii. [Connect Kong to the Postgres database](/#connect-kong-to-the-postgresql-database)


**i. Install and Start PostgreSQL**

1. Install PostgreSQL
  ```
  $ sudo yum install postgresql96 postgresql96-server
  ```
2. Initialize the database
  ```
  $ sudo service postgresql96 initdb
  ```
3. Start PostgreSQL
  ```
  $ sudo service postgresql96 start
  ```


**ii. Create a Kong user and database**

The user and database can easily be created via the command line by using PostgreSQL’s command line tool `psql`

1. Change to the `postgres` user
  ```
  $ sudo -i -u postgres
  ```

2. Launch the PostgreSQL command line tool `psql`
  ```
  $ psql
  ```

3. Create the `kong` user and database
  ```
  $ psql> CREATE USER kong; CREATE DATABASE kong OWNER kong; ALTER USER kong WITH password 'kong';
  ```
  > ⚠️Note: Make sure the username and password for the Kong Database are kept safe. We have used a simple example for illustration purposes only.

4. Exit `psql`
  ```
  $ psql> \q
  ```

5. Return to the terminal
  ```
  $ exit
  ```

**iii. Connect Kong to the PostgreSQL database**

Postgres uses `ident` authentication by default, to allow the `kong` user to communicate with the database locally we must change the authentication method to `md5` by modifying the Postgres configuration file. 


1. Open the configuration file:
  ```
  $ sudo vi /var/lib/pgsql96/data/pg_hba.conf
  ```

2. Change the `IPV4` local connection method to `md5`
  ```
    | TYPE | DATABASE | USER | ADDRESS      | METHOD |
    | # IPv4 local connections:                      |
    | host | all      | all  | 127.0.0.1/32 |  md5   |
    | # IPv6 local connections:                      |
    | host | all      | all  | ::1/128      | ident  |
  ```

3. Save and exit the file, then restart Postgres
  ```
  $ sudo service postgresql96 restart
  ```

Now that the database is set up, Kong must be given credentials to access the database. This is done by adding the Postgres user and password information to Kong’s configuration file.


1. Make a copy of Kong’s configuration file
  ```
  sudo cp /etc/kong/kong.conf.default kong.conf
  ```

2. Open the new configuration file
  ```
  sudo vi /etc/kong/kong.conf
  ```

3. Search for `pg_password` under `DATASTORE,` uncomment `pg_password` and add the value. 
  ```
  #pg_user = kong
  pg_password = kong
  #pg_datastore = kong
  ```
  > Note: If you used different values for the user and database name, uncomment the pg_user and pg_datastore variables and add the username and datastore values


## Step 4. Customize Your Configuration
Before starting Kong, you can further modify Kong’s configuration file to enable a host of different features:


### Enable RBAC

  Kong Enterprise allows applying RBAC to all requests. To enable RBAC, you must set RBAC to `on`, select an authentication plugin for Kong Manager, and configure the [Session plugin](/hub/kong-inc/session).

  ```
  enforce_rbac = on

  admin_gui_auth = basic-auth

  admin_gui_session_conf = {"secret":"password", "cookie_secure": false, "cookie_samesite": "off", "cookie_name": "admin_session", "storage": "kong"}
  ```

  Export the KONG_PASSWORD environment variable:
  ```
  export KONG_PASSWORD=kong
  ```

### Enable Kong Manager

  Kong Enterprise's Graphical User Interface **Kong Manager** can be connected by setting the `admin_gui_url` property to the EC2 instances `IPv4` address

  ```
  admin_gui_url = http://ec2-xx-xxx-xx-xx.us-east-2.compute.amazonaws.com:8002
  ```

### Enable the Dev Portal

  Kong Enterprise's **Developer Portal** can be connected by setting the `portal` property to `on` and setting the `portal_gui_host` property to the EC2 instance's `IPv4` address

  ```
  portal = on
  portal_gui_host = http://ec2-xx-xxx-xx-xx.us-east-2.compute.amazonaws.com:8003
  ```


## Step 5. Start Kong

1. Run migrations
  ```
  kong migrations bootstrap -c /etc/kong/kong.conf
  ```
2. Start Kong
  ```
  sudo /usr/local/bin/kong start -c /etc/kong/kong.conf
  ```


## Step 6. Verify Kong is Receiving Requests

##### Install HTTPie to easily send requests to Kong *(optional)*
  ```
  sudo yum install python36

  sudo pip-3.6 install --upgrade pip setuptools

  sudo /usr/local/bin/pip3.6 install --upgrade httpie
  ```

#### Test your connection to Kong

**httpie**
  ```
  http :8001/services 
  
  if RBAC is enabled:
  *http :8001/services Kong-Admin-Token:$KONG_PASSWORD
  ```

**curl**
  ```
  curl -i -X GET --url http://localhost:8001/services

  if RBAC is enabled:
  curl -i -X GET --url http://localhost:8001/services --header 'kong-admin-token:<KONG_PASSWORD>'
  ```


You should receive a `200 OK` response:

```
HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 23
Content-Type: application/json; charset=utf-8
Date:
Server: kong/kong-enterprise-edition
X-Kong-Admin-Request-ID: 

{
    "data": [],
    "next": null
}
```

If you did not receive a `200` check out the troubleshooting section below or contact your Sales or Support Representative for assistance.


## Troubleshooting

##### I receive an error when downloading the RPM Package
  Ensure that you are using your Bintray Username and Bintray account **password **in the `wget` request - note that this is different from your Bintray API KEY.


##### HTTP 401 - Unauthorized
  If you have enabled RBAC all request must be sent with the `kong-admin-token` header 

  **httpie**
    ```
    Kong-Admin-Token:$KONG_PASSWORD
    ```

  **curl**
    ```
    --header 'kong-admin-token:<KONG_PASSWORD>'
    ```

## Next Steps

Now that Kong Enterprise is up and running, checkout our [Getting Started](/enterprise/{{page.kong_version}}/getting-started) guide.
