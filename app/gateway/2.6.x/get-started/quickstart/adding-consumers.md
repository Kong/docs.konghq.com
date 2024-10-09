---
title: Adding Consumers
---

In the last section, we learned how to add plugins to Kong, in this section
we're going to learn how to add consumers to your Kong instances. Consumers are
associated to individuals using your Service, and can be used for tracking, access
management, and more.

## Before you start

* You have installed and started {{site.base_gateway}}, either through the [Docker quickstart](/gateway/{{page.release}}/get-started/quickstart/) or a more [comprehensive installation](/gateway/{{page.release}}/install-and-run/).
* You have [configured a Service](/gateway/{{page.release}}/get-started/quickstart/configuring-a-service/)
* You have [enabled the key-auth plugin](/gateway/{{page.release}}/get-started/quickstart/enabling-plugins/)

## 1. Create a Consumer through the RESTful API

Lets create a user named `Jason` by issuing the following request:

```bash
curl -i -X POST \
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

**Note:** Kong also accepts a `custom_id` parameter when [creating
consumers][API-consumers] to associate a consumer with your existing user
database.

## 2. Provision key credentials for your Consumer

Now, we can create a key for our recently created consumer `Jason` by
issuing the following request:

```bash
curl -i -X POST \
  --url http://localhost:8001/consumers/Jason/key-auth/ \
  --data 'key=ENTER_KEY_HERE'
```

## 3. Verify that your Consumer credentials are valid

We can now issue the following request to verify that the credentials of
our `Jason` Consumer is valid:

```bash
curl -i -X GET \
  --url http://localhost:8000 \
  --header "Host: example.com" \
  --header "apikey: ENTER_KEY_HERE"
```

## Next Steps

Now that we've covered the basics of adding Services, Routes, Consumers and enabling
Plugins, feel free to read more on Kong in one of the following documents:

- [Configuration file Reference][configuration]
- [CLI Reference][CLI]
- [Proxy Reference][proxy]
- [Admin API Reference][API]
- [Clustering Reference][cluster]

Questions? Issues? Contact us on one of the [Community Channels](https://konghq.com/community/)
for help!

[key-auth]: /hub/kong-inc/key-auth
[API-consumers]: /gateway/{{page.release}}/admin-api#create-consumer
[enabling-plugins]: /gateway/{{page.release}}/get-started/quickstart/enabling-plugins
[configuration]: /gateway/{{page.release}}/reference/configuration
[CLI]: /gateway/{{page.release}}/reference/cli
[proxy]: /gateway/{{page.release}}/reference/proxy
[API]: /gateway/{{page.release}}/admin-api
[cluster]: /gateway/{{page.release}}/reference/clustering
