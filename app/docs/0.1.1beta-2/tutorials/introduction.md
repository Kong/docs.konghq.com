---
layout: docs
title: Tutorials - Introduction
version: 0.1.1beta-2
permalink: /docs/0.1.1beta-2/tutorials/introduction/
---

# Introduction

The following tutorials assume that Kong has been properly installed using one of the [available installation methods](/download).

Kong will look by default for a configuration file at `/etc/kong/kong.yml`. If you installed Kong from luarocks, you can copy the default configuration from the luarocks tree (luarocks --help to print it). Usually:

```
cp /usr/local/lib/luarocks/rocks/kong/<kong_version>/conf/kong.yml /etc/kong/kong.yml
```

Edit the configuration to let Kong access your Cassandra cluster.

Let's start Kong:

```
kong start
```

If this is the first time running Kong, the `start` command will also automatically run database migrations to prepare the Cassandra keyspace.

Once Kong is started it will listen by default on the following ports:

* `8000`, that will accept incoming HTTP request to be proxied to the final APIs
* `8001`, that exposes Kong's administration API to operate the system

Port `8001` should be firewalled to prevent unauthorized access.