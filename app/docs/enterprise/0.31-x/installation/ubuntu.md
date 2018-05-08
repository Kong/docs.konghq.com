---
title: How to install Kong Enterprise and PostgreSQL onto Ubuntu
---

## Install Kong Enterprise

Download the EE binary for Ubuntu (or Debian) from Bintray
SFTP the file to your Ubuntu server

```bash
$ sudo apt-get update
$ sudo apt-get install openssl libpcre3 procps perl
$ sudo dpkg -i kong-enterprise-edition-0.31-1.zesty.all.deb
```
NOTE: EE file may differ in last step above. In addition to Zesty, we currently build for Precise, Trusty, and Xenial.

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
$ kong migrations up
$ sudo /usr/local/bin/kong start
```

### (Optional) Setup HTTPie to make commands easier
```bash
$ sudo apt install httpie
```

### Test your Kong installation
```bash
# curl syntax
$ curl -i -X POST \
  --url http://localhost:8001/apis/ \
  --data 'name=demo' \
  --data 'uris=/' \
  --data 'upstream_url=http://httpbin.org'
$ curl -i -X GET \
  --url http://localhost:8000/ip
  
# httpie syntax
$ http :8001/apis name=demo uris=/ upstream_url=http://httpbin.org
$ http :8000/ip
```

### Setup Admin GUI
```bash
### Get the local IP address
$ ifconfig 

### Uncomment the admin_listen setting, and update to something like this `admin_listen = 172.31.3.8:8001`
$ sudo vi /etc/kong/kong.conf

### Restart kong
$ sudo /usr/local/bin/kong stop 
$ sudo /usr/local/bin/kong start
```

In a browser, load your server on port `8002`
