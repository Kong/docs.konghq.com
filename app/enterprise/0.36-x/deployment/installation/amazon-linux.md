---
title: Install Kong Enterprise and on Amazon Linux
---

## Installation Steps

```bash
$ sudo yum update
$ sudo vi /etc/yum.repos.d/bintray-kong-kong-enterprise-edition-aws.repo
[kong-enterprise]
name = kong-enterprise
baseurl = https://<BINTRAY_USER:<PASSWORD>@kong.bintray.com/kong-enterprise-edition-aws
gpgcheck = 0
enabled = 1
```

```bash
$ sudo yum install kong-enterprise-edition
$ sudo yum install postgresql95 postgresql-server95
$ sudo service postgresql95 initdb
$ sudo service postgresql95 start
$ sudo -i -u postgres (puts you into new shell)
```

Create `kong` user

```bash
$ psql
> CREATE USER kong; CREATE DATABASE kong OWNER kong; ALTER USER kong WITH password 'kong'; 
> \q
> exit
```

```bash
# Change entries from ident to md5
$ sudo vi /var/lib/pgsql95/data/pg_hba.conf
$ sudo service postgresql95 restart

# add contents of license file
$ sudo vi /etc/kong/license.json

# Make a copy of the default configuration file

    ```
    $ sudo cp /etc/kong/kong.conf.default /etc/kong/kong.conf
    ```

# Uncomment and update the PostgreSQL database properties inside the Kong conf:

    ```
    $ sudo vi /etc/kong/kong.conf
    ```
    ```
    pg_user = kong
    pg_password = kong
    pg_database = kong
    ```

# Run migrations and start kong
$ sudo /usr/local/bin/kong migrations bootstrap -c /etc/kong/kong.conf
$ sudo /usr/local/bin/kong start /etc/kong/kong.conf
```

## Verify Kong Installation

```bash
$ curl -i -X GET --url http://localhost:8001/services
```

## Install Kong Manager

```bash
# Get the local IP address
$ ifconfig 

# Uncomment the admin_listen setting, and update to the network IP in the step before.  For example `admin_listen = 172.31.3.8:8001`
$ sudo vi /etc/kong.conf

# Restart kong
$ sudo /usr/local/bin/kong stop 
$ sudo /usr/local/bin/kong start /etc/kong/kong.conf
```
In a browser, load your server on port `8002`
