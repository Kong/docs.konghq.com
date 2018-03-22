---
title: 5-minute Quickstart
---

# 5-minute Quickstart

In this section, you'll learn how to manage your Kong Enterprise Edition (EE)
instance. First we'll
have you start Kong to give you access to the RESTful Admin API, and easy-to-use
Admin GUI, through which you manage your APIs, consumers, and more. Data sent
through the Admin API and GUI is stored in Kong's [datastore][datastore-section]
(Kong supports PostgreSQL and Cassandra).

1. ### Start Kong EE

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

2. ### Verify that Kong EE has started successfully

    If everything went well, you should see a message (`Kong started`)
    informing you that Kong is running.

    By default Kong listens on the following ports:

- `:8000` on which Kong listens for incoming HTTP traffic from your
  clients, and forwards it to your upstream services.
- `:8443` on which Kong listens for incoming HTTPS traffic. This port has a
  similar behavior as the `:8000` port, except that it expects HTTPS
  traffic only. This port can be disabled via the configuration file.
- `:8001` on which the [Admin API][API] used to configure Kong listens.
- `:8444` on which the [Admin API][API] listens for HTTPS traffic.

3. ### Stop Kong EE

    As needed you can stop the Kong process by issuing the following
    [command][CLI]:

    ```bash
    $ kong stop
    ```

4. ### Reload Kong EE

    Issue the following command to [reload][CLI] Kong without downtime:

    ```bash
    $ kong reload
    ```

### Next Steps

Now that you have Kong EE running you can interact with the Admin API.

To begin, go to [Adding your API &rsaquo;][adding-your-api]

[CLI]: /docs/latest/cli
[API]: /docs/latest/admin-api
[datastore-section]: /docs/latest/configuration/#datastore-section
[adding-your-api]: /docs/enterprise/{{page.kong_version}}/getting-started/adding-your-api
