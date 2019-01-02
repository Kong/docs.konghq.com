---
title: 5-minute Quickstart
---

<div class="alert alert-warning">
  <strong>Before you start:</strong> Make sure you've
  <a href="https://konghq.com/install/">installed Kong</a> &mdash; It should only take a minute!
</div>

In this section, you'll learn how to manage your Kong instance. First, we'll
have you start Kong in order to give you access to the RESTful Admin
interface, through which you manage your Services, Routes, Consumers, and more. Data sent
through the Admin API is stored in Kong's [datastore][datastore-section] (Kong
supports PostgreSQL and Cassandra).

## 1. Start Kong

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
allowing you to point to [your own configuration][configuration-loading].

## 2. Verify that Kong has started successfully

If everything went well, you should see a message (`Kong started`)
informing you that Kong is running.

By default Kong listens on the following ports:

- `:8000` on which Kong listens for incoming HTTP traffic from your
  clients, and forwards it to your upstream services.
- `:8443` on which Kong listens for incoming HTTPS traffic. This port has a
  similar behavior as the `:8000` port, except that it expects HTTPS
  traffic only. This port can be disabled via the configuration file.
- `:8001` on which the [Admin API][API] used to configure Kong listens.
- `:8444` on which the Admin API listens for HTTPS traffic.

## 3. Stop Kong

As needed you can stop the Kong process by issuing the following
[command][CLI]:

```bash
$ kong stop
```

## 4. Reload Kong

Issue the following command to [reload][CLI] Kong without downtime:

```bash
$ kong reload
```

## Next Steps

Now that you have Kong running you can interact with the Admin API.

To begin, go to [Configuring a Service &rsaquo;][configuring-a-service]

[configuration-loading]: /{{page.kong_version}}/configuration/#configuration-loading
[CLI]: /{{page.kong_version}}/cli
[API]: /{{page.kong_version}}/admin-api
[datastore-section]: /{{page.kong_version}}/configuration/#datastore-section
[configuring-a-service]: /{{page.kong_version}}/getting-started/configuring-a-service
