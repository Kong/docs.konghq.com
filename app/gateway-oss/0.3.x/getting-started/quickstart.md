---
title: 5-minute Quickstart
---

## Introduction

<div class="alert alert-warning">
  <strong>Before you start:</strong> Make sure you've <a href="https://konghq.com/install/">installed Kong</a> &mdash; It should only take a minute!
</div>

In this section, you'll learn how to manage your Kong instance. First we'll have you start Kong giving you access to the RESTful interface to manage your APIs, consumers, and more. Data sent through the RESTful interface is stored in your Cassandra instance or cluster, meaning you **must** have Cassandra running **before** starting Kong.

**Note:** If you haven't already, go ahead and make sure that you have a Kong configuration file located under `/etc/kong/kong.yml` and points to your Cassandra instance or cluster. If you haven't, consult the [configuration reference][configuration] before starting.

## 1. Start Kong.

    Issue the following command to start [kong][CLI]:

    ```bash
    $ kong start
    ```

    **Note:** The CLI also accepts a configuration (`-c <path_to_config>`) option allowing you to point to different configurations.

## 2. Verify that Kong has started successfully

    The previous step runs migrations to prepare the Cassandra keyspace.
    Once these have finished you should see a message (`[OK] Started`) informing you that Kong is running.

    By default Kong listens on the following ports:

    `:8000` - Proxy layer for API requests

    `:8001` - [RESTful Admin API][API] for configuration

## 3. Stop Kong.

    As needed you can stop the [kong][CLI] process by issuing the following command:

    ```bash
    $ kong stop
    ```

## 4. Reload Kong.

    Issue the following command to reload [kong][CLI] without downtime:

    ```bash
    $ kong reload
    ```

## Next Steps

Now that you have Kong running you can interact with the RESTful API.

To begin, go to [Adding your API &rsaquo;][adding-your-api]

[CLI]: /{{page.kong_version}}/cli
[API]: /{{page.kong_version}}/admin-api
[configuration]: /{{page.kong_version}}/configuration
[adding-your-api]: /{{page.kong_version}}/getting-started/adding-your-api
