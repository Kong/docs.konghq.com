---
title: Install Kong Enterprise and PostgreSQL onto Amazon Linux
---

## Download Kong Gateway

{% include /md/enterprise/install.md install='OS' %}

### Obtain your Kong Enterprise license

{% include /md/enterprise/license.md license='<1.3' %}

{% include /md/enterprise/license.md license='json-example' %}

## Install Postgres

```bash
$ sudo yum install postgresql95 postgresql95-server
$ sudo service postgresql95 initdb
$ sudo service postgresql95 start
$ sudo -i -u postgres (puts you into new shell)
```

**Note**: `<USERNAME>` is obtained from your access key, by appending a `%40kong`
to it (encoded form of `@kong`). For example, if your access key is `bob-company`,
your username will be `bob-company%40kong`.

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
$ sudo vi [/path/to/kong.conf]

# Run migrations and start kong
$ kong migrations up [-c /path/to/kong.conf]
$ sudo /usr/local/bin/kong start [-c /path/to/kong.conf]
```

**Note:** You may use `kong.conf.default` or create [your own configuration](/0.13.x/configuration/#configuration-loading).

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
$ sudo vi [/path/to/kong.conf]

# Restart kong
$ sudo /usr/local/bin/kong stop
$ sudo /usr/local/bin/kong start [-c /path/to/kong.conf]
```

In a browser, load your server on port `8002`
