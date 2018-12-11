---
title: How to install Kong Enterprise and PostgreSQL onto Amazon Linux
---

# Introduction

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
$ sudo yum install postgresql95 postgresql95-server
$ sudo service postgresql95 initdb
$ sudo service postgresql95 start
$ sudo -i -u postgres (puts you into new shell)
```

Create `kong` user

```bash
$ psql
> CREATE USER kong; CREATE DATABASE kong OWNER kong; ALTER USER kong WITH password 'kong'; 
> \q
```

```bash
# Change entries from ident to md5
$ sudo vi /var/lib/pgsql95/data/pg_hba.conf
$ sudo service postgresql95 restart

# add contents of license file
$ sudo vi /etc/kong/license.json

# Uncomment and add 'kong' to pg_password line
$ sudo vi /etc/kong/kong.conf.default

# Run migrations and start kong
$ kong migrations up -c /etc/kong/kong.conf.default
$ sudo /usr/local/bin/kong start -c /etc/kong/kong.conf.default
```

## Setup HTTPie to make commands easier

```bash
$ sudo yum install python-pip
$ sudo pip install --upgrade pip setuptools
$ sudo pip install --upgrade httpie
```

## Test your Kong installation

```bash
$ http :8001/apis name=demo uris=/ upstream_url=http://httpbin.org
$ http :8000/ip
```

## Setup Admin GUI

```bash
# Get the local IP address
$ ifconfig 

# Uncomment the admin_listen setting, and update to something like this `admin_listen = 172.31.3.8:8001`
$ sudo vi /etc/kong/kong.conf.default 

# Restart kong
$ sudo /usr/local/bin/kong stop 
$ sudo /usr/local/bin/kong start -c /etc/kong/kong.conf.default
```

In a browser, load your server on port `8002`
