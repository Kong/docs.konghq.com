---
title: 5-Minute Quickstart
---

## Introduction

In this section, you'll learn how to manage your Kong Enterprise instance. 
First, you'll start Kong to give you access to the RESTful Admin API and the 
easy-to-use Kong Manager, through which you'll manage your APIs, consumers, and 
more. Configuration changes made through the Admin API and Kong Manager are 
stored in Kong's [datastore][datastore-section] (Kong supports PostgreSQL 
and Cassandra).

The easiest way to start using Kong Enterprise is by following our 
[Docker installation][docker] instructions. Alternately, you can install and 
run without containers by following our [CentOS][centos] or 
[Amazon Linux][amazonlinux] instructions.

## 1. Start Kong Enterprise

A Super Admin account is required to secure the Admin API with RBAC or Kong 
Manager with an authentication plugin. The Super Admin account is created 
during database migrations. 

To set up the first account:

1. Set a password for the Super Admin. This environment variable must
    be present in the environment where database migrations will run. 

    ```
    $ export KONG_PASSWORD=<password-only-you-know>
    ```

    This creates a user, `kong_admin`, and a password that can be used to
    log in to Kong Manager or to make Admin API requests when RBAC is enabled.

    **Note:** only one **Super Admin** may be created using this method, and only
    on a fresh installation with an empty database.  Future migrations will not update the
    password or create additional **Super Admins**.  To add additional **Super
    Admins** it is necessary to invite a new user as a **Super Admin** in Kong Manager.

2. Issue the following command to prepare your datastore by running the Kong
    migrations:

    ```bash
    $ kong migrations up [-c /path/to/kong.conf]
    ```

    You should see a message that tells you Kong has successfully migrated your
    database. If not, you probably incorrectly configured your database
    connection settings in your configuration file.

3. Now let's [start][CLI] Kong:

    ```bash
    $ kong start [-c /path/to/kong.conf]
    ```

**Note:** the CLI accepts a configuration option (`-c /path/to/kong.conf`)
allowing you to point to [your own configuration](/0.13.x/configuration/#configuration-loading).

## 2. Verify that Kong Enterprise has Started Successfully

If everything went well, you should see a message (`Kong started`)
informing you that Kong is running.

By default Kong listens on the following ports:

- `:8000` on which Kong listens for incoming HTTP traffic from your
  clients, and forwards it to your upstream services.
- `:8443` on which Kong listens for incoming HTTPS traffic. This port has a
  similar behavior as the `:8000` port, except that it expects HTTPS
  traffic only. This port can be disabled via the configuration file.
- `:8003` on which Kong listens for [Kong Dev Portal][dev-portal] GUI traffic—
if the Dev Portal is enabled.
- `:8004` on which Kong listens for [Kong Dev Portal][dev-portal] `/files` 
  traffic—if the Dev Portal is enabled.
- `:8001` on which the [Admin API][API] listens.
- `:8444` on which the [Admin API][API] listens for HTTPS traffic.
- `:8002` on which [Kong Manager][kong-manager] listens.
- `:8445` on which [Kong Manager][kong-manager] listens for HTTPS traffic.


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

Now that you have Kong Enterprise running you can interact with the Admin API 
and Kong Manager.

To begin, go to [Configuring a Service &rsaquo;][configuring-a-service]

[CLI]: /0.13.x/cli
[API]: /0.13.x/admin-api
[kong-manager]: /enterprise/{{page.kong_version}}/kong-manager/overview
[datastore-section]: /0.13.x/configuration/#datastore-section
[configuring-a-service]: /enterprise/{{page.kong_version}}/getting-started/configuring-a-service
[docker]: /enterprise/{{page.kong_version}}/installation/docker/
[centos]: /enterprise/{{page.kong_version}}/installation/centos/
[amazonlinux]: /enterprise/{{page.kong_version}}/installation/amazon-linux/
[dev-portal]: /enterprise/{{page.kong_version}}/developer-portal/introduction
