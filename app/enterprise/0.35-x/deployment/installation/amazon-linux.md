---
title: Install Kong Enterprise on Amazon Linux
---

## Installation Steps

```bash
$ sudo yum update
$ wget 'https://<BINTRAY_USER:<PASSWORD>@bintray.com/kong/kong-enterprise-edition-aws/rpm' -O bintray-kong-kong-enterprise-edition-aws.repo --auth-no-challenge
$ sudo mv bintray-kong-kong-enterprise-edition-aws.repo /etc/yum.repos.d/
$ sudo vi /etc/yum.repos.d/bintray-kong-kong-enterprise-edition-aws.repo
```

Ensure `baseurl` is correct

```bash
baseurl=https://<BINTRAY_USER>:<BINTRAY_API_KEY>@kong.bintray.com/kong-enterprise-edition-aws
```

```bash
$ sudo yum install kong-enterprise-edition
$ sudo yum install postgresql postgresql-server
$ sudo service postgresql initdb
$ sudo service postgresql start
$ sudo -i -u postgres (puts you into new shell)
```

Create `kong` user

```bash
$ psql
> CREATE USER kong; CREATE DATABASE kong OWNER kong; ALTER USER kong WITH password 'kong'; 
> \q
> quit
```

```bash
# Change entries from ident to md5
$ sudo vi /var/lib/pgsql/data/pg_hba.conf
$ sudo service postgresql restart

# add contents of license file
$ sudo vi /etc/kong/license.json

# Uncomment and add 'kong' to pg_password line
$ sudo vi [/path/to/kong.conf]

# Run migrations and start kong
$ kong migrations bootstrap [-c /path/to/kong.conf]
$ sudo /usr/local/bin/kong start [-c /path/to/kong.conf]
```

**Note:** You may use `kong.conf.default` or create [your own configuration](/enterprise/{{page.kong_version}}/property-reference/#configuration-loading).

## Verify Kong Installation

```bash
$ curl -i -X GET --url http://localhost:8001/services
```

## Install Kong Manager

```bash
# Get the local IP address
$ ifconfig 

# Uncomment the admin_listen setting, and update to something like this `admin_listen = 172.31.3.8:8001`
$ sudo vi [/path/to/kong.conf] 

# Restart kong
$ sudo /usr/local/bin/kong stop 
$ sudo /usr/local/bin/kong start [-c /path/to/kong.conf]
```

In a browser, load your server on port `8002`
