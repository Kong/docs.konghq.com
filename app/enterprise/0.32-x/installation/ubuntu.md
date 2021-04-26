---
title: Install Kong Enterprise and PostgreSQL onto Ubuntu
---

## Download Kong Gateway

{% include /md/enterprise/install.md install='OS' %}

### Obtain your Kong Enterprise license

{% include /md/enterprise/license.md license='<1.3' %}

{% include /md/enterprise/license.md license='json-example' %}

## Install PostgreSQL
```bash
$ sudo apt-get install postgresql
$ sudo -i -u postgres (puts you into new shell)
```

Create `kong` user

```bash
$ psql
> CREATE USER kong; CREATE DATABASE kong OWNER kong; ALTER USER kong WITH password 'kong';
> \q
$ exit
```

## Finish Kong Enterprise setup steps

```bash
# Add contents of your license file (copy & paste)
$ sudo vi /etc/kong/license.json
$ sudo cp /etc/kong/kong.conf.default /etc/kong/kong.conf
# Uncomment and add 'kong' to pg_password line
$ sudo vi /etc/kong/kong.conf
```

### Run migrations and start kong
```bash
$ sudo /usr/local/bin/kong migrations up
$ sudo /usr/local/bin/kong start
```

### Test your Kong installation
```bash
$ curl -i -X POST \
  --url http://localhost:8001/apis/ \
  --data 'name=demo' \
  --data 'uris=/' \
  --data 'upstream_url=http://httpbin.org'
$ curl -i -X GET \
  --url http://localhost:8000/ip
```

### Setup Admin GUI
```bash
# Get the local IP address
$ ifconfig

# Uncomment the admin_listen setting, and update to
# something like this `admin_listen = 172.31.3.8:8001`
$ sudo vi /etc/kong/kong.conf

# Restart kong
$ sudo /usr/local/bin/kong stop
$ sudo /usr/local/bin/kong start
```

In a browser, load your server on port `8002`
