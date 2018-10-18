---
title: 5-minute Quickstart
---

# 5-minute Quickstart

In this section, you'll learn how to manage your Kong Enterprise
instance. First you'll start Kong to give you access to the RESTful Admin API and an easy-to-use
Admin GUI, through which you'll manage your APIs, consumers, and more. Configuration changes made
through the Admin API and GUI is stored in Kong's [datastore][datastore-section]
(Kong supports PostgreSQL and Cassandra).

The easiest way to start using Kong Enterprise is by following our [Docker installation][docker] instructions.
Alternately, you can install and run without containers by following our [CentOS][centos] or
[Amazon Linux][amazonlinux] instructions.

## 1. Start Kong Enterprise

Issue the following command to prepare your datastore by running the Kong
migrations:

```bash
$ kong migrations up [-c /path/to/kong.conf]
```

You should see a message that tells you Kong has successfully migrated your
database. If not, you probably incorrectly configured your database
connection settings in your configuration file.

Now let's [start][CLI] Kong:

```bash
$ kong start [-c /path/to/kong.conf]
```

**Note:** the CLI accepts a configuration option (`-c /path/to/kong.conf`)
allowing you to point to your own configuration.

## 2. Verify that Kong Enterprise has started successfully

If everything went well, you should see a message (`Kong started`)
informing you that Kong is running.

By default Kong listens on the following ports:

- `:8000` on which Kong listens for incoming HTTP traffic from your
  clients, and forwards it to your upstream services.
- `:8443` on which Kong listens for incoming HTTPS traffic. This port has a
  similar behavior as the `:8000` port, except that it expects HTTPS
  traffic only. This port can be disabled via the configuration file.
- `:8003` on which Kong listens for [Kong Dev Portal][dev-portal] GUI traffic - if the Dev Portal is enabled.
- `:8004` on which Kong listens for [Kong Dev Portal][dev-portal] `/files` traffic - if the Dev Portal is enabled.
- `:8001` on which the [Admin API][API] listens.
- `:8444` on which the [Admin API][API] listens for HTTPS traffic.
- `:8002` on which the [Admin GUI][GUI] listens.
- `:8445` on which the [Admin GUI][GUI] listens for HTTPS traffic.


## 3. Stop Kong Enterprise

As needed you can stop the Kong process by issuing the following [command][CLI]:

```bash
$ kong stop
```

## 4. Reload Kong Enterprise

Issue the following command to [reload][CLI] Kong without downtime:

```bash
$ kong reload
```

## Next Steps

Now that you have Kong Enterprise running you can interact with the Admin API and GUI.

To begin, go to [Adding your API &rsaquo;][adding-your-api]

[CLI]: /latest/cli
[API]: /latest/admin-api
[GUI]: /enterprise/{{page.kong_version}}/admin-gui/overview
[datastore-section]: /latest/configuration/#datastore-section
[adding-your-api]: /enterprise/{{page.kong_version}}/getting-started/adding-your-api
[docker]: /enterprise/{{page.kong_version}}/installation/docker/
[centos]: /enterprise/{{page.kong_version}}/installation/centos/
[amazonlinux]: /enterprise/{{page.kong_version}}/installation/amazon-linux/
[dev-portal]: /enterprise/{{page.kong_version}}/developer-portal/introduction/
