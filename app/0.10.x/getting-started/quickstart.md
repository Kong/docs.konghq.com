---
title: 5-minute Quickstart
---

# 5-minute Quickstart

<div class="alert alert-warning">
  <strong>Before you start:</strong> Make sure you've
  <a href="/install/">installed Kong</a> &mdash; It should only take a minute!
</div>

In this section, you'll learn how to manage your Kong instance. First we'll
have you start Kong giving in order to give you access to the RESTful Admin
interface, through which you manage your APIs, consumers, and more. Data sent
through the Admin API is stored in Kong's [datastore][datastore-section] (Kong
supports PostgreSQL and Cassandra).

1. ### Start Kong.

    Issue the following command to [start][CLI] Kong:

    ```bash
    $ kong start
    ```

    **Note:** The CLI also accepts a configuration (`-c <path_to_config>`)
    option allowing you to point to different configurations.

2. ### Verify that Kong has started successfully

    The previous step runs migrations to prepare your database.
    Once these have finished you should see a message (`Kong started`)
    informing you that Kong is running.

    By default Kong listens on the following ports:

- `:8000` on which Kong listens for incoming HTTP traffic from your
  clients, and forwards it to your upstream services.
- `:8443` on which Kong listens for incoming HTTPS traffic. This port has a
  similar behavior as the `:8000` port, except that it expects HTTPS
  traffic only. This port can be disabled via the configuration file.
- `:8001` on which the [Admin API][API] used to configure Kong listens.
- `:8444` on which the Admin API listens for HTTPS traffic.

3. ### Stop Kong.

    As needed you can stop the Kong process by issuing the following
    [command][CLI]:

    ```bash
    $ kong stop
    ```

4. ### Reload Kong.

    Issue the following command to [reload][CLI] Kong without downtime:

    ```bash
    $ kong reload
    ```

### Next Steps

Now that you have Kong running you can interact with the Admin API.

To begin, go to [Adding your API &rsaquo;][adding-your-api]

[CLI]: /{{page.kong_version}}/cli
[API]: /{{page.kong_version}}/admin-api
[datastore-section]: /{{page.kong_version}}/configuration/#datastore-section
[adding-your-api]: /{{page.kong_version}}/getting-started/adding-your-api
