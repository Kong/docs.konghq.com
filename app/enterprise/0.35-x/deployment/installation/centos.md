---
title: How to Install Kong Enterprise on CentOS
toc: false
---

#### Table of Contents

- [Prerequisites](#prerequisites)
- [Step 1](#step-1)
- [Step 2](#step-2)
- [Step 3](#step-3)
- [Step 4](#step-4)
- [Step 5](#step-5)
- [Step 6](#step-6)
- [Step 7](#step-7)
- [Step 8](#step-8)
- [Step 9](#step-9)
- [Next Steps](#next-steps)

### Prerequisites

This installation guide assumes:
* You have a CentOS 7 system with root equivalent access. 
* You can SSH to the system.
* You have basic knowledge of CentOS and can alter the commands below to suit your needs. The example commands may not 
          be suitable for you based on your environment and security needs. 
        - This is an example only. In a production environment, you will want to take additional measures to secure your 
          Kong Enterprise system and take matters such as HA into account. 
        
Before installing Kong Enterprise, ensure that you've prepared your system:

1. Log in to bintray.com in order to download Kong Enterprise. Your Sales or Support contact will email the credential to you.

2. Copy the latest RPM for CentOS to your CentOS system home directory. 
    To copy Kong Enterprise to the home directory:

    ```
    $ scp kong-enterprise-edition-0.35-1.el7.noarch.rpm <centos user>@192.168.91.109:~
    ```
            
    ⚠️**Note**: In order to use a yum repo to download Kong Enterprise, you can edit the yum repo file under `/etc/yum.repos.d` to reference your CentOS version (`$releasever`, e.g., `6`, `7`), by editing the **baseurl** field. For instance:

    ```
    baseurl=https://<USERNAME>:<API_KEY>@kong.bintray.com/kong-enterprise-edition-rpm/centos/$releasever
    ```
    
    Where `<USERNAME>` is obtained from your access key, by appending a `%40kong` to it (encoded form of `@kong`). For
    example, if your access key is `bob-company`, your username will be `bob-company%40kong`.
          
    Now you can update `yum` with 
      
    ```
    $ yum update
    ```

    You should now be able to install Kong Enterprise using `yum`. 

    **Note**: The following instructions explain how to install Kong Enterprise with an RPM. 

3. Obtain the Kong license file in `.json` format and copy it to your CentOS system home directory. 
    <br/><br/>
    **Note**: Users with Bintray accounts should visit `https://bintray.com/kong/<YOUR_REPO_NAME>/license#files` to retrieve their license. Your license.json file will look something like this:

4. Securely copy the license file to the CentOS system

    ```
    $ scp kong-se-license.json <centos username>@192.168.91.109:~
    ```

## Step 1

Install Kong Enterprise (Note your version will be different based on when you obtained the rpm)

```
$ sudo yum install kong-enterprise-edition-0.35-1.el7.noarch.rpm
```

## Step 2

Install PostgreSQL.

```
$ sudo yum install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

$ sudo yum install postgresql95 postgresql95-server
```

## Step 3 

Initialize the PostgreSQL database.

```
$ sudo /usr/pgsql-9.5/bin/postgresql95-setup initdb
```

## Step 4

Start PostgreSQL and enable automatic start.

```
$ sudo systemctl enable postgresql-9.5
$ sudo systemctl start postgresql-9.5
```

## Step 5

Create a Kong database and user. 

⚠️**Note**: Make sure the username and password for the Kong Database are kept 
safe. We have used a simple example below for illustration purposes. 

1. Switch to PostgreSQL user  
    ```
    $ sudo -i -u postgres
    ```

2. Launch PostgreSQL
    ```
    $ psql
    ```

3. Create a Kong user and database, make Kong the owner of the database, and 
set the password of the Kong user to 'kong'
    ```
    $ CREATE USER kong; CREATE DATABASE kong OWNER kong; ALTER USER kong WITH password 'kong';
    ```

4. Exit from PostgreSQL
    ```
    $ \q
    ```

5. Return to terminal
    ```
    $ exit
    ```

6. Modify the PostgreSQL configuration to allow password authentication with 
MD5.
    Under IPv4 local connections: replace the `"ident"` entry with `"md5"`
  
    ```
    $ sudo vi /var/lib/pgsql/9.5/data/pg_hba.conf
    ```

7. restart PostgreSQL
    ```
    $ sudo systemctl restart postgresql-9.5
    ```

8. Copy the license file from your home directory to the `/etc/kong` directory. 
Kong will look for the license here. 
    ```
    $ sudo cp kong-se-license.json /etc/kong/license.json
    ```

9. Modify the `kong.conf` file and update the PostgreSQL database password to 
the password you used when you created the PostgreSQL user named **kong**. 

10. Make a copy of the default configuration file    
    ```
    $ cp /etc/kong/kong.conf.default /etc/kong/kong.conf
    ```

11. Uncomment and add 'kong' to pg_password line
    ```
    $ sudo vi [/path/to/kong.conf]
    ```

## Step 6 

Seed the **Super Admin** for initial startup. This step is not mandatory, 
but if you want to add security and Role-Based Access Control (RBAC) to your 
environment, it is best to seed the **Super Admin** at this step and make note 
of the password for when you need it later. 

Create an environment variable with the _Super Admin_ password (that will be 
used during migrations to seed the initial _Super Admin_ password):

```
$ export KONG_PASSWORD=<password-only-you-know>
```

## Step 7

Run migrations to prepare the Kong DB

```
$ kong migrations bootstrap -c /etc/kong/kong.conf
```

## Step 8

Start Kong.

```
$ sudo /usr/local/bin/kong start -c /etc/kong/kong.conf
```

## Step 9

Verify Kong installation is working.

```
curl -i -X GET --url http://localhost:8001/services
```

## Next Steps

You should receive a HTTP/1.1 200 OK message. If you do, you are ready to move on. As a Next Step, consider the following tasks:

1. Turn on RBAC and understand the RBAC model within Kong. 
2. Turn on the Admin GUI Portal to allow you to administer Kong through the UI. 
3. Create a sample Workspace to understand how Kong can be segregated for use between teams. 
4. Create Services, Routes, and Consumers for a given workspace. 
5. Add Plugins to inject functionality to the API calls that are being proxied through Kong. For example, Add Rate-Limiting. 
