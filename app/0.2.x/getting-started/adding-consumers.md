---
title: Adding Consumers
---

# Adding Consumers

<div class="alert alert-warning">
  <strong>Before you start:</strong>
  <ol>
    <li>Make sure you've <a href="https://konghq.com/install/">installed Kong</a> &mdash; It should only take a minute!</li>
    <li>Make sure you've <a href="/{{page.kong_version}}/getting-started/quickstart">started Kong</a>.</li>
    <li>Also, make sure you've <a href="/{{page.kong_version}}/getting-started/adding-your-api">added your API to Kong</a>.</li>
  </ol>
</div>

In the last section, we learned how to add plugins to Kong, in this section we're going to learn how to add consumers to your Kong instances. Consumers are associated to individuals using your API, and can be used for tracking, access management, and more.

**Note:** This section assumes you have [enabled][enabling-plugins] the [keyauth][keyauth] plugin. If you haven't, you can either [enable the plugin][enabling-plugins] or skip steps two and three.

1. ### Create a Consumer through the RESTful API

    Lets create a user named `Jason` by issuing the following request:

    ```bash
    $ curl -i -X POST \
      --url http://localhost:8001/consumers/ \
      --data "username=Jason"
    ```

    You should see a response similar to the one below:

    ```http
    HTTP/1.1 201 Created
    Content-Type: application/json
    Connection: keep-alive

    {
      "username": "Jason",
      "created_at": 1428555626000,
      "id": "bbdf1c48-19dc-4ab7-cae0-ff4f59d87dc9"
    }
    ```

    Congratulations! You've just added your first consumer to Kong.

    **Note:** Kong also accepts a `consumer_id` parameter when [creating consumers][API-consumers] to associate a consumer with your existing user database.

2. ### Provision key credentials for your Consumer

    Now, we can create a key for our recently created consumer `Jason` by issuing the following request with the Consumer `id` from our previous request:

    ```bash
    $ curl -i -X POST \
      --url http://localhost:8001/keyauth_credentials/ \
      --data 'key=ENTER_KEY_HERE' \
      --data 'consumer_id=bbdf1c48-19dc-4ab7-cae0-ff4f59d87dc9'
    ```

3. ### Verify that your Consumer credentials are valid

    Using the `id` of the Consumer we just created we can issue the following request to verify that the credentials of our Consumer is valid:

    ```bash
    $ curl -i -X GET \
      --url http://localhost:8000 \
      --header "Host: mockbin.com" \
      --header "apikey: ENTER_KEY_HERE"
    ```

### Next Steps

Now that we've covered the basics of creating consumers, enabling plugins, and adding apis you can start giving out access and sharing your API.

[mockbin]: https://mockbin.com
[CLI]: /{{page.kong_version}}/cli
[API]: /{{page.kong_version}}/admin-api
[API-consumers]: /{{page.kong_version}}/admin-api#create-consumer
[keyauth]: /plugins/key-authentication
[configuration]: /{{page.kong_version}}/configuration
[migrations]: /{{page.kong_version}}/migrations
[quickstart]: /{{page.kong_version}}/getting-started/quickstart
[enabling-plugins]: /{{page.kong_version}}/getting-started/enabling-plugins
[adding-consumers]: /{{page.kong_version}}/getting-started/adding-consumers
