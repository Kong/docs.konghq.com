---
title: Install Kong Enterprise on Amazon Linux
---

## Download Kong Gateway

{% include /md/enterprise/install.md install='OS' %}

### Obtain your Kong Enterprise license

{% include /md/enterprise/license.md license='<1.3' %}

{% include /md/enterprise/license.md license='json-example' %}

## Install Postgres

```bash
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
